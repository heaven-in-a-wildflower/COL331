#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

// void add_to_history(const char *name, int pid);

int exec(char *path, char **argv)
{
  char *s, *last;
  int i, off;
  uint argc, sz, sp, ustack[3 + MAXARG + 1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
  int bad_flag = 0;

  begin_op();
  curproc->exec_failed=0;


  if ((ip = namei(path)) == 0)
  {
    cprintf("bakchodi\n");
    curproc->exec_failed=1;
    // cprintf("%d->exec_failed=%d\n",curproc->pid,curproc->exec_failed);
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if (readi(ip, (char *)&elf, 0, sizeof(elf)) != sizeof(elf))
  {
    goto bad;
    bad_flag = 1;
  }

  if (elf.magic != ELF_MAGIC)
  {
    goto bad;
    bad_flag = 1;
  }

  if ((pgdir = setupkvm()) == 0)
  {
    goto bad;
    bad_flag = 1;
  }

  // Load program into memory.
  sz = 0;
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
  {
    if (readi(ip, (char *)&ph, off, sizeof(ph)) != sizeof(ph))
    {
      goto bad;
      bad_flag = 1;
    }

    if (ph.type != ELF_PROG_LOAD)
      continue;
    if (ph.memsz < ph.filesz)
    {
      goto bad;
      bad_flag = 1;
    }

    if (ph.vaddr + ph.memsz < ph.vaddr)
    {
      goto bad;
      bad_flag = 1;
    }
    if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
    {
      goto bad;
      bad_flag = 1;
    }

    if (ph.vaddr % PGSIZE != 0)
    {
      goto bad;
      bad_flag = 1;
    }

    if (loaduvm(pgdir, (char *)ph.vaddr, ip, ph.off, ph.filesz) < 0)
    {
      goto bad;
      bad_flag = 1;
    }
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
  {
    goto bad;
    bad_flag = 1;
  }

  clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for (argc = 0; argv[argc]; argc++)
  {
    if (argc >= MAXARG)
    {
      goto bad;
      bad_flag = 1;
    }

    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    {
      goto bad;
      bad_flag = 1;
    }

    ustack[3 + argc] = sp;
  }
  ustack[3 + argc] = 0;

  ustack[0] = 0xffffffff; // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc + 1) * 4; // argv pointer

  sp -= (3 + argc + 1) * 4;
  if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
  {
    goto bad;
    bad_flag = 1;
  }

  // Save program name for debugging.
  for (last = s = path; *s; s++)
    if (*s == '/')
      last = s + 1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry; // main
  curproc->tf->esp = sp;
  switchuvm(curproc);
  freevm(oldpgdir);
  // cprintf("Sanity: %s (PID: %d, Size: %d)\n",
          // curproc->name, curproc->pid, curproc->sz);
  
  cprintf("%d->exec_failed=%d",curproc->pid,curproc->exec_failed);
  return 0;

bad:
  curproc->exec_failed=1;
  if (pgdir)
    freevm(pgdir);
  if (ip)
  {
    iunlockput(ip);
    end_op();
  }
  return -1;
}
