#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "syscall.h"

// User code makes a system call with INT T_SYSCALL.
// System call number in %eax.
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if (addr >= curproc->sz || addr + 4 > curproc->sz)
    return -1;
  *ip = *(int *)(addr);
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if (addr >= curproc->sz)
    return -1;
  *pp = (char *)addr;
  ep = (char *)curproc->sz;
  for (s = *pp; s < ep; s++)
  {
    if (*s == 0)
      return s - *pp;
  }
  return -1;
}

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
}

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size)
{
  int i;
  struct proc *curproc = myproc();

  if (argint(n, &i) < 0)
    return -1;
  if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz)
    return -1;
  *pp = (char *)i;
  return 0;
}

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp)
{
  int addr;
  if (argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}

extern int sys_chdir(void);
extern int sys_close(void);
extern int sys_dup(void);
extern int sys_exec(void);
extern int sys_exit(void);
extern int sys_fork(void);
extern int sys_fstat(void);
extern int sys_getpid(void);
extern int sys_kill(void);
extern int sys_link(void);
extern int sys_mkdir(void);
extern int sys_mknod(void);
extern int sys_open(void);
extern int sys_pipe(void);
extern int sys_read(void);
extern int sys_sbrk(void);
extern int sys_sleep(void);
extern int sys_unlink(void);
extern int sys_wait(void);
extern int sys_write(void);
extern int sys_uptime(void);
extern int sys_gethistory(void);
extern int sys_block(int);
extern int sys_unblock(int);
extern int sys_realsh(int);
extern int sys_chmod(const char*,int);

static int (*syscalls[])(void) = {
    [SYS_fork] sys_fork,
    [SYS_exit] sys_exit,
    [SYS_wait] sys_wait,
    [SYS_pipe] sys_pipe,
    [SYS_read] sys_read,
    [SYS_kill] sys_kill,
    [SYS_exec] sys_exec,
    [SYS_fstat] sys_fstat,
    [SYS_chdir] sys_chdir,
    [SYS_dup] sys_dup,
    [SYS_getpid] sys_getpid,
    [SYS_sbrk] sys_sbrk,
    [SYS_sleep] sys_sleep,
    [SYS_uptime] sys_uptime,
    [SYS_open] sys_open,
    [SYS_write] sys_write,
    [SYS_mknod] sys_mknod,
    [SYS_unlink] sys_unlink,
    [SYS_link] sys_link,
    [SYS_mkdir] sys_mkdir,
    [SYS_close] sys_close,
    [SYS_gethistory] sys_gethistory,
    [SYS_block] sys_block,
    [SYS_unblock] sys_unblock,
    [SYS_chmod] sys_chmod,
    [SYS_realsh] sys_realsh,
};

void syscall(void)
{
  int num;
  struct proc *curproc = myproc();
  num = curproc->tf->eax;

  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
  {
    if (curproc->pid <= 2)
    {
      curproc->tf->eax = syscalls[num]();
    }
    if (curproc->pid > 2) // Ignore init/system processes
    {
      int bit = curproc->parent->syscall_bitmask[num];

      if (num == 7)
      {
        int is_bit_set_in_ancestors_except_parent = 0;
        struct proc *p = myproc();
        p = p->parent;
        if (num == 7)
        {
          cprintf("curproc->pid=%d\n", myproc()->pid);
          cprintf("curproc->parent->pid=%d\n", myproc()->parent->pid);
        }
        while (p->parent->pid != 1)
        {
          cprintf("p->pid=%d\n", p->pid);
          if (p->parent->syscall_bitmask[num] == 1)
          {
            is_bit_set_in_ancestors_except_parent = 1;
            break;
          }
          p = p->parent;
        }
        if ((curproc->real_sh != 2) && (is_bit_set_in_ancestors_except_parent == 0)) // Proper precedence
        {
          curproc->tf->eax = syscalls[num](); // Allow

          if (num != 5 && num != 16)
          {
            cprintf("name==%s\n", curproc->name);
            // cprintf("sys_bit[%d]=%d\n", num, bit);
            // cprintf("real_sh=%d\n", curproc->real_sh);
            cprintf("ancestral=%d\n\n", is_bit_set_in_ancestors_except_parent);
          }
        }
        else if (curproc->real_sh == 2)
        {
          curproc->tf->eax = syscalls[num](); // Allow
        }
        else
        {
          cprintf("Syscall %d blocked for PID %d\n", num, curproc->pid);
          curproc->tf->eax = -1; // Return error to indicate syscall is blocked
        }
      }
      else
      {
        if (bit == 0)
        {
          curproc->tf->eax = syscalls[num]();
        }
        else
        {
          cprintf("Syscall %d blocked for PID %d\n", num, curproc->pid);
          curproc->tf->eax = -1; // Return error to indicate syscall is blocked
        }
      }
    }
  }
}
