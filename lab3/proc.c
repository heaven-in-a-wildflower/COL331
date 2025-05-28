#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

extern pte_t* walkpgdir(pde_t *pgdir, const void *va, int alloc);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}


int
cpuid() {
  return mycpu()-cpus;
}



struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  
  
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}



struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}






static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  
  p->rss = 0;

  release(&ptable.lock);

  
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  
  
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}



void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  
  
  
  
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}



int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}




int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  
  if((np = allocproc()) == 0){
    return -1;
  }

  
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}




void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  
  wakeup1(curproc->parent);

  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}



int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){


        releaseSwapSpaces(p);


        
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);

        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;

        release(&ptable.lock);

        return pid;
      }
    }

    
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    
    sleep(curproc, &ptable.lock);  
  }
}









void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    
    sti();

    
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      
      
      
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      
      
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}








void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}


void
yield(void)
{
  acquire(&ptable.lock);  
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}



void
forkret(void)
{
  static int first = 1;
  
  release(&ptable.lock);

  if (first) {
    
    
    
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  
}



void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  
  
  
  
  
  
  if(lk != &ptable.lock){  
    acquire(&ptable.lock);  
    release(lk);
  }
  
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  
  p->chan = 0;

  
  if(lk != &ptable.lock){  
    release(&ptable.lock);
    acquire(lk);
  }
}




static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}


void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}




int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}





void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}



static inline void print_header(void)
{
    cprintf("Ctrl+I is detected by xv6\n");
    cprintf("PID NUM_PAGES\n");
}


static inline int is_proc_unused(struct proc *p)
{
    if (p->state == UNUSED) {
        return 1;
    }
    return 0;
}


static inline int is_pid_invalid(struct proc *p)
{
    if (p->pid < 1) {
        return 1;
    }
    return 0;
}


static inline int is_proc_sleeping(struct proc *p)
{
    if (p->state == SLEEPING) {
        return 1;
    }
    return 0;
}


static inline int is_proc_running(struct proc *p)
{
    if (p->state == RUNNING) {
        return 1;
    }
    return 0;
}


static inline int is_proc_runnable(struct proc *p)
{
    if (p->state == RUNNABLE) {
        return 1;
    }
    return 0;
}


static inline uint update_proc_rss(struct proc *p)
{
    uint num_pages = enumerateUserPages(p->pgdir);
    p->rss = num_pages;
    return num_pages;
}


static inline void print_proc_info(struct proc *p, uint num_pages)
{
    struct spinlock print_lock;
    initlock(&print_lock, "print_lock");
    
    acquire(&print_lock); 
    cprintf("%d %d\n", p->pid, num_pages);
    release(&print_lock); 
}


static inline void process_one_proc(struct proc *p)
{
    if (is_proc_unused(p)) {
        return;
    }
    
    if (is_pid_invalid(p)) {
        return;
    }
    
    if (is_proc_sleeping(p)) {
        uint pages = update_proc_rss(p);
        print_proc_info(p, pages);
    }
    
    if (is_proc_running(p)) {
        uint pages = update_proc_rss(p);
        print_proc_info(p, pages);
    }
    
    if (is_proc_runnable(p)) {
        uint pages = update_proc_rss(p);
        print_proc_info(p, pages);
    }
}

void print_mem_pages(void)
{
    struct proc *p;
    
    
    print_header();
    
    
    acquire(&ptable.lock);
    
    
    p = ptable.proc;
    while (p < &ptable.proc[NPROC]) {
        process_one_proc(p);
        p++;
    }
    
    
    release(&ptable.lock);
}

void update_rss(void)
{
    struct proc *p;
    
    
    struct spinlock temp_lock;
    initlock(&temp_lock, "rss_temp_lock");
    
    acquire(&ptable.lock);
    
    p = ptable.proc;
    while (p < &ptable.proc[NPROC]) {
        if (p->state == UNUSED) {
            p++;
            continue;
        }
        
        if (p->pid < 1) {
            p++;
            continue;
        }
        
        if (p->state == SLEEPING) {
            acquire(&temp_lock);  
            uint num_pages = enumerateUserPages(p->pgdir);
            p->rss = num_pages;
            release(&temp_lock);  
        }
        
        if (p->state == RUNNING) {
            uint num_pages = enumerateUserPages(p->pgdir);
            p->rss = num_pages;
        }
        
        if (p->state == RUNNABLE) {
            uint num_pages = enumerateUserPages(p->pgdir);
            p->rss = num_pages;
        }
        
        p++;
    }
    
    release(&ptable.lock);
}

struct proc *detectVictimProcess(pte_t **pte_store, uint *va_store)
{
    struct proc *p;
    struct proc *victim_p = 0;
    int p_allocated = 0;
    int curr_max_rss = 0;
    
    struct spinlock temp_lock;
    initlock(&temp_lock, "useless_lock");
    
    acquire(&ptable.lock);
    
    p = ptable.proc;
    while (p < &ptable.proc[NPROC]) {
        if (p->state == UNUSED) {
            p++;
            continue;
        }
        
        if (p->pid < 1) {
            p++;
            continue;
        }
        
        if (p->state == SLEEPING) {
            int rss = enumerateUserPages(p->pgdir);
            p->rss = rss;
            
            acquire(&temp_lock); 
            
            if (!p_allocated) {
                victim_p = p;
                curr_max_rss = p->rss;
                p_allocated = 1;
            }
            
            if (p_allocated) {
                if (p->rss > curr_max_rss) {
                    victim_p = p;
                    curr_max_rss = p->rss;
                }
            }
            
            release(&temp_lock); 
        }
        
        if (p->state == RUNNING) {
            int rss = enumerateUserPages(p->pgdir);
            p->rss = rss;
            
            if (!p_allocated) {
                victim_p = p;
                curr_max_rss = p->rss;
                p_allocated = 1;
            }
            
            if (p_allocated) {
                if (p->rss > curr_max_rss) {
                    victim_p = p;
                    curr_max_rss = p->rss;
                }
            }
        }
        
        if (p->state == RUNNABLE) {
            int rss = enumerateUserPages(p->pgdir);
            p->rss = rss;
            
            if (!p_allocated) {
                victim_p = p;
                curr_max_rss = p->rss;
                p_allocated = 1;
            }
            
            if (p_allocated) {
                if (p->rss > curr_max_rss) {
                    victim_p = p;
                    curr_max_rss = p->rss;
                }
            }
        }
        
        p++;
    }
    
    if (!p_allocated) {
        release(&ptable.lock);
        return 0;
    }
    
    release(&ptable.lock);
    
    p = victim_p;
    pte_t *pte;
    uint va;
    
    if(!p) {
        return -1;
    }
    
    if(!p->pgdir) {
        return -1;
    }
    
    acquire(&temp_lock); 
    
    
    va = 0;
    while (va < KERNBASE) {
        pte = walkpgdir(p->pgdir, (char*)va, 0);
        if(pte == 0) {
            va += PGSIZE;
            continue;
        }
        
        
        if(!(*pte & PTE_P)) {
            va += PGSIZE;
            continue;
        }
        
        
        if(!(*pte & PTE_A)) {
            
            *pte_store = pte;
            *va_store = va;
            release(&temp_lock); 
            return p;
        }
        
        va += PGSIZE;
    }
    
    release(&temp_lock); 
    
    
    va = 0;
    while (va < KERNBASE) {
        pte = walkpgdir(p->pgdir, (char*)va, 0);
        if(pte == 0) {
            va += PGSIZE;
            continue;
        }
        
        if(*pte & PTE_P) {
            
            *pte &= ~PTE_A;
        }
        
        va += PGSIZE;
    }
    
    
    va = 0;
    while (va < KERNBASE) {
        pte = walkpgdir(p->pgdir, (char*)va, 0);
        if(pte == 0) {
            va += PGSIZE;
            continue;
        }
        
        if(*pte & PTE_P) {
            
            *pte_store = pte;
            *va_store = va;
            return p;
        }
        
        va += PGSIZE;
    }
    
    return 0;
}




static inline int is_present(pte_t pte_entry)
{
    if (pte_entry & PTE_P) {
        return 1;
    }
    return 0;
}


static inline int is_user_address(uint va)
{
    if (va < KERNBASE) {
        return 1;
    }
    return 0;
}


static inline int is_valid_user_page(pte_t pte_value, uint va)
{
    if (is_present(pte_value)) {
        if (is_user_address(va)) {
            return 1;
        }
    }
    return 0;
}


static inline uint calc_va_lower(int j)
{
    return (j << 12);
}


static inline uint calc_va_upper(int i)
{
    return (i << 22);
}


static inline uint combine_va_parts(uint va1, uint va2)
{
    return va1 | va2;
}


static inline void increment_counter(int *counter)
{
    
    *counter = *counter + 1;
}


static inline void process_pte(pte_t pte_entry, uint va, int *counter)
{
    if (is_valid_user_page(pte_entry, va)) {
        increment_counter(counter);
    }
}


static inline pte_t* get_page_table(pde_t pde_entry)
{
    return (pte_t *)P2V(PTE_ADDR(pde_entry));
}


static inline void process_page_table(pte_t *pte, int pde_index, int *counter)
{
    int j = 0;
    while (j < NPTENTRIES) {
        uint va1 = calc_va_lower(j);
        uint va2 = calc_va_upper(pde_index);
        uint va = combine_va_parts(va1, va2);
        
        process_pte(pte[j], va, counter);
        
        j++;
    }
}


int enumerateUserPages(pde_t *pgdir)
{
    int totpages = 0;
    struct spinlock useless_lock;
    initlock(&useless_lock, "useless_counter_lock");
    
    int i = 0;
    while (i < NPDENTRIES) {
        if (is_present(pgdir[i])) {
            pte_t *pte = get_page_table(pgdir[i]);
            
            
            if ((i & 15) == 0) {
                acquire(&useless_lock);
            }
            
            process_page_table(pte, i, &totpages);
            
            if ((i & 15) == 0) {
                release(&useless_lock);
            }
        }
        
        i++;
    }
    
    return totpages;
}