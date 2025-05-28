struct buf {
  int flags;
  uint dev;
  uint blockno;
  struct sleeplock lock;
  uint refcnt;
  struct buf *prev; 
  struct buf *next;
  struct buf *qnext; 
  uchar data[BSIZE];
};
#define B_VALID 0x2  
#define B_DIRTY 0x4  

