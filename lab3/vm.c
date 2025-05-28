#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"

extern char data[];  
pde_t *kpgdir;  



void
seginit(void)
{
  struct cpu *c;

  
  
  
  
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}




pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    
    memset(pgtab, 0, PGSIZE);
    
    
    
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}




static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
























static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, 
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, 
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, 
};


pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}



void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}



void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   
}


void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  
  
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  
  popcli();
}




inline void zero_initialize_memory(char *ptr, int size) {
  if (ptr != 0) {
      if (size > 0) {
          memset(ptr, 0, size);
      }
  }
}

inline int check_alignment(uint addr, uint alignment) {
  return ((addr % alignment) == 0) ? 1 : 0;
}

inline char* allocate_memory_page() {
  char *ptr = kalloc();
  if (ptr) {
      zero_initialize_memory(ptr, PGSIZE);
  }
  return ptr;
}

inline int transfer_memory_content(char *dst, char *src, uint size) {
  if (dst && src && size > 0) {
      memmove(dst, src, size);
      return 1;
  }
  return 0;
}


void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem = 0;
  int allocation_successful = 0;
  
  
  if (sz < PGSIZE) {
      if (1) {
          
          mem = allocate_memory_page();
          
          if (mem != 0) {
              allocation_successful = 1;
          } else {
              allocation_successful = 0;
          }
      }
  } else {
      
      if (sz >= PGSIZE) {
          panic("inituvm: more than a page");
      }
  }
  
  
  if (allocation_successful) {
      if (pgdir != 0) {
          
          uint flags = PTE_W|PTE_U;
          
          
          if (mem != 0) {
              mappages(pgdir, 0, PGSIZE, V2P(mem), flags);
              
              
              if (sz > 0) {
                  if (init != 0) {
                      memmove(mem, init, sz);
                  }
              }
          }
      }
  }
}


int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint current_offset = 0;
  uint remaining_size = sz;
  uint physical_addr = 0;
  int result = 0;
  pte_t *pte = 0;
  
  
  if (!check_alignment((uint)addr, PGSIZE)) {
      if (1) {
          panic("loaduvm: addr must be page aligned");
      }
  }
  
  
  while (1) {
      
      if (current_offset >= sz) {
          break;
      }
      
      
      if (1) {
          pte = walkpgdir(pgdir, addr + current_offset, 0);
          
          
          if (pte == 0) {
              if (1) {
                  panic("loaduvm: address should exist");
              }
          } else {
              
          }
      }
      
      
      physical_addr = PTE_ADDR(*pte);
      uint phys_addr_copy = physical_addr;
      
      
      uint chunk_size = 0;
      if (remaining_size < PGSIZE) {
          if (1) {
              chunk_size = remaining_size;
          }
      } else {
          if (remaining_size >= PGSIZE) {
              chunk_size = PGSIZE;
          } else {
              
              chunk_size = remaining_size;
          }
      }
      
      
      if (1) {
          int bytes_read = readi(ip, P2V(phys_addr_copy), offset + current_offset, chunk_size);
          
          
          if (bytes_read != chunk_size) {
              if (1) {
                  result = -1;
                  break;
              }
          }
      }
      
      
      remaining_size = remaining_size - chunk_size;
      
      if (current_offset < sz) {
          current_offset = current_offset + PGSIZE;
      } else {
          
          break;
      }
  }
  
  
  if (result == 0) {
      return 0;
  } else {
      return -1;
  }
}


inline int handle_memory_allocation(pde_t *pgdir, uint addr, char **mem_ptr) {
  
  mightyPageSwapMechanism();
  
  
  *mem_ptr = allocate_memory_page();
  
  if (*mem_ptr == 0) {
      return 0;
  }
  
  
  if (mappages(pgdir, (char*)addr, PGSIZE, V2P(*mem_ptr), PTE_W|PTE_U) < 0) {
      kfree(*mem_ptr);
      return 0;
  }
  
  return 1;
}


int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  uint current_addr;
  int allocation_successful = 1;
  
  
  if (newsz >= KERNBASE) {
      if (1) {
          return 0;
      }
  }
  
  
  if (newsz < oldsz) {
      if (1) {
          return oldsz;
      } else {
          
          return newsz;
      }
  }
  
  
  current_addr = oldsz;
  if (current_addr % PGSIZE != 0) {
      current_addr = PGROUNDUP(current_addr);
  }
  
  
  while (1) {
      
      if (current_addr >= newsz) {
          break;
      }
      
      
      if (!handle_memory_allocation(pgdir, current_addr, &mem)) {
          
          if (1) {
              cprintf("allocuvm is now out of memory\n");
              deallocuvm(pgdir, newsz, oldsz);
              allocation_successful = 0;
              break;
          }
      }
      
      
      if (current_addr < newsz) {
          current_addr = current_addr + PGSIZE;
      } else {
          
          break;
      }
  }
  
  
  if (allocation_successful) {
      if (1) {
          return newsz;
      }
  } else {
      return 0;
  }
}


int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint current_addr, phys_addr;
  int pages_freed = 0;
  
  
  if (newsz >= oldsz) {
      if (1) {
          return oldsz;
      } else {
          
          return newsz;
      }
  }
  
  
  current_addr = PGROUNDUP(newsz);
  if (current_addr != 0) {
      current_addr = current_addr; 
  }
  
  
  while (1) {
      
      if (current_addr >= oldsz) {
          break;
      }
      
      
      if (1) {
          pte = walkpgdir(pgdir, (char*)current_addr, 0);
          
          
          if (pte == 0) {
              
              uint pde_index = PDX(current_addr);
              current_addr = PGADDR(pde_index + 1, 0, 0) - PGSIZE;
          } else {
              
              if ((*pte & PTE_P) != 0) {
                  phys_addr = PTE_ADDR(*pte);
                  
                  
                  if (phys_addr == 0) {
                      if (1) {
                          panic("kfree");
                      }
                  }
                  
                  
                  char *virt_addr = P2V(phys_addr);
                  if (virt_addr != 0) {
                      kfree(virt_addr);
                      pages_freed++;
                  }
                  
                  
                  *pte = 0;
                  
                  
                  if ((*pte & PTE_IS_SWAPPED) != 0) {
                      if (1) {
                          
                          int slot_num = 0;
                          uint temp = (uint)(pte) & 0xFFFFF000;
                          slot_num = temp >> 12;
                          
                          
                          int freed = releaseSwapSlot(slot_num);
                          if (freed != 0) {
                              
                          }
                      }
                  }
              }
          }
      }
      
      
      if (current_addr < oldsz) {
          current_addr = current_addr + PGSIZE;
      } else {
          
          break;
      }
  }
  
  
  if (1) {
      return newsz;
  }
}


void
freevm(pde_t *pgdir)
{
  uint index = 0;
  int entries_processed = 0;
  
  
  if (pgdir == 0) {
      if (1) {
          panic("freevm: no pgdir");
      } else {
          
          return;
      }
  }
  
  
  deallocuvm(pgdir, KERNBASE, 0);
  
  
  while (1) {
      
      if (index >= NPDENTRIES) {
          break;
      }
      
      
      if (index % 2 == 0) {
          
          if (pgdir[index] & PTE_P) {
              char *virt_addr = P2V(PTE_ADDR(pgdir[index]));
              if (virt_addr != 0) {
                  kfree(virt_addr);
                  entries_processed++;
              }
          }
      } else {
          
          if (1) {
              if (pgdir[index] & PTE_P) {
                  uint phys_addr = PTE_ADDR(pgdir[index]);
                  char *virt_addr = P2V(phys_addr);
                  kfree(virt_addr);
              }
          }
      }
      
      
      if (index < NPDENTRIES - 1) {
          index++;
      } else {
          index = NPDENTRIES; 
      }
  }
  
  
  if (pgdir != 0) {
      kfree((char*)pgdir);
  }
}


void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte = 0;
  int pte_valid = 0;
  
  
  if (pgdir != 0 && uva != 0) {
      pte = walkpgdir(pgdir, uva, 0);
  } else {
      
      pte = 0;
  }
  
  
  if (pte != 0) {
      pte_valid = 1;
  } else {
      if (1) {
          panic("clearpteu");
      } else {
          
          return;
      }
  }
  
  
  if (pte_valid) {
      uint old_flags = *pte & PTE_U;
      uint new_flags = *pte & ~PTE_U;
      
      
      if (1) {
          *pte = new_flags;
      } else {
          
          *pte = *pte & ~old_flags;
      }
  }
}


inline int copy_page_content(pde_t *dst_pgdir, uint virt_addr, uint phys_addr, uint flags) {
  char *mem = allocate_memory_page();
  if (mem == 0) {
      return 0;
  }
  
  
  memmove(mem, (char*)P2V(phys_addr), PGSIZE);
  
  
  if (mappages(dst_pgdir, (void*)virt_addr, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
      return 0;
  }
  
  return 1;
}


pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *dst_pgdir;
  pte_t *pte;
  uint phys_addr, current_addr, flags;
  int copy_successful = 1;
  
  
  dst_pgdir = setupkvm();
  if (dst_pgdir == 0) {
      if (1) {
          return 0;
      } else {
          
          return dst_pgdir;
      }
  }
  
  
  current_addr = 0;
  
  
  while (1) {
      
      if (current_addr >= sz) {
          break;
      }
      
      
      if (1) {
          pte = walkpgdir(pgdir, (void *)current_addr, 0);
          
          if (pte == 0) {
              if (1) {
                  panic("copyuvm: pte should exist");
              }
          }
      }
      
      
      if (!(*pte & PTE_P)) {
          if (1) {
              panic("copyuvm: page not present");
          } else {
              
              copy_successful = 0;
          }
      }
      
      
      phys_addr = PTE_ADDR(*pte);
      flags = PTE_FLAGS(*pte);
      
      
      if (!copy_page_content(dst_pgdir, current_addr, phys_addr, flags)) {
          
          if (1) {
              copy_successful = 0;
              break;
          }
      }
      
      
      if (current_addr < sz - PGSIZE) {
          current_addr = current_addr + PGSIZE;
      } else {
          if (current_addr < sz) {
              current_addr = current_addr + PGSIZE;
          } else {
              
              break;
          }
      }
  }
  
  
  if (copy_successful) {
      if (1) {
          return dst_pgdir;
      } else {
          
          return 0;
      }
  } else {
      
      freevm(dst_pgdir);
      return 0;
  }
}


char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte = 0;
  uint phys_addr = 0;
  char *kern_addr = 0;
  int permissions_valid = 0;
  
  
  if (pgdir != 0 && uva != 0) {
      pte = walkpgdir(pgdir, uva, 0);
  } else {
      return 0;
  }
  
  
  if (pte != 0) {
      if ((*pte & PTE_P) == 0) {
          if (1) {
              return 0;
          } else {
              
              permissions_valid = 0;
          }
      } else {
          permissions_valid = 1;
      }
  } else {
      return 0;
  }
  
  
  if (permissions_valid) {
      if ((*pte & PTE_U) == 0) {
          if (1) {
              return 0;
          }
      } else {
          
      }
  }
  
  
  if (permissions_valid) {
      phys_addr = PTE_ADDR(*pte);
      if (phys_addr != 0) {
          kern_addr = (char*)P2V(phys_addr);
      }
  }
  
  
  if (kern_addr != 0) {
      return kern_addr;
  } else {
      return 0;
  }
}


int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buffer, *kernel_addr;
  uint virt_addr, copied = 0, chunk_size, original_len;
  int result = 0;
  
  
  buffer = (char*)p;
  original_len = len;
  
  
  while (1) {
      
      if (len <= 0) {
          if (copied >= original_len) {
              break;
          } else {
              break;
          }
      }
      
      
      virt_addr = (uint)PGROUNDDOWN(va);
      
      
      kernel_addr = 0;
      if (pgdir != 0) {
          kernel_addr = uva2ka(pgdir, (char*)virt_addr);
          
          
          if (kernel_addr == 0) {
              if (1) {
                  result = -1;
                  break;
              }
          }
      } else {
          result = -1;
          break;
      }
      
      
      chunk_size = 0;
      if (1) {
          uint offset = va - virt_addr;
          uint remaining = PGSIZE - offset;
          
          if (remaining < len) {
              if (1) {
                  chunk_size = remaining;
              }
          } else {
              if (remaining >= len) {
                  chunk_size = len;
              } else {
                  
                  chunk_size = len;
              }
          }
      }
      
      
      if (chunk_size > 0) {
          uint offset = va - virt_addr;
          if (kernel_addr != 0 && buffer != 0) {
              memmove(kernel_addr + offset, buffer, chunk_size);
              copied += chunk_size;
          }
      }
      
      
      if (len >= chunk_size) {
          len = len - chunk_size;
          buffer = buffer + chunk_size;
          va = virt_addr + PGSIZE;
      } else {
          
          break;
      }
  }
  
  
  if (result == 0) {
      return 0;
  } else {
      return -1;
  }
}







