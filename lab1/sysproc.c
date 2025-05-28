#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int gethistory();

int sys_gethistory(void)
{
  return gethistory(); // Call the helper function in `proc.c`
}

int sys_block(int syscall_id)
{
  struct proc *p = myproc(); // Get current process

  int num;
  if (argint(0, &num) < 0) // Get argument from user space
    return -1;

  p->syscall_bitmask[num]=1;
  return 0;
}

int sys_unblock(int syscall_id)
{
  struct proc *p = myproc(); // Get current process

  int num;
  if (argint(0, &num) < 0) // Get argument from user space
    return -1;

    p->syscall_bitmask[num]=0;
  return 0;
}

int sys_realsh(void)
{
  struct proc *p = myproc(); // Get current process

  int new_value;
  if (argint(0, &new_value) < 0) // Get argument from user space
    return -1;

  p->real_sh = new_value; // Modify process attribute
  return 0;
}

int sys_allzeroes(void)
{
  struct proc *p = myproc(); // Get current process
  for(int i=0;i<22;i++)
  {
    p->syscall_bitmask[i]=0; // Modify process attribute
  }
  return 0;
}


int sys_fork(void)
{
  return fork();
}

int sys_exit(void)
{
  exit();
  return 0; // not reached
}

int sys_wait(void)
{
  return wait();
}

int sys_kill(void)
{
  int pid;

  if (argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int sys_getpid(void)
{
  return myproc()->pid;
}

int sys_sbrk(void)
{
  int addr;
  int n;

  if (argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

int sys_sleep(void)
{
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (myproc()->killed)
    {
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
int sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
