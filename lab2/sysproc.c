#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

// Declare ptable as extern (defined in proc.c)
extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

int sys_custom_fork()
{
  int start_later, exec_time;
  if(argint(0,&start_later)<0 || argint(0,&exec_time)<0)
  {
    return -1;
  }
  return custom_fork(start_later,exec_time);
}

// sysproc.c
int sys_scheduler_start(void) {
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->state == HOLDING) {
      setprocstate(p,RUNNABLE);
    }
  }
  release(&ptable.lock);
  return 0;
}

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_sigstop(void)
{
  sigstop();
  return 0;
}

int
sys_sigcont(void)
{
  sigcont();
  return 0;
}

int
sys_shell_status(void)
{
  return shell_status();
}

int
sys_sigkill(void)
{
  sigkill();
  return 0;
}

int
sys_signal(void) {
    sighandler_t handler;
    if (argptr(0, (void*)&handler, sizeof(handler)) < 0) return -1;
    if ((uint)handler >= KERNBASE)  return -1;
    // cprintf("Registering signal handler at address: %p\n", handler);
    myproc()->signal_handler = handler;
    return 0;
}

int
sys_sigcustom(void)
{
  sigcustom();
  return 0;
}
