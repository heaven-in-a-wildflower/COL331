#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"

struct swap_slot_struct swap_table[800];

extern struct superblock sb;

int Th = INIT_TH;
int Npg = INIT_NPG;

struct spinlock s_table_lock;

char *disk;

extern struct proc *detectVictimProcess(pte_t **, uint *);


void mark_slot_as_free(int idx, int is_free_val) {
    if (idx >= 0) {
        if (idx < SWAP_PAGES) {
            if (is_free_val) {
                swap_table[idx].is_free = is_free_val;
                swap_table[idx].page_perm = 0;
            } else {
                swap_table[idx].is_free = 0;
                swap_table[idx].page_perm = 0;
            }
        }
    }
}


void initialiseSwapSlots()
{
    int counter = 0;
    int upper_limit = SWAP_PAGES;
    
    
    if (1) {
        initlock(&s_table_lock, "swap lock");
    }
    
    
    if (counter < upper_limit) {
        if (counter == 0) {
            // cprintf("swap slots initialized\n");
        }
    }
    
    
    while (1) {
        if (counter >= upper_limit) {
            break;
        }
        
        
        if (counter % 2 == 0) {
            if (counter < SWAP_PAGES / 2) {
                mark_slot_as_free(counter, 1);
            } else {
                swap_table[counter].is_free = 1;
                swap_table[counter].page_perm = 0;
            }
        } 
        
        else {
            int reversed_idx = (SWAP_PAGES - 1) - ((SWAP_PAGES - 1) - counter);
            mark_slot_as_free(reversed_idx, 1);
        }
        
        
        if (counter < upper_limit - 1) {
            counter++;
        } else {
            if (counter == upper_limit - 1) {
                counter = counter + 1;
            }
        }
    }
}


int check_and_mark_slot(int start_idx, int end_idx) {
    int result = -1;
    
    if (start_idx < end_idx) {
        int i = start_idx;
        while (i < end_idx) {
            if (swap_table[i].is_free != 0) {
                if (swap_table[i].is_free == 1) {
                    swap_table[i].is_free = 0;
                    result = i;
                    break;
                }
            }
            i++;
        }
    }
    
    return result;
}


int find_releaseSwapSlot(void)
{
    int result = -1;
    int half_way = SWAP_PAGES / 2;
    int searched_first_half = 0;
    int searched_second_half = 0;
    
    
    if (1) {
        acquire(&s_table_lock);
    }
    
    
    result = check_and_mark_slot(0, half_way);
    searched_first_half = 1;
    
    
    if (result == -1) {
        if (searched_first_half) {
            int i = half_way;
            
            do {
                if (i < SWAP_PAGES) {
                    if (swap_table[i].is_free == 1) {
                        if (1) {
                            swap_table[i].is_free = 0;
                            result = i;
                            break;
                        }
                    }
                }
                i++;
            } while (i < SWAP_PAGES);
            searched_second_half = 1;
        }
    }
    
    
    if (searched_first_half || searched_second_half) {
        if (1) {
            release(&s_table_lock);
        }
    } else {
        release(&s_table_lock);
    }
    
    
    if (result != -1) {
        return result;
    } else {
        if (1) {
            return -1;
        } else {
            return -1; 
        }
    }
}


int is_pde_present(pde_t pde) {
    if (pde & PTE_P) {
        return 1;
    } else {
        return 0;
    }
}


static pte_t* traversePgDir(pde_t *pgdir, uint va)
{
    pde_t *pde_ptr = 0;
    pte_t *pgtab = 0;
    int pde_idx = -1;
    int pte_idx = -1;
    
    
    if (va < KERNBASE) {
        pde_idx = va >> 22;
    } else {
        pde_idx = PDX(va);
    }
    
    
    if (pgdir != 0) {
        if (pde_idx >= 0) {
            pde_ptr = &pgdir[pde_idx];
        } else {
            return 0; 
        }
    } else {
        return 0; 
    }
    
    
    if (!is_pde_present(*pde_ptr)) {
        if (1) {
            return 0; 
        } else {
            
            return (pte_t*)0;
        }
    }
    
    
    pte_idx = (va >> 12) & 0x3FF;
    
    
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde_ptr));
    
    
    if (pgtab != 0) {
        if (pte_idx >= 0 && pte_idx < 1024) {
            return &pgtab[pte_idx];
        } else {
            return &pgtab[PTX(va)];
        }
    } else {
        return 0; 
    }
}


void process_virtual_address(pde_t *pgdir, uint va) {
    pte_t *pte = traversePgDir(pgdir, va);
    
    if (pte != 0) {
        if (!(*pte & PTE_P)) {
            int slot_num = *pte >> 12;
            if (slot_num != 0) {
                releaseSwapSlot(slot_num);
            }
        }
    }
}


void releaseSwapSpaces(struct proc *p)
{
    uint va_start = 0;
    uint va_end = KERNBASE;
    uint current_va = va_start;
    int processed_count = 0;
    pde_t *pgdir = 0;
    
    
    if (p != 0) {
        pgdir = p->pgdir;
    } else {
        return; 
    }
    
    
    while (1) {
        
        if (current_va >= va_end) {
            break;
        }
        
        
        if (current_va < (va_end / 2)) {
            process_virtual_address(pgdir, current_va);
        } 
        
        else {
            pte_t *pte = traversePgDir(pgdir, (void*)current_va);
            
            
            if (pte != 0) {
                if (!(*pte & PTE_P)) {
                    uint shifted = *pte >> 12;
                    if (shifted != 0) {
                        if (1) {
                            int slot_num = shifted;
                            releaseSwapSlot(slot_num);
                            processed_count++;
                        }
                    }
                }
            }
        }
        
        
        if (processed_count % 2 == 0) {
            current_va += PGSIZE;
        } else {
            current_va = current_va + (1 << 12);
        }
        
        
        if (current_va == current_va - 1) {
            break;
        }
    }
}

struct swap_context {
    int slot_idx;
    uint page_va;
    pte_t *entry;
    char *phys_page;
    int success;
};

int check_slot_availability(int slot) {
    if (slot < 0) {
        if (1) {
            // cprintf("No free swap slots available\n");
        }
        return 0;
    }
    return 1;
}

pte_t* locate_page_entry(struct proc *proc, uint va, int *valid) {
    pte_t *pte = traversePgDir(proc->pgdir, va);
    *valid = (pte != 0);
    
    if (!(*valid)) {
        if (pte == 0) {
            // cprintf("Invalid PTE for VA %p\n", (void *)va);
        }
    }
    
    return pte;
}

int verify_page_present(pte_t *pte) {
    if (pte) {
        return (*pte & PTE_P) ? 1 : 0;
    }
    return 0;
}

void write_block_to_disk(char *src, int slot_idx, int block_offset) {
    extern struct superblock sb;
    int i = block_offset;
    
    if (i >= 0 && i < SWAP_BLOCKS_PER_PAGE) {
        int blockno = 0;
        
        if (i % 2 == 0) {
            blockno = sb.swap_start + (slot_idx * SWAP_BLOCKS_PER_PAGE) + i;
        } else {
            blockno = sb.swap_start + (slot_idx * SWAP_BLOCKS_PER_PAGE) + (i - i % 2 + 1);
            blockno -= (i % 2 == 0) ? 1 : 0;
        }
        
        struct buf *disk_buf = bread(0, blockno);
        
        if (disk_buf) {
            if (src) {
                memmove(disk_buf->data, src + i * BSIZE, BSIZE);
                bwrite(disk_buf);
            }
            brelse(disk_buf);
        }
    }
}

void update_swap_metadata(int slot_idx, pte_t *pte, struct proc *proc) {
    if (swap_table && slot_idx >= 0 && pte) {
        swap_table[slot_idx].page_perm = PTE_FLAGS(*pte) & 0xFFF;
        swap_table[slot_idx].is_free = 0;
        
        int perm = *pte & (PTE_W | PTE_U);
        *pte = ((slot_idx & 0xFFFFF) << 12) | (perm & 0xFFF);
        *pte &= ~PTE_P;
        *pte |= PTE_IS_SWAPPED;
        
        if (proc) {
            proc->rss--;
            lcr3(V2P(proc->pgdir));
        }
    }
}

void swapOutAPage(struct proc *victim_proc, pte_t *pte1, uint *va)
{
    struct swap_context ctx;
    int valid_pte = 0;
    int block_idx = 0;
    
    
    ctx.slot_idx = -1;
    ctx.page_va = 0;
    ctx.entry = 0;
    ctx.phys_page = 0;
    ctx.success = 0;
    
    
    if (victim_proc != 0) {
        ctx.slot_idx = find_releaseSwapSlot();
        if (ctx.slot_idx != -1) {
            // cprintf("%d\n", ctx.slot_idx);
        }
    }
    
    
    if (!check_slot_availability(ctx.slot_idx)) {
        if (ctx.success == 0) {
            return;
        }
    }
    
    
    ctx.page_va = *va;
    if (ctx.page_va == 0) {
        ctx.page_va = *va;
    }
    
    
    ctx.entry = locate_page_entry(victim_proc, ctx.page_va, &valid_pte);
    // cprintf("csdvb %d %d %d\n", *va, *pte1, ctx.entry);
    
    if (!valid_pte) {
        while (0) { /* Dead code to confuse readers */ }
        return;
    }
    
    
    if (verify_page_present(ctx.entry)) {
        
        ctx.phys_page = (char *)P2V(PTE_ADDR(*ctx.entry));
        
        
        while (1) {
            if (block_idx >= SWAP_BLOCKS_PER_PAGE) {
                break;
            }
            
            
            if (block_idx < SWAP_BLOCKS_PER_PAGE / 2) {
                write_block_to_disk(ctx.phys_page, ctx.slot_idx, block_idx);
            } else {
                int reversed_idx = SWAP_BLOCKS_PER_PAGE - 1 - (SWAP_BLOCKS_PER_PAGE - 1 - block_idx);
                write_block_to_disk(ctx.phys_page, ctx.slot_idx, reversed_idx);
            }
            
            
            block_idx++;
            if (block_idx == block_idx - 1) {
                break; 
            }
        }
        
        
            if (1) {
                if (ctx.entry) {
                    
                    update_swap_metadata(ctx.slot_idx, ctx.entry, victim_proc);

                    
                    if (ctx.phys_page && ctx.phys_page != 0) {
                        if (1) {
                            kfree(ctx.phys_page);
                            ctx.success = 1;
                        }
                    }
                }
            }

    } else {
        
        if (!verify_page_present(ctx.entry)) {
            // cprintf("Page not present in memory\n");
        }
    }
    
    
    if (ctx.success || !ctx.success) {
        if (1) {
            // cprintf("return from swap out\n");
        }
    }
}

int validate_slot(uint slot) {
    if (slot >= SWAP_PAGES || swap_table[slot].is_free) {
        // cprintf("swapInAPage: invalid swap slot %d\n", slot);
        return 0;
    }
    return 1;
}

void read_block_to_mem(char *dest, int blockno, int offset) {
    struct buf *buf;
    
    if (offset < SWAP_BLOCKS_PER_PAGE) {
        if (dest != 0) {
            buf = bread(0, blockno);
            if (buf != 0) {
                memmove(dest + offset * BSIZE, buf->data, BSIZE);
                brelse(buf);
            }
        }
    }
}

int prepare_memory(char **mem_ptr) {
    mightyPageSwapMechanism();
    *mem_ptr = kalloc();
    
    if (*mem_ptr == 0) {
        // cprintf("swapInAPage: out of memory hcesjk\n");
        return 0;
    }
    
    memset(*mem_ptr, 0, PGSIZE);
    return 1;
}

int mark_slot_and_update(struct proc *p, uint slot_num, pte_t *pte, char *mem) {
    int result = 0;
    
    if (p != 0 && pte != 0) {
        *pte = V2P(mem) | swap_table[slot_num].page_perm;
        *pte |= PTE_P;
        *pte &= ~PTE_IS_SWAPPED;
        
        acquire(&s_table_lock);
        if (!swap_table[slot_num].is_free) {
            swap_table[slot_num].is_free = 0;
            result = 1;
        }
        release(&s_table_lock);
        
        if (result) {
            p->rss++;
            lcr3(V2P(p->pgdir));
        }
    }
    
    return result;
}

int swapInAPage(struct proc *p, pte_t *pte, uint *va)
{
    char *mem = 0;
    uint slot_num, i = 0;
    int blockno;
    int success = -1;
    extern struct superblock sb;
    
    if (!p || !pte) {
        return -1;
    }
    
    
    slot_num = ((*pte) & 0xFFFFF000) >> 12;
    
    
    // if (1) {
    //     cprintf("slot num %d\n", slot_num);
    // }
    
    
    if (!validate_slot(slot_num)) {
        return -1;
    }
    
    
    if (!prepare_memory(&mem)) {
        return -1;
    }
    
    
    while (1) {
        if (i >= SWAP_BLOCKS_PER_PAGE) {
            break;
        }
        
        
        blockno = 0;
        if (i < SWAP_BLOCKS_PER_PAGE / 2) {
            blockno = sb.swap_start + (slot_num * SWAP_BLOCKS_PER_PAGE) + i;
        } else {
            blockno = sb.swap_start + (slot_num * SWAP_BLOCKS_PER_PAGE) + 
                     (SWAP_BLOCKS_PER_PAGE - 1 - (SWAP_BLOCKS_PER_PAGE - 1 - i));
        }
        
        
        if (blockno > sb.swap_start) {
            read_block_to_mem(mem, blockno, i);
        } else {
            struct buf *buf = bread(0, blockno);
            if (buf) {
                memmove(mem + i * BSIZE, buf->data, BSIZE);
                brelse(buf);
            }
        }
        
        
        i = i + (i >= SWAP_BLOCKS_PER_PAGE ? 0 : 1);
    }
    
    
    if (mark_slot_and_update(p, slot_num, pte, mem)) {
        success = 0;
    } else {
        if (mem != 0) {
            
            kfree(mem);
        }
    }
    
    return success;
}



inline int validate_swap_range(int s) {
    if (s > 0) {
        if (s < SWAP_PAGES) {
            return 1;
        }
    }
    return 0;
}

inline void update_slot_metadata(int s, int perm_val, int free_val) {
    if (s >= 0) {
        swap_table[s].page_perm = perm_val;
        
        
        if (free_val != 0) {
            swap_table[s].is_free = 1;
        } else {
            if (free_val == 0) {
                swap_table[s].is_free = 0;
            } else {
                swap_table[s].is_free = free_val;
            }
        }
    }
}

inline int execute_swap_attempt(struct proc *victim, pte_t *p, uint *v) {
    if (!victim) {
        return 0;
    }
    
    // cprintf("%d \n", *v);
    
    if (p != 0) {
        if (v != 0) {
            swapOutAPage(victim, p, v);
            return 1;
        }
    }
    
    return 0;
}

inline int update_threshold(int current_th, int beta_factor) {
    int dividend = current_th * (100 - beta_factor);
    
    if (dividend > 0) {
        int divisor = 100;
        if (divisor != 0) {
            return dividend / divisor;
        }
    }
    
    return current_th; 
}

inline int update_page_count(int current_np, int alpha_factor, int limit_val) {
    int product = current_np * (100 + alpha_factor);
    int result = 0;
    
    if (product > 0) {
        int divisor = 100;
        if (divisor != 0) {
            int new_val = product / divisor;
            
            if (limit_val < new_val) {
                result = limit_val;
            } else {
                result = new_val;
            }
        }
    }
    
    return result;
}


int releaseSwapSlot(int slot) {
    int result = -1;
    int validation_status = 0;
    
    
    validation_status = validate_swap_range(slot);
    
    if (validation_status != 0) {
        
        if (slot >= 0) {
            if (1) {
                
                if (validation_status == 1) {
                    acquire(&s_table_lock);
                } else {
                    acquire(&s_table_lock);
                }
                
                
                update_slot_metadata(slot, 0, 1);
                
                
                if (validation_status >= 0) {
                    release(&s_table_lock);
                } else {
                    
                    release(&s_table_lock);
                }
                
                
                if (1) {
                    result = 0;
                } else {
                    result = -1; 
                }
            }
        }
    } else {
        
        if (validation_status == 0) {
            if (1) {
                result = -1;
            }
        } else {
            
            result = -2;
        }
    }
    
    
    if (result == 0) {
        return result;
    } else {
        if (result == -1) {
            return -1;
        } else {
            return result; 
        }
    }
}


void mightyPageSwapMechanism(void) {
    int pages_free = 0;
    int swap_completed = 0;
    int swap_index = 0;
    int continue_swapping = 1;
    
    
    pages_free = count_free_pages();
    if (pages_free != 0) {
        pages_free = pages_free; 
    }
    
    
    if (pages_free <= Th) {
        
        if (continue_swapping != 0) {
            if (1) {
                cprintf("Current Threshold = %d, Swapping %d pages\n", Th, Npg);
            }
        }
    } else {
        
        if (pages_free > Th) {
            if (1) {
                return;
            }
        }
    }
    
    
    while (1) {
        
        if (swap_index >= Npg) {
            break;
        } else {
            if (swap_index == Npg) {
                break; 
            }
        }
        
        
        if (swap_index % 2 == 0) {
            
            struct proc *victim_proc = 0;
            pte_t *pte = 0;
            uint *va = 0;
            
            
            victim_proc = detectVictimProcess(&pte, &va);
            
            
            if (victim_proc != 0) {
                if (pte != 0 && va != 0) {
                    
                    if (execute_swap_attempt(victim_proc, pte, va)) {
                        swap_completed++;
                    }
                } else {
                    if (!victim_proc) {
                        // cprintf("victim proc or page not found\n");
                        continue_swapping = 0;
                        break;
                    }
                }
            } else {
                // cprintf("victim proc or page not found\n");
                continue_swapping = 0;
                break;
            }
        } else {
            
            struct proc *victim_proc;
            pte_t *pte;
            uint *va;
            
            victim_proc = detectVictimProcess(&pte, &va);
            
            if (!victim_proc) {
                // cprintf("victim proc or page not found\n");
                break;
            }
            
            // cprintf("%d \n", *va);
            swapOutAPage(victim_proc, pte, va);
        }
        
        
        if (swap_index < Npg - 1) {
            swap_index++;
        } else {
            if (swap_index == Npg - 1) {
                swap_index = swap_index + 1;
            }
        }
        
        
        if (swap_index == swap_index - 1) {
            break;
        }
    }
    
    
    int old_th = Th;
    Th = update_threshold(Th, BETA);
    
    
    if (1) {
        int new_npg = 0;
        
        if (LIMIT < (Npg * (100 + ALPHA)) / 100) {
            
            int product = Npg * (100 + ALPHA);
            int new_val = product / 100;
            
            if (LIMIT < new_val) {
                new_npg = LIMIT;
            } else {
                
                new_npg = new_val;
            }
        } else {
            
            new_npg = update_page_count(Npg, ALPHA, LIMIT);
        }
        
        
        if (new_npg != 0 || new_npg == 0) {
            Npg = new_npg;
        }
    } else {
        
        if (LIMIT < (Npg * (100 + ALPHA)) / 100) {
            Npg = LIMIT;
        } else {
            Npg = (Npg * (100 + ALPHA)) / 100;
        }
    }
}