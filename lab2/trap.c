#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

#define FAKE_RETURN_ADDR 0xFFFFFFFF

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
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

//PAGEBREAK: 41
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

    // Handle ticks
    struct proc *p = myproc();
    if (p && p->state == RUNNING)
    {
      if (p->exec_time != -1)
      {
        p->ticks_used++;
        if (p->ticks_used >= p->exec_time)
        {
          p->killed = 1;
        }
      }
    }
    
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
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

  //PAGEBREAK: 13
  default:
    if(tf->eip == FAKE_RETURN_ADDR && (tf->cs&3) == DPL_USER){
        memmove(myproc()->tf, myproc()->tf_backup, sizeof(struct trapframe));
        if(myproc()->tf_backup){
            kfree((char*)myproc()->tf_backup);
            myproc()->tf_backup = 0;
        }
        // cprintf("After restoring:\n");
        // cprintf("eip: 0x%x esp: 0x%x eflags: 0x%x\n", myproc()->tf->eip, myproc()->tf->esp, myproc()->tf->eflags);
        // cprintf("eax: 0x%x ebx: 0x%x ecx: 0x%x edx: 0x%x\n", myproc()->tf->eax, myproc()->tf->ebx, myproc()->tf->ecx, myproc()->tf->edx);
        // cprintf("ebp: 0x%x oesp: 0x%x esi: 0x%x edi: 0x%x\n", myproc()->tf->ebp, myproc()->tf->oesp, myproc()->tf->esi, myproc()->tf->edi);
        return;
    }

    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  if(myproc() && myproc()->call_handler == 1 && myproc()->signal_handler && (tf->cs&3) == DPL_USER){
      myproc()->call_handler = 0;
      if(myproc()->tf_backup == 0){
          myproc()->tf_backup = (struct trapframe*)kalloc();
          if(myproc()->tf_backup == 0){
              panic("tf_backup: out of memory");
          }
      }
      memmove(myproc()->tf_backup, tf, sizeof(struct trapframe));
      // cprintf("Before running:\n");
      // cprintf("eip: 0x%x esp: 0x%x eflags: 0x%x\n", myproc()->tf->eip, myproc()->tf->esp, myproc()->tf->eflags);
      // cprintf("eax: 0x%x ebx: 0x%x ecx: 0x%x edx: 0x%x\n", myproc()->tf->eax, myproc()->tf->ebx, myproc()->tf->ecx, myproc()->tf->edx);
      // cprintf("ebp: 0x%x oesp: 0x%x esi: 0x%x edi: 0x%x\n", myproc()->tf->ebp, myproc()->tf->oesp, myproc()->tf->esi, myproc()->tf->edi);

      myproc()->tf->esp -= 4;
      *(uint*)myproc()->tf->esp = FAKE_RETURN_ADDR;

      myproc()->tf->eip = (uint)myproc()->signal_handler;
      return;
  }

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER){
    yield();
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
