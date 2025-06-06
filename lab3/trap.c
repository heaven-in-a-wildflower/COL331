#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

extern pte_t* walkpgdir(pde_t *pgdir, const void *va, int alloc);
extern int swapInAPage(struct proc *p, pte_t *pte, uint va);


struct gatedesc idt[256];
extern uint vectors[];  
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}


void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;

    

  case T_PGFLT:

  if(myproc() == 0 || (tf->cs & 3) == 0) {
    // cprintf("kernel page fault hua hai at va %x ip %x\n", rcr2(), tf->eip);
    // panic("kernel page fault damn");
  }

      uint va = PGROUNDDOWN(rcr2());

      pte_t *pte = walkpgdir(myproc()->pgdir, (char *)va, 0);

      if (*pte & PTE_P)
      {
          // cprintf("in a trap: invalid access at address %d\n", va);
          myproc()->killed = 1;
      }
      else if (swapInAPage(myproc(), pte, va) < 0)
      {
          // cprintf("oh damn again trap: page fault failed to swap in page\n");
          myproc()->killed = 1;
      }
      else
      {
        
        
        // cprintf("swapped in successfully\n");
      }
      break;

  case T_IRQ0 + IRQ_IDE+1:
    
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  
  
  
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  
  
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
