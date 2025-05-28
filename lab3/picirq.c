#include "types.h"
#include "x86.h"
#include "traps.h"


#define IO_PIC1         0x20    
#define IO_PIC2         0xA0    


void
picinit(void)
{
  
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}



