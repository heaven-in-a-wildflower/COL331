

struct mp {             
  uchar signature[4];           
  void *physaddr;               
  uchar length;                 
  uchar specrev;                
  uchar checksum;               
  uchar type;                   
  uchar imcrp;
  uchar reserved[3];
};

struct mpconf {         
  uchar signature[4];           
  ushort length;                
  uchar version;                
  uchar checksum;               
  uchar product[20];            
  uint *oemtable;               
  ushort oemlength;             
  ushort entry;                 
  uint *lapicaddr;              
  ushort xlength;               
  uchar xchecksum;              
  uchar reserved;
};

struct mpproc {         
  uchar type;                   
  uchar apicid;                 
  uchar version;                
  uchar flags;                  
    #define MPBOOT 0x02           
  uchar signature[4];           
  uint feature;                 
  uchar reserved[8];
};

struct mpioapic {       
  uchar type;                   
  uchar apicno;                 
  uchar version;                
  uchar flags;                  
  uint *addr;                  
};


#define MPPROC    0x00  
#define MPBUS     0x01  
#define MPIOAPIC  0x02  
#define MPIOINTR  0x03  
#define MPLINTR   0x04  



