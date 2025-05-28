struct file {
  enum { FD_NONE, FD_PIPE, FD_INODE } type;
  int ref; 
  char readable;
  char writable;
  struct pipe *pipe;
  struct inode *ip;
  uint off;
};



struct inode {
  uint dev;           
  uint inum;          
  int ref;            
  struct sleeplock lock; 
  int valid;          

  short type;         
  short major;
  short minor;
  short nlink;
  uint size;
  uint addrs[NDIRECT+1];
};



struct devsw {
  int (*read)(struct inode*, char*, int);
  int (*write)(struct inode*, char*, int);
};

extern struct devsw devsw[];

#define CONSOLE 1
