


#include "param.h"
#include "types.h"
#include "defs.h"
#include "date.h"
#include "memlayout.h"
#include "traps.h"
#include "mmu.h"
#include "x86.h"


#define ID      (0x0020/4)   
#define VER     (0x0030/4)   
#define TPR     (0x0080/4)   
#define EOI     (0x00B0/4)   
#define SVR     (0x00F0/4)   
  #define ENABLE     0x00000100   
#define ESR     (0x0280/4)   
#define ICRLO   (0x0300/4)   
  #define INIT       0x00000500   
  #define STARTUP    0x00000600   
  #define DELIVS     0x00001000   
  #define ASSERT     0x00004000   
  #define DEASSERT   0x00000000
  #define LEVEL      0x00008000   
  #define BCAST      0x00080000   
  #define BUSY       0x00001000
  #define FIXED      0x00000000
#define ICRHI   (0x0310/4)   
#define TIMER   (0x0320/4)   
  #define X1         0x0000000B   
  #define PERIODIC   0x00020000   
#define PCINT   (0x0340/4)   
#define LINT0   (0x0350/4)   
#define LINT1   (0x0360/4)   
#define ERROR   (0x0370/4)   
  #define MASKED     0x00010000   
#define TICR    (0x0380/4)   
#define TCCR    (0x0390/4)   
#define TDCR    (0x03E0/4)   

volatile uint *lapic;  


static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  
}

void
lapicinit(void)
{
  if(!lapic)
    return;

  
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));

  
  
  
  
  lapicw(TDCR, X1);
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
  lapicw(TICR, 10000000);

  
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  
  
  if(((lapic[VER]>>16) & 0xFF) >= 4)
    lapicw(PCINT, MASKED);

  
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);

  
  lapicw(ESR, 0);
  lapicw(ESR, 0);

  
  lapicw(EOI, 0);

  
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
    ;

  
  lapicw(TPR, 0);
}

int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
}


void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}



void
microdelay(int us)
{
}

#define CMOS_PORT    0x70
#define CMOS_RETURN  0x71



void
lapicstartap(uchar apicid, uint addr)
{
  int i;
  ushort *wrv;

  
  
  
  outb(CMOS_PORT, 0xF);  
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  
  
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);    

  
  
  
  
  
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}

#define CMOS_STATA   0x0a
#define CMOS_STATB   0x0b
#define CMOS_UIP    (1 << 7)        

#define SECS    0x00
#define MINS    0x02
#define HOURS   0x04
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}


void
cmostime(struct rtcdate *r)
{
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;

  
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }

  
  if(bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
    CONV(minute);
    CONV(hour  );
    CONV(day   );
    CONV(month );
    CONV(year  );
#undef     CONV
  }

  *r = t1;
  r->year += 2000;
}
