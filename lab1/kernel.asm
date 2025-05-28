
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 30 10 80       	mov    $0x801030d0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 e0 77 10 80       	push   $0x801077e0
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 61 46 00 00       	call   801046c0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc 0c 11 80       	mov    $0x80110cdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 77 10 80       	push   $0x801077e7
80100097:	50                   	push   %eax
80100098:	e8 e3 44 00 00       	call   80104580 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 0a 11 80    	cmp    $0x80110a80,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e8:	e8 53 47 00 00       	call   80104840 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 99 47 00 00       	call   80104900 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 44 00 00       	call   801045c0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 7f 21 00 00       	call   80102310 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ee 77 10 80       	push   $0x801077ee
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 99 44 00 00       	call   80104660 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave
  iderw(b);
801001d8:	e9 33 21 00 00       	jmp    80102310 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 ff 77 10 80       	push   $0x801077ff
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 58 44 00 00       	call   80104660 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 08 44 00 00       	call   80104620 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 1c 46 00 00       	call   80104840 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 0d 11 80       	mov    0x80110d30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 8b 46 00 00       	jmp    80104900 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 06 78 10 80       	push   $0x80107806
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	push   0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 16 16 00 00       	call   801018c0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 8a 45 00 00       	call   80104840 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002cb:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 c0 0f 11 80       	push   $0x80110fc0
801002e5:	e8 f6 3e 00 00       	call   801041e0 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 31 37 00 00       	call   80103a30 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 ed 45 00 00       	call   80104900 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	push   0x8(%ebp)
80100317:	e8 c4 14 00 00       	call   801017e0 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 0f 11 80 	movsbl -0x7feef0c0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 96 45 00 00       	call   80104900 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	push   0x8(%ebp)
8010036e:	e8 6d 14 00 00       	call   801017e0 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 7e 25 00 00       	call   80102930 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 0d 78 10 80       	push   $0x8010780d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	push   0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 d9 7b 10 80 	movl   $0x80107bd9,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ff 42 00 00       	call   801046e0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	push   (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 21 78 10 80       	push   $0x80107821
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 b1 5f 00 00       	call   801063e0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 c6 5e 00 00       	call   801063e0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ba 5e 00 00       	call   801063e0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ae 5e 00 00       	call   801063e0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 8a 44 00 00       	call   801049f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 d5 43 00 00       	call   80104950 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 25 78 10 80       	push   $0x80107825
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010059a:	00 
8010059b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 90 7d 10 80 	movzbl -0x7fef8270(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret
80100631:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100638:	00 
80100639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	push   0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 68 12 00 00       	call   801018c0 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 dc 41 00 00       	call   80104840 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 64 42 00 00       	call   80104900 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	push   0x8(%ebp)
801006a0:	e8 3b 11 00 00       	call   801017e0 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret
8010072b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 38 78 10 80       	mov    $0x80107838,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 7e 40 00 00       	call   80104840 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 d3 40 00 00       	call   80104900 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 3f 78 10 80       	push   $0x8010783f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010085b:	00 
8010085c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 c4 3f 00 00       	call   80104840 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d c8 0f 11 80    	mov    %ecx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 40 0f 11 80    	mov    %bl,-0x7feef0c0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100925:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010095f:	00 
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010096f:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100985:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 2c 3f 00 00       	call   80104900 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 9c 3a 00 00       	jmp    801044a0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100a1b:	68 c0 0f 11 80       	push   $0x80110fc0
80100a20:	e8 7b 39 00 00       	call   801043a0 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 48 78 10 80       	push   $0x80107848
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 77 3c 00 00       	call   801046c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 8c 19 11 80 40 	movl   $0x80100640,0x8011198c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 88 19 11 80 90 	movl   $0x80100290,0x80111988
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 4e 1a 00 00       	call   801024c0 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave
80100a76:	c3                   	ret
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "elf.h"

// void add_to_history(const char *name, int pid);

int exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3 + MAXARG + 1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 9b 2f 00 00       	call   80103a30 <myproc>
80100a95:	89 c6                	mov    %eax,%esi
80100a97:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  int bad_flag = 0;

  begin_op();
80100a9d:	e8 1e 23 00 00       	call   80102dc0 <begin_op>
  curproc->exec_failed=0;


  if ((ip = namei(path)) == 0)
80100aa2:	83 ec 0c             	sub    $0xc,%esp
  curproc->exec_failed=0;
80100aa5:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
  if ((ip = namei(path)) == 0)
80100aac:	ff 75 08             	push   0x8(%ebp)
80100aaf:	e8 0c 16 00 00       	call   801020c0 <namei>
80100ab4:	83 c4 10             	add    $0x10,%esp
80100ab7:	85 c0                	test   %eax,%eax
80100ab9:	0f 84 30 03 00 00    	je     80100def <exec+0x36f>
    // cprintf("%d->exec_failed=%d\n",curproc->pid,curproc->exec_failed);
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100abf:	83 ec 0c             	sub    $0xc,%esp
80100ac2:	89 c3                	mov    %eax,%ebx
80100ac4:	50                   	push   %eax
80100ac5:	e8 16 0d 00 00       	call   801017e0 <ilock>
  pgdir = 0;

  // Check ELF header
  if (readi(ip, (char *)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aca:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ad0:	6a 34                	push   $0x34
80100ad2:	6a 00                	push   $0x0
80100ad4:	50                   	push   %eax
80100ad5:	53                   	push   %ebx
80100ad6:	e8 15 10 00 00       	call   80101af0 <readi>
80100adb:	83 c4 20             	add    $0x20,%esp
80100ade:	83 f8 34             	cmp    $0x34,%eax
80100ae1:	74 2d                	je     80100b10 <exec+0x90>
  
  cprintf("%d->exec_failed=%d",curproc->pid,curproc->exec_failed);
  return 0;

bad:
  curproc->exec_failed=1;
80100ae3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100ae9:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
  if (pgdir)
    freevm(pgdir);
  if (ip)
  {
    iunlockput(ip);
80100af0:	83 ec 0c             	sub    $0xc,%esp
80100af3:	53                   	push   %ebx
80100af4:	e8 87 0f 00 00       	call   80101a80 <iunlockput>
    end_op();
80100af9:	e8 32 23 00 00       	call   80102e30 <end_op>
80100afe:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b09:	5b                   	pop    %ebx
80100b0a:	5e                   	pop    %esi
80100b0b:	5f                   	pop    %edi
80100b0c:	5d                   	pop    %ebp
80100b0d:	c3                   	ret
80100b0e:	66 90                	xchg   %ax,%ax
  if (elf.magic != ELF_MAGIC)
80100b10:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b17:	45 4c 46 
80100b1a:	75 c7                	jne    80100ae3 <exec+0x63>
  if ((pgdir = setupkvm()) == 0)
80100b1c:	e8 2f 6a 00 00       	call   80107550 <setupkvm>
80100b21:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b27:	85 c0                	test   %eax,%eax
80100b29:	74 b8                	je     80100ae3 <exec+0x63>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
80100b2b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b32:	00 
80100b33:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b39:	0f 84 e8 02 00 00    	je     80100e27 <exec+0x3a7>
  sz = 0;
80100b3f:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100b46:	00 00 00 
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
80100b49:	31 ff                	xor    %edi,%edi
80100b4b:	e9 86 00 00 00       	jmp    80100bd6 <exec+0x156>
    if (ph.type != ELF_PROG_LOAD)
80100b50:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b57:	75 6c                	jne    80100bc5 <exec+0x145>
    if (ph.memsz < ph.filesz)
80100b59:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b5f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b65:	0f 82 87 00 00 00    	jb     80100bf2 <exec+0x172>
    if (ph.vaddr + ph.memsz < ph.vaddr)
80100b6b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b71:	72 7f                	jb     80100bf2 <exec+0x172>
    if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b73:	83 ec 04             	sub    $0x4,%esp
80100b76:	50                   	push   %eax
80100b77:	ff b5 ec fe ff ff    	push   -0x114(%ebp)
80100b7d:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b83:	e8 e8 67 00 00       	call   80107370 <allocuvm>
80100b88:	83 c4 10             	add    $0x10,%esp
80100b8b:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b91:	85 c0                	test   %eax,%eax
80100b93:	74 5d                	je     80100bf2 <exec+0x172>
    if (ph.vaddr % PGSIZE != 0)
80100b95:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b9b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba0:	75 50                	jne    80100bf2 <exec+0x172>
    if (loaduvm(pgdir, (char *)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ba2:	83 ec 0c             	sub    $0xc,%esp
80100ba5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bab:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bb1:	53                   	push   %ebx
80100bb2:	50                   	push   %eax
80100bb3:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bb9:	e8 e2 66 00 00       	call   801072a0 <loaduvm>
80100bbe:	83 c4 20             	add    $0x20,%esp
80100bc1:	85 c0                	test   %eax,%eax
80100bc3:	78 2d                	js     80100bf2 <exec+0x172>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
80100bc5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bcc:	83 c7 01             	add    $0x1,%edi
80100bcf:	83 c6 20             	add    $0x20,%esi
80100bd2:	39 f8                	cmp    %edi,%eax
80100bd4:	7e 42                	jle    80100c18 <exec+0x198>
    if (readi(ip, (char *)&ph, off, sizeof(ph)) != sizeof(ph))
80100bd6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bdc:	6a 20                	push   $0x20
80100bde:	56                   	push   %esi
80100bdf:	50                   	push   %eax
80100be0:	53                   	push   %ebx
80100be1:	e8 0a 0f 00 00       	call   80101af0 <readi>
80100be6:	83 c4 10             	add    $0x10,%esp
80100be9:	83 f8 20             	cmp    $0x20,%eax
80100bec:	0f 84 5e ff ff ff    	je     80100b50 <exec+0xd0>
  curproc->exec_failed=1;
80100bf2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
    freevm(pgdir);
80100bf8:	83 ec 0c             	sub    $0xc,%esp
  curproc->exec_failed=1;
80100bfb:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
    freevm(pgdir);
80100c02:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100c08:	e8 c3 68 00 00       	call   801074d0 <freevm>
80100c0d:	83 c4 10             	add    $0x10,%esp
80100c10:	e9 db fe ff ff       	jmp    80100af0 <exec+0x70>
80100c15:	8d 76 00             	lea    0x0(%esi),%esi
80100c18:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100c1e:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c24:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c2a:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c30:	83 ec 0c             	sub    $0xc,%esp
80100c33:	53                   	push   %ebx
80100c34:	e8 47 0e 00 00       	call   80101a80 <iunlockput>
  end_op();
80100c39:	e8 f2 21 00 00       	call   80102e30 <end_op>
  if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100c3e:	83 c4 0c             	add    $0xc,%esp
80100c41:	56                   	push   %esi
80100c42:	57                   	push   %edi
80100c43:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c49:	57                   	push   %edi
80100c4a:	e8 21 67 00 00       	call   80107370 <allocuvm>
80100c4f:	83 c4 10             	add    $0x10,%esp
80100c52:	89 c6                	mov    %eax,%esi
80100c54:	85 c0                	test   %eax,%eax
80100c56:	0f 84 94 00 00 00    	je     80100cf0 <exec+0x270>
  clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100c5c:	83 ec 08             	sub    $0x8,%esp
80100c5f:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for (argc = 0; argv[argc]; argc++)
80100c65:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100c67:	50                   	push   %eax
80100c68:	57                   	push   %edi
  for (argc = 0; argv[argc]; argc++)
80100c69:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100c6b:	e8 80 69 00 00       	call   801075f0 <clearpteu>
  for (argc = 0; argv[argc]; argc++)
80100c70:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c73:	83 c4 10             	add    $0x10,%esp
80100c76:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c7c:	8b 00                	mov    (%eax),%eax
80100c7e:	85 c0                	test   %eax,%eax
80100c80:	0f 84 98 00 00 00    	je     80100d1e <exec+0x29e>
80100c86:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c8c:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c92:	eb 23                	jmp    80100cb7 <exec+0x237>
80100c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c98:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3 + argc] = sp;
80100c9b:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for (argc = 0; argv[argc]; argc++)
80100ca2:	83 c7 01             	add    $0x1,%edi
    ustack[3 + argc] = sp;
80100ca5:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for (argc = 0; argv[argc]; argc++)
80100cab:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cae:	85 c0                	test   %eax,%eax
80100cb0:	74 66                	je     80100d18 <exec+0x298>
    if (argc >= MAXARG)
80100cb2:	83 ff 20             	cmp    $0x20,%edi
80100cb5:	74 39                	je     80100cf0 <exec+0x270>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb7:	83 ec 0c             	sub    $0xc,%esp
80100cba:	50                   	push   %eax
80100cbb:	e8 90 3e 00 00       	call   80104b50 <strlen>
80100cc0:	f7 d0                	not    %eax
80100cc2:	01 c3                	add    %eax,%ebx
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cc4:	58                   	pop    %eax
80100cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ccb:	ff 34 b8             	push   (%eax,%edi,4)
80100cce:	e8 7d 3e 00 00       	call   80104b50 <strlen>
80100cd3:	83 c0 01             	add    $0x1,%eax
80100cd6:	50                   	push   %eax
80100cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cda:	ff 34 b8             	push   (%eax,%edi,4)
80100cdd:	53                   	push   %ebx
80100cde:	56                   	push   %esi
80100cdf:	e8 6c 6a 00 00       	call   80107750 <copyout>
80100ce4:	83 c4 20             	add    $0x20,%esp
80100ce7:	85 c0                	test   %eax,%eax
80100ce9:	79 ad                	jns    80100c98 <exec+0x218>
80100ceb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  curproc->exec_failed=1;
80100cf0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
    freevm(pgdir);
80100cf6:	83 ec 0c             	sub    $0xc,%esp
  curproc->exec_failed=1;
80100cf9:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
    freevm(pgdir);
80100d00:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100d06:	e8 c5 67 00 00       	call   801074d0 <freevm>
80100d0b:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d13:	e9 ee fd ff ff       	jmp    80100b06 <exec+0x86>
80100d18:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100d1e:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d25:	89 d9                	mov    %ebx,%ecx
  ustack[3 + argc] = 0;
80100d27:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d2e:	00 00 00 00 
  ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100d32:	29 c1                	sub    %eax,%ecx
  sp -= (3 + argc + 1) * 4;
80100d34:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d37:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3 + argc + 1) * 4;
80100d3d:	29 c3                	sub    %eax,%ebx
  if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100d3f:	50                   	push   %eax
80100d40:	52                   	push   %edx
80100d41:	53                   	push   %ebx
80100d42:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
  ustack[0] = 0xffffffff; // fake return PC
80100d48:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d4f:	ff ff ff 
  ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100d52:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100d58:	e8 f3 69 00 00       	call   80107750 <copyout>
80100d5d:	83 c4 10             	add    $0x10,%esp
80100d60:	85 c0                	test   %eax,%eax
80100d62:	78 8c                	js     80100cf0 <exec+0x270>
  for (last = s = path; *s; s++)
80100d64:	8b 45 08             	mov    0x8(%ebp),%eax
80100d67:	8b 55 08             	mov    0x8(%ebp),%edx
80100d6a:	0f b6 00             	movzbl (%eax),%eax
80100d6d:	84 c0                	test   %al,%al
80100d6f:	74 16                	je     80100d87 <exec+0x307>
80100d71:	89 d1                	mov    %edx,%ecx
80100d73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (*s == '/')
80100d78:	83 c1 01             	add    $0x1,%ecx
80100d7b:	3c 2f                	cmp    $0x2f,%al
  for (last = s = path; *s; s++)
80100d7d:	0f b6 01             	movzbl (%ecx),%eax
    if (*s == '/')
80100d80:	0f 44 d1             	cmove  %ecx,%edx
  for (last = s = path; *s; s++)
80100d83:	84 c0                	test   %al,%al
80100d85:	75 f1                	jne    80100d78 <exec+0x2f8>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d87:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d8d:	83 ec 04             	sub    $0x4,%esp
80100d90:	6a 10                	push   $0x10
80100d92:	89 f8                	mov    %edi,%eax
80100d94:	52                   	push   %edx
80100d95:	83 c0 6c             	add    $0x6c,%eax
80100d98:	50                   	push   %eax
80100d99:	e8 72 3d 00 00       	call   80104b10 <safestrcpy>
  curproc->pgdir = pgdir;
80100d9e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100da4:	89 f8                	mov    %edi,%eax
80100da6:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100da9:	89 30                	mov    %esi,(%eax)
  curproc->tf->eip = elf.entry; // main
80100dab:	89 c6                	mov    %eax,%esi
  curproc->pgdir = pgdir;
80100dad:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry; // main
80100db0:	8b 40 18             	mov    0x18(%eax),%eax
80100db3:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100db9:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dbc:	8b 46 18             	mov    0x18(%esi),%eax
80100dbf:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc2:	89 34 24             	mov    %esi,(%esp)
80100dc5:	e8 46 63 00 00       	call   80107110 <switchuvm>
  freevm(oldpgdir);
80100dca:	89 3c 24             	mov    %edi,(%esp)
80100dcd:	e8 fe 66 00 00       	call   801074d0 <freevm>
  cprintf("%d->exec_failed=%d",curproc->pid,curproc->exec_failed);
80100dd2:	83 c4 0c             	add    $0xc,%esp
80100dd5:	ff 76 7c             	push   0x7c(%esi)
80100dd8:	ff 76 10             	push   0x10(%esi)
80100ddb:	68 66 78 10 80       	push   $0x80107866
80100de0:	e8 cb f8 ff ff       	call   801006b0 <cprintf>
  return 0;
80100de5:	83 c4 10             	add    $0x10,%esp
80100de8:	31 c0                	xor    %eax,%eax
80100dea:	e9 17 fd ff ff       	jmp    80100b06 <exec+0x86>
    cprintf("bakchodi\n");
80100def:	83 ec 0c             	sub    $0xc,%esp
80100df2:	68 50 78 10 80       	push   $0x80107850
80100df7:	e8 b4 f8 ff ff       	call   801006b0 <cprintf>
    curproc->exec_failed=1;
80100dfc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100e02:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
    end_op();
80100e09:	e8 22 20 00 00       	call   80102e30 <end_op>
    cprintf("exec: fail\n");
80100e0e:	c7 04 24 5a 78 10 80 	movl   $0x8010785a,(%esp)
80100e15:	e8 96 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e22:	e9 df fc ff ff       	jmp    80100b06 <exec+0x86>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
80100e27:	31 ff                	xor    %edi,%edi
80100e29:	be 00 20 00 00       	mov    $0x2000,%esi
80100e2e:	e9 fd fd ff ff       	jmp    80100c30 <exec+0x1b0>
80100e33:	66 90                	xchg   %ax,%ax
80100e35:	66 90                	xchg   %ax,%ax
80100e37:	66 90                	xchg   %ax,%ax
80100e39:	66 90                	xchg   %ax,%ax
80100e3b:	66 90                	xchg   %ax,%ax
80100e3d:	66 90                	xchg   %ax,%ax
80100e3f:	90                   	nop

80100e40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e40:	f3 0f 1e fb          	endbr32
80100e44:	55                   	push   %ebp
80100e45:	89 e5                	mov    %esp,%ebp
80100e47:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e4a:	68 79 78 10 80       	push   $0x80107879
80100e4f:	68 e0 0f 11 80       	push   $0x80110fe0
80100e54:	e8 67 38 00 00       	call   801046c0 <initlock>
}
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	c9                   	leave
80100e5d:	c3                   	ret
80100e5e:	66 90                	xchg   %ax,%ax

80100e60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e60:	f3 0f 1e fb          	endbr32
80100e64:	55                   	push   %ebp
80100e65:	89 e5                	mov    %esp,%ebp
80100e67:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e68:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100e6d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e70:	68 e0 0f 11 80       	push   $0x80110fe0
80100e75:	e8 c6 39 00 00       	call   80104840 <acquire>
80100e7a:	83 c4 10             	add    $0x10,%esp
80100e7d:	eb 0c                	jmp    80100e8b <filealloc+0x2b>
80100e7f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e80:	83 c3 18             	add    $0x18,%ebx
80100e83:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
80100e89:	74 25                	je     80100eb0 <filealloc+0x50>
    if(f->ref == 0){
80100e8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	75 ee                	jne    80100e80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e92:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e95:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e9c:	68 e0 0f 11 80       	push   $0x80110fe0
80100ea1:	e8 5a 3a 00 00       	call   80104900 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ea6:	89 d8                	mov    %ebx,%eax
      return f;
80100ea8:	83 c4 10             	add    $0x10,%esp
}
80100eab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eae:	c9                   	leave
80100eaf:	c3                   	ret
  release(&ftable.lock);
80100eb0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100eb3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100eb5:	68 e0 0f 11 80       	push   $0x80110fe0
80100eba:	e8 41 3a 00 00       	call   80104900 <release>
}
80100ebf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ec1:	83 c4 10             	add    $0x10,%esp
}
80100ec4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ec7:	c9                   	leave
80100ec8:	c3                   	ret
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ed0:	f3 0f 1e fb          	endbr32
80100ed4:	55                   	push   %ebp
80100ed5:	89 e5                	mov    %esp,%ebp
80100ed7:	53                   	push   %ebx
80100ed8:	83 ec 10             	sub    $0x10,%esp
80100edb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ede:	68 e0 0f 11 80       	push   $0x80110fe0
80100ee3:	e8 58 39 00 00       	call   80104840 <acquire>
  if(f->ref < 1)
80100ee8:	8b 43 04             	mov    0x4(%ebx),%eax
80100eeb:	83 c4 10             	add    $0x10,%esp
80100eee:	85 c0                	test   %eax,%eax
80100ef0:	7e 1a                	jle    80100f0c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ef2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ef5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ef8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100efb:	68 e0 0f 11 80       	push   $0x80110fe0
80100f00:	e8 fb 39 00 00       	call   80104900 <release>
  return f;
}
80100f05:	89 d8                	mov    %ebx,%eax
80100f07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f0a:	c9                   	leave
80100f0b:	c3                   	ret
    panic("filedup");
80100f0c:	83 ec 0c             	sub    $0xc,%esp
80100f0f:	68 80 78 10 80       	push   $0x80107880
80100f14:	e8 77 f4 ff ff       	call   80100390 <panic>
80100f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f20 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f20:	f3 0f 1e fb          	endbr32
80100f24:	55                   	push   %ebp
80100f25:	89 e5                	mov    %esp,%ebp
80100f27:	57                   	push   %edi
80100f28:	56                   	push   %esi
80100f29:	53                   	push   %ebx
80100f2a:	83 ec 28             	sub    $0x28,%esp
80100f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f30:	68 e0 0f 11 80       	push   $0x80110fe0
80100f35:	e8 06 39 00 00       	call   80104840 <acquire>
  if(f->ref < 1)
80100f3a:	8b 53 04             	mov    0x4(%ebx),%edx
80100f3d:	83 c4 10             	add    $0x10,%esp
80100f40:	85 d2                	test   %edx,%edx
80100f42:	0f 8e a1 00 00 00    	jle    80100fe9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f48:	83 ea 01             	sub    $0x1,%edx
80100f4b:	89 53 04             	mov    %edx,0x4(%ebx)
80100f4e:	75 40                	jne    80100f90 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f50:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f54:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f57:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f59:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f5f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f62:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f65:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f68:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100f6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f70:	e8 8b 39 00 00       	call   80104900 <release>

  if(ff.type == FD_PIPE)
80100f75:	83 c4 10             	add    $0x10,%esp
80100f78:	83 ff 01             	cmp    $0x1,%edi
80100f7b:	74 53                	je     80100fd0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f7d:	83 ff 02             	cmp    $0x2,%edi
80100f80:	74 26                	je     80100fa8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f85:	5b                   	pop    %ebx
80100f86:	5e                   	pop    %esi
80100f87:	5f                   	pop    %edi
80100f88:	5d                   	pop    %ebp
80100f89:	c3                   	ret
80100f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f90:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
}
80100f97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9a:	5b                   	pop    %ebx
80100f9b:	5e                   	pop    %esi
80100f9c:	5f                   	pop    %edi
80100f9d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f9e:	e9 5d 39 00 00       	jmp    80104900 <release>
80100fa3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100fa8:	e8 13 1e 00 00       	call   80102dc0 <begin_op>
    iput(ff.ip);
80100fad:	83 ec 0c             	sub    $0xc,%esp
80100fb0:	ff 75 e0             	push   -0x20(%ebp)
80100fb3:	e8 58 09 00 00       	call   80101910 <iput>
    end_op();
80100fb8:	83 c4 10             	add    $0x10,%esp
}
80100fbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fbe:	5b                   	pop    %ebx
80100fbf:	5e                   	pop    %esi
80100fc0:	5f                   	pop    %edi
80100fc1:	5d                   	pop    %ebp
    end_op();
80100fc2:	e9 69 1e 00 00       	jmp    80102e30 <end_op>
80100fc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fce:	00 
80100fcf:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fd0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fd4:	83 ec 08             	sub    $0x8,%esp
80100fd7:	53                   	push   %ebx
80100fd8:	56                   	push   %esi
80100fd9:	e8 b2 25 00 00       	call   80103590 <pipeclose>
80100fde:	83 c4 10             	add    $0x10,%esp
}
80100fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe4:	5b                   	pop    %ebx
80100fe5:	5e                   	pop    %esi
80100fe6:	5f                   	pop    %edi
80100fe7:	5d                   	pop    %ebp
80100fe8:	c3                   	ret
    panic("fileclose");
80100fe9:	83 ec 0c             	sub    $0xc,%esp
80100fec:	68 88 78 10 80       	push   $0x80107888
80100ff1:	e8 9a f3 ff ff       	call   80100390 <panic>
80100ff6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ffd:	00 
80100ffe:	66 90                	xchg   %ax,%ax

80101000 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101000:	f3 0f 1e fb          	endbr32
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	53                   	push   %ebx
80101008:	83 ec 04             	sub    $0x4,%esp
8010100b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010100e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101011:	75 2d                	jne    80101040 <filestat+0x40>
    ilock(f->ip);
80101013:	83 ec 0c             	sub    $0xc,%esp
80101016:	ff 73 10             	push   0x10(%ebx)
80101019:	e8 c2 07 00 00       	call   801017e0 <ilock>
    stati(f->ip, st);
8010101e:	58                   	pop    %eax
8010101f:	5a                   	pop    %edx
80101020:	ff 75 0c             	push   0xc(%ebp)
80101023:	ff 73 10             	push   0x10(%ebx)
80101026:	e8 85 0a 00 00       	call   80101ab0 <stati>
    iunlock(f->ip);
8010102b:	59                   	pop    %ecx
8010102c:	ff 73 10             	push   0x10(%ebx)
8010102f:	e8 8c 08 00 00       	call   801018c0 <iunlock>
    return 0;
  }
  return -1;
}
80101034:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101037:	83 c4 10             	add    $0x10,%esp
8010103a:	31 c0                	xor    %eax,%eax
}
8010103c:	c9                   	leave
8010103d:	c3                   	ret
8010103e:	66 90                	xchg   %ax,%ax
80101040:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101043:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101048:	c9                   	leave
80101049:	c3                   	ret
8010104a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101050 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101050:	f3 0f 1e fb          	endbr32
80101054:	55                   	push   %ebp
80101055:	89 e5                	mov    %esp,%ebp
80101057:	57                   	push   %edi
80101058:	56                   	push   %esi
80101059:	53                   	push   %ebx
8010105a:	83 ec 0c             	sub    $0xc,%esp
8010105d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101060:	8b 75 0c             	mov    0xc(%ebp),%esi
80101063:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101066:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010106a:	74 64                	je     801010d0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010106c:	8b 03                	mov    (%ebx),%eax
8010106e:	83 f8 01             	cmp    $0x1,%eax
80101071:	74 45                	je     801010b8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101073:	83 f8 02             	cmp    $0x2,%eax
80101076:	75 5f                	jne    801010d7 <fileread+0x87>
    ilock(f->ip);
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	ff 73 10             	push   0x10(%ebx)
8010107e:	e8 5d 07 00 00       	call   801017e0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101083:	57                   	push   %edi
80101084:	ff 73 14             	push   0x14(%ebx)
80101087:	56                   	push   %esi
80101088:	ff 73 10             	push   0x10(%ebx)
8010108b:	e8 60 0a 00 00       	call   80101af0 <readi>
80101090:	83 c4 20             	add    $0x20,%esp
80101093:	89 c6                	mov    %eax,%esi
80101095:	85 c0                	test   %eax,%eax
80101097:	7e 03                	jle    8010109c <fileread+0x4c>
      f->off += r;
80101099:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010109c:	83 ec 0c             	sub    $0xc,%esp
8010109f:	ff 73 10             	push   0x10(%ebx)
801010a2:	e8 19 08 00 00       	call   801018c0 <iunlock>
    return r;
801010a7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010ad:	89 f0                	mov    %esi,%eax
801010af:	5b                   	pop    %ebx
801010b0:	5e                   	pop    %esi
801010b1:	5f                   	pop    %edi
801010b2:	5d                   	pop    %ebp
801010b3:	c3                   	ret
801010b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801010b8:	8b 43 0c             	mov    0xc(%ebx),%eax
801010bb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c1:	5b                   	pop    %ebx
801010c2:	5e                   	pop    %esi
801010c3:	5f                   	pop    %edi
801010c4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010c5:	e9 66 26 00 00       	jmp    80103730 <piperead>
801010ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010d5:	eb d3                	jmp    801010aa <fileread+0x5a>
  panic("fileread");
801010d7:	83 ec 0c             	sub    $0xc,%esp
801010da:	68 92 78 10 80       	push   $0x80107892
801010df:	e8 ac f2 ff ff       	call   80100390 <panic>
801010e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801010eb:	00 
801010ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010f0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010f0:	f3 0f 1e fb          	endbr32
801010f4:	55                   	push   %ebp
801010f5:	89 e5                	mov    %esp,%ebp
801010f7:	57                   	push   %edi
801010f8:	56                   	push   %esi
801010f9:	53                   	push   %ebx
801010fa:	83 ec 1c             	sub    $0x1c,%esp
801010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101100:	8b 75 08             	mov    0x8(%ebp),%esi
80101103:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101106:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101109:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010110d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101110:	0f 84 c1 00 00 00    	je     801011d7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101116:	8b 06                	mov    (%esi),%eax
80101118:	83 f8 01             	cmp    $0x1,%eax
8010111b:	0f 84 c3 00 00 00    	je     801011e4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101121:	83 f8 02             	cmp    $0x2,%eax
80101124:	0f 85 cc 00 00 00    	jne    801011f6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010112a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010112d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010112f:	85 c0                	test   %eax,%eax
80101131:	7f 34                	jg     80101167 <filewrite+0x77>
80101133:	e9 98 00 00 00       	jmp    801011d0 <filewrite+0xe0>
80101138:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010113f:	00 
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101140:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	push   0x10(%esi)
        f->off += r;
80101149:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010114c:	e8 6f 07 00 00       	call   801018c0 <iunlock>
      end_op();
80101151:	e8 da 1c 00 00       	call   80102e30 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101156:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	39 c3                	cmp    %eax,%ebx
8010115e:	75 60                	jne    801011c0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101160:	01 df                	add    %ebx,%edi
    while(i < n){
80101162:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101165:	7e 69                	jle    801011d0 <filewrite+0xe0>
      int n1 = n - i;
80101167:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010116a:	b8 00 06 00 00       	mov    $0x600,%eax
8010116f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101171:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101177:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010117a:	e8 41 1c 00 00       	call   80102dc0 <begin_op>
      ilock(f->ip);
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	ff 76 10             	push   0x10(%esi)
80101185:	e8 56 06 00 00       	call   801017e0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010118a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010118d:	53                   	push   %ebx
8010118e:	ff 76 14             	push   0x14(%esi)
80101191:	01 f8                	add    %edi,%eax
80101193:	50                   	push   %eax
80101194:	ff 76 10             	push   0x10(%esi)
80101197:	e8 54 0a 00 00       	call   80101bf0 <writei>
8010119c:	83 c4 20             	add    $0x20,%esp
8010119f:	85 c0                	test   %eax,%eax
801011a1:	7f 9d                	jg     80101140 <filewrite+0x50>
      iunlock(f->ip);
801011a3:	83 ec 0c             	sub    $0xc,%esp
801011a6:	ff 76 10             	push   0x10(%esi)
801011a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011ac:	e8 0f 07 00 00       	call   801018c0 <iunlock>
      end_op();
801011b1:	e8 7a 1c 00 00       	call   80102e30 <end_op>
      if(r < 0)
801011b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011b9:	83 c4 10             	add    $0x10,%esp
801011bc:	85 c0                	test   %eax,%eax
801011be:	75 17                	jne    801011d7 <filewrite+0xe7>
        panic("short filewrite");
801011c0:	83 ec 0c             	sub    $0xc,%esp
801011c3:	68 9b 78 10 80       	push   $0x8010789b
801011c8:	e8 c3 f1 ff ff       	call   80100390 <panic>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801011d0:	89 f8                	mov    %edi,%eax
801011d2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801011d5:	74 05                	je     801011dc <filewrite+0xec>
801011d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011df:	5b                   	pop    %ebx
801011e0:	5e                   	pop    %esi
801011e1:	5f                   	pop    %edi
801011e2:	5d                   	pop    %ebp
801011e3:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011e4:	8b 46 0c             	mov    0xc(%esi),%eax
801011e7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ed:	5b                   	pop    %ebx
801011ee:	5e                   	pop    %esi
801011ef:	5f                   	pop    %edi
801011f0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011f1:	e9 3a 24 00 00       	jmp    80103630 <pipewrite>
  panic("filewrite");
801011f6:	83 ec 0c             	sub    $0xc,%esp
801011f9:	68 a1 78 10 80       	push   $0x801078a1
801011fe:	e8 8d f1 ff ff       	call   80100390 <panic>
80101203:	66 90                	xchg   %ax,%ax
80101205:	66 90                	xchg   %ax,%ax
80101207:	66 90                	xchg   %ax,%ax
80101209:	66 90                	xchg   %ax,%ax
8010120b:	66 90                	xchg   %ax,%ax
8010120d:	66 90                	xchg   %ax,%ax
8010120f:	90                   	nop

80101210 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101210:	55                   	push   %ebp
80101211:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101213:	89 d0                	mov    %edx,%eax
80101215:	c1 e8 0c             	shr    $0xc,%eax
80101218:	03 05 f8 19 11 80    	add    0x801119f8,%eax
{
8010121e:	89 e5                	mov    %esp,%ebp
80101220:	56                   	push   %esi
80101221:	53                   	push   %ebx
80101222:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101224:	83 ec 08             	sub    $0x8,%esp
80101227:	50                   	push   %eax
80101228:	51                   	push   %ecx
80101229:	e8 a2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010122e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101230:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101233:	ba 01 00 00 00       	mov    $0x1,%edx
80101238:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010123b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101241:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101244:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101246:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010124b:	85 d1                	test   %edx,%ecx
8010124d:	74 25                	je     80101274 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010124f:	f7 d2                	not    %edx
  log_write(bp);
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101256:	21 ca                	and    %ecx,%edx
80101258:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010125c:	50                   	push   %eax
8010125d:	e8 3e 1d 00 00       	call   80102fa0 <log_write>
  brelse(bp);
80101262:	89 34 24             	mov    %esi,(%esp)
80101265:	e8 86 ef ff ff       	call   801001f0 <brelse>
}
8010126a:	83 c4 10             	add    $0x10,%esp
8010126d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101270:	5b                   	pop    %ebx
80101271:	5e                   	pop    %esi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret
    panic("freeing free block");
80101274:	83 ec 0c             	sub    $0xc,%esp
80101277:	68 ab 78 10 80       	push   $0x801078ab
8010127c:	e8 0f f1 ff ff       	call   80100390 <panic>
80101281:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101288:	00 
80101289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101290 <balloc>:
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101299:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
{
8010129f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012a2:	85 c9                	test   %ecx,%ecx
801012a4:	0f 84 87 00 00 00    	je     80101331 <balloc+0xa1>
801012aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012b4:	83 ec 08             	sub    $0x8,%esp
801012b7:	89 f0                	mov    %esi,%eax
801012b9:	c1 f8 0c             	sar    $0xc,%eax
801012bc:	03 05 f8 19 11 80    	add    0x801119f8,%eax
801012c2:	50                   	push   %eax
801012c3:	ff 75 d8             	push   -0x28(%ebp)
801012c6:	e8 05 ee ff ff       	call   801000d0 <bread>
801012cb:	83 c4 10             	add    $0x10,%esp
801012ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012d1:	a1 e0 19 11 80       	mov    0x801119e0,%eax
801012d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012d9:	31 c0                	xor    %eax,%eax
801012db:	eb 2f                	jmp    8010130c <balloc+0x7c>
801012dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012e0:	89 c1                	mov    %eax,%ecx
801012e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012ea:	83 e1 07             	and    $0x7,%ecx
801012ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012ef:	89 c1                	mov    %eax,%ecx
801012f1:	c1 f9 03             	sar    $0x3,%ecx
801012f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012f9:	89 fa                	mov    %edi,%edx
801012fb:	85 df                	test   %ebx,%edi
801012fd:	74 41                	je     80101340 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012ff:	83 c0 01             	add    $0x1,%eax
80101302:	83 c6 01             	add    $0x1,%esi
80101305:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010130a:	74 05                	je     80101311 <balloc+0x81>
8010130c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010130f:	77 cf                	ja     801012e0 <balloc+0x50>
    brelse(bp);
80101311:	83 ec 0c             	sub    $0xc,%esp
80101314:	ff 75 e4             	push   -0x1c(%ebp)
80101317:	e8 d4 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010131c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101323:	83 c4 10             	add    $0x10,%esp
80101326:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101329:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
8010132f:	77 80                	ja     801012b1 <balloc+0x21>
  panic("balloc: out of blocks");
80101331:	83 ec 0c             	sub    $0xc,%esp
80101334:	68 be 78 10 80       	push   $0x801078be
80101339:	e8 52 f0 ff ff       	call   80100390 <panic>
8010133e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101343:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101346:	09 da                	or     %ebx,%edx
80101348:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 4e 1c 00 00       	call   80102fa0 <log_write>
        brelse(bp);
80101352:	89 3c 24             	mov    %edi,(%esp)
80101355:	e8 96 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010135a:	58                   	pop    %eax
8010135b:	5a                   	pop    %edx
8010135c:	56                   	push   %esi
8010135d:	ff 75 d8             	push   -0x28(%ebp)
80101360:	e8 6b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101365:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101368:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010136a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010136d:	68 00 02 00 00       	push   $0x200
80101372:	6a 00                	push   $0x0
80101374:	50                   	push   %eax
80101375:	e8 d6 35 00 00       	call   80104950 <memset>
  log_write(bp);
8010137a:	89 1c 24             	mov    %ebx,(%esp)
8010137d:	e8 1e 1c 00 00       	call   80102fa0 <log_write>
  brelse(bp);
80101382:	89 1c 24             	mov    %ebx,(%esp)
80101385:	e8 66 ee ff ff       	call   801001f0 <brelse>
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010138d:	89 f0                	mov    %esi,%eax
8010138f:	5b                   	pop    %ebx
80101390:	5e                   	pop    %esi
80101391:	5f                   	pop    %edi
80101392:	5d                   	pop    %ebp
80101393:	c3                   	ret
80101394:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010139b:	00 
8010139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	89 c7                	mov    %eax,%edi
801013a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013a7:	31 f6                	xor    %esi,%esi
{
801013a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013aa:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
801013af:	83 ec 28             	sub    $0x28,%esp
801013b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013b5:	68 00 1a 11 80       	push   $0x80111a00
801013ba:	e8 81 34 00 00       	call   80104840 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013c2:	83 c4 10             	add    $0x10,%esp
801013c5:	eb 1b                	jmp    801013e2 <iget+0x42>
801013c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013ce:	00 
801013cf:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013d0:	39 3b                	cmp    %edi,(%ebx)
801013d2:	74 74                	je     80101448 <iget+0xa8>
801013d4:	81 c3 94 00 00 00    	add    $0x94,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013da:	81 fb 1c 37 11 80    	cmp    $0x8011371c,%ebx
801013e0:	73 26                	jae    80101408 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013e5:	85 c9                	test   %ecx,%ecx
801013e7:	7f e7                	jg     801013d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013e9:	85 f6                	test   %esi,%esi
801013eb:	75 e7                	jne    801013d4 <iget+0x34>
801013ed:	89 d8                	mov    %ebx,%eax
801013ef:	81 c3 94 00 00 00    	add    $0x94,%ebx
801013f5:	85 c9                	test   %ecx,%ecx
801013f7:	75 76                	jne    8010146f <iget+0xcf>
801013f9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013fb:	81 fb 1c 37 11 80    	cmp    $0x8011371c,%ebx
80101401:	72 df                	jb     801013e2 <iget+0x42>
80101403:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101408:	85 f6                	test   %esi,%esi
8010140a:	74 7b                	je     80101487 <iget+0xe7>
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  ip->mode = 7;
  release(&icache.lock);
8010140c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010140f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101411:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101414:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010141b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  ip->mode = 7;
80101422:	c7 86 90 00 00 00 07 	movl   $0x7,0x90(%esi)
80101429:	00 00 00 
  release(&icache.lock);
8010142c:	68 00 1a 11 80       	push   $0x80111a00
80101431:	e8 ca 34 00 00       	call   80104900 <release>

  return ip;
80101436:	83 c4 10             	add    $0x10,%esp
}
80101439:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010143c:	89 f0                	mov    %esi,%eax
8010143e:	5b                   	pop    %ebx
8010143f:	5e                   	pop    %esi
80101440:	5f                   	pop    %edi
80101441:	5d                   	pop    %ebp
80101442:	c3                   	ret
80101443:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101448:	39 53 04             	cmp    %edx,0x4(%ebx)
8010144b:	75 87                	jne    801013d4 <iget+0x34>
      release(&icache.lock);
8010144d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101450:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101453:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101455:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
8010145a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010145d:	e8 9e 34 00 00       	call   80104900 <release>
      return ip;
80101462:	83 c4 10             	add    $0x10,%esp
}
80101465:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101468:	89 f0                	mov    %esi,%eax
8010146a:	5b                   	pop    %ebx
8010146b:	5e                   	pop    %esi
8010146c:	5f                   	pop    %edi
8010146d:	5d                   	pop    %ebp
8010146e:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010146f:	81 fb 1c 37 11 80    	cmp    $0x8011371c,%ebx
80101475:	73 10                	jae    80101487 <iget+0xe7>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101477:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010147a:	85 c9                	test   %ecx,%ecx
8010147c:	0f 8f 4e ff ff ff    	jg     801013d0 <iget+0x30>
80101482:	e9 66 ff ff ff       	jmp    801013ed <iget+0x4d>
    panic("iget: no inodes");
80101487:	83 ec 0c             	sub    $0xc,%esp
8010148a:	68 d4 78 10 80       	push   $0x801078d4
8010148f:	e8 fc ee ff ff       	call   80100390 <panic>
80101494:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010149b:	00 
8010149c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	89 c6                	mov    %eax,%esi
801014a7:	53                   	push   %ebx
801014a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014ab:	83 fa 0b             	cmp    $0xb,%edx
801014ae:	0f 86 84 00 00 00    	jbe    80101538 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014b7:	83 fb 7f             	cmp    $0x7f,%ebx
801014ba:	0f 87 98 00 00 00    	ja     80101558 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014c6:	8b 16                	mov    (%esi),%edx
801014c8:	85 c0                	test   %eax,%eax
801014ca:	74 54                	je     80101520 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014cc:	83 ec 08             	sub    $0x8,%esp
801014cf:	50                   	push   %eax
801014d0:	52                   	push   %edx
801014d1:	e8 fa eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014d6:	83 c4 10             	add    $0x10,%esp
801014d9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801014dd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801014df:	8b 1a                	mov    (%edx),%ebx
801014e1:	85 db                	test   %ebx,%ebx
801014e3:	74 1b                	je     80101500 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014e5:	83 ec 0c             	sub    $0xc,%esp
801014e8:	57                   	push   %edi
801014e9:	e8 02 ed ff ff       	call   801001f0 <brelse>
    return addr;
801014ee:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801014f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f4:	89 d8                	mov    %ebx,%eax
801014f6:	5b                   	pop    %ebx
801014f7:	5e                   	pop    %esi
801014f8:	5f                   	pop    %edi
801014f9:	5d                   	pop    %ebp
801014fa:	c3                   	ret
801014fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      a[bn] = addr = balloc(ip->dev);
80101500:	8b 06                	mov    (%esi),%eax
80101502:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101505:	e8 86 fd ff ff       	call   80101290 <balloc>
8010150a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010150d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101510:	89 c3                	mov    %eax,%ebx
80101512:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101514:	57                   	push   %edi
80101515:	e8 86 1a 00 00       	call   80102fa0 <log_write>
8010151a:	83 c4 10             	add    $0x10,%esp
8010151d:	eb c6                	jmp    801014e5 <bmap+0x45>
8010151f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101520:	89 d0                	mov    %edx,%eax
80101522:	e8 69 fd ff ff       	call   80101290 <balloc>
80101527:	8b 16                	mov    (%esi),%edx
80101529:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010152f:	eb 9b                	jmp    801014cc <bmap+0x2c>
80101531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101538:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010153b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010153e:	85 db                	test   %ebx,%ebx
80101540:	75 af                	jne    801014f1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101542:	8b 00                	mov    (%eax),%eax
80101544:	e8 47 fd ff ff       	call   80101290 <balloc>
80101549:	89 47 5c             	mov    %eax,0x5c(%edi)
8010154c:	89 c3                	mov    %eax,%ebx
}
8010154e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101551:	89 d8                	mov    %ebx,%eax
80101553:	5b                   	pop    %ebx
80101554:	5e                   	pop    %esi
80101555:	5f                   	pop    %edi
80101556:	5d                   	pop    %ebp
80101557:	c3                   	ret
  panic("bmap: out of range");
80101558:	83 ec 0c             	sub    $0xc,%esp
8010155b:	68 e4 78 10 80       	push   $0x801078e4
80101560:	e8 2b ee ff ff       	call   80100390 <panic>
80101565:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010156c:	00 
8010156d:	8d 76 00             	lea    0x0(%esi),%esi

80101570 <readsb>:
{
80101570:	f3 0f 1e fb          	endbr32
80101574:	55                   	push   %ebp
80101575:	89 e5                	mov    %esp,%ebp
80101577:	56                   	push   %esi
80101578:	53                   	push   %ebx
80101579:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010157c:	83 ec 08             	sub    $0x8,%esp
8010157f:	6a 01                	push   $0x1
80101581:	ff 75 08             	push   0x8(%ebp)
80101584:	e8 47 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101589:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010158c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010158e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101591:	6a 1c                	push   $0x1c
80101593:	50                   	push   %eax
80101594:	56                   	push   %esi
80101595:	e8 56 34 00 00       	call   801049f0 <memmove>
  brelse(bp);
8010159a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010159d:	83 c4 10             	add    $0x10,%esp
}
801015a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015a3:	5b                   	pop    %ebx
801015a4:	5e                   	pop    %esi
801015a5:	5d                   	pop    %ebp
  brelse(bp);
801015a6:	e9 45 ec ff ff       	jmp    801001f0 <brelse>
801015ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801015b0 <iinit>:
{
801015b0:	f3 0f 1e fb          	endbr32
801015b4:	55                   	push   %ebp
801015b5:	89 e5                	mov    %esp,%ebp
801015b7:	53                   	push   %ebx
801015b8:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
801015bd:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015c0:	68 f7 78 10 80       	push   $0x801078f7
801015c5:	68 00 1a 11 80       	push   $0x80111a00
801015ca:	e8 f1 30 00 00       	call   801046c0 <initlock>
  for(i = 0; i < NINODE; i++) {
801015cf:	83 c4 10             	add    $0x10,%esp
801015d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	68 fe 78 10 80       	push   $0x801078fe
801015e0:	53                   	push   %ebx
801015e1:	81 c3 94 00 00 00    	add    $0x94,%ebx
801015e7:	e8 94 2f 00 00       	call   80104580 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015ec:	83 c4 10             	add    $0x10,%esp
801015ef:	81 fb 28 37 11 80    	cmp    $0x80113728,%ebx
801015f5:	75 e1                	jne    801015d8 <iinit+0x28>
  readsb(dev, &sb);
801015f7:	83 ec 08             	sub    $0x8,%esp
801015fa:	68 e0 19 11 80       	push   $0x801119e0
801015ff:	ff 75 08             	push   0x8(%ebp)
80101602:	e8 69 ff ff ff       	call   80101570 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101607:	ff 35 f8 19 11 80    	push   0x801119f8
8010160d:	ff 35 f4 19 11 80    	push   0x801119f4
80101613:	ff 35 f0 19 11 80    	push   0x801119f0
80101619:	ff 35 ec 19 11 80    	push   0x801119ec
8010161f:	ff 35 e8 19 11 80    	push   0x801119e8
80101625:	ff 35 e4 19 11 80    	push   0x801119e4
8010162b:	ff 35 e0 19 11 80    	push   0x801119e0
80101631:	68 a4 7d 10 80       	push   $0x80107da4
80101636:	e8 75 f0 ff ff       	call   801006b0 <cprintf>
}
8010163b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010163e:	83 c4 30             	add    $0x30,%esp
80101641:	c9                   	leave
80101642:	c3                   	ret
80101643:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010164a:	00 
8010164b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101650 <ialloc>:
{
80101650:	f3 0f 1e fb          	endbr32
80101654:	55                   	push   %ebp
80101655:	89 e5                	mov    %esp,%ebp
80101657:	57                   	push   %edi
80101658:	56                   	push   %esi
80101659:	53                   	push   %ebx
8010165a:	83 ec 1c             	sub    $0x1c,%esp
8010165d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101660:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
{
80101667:	8b 75 08             	mov    0x8(%ebp),%esi
8010166a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010166d:	0f 86 97 00 00 00    	jbe    8010170a <ialloc+0xba>
80101673:	bf 01 00 00 00       	mov    $0x1,%edi
80101678:	eb 1d                	jmp    80101697 <ialloc+0x47>
8010167a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101680:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101683:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101686:	53                   	push   %ebx
80101687:	e8 64 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010168c:	83 c4 10             	add    $0x10,%esp
8010168f:	3b 3d e8 19 11 80    	cmp    0x801119e8,%edi
80101695:	73 73                	jae    8010170a <ialloc+0xba>
    bp = bread(dev, IBLOCK(inum, sb));
80101697:	89 f8                	mov    %edi,%eax
80101699:	83 ec 08             	sub    $0x8,%esp
8010169c:	c1 e8 02             	shr    $0x2,%eax
8010169f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801016a5:	50                   	push   %eax
801016a6:	56                   	push   %esi
801016a7:	e8 24 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016ac:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016af:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016b1:	89 f8                	mov    %edi,%eax
801016b3:	83 e0 03             	and    $0x3,%eax
801016b6:	c1 e0 07             	shl    $0x7,%eax
801016b9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016c1:	75 bd                	jne    80101680 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016c3:	83 ec 04             	sub    $0x4,%esp
801016c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016c9:	68 80 00 00 00       	push   $0x80
801016ce:	6a 00                	push   $0x0
801016d0:	51                   	push   %ecx
801016d1:	e8 7a 32 00 00       	call   80104950 <memset>
      dip->type = type;
801016d6:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016da:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016dd:	66 89 01             	mov    %ax,(%ecx)
      dip->mode = 7;
801016e0:	c7 41 40 07 00 00 00 	movl   $0x7,0x40(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016e7:	89 1c 24             	mov    %ebx,(%esp)
801016ea:	e8 b1 18 00 00       	call   80102fa0 <log_write>
      brelse(bp);
801016ef:	89 1c 24             	mov    %ebx,(%esp)
801016f2:	e8 f9 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016f7:	83 c4 10             	add    $0x10,%esp
}
801016fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016fd:	89 fa                	mov    %edi,%edx
}
801016ff:	5b                   	pop    %ebx
      return iget(dev, inum);
80101700:	89 f0                	mov    %esi,%eax
}
80101702:	5e                   	pop    %esi
80101703:	5f                   	pop    %edi
80101704:	5d                   	pop    %ebp
      return iget(dev, inum);
80101705:	e9 96 fc ff ff       	jmp    801013a0 <iget>
  panic("ialloc: no inodes");
8010170a:	83 ec 0c             	sub    $0xc,%esp
8010170d:	68 04 79 10 80       	push   $0x80107904
80101712:	e8 79 ec ff ff       	call   80100390 <panic>
80101717:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010171e:	00 
8010171f:	90                   	nop

80101720 <iupdate>:
{
80101720:	f3 0f 1e fb          	endbr32
80101724:	55                   	push   %ebp
80101725:	89 e5                	mov    %esp,%ebp
80101727:	56                   	push   %esi
80101728:	53                   	push   %ebx
80101729:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010172c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101732:	83 ec 08             	sub    $0x8,%esp
80101735:	c1 e8 02             	shr    $0x2,%eax
80101738:	03 05 f4 19 11 80    	add    0x801119f4,%eax
8010173e:	50                   	push   %eax
8010173f:	ff 73 a4             	push   -0x5c(%ebx)
80101742:	e8 89 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101747:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101750:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101753:	83 e0 03             	and    $0x3,%eax
80101756:	c1 e0 07             	shl    $0x7,%eax
80101759:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010175d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101760:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101764:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101767:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010176b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010176f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101773:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101777:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010177b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010177e:	89 50 fc             	mov    %edx,-0x4(%eax)
  dip->mode = ip->mode;
80101781:	8b 53 34             	mov    0x34(%ebx),%edx
80101784:	89 50 34             	mov    %edx,0x34(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101787:	6a 34                	push   $0x34
80101789:	53                   	push   %ebx
8010178a:	50                   	push   %eax
8010178b:	e8 60 32 00 00       	call   801049f0 <memmove>
  log_write(bp);
80101790:	89 34 24             	mov    %esi,(%esp)
80101793:	e8 08 18 00 00       	call   80102fa0 <log_write>
  brelse(bp);
80101798:	89 75 08             	mov    %esi,0x8(%ebp)
8010179b:	83 c4 10             	add    $0x10,%esp
}
8010179e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a1:	5b                   	pop    %ebx
801017a2:	5e                   	pop    %esi
801017a3:	5d                   	pop    %ebp
  brelse(bp);
801017a4:	e9 47 ea ff ff       	jmp    801001f0 <brelse>
801017a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801017b0 <idup>:
{
801017b0:	f3 0f 1e fb          	endbr32
801017b4:	55                   	push   %ebp
801017b5:	89 e5                	mov    %esp,%ebp
801017b7:	53                   	push   %ebx
801017b8:	83 ec 10             	sub    $0x10,%esp
801017bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017be:	68 00 1a 11 80       	push   $0x80111a00
801017c3:	e8 78 30 00 00       	call   80104840 <acquire>
  ip->ref++;
801017c8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017cc:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801017d3:	e8 28 31 00 00       	call   80104900 <release>
}
801017d8:	89 d8                	mov    %ebx,%eax
801017da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017dd:	c9                   	leave
801017de:	c3                   	ret
801017df:	90                   	nop

801017e0 <ilock>:
{
801017e0:	f3 0f 1e fb          	endbr32
801017e4:	55                   	push   %ebp
801017e5:	89 e5                	mov    %esp,%ebp
801017e7:	56                   	push   %esi
801017e8:	53                   	push   %ebx
801017e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017ec:	85 db                	test   %ebx,%ebx
801017ee:	0f 84 bc 00 00 00    	je     801018b0 <ilock+0xd0>
801017f4:	8b 53 08             	mov    0x8(%ebx),%edx
801017f7:	85 d2                	test   %edx,%edx
801017f9:	0f 8e b1 00 00 00    	jle    801018b0 <ilock+0xd0>
  acquiresleep(&ip->lock);
801017ff:	83 ec 0c             	sub    $0xc,%esp
80101802:	8d 43 0c             	lea    0xc(%ebx),%eax
80101805:	50                   	push   %eax
80101806:	e8 b5 2d 00 00       	call   801045c0 <acquiresleep>
  if(ip->valid == 0){
8010180b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010180e:	83 c4 10             	add    $0x10,%esp
80101811:	85 c0                	test   %eax,%eax
80101813:	74 0b                	je     80101820 <ilock+0x40>
}
80101815:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101818:	5b                   	pop    %ebx
80101819:	5e                   	pop    %esi
8010181a:	5d                   	pop    %ebp
8010181b:	c3                   	ret
8010181c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101820:	8b 43 04             	mov    0x4(%ebx),%eax
80101823:	83 ec 08             	sub    $0x8,%esp
80101826:	c1 e8 02             	shr    $0x2,%eax
80101829:	03 05 f4 19 11 80    	add    0x801119f4,%eax
8010182f:	50                   	push   %eax
80101830:	ff 33                	push   (%ebx)
80101832:	e8 99 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101837:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010183a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010183c:	8b 43 04             	mov    0x4(%ebx),%eax
8010183f:	83 e0 03             	and    $0x3,%eax
80101842:	c1 e0 07             	shl    $0x7,%eax
80101845:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101849:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010184c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010184f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101853:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101857:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010185b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010185f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101863:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101867:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010186b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010186e:	89 53 58             	mov    %edx,0x58(%ebx)
    ip->mode = dip->mode;
80101871:	8b 50 34             	mov    0x34(%eax),%edx
80101874:	89 93 90 00 00 00    	mov    %edx,0x90(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010187a:	6a 34                	push   $0x34
8010187c:	50                   	push   %eax
8010187d:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101880:	50                   	push   %eax
80101881:	e8 6a 31 00 00       	call   801049f0 <memmove>
    brelse(bp);
80101886:	89 34 24             	mov    %esi,(%esp)
80101889:	e8 62 e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
8010188e:	83 c4 10             	add    $0x10,%esp
80101891:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101896:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010189d:	0f 85 72 ff ff ff    	jne    80101815 <ilock+0x35>
      panic("ilock: no type");
801018a3:	83 ec 0c             	sub    $0xc,%esp
801018a6:	68 1c 79 10 80       	push   $0x8010791c
801018ab:	e8 e0 ea ff ff       	call   80100390 <panic>
    panic("ilock");
801018b0:	83 ec 0c             	sub    $0xc,%esp
801018b3:	68 16 79 10 80       	push   $0x80107916
801018b8:	e8 d3 ea ff ff       	call   80100390 <panic>
801018bd:	8d 76 00             	lea    0x0(%esi),%esi

801018c0 <iunlock>:
{
801018c0:	f3 0f 1e fb          	endbr32
801018c4:	55                   	push   %ebp
801018c5:	89 e5                	mov    %esp,%ebp
801018c7:	56                   	push   %esi
801018c8:	53                   	push   %ebx
801018c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018cc:	85 db                	test   %ebx,%ebx
801018ce:	74 28                	je     801018f8 <iunlock+0x38>
801018d0:	83 ec 0c             	sub    $0xc,%esp
801018d3:	8d 73 0c             	lea    0xc(%ebx),%esi
801018d6:	56                   	push   %esi
801018d7:	e8 84 2d 00 00       	call   80104660 <holdingsleep>
801018dc:	83 c4 10             	add    $0x10,%esp
801018df:	85 c0                	test   %eax,%eax
801018e1:	74 15                	je     801018f8 <iunlock+0x38>
801018e3:	8b 43 08             	mov    0x8(%ebx),%eax
801018e6:	85 c0                	test   %eax,%eax
801018e8:	7e 0e                	jle    801018f8 <iunlock+0x38>
  releasesleep(&ip->lock);
801018ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018f0:	5b                   	pop    %ebx
801018f1:	5e                   	pop    %esi
801018f2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018f3:	e9 28 2d 00 00       	jmp    80104620 <releasesleep>
    panic("iunlock");
801018f8:	83 ec 0c             	sub    $0xc,%esp
801018fb:	68 2b 79 10 80       	push   $0x8010792b
80101900:	e8 8b ea ff ff       	call   80100390 <panic>
80101905:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010190c:	00 
8010190d:	8d 76 00             	lea    0x0(%esi),%esi

80101910 <iput>:
{
80101910:	f3 0f 1e fb          	endbr32
80101914:	55                   	push   %ebp
80101915:	89 e5                	mov    %esp,%ebp
80101917:	57                   	push   %edi
80101918:	56                   	push   %esi
80101919:	53                   	push   %ebx
8010191a:	83 ec 28             	sub    $0x28,%esp
8010191d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101920:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101923:	57                   	push   %edi
80101924:	e8 97 2c 00 00       	call   801045c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101929:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010192c:	83 c4 10             	add    $0x10,%esp
8010192f:	85 d2                	test   %edx,%edx
80101931:	74 07                	je     8010193a <iput+0x2a>
80101933:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101938:	74 36                	je     80101970 <iput+0x60>
  releasesleep(&ip->lock);
8010193a:	83 ec 0c             	sub    $0xc,%esp
8010193d:	57                   	push   %edi
8010193e:	e8 dd 2c 00 00       	call   80104620 <releasesleep>
  acquire(&icache.lock);
80101943:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010194a:	e8 f1 2e 00 00       	call   80104840 <acquire>
  ip->ref--;
8010194f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101953:	83 c4 10             	add    $0x10,%esp
80101956:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
8010195d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101960:	5b                   	pop    %ebx
80101961:	5e                   	pop    %esi
80101962:	5f                   	pop    %edi
80101963:	5d                   	pop    %ebp
  release(&icache.lock);
80101964:	e9 97 2f 00 00       	jmp    80104900 <release>
80101969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101970:	83 ec 0c             	sub    $0xc,%esp
80101973:	68 00 1a 11 80       	push   $0x80111a00
80101978:	e8 c3 2e 00 00       	call   80104840 <acquire>
    int r = ip->ref;
8010197d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101980:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101987:	e8 74 2f 00 00       	call   80104900 <release>
    if(r == 1){
8010198c:	83 c4 10             	add    $0x10,%esp
8010198f:	83 fe 01             	cmp    $0x1,%esi
80101992:	75 a6                	jne    8010193a <iput+0x2a>
80101994:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010199a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010199d:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019a0:	89 cf                	mov    %ecx,%edi
801019a2:	eb 0b                	jmp    801019af <iput+0x9f>
801019a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019a8:	83 c6 04             	add    $0x4,%esi
801019ab:	39 fe                	cmp    %edi,%esi
801019ad:	74 19                	je     801019c8 <iput+0xb8>
    if(ip->addrs[i]){
801019af:	8b 16                	mov    (%esi),%edx
801019b1:	85 d2                	test   %edx,%edx
801019b3:	74 f3                	je     801019a8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
801019b5:	8b 03                	mov    (%ebx),%eax
801019b7:	e8 54 f8 ff ff       	call   80101210 <bfree>
      ip->addrs[i] = 0;
801019bc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019c2:	eb e4                	jmp    801019a8 <iput+0x98>
801019c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019c8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019d1:	85 c0                	test   %eax,%eax
801019d3:	75 33                	jne    80101a08 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019d5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019d8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019df:	53                   	push   %ebx
801019e0:	e8 3b fd ff ff       	call   80101720 <iupdate>
      ip->type = 0;
801019e5:	31 c0                	xor    %eax,%eax
801019e7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019eb:	89 1c 24             	mov    %ebx,(%esp)
801019ee:	e8 2d fd ff ff       	call   80101720 <iupdate>
      ip->valid = 0;
801019f3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019fa:	83 c4 10             	add    $0x10,%esp
801019fd:	e9 38 ff ff ff       	jmp    8010193a <iput+0x2a>
80101a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a08:	83 ec 08             	sub    $0x8,%esp
80101a0b:	50                   	push   %eax
80101a0c:	ff 33                	push   (%ebx)
80101a0e:	e8 bd e6 ff ff       	call   801000d0 <bread>
80101a13:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a16:	83 c4 10             	add    $0x10,%esp
80101a19:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a22:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a25:	89 cf                	mov    %ecx,%edi
80101a27:	eb 0e                	jmp    80101a37 <iput+0x127>
80101a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a30:	83 c6 04             	add    $0x4,%esi
80101a33:	39 f7                	cmp    %esi,%edi
80101a35:	74 19                	je     80101a50 <iput+0x140>
      if(a[j])
80101a37:	8b 16                	mov    (%esi),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x120>
        bfree(ip->dev, a[j]);
80101a3d:	8b 03                	mov    (%ebx),%eax
80101a3f:	e8 cc f7 ff ff       	call   80101210 <bfree>
80101a44:	eb ea                	jmp    80101a30 <iput+0x120>
80101a46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a4d:	00 
80101a4e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	ff 75 e4             	push   -0x1c(%ebp)
80101a56:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a59:	e8 92 e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a5e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a64:	8b 03                	mov    (%ebx),%eax
80101a66:	e8 a5 f7 ff ff       	call   80101210 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a6b:	83 c4 10             	add    $0x10,%esp
80101a6e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a75:	00 00 00 
80101a78:	e9 58 ff ff ff       	jmp    801019d5 <iput+0xc5>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <iunlockput>:
{
80101a80:	f3 0f 1e fb          	endbr32
80101a84:	55                   	push   %ebp
80101a85:	89 e5                	mov    %esp,%ebp
80101a87:	53                   	push   %ebx
80101a88:	83 ec 10             	sub    $0x10,%esp
80101a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a8e:	53                   	push   %ebx
80101a8f:	e8 2c fe ff ff       	call   801018c0 <iunlock>
  iput(ip);
80101a94:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a97:	83 c4 10             	add    $0x10,%esp
}
80101a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a9d:	c9                   	leave
  iput(ip);
80101a9e:	e9 6d fe ff ff       	jmp    80101910 <iput>
80101aa3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101aaa:	00 
80101aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ab0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ab0:	f3 0f 1e fb          	endbr32
80101ab4:	55                   	push   %ebp
80101ab5:	89 e5                	mov    %esp,%ebp
80101ab7:	8b 55 08             	mov    0x8(%ebp),%edx
80101aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101abd:	8b 0a                	mov    (%edx),%ecx
80101abf:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ac2:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ac5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ac8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101acc:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101acf:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101ad3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ad7:	8b 4a 58             	mov    0x58(%edx),%ecx
80101ada:	89 48 10             	mov    %ecx,0x10(%eax)
  st->mode = ip->mode;
80101add:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
80101ae3:	89 50 14             	mov    %edx,0x14(%eax)
}
80101ae6:	5d                   	pop    %ebp
80101ae7:	c3                   	ret
80101ae8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101aef:	00 

80101af0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101af0:	f3 0f 1e fb          	endbr32
80101af4:	55                   	push   %ebp
80101af5:	89 e5                	mov    %esp,%ebp
80101af7:	57                   	push   %edi
80101af8:	56                   	push   %esi
80101af9:	53                   	push   %ebx
80101afa:	83 ec 1c             	sub    $0x1c,%esp
80101afd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101b00:	8b 45 08             	mov    0x8(%ebp),%eax
80101b03:	8b 75 10             	mov    0x10(%ebp),%esi
80101b06:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b09:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b0c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b11:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b14:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b17:	0f 84 a3 00 00 00    	je     80101bc0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b20:	8b 40 58             	mov    0x58(%eax),%eax
80101b23:	39 c6                	cmp    %eax,%esi
80101b25:	0f 87 b6 00 00 00    	ja     80101be1 <readi+0xf1>
80101b2b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2e:	31 c9                	xor    %ecx,%ecx
80101b30:	89 da                	mov    %ebx,%edx
80101b32:	01 f2                	add    %esi,%edx
80101b34:	0f 92 c1             	setb   %cl
80101b37:	89 cf                	mov    %ecx,%edi
80101b39:	0f 82 a2 00 00 00    	jb     80101be1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b3f:	89 c1                	mov    %eax,%ecx
80101b41:	29 f1                	sub    %esi,%ecx
80101b43:	39 d0                	cmp    %edx,%eax
80101b45:	0f 43 cb             	cmovae %ebx,%ecx
80101b48:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4b:	85 c9                	test   %ecx,%ecx
80101b4d:	74 63                	je     80101bb2 <readi+0xc2>
80101b4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b50:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b53:	89 f2                	mov    %esi,%edx
80101b55:	c1 ea 09             	shr    $0x9,%edx
80101b58:	89 d8                	mov    %ebx,%eax
80101b5a:	e8 41 f9 ff ff       	call   801014a0 <bmap>
80101b5f:	83 ec 08             	sub    $0x8,%esp
80101b62:	50                   	push   %eax
80101b63:	ff 33                	push   (%ebx)
80101b65:	e8 66 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b72:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b75:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b77:	89 f0                	mov    %esi,%eax
80101b79:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b7e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b80:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b83:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b85:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b89:	39 d9                	cmp    %ebx,%ecx
80101b8b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b8e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b8f:	01 df                	add    %ebx,%edi
80101b91:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b93:	50                   	push   %eax
80101b94:	ff 75 e0             	push   -0x20(%ebp)
80101b97:	e8 54 2e 00 00       	call   801049f0 <memmove>
    brelse(bp);
80101b9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b9f:	89 14 24             	mov    %edx,(%esp)
80101ba2:	e8 49 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ba7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101baa:	83 c4 10             	add    $0x10,%esp
80101bad:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bb0:	77 9e                	ja     80101b50 <readi+0x60>
  }
  return n;
80101bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bb8:	5b                   	pop    %ebx
80101bb9:	5e                   	pop    %esi
80101bba:	5f                   	pop    %edi
80101bbb:	5d                   	pop    %ebp
80101bbc:	c3                   	ret
80101bbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bc4:	66 83 f8 09          	cmp    $0x9,%ax
80101bc8:	77 17                	ja     80101be1 <readi+0xf1>
80101bca:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101bd1:	85 c0                	test   %eax,%eax
80101bd3:	74 0c                	je     80101be1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bd5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bdb:	5b                   	pop    %ebx
80101bdc:	5e                   	pop    %esi
80101bdd:	5f                   	pop    %edi
80101bde:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bdf:	ff e0                	jmp    *%eax
      return -1;
80101be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101be6:	eb cd                	jmp    80101bb5 <readi+0xc5>
80101be8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101bef:	00 

80101bf0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bf0:	f3 0f 1e fb          	endbr32
80101bf4:	55                   	push   %ebp
80101bf5:	89 e5                	mov    %esp,%ebp
80101bf7:	57                   	push   %edi
80101bf8:	56                   	push   %esi
80101bf9:	53                   	push   %ebx
80101bfa:	83 ec 1c             	sub    $0x1c,%esp
80101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101c00:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c03:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c06:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c0b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c11:	8b 75 10             	mov    0x10(%ebp),%esi
80101c14:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c17:	0f 84 b3 00 00 00    	je     80101cd0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c20:	39 70 58             	cmp    %esi,0x58(%eax)
80101c23:	0f 82 e3 00 00 00    	jb     80101d0c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c29:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c2c:	89 f8                	mov    %edi,%eax
80101c2e:	01 f0                	add    %esi,%eax
80101c30:	0f 82 d6 00 00 00    	jb     80101d0c <writei+0x11c>
80101c36:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c3b:	0f 87 cb 00 00 00    	ja     80101d0c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c41:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c48:	85 ff                	test   %edi,%edi
80101c4a:	74 75                	je     80101cc1 <writei+0xd1>
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c50:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c53:	89 f2                	mov    %esi,%edx
80101c55:	c1 ea 09             	shr    $0x9,%edx
80101c58:	89 f8                	mov    %edi,%eax
80101c5a:	e8 41 f8 ff ff       	call   801014a0 <bmap>
80101c5f:	83 ec 08             	sub    $0x8,%esp
80101c62:	50                   	push   %eax
80101c63:	ff 37                	push   (%edi)
80101c65:	e8 66 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c6a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c6f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c72:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c75:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c77:	89 f0                	mov    %esi,%eax
80101c79:	83 c4 0c             	add    $0xc,%esp
80101c7c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c81:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c83:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c87:	39 d9                	cmp    %ebx,%ecx
80101c89:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c8c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c8d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c8f:	ff 75 dc             	push   -0x24(%ebp)
80101c92:	50                   	push   %eax
80101c93:	e8 58 2d 00 00       	call   801049f0 <memmove>
    log_write(bp);
80101c98:	89 3c 24             	mov    %edi,(%esp)
80101c9b:	e8 00 13 00 00       	call   80102fa0 <log_write>
    brelse(bp);
80101ca0:	89 3c 24             	mov    %edi,(%esp)
80101ca3:	e8 48 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cab:	83 c4 10             	add    $0x10,%esp
80101cae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cb1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cb4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101cb7:	77 97                	ja     80101c50 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101cbf:	77 37                	ja     80101cf8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cc7:	5b                   	pop    %ebx
80101cc8:	5e                   	pop    %esi
80101cc9:	5f                   	pop    %edi
80101cca:	5d                   	pop    %ebp
80101ccb:	c3                   	ret
80101ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cd4:	66 83 f8 09          	cmp    $0x9,%ax
80101cd8:	77 32                	ja     80101d0c <writei+0x11c>
80101cda:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80101ce1:	85 c0                	test   %eax,%eax
80101ce3:	74 27                	je     80101d0c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101ce5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ceb:	5b                   	pop    %ebx
80101cec:	5e                   	pop    %esi
80101ced:	5f                   	pop    %edi
80101cee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cef:	ff e0                	jmp    *%eax
80101cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101cf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cfb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cfe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d01:	50                   	push   %eax
80101d02:	e8 19 fa ff ff       	call   80101720 <iupdate>
80101d07:	83 c4 10             	add    $0x10,%esp
80101d0a:	eb b5                	jmp    80101cc1 <writei+0xd1>
      return -1;
80101d0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d11:	eb b1                	jmp    80101cc4 <writei+0xd4>
80101d13:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d1a:	00 
80101d1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101d20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d20:	f3 0f 1e fb          	endbr32
80101d24:	55                   	push   %ebp
80101d25:	89 e5                	mov    %esp,%ebp
80101d27:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d2a:	6a 0e                	push   $0xe
80101d2c:	ff 75 0c             	push   0xc(%ebp)
80101d2f:	ff 75 08             	push   0x8(%ebp)
80101d32:	e8 29 2d 00 00       	call   80104a60 <strncmp>
}
80101d37:	c9                   	leave
80101d38:	c3                   	ret
80101d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d40:	f3 0f 1e fb          	endbr32
80101d44:	55                   	push   %ebp
80101d45:	89 e5                	mov    %esp,%ebp
80101d47:	57                   	push   %edi
80101d48:	56                   	push   %esi
80101d49:	53                   	push   %ebx
80101d4a:	83 ec 1c             	sub    $0x1c,%esp
80101d4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d50:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d55:	0f 85 89 00 00 00    	jne    80101de4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d5b:	8b 53 58             	mov    0x58(%ebx),%edx
80101d5e:	31 ff                	xor    %edi,%edi
80101d60:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d63:	85 d2                	test   %edx,%edx
80101d65:	74 42                	je     80101da9 <dirlookup+0x69>
80101d67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d6e:	00 
80101d6f:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d70:	6a 10                	push   $0x10
80101d72:	57                   	push   %edi
80101d73:	56                   	push   %esi
80101d74:	53                   	push   %ebx
80101d75:	e8 76 fd ff ff       	call   80101af0 <readi>
80101d7a:	83 c4 10             	add    $0x10,%esp
80101d7d:	83 f8 10             	cmp    $0x10,%eax
80101d80:	75 55                	jne    80101dd7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d82:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d87:	74 18                	je     80101da1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d89:	83 ec 04             	sub    $0x4,%esp
80101d8c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d8f:	6a 0e                	push   $0xe
80101d91:	50                   	push   %eax
80101d92:	ff 75 0c             	push   0xc(%ebp)
80101d95:	e8 c6 2c 00 00       	call   80104a60 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d9a:	83 c4 10             	add    $0x10,%esp
80101d9d:	85 c0                	test   %eax,%eax
80101d9f:	74 17                	je     80101db8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101da1:	83 c7 10             	add    $0x10,%edi
80101da4:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101da7:	72 c7                	jb     80101d70 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101dac:	31 c0                	xor    %eax,%eax
}
80101dae:	5b                   	pop    %ebx
80101daf:	5e                   	pop    %esi
80101db0:	5f                   	pop    %edi
80101db1:	5d                   	pop    %ebp
80101db2:	c3                   	ret
80101db3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101db8:	8b 45 10             	mov    0x10(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	74 05                	je     80101dc4 <dirlookup+0x84>
        *poff = off;
80101dbf:	8b 45 10             	mov    0x10(%ebp),%eax
80101dc2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dc4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dc8:	8b 03                	mov    (%ebx),%eax
80101dca:	e8 d1 f5 ff ff       	call   801013a0 <iget>
}
80101dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd2:	5b                   	pop    %ebx
80101dd3:	5e                   	pop    %esi
80101dd4:	5f                   	pop    %edi
80101dd5:	5d                   	pop    %ebp
80101dd6:	c3                   	ret
      panic("dirlookup read");
80101dd7:	83 ec 0c             	sub    $0xc,%esp
80101dda:	68 45 79 10 80       	push   $0x80107945
80101ddf:	e8 ac e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101de4:	83 ec 0c             	sub    $0xc,%esp
80101de7:	68 33 79 10 80       	push   $0x80107933
80101dec:	e8 9f e5 ff ff       	call   80100390 <panic>
80101df1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101df8:	00 
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	89 c3                	mov    %eax,%ebx
80101e08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e0e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e14:	0f 84 86 01 00 00    	je     80101fa0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e1a:	e8 11 1c 00 00       	call   80103a30 <myproc>
  acquire(&icache.lock);
80101e1f:	83 ec 0c             	sub    $0xc,%esp
80101e22:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101e24:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e27:	68 00 1a 11 80       	push   $0x80111a00
80101e2c:	e8 0f 2a 00 00       	call   80104840 <acquire>
  ip->ref++;
80101e31:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e35:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101e3c:	e8 bf 2a 00 00       	call   80104900 <release>
80101e41:	83 c4 10             	add    $0x10,%esp
80101e44:	eb 0d                	jmp    80101e53 <namex+0x53>
80101e46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e4d:	00 
80101e4e:	66 90                	xchg   %ax,%ax
    path++;
80101e50:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e53:	0f b6 07             	movzbl (%edi),%eax
80101e56:	3c 2f                	cmp    $0x2f,%al
80101e58:	74 f6                	je     80101e50 <namex+0x50>
  if(*path == 0)
80101e5a:	84 c0                	test   %al,%al
80101e5c:	0f 84 ee 00 00 00    	je     80101f50 <namex+0x150>
  while(*path != '/' && *path != 0)
80101e62:	0f b6 07             	movzbl (%edi),%eax
80101e65:	84 c0                	test   %al,%al
80101e67:	0f 84 fb 00 00 00    	je     80101f68 <namex+0x168>
80101e6d:	89 fb                	mov    %edi,%ebx
80101e6f:	3c 2f                	cmp    $0x2f,%al
80101e71:	0f 84 f1 00 00 00    	je     80101f68 <namex+0x168>
80101e77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e7e:	00 
80101e7f:	90                   	nop
80101e80:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e84:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e87:	3c 2f                	cmp    $0x2f,%al
80101e89:	74 04                	je     80101e8f <namex+0x8f>
80101e8b:	84 c0                	test   %al,%al
80101e8d:	75 f1                	jne    80101e80 <namex+0x80>
  len = path - s;
80101e8f:	89 d8                	mov    %ebx,%eax
80101e91:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e93:	83 f8 0d             	cmp    $0xd,%eax
80101e96:	0f 8e 84 00 00 00    	jle    80101f20 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e9c:	83 ec 04             	sub    $0x4,%esp
80101e9f:	6a 0e                	push   $0xe
80101ea1:	57                   	push   %edi
    path++;
80101ea2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101ea4:	ff 75 e4             	push   -0x1c(%ebp)
80101ea7:	e8 44 2b 00 00       	call   801049f0 <memmove>
80101eac:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101eaf:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101eb2:	75 0c                	jne    80101ec0 <namex+0xc0>
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101eb8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101ebb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101ebe:	74 f8                	je     80101eb8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	56                   	push   %esi
80101ec4:	e8 17 f9 ff ff       	call   801017e0 <ilock>
    if(ip->type != T_DIR){
80101ec9:	83 c4 10             	add    $0x10,%esp
80101ecc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ed1:	0f 85 a1 00 00 00    	jne    80101f78 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ed7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eda:	85 d2                	test   %edx,%edx
80101edc:	74 09                	je     80101ee7 <namex+0xe7>
80101ede:	80 3f 00             	cmpb   $0x0,(%edi)
80101ee1:	0f 84 d9 00 00 00    	je     80101fc0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ee7:	83 ec 04             	sub    $0x4,%esp
80101eea:	6a 00                	push   $0x0
80101eec:	ff 75 e4             	push   -0x1c(%ebp)
80101eef:	56                   	push   %esi
80101ef0:	e8 4b fe ff ff       	call   80101d40 <dirlookup>
80101ef5:	83 c4 10             	add    $0x10,%esp
80101ef8:	89 c3                	mov    %eax,%ebx
80101efa:	85 c0                	test   %eax,%eax
80101efc:	74 7a                	je     80101f78 <namex+0x178>
  iunlock(ip);
80101efe:	83 ec 0c             	sub    $0xc,%esp
80101f01:	56                   	push   %esi
80101f02:	e8 b9 f9 ff ff       	call   801018c0 <iunlock>
  iput(ip);
80101f07:	89 34 24             	mov    %esi,(%esp)
80101f0a:	89 de                	mov    %ebx,%esi
80101f0c:	e8 ff f9 ff ff       	call   80101910 <iput>
80101f11:	83 c4 10             	add    $0x10,%esp
80101f14:	e9 3a ff ff ff       	jmp    80101e53 <namex+0x53>
80101f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f23:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101f26:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101f29:	83 ec 04             	sub    $0x4,%esp
80101f2c:	50                   	push   %eax
80101f2d:	57                   	push   %edi
    name[len] = 0;
80101f2e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101f30:	ff 75 e4             	push   -0x1c(%ebp)
80101f33:	e8 b8 2a 00 00       	call   801049f0 <memmove>
    name[len] = 0;
80101f38:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f3b:	83 c4 10             	add    $0x10,%esp
80101f3e:	c6 00 00             	movb   $0x0,(%eax)
80101f41:	e9 69 ff ff ff       	jmp    80101eaf <namex+0xaf>
80101f46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f4d:	00 
80101f4e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f53:	85 c0                	test   %eax,%eax
80101f55:	0f 85 85 00 00 00    	jne    80101fe0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5e:	89 f0                	mov    %esi,%eax
80101f60:	5b                   	pop    %ebx
80101f61:	5e                   	pop    %esi
80101f62:	5f                   	pop    %edi
80101f63:	5d                   	pop    %ebp
80101f64:	c3                   	ret
80101f65:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101f68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f6b:	89 fb                	mov    %edi,%ebx
80101f6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101f70:	31 c0                	xor    %eax,%eax
80101f72:	eb b5                	jmp    80101f29 <namex+0x129>
80101f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f78:	83 ec 0c             	sub    $0xc,%esp
80101f7b:	56                   	push   %esi
80101f7c:	e8 3f f9 ff ff       	call   801018c0 <iunlock>
  iput(ip);
80101f81:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f84:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f86:	e8 85 f9 ff ff       	call   80101910 <iput>
      return 0;
80101f8b:	83 c4 10             	add    $0x10,%esp
}
80101f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f91:	89 f0                	mov    %esi,%eax
80101f93:	5b                   	pop    %ebx
80101f94:	5e                   	pop    %esi
80101f95:	5f                   	pop    %edi
80101f96:	5d                   	pop    %ebp
80101f97:	c3                   	ret
80101f98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f9f:	00 
    ip = iget(ROOTDEV, ROOTINO);
80101fa0:	ba 01 00 00 00       	mov    $0x1,%edx
80101fa5:	b8 01 00 00 00       	mov    $0x1,%eax
80101faa:	89 df                	mov    %ebx,%edi
80101fac:	e8 ef f3 ff ff       	call   801013a0 <iget>
80101fb1:	89 c6                	mov    %eax,%esi
80101fb3:	e9 9b fe ff ff       	jmp    80101e53 <namex+0x53>
80101fb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101fbf:	00 
      iunlock(ip);
80101fc0:	83 ec 0c             	sub    $0xc,%esp
80101fc3:	56                   	push   %esi
80101fc4:	e8 f7 f8 ff ff       	call   801018c0 <iunlock>
      return ip;
80101fc9:	83 c4 10             	add    $0x10,%esp
}
80101fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fcf:	89 f0                	mov    %esi,%eax
80101fd1:	5b                   	pop    %ebx
80101fd2:	5e                   	pop    %esi
80101fd3:	5f                   	pop    %edi
80101fd4:	5d                   	pop    %ebp
80101fd5:	c3                   	ret
80101fd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101fdd:	00 
80101fde:	66 90                	xchg   %ax,%ax
    iput(ip);
80101fe0:	83 ec 0c             	sub    $0xc,%esp
80101fe3:	56                   	push   %esi
    return 0;
80101fe4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fe6:	e8 25 f9 ff ff       	call   80101910 <iput>
    return 0;
80101feb:	83 c4 10             	add    $0x10,%esp
80101fee:	e9 68 ff ff ff       	jmp    80101f5b <namex+0x15b>
80101ff3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101ffa:	00 
80101ffb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102000 <dirlink>:
{
80102000:	f3 0f 1e fb          	endbr32
80102004:	55                   	push   %ebp
80102005:	89 e5                	mov    %esp,%ebp
80102007:	57                   	push   %edi
80102008:	56                   	push   %esi
80102009:	53                   	push   %ebx
8010200a:	83 ec 20             	sub    $0x20,%esp
8010200d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102010:	6a 00                	push   $0x0
80102012:	ff 75 0c             	push   0xc(%ebp)
80102015:	53                   	push   %ebx
80102016:	e8 25 fd ff ff       	call   80101d40 <dirlookup>
8010201b:	83 c4 10             	add    $0x10,%esp
8010201e:	85 c0                	test   %eax,%eax
80102020:	75 6b                	jne    8010208d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102022:	8b 7b 58             	mov    0x58(%ebx),%edi
80102025:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102028:	85 ff                	test   %edi,%edi
8010202a:	74 2d                	je     80102059 <dirlink+0x59>
8010202c:	31 ff                	xor    %edi,%edi
8010202e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102031:	eb 0d                	jmp    80102040 <dirlink+0x40>
80102033:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102038:	83 c7 10             	add    $0x10,%edi
8010203b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010203e:	73 19                	jae    80102059 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102040:	6a 10                	push   $0x10
80102042:	57                   	push   %edi
80102043:	56                   	push   %esi
80102044:	53                   	push   %ebx
80102045:	e8 a6 fa ff ff       	call   80101af0 <readi>
8010204a:	83 c4 10             	add    $0x10,%esp
8010204d:	83 f8 10             	cmp    $0x10,%eax
80102050:	75 4e                	jne    801020a0 <dirlink+0xa0>
    if(de.inum == 0)
80102052:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102057:	75 df                	jne    80102038 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102059:	83 ec 04             	sub    $0x4,%esp
8010205c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010205f:	6a 0e                	push   $0xe
80102061:	ff 75 0c             	push   0xc(%ebp)
80102064:	50                   	push   %eax
80102065:	e8 46 2a 00 00       	call   80104ab0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010206a:	6a 10                	push   $0x10
  de.inum = inum;
8010206c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010206f:	57                   	push   %edi
80102070:	56                   	push   %esi
80102071:	53                   	push   %ebx
  de.inum = inum;
80102072:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102076:	e8 75 fb ff ff       	call   80101bf0 <writei>
8010207b:	83 c4 20             	add    $0x20,%esp
8010207e:	83 f8 10             	cmp    $0x10,%eax
80102081:	75 2a                	jne    801020ad <dirlink+0xad>
  return 0;
80102083:	31 c0                	xor    %eax,%eax
}
80102085:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102088:	5b                   	pop    %ebx
80102089:	5e                   	pop    %esi
8010208a:	5f                   	pop    %edi
8010208b:	5d                   	pop    %ebp
8010208c:	c3                   	ret
    iput(ip);
8010208d:	83 ec 0c             	sub    $0xc,%esp
80102090:	50                   	push   %eax
80102091:	e8 7a f8 ff ff       	call   80101910 <iput>
    return -1;
80102096:	83 c4 10             	add    $0x10,%esp
80102099:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010209e:	eb e5                	jmp    80102085 <dirlink+0x85>
      panic("dirlink read");
801020a0:	83 ec 0c             	sub    $0xc,%esp
801020a3:	68 54 79 10 80       	push   $0x80107954
801020a8:	e8 e3 e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
801020ad:	83 ec 0c             	sub    $0xc,%esp
801020b0:	68 01 7c 10 80       	push   $0x80107c01
801020b5:	e8 d6 e2 ff ff       	call   80100390 <panic>
801020ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020c0 <namei>:

struct inode*
namei(char *path)
{
801020c0:	f3 0f 1e fb          	endbr32
801020c4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020c5:	31 d2                	xor    %edx,%edx
{
801020c7:	89 e5                	mov    %esp,%ebp
801020c9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020cc:	8b 45 08             	mov    0x8(%ebp),%eax
801020cf:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020d2:	e8 29 fd ff ff       	call   80101e00 <namex>
}
801020d7:	c9                   	leave
801020d8:	c3                   	ret
801020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020e0:	f3 0f 1e fb          	endbr32
801020e4:	55                   	push   %ebp
  return namex(path, 1, name);
801020e5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020ea:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020f2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020f3:	e9 08 fd ff ff       	jmp    80101e00 <namex>
801020f8:	66 90                	xchg   %ax,%ax
801020fa:	66 90                	xchg   %ax,%ax
801020fc:	66 90                	xchg   %ax,%ax
801020fe:	66 90                	xchg   %ax,%ax

80102100 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	57                   	push   %edi
80102104:	56                   	push   %esi
80102105:	53                   	push   %ebx
80102106:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102109:	85 c0                	test   %eax,%eax
8010210b:	0f 84 b4 00 00 00    	je     801021c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102111:	8b 70 08             	mov    0x8(%eax),%esi
80102114:	89 c3                	mov    %eax,%ebx
80102116:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010211c:	0f 87 96 00 00 00    	ja     801021b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102122:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102127:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010212e:	00 
8010212f:	90                   	nop
80102130:	89 ca                	mov    %ecx,%edx
80102132:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102133:	83 e0 c0             	and    $0xffffffc0,%eax
80102136:	3c 40                	cmp    $0x40,%al
80102138:	75 f6                	jne    80102130 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010213a:	31 ff                	xor    %edi,%edi
8010213c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102141:	89 f8                	mov    %edi,%eax
80102143:	ee                   	out    %al,(%dx)
80102144:	b8 01 00 00 00       	mov    $0x1,%eax
80102149:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010214e:	ee                   	out    %al,(%dx)
8010214f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102154:	89 f0                	mov    %esi,%eax
80102156:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102157:	89 f0                	mov    %esi,%eax
80102159:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010215e:	c1 f8 08             	sar    $0x8,%eax
80102161:	ee                   	out    %al,(%dx)
80102162:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102167:	89 f8                	mov    %edi,%eax
80102169:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010216a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010216e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102173:	c1 e0 04             	shl    $0x4,%eax
80102176:	83 e0 10             	and    $0x10,%eax
80102179:	83 c8 e0             	or     $0xffffffe0,%eax
8010217c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010217d:	f6 03 04             	testb  $0x4,(%ebx)
80102180:	75 16                	jne    80102198 <idestart+0x98>
80102182:	b8 20 00 00 00       	mov    $0x20,%eax
80102187:	89 ca                	mov    %ecx,%edx
80102189:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010218a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218d:	5b                   	pop    %ebx
8010218e:	5e                   	pop    %esi
8010218f:	5f                   	pop    %edi
80102190:	5d                   	pop    %ebp
80102191:	c3                   	ret
80102192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102198:	b8 30 00 00 00       	mov    $0x30,%eax
8010219d:	89 ca                	mov    %ecx,%edx
8010219f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ad:	fc                   	cld
801021ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b3:	5b                   	pop    %ebx
801021b4:	5e                   	pop    %esi
801021b5:	5f                   	pop    %edi
801021b6:	5d                   	pop    %ebp
801021b7:	c3                   	ret
    panic("incorrect blockno");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 6a 79 10 80       	push   $0x8010796a
801021c0:	e8 cb e1 ff ff       	call   80100390 <panic>
    panic("idestart");
801021c5:	83 ec 0c             	sub    $0xc,%esp
801021c8:	68 61 79 10 80       	push   $0x80107961
801021cd:	e8 be e1 ff ff       	call   80100390 <panic>
801021d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021d9:	00 
801021da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021e0 <ideinit>:
{
801021e0:	f3 0f 1e fb          	endbr32
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021ea:	68 7c 79 10 80       	push   $0x8010797c
801021ef:	68 80 b5 10 80       	push   $0x8010b580
801021f4:	e8 c7 24 00 00       	call   801046c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021f9:	58                   	pop    %eax
801021fa:	a1 e0 3d 11 80       	mov    0x80113de0,%eax
801021ff:	5a                   	pop    %edx
80102200:	83 e8 01             	sub    $0x1,%eax
80102203:	50                   	push   %eax
80102204:	6a 0e                	push   $0xe
80102206:	e8 b5 02 00 00       	call   801024c0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010220b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010220e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102213:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102218:	ec                   	in     (%dx),%al
80102219:	83 e0 c0             	and    $0xffffffc0,%eax
8010221c:	3c 40                	cmp    $0x40,%al
8010221e:	75 f8                	jne    80102218 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102220:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102225:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222a:	ee                   	out    %al,(%dx)
8010222b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102230:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102235:	eb 0e                	jmp    80102245 <ideinit+0x65>
80102237:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010223e:	00 
8010223f:	90                   	nop
  for(i=0; i<1000; i++){
80102240:	83 e9 01             	sub    $0x1,%ecx
80102243:	74 0f                	je     80102254 <ideinit+0x74>
80102245:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102246:	84 c0                	test   %al,%al
80102248:	74 f6                	je     80102240 <ideinit+0x60>
      havedisk1 = 1;
8010224a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102251:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102254:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102259:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010225e:	ee                   	out    %al,(%dx)
}
8010225f:	c9                   	leave
80102260:	c3                   	ret
80102261:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102268:	00 
80102269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102270 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102270:	f3 0f 1e fb          	endbr32
80102274:	55                   	push   %ebp
80102275:	89 e5                	mov    %esp,%ebp
80102277:	57                   	push   %edi
80102278:	56                   	push   %esi
80102279:	53                   	push   %ebx
8010227a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010227d:	68 80 b5 10 80       	push   $0x8010b580
80102282:	e8 b9 25 00 00       	call   80104840 <acquire>

  if((b = idequeue) == 0){
80102287:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010228d:	83 c4 10             	add    $0x10,%esp
80102290:	85 db                	test   %ebx,%ebx
80102292:	74 5f                	je     801022f3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102294:	8b 43 58             	mov    0x58(%ebx),%eax
80102297:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010229c:	8b 33                	mov    (%ebx),%esi
8010229e:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022a4:	75 2b                	jne    801022d1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022a6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801022b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022b1:	89 c1                	mov    %eax,%ecx
801022b3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022b6:	80 f9 40             	cmp    $0x40,%cl
801022b9:	75 f5                	jne    801022b0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022bb:	a8 21                	test   $0x21,%al
801022bd:	75 12                	jne    801022d1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022bf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022c2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022cc:	fc                   	cld
801022cd:	f3 6d                	rep insl (%dx),%es:(%edi)
801022cf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022d1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022d4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022d7:	83 ce 02             	or     $0x2,%esi
801022da:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022dc:	53                   	push   %ebx
801022dd:	e8 be 20 00 00       	call   801043a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022e2:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801022e7:	83 c4 10             	add    $0x10,%esp
801022ea:	85 c0                	test   %eax,%eax
801022ec:	74 05                	je     801022f3 <ideintr+0x83>
    idestart(idequeue);
801022ee:	e8 0d fe ff ff       	call   80102100 <idestart>
    release(&idelock);
801022f3:	83 ec 0c             	sub    $0xc,%esp
801022f6:	68 80 b5 10 80       	push   $0x8010b580
801022fb:	e8 00 26 00 00       	call   80104900 <release>

  release(&idelock);
}
80102300:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102303:	5b                   	pop    %ebx
80102304:	5e                   	pop    %esi
80102305:	5f                   	pop    %edi
80102306:	5d                   	pop    %ebp
80102307:	c3                   	ret
80102308:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010230f:	00 

80102310 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102310:	f3 0f 1e fb          	endbr32
80102314:	55                   	push   %ebp
80102315:	89 e5                	mov    %esp,%ebp
80102317:	53                   	push   %ebx
80102318:	83 ec 10             	sub    $0x10,%esp
8010231b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010231e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102321:	50                   	push   %eax
80102322:	e8 39 23 00 00       	call   80104660 <holdingsleep>
80102327:	83 c4 10             	add    $0x10,%esp
8010232a:	85 c0                	test   %eax,%eax
8010232c:	0f 84 cf 00 00 00    	je     80102401 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102332:	8b 03                	mov    (%ebx),%eax
80102334:	83 e0 06             	and    $0x6,%eax
80102337:	83 f8 02             	cmp    $0x2,%eax
8010233a:	0f 84 b4 00 00 00    	je     801023f4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102340:	8b 53 04             	mov    0x4(%ebx),%edx
80102343:	85 d2                	test   %edx,%edx
80102345:	74 0d                	je     80102354 <iderw+0x44>
80102347:	a1 60 b5 10 80       	mov    0x8010b560,%eax
8010234c:	85 c0                	test   %eax,%eax
8010234e:	0f 84 93 00 00 00    	je     801023e7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102354:	83 ec 0c             	sub    $0xc,%esp
80102357:	68 80 b5 10 80       	push   $0x8010b580
8010235c:	e8 df 24 00 00       	call   80104840 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102361:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
80102366:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010236d:	83 c4 10             	add    $0x10,%esp
80102370:	85 c0                	test   %eax,%eax
80102372:	74 6c                	je     801023e0 <iderw+0xd0>
80102374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102378:	89 c2                	mov    %eax,%edx
8010237a:	8b 40 58             	mov    0x58(%eax),%eax
8010237d:	85 c0                	test   %eax,%eax
8010237f:	75 f7                	jne    80102378 <iderw+0x68>
80102381:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102384:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102386:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010238c:	74 42                	je     801023d0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 e0 06             	and    $0x6,%eax
80102393:	83 f8 02             	cmp    $0x2,%eax
80102396:	74 23                	je     801023bb <iderw+0xab>
80102398:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010239f:	00 
    sleep(b, &idelock);
801023a0:	83 ec 08             	sub    $0x8,%esp
801023a3:	68 80 b5 10 80       	push   $0x8010b580
801023a8:	53                   	push   %ebx
801023a9:	e8 32 1e 00 00       	call   801041e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023ae:	8b 03                	mov    (%ebx),%eax
801023b0:	83 c4 10             	add    $0x10,%esp
801023b3:	83 e0 06             	and    $0x6,%eax
801023b6:	83 f8 02             	cmp    $0x2,%eax
801023b9:	75 e5                	jne    801023a0 <iderw+0x90>
  }


  release(&idelock);
801023bb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801023c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023c5:	c9                   	leave
  release(&idelock);
801023c6:	e9 35 25 00 00       	jmp    80104900 <release>
801023cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801023d0:	89 d8                	mov    %ebx,%eax
801023d2:	e8 29 fd ff ff       	call   80102100 <idestart>
801023d7:	eb b5                	jmp    8010238e <iderw+0x7e>
801023d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023e0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801023e5:	eb 9d                	jmp    80102384 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801023e7:	83 ec 0c             	sub    $0xc,%esp
801023ea:	68 ab 79 10 80       	push   $0x801079ab
801023ef:	e8 9c df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801023f4:	83 ec 0c             	sub    $0xc,%esp
801023f7:	68 96 79 10 80       	push   $0x80107996
801023fc:	e8 8f df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102401:	83 ec 0c             	sub    $0xc,%esp
80102404:	68 80 79 10 80       	push   $0x80107980
80102409:	e8 82 df ff ff       	call   80100390 <panic>
8010240e:	66 90                	xchg   %ax,%ax

80102410 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102410:	f3 0f 1e fb          	endbr32
80102414:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102415:	c7 05 1c 37 11 80 00 	movl   $0xfec00000,0x8011371c
8010241c:	00 c0 fe 
{
8010241f:	89 e5                	mov    %esp,%ebp
80102421:	56                   	push   %esi
80102422:	53                   	push   %ebx
  ioapic->reg = reg;
80102423:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010242a:	00 00 00 
  return ioapic->data;
8010242d:	8b 15 1c 37 11 80    	mov    0x8011371c,%edx
80102433:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102436:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010243c:	8b 0d 1c 37 11 80    	mov    0x8011371c,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102442:	0f b6 15 40 38 11 80 	movzbl 0x80113840,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102449:	c1 ee 10             	shr    $0x10,%esi
8010244c:	89 f0                	mov    %esi,%eax
8010244e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102451:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102454:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102457:	39 c2                	cmp    %eax,%edx
80102459:	74 16                	je     80102471 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010245b:	83 ec 0c             	sub    $0xc,%esp
8010245e:	68 f8 7d 10 80       	push   $0x80107df8
80102463:	e8 48 e2 ff ff       	call   801006b0 <cprintf>
80102468:	8b 0d 1c 37 11 80    	mov    0x8011371c,%ecx
8010246e:	83 c4 10             	add    $0x10,%esp
80102471:	83 c6 21             	add    $0x21,%esi
{
80102474:	ba 10 00 00 00       	mov    $0x10,%edx
80102479:	b8 20 00 00 00       	mov    $0x20,%eax
8010247e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102480:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102482:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102484:	8b 0d 1c 37 11 80    	mov    0x8011371c,%ecx
8010248a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010248d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102493:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102496:	8d 5a 01             	lea    0x1(%edx),%ebx
80102499:	83 c2 02             	add    $0x2,%edx
8010249c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010249e:	8b 0d 1c 37 11 80    	mov    0x8011371c,%ecx
801024a4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801024ab:	39 f0                	cmp    %esi,%eax
801024ad:	75 d1                	jne    80102480 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b2:	5b                   	pop    %ebx
801024b3:	5e                   	pop    %esi
801024b4:	5d                   	pop    %ebp
801024b5:	c3                   	ret
801024b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801024bd:	00 
801024be:	66 90                	xchg   %ax,%ax

801024c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024c0:	f3 0f 1e fb          	endbr32
801024c4:	55                   	push   %ebp
  ioapic->reg = reg;
801024c5:	8b 0d 1c 37 11 80    	mov    0x8011371c,%ecx
{
801024cb:	89 e5                	mov    %esp,%ebp
801024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024d0:	8d 50 20             	lea    0x20(%eax),%edx
801024d3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024d7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024d9:	8b 0d 1c 37 11 80    	mov    0x8011371c,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024df:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024e2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024e8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024ea:	a1 1c 37 11 80       	mov    0x8011371c,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ef:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024f2:	89 50 10             	mov    %edx,0x10(%eax)
}
801024f5:	5d                   	pop    %ebp
801024f6:	c3                   	ret
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102500:	f3 0f 1e fb          	endbr32
80102504:	55                   	push   %ebp
80102505:	89 e5                	mov    %esp,%ebp
80102507:	53                   	push   %ebx
80102508:	83 ec 04             	sub    $0x4,%esp
8010250b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010250e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102514:	75 7a                	jne    80102590 <kfree+0x90>
80102516:	81 fb 88 88 11 80    	cmp    $0x80118888,%ebx
8010251c:	72 72                	jb     80102590 <kfree+0x90>
8010251e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102524:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102529:	77 65                	ja     80102590 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010252b:	83 ec 04             	sub    $0x4,%esp
8010252e:	68 00 10 00 00       	push   $0x1000
80102533:	6a 01                	push   $0x1
80102535:	53                   	push   %ebx
80102536:	e8 15 24 00 00       	call   80104950 <memset>

  if(kmem.use_lock)
8010253b:	8b 15 54 37 11 80    	mov    0x80113754,%edx
80102541:	83 c4 10             	add    $0x10,%esp
80102544:	85 d2                	test   %edx,%edx
80102546:	75 20                	jne    80102568 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102548:	a1 58 37 11 80       	mov    0x80113758,%eax
8010254d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010254f:	a1 54 37 11 80       	mov    0x80113754,%eax
  kmem.freelist = r;
80102554:	89 1d 58 37 11 80    	mov    %ebx,0x80113758
  if(kmem.use_lock)
8010255a:	85 c0                	test   %eax,%eax
8010255c:	75 22                	jne    80102580 <kfree+0x80>
    release(&kmem.lock);
}
8010255e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102561:	c9                   	leave
80102562:	c3                   	ret
80102563:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	68 20 37 11 80       	push   $0x80113720
80102570:	e8 cb 22 00 00       	call   80104840 <acquire>
80102575:	83 c4 10             	add    $0x10,%esp
80102578:	eb ce                	jmp    80102548 <kfree+0x48>
8010257a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102580:	c7 45 08 20 37 11 80 	movl   $0x80113720,0x8(%ebp)
}
80102587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010258a:	c9                   	leave
    release(&kmem.lock);
8010258b:	e9 70 23 00 00       	jmp    80104900 <release>
    panic("kfree");
80102590:	83 ec 0c             	sub    $0xc,%esp
80102593:	68 c9 79 10 80       	push   $0x801079c9
80102598:	e8 f3 dd ff ff       	call   80100390 <panic>
8010259d:	8d 76 00             	lea    0x0(%esi),%esi

801025a0 <freerange>:
{
801025a0:	f3 0f 1e fb          	endbr32
801025a4:	55                   	push   %ebp
801025a5:	89 e5                	mov    %esp,%ebp
801025a7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025a8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025ab:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ae:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025af:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025b5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025c1:	39 de                	cmp    %ebx,%esi
801025c3:	72 1f                	jb     801025e4 <freerange+0x44>
801025c5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801025c8:	83 ec 0c             	sub    $0xc,%esp
801025cb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025d7:	50                   	push   %eax
801025d8:	e8 23 ff ff ff       	call   80102500 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025dd:	83 c4 10             	add    $0x10,%esp
801025e0:	39 f3                	cmp    %esi,%ebx
801025e2:	76 e4                	jbe    801025c8 <freerange+0x28>
}
801025e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e7:	5b                   	pop    %ebx
801025e8:	5e                   	pop    %esi
801025e9:	5d                   	pop    %ebp
801025ea:	c3                   	ret
801025eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801025f0 <kinit1>:
{
801025f0:	f3 0f 1e fb          	endbr32
801025f4:	55                   	push   %ebp
801025f5:	89 e5                	mov    %esp,%ebp
801025f7:	56                   	push   %esi
801025f8:	53                   	push   %ebx
801025f9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025fc:	83 ec 08             	sub    $0x8,%esp
801025ff:	68 cf 79 10 80       	push   $0x801079cf
80102604:	68 20 37 11 80       	push   $0x80113720
80102609:	e8 b2 20 00 00       	call   801046c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010260e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102614:	c7 05 54 37 11 80 00 	movl   $0x0,0x80113754
8010261b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010261e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102624:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102630:	39 de                	cmp    %ebx,%esi
80102632:	72 20                	jb     80102654 <kinit1+0x64>
80102634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102647:	50                   	push   %eax
80102648:	e8 b3 fe ff ff       	call   80102500 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	39 de                	cmp    %ebx,%esi
80102652:	73 e4                	jae    80102638 <kinit1+0x48>
}
80102654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102657:	5b                   	pop    %ebx
80102658:	5e                   	pop    %esi
80102659:	5d                   	pop    %ebp
8010265a:	c3                   	ret
8010265b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102660 <kinit2>:
{
80102660:	f3 0f 1e fb          	endbr32
80102664:	55                   	push   %ebp
80102665:	89 e5                	mov    %esp,%ebp
80102667:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102668:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010266b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010266e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010266f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102675:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010267b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102681:	39 de                	cmp    %ebx,%esi
80102683:	72 1f                	jb     801026a4 <kinit2+0x44>
80102685:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102688:	83 ec 0c             	sub    $0xc,%esp
8010268b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102691:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102697:	50                   	push   %eax
80102698:	e8 63 fe ff ff       	call   80102500 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010269d:	83 c4 10             	add    $0x10,%esp
801026a0:	39 de                	cmp    %ebx,%esi
801026a2:	73 e4                	jae    80102688 <kinit2+0x28>
  kmem.use_lock = 1;
801026a4:	c7 05 54 37 11 80 01 	movl   $0x1,0x80113754
801026ab:	00 00 00 
}
801026ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026b1:	5b                   	pop    %ebx
801026b2:	5e                   	pop    %esi
801026b3:	5d                   	pop    %ebp
801026b4:	c3                   	ret
801026b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026bc:	00 
801026bd:	8d 76 00             	lea    0x0(%esi),%esi

801026c0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026c0:	f3 0f 1e fb          	endbr32
  struct run *r;

  if(kmem.use_lock)
801026c4:	a1 54 37 11 80       	mov    0x80113754,%eax
801026c9:	85 c0                	test   %eax,%eax
801026cb:	75 1b                	jne    801026e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026cd:	a1 58 37 11 80       	mov    0x80113758,%eax
  if(r)
801026d2:	85 c0                	test   %eax,%eax
801026d4:	74 0a                	je     801026e0 <kalloc+0x20>
    kmem.freelist = r->next;
801026d6:	8b 10                	mov    (%eax),%edx
801026d8:	89 15 58 37 11 80    	mov    %edx,0x80113758
  if(kmem.use_lock)
801026de:	c3                   	ret
801026df:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026e0:	c3                   	ret
801026e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026e8:	55                   	push   %ebp
801026e9:	89 e5                	mov    %esp,%ebp
801026eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ee:	68 20 37 11 80       	push   $0x80113720
801026f3:	e8 48 21 00 00       	call   80104840 <acquire>
  r = kmem.freelist;
801026f8:	a1 58 37 11 80       	mov    0x80113758,%eax
  if(r)
801026fd:	8b 15 54 37 11 80    	mov    0x80113754,%edx
80102703:	83 c4 10             	add    $0x10,%esp
80102706:	85 c0                	test   %eax,%eax
80102708:	74 08                	je     80102712 <kalloc+0x52>
    kmem.freelist = r->next;
8010270a:	8b 08                	mov    (%eax),%ecx
8010270c:	89 0d 58 37 11 80    	mov    %ecx,0x80113758
  if(kmem.use_lock)
80102712:	85 d2                	test   %edx,%edx
80102714:	74 16                	je     8010272c <kalloc+0x6c>
    release(&kmem.lock);
80102716:	83 ec 0c             	sub    $0xc,%esp
80102719:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010271c:	68 20 37 11 80       	push   $0x80113720
80102721:	e8 da 21 00 00       	call   80104900 <release>
  return (char*)r;
80102726:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102729:	83 c4 10             	add    $0x10,%esp
}
8010272c:	c9                   	leave
8010272d:	c3                   	ret
8010272e:	66 90                	xchg   %ax,%ax

80102730 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102730:	f3 0f 1e fb          	endbr32
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102734:	ba 64 00 00 00       	mov    $0x64,%edx
80102739:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010273a:	a8 01                	test   $0x1,%al
8010273c:	0f 84 be 00 00 00    	je     80102800 <kbdgetc+0xd0>
{
80102742:	55                   	push   %ebp
80102743:	ba 60 00 00 00       	mov    $0x60,%edx
80102748:	89 e5                	mov    %esp,%ebp
8010274a:	53                   	push   %ebx
8010274b:	ec                   	in     (%dx),%al
  return data;
8010274c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102752:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102755:	3c e0                	cmp    $0xe0,%al
80102757:	74 57                	je     801027b0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102759:	89 d9                	mov    %ebx,%ecx
8010275b:	83 e1 40             	and    $0x40,%ecx
8010275e:	84 c0                	test   %al,%al
80102760:	78 5e                	js     801027c0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102762:	85 c9                	test   %ecx,%ecx
80102764:	74 09                	je     8010276f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102766:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102769:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010276c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010276f:	0f b6 8a 80 80 10 80 	movzbl -0x7fef7f80(%edx),%ecx
  shift ^= togglecode[data];
80102776:	0f b6 82 80 7f 10 80 	movzbl -0x7fef8080(%edx),%eax
  shift |= shiftcode[data];
8010277d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010277f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102781:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102783:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102789:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010278c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010278f:	8b 04 85 60 7f 10 80 	mov    -0x7fef80a0(,%eax,4),%eax
80102796:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010279a:	74 0b                	je     801027a7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010279c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010279f:	83 fa 19             	cmp    $0x19,%edx
801027a2:	77 44                	ja     801027e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027a4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027a7:	5b                   	pop    %ebx
801027a8:	5d                   	pop    %ebp
801027a9:	c3                   	ret
801027aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801027b0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027b3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027b5:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
801027bb:	5b                   	pop    %ebx
801027bc:	5d                   	pop    %ebp
801027bd:	c3                   	ret
801027be:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801027c0:	83 e0 7f             	and    $0x7f,%eax
801027c3:	85 c9                	test   %ecx,%ecx
801027c5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801027c8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801027ca:	0f b6 8a 80 80 10 80 	movzbl -0x7fef7f80(%edx),%ecx
801027d1:	83 c9 40             	or     $0x40,%ecx
801027d4:	0f b6 c9             	movzbl %cl,%ecx
801027d7:	f7 d1                	not    %ecx
801027d9:	21 d9                	and    %ebx,%ecx
}
801027db:	5b                   	pop    %ebx
801027dc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801027dd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801027e3:	c3                   	ret
801027e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801027e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ee:	5b                   	pop    %ebx
801027ef:	5d                   	pop    %ebp
      c += 'a' - 'A';
801027f0:	83 f9 1a             	cmp    $0x1a,%ecx
801027f3:	0f 42 c2             	cmovb  %edx,%eax
}
801027f6:	c3                   	ret
801027f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027fe:	00 
801027ff:	90                   	nop
    return -1;
80102800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102805:	c3                   	ret
80102806:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010280d:	00 
8010280e:	66 90                	xchg   %ax,%ax

80102810 <kbdintr>:

void
kbdintr(void)
{
80102810:	f3 0f 1e fb          	endbr32
80102814:	55                   	push   %ebp
80102815:	89 e5                	mov    %esp,%ebp
80102817:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010281a:	68 30 27 10 80       	push   $0x80102730
8010281f:	e8 3c e0 ff ff       	call   80100860 <consoleintr>
}
80102824:	83 c4 10             	add    $0x10,%esp
80102827:	c9                   	leave
80102828:	c3                   	ret
80102829:	66 90                	xchg   %ax,%ax
8010282b:	66 90                	xchg   %ax,%ax
8010282d:	66 90                	xchg   %ax,%ax
8010282f:	90                   	nop

80102830 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102830:	f3 0f 1e fb          	endbr32
  if(!lapic)
80102834:	a1 5c 37 11 80       	mov    0x8011375c,%eax
80102839:	85 c0                	test   %eax,%eax
8010283b:	0f 84 c7 00 00 00    	je     80102908 <lapicinit+0xd8>
  lapic[index] = value;
80102841:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102848:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102855:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102862:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102865:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102868:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010286f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102872:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102875:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010287c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010287f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102882:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102889:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010288f:	8b 50 30             	mov    0x30(%eax),%edx
80102892:	c1 ea 10             	shr    $0x10,%edx
80102895:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010289b:	75 73                	jne    80102910 <lapicinit+0xe0>
  lapic[index] = value;
8010289d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028aa:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028b1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028be:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028cb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028d8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028db:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028de:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028e5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028e8:	8b 50 20             	mov    0x20(%eax),%edx
801028eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028f6:	80 e6 10             	and    $0x10,%dh
801028f9:	75 f5                	jne    801028f0 <lapicinit+0xc0>
  lapic[index] = value;
801028fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102902:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102905:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102908:	c3                   	ret
80102909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102910:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102917:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010291a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010291d:	e9 7b ff ff ff       	jmp    8010289d <lapicinit+0x6d>
80102922:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102929:	00 
8010292a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102930 <lapicid>:

int
lapicid(void)
{
80102930:	f3 0f 1e fb          	endbr32
  if (!lapic)
80102934:	a1 5c 37 11 80       	mov    0x8011375c,%eax
80102939:	85 c0                	test   %eax,%eax
8010293b:	74 0b                	je     80102948 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010293d:	8b 40 20             	mov    0x20(%eax),%eax
80102940:	c1 e8 18             	shr    $0x18,%eax
80102943:	c3                   	ret
80102944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102948:	31 c0                	xor    %eax,%eax
}
8010294a:	c3                   	ret
8010294b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102950 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102950:	f3 0f 1e fb          	endbr32
  if(lapic)
80102954:	a1 5c 37 11 80       	mov    0x8011375c,%eax
80102959:	85 c0                	test   %eax,%eax
8010295b:	74 0d                	je     8010296a <lapiceoi+0x1a>
  lapic[index] = value;
8010295d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102964:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010296a:	c3                   	ret
8010296b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102970 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102970:	f3 0f 1e fb          	endbr32
}
80102974:	c3                   	ret
80102975:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010297c:	00 
8010297d:	8d 76 00             	lea    0x0(%esi),%esi

80102980 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102980:	f3 0f 1e fb          	endbr32
80102984:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102985:	b8 0f 00 00 00       	mov    $0xf,%eax
8010298a:	ba 70 00 00 00       	mov    $0x70,%edx
8010298f:	89 e5                	mov    %esp,%ebp
80102991:	53                   	push   %ebx
80102992:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102995:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102998:	ee                   	out    %al,(%dx)
80102999:	b8 0a 00 00 00       	mov    $0xa,%eax
8010299e:	ba 71 00 00 00       	mov    $0x71,%edx
801029a3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029a4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801029a6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029a9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029af:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029b1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801029b4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029b6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029b9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029bc:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029c2:	a1 5c 37 11 80       	mov    0x8011375c,%eax
801029c7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029cd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029d0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029d7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029da:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029dd:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029e4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ea:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029f3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029fc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a02:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a05:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102a0b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102a0c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102a0f:	5d                   	pop    %ebp
80102a10:	c3                   	ret
80102a11:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a18:	00 
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a20 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a20:	f3 0f 1e fb          	endbr32
80102a24:	55                   	push   %ebp
80102a25:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a2a:	ba 70 00 00 00       	mov    $0x70,%edx
80102a2f:	89 e5                	mov    %esp,%ebp
80102a31:	57                   	push   %edi
80102a32:	56                   	push   %esi
80102a33:	53                   	push   %ebx
80102a34:	83 ec 4c             	sub    $0x4c,%esp
80102a37:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a38:	ba 71 00 00 00       	mov    $0x71,%edx
80102a3d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a3e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a41:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a46:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a50:	31 c0                	xor    %eax,%eax
80102a52:	89 da                	mov    %ebx,%edx
80102a54:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a55:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a5a:	89 ca                	mov    %ecx,%edx
80102a5c:	ec                   	in     (%dx),%al
80102a5d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a60:	89 da                	mov    %ebx,%edx
80102a62:	b8 02 00 00 00       	mov    $0x2,%eax
80102a67:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a68:	89 ca                	mov    %ecx,%edx
80102a6a:	ec                   	in     (%dx),%al
80102a6b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6e:	89 da                	mov    %ebx,%edx
80102a70:	b8 04 00 00 00       	mov    $0x4,%eax
80102a75:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a76:	89 ca                	mov    %ecx,%edx
80102a78:	ec                   	in     (%dx),%al
80102a79:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	b8 07 00 00 00       	mov    $0x7,%eax
80102a83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a84:	89 ca                	mov    %ecx,%edx
80102a86:	ec                   	in     (%dx),%al
80102a87:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8a:	89 da                	mov    %ebx,%edx
80102a8c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a91:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a92:	89 ca                	mov    %ecx,%edx
80102a94:	ec                   	in     (%dx),%al
80102a95:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a97:	89 da                	mov    %ebx,%edx
80102a99:	b8 09 00 00 00       	mov    $0x9,%eax
80102a9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9f:	89 ca                	mov    %ecx,%edx
80102aa1:	ec                   	in     (%dx),%al
80102aa2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa4:	89 da                	mov    %ebx,%edx
80102aa6:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aac:	89 ca                	mov    %ecx,%edx
80102aae:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102aaf:	84 c0                	test   %al,%al
80102ab1:	78 9d                	js     80102a50 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102ab3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102ab7:	89 fa                	mov    %edi,%edx
80102ab9:	0f b6 fa             	movzbl %dl,%edi
80102abc:	89 f2                	mov    %esi,%edx
80102abe:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ac1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ac5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac8:	89 da                	mov    %ebx,%edx
80102aca:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102acd:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ad0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102ad4:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102ad7:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ada:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ade:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ae1:	31 c0                	xor    %eax,%eax
80102ae3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae4:	89 ca                	mov    %ecx,%edx
80102ae6:	ec                   	in     (%dx),%al
80102ae7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aea:	89 da                	mov    %ebx,%edx
80102aec:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102aef:	b8 02 00 00 00       	mov    $0x2,%eax
80102af4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af5:	89 ca                	mov    %ecx,%edx
80102af7:	ec                   	in     (%dx),%al
80102af8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afb:	89 da                	mov    %ebx,%edx
80102afd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b00:	b8 04 00 00 00       	mov    $0x4,%eax
80102b05:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b06:	89 ca                	mov    %ecx,%edx
80102b08:	ec                   	in     (%dx),%al
80102b09:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0c:	89 da                	mov    %ebx,%edx
80102b0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b11:	b8 07 00 00 00       	mov    $0x7,%eax
80102b16:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b17:	89 ca                	mov    %ecx,%edx
80102b19:	ec                   	in     (%dx),%al
80102b1a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b1d:	89 da                	mov    %ebx,%edx
80102b1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b22:	b8 08 00 00 00       	mov    $0x8,%eax
80102b27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b28:	89 ca                	mov    %ecx,%edx
80102b2a:	ec                   	in     (%dx),%al
80102b2b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2e:	89 da                	mov    %ebx,%edx
80102b30:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b33:	b8 09 00 00 00       	mov    $0x9,%eax
80102b38:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b39:	89 ca                	mov    %ecx,%edx
80102b3b:	ec                   	in     (%dx),%al
80102b3c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b3f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b45:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b48:	6a 18                	push   $0x18
80102b4a:	50                   	push   %eax
80102b4b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b4e:	50                   	push   %eax
80102b4f:	e8 4c 1e 00 00       	call   801049a0 <memcmp>
80102b54:	83 c4 10             	add    $0x10,%esp
80102b57:	85 c0                	test   %eax,%eax
80102b59:	0f 85 f1 fe ff ff    	jne    80102a50 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102b5f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b63:	75 78                	jne    80102bdd <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b65:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b68:	89 c2                	mov    %eax,%edx
80102b6a:	83 e0 0f             	and    $0xf,%eax
80102b6d:	c1 ea 04             	shr    $0x4,%edx
80102b70:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b73:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b76:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b79:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b7c:	89 c2                	mov    %eax,%edx
80102b7e:	83 e0 0f             	and    $0xf,%eax
80102b81:	c1 ea 04             	shr    $0x4,%edx
80102b84:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b87:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b8d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b90:	89 c2                	mov    %eax,%edx
80102b92:	83 e0 0f             	and    $0xf,%eax
80102b95:	c1 ea 04             	shr    $0x4,%edx
80102b98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b9e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ba1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ba4:	89 c2                	mov    %eax,%edx
80102ba6:	83 e0 0f             	and    $0xf,%eax
80102ba9:	c1 ea 04             	shr    $0x4,%edx
80102bac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102baf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bb5:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb8:	89 c2                	mov    %eax,%edx
80102bba:	83 e0 0f             	and    $0xf,%eax
80102bbd:	c1 ea 04             	shr    $0x4,%edx
80102bc0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bc3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bc6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bc9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bcc:	89 c2                	mov    %eax,%edx
80102bce:	83 e0 0f             	and    $0xf,%eax
80102bd1:	c1 ea 04             	shr    $0x4,%edx
80102bd4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bd7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bda:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bdd:	8b 75 08             	mov    0x8(%ebp),%esi
80102be0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102be3:	89 06                	mov    %eax,(%esi)
80102be5:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102be8:	89 46 04             	mov    %eax,0x4(%esi)
80102beb:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bee:	89 46 08             	mov    %eax,0x8(%esi)
80102bf1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bf4:	89 46 0c             	mov    %eax,0xc(%esi)
80102bf7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bfa:	89 46 10             	mov    %eax,0x10(%esi)
80102bfd:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c00:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c03:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c0d:	5b                   	pop    %ebx
80102c0e:	5e                   	pop    %esi
80102c0f:	5f                   	pop    %edi
80102c10:	5d                   	pop    %ebp
80102c11:	c3                   	ret
80102c12:	66 90                	xchg   %ax,%ax
80102c14:	66 90                	xchg   %ax,%ax
80102c16:	66 90                	xchg   %ax,%ax
80102c18:	66 90                	xchg   %ax,%ax
80102c1a:	66 90                	xchg   %ax,%ax
80102c1c:	66 90                	xchg   %ax,%ax
80102c1e:	66 90                	xchg   %ax,%ax

80102c20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c20:	8b 0d a8 37 11 80    	mov    0x801137a8,%ecx
80102c26:	85 c9                	test   %ecx,%ecx
80102c28:	0f 8e 8a 00 00 00    	jle    80102cb8 <install_trans+0x98>
{
80102c2e:	55                   	push   %ebp
80102c2f:	89 e5                	mov    %esp,%ebp
80102c31:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c32:	31 ff                	xor    %edi,%edi
{
80102c34:	56                   	push   %esi
80102c35:	53                   	push   %ebx
80102c36:	83 ec 0c             	sub    $0xc,%esp
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c40:	a1 94 37 11 80       	mov    0x80113794,%eax
80102c45:	83 ec 08             	sub    $0x8,%esp
80102c48:	01 f8                	add    %edi,%eax
80102c4a:	83 c0 01             	add    $0x1,%eax
80102c4d:	50                   	push   %eax
80102c4e:	ff 35 a4 37 11 80    	push   0x801137a4
80102c54:	e8 77 d4 ff ff       	call   801000d0 <bread>
80102c59:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c5b:	58                   	pop    %eax
80102c5c:	5a                   	pop    %edx
80102c5d:	ff 34 bd ac 37 11 80 	push   -0x7feec854(,%edi,4)
80102c64:	ff 35 a4 37 11 80    	push   0x801137a4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c6a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c6d:	e8 5e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c72:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c75:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c77:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c7a:	68 00 02 00 00       	push   $0x200
80102c7f:	50                   	push   %eax
80102c80:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c83:	50                   	push   %eax
80102c84:	e8 67 1d 00 00       	call   801049f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c89:	89 1c 24             	mov    %ebx,(%esp)
80102c8c:	e8 1f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c91:	89 34 24             	mov    %esi,(%esp)
80102c94:	e8 57 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c99:	89 1c 24             	mov    %ebx,(%esp)
80102c9c:	e8 4f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ca1:	83 c4 10             	add    $0x10,%esp
80102ca4:	39 3d a8 37 11 80    	cmp    %edi,0x801137a8
80102caa:	7f 94                	jg     80102c40 <install_trans+0x20>
  }
}
80102cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102caf:	5b                   	pop    %ebx
80102cb0:	5e                   	pop    %esi
80102cb1:	5f                   	pop    %edi
80102cb2:	5d                   	pop    %ebp
80102cb3:	c3                   	ret
80102cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cb8:	c3                   	ret
80102cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cc7:	ff 35 94 37 11 80    	push   0x80113794
80102ccd:	ff 35 a4 37 11 80    	push   0x801137a4
80102cd3:	e8 f8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102cd8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cdb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102cdd:	a1 a8 37 11 80       	mov    0x801137a8,%eax
80102ce2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	85 c0                	test   %eax,%eax
80102ce7:	7e 19                	jle    80102d02 <write_head+0x42>
80102ce9:	31 d2                	xor    %edx,%edx
80102ceb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102cf0:	8b 0c 95 ac 37 11 80 	mov    -0x7feec854(,%edx,4),%ecx
80102cf7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cfb:	83 c2 01             	add    $0x1,%edx
80102cfe:	39 d0                	cmp    %edx,%eax
80102d00:	75 ee                	jne    80102cf0 <write_head+0x30>
  }
  bwrite(buf);
80102d02:	83 ec 0c             	sub    $0xc,%esp
80102d05:	53                   	push   %ebx
80102d06:	e8 a5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d0b:	89 1c 24             	mov    %ebx,(%esp)
80102d0e:	e8 dd d4 ff ff       	call   801001f0 <brelse>
}
80102d13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d16:	83 c4 10             	add    $0x10,%esp
80102d19:	c9                   	leave
80102d1a:	c3                   	ret
80102d1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102d20 <initlog>:
{
80102d20:	f3 0f 1e fb          	endbr32
80102d24:	55                   	push   %ebp
80102d25:	89 e5                	mov    %esp,%ebp
80102d27:	53                   	push   %ebx
80102d28:	83 ec 2c             	sub    $0x2c,%esp
80102d2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d2e:	68 d4 79 10 80       	push   $0x801079d4
80102d33:	68 60 37 11 80       	push   $0x80113760
80102d38:	e8 83 19 00 00       	call   801046c0 <initlock>
  readsb(dev, &sb);
80102d3d:	58                   	pop    %eax
80102d3e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d41:	5a                   	pop    %edx
80102d42:	50                   	push   %eax
80102d43:	53                   	push   %ebx
80102d44:	e8 27 e8 ff ff       	call   80101570 <readsb>
  log.start = sb.logstart;
80102d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d4c:	59                   	pop    %ecx
  log.dev = dev;
80102d4d:	89 1d a4 37 11 80    	mov    %ebx,0x801137a4
  log.size = sb.nlog;
80102d53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d56:	a3 94 37 11 80       	mov    %eax,0x80113794
  log.size = sb.nlog;
80102d5b:	89 15 98 37 11 80    	mov    %edx,0x80113798
  struct buf *buf = bread(log.dev, log.start);
80102d61:	5a                   	pop    %edx
80102d62:	50                   	push   %eax
80102d63:	53                   	push   %ebx
80102d64:	e8 67 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d69:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d6c:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102d6f:	89 0d a8 37 11 80    	mov    %ecx,0x801137a8
  for (i = 0; i < log.lh.n; i++) {
80102d75:	85 c9                	test   %ecx,%ecx
80102d77:	7e 19                	jle    80102d92 <initlog+0x72>
80102d79:	31 d2                	xor    %edx,%edx
80102d7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102d80:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d84:	89 1c 95 ac 37 11 80 	mov    %ebx,-0x7feec854(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d8b:	83 c2 01             	add    $0x1,%edx
80102d8e:	39 d1                	cmp    %edx,%ecx
80102d90:	75 ee                	jne    80102d80 <initlog+0x60>
  brelse(buf);
80102d92:	83 ec 0c             	sub    $0xc,%esp
80102d95:	50                   	push   %eax
80102d96:	e8 55 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d9b:	e8 80 fe ff ff       	call   80102c20 <install_trans>
  log.lh.n = 0;
80102da0:	c7 05 a8 37 11 80 00 	movl   $0x0,0x801137a8
80102da7:	00 00 00 
  write_head(); // clear the log
80102daa:	e8 11 ff ff ff       	call   80102cc0 <write_head>
}
80102daf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102db2:	83 c4 10             	add    $0x10,%esp
80102db5:	c9                   	leave
80102db6:	c3                   	ret
80102db7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dbe:	00 
80102dbf:	90                   	nop

80102dc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102dc0:	f3 0f 1e fb          	endbr32
80102dc4:	55                   	push   %ebp
80102dc5:	89 e5                	mov    %esp,%ebp
80102dc7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102dca:	68 60 37 11 80       	push   $0x80113760
80102dcf:	e8 6c 1a 00 00       	call   80104840 <acquire>
80102dd4:	83 c4 10             	add    $0x10,%esp
80102dd7:	eb 1c                	jmp    80102df5 <begin_op+0x35>
80102dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102de0:	83 ec 08             	sub    $0x8,%esp
80102de3:	68 60 37 11 80       	push   $0x80113760
80102de8:	68 60 37 11 80       	push   $0x80113760
80102ded:	e8 ee 13 00 00       	call   801041e0 <sleep>
80102df2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102df5:	a1 a0 37 11 80       	mov    0x801137a0,%eax
80102dfa:	85 c0                	test   %eax,%eax
80102dfc:	75 e2                	jne    80102de0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dfe:	a1 9c 37 11 80       	mov    0x8011379c,%eax
80102e03:	8b 15 a8 37 11 80    	mov    0x801137a8,%edx
80102e09:	83 c0 01             	add    $0x1,%eax
80102e0c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e0f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e12:	83 fa 1e             	cmp    $0x1e,%edx
80102e15:	7f c9                	jg     80102de0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e17:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e1a:	a3 9c 37 11 80       	mov    %eax,0x8011379c
      release(&log.lock);
80102e1f:	68 60 37 11 80       	push   $0x80113760
80102e24:	e8 d7 1a 00 00       	call   80104900 <release>
      break;
    }
  }
}
80102e29:	83 c4 10             	add    $0x10,%esp
80102e2c:	c9                   	leave
80102e2d:	c3                   	ret
80102e2e:	66 90                	xchg   %ax,%ax

80102e30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e30:	f3 0f 1e fb          	endbr32
80102e34:	55                   	push   %ebp
80102e35:	89 e5                	mov    %esp,%ebp
80102e37:	57                   	push   %edi
80102e38:	56                   	push   %esi
80102e39:	53                   	push   %ebx
80102e3a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e3d:	68 60 37 11 80       	push   $0x80113760
80102e42:	e8 f9 19 00 00       	call   80104840 <acquire>
  log.outstanding -= 1;
80102e47:	a1 9c 37 11 80       	mov    0x8011379c,%eax
  if(log.committing)
80102e4c:	8b 35 a0 37 11 80    	mov    0x801137a0,%esi
80102e52:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e55:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e58:	89 1d 9c 37 11 80    	mov    %ebx,0x8011379c
  if(log.committing)
80102e5e:	85 f6                	test   %esi,%esi
80102e60:	0f 85 1e 01 00 00    	jne    80102f84 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e66:	85 db                	test   %ebx,%ebx
80102e68:	0f 85 f2 00 00 00    	jne    80102f60 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e6e:	c7 05 a0 37 11 80 01 	movl   $0x1,0x801137a0
80102e75:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e78:	83 ec 0c             	sub    $0xc,%esp
80102e7b:	68 60 37 11 80       	push   $0x80113760
80102e80:	e8 7b 1a 00 00       	call   80104900 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e85:	8b 0d a8 37 11 80    	mov    0x801137a8,%ecx
80102e8b:	83 c4 10             	add    $0x10,%esp
80102e8e:	85 c9                	test   %ecx,%ecx
80102e90:	7f 3e                	jg     80102ed0 <end_op+0xa0>
    acquire(&log.lock);
80102e92:	83 ec 0c             	sub    $0xc,%esp
80102e95:	68 60 37 11 80       	push   $0x80113760
80102e9a:	e8 a1 19 00 00       	call   80104840 <acquire>
    wakeup(&log);
80102e9f:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
    log.committing = 0;
80102ea6:	c7 05 a0 37 11 80 00 	movl   $0x0,0x801137a0
80102ead:	00 00 00 
    wakeup(&log);
80102eb0:	e8 eb 14 00 00       	call   801043a0 <wakeup>
    release(&log.lock);
80102eb5:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
80102ebc:	e8 3f 1a 00 00       	call   80104900 <release>
80102ec1:	83 c4 10             	add    $0x10,%esp
}
80102ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ec7:	5b                   	pop    %ebx
80102ec8:	5e                   	pop    %esi
80102ec9:	5f                   	pop    %edi
80102eca:	5d                   	pop    %ebp
80102ecb:	c3                   	ret
80102ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ed0:	a1 94 37 11 80       	mov    0x80113794,%eax
80102ed5:	83 ec 08             	sub    $0x8,%esp
80102ed8:	01 d8                	add    %ebx,%eax
80102eda:	83 c0 01             	add    $0x1,%eax
80102edd:	50                   	push   %eax
80102ede:	ff 35 a4 37 11 80    	push   0x801137a4
80102ee4:	e8 e7 d1 ff ff       	call   801000d0 <bread>
80102ee9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eeb:	58                   	pop    %eax
80102eec:	5a                   	pop    %edx
80102eed:	ff 34 9d ac 37 11 80 	push   -0x7feec854(,%ebx,4)
80102ef4:	ff 35 a4 37 11 80    	push   0x801137a4
  for (tail = 0; tail < log.lh.n; tail++) {
80102efa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102efd:	e8 ce d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f02:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f05:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f07:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f0a:	68 00 02 00 00       	push   $0x200
80102f0f:	50                   	push   %eax
80102f10:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f13:	50                   	push   %eax
80102f14:	e8 d7 1a 00 00       	call   801049f0 <memmove>
    bwrite(to);  // write the log
80102f19:	89 34 24             	mov    %esi,(%esp)
80102f1c:	e8 8f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f21:	89 3c 24             	mov    %edi,(%esp)
80102f24:	e8 c7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f29:	89 34 24             	mov    %esi,(%esp)
80102f2c:	e8 bf d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f31:	83 c4 10             	add    $0x10,%esp
80102f34:	3b 1d a8 37 11 80    	cmp    0x801137a8,%ebx
80102f3a:	7c 94                	jl     80102ed0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f3c:	e8 7f fd ff ff       	call   80102cc0 <write_head>
    install_trans(); // Now install writes to home locations
80102f41:	e8 da fc ff ff       	call   80102c20 <install_trans>
    log.lh.n = 0;
80102f46:	c7 05 a8 37 11 80 00 	movl   $0x0,0x801137a8
80102f4d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f50:	e8 6b fd ff ff       	call   80102cc0 <write_head>
80102f55:	e9 38 ff ff ff       	jmp    80102e92 <end_op+0x62>
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f60:	83 ec 0c             	sub    $0xc,%esp
80102f63:	68 60 37 11 80       	push   $0x80113760
80102f68:	e8 33 14 00 00       	call   801043a0 <wakeup>
  release(&log.lock);
80102f6d:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
80102f74:	e8 87 19 00 00       	call   80104900 <release>
80102f79:	83 c4 10             	add    $0x10,%esp
}
80102f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f7f:	5b                   	pop    %ebx
80102f80:	5e                   	pop    %esi
80102f81:	5f                   	pop    %edi
80102f82:	5d                   	pop    %ebp
80102f83:	c3                   	ret
    panic("log.committing");
80102f84:	83 ec 0c             	sub    $0xc,%esp
80102f87:	68 d8 79 10 80       	push   $0x801079d8
80102f8c:	e8 ff d3 ff ff       	call   80100390 <panic>
80102f91:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f98:	00 
80102f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fa0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fa0:	f3 0f 1e fb          	endbr32
80102fa4:	55                   	push   %ebp
80102fa5:	89 e5                	mov    %esp,%ebp
80102fa7:	53                   	push   %ebx
80102fa8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fab:	8b 15 a8 37 11 80    	mov    0x801137a8,%edx
{
80102fb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fb4:	83 fa 1d             	cmp    $0x1d,%edx
80102fb7:	0f 8f 91 00 00 00    	jg     8010304e <log_write+0xae>
80102fbd:	a1 98 37 11 80       	mov    0x80113798,%eax
80102fc2:	83 e8 01             	sub    $0x1,%eax
80102fc5:	39 c2                	cmp    %eax,%edx
80102fc7:	0f 8d 81 00 00 00    	jge    8010304e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fcd:	a1 9c 37 11 80       	mov    0x8011379c,%eax
80102fd2:	85 c0                	test   %eax,%eax
80102fd4:	0f 8e 81 00 00 00    	jle    8010305b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fda:	83 ec 0c             	sub    $0xc,%esp
80102fdd:	68 60 37 11 80       	push   $0x80113760
80102fe2:	e8 59 18 00 00       	call   80104840 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fe7:	8b 15 a8 37 11 80    	mov    0x801137a8,%edx
80102fed:	83 c4 10             	add    $0x10,%esp
80102ff0:	85 d2                	test   %edx,%edx
80102ff2:	7e 4e                	jle    80103042 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ff4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ff7:	31 c0                	xor    %eax,%eax
80102ff9:	eb 0c                	jmp    80103007 <log_write+0x67>
80102ffb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103000:	83 c0 01             	add    $0x1,%eax
80103003:	39 c2                	cmp    %eax,%edx
80103005:	74 29                	je     80103030 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103007:	39 0c 85 ac 37 11 80 	cmp    %ecx,-0x7feec854(,%eax,4)
8010300e:	75 f0                	jne    80103000 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103010:	89 0c 85 ac 37 11 80 	mov    %ecx,-0x7feec854(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103017:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010301a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010301d:	c7 45 08 60 37 11 80 	movl   $0x80113760,0x8(%ebp)
}
80103024:	c9                   	leave
  release(&log.lock);
80103025:	e9 d6 18 00 00       	jmp    80104900 <release>
8010302a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103030:	89 0c 95 ac 37 11 80 	mov    %ecx,-0x7feec854(,%edx,4)
    log.lh.n++;
80103037:	83 c2 01             	add    $0x1,%edx
8010303a:	89 15 a8 37 11 80    	mov    %edx,0x801137a8
80103040:	eb d5                	jmp    80103017 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103042:	8b 43 08             	mov    0x8(%ebx),%eax
80103045:	a3 ac 37 11 80       	mov    %eax,0x801137ac
  if (i == log.lh.n)
8010304a:	75 cb                	jne    80103017 <log_write+0x77>
8010304c:	eb e9                	jmp    80103037 <log_write+0x97>
    panic("too big a transaction");
8010304e:	83 ec 0c             	sub    $0xc,%esp
80103051:	68 e7 79 10 80       	push   $0x801079e7
80103056:	e8 35 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010305b:	83 ec 0c             	sub    $0xc,%esp
8010305e:	68 fd 79 10 80       	push   $0x801079fd
80103063:	e8 28 d3 ff ff       	call   80100390 <panic>
80103068:	66 90                	xchg   %ax,%ax
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	53                   	push   %ebx
80103074:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103077:	e8 94 09 00 00       	call   80103a10 <cpuid>
8010307c:	89 c3                	mov    %eax,%ebx
8010307e:	e8 8d 09 00 00       	call   80103a10 <cpuid>
80103083:	83 ec 04             	sub    $0x4,%esp
80103086:	53                   	push   %ebx
80103087:	50                   	push   %eax
80103088:	68 18 7a 10 80       	push   $0x80107a18
8010308d:	e8 1e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103092:	e8 89 2f 00 00       	call   80106020 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103097:	e8 04 09 00 00       	call   801039a0 <mycpu>
8010309c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010309e:	b8 01 00 00 00       	mov    $0x1,%eax
801030a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030aa:	e8 11 0e 00 00       	call   80103ec0 <scheduler>
801030af:	90                   	nop

801030b0 <mpenter>:
{
801030b0:	f3 0f 1e fb          	endbr32
801030b4:	55                   	push   %ebp
801030b5:	89 e5                	mov    %esp,%ebp
801030b7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030ba:	e8 31 40 00 00       	call   801070f0 <switchkvm>
  seginit();
801030bf:	e8 9c 3f 00 00       	call   80107060 <seginit>
  lapicinit();
801030c4:	e8 67 f7 ff ff       	call   80102830 <lapicinit>
  mpmain();
801030c9:	e8 a2 ff ff ff       	call   80103070 <mpmain>
801030ce:	66 90                	xchg   %ax,%ax

801030d0 <main>:
{
801030d0:	f3 0f 1e fb          	endbr32
801030d4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030d8:	83 e4 f0             	and    $0xfffffff0,%esp
801030db:	ff 71 fc             	push   -0x4(%ecx)
801030de:	55                   	push   %ebp
801030df:	89 e5                	mov    %esp,%ebp
801030e1:	53                   	push   %ebx
801030e2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030e3:	83 ec 08             	sub    $0x8,%esp
801030e6:	68 00 00 40 80       	push   $0x80400000
801030eb:	68 88 88 11 80       	push   $0x80118888
801030f0:	e8 fb f4 ff ff       	call   801025f0 <kinit1>
  kvmalloc();      // kernel page table
801030f5:	e8 d6 44 00 00       	call   801075d0 <kvmalloc>
  mpinit();        // detect other processors
801030fa:	e8 81 01 00 00       	call   80103280 <mpinit>
  lapicinit();     // interrupt controller
801030ff:	e8 2c f7 ff ff       	call   80102830 <lapicinit>
  seginit();       // segment descriptors
80103104:	e8 57 3f 00 00       	call   80107060 <seginit>
  picinit();       // disable pic
80103109:	e8 52 03 00 00       	call   80103460 <picinit>
  ioapicinit();    // another interrupt controller
8010310e:	e8 fd f2 ff ff       	call   80102410 <ioapicinit>
  consoleinit();   // console hardware
80103113:	e8 18 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103118:	e8 03 32 00 00       	call   80106320 <uartinit>
  pinit();         // process table
8010311d:	e8 5e 08 00 00       	call   80103980 <pinit>
  tvinit();        // trap vectors
80103122:	e8 79 2e 00 00       	call   80105fa0 <tvinit>
  binit();         // buffer cache
80103127:	e8 14 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010312c:	e8 0f dd ff ff       	call   80100e40 <fileinit>
  ideinit();       // disk 
80103131:	e8 aa f0 ff ff       	call   801021e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103136:	83 c4 0c             	add    $0xc,%esp
80103139:	68 8a 00 00 00       	push   $0x8a
8010313e:	68 8c b4 10 80       	push   $0x8010b48c
80103143:	68 00 70 00 80       	push   $0x80007000
80103148:	e8 a3 18 00 00       	call   801049f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010314d:	83 c4 10             	add    $0x10,%esp
80103150:	69 05 e0 3d 11 80 b0 	imul   $0xb0,0x80113de0,%eax
80103157:	00 00 00 
8010315a:	05 60 38 11 80       	add    $0x80113860,%eax
8010315f:	3d 60 38 11 80       	cmp    $0x80113860,%eax
80103164:	76 7a                	jbe    801031e0 <main+0x110>
80103166:	bb 60 38 11 80       	mov    $0x80113860,%ebx
8010316b:	eb 1c                	jmp    80103189 <main+0xb9>
8010316d:	8d 76 00             	lea    0x0(%esi),%esi
80103170:	69 05 e0 3d 11 80 b0 	imul   $0xb0,0x80113de0,%eax
80103177:	00 00 00 
8010317a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103180:	05 60 38 11 80       	add    $0x80113860,%eax
80103185:	39 c3                	cmp    %eax,%ebx
80103187:	73 57                	jae    801031e0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103189:	e8 12 08 00 00       	call   801039a0 <mycpu>
8010318e:	39 c3                	cmp    %eax,%ebx
80103190:	74 de                	je     80103170 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103192:	e8 29 f5 ff ff       	call   801026c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103197:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010319a:	c7 05 f8 6f 00 80 b0 	movl   $0x801030b0,0x80006ff8
801031a1:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031a4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801031ab:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031ae:	05 00 10 00 00       	add    $0x1000,%eax
801031b3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031b8:	0f b6 03             	movzbl (%ebx),%eax
801031bb:	68 00 70 00 00       	push   $0x7000
801031c0:	50                   	push   %eax
801031c1:	e8 ba f7 ff ff       	call   80102980 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031c6:	83 c4 10             	add    $0x10,%esp
801031c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031d6:	85 c0                	test   %eax,%eax
801031d8:	74 f6                	je     801031d0 <main+0x100>
801031da:	eb 94                	jmp    80103170 <main+0xa0>
801031dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031e0:	83 ec 08             	sub    $0x8,%esp
801031e3:	68 00 00 00 8e       	push   $0x8e000000
801031e8:	68 00 00 40 80       	push   $0x80400000
801031ed:	e8 6e f4 ff ff       	call   80102660 <kinit2>
  userinit();      // first user process
801031f2:	e8 e9 09 00 00       	call   80103be0 <userinit>
  mpmain();        // finish this processor's setup
801031f7:	e8 74 fe ff ff       	call   80103070 <mpmain>
801031fc:	66 90                	xchg   %ax,%ax
801031fe:	66 90                	xchg   %ax,%ax

80103200 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	57                   	push   %edi
80103204:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103205:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010320b:	53                   	push   %ebx
  e = addr+len;
8010320c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010320f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103212:	39 de                	cmp    %ebx,%esi
80103214:	72 10                	jb     80103226 <mpsearch1+0x26>
80103216:	eb 50                	jmp    80103268 <mpsearch1+0x68>
80103218:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010321f:	00 
80103220:	89 fe                	mov    %edi,%esi
80103222:	39 fb                	cmp    %edi,%ebx
80103224:	76 42                	jbe    80103268 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103226:	83 ec 04             	sub    $0x4,%esp
80103229:	8d 7e 10             	lea    0x10(%esi),%edi
8010322c:	6a 04                	push   $0x4
8010322e:	68 2c 7a 10 80       	push   $0x80107a2c
80103233:	56                   	push   %esi
80103234:	e8 67 17 00 00       	call   801049a0 <memcmp>
80103239:	83 c4 10             	add    $0x10,%esp
8010323c:	85 c0                	test   %eax,%eax
8010323e:	75 e0                	jne    80103220 <mpsearch1+0x20>
80103240:	89 f2                	mov    %esi,%edx
80103242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103248:	0f b6 0a             	movzbl (%edx),%ecx
8010324b:	83 c2 01             	add    $0x1,%edx
8010324e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103250:	39 fa                	cmp    %edi,%edx
80103252:	75 f4                	jne    80103248 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103254:	84 c0                	test   %al,%al
80103256:	75 c8                	jne    80103220 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103258:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010325b:	89 f0                	mov    %esi,%eax
8010325d:	5b                   	pop    %ebx
8010325e:	5e                   	pop    %esi
8010325f:	5f                   	pop    %edi
80103260:	5d                   	pop    %ebp
80103261:	c3                   	ret
80103262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103268:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010326b:	31 f6                	xor    %esi,%esi
}
8010326d:	5b                   	pop    %ebx
8010326e:	89 f0                	mov    %esi,%eax
80103270:	5e                   	pop    %esi
80103271:	5f                   	pop    %edi
80103272:	5d                   	pop    %ebp
80103273:	c3                   	ret
80103274:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010327b:	00 
8010327c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103280 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103280:	f3 0f 1e fb          	endbr32
80103284:	55                   	push   %ebp
80103285:	89 e5                	mov    %esp,%ebp
80103287:	57                   	push   %edi
80103288:	56                   	push   %esi
80103289:	53                   	push   %ebx
8010328a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010328d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103294:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010329b:	c1 e0 08             	shl    $0x8,%eax
8010329e:	09 d0                	or     %edx,%eax
801032a0:	c1 e0 04             	shl    $0x4,%eax
801032a3:	75 1b                	jne    801032c0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032a5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032ac:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032b3:	c1 e0 08             	shl    $0x8,%eax
801032b6:	09 d0                	or     %edx,%eax
801032b8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032bb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032c0:	ba 00 04 00 00       	mov    $0x400,%edx
801032c5:	e8 36 ff ff ff       	call   80103200 <mpsearch1>
801032ca:	89 c6                	mov    %eax,%esi
801032cc:	85 c0                	test   %eax,%eax
801032ce:	0f 84 4c 01 00 00    	je     80103420 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032d4:	8b 5e 04             	mov    0x4(%esi),%ebx
801032d7:	85 db                	test   %ebx,%ebx
801032d9:	0f 84 61 01 00 00    	je     80103440 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801032df:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032e2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032e8:	6a 04                	push   $0x4
801032ea:	68 31 7a 10 80       	push   $0x80107a31
801032ef:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032f3:	e8 a8 16 00 00       	call   801049a0 <memcmp>
801032f8:	83 c4 10             	add    $0x10,%esp
801032fb:	85 c0                	test   %eax,%eax
801032fd:	0f 85 3d 01 00 00    	jne    80103440 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103303:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010330a:	3c 01                	cmp    $0x1,%al
8010330c:	74 08                	je     80103316 <mpinit+0x96>
8010330e:	3c 04                	cmp    $0x4,%al
80103310:	0f 85 2a 01 00 00    	jne    80103440 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103316:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010331d:	66 85 d2             	test   %dx,%dx
80103320:	74 26                	je     80103348 <mpinit+0xc8>
80103322:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103325:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103327:	31 d2                	xor    %edx,%edx
80103329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103330:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103337:	83 c0 01             	add    $0x1,%eax
8010333a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010333c:	39 f8                	cmp    %edi,%eax
8010333e:	75 f0                	jne    80103330 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103340:	84 d2                	test   %dl,%dl
80103342:	0f 85 f8 00 00 00    	jne    80103440 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103348:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010334e:	a3 5c 37 11 80       	mov    %eax,0x8011375c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103353:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103359:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103360:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103365:	03 55 e4             	add    -0x1c(%ebp),%edx
80103368:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010336b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103370:	39 c2                	cmp    %eax,%edx
80103372:	76 15                	jbe    80103389 <mpinit+0x109>
    switch(*p){
80103374:	0f b6 08             	movzbl (%eax),%ecx
80103377:	80 f9 02             	cmp    $0x2,%cl
8010337a:	74 5c                	je     801033d8 <mpinit+0x158>
8010337c:	77 42                	ja     801033c0 <mpinit+0x140>
8010337e:	84 c9                	test   %cl,%cl
80103380:	74 6e                	je     801033f0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103382:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103385:	39 c2                	cmp    %eax,%edx
80103387:	77 eb                	ja     80103374 <mpinit+0xf4>
80103389:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010338c:	85 db                	test   %ebx,%ebx
8010338e:	0f 84 b9 00 00 00    	je     8010344d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103394:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103398:	74 15                	je     801033af <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010339a:	b8 70 00 00 00       	mov    $0x70,%eax
8010339f:	ba 22 00 00 00       	mov    $0x22,%edx
801033a4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033a5:	ba 23 00 00 00       	mov    $0x23,%edx
801033aa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033ab:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ae:	ee                   	out    %al,(%dx)
  }
}
801033af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033b2:	5b                   	pop    %ebx
801033b3:	5e                   	pop    %esi
801033b4:	5f                   	pop    %edi
801033b5:	5d                   	pop    %ebp
801033b6:	c3                   	ret
801033b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033be:	00 
801033bf:	90                   	nop
    switch(*p){
801033c0:	83 e9 03             	sub    $0x3,%ecx
801033c3:	80 f9 01             	cmp    $0x1,%cl
801033c6:	76 ba                	jbe    80103382 <mpinit+0x102>
801033c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801033cf:	eb 9f                	jmp    80103370 <mpinit+0xf0>
801033d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033d8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033dc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033df:	88 0d 40 38 11 80    	mov    %cl,0x80113840
      continue;
801033e5:	eb 89                	jmp    80103370 <mpinit+0xf0>
801033e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033ee:	00 
801033ef:	90                   	nop
      if(ncpu < NCPU) {
801033f0:	8b 0d e0 3d 11 80    	mov    0x80113de0,%ecx
801033f6:	83 f9 07             	cmp    $0x7,%ecx
801033f9:	7f 19                	jg     80103414 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033fb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103401:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103405:	83 c1 01             	add    $0x1,%ecx
80103408:	89 0d e0 3d 11 80    	mov    %ecx,0x80113de0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010340e:	88 9f 60 38 11 80    	mov    %bl,-0x7feec7a0(%edi)
      p += sizeof(struct mpproc);
80103414:	83 c0 14             	add    $0x14,%eax
      continue;
80103417:	e9 54 ff ff ff       	jmp    80103370 <mpinit+0xf0>
8010341c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103420:	ba 00 00 01 00       	mov    $0x10000,%edx
80103425:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010342a:	e8 d1 fd ff ff       	call   80103200 <mpsearch1>
8010342f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103431:	85 c0                	test   %eax,%eax
80103433:	0f 85 9b fe ff ff    	jne    801032d4 <mpinit+0x54>
80103439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103440:	83 ec 0c             	sub    $0xc,%esp
80103443:	68 36 7a 10 80       	push   $0x80107a36
80103448:	e8 43 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010344d:	83 ec 0c             	sub    $0xc,%esp
80103450:	68 2c 7e 10 80       	push   $0x80107e2c
80103455:	e8 36 cf ff ff       	call   80100390 <panic>
8010345a:	66 90                	xchg   %ax,%ax
8010345c:	66 90                	xchg   %ax,%ax
8010345e:	66 90                	xchg   %ax,%ax

80103460 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103460:	f3 0f 1e fb          	endbr32
80103464:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103469:	ba 21 00 00 00       	mov    $0x21,%edx
8010346e:	ee                   	out    %al,(%dx)
8010346f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103474:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103475:	c3                   	ret
80103476:	66 90                	xchg   %ax,%ax
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103480:	f3 0f 1e fb          	endbr32
80103484:	55                   	push   %ebp
80103485:	89 e5                	mov    %esp,%ebp
80103487:	57                   	push   %edi
80103488:	56                   	push   %esi
80103489:	53                   	push   %ebx
8010348a:	83 ec 0c             	sub    $0xc,%esp
8010348d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103490:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103493:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103499:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010349f:	e8 bc d9 ff ff       	call   80100e60 <filealloc>
801034a4:	89 03                	mov    %eax,(%ebx)
801034a6:	85 c0                	test   %eax,%eax
801034a8:	0f 84 ac 00 00 00    	je     8010355a <pipealloc+0xda>
801034ae:	e8 ad d9 ff ff       	call   80100e60 <filealloc>
801034b3:	89 06                	mov    %eax,(%esi)
801034b5:	85 c0                	test   %eax,%eax
801034b7:	0f 84 8b 00 00 00    	je     80103548 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034bd:	e8 fe f1 ff ff       	call   801026c0 <kalloc>
801034c2:	89 c7                	mov    %eax,%edi
801034c4:	85 c0                	test   %eax,%eax
801034c6:	0f 84 b4 00 00 00    	je     80103580 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
801034cc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034d3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034d6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034d9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034e0:	00 00 00 
  p->nwrite = 0;
801034e3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034ea:	00 00 00 
  p->nread = 0;
801034ed:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034f4:	00 00 00 
  initlock(&p->lock, "pipe");
801034f7:	68 4e 7a 10 80       	push   $0x80107a4e
801034fc:	50                   	push   %eax
801034fd:	e8 be 11 00 00       	call   801046c0 <initlock>
  (*f0)->type = FD_PIPE;
80103502:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103504:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103507:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010350d:	8b 03                	mov    (%ebx),%eax
8010350f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103513:	8b 03                	mov    (%ebx),%eax
80103515:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103519:	8b 03                	mov    (%ebx),%eax
8010351b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010351e:	8b 06                	mov    (%esi),%eax
80103520:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103526:	8b 06                	mov    (%esi),%eax
80103528:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010352c:	8b 06                	mov    (%esi),%eax
8010352e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103532:	8b 06                	mov    (%esi),%eax
80103534:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103537:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010353a:	31 c0                	xor    %eax,%eax
}
8010353c:	5b                   	pop    %ebx
8010353d:	5e                   	pop    %esi
8010353e:	5f                   	pop    %edi
8010353f:	5d                   	pop    %ebp
80103540:	c3                   	ret
80103541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103548:	8b 03                	mov    (%ebx),%eax
8010354a:	85 c0                	test   %eax,%eax
8010354c:	74 1e                	je     8010356c <pipealloc+0xec>
    fileclose(*f0);
8010354e:	83 ec 0c             	sub    $0xc,%esp
80103551:	50                   	push   %eax
80103552:	e8 c9 d9 ff ff       	call   80100f20 <fileclose>
80103557:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010355a:	8b 06                	mov    (%esi),%eax
8010355c:	85 c0                	test   %eax,%eax
8010355e:	74 0c                	je     8010356c <pipealloc+0xec>
    fileclose(*f1);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	50                   	push   %eax
80103564:	e8 b7 d9 ff ff       	call   80100f20 <fileclose>
80103569:	83 c4 10             	add    $0x10,%esp
}
8010356c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010356f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103574:	5b                   	pop    %ebx
80103575:	5e                   	pop    %esi
80103576:	5f                   	pop    %edi
80103577:	5d                   	pop    %ebp
80103578:	c3                   	ret
80103579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103580:	8b 03                	mov    (%ebx),%eax
80103582:	85 c0                	test   %eax,%eax
80103584:	75 c8                	jne    8010354e <pipealloc+0xce>
80103586:	eb d2                	jmp    8010355a <pipealloc+0xda>
80103588:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010358f:	00 

80103590 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103590:	f3 0f 1e fb          	endbr32
80103594:	55                   	push   %ebp
80103595:	89 e5                	mov    %esp,%ebp
80103597:	56                   	push   %esi
80103598:	53                   	push   %ebx
80103599:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010359c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010359f:	83 ec 0c             	sub    $0xc,%esp
801035a2:	53                   	push   %ebx
801035a3:	e8 98 12 00 00       	call   80104840 <acquire>
  if(writable){
801035a8:	83 c4 10             	add    $0x10,%esp
801035ab:	85 f6                	test   %esi,%esi
801035ad:	74 41                	je     801035f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801035af:	83 ec 0c             	sub    $0xc,%esp
801035b2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035b8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035bf:	00 00 00 
    wakeup(&p->nread);
801035c2:	50                   	push   %eax
801035c3:	e8 d8 0d 00 00       	call   801043a0 <wakeup>
801035c8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035cb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035d1:	85 d2                	test   %edx,%edx
801035d3:	75 0a                	jne    801035df <pipeclose+0x4f>
801035d5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035db:	85 c0                	test   %eax,%eax
801035dd:	74 31                	je     80103610 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035df:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e5:	5b                   	pop    %ebx
801035e6:	5e                   	pop    %esi
801035e7:	5d                   	pop    %ebp
    release(&p->lock);
801035e8:	e9 13 13 00 00       	jmp    80104900 <release>
801035ed:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103600:	00 00 00 
    wakeup(&p->nwrite);
80103603:	50                   	push   %eax
80103604:	e8 97 0d 00 00       	call   801043a0 <wakeup>
80103609:	83 c4 10             	add    $0x10,%esp
8010360c:	eb bd                	jmp    801035cb <pipeclose+0x3b>
8010360e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	53                   	push   %ebx
80103614:	e8 e7 12 00 00       	call   80104900 <release>
    kfree((char*)p);
80103619:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010361c:	83 c4 10             	add    $0x10,%esp
}
8010361f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103622:	5b                   	pop    %ebx
80103623:	5e                   	pop    %esi
80103624:	5d                   	pop    %ebp
    kfree((char*)p);
80103625:	e9 d6 ee ff ff       	jmp    80102500 <kfree>
8010362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103630 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103630:	f3 0f 1e fb          	endbr32
80103634:	55                   	push   %ebp
80103635:	89 e5                	mov    %esp,%ebp
80103637:	57                   	push   %edi
80103638:	56                   	push   %esi
80103639:	53                   	push   %ebx
8010363a:	83 ec 28             	sub    $0x28,%esp
8010363d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103640:	53                   	push   %ebx
80103641:	e8 fa 11 00 00       	call   80104840 <acquire>
  for(i = 0; i < n; i++){
80103646:	8b 45 10             	mov    0x10(%ebp),%eax
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	85 c0                	test   %eax,%eax
8010364e:	0f 8e bc 00 00 00    	jle    80103710 <pipewrite+0xe0>
80103654:	8b 45 0c             	mov    0xc(%ebp),%eax
80103657:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010365d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103663:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103666:	03 45 10             	add    0x10(%ebp),%eax
80103669:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010366c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103672:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103678:	89 ca                	mov    %ecx,%edx
8010367a:	05 00 02 00 00       	add    $0x200,%eax
8010367f:	39 c1                	cmp    %eax,%ecx
80103681:	74 3b                	je     801036be <pipewrite+0x8e>
80103683:	eb 63                	jmp    801036e8 <pipewrite+0xb8>
80103685:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103688:	e8 a3 03 00 00       	call   80103a30 <myproc>
8010368d:	8b 48 24             	mov    0x24(%eax),%ecx
80103690:	85 c9                	test   %ecx,%ecx
80103692:	75 34                	jne    801036c8 <pipewrite+0x98>
      wakeup(&p->nread);
80103694:	83 ec 0c             	sub    $0xc,%esp
80103697:	57                   	push   %edi
80103698:	e8 03 0d 00 00       	call   801043a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010369d:	58                   	pop    %eax
8010369e:	5a                   	pop    %edx
8010369f:	53                   	push   %ebx
801036a0:	56                   	push   %esi
801036a1:	e8 3a 0b 00 00       	call   801041e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036a6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036ac:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036b2:	83 c4 10             	add    $0x10,%esp
801036b5:	05 00 02 00 00       	add    $0x200,%eax
801036ba:	39 c2                	cmp    %eax,%edx
801036bc:	75 2a                	jne    801036e8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801036be:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036c4:	85 c0                	test   %eax,%eax
801036c6:	75 c0                	jne    80103688 <pipewrite+0x58>
        release(&p->lock);
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	53                   	push   %ebx
801036cc:	e8 2f 12 00 00       	call   80104900 <release>
        return -1;
801036d1:	83 c4 10             	add    $0x10,%esp
801036d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036dc:	5b                   	pop    %ebx
801036dd:	5e                   	pop    %esi
801036de:	5f                   	pop    %edi
801036df:	5d                   	pop    %ebp
801036e0:	c3                   	ret
801036e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036e8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036eb:	8d 4a 01             	lea    0x1(%edx),%ecx
801036ee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036f4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036fa:	0f b6 06             	movzbl (%esi),%eax
801036fd:	83 c6 01             	add    $0x1,%esi
80103700:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103703:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103707:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010370a:	0f 85 5c ff ff ff    	jne    8010366c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103710:	83 ec 0c             	sub    $0xc,%esp
80103713:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103719:	50                   	push   %eax
8010371a:	e8 81 0c 00 00       	call   801043a0 <wakeup>
  release(&p->lock);
8010371f:	89 1c 24             	mov    %ebx,(%esp)
80103722:	e8 d9 11 00 00       	call   80104900 <release>
  return n;
80103727:	8b 45 10             	mov    0x10(%ebp),%eax
8010372a:	83 c4 10             	add    $0x10,%esp
8010372d:	eb aa                	jmp    801036d9 <pipewrite+0xa9>
8010372f:	90                   	nop

80103730 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103730:	f3 0f 1e fb          	endbr32
80103734:	55                   	push   %ebp
80103735:	89 e5                	mov    %esp,%ebp
80103737:	57                   	push   %edi
80103738:	56                   	push   %esi
80103739:	53                   	push   %ebx
8010373a:	83 ec 18             	sub    $0x18,%esp
8010373d:	8b 75 08             	mov    0x8(%ebp),%esi
80103740:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103743:	56                   	push   %esi
80103744:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010374a:	e8 f1 10 00 00       	call   80104840 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010374f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010375e:	74 33                	je     80103793 <piperead+0x63>
80103760:	eb 3b                	jmp    8010379d <piperead+0x6d>
80103762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103768:	e8 c3 02 00 00       	call   80103a30 <myproc>
8010376d:	8b 48 24             	mov    0x24(%eax),%ecx
80103770:	85 c9                	test   %ecx,%ecx
80103772:	0f 85 88 00 00 00    	jne    80103800 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103778:	83 ec 08             	sub    $0x8,%esp
8010377b:	56                   	push   %esi
8010377c:	53                   	push   %ebx
8010377d:	e8 5e 0a 00 00       	call   801041e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103782:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103788:	83 c4 10             	add    $0x10,%esp
8010378b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103791:	75 0a                	jne    8010379d <piperead+0x6d>
80103793:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103799:	85 c0                	test   %eax,%eax
8010379b:	75 cb                	jne    80103768 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010379d:	8b 55 10             	mov    0x10(%ebp),%edx
801037a0:	31 db                	xor    %ebx,%ebx
801037a2:	85 d2                	test   %edx,%edx
801037a4:	7f 28                	jg     801037ce <piperead+0x9e>
801037a6:	eb 34                	jmp    801037dc <piperead+0xac>
801037a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801037af:	00 
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037b0:	8d 48 01             	lea    0x1(%eax),%ecx
801037b3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037b8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037be:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037c3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037c6:	83 c3 01             	add    $0x1,%ebx
801037c9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037cc:	74 0e                	je     801037dc <piperead+0xac>
    if(p->nread == p->nwrite)
801037ce:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037d4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037da:	75 d4                	jne    801037b0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037dc:	83 ec 0c             	sub    $0xc,%esp
801037df:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037e5:	50                   	push   %eax
801037e6:	e8 b5 0b 00 00       	call   801043a0 <wakeup>
  release(&p->lock);
801037eb:	89 34 24             	mov    %esi,(%esp)
801037ee:	e8 0d 11 00 00       	call   80104900 <release>
  return i;
801037f3:	83 c4 10             	add    $0x10,%esp
}
801037f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f9:	89 d8                	mov    %ebx,%eax
801037fb:	5b                   	pop    %ebx
801037fc:	5e                   	pop    %esi
801037fd:	5f                   	pop    %edi
801037fe:	5d                   	pop    %ebp
801037ff:	c3                   	ret
      release(&p->lock);
80103800:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103803:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103808:	56                   	push   %esi
80103809:	e8 f2 10 00 00       	call   80104900 <release>
      return -1;
8010380e:	83 c4 10             	add    $0x10,%esp
}
80103811:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103814:	89 d8                	mov    %ebx,%eax
80103816:	5b                   	pop    %ebx
80103817:	5e                   	pop    %esi
80103818:	5f                   	pop    %edi
80103819:	5d                   	pop    %ebp
8010381a:	c3                   	ret
8010381b:	66 90                	xchg   %ax,%ax
8010381d:	66 90                	xchg   %ax,%ax
8010381f:	90                   	nop

80103820 <allocproc>:
}


static struct proc *
allocproc(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103824:	bb 34 44 11 80       	mov    $0x80114434,%ebx
{
80103829:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010382c:	68 00 44 11 80       	push   $0x80114400
80103831:	e8 0a 10 00 00       	call   80104840 <acquire>
80103836:	83 c4 10             	add    $0x10,%esp
80103839:	eb 17                	jmp    80103852 <allocproc+0x32>
8010383b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103840:	81 c3 f0 00 00 00    	add    $0xf0,%ebx
80103846:	81 fb 34 80 11 80    	cmp    $0x80118034,%ebx
8010384c:	0f 84 be 00 00 00    	je     80103910 <allocproc+0xf0>
    if (p->state == UNUSED)
80103852:	8b 43 0c             	mov    0xc(%ebx),%eax
80103855:	85 c0                	test   %eax,%eax
80103857:	75 e7                	jne    80103840 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103859:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010385e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103861:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103868:	89 43 10             	mov    %eax,0x10(%ebx)
8010386b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010386e:	68 00 44 11 80       	push   $0x80114400
  p->pid = nextpid++;
80103873:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103879:	e8 82 10 00 00       	call   80104900 <release>

  // ✅ Special handling for PID 1 (init)
  if (p->pid == 1)
8010387e:	83 c4 10             	add    $0x10,%esp
80103881:	83 7b 10 01          	cmpl   $0x1,0x10(%ebx)
80103885:	74 49                	je     801038d0 <allocproc+0xb0>
  // {
  //   cprintf("id=%d,Bit %d = %d\n",p->pid, i+1,p->syscall_bitmask[i]);
  // }

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
80103887:	e8 34 ee ff ff       	call   801026c0 <kalloc>
8010388c:	89 43 08             	mov    %eax,0x8(%ebx)
8010388f:	85 c0                	test   %eax,%eax
80103891:	74 66                	je     801038f9 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103893:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
80103899:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010389c:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038a1:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
801038a4:	c7 40 14 86 5f 10 80 	movl   $0x80105f86,0x14(%eax)
  p->context = (struct context *)sp;
801038ab:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038ae:	6a 14                	push   $0x14
801038b0:	6a 00                	push   $0x0
801038b2:	50                   	push   %eax
801038b3:	e8 98 10 00 00       	call   80104950 <memset>
  p->context->eip = (uint)forkret;
801038b8:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038bb:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038be:	c7 40 10 30 39 10 80 	movl   $0x80103930,0x10(%eax)
}
801038c5:	89 d8                	mov    %ebx,%eax
801038c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ca:	c9                   	leave
801038cb:	c3                   	ret
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038d0:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
801038d6:	8d 93 ec 00 00 00    	lea    0xec(%ebx),%edx
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p->syscall_bitmask[i] = 0;
801038e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (int i = 0; i < NUM_SYSCALLS; i++)
801038e6:	83 c0 04             	add    $0x4,%eax
801038e9:	39 c2                	cmp    %eax,%edx
801038eb:	75 f3                	jne    801038e0 <allocproc+0xc0>
  if ((p->kstack = kalloc()) == 0)
801038ed:	e8 ce ed ff ff       	call   801026c0 <kalloc>
801038f2:	89 43 08             	mov    %eax,0x8(%ebx)
801038f5:	85 c0                	test   %eax,%eax
801038f7:	75 9a                	jne    80103893 <allocproc+0x73>
    p->state = UNUSED;
801038f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103900:	31 db                	xor    %ebx,%ebx
}
80103902:	89 d8                	mov    %ebx,%eax
80103904:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103907:	c9                   	leave
80103908:	c3                   	ret
80103909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103910:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103913:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103915:	68 00 44 11 80       	push   $0x80114400
8010391a:	e8 e1 0f 00 00       	call   80104900 <release>
}
8010391f:	89 d8                	mov    %ebx,%eax
  return 0;
80103921:	83 c4 10             	add    $0x10,%esp
}
80103924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103927:	c9                   	leave
80103928:	c3                   	ret
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103930 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
80103930:	f3 0f 1e fb          	endbr32
80103934:	55                   	push   %ebp
80103935:	89 e5                	mov    %esp,%ebp
80103937:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010393a:	68 00 44 11 80       	push   $0x80114400
8010393f:	e8 bc 0f 00 00       	call   80104900 <release>

  if (first)
80103944:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103949:	83 c4 10             	add    $0x10,%esp
8010394c:	85 c0                	test   %eax,%eax
8010394e:	75 08                	jne    80103958 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103950:	c9                   	leave
80103951:	c3                   	ret
80103952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103958:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010395f:	00 00 00 
    iinit(ROOTDEV);
80103962:	83 ec 0c             	sub    $0xc,%esp
80103965:	6a 01                	push   $0x1
80103967:	e8 44 dc ff ff       	call   801015b0 <iinit>
    initlog(ROOTDEV);
8010396c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103973:	e8 a8 f3 ff ff       	call   80102d20 <initlog>
}
80103978:	83 c4 10             	add    $0x10,%esp
8010397b:	c9                   	leave
8010397c:	c3                   	ret
8010397d:	8d 76 00             	lea    0x0(%esi),%esi

80103980 <pinit>:
{
80103980:	f3 0f 1e fb          	endbr32
80103984:	55                   	push   %ebp
80103985:	89 e5                	mov    %esp,%ebp
80103987:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010398a:	68 53 7a 10 80       	push   $0x80107a53
8010398f:	68 00 44 11 80       	push   $0x80114400
80103994:	e8 27 0d 00 00       	call   801046c0 <initlock>
}
80103999:	83 c4 10             	add    $0x10,%esp
8010399c:	c9                   	leave
8010399d:	c3                   	ret
8010399e:	66 90                	xchg   %ax,%ax

801039a0 <mycpu>:
{
801039a0:	f3 0f 1e fb          	endbr32
801039a4:	55                   	push   %ebp
801039a5:	89 e5                	mov    %esp,%ebp
801039a7:	56                   	push   %esi
801039a8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039a9:	9c                   	pushf
801039aa:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801039ab:	f6 c4 02             	test   $0x2,%ah
801039ae:	75 4a                	jne    801039fa <mycpu+0x5a>
  apicid = lapicid();
801039b0:	e8 7b ef ff ff       	call   80102930 <lapicid>
  for (i = 0; i < ncpu; ++i)
801039b5:	8b 35 e0 3d 11 80    	mov    0x80113de0,%esi
  apicid = lapicid();
801039bb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i)
801039bd:	85 f6                	test   %esi,%esi
801039bf:	7e 2c                	jle    801039ed <mycpu+0x4d>
801039c1:	31 d2                	xor    %edx,%edx
801039c3:	eb 0a                	jmp    801039cf <mycpu+0x2f>
801039c5:	8d 76 00             	lea    0x0(%esi),%esi
801039c8:	83 c2 01             	add    $0x1,%edx
801039cb:	39 f2                	cmp    %esi,%edx
801039cd:	74 1e                	je     801039ed <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801039cf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039d5:	0f b6 81 60 38 11 80 	movzbl -0x7feec7a0(%ecx),%eax
801039dc:	39 d8                	cmp    %ebx,%eax
801039de:	75 e8                	jne    801039c8 <mycpu+0x28>
}
801039e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039e3:	8d 81 60 38 11 80    	lea    -0x7feec7a0(%ecx),%eax
}
801039e9:	5b                   	pop    %ebx
801039ea:	5e                   	pop    %esi
801039eb:	5d                   	pop    %ebp
801039ec:	c3                   	ret
  panic("unknown apicid\n");
801039ed:	83 ec 0c             	sub    $0xc,%esp
801039f0:	68 5a 7a 10 80       	push   $0x80107a5a
801039f5:	e8 96 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801039fa:	83 ec 0c             	sub    $0xc,%esp
801039fd:	68 4c 7e 10 80       	push   $0x80107e4c
80103a02:	e8 89 c9 ff ff       	call   80100390 <panic>
80103a07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a0e:	00 
80103a0f:	90                   	nop

80103a10 <cpuid>:
{
80103a10:	f3 0f 1e fb          	endbr32
80103a14:	55                   	push   %ebp
80103a15:	89 e5                	mov    %esp,%ebp
80103a17:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103a1a:	e8 81 ff ff ff       	call   801039a0 <mycpu>
}
80103a1f:	c9                   	leave
  return mycpu() - cpus;
80103a20:	2d 60 38 11 80       	sub    $0x80113860,%eax
80103a25:	c1 f8 04             	sar    $0x4,%eax
80103a28:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a2e:	c3                   	ret
80103a2f:	90                   	nop

80103a30 <myproc>:
{
80103a30:	f3 0f 1e fb          	endbr32
80103a34:	55                   	push   %ebp
80103a35:	89 e5                	mov    %esp,%ebp
80103a37:	53                   	push   %ebx
80103a38:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a3b:	e8 00 0d 00 00       	call   80104740 <pushcli>
  c = mycpu();
80103a40:	e8 5b ff ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103a45:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a4b:	e8 40 0d 00 00       	call   80104790 <popcli>
}
80103a50:	83 c4 04             	add    $0x4,%esp
80103a53:	89 d8                	mov    %ebx,%eax
80103a55:	5b                   	pop    %ebx
80103a56:	5d                   	pop    %ebp
80103a57:	c3                   	ret
80103a58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a5f:	00 

80103a60 <add_to_history>:
{
80103a60:	f3 0f 1e fb          	endbr32
80103a64:	55                   	push   %ebp
80103a65:	89 e5                	mov    %esp,%ebp
80103a67:	56                   	push   %esi
80103a68:	53                   	push   %ebx
80103a69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (strncmp(p->name, "init", 4) == 0)
80103a6c:	8d 73 6c             	lea    0x6c(%ebx),%esi
80103a6f:	83 ec 04             	sub    $0x4,%esp
80103a72:	6a 04                	push   $0x4
80103a74:	68 6a 7a 10 80       	push   $0x80107a6a
80103a79:	56                   	push   %esi
80103a7a:	e8 e1 0f 00 00       	call   80104a60 <strncmp>
80103a7f:	83 c4 10             	add    $0x10,%esp
80103a82:	85 c0                	test   %eax,%eax
80103a84:	74 0a                	je     80103a90 <add_to_history+0x30>
  if (history_count >= MAX_HISTORY)
80103a86:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103a8b:	83 f8 3f             	cmp    $0x3f,%eax
80103a8e:	7e 10                	jle    80103aa0 <add_to_history+0x40>
}
80103a90:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a93:	5b                   	pop    %ebx
80103a94:	5e                   	pop    %esi
80103a95:	5d                   	pop    %ebp
80103a96:	c3                   	ret
80103a97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a9e:	00 
80103a9f:	90                   	nop
  history[history_count].pid = p->pid;
80103aa0:	8b 53 10             	mov    0x10(%ebx),%edx
80103aa3:	8d 04 40             	lea    (%eax,%eax,2),%eax
  safestrcpy(history[history_count].name, p->name, sizeof(p->name) + 1);
80103aa6:	83 ec 04             	sub    $0x4,%esp
  history[history_count].pid = p->pid;
80103aa9:	c1 e0 03             	shl    $0x3,%eax
  safestrcpy(history[history_count].name, p->name, sizeof(p->name) + 1);
80103aac:	6a 11                	push   $0x11
  history[history_count].pid = p->pid;
80103aae:	89 90 00 3e 11 80    	mov    %edx,-0x7feec200(%eax)
  safestrcpy(history[history_count].name, p->name, sizeof(p->name) + 1);
80103ab4:	05 04 3e 11 80       	add    $0x80113e04,%eax
80103ab9:	56                   	push   %esi
80103aba:	50                   	push   %eax
80103abb:	e8 50 10 00 00       	call   80104b10 <safestrcpy>
  history[history_count].mem_usage = p->sz;
80103ac0:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103ac5:	8b 0b                	mov    (%ebx),%ecx
  history_count++;
80103ac7:	83 c4 10             	add    $0x10,%esp
  history[history_count].mem_usage = p->sz;
80103aca:	8d 14 40             	lea    (%eax,%eax,2),%edx
  history_count++;
80103acd:	83 c0 01             	add    $0x1,%eax
  history[history_count].mem_usage = p->sz;
80103ad0:	89 0c d5 14 3e 11 80 	mov    %ecx,-0x7feec1ec(,%edx,8)
  history_count++;
80103ad7:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
}
80103adc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103adf:	5b                   	pop    %ebx
80103ae0:	5e                   	pop    %esi
80103ae1:	5d                   	pop    %ebp
80103ae2:	c3                   	ret
80103ae3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103aea:	00 
80103aeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103af0 <gethistory>:
{
80103af0:	f3 0f 1e fb          	endbr32
80103af4:	55                   	push   %ebp
80103af5:	89 e5                	mov    %esp,%ebp
80103af7:	57                   	push   %edi
80103af8:	56                   	push   %esi
80103af9:	53                   	push   %ebx
80103afa:	83 ec 4c             	sub    $0x4c,%esp
  for (int i = 0; i < history_count - 1; i++)
80103afd:	8b 15 b8 b5 10 80    	mov    0x8010b5b8,%edx
80103b03:	8d 42 ff             	lea    -0x1(%edx),%eax
80103b06:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80103b09:	85 c0                	test   %eax,%eax
80103b0b:	0f 8e 84 00 00 00    	jle    80103b95 <gethistory+0xa5>
80103b11:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103b14:	8d 04 52             	lea    (%edx,%edx,2),%eax
80103b17:	8d 0c c5 e8 3d 11 80 	lea    -0x7feec218(,%eax,8),%ecx
80103b1e:	89 ca                	mov    %ecx,%edx
{
80103b20:	b9 00 3e 11 80       	mov    $0x80113e00,%ecx
80103b25:	8d 76 00             	lea    0x0(%esi),%esi
      if (history[j].pid > history[j + 1].pid)
80103b28:	8b 01                	mov    (%ecx),%eax
80103b2a:	3b 41 18             	cmp    0x18(%ecx),%eax
80103b2d:	7e 56                	jle    80103b85 <gethistory+0x95>
        history[j] = history[j + 1];
80103b2f:	8b 79 18             	mov    0x18(%ecx),%edi
        struct history_entry temp = history[j];
80103b32:	8b 71 04             	mov    0x4(%ecx),%esi
        history[j + 1] = temp;
80103b35:	89 41 18             	mov    %eax,0x18(%ecx)
        struct history_entry temp = history[j];
80103b38:	8b 59 0c             	mov    0xc(%ecx),%ebx
        history[j] = history[j + 1];
80103b3b:	89 39                	mov    %edi,(%ecx)
80103b3d:	8b 79 1c             	mov    0x1c(%ecx),%edi
        struct history_entry temp = history[j];
80103b40:	89 75 c4             	mov    %esi,-0x3c(%ebp)
80103b43:	8b 71 08             	mov    0x8(%ecx),%esi
        history[j] = history[j + 1];
80103b46:	89 79 04             	mov    %edi,0x4(%ecx)
80103b49:	8b 79 20             	mov    0x20(%ecx),%edi
        history[j + 1] = temp;
80103b4c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
        struct history_entry temp = history[j];
80103b4f:	89 75 c0             	mov    %esi,-0x40(%ebp)
        history[j] = history[j + 1];
80103b52:	89 79 08             	mov    %edi,0x8(%ecx)
80103b55:	8b 79 24             	mov    0x24(%ecx),%edi
        history[j + 1] = temp;
80103b58:	89 41 1c             	mov    %eax,0x1c(%ecx)
80103b5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
        history[j] = history[j + 1];
80103b5e:	89 79 0c             	mov    %edi,0xc(%ecx)
80103b61:	8b 79 28             	mov    0x28(%ecx),%edi
        struct history_entry temp = history[j];
80103b64:	89 5d bc             	mov    %ebx,-0x44(%ebp)
80103b67:	8b 71 10             	mov    0x10(%ecx),%esi
80103b6a:	8b 59 14             	mov    0x14(%ecx),%ebx
        history[j] = history[j + 1];
80103b6d:	89 79 10             	mov    %edi,0x10(%ecx)
        history[j + 1] = temp;
80103b70:	89 41 20             	mov    %eax,0x20(%ecx)
        history[j] = history[j + 1];
80103b73:	8b 79 2c             	mov    0x2c(%ecx),%edi
        history[j + 1] = temp;
80103b76:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103b79:	89 71 28             	mov    %esi,0x28(%ecx)
        history[j] = history[j + 1];
80103b7c:	89 79 14             	mov    %edi,0x14(%ecx)
        history[j + 1] = temp;
80103b7f:	89 41 24             	mov    %eax,0x24(%ecx)
80103b82:	89 59 2c             	mov    %ebx,0x2c(%ecx)
    for (int j = 0; j < history_count - i - 1; j++)
80103b85:	83 c1 18             	add    $0x18,%ecx
80103b88:	39 d1                	cmp    %edx,%ecx
80103b8a:	75 9c                	jne    80103b28 <gethistory+0x38>
  for (int i = 0; i < history_count - 1; i++)
80103b8c:	83 ea 18             	sub    $0x18,%edx
80103b8f:	83 6d b8 01          	subl   $0x1,-0x48(%ebp)
80103b93:	75 8b                	jne    80103b20 <gethistory+0x30>
  for (int i = 0; i < history_count; i++)
80103b95:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80103b98:	85 c0                	test   %eax,%eax
80103b9a:	7e 2e                	jle    80103bca <gethistory+0xda>
80103b9c:	bb 04 3e 11 80       	mov    $0x80113e04,%ebx
80103ba1:	31 f6                	xor    %esi,%esi
80103ba3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    cprintf("%d\t%s\t%d\n", history[i].pid, history[i].name, history[i].mem_usage);
80103ba8:	ff 73 10             	push   0x10(%ebx)
  for (int i = 0; i < history_count; i++)
80103bab:	83 c6 01             	add    $0x1,%esi
    cprintf("%d\t%s\t%d\n", history[i].pid, history[i].name, history[i].mem_usage);
80103bae:	53                   	push   %ebx
80103baf:	83 c3 18             	add    $0x18,%ebx
80103bb2:	ff 73 e4             	push   -0x1c(%ebx)
80103bb5:	68 6f 7a 10 80       	push   $0x80107a6f
80103bba:	e8 f1 ca ff ff       	call   801006b0 <cprintf>
  for (int i = 0; i < history_count; i++)
80103bbf:	83 c4 10             	add    $0x10,%esp
80103bc2:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103bc8:	7f de                	jg     80103ba8 <gethistory+0xb8>
}
80103bca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bcd:	31 c0                	xor    %eax,%eax
80103bcf:	5b                   	pop    %ebx
80103bd0:	5e                   	pop    %esi
80103bd1:	5f                   	pop    %edi
80103bd2:	5d                   	pop    %ebp
80103bd3:	c3                   	ret
80103bd4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bdb:	00 
80103bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103be0 <userinit>:
{
80103be0:	f3 0f 1e fb          	endbr32
80103be4:	55                   	push   %ebp
80103be5:	89 e5                	mov    %esp,%ebp
80103be7:	53                   	push   %ebx
80103be8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103beb:	e8 30 fc ff ff       	call   80103820 <allocproc>
80103bf0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bf2:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
  if ((p->pgdir = setupkvm()) == 0)
80103bf7:	e8 54 39 00 00       	call   80107550 <setupkvm>
80103bfc:	89 43 04             	mov    %eax,0x4(%ebx)
80103bff:	85 c0                	test   %eax,%eax
80103c01:	0f 84 bd 00 00 00    	je     80103cc4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c07:	83 ec 04             	sub    $0x4,%esp
80103c0a:	68 2c 00 00 00       	push   $0x2c
80103c0f:	68 60 b4 10 80       	push   $0x8010b460
80103c14:	50                   	push   %eax
80103c15:	e8 06 36 00 00       	call   80107220 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c1a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c1d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c23:	6a 4c                	push   $0x4c
80103c25:	6a 00                	push   $0x0
80103c27:	ff 73 18             	push   0x18(%ebx)
80103c2a:	e8 21 0d 00 00       	call   80104950 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c32:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c37:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c3a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c3f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c43:	8b 43 18             	mov    0x18(%ebx),%eax
80103c46:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c4a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c4d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c51:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c55:	8b 43 18             	mov    0x18(%ebx),%eax
80103c58:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c5c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c60:	8b 43 18             	mov    0x18(%ebx),%eax
80103c63:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c6a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c6d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103c74:	8b 43 18             	mov    0x18(%ebx),%eax
80103c77:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c7e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c81:	6a 10                	push   $0x10
80103c83:	68 92 7a 10 80       	push   $0x80107a92
80103c88:	50                   	push   %eax
80103c89:	e8 82 0e 00 00       	call   80104b10 <safestrcpy>
  p->cwd = namei("/");
80103c8e:	c7 04 24 9b 7a 10 80 	movl   $0x80107a9b,(%esp)
80103c95:	e8 26 e4 ff ff       	call   801020c0 <namei>
80103c9a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c9d:	c7 04 24 00 44 11 80 	movl   $0x80114400,(%esp)
80103ca4:	e8 97 0b 00 00       	call   80104840 <acquire>
  p->state = RUNNABLE;
80103ca9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103cb0:	c7 04 24 00 44 11 80 	movl   $0x80114400,(%esp)
80103cb7:	e8 44 0c 00 00       	call   80104900 <release>
}
80103cbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	c9                   	leave
80103cc3:	c3                   	ret
    panic("userinit: out of memory?");
80103cc4:	83 ec 0c             	sub    $0xc,%esp
80103cc7:	68 79 7a 10 80       	push   $0x80107a79
80103ccc:	e8 bf c6 ff ff       	call   80100390 <panic>
80103cd1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cd8:	00 
80103cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ce0 <growproc>:
{
80103ce0:	f3 0f 1e fb          	endbr32
80103ce4:	55                   	push   %ebp
80103ce5:	89 e5                	mov    %esp,%ebp
80103ce7:	56                   	push   %esi
80103ce8:	53                   	push   %ebx
80103ce9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cec:	e8 4f 0a 00 00       	call   80104740 <pushcli>
  c = mycpu();
80103cf1:	e8 aa fc ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103cf6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cfc:	e8 8f 0a 00 00       	call   80104790 <popcli>
  sz = curproc->sz;
80103d01:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80103d03:	85 f6                	test   %esi,%esi
80103d05:	7f 19                	jg     80103d20 <growproc+0x40>
  else if (n < 0)
80103d07:	75 37                	jne    80103d40 <growproc+0x60>
  switchuvm(curproc);
80103d09:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d0c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d0e:	53                   	push   %ebx
80103d0f:	e8 fc 33 00 00       	call   80107110 <switchuvm>
  return 0;
80103d14:	83 c4 10             	add    $0x10,%esp
80103d17:	31 c0                	xor    %eax,%eax
}
80103d19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d1c:	5b                   	pop    %ebx
80103d1d:	5e                   	pop    %esi
80103d1e:	5d                   	pop    %ebp
80103d1f:	c3                   	ret
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d20:	83 ec 04             	sub    $0x4,%esp
80103d23:	01 c6                	add    %eax,%esi
80103d25:	56                   	push   %esi
80103d26:	50                   	push   %eax
80103d27:	ff 73 04             	push   0x4(%ebx)
80103d2a:	e8 41 36 00 00       	call   80107370 <allocuvm>
80103d2f:	83 c4 10             	add    $0x10,%esp
80103d32:	85 c0                	test   %eax,%eax
80103d34:	75 d3                	jne    80103d09 <growproc+0x29>
      return -1;
80103d36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d3b:	eb dc                	jmp    80103d19 <growproc+0x39>
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d40:	83 ec 04             	sub    $0x4,%esp
80103d43:	01 c6                	add    %eax,%esi
80103d45:	56                   	push   %esi
80103d46:	50                   	push   %eax
80103d47:	ff 73 04             	push   0x4(%ebx)
80103d4a:	e8 51 37 00 00       	call   801074a0 <deallocuvm>
80103d4f:	83 c4 10             	add    $0x10,%esp
80103d52:	85 c0                	test   %eax,%eax
80103d54:	75 b3                	jne    80103d09 <growproc+0x29>
80103d56:	eb de                	jmp    80103d36 <growproc+0x56>
80103d58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d5f:	00 

80103d60 <fork>:
{
80103d60:	f3 0f 1e fb          	endbr32
80103d64:	55                   	push   %ebp
80103d65:	89 e5                	mov    %esp,%ebp
80103d67:	57                   	push   %edi
80103d68:	56                   	push   %esi
80103d69:	53                   	push   %ebx
80103d6a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d6d:	e8 ce 09 00 00       	call   80104740 <pushcli>
  c = mycpu();
80103d72:	e8 29 fc ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103d77:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d7d:	e8 0e 0a 00 00       	call   80104790 <popcli>
  if ((np = allocproc()) == 0)
80103d82:	e8 99 fa ff ff       	call   80103820 <allocproc>
80103d87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d8a:	85 c0                	test   %eax,%eax
80103d8c:	0f 84 f3 00 00 00    	je     80103e85 <fork+0x125>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103d92:	83 ec 08             	sub    $0x8,%esp
80103d95:	ff 33                	push   (%ebx)
80103d97:	89 c7                	mov    %eax,%edi
80103d99:	ff 73 04             	push   0x4(%ebx)
80103d9c:	e8 7f 38 00 00       	call   80107620 <copyuvm>
80103da1:	83 c4 10             	add    $0x10,%esp
80103da4:	89 47 04             	mov    %eax,0x4(%edi)
80103da7:	85 c0                	test   %eax,%eax
80103da9:	0f 84 dd 00 00 00    	je     80103e8c <fork+0x12c>
  np->sz = curproc->sz;
80103daf:	8b 03                	mov    (%ebx),%eax
80103db1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  *np->tf = *curproc->tf;
80103db4:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103db9:	89 07                	mov    %eax,(%edi)
  np->parent = curproc;
80103dbb:	89 f8                	mov    %edi,%eax
80103dbd:	89 5f 14             	mov    %ebx,0x14(%edi)
  *np->tf = *curproc->tf;
80103dc0:	8b 7f 18             	mov    0x18(%edi),%edi
80103dc3:	8b 73 18             	mov    0x18(%ebx),%esi
80103dc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NUM_SYSCALLS; i++)
80103dc8:	89 c7                	mov    %eax,%edi
80103dca:	8d 80 80 00 00 00    	lea    0x80(%eax),%eax
80103dd0:	8d 97 ec 00 00 00    	lea    0xec(%edi),%edx
80103dd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ddd:	00 
80103dde:	66 90                	xchg   %ax,%ax
    np->syscall_bitmask[i] = 0;
80103de0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (i = 0; i < NUM_SYSCALLS; i++)
80103de6:	83 c0 04             	add    $0x4,%eax
80103de9:	39 c2                	cmp    %eax,%edx
80103deb:	75 f3                	jne    80103de0 <fork+0x80>
  np->real_sh=1;
80103ded:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for (i = 0; i < NOFILE; i++)
80103df0:	31 f6                	xor    %esi,%esi
  np->real_sh=1;
80103df2:	c7 80 ec 00 00 00 01 	movl   $0x1,0xec(%eax)
80103df9:	00 00 00 
  np->tf->eax = 0;
80103dfc:	8b 40 18             	mov    0x18(%eax),%eax
80103dff:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
80103e06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e0d:	00 
80103e0e:	66 90                	xchg   %ax,%ax
    if (curproc->ofile[i])
80103e10:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e14:	85 c0                	test   %eax,%eax
80103e16:	74 13                	je     80103e2b <fork+0xcb>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e18:	83 ec 0c             	sub    $0xc,%esp
80103e1b:	50                   	push   %eax
80103e1c:	e8 af d0 ff ff       	call   80100ed0 <filedup>
80103e21:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e24:	83 c4 10             	add    $0x10,%esp
80103e27:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80103e2b:	83 c6 01             	add    $0x1,%esi
80103e2e:	83 fe 10             	cmp    $0x10,%esi
80103e31:	75 dd                	jne    80103e10 <fork+0xb0>
  np->cwd = idup(curproc->cwd);
80103e33:	83 ec 0c             	sub    $0xc,%esp
80103e36:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e39:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e3c:	e8 6f d9 ff ff       	call   801017b0 <idup>
80103e41:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e44:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e47:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e4a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e4d:	6a 10                	push   $0x10
80103e4f:	53                   	push   %ebx
80103e50:	50                   	push   %eax
80103e51:	e8 ba 0c 00 00       	call   80104b10 <safestrcpy>
  pid = np->pid;
80103e56:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103e59:	c7 04 24 00 44 11 80 	movl   $0x80114400,(%esp)
80103e60:	e8 db 09 00 00       	call   80104840 <acquire>
  np->state = RUNNABLE;
80103e65:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103e6c:	c7 04 24 00 44 11 80 	movl   $0x80114400,(%esp)
80103e73:	e8 88 0a 00 00       	call   80104900 <release>
  return pid;
80103e78:	83 c4 10             	add    $0x10,%esp
}
80103e7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e7e:	89 d8                	mov    %ebx,%eax
80103e80:	5b                   	pop    %ebx
80103e81:	5e                   	pop    %esi
80103e82:	5f                   	pop    %edi
80103e83:	5d                   	pop    %ebp
80103e84:	c3                   	ret
    return -1;
80103e85:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e8a:	eb ef                	jmp    80103e7b <fork+0x11b>
    kfree(np->kstack);
80103e8c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e8f:	83 ec 0c             	sub    $0xc,%esp
80103e92:	ff 73 08             	push   0x8(%ebx)
80103e95:	e8 66 e6 ff ff       	call   80102500 <kfree>
    np->kstack = 0;
80103e9a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103ea1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103ea4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103eab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103eb0:	eb c9                	jmp    80103e7b <fork+0x11b>
80103eb2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103eb9:	00 
80103eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ec0 <scheduler>:
{
80103ec0:	f3 0f 1e fb          	endbr32
80103ec4:	55                   	push   %ebp
80103ec5:	89 e5                	mov    %esp,%ebp
80103ec7:	57                   	push   %edi
80103ec8:	56                   	push   %esi
80103ec9:	53                   	push   %ebx
80103eca:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ecd:	e8 ce fa ff ff       	call   801039a0 <mycpu>
  c->proc = 0;
80103ed2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ed9:	00 00 00 
  struct cpu *c = mycpu();
80103edc:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ede:	8d 78 04             	lea    0x4(%eax),%edi
80103ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103ee8:	fb                   	sti
    acquire(&ptable.lock);
80103ee9:	83 ec 0c             	sub    $0xc,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eec:	bb 34 44 11 80       	mov    $0x80114434,%ebx
    acquire(&ptable.lock);
80103ef1:	68 00 44 11 80       	push   $0x80114400
80103ef6:	e8 45 09 00 00       	call   80104840 <acquire>
80103efb:	83 c4 10             	add    $0x10,%esp
80103efe:	66 90                	xchg   %ax,%ax
      if (p->state != RUNNABLE)
80103f00:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f04:	75 33                	jne    80103f39 <scheduler+0x79>
      switchuvm(p);
80103f06:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f09:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f0f:	53                   	push   %ebx
80103f10:	e8 fb 31 00 00       	call   80107110 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f15:	58                   	pop    %eax
80103f16:	5a                   	pop    %edx
80103f17:	ff 73 1c             	push   0x1c(%ebx)
80103f1a:	57                   	push   %edi
      p->state = RUNNING;
80103f1b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f22:	e8 4c 0c 00 00       	call   80104b73 <swtch>
      switchkvm();
80103f27:	e8 c4 31 00 00       	call   801070f0 <switchkvm>
      c->proc = 0;
80103f2c:	83 c4 10             	add    $0x10,%esp
80103f2f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f36:	00 00 00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f39:	81 c3 f0 00 00 00    	add    $0xf0,%ebx
80103f3f:	81 fb 34 80 11 80    	cmp    $0x80118034,%ebx
80103f45:	75 b9                	jne    80103f00 <scheduler+0x40>
    release(&ptable.lock);
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	68 00 44 11 80       	push   $0x80114400
80103f4f:	e8 ac 09 00 00       	call   80104900 <release>
    sti();
80103f54:	83 c4 10             	add    $0x10,%esp
80103f57:	eb 8f                	jmp    80103ee8 <scheduler+0x28>
80103f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f60 <sched>:
{
80103f60:	f3 0f 1e fb          	endbr32
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	56                   	push   %esi
80103f68:	53                   	push   %ebx
  pushcli();
80103f69:	e8 d2 07 00 00       	call   80104740 <pushcli>
  c = mycpu();
80103f6e:	e8 2d fa ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103f73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f79:	e8 12 08 00 00       	call   80104790 <popcli>
  if (!holding(&ptable.lock))
80103f7e:	83 ec 0c             	sub    $0xc,%esp
80103f81:	68 00 44 11 80       	push   $0x80114400
80103f86:	e8 65 08 00 00       	call   801047f0 <holding>
80103f8b:	83 c4 10             	add    $0x10,%esp
80103f8e:	85 c0                	test   %eax,%eax
80103f90:	74 4f                	je     80103fe1 <sched+0x81>
  if (mycpu()->ncli != 1)
80103f92:	e8 09 fa ff ff       	call   801039a0 <mycpu>
80103f97:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f9e:	75 68                	jne    80104008 <sched+0xa8>
  if (p->state == RUNNING)
80103fa0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fa4:	74 55                	je     80103ffb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fa6:	9c                   	pushf
80103fa7:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103fa8:	f6 c4 02             	test   $0x2,%ah
80103fab:	75 41                	jne    80103fee <sched+0x8e>
  intena = mycpu()->intena;
80103fad:	e8 ee f9 ff ff       	call   801039a0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fb2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103fb5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103fbb:	e8 e0 f9 ff ff       	call   801039a0 <mycpu>
80103fc0:	83 ec 08             	sub    $0x8,%esp
80103fc3:	ff 70 04             	push   0x4(%eax)
80103fc6:	53                   	push   %ebx
80103fc7:	e8 a7 0b 00 00       	call   80104b73 <swtch>
  mycpu()->intena = intena;
80103fcc:	e8 cf f9 ff ff       	call   801039a0 <mycpu>
}
80103fd1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103fd4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fda:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fdd:	5b                   	pop    %ebx
80103fde:	5e                   	pop    %esi
80103fdf:	5d                   	pop    %ebp
80103fe0:	c3                   	ret
    panic("sched ptable.lock");
80103fe1:	83 ec 0c             	sub    $0xc,%esp
80103fe4:	68 9d 7a 10 80       	push   $0x80107a9d
80103fe9:	e8 a2 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103fee:	83 ec 0c             	sub    $0xc,%esp
80103ff1:	68 c9 7a 10 80       	push   $0x80107ac9
80103ff6:	e8 95 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80103ffb:	83 ec 0c             	sub    $0xc,%esp
80103ffe:	68 bb 7a 10 80       	push   $0x80107abb
80104003:	e8 88 c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104008:	83 ec 0c             	sub    $0xc,%esp
8010400b:	68 af 7a 10 80       	push   $0x80107aaf
80104010:	e8 7b c3 ff ff       	call   80100390 <panic>
80104015:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010401c:	00 
8010401d:	8d 76 00             	lea    0x0(%esi),%esi

80104020 <exit>:
{
80104020:	f3 0f 1e fb          	endbr32
80104024:	55                   	push   %ebp
80104025:	89 e5                	mov    %esp,%ebp
80104027:	57                   	push   %edi
80104028:	56                   	push   %esi
80104029:	53                   	push   %ebx
8010402a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010402d:	e8 0e 07 00 00       	call   80104740 <pushcli>
  c = mycpu();
80104032:	e8 69 f9 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104037:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010403d:	e8 4e 07 00 00       	call   80104790 <popcli>
  cprintf("proc=%s,mem=%d\n", curproc->name, curproc->sz);
80104042:	83 ec 04             	sub    $0x4,%esp
80104045:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104048:	ff 33                	push   (%ebx)
8010404a:	50                   	push   %eax
8010404b:	68 dd 7a 10 80       	push   $0x80107add
80104050:	e8 5b c6 ff ff       	call   801006b0 <cprintf>
  if (curproc->exec_failed == 0)
80104055:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104058:	83 c4 10             	add    $0x10,%esp
8010405b:	85 c0                	test   %eax,%eax
8010405d:	0f 84 0e 01 00 00    	je     80104171 <exit+0x151>
  if (curproc == initproc)
80104063:	8d 73 28             	lea    0x28(%ebx),%esi
80104066:	8d 7b 68             	lea    0x68(%ebx),%edi
80104069:	39 1d bc b5 10 80    	cmp    %ebx,0x8010b5bc
8010406f:	0f 84 0d 01 00 00    	je     80104182 <exit+0x162>
80104075:	8d 76 00             	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
80104078:	8b 06                	mov    (%esi),%eax
8010407a:	85 c0                	test   %eax,%eax
8010407c:	74 12                	je     80104090 <exit+0x70>
      fileclose(curproc->ofile[fd]);
8010407e:	83 ec 0c             	sub    $0xc,%esp
80104081:	50                   	push   %eax
80104082:	e8 99 ce ff ff       	call   80100f20 <fileclose>
      curproc->ofile[fd] = 0;
80104087:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010408d:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80104090:	83 c6 04             	add    $0x4,%esi
80104093:	39 f7                	cmp    %esi,%edi
80104095:	75 e1                	jne    80104078 <exit+0x58>
  begin_op();
80104097:	e8 24 ed ff ff       	call   80102dc0 <begin_op>
  iput(curproc->cwd);
8010409c:	83 ec 0c             	sub    $0xc,%esp
8010409f:	ff 73 68             	push   0x68(%ebx)
801040a2:	e8 69 d8 ff ff       	call   80101910 <iput>
  end_op();
801040a7:	e8 84 ed ff ff       	call   80102e30 <end_op>
  curproc->cwd = 0;
801040ac:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801040b3:	c7 04 24 00 44 11 80 	movl   $0x80114400,(%esp)
801040ba:	e8 81 07 00 00       	call   80104840 <acquire>
  wakeup1(curproc->parent);
801040bf:	8b 53 14             	mov    0x14(%ebx),%edx
801040c2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c5:	b8 34 44 11 80       	mov    $0x80114434,%eax
801040ca:	eb 10                	jmp    801040dc <exit+0xbc>
801040cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040d0:	05 f0 00 00 00       	add    $0xf0,%eax
801040d5:	3d 34 80 11 80       	cmp    $0x80118034,%eax
801040da:	74 1e                	je     801040fa <exit+0xda>
    if (p->state == SLEEPING && p->chan == chan)
801040dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040e0:	75 ee                	jne    801040d0 <exit+0xb0>
801040e2:	3b 50 20             	cmp    0x20(%eax),%edx
801040e5:	75 e9                	jne    801040d0 <exit+0xb0>
      p->state = RUNNABLE;
801040e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ee:	05 f0 00 00 00       	add    $0xf0,%eax
801040f3:	3d 34 80 11 80       	cmp    $0x80118034,%eax
801040f8:	75 e2                	jne    801040dc <exit+0xbc>
      p->parent = initproc;
801040fa:	8b 0d bc b5 10 80    	mov    0x8010b5bc,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104100:	ba 34 44 11 80       	mov    $0x80114434,%edx
80104105:	eb 17                	jmp    8010411e <exit+0xfe>
80104107:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010410e:	00 
8010410f:	90                   	nop
80104110:	81 c2 f0 00 00 00    	add    $0xf0,%edx
80104116:	81 fa 34 80 11 80    	cmp    $0x80118034,%edx
8010411c:	74 3a                	je     80104158 <exit+0x138>
    if (p->parent == curproc)
8010411e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104121:	75 ed                	jne    80104110 <exit+0xf0>
      if (p->state == ZOMBIE)
80104123:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104127:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
8010412a:	75 e4                	jne    80104110 <exit+0xf0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010412c:	b8 34 44 11 80       	mov    $0x80114434,%eax
80104131:	eb 11                	jmp    80104144 <exit+0x124>
80104133:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104138:	05 f0 00 00 00       	add    $0xf0,%eax
8010413d:	3d 34 80 11 80       	cmp    $0x80118034,%eax
80104142:	74 cc                	je     80104110 <exit+0xf0>
    if (p->state == SLEEPING && p->chan == chan)
80104144:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104148:	75 ee                	jne    80104138 <exit+0x118>
8010414a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010414d:	75 e9                	jne    80104138 <exit+0x118>
      p->state = RUNNABLE;
8010414f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104156:	eb e0                	jmp    80104138 <exit+0x118>
  curproc->state = ZOMBIE;
80104158:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010415f:	e8 fc fd ff ff       	call   80103f60 <sched>
  panic("zombie exit");
80104164:	83 ec 0c             	sub    $0xc,%esp
80104167:	68 fa 7a 10 80       	push   $0x80107afa
8010416c:	e8 1f c2 ff ff       	call   80100390 <panic>
    add_to_history(curproc);
80104171:	83 ec 0c             	sub    $0xc,%esp
80104174:	53                   	push   %ebx
80104175:	e8 e6 f8 ff ff       	call   80103a60 <add_to_history>
8010417a:	83 c4 10             	add    $0x10,%esp
8010417d:	e9 e1 fe ff ff       	jmp    80104063 <exit+0x43>
    panic("init exiting");
80104182:	83 ec 0c             	sub    $0xc,%esp
80104185:	68 ed 7a 10 80       	push   $0x80107aed
8010418a:	e8 01 c2 ff ff       	call   80100390 <panic>
8010418f:	90                   	nop

80104190 <yield>:
{
80104190:	f3 0f 1e fb          	endbr32
80104194:	55                   	push   %ebp
80104195:	89 e5                	mov    %esp,%ebp
80104197:	53                   	push   %ebx
80104198:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
8010419b:	68 00 44 11 80       	push   $0x80114400
801041a0:	e8 9b 06 00 00       	call   80104840 <acquire>
  pushcli();
801041a5:	e8 96 05 00 00       	call   80104740 <pushcli>
  c = mycpu();
801041aa:	e8 f1 f7 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
801041af:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041b5:	e8 d6 05 00 00       	call   80104790 <popcli>
  myproc()->state = RUNNABLE;
801041ba:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041c1:	e8 9a fd ff ff       	call   80103f60 <sched>
  release(&ptable.lock);
801041c6:	c7 04 24 00 44 11 80 	movl   $0x80114400,(%esp)
801041cd:	e8 2e 07 00 00       	call   80104900 <release>
}
801041d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d5:	83 c4 10             	add    $0x10,%esp
801041d8:	c9                   	leave
801041d9:	c3                   	ret
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041e0 <sleep>:
{
801041e0:	f3 0f 1e fb          	endbr32
801041e4:	55                   	push   %ebp
801041e5:	89 e5                	mov    %esp,%ebp
801041e7:	57                   	push   %edi
801041e8:	56                   	push   %esi
801041e9:	53                   	push   %ebx
801041ea:	83 ec 0c             	sub    $0xc,%esp
801041ed:	8b 7d 08             	mov    0x8(%ebp),%edi
801041f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041f3:	e8 48 05 00 00       	call   80104740 <pushcli>
  c = mycpu();
801041f8:	e8 a3 f7 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
801041fd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104203:	e8 88 05 00 00       	call   80104790 <popcli>
  if (p == 0)
80104208:	85 db                	test   %ebx,%ebx
8010420a:	0f 84 83 00 00 00    	je     80104293 <sleep+0xb3>
  if (lk == 0)
80104210:	85 f6                	test   %esi,%esi
80104212:	74 72                	je     80104286 <sleep+0xa6>
  if (lk != &ptable.lock)
80104214:	81 fe 00 44 11 80    	cmp    $0x80114400,%esi
8010421a:	74 4c                	je     80104268 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
8010421c:	83 ec 0c             	sub    $0xc,%esp
8010421f:	68 00 44 11 80       	push   $0x80114400
80104224:	e8 17 06 00 00       	call   80104840 <acquire>
    release(lk);
80104229:	89 34 24             	mov    %esi,(%esp)
8010422c:	e8 cf 06 00 00       	call   80104900 <release>
  p->chan = chan;
80104231:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104234:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010423b:	e8 20 fd ff ff       	call   80103f60 <sched>
  p->chan = 0;
80104240:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104247:	c7 04 24 00 44 11 80 	movl   $0x80114400,(%esp)
8010424e:	e8 ad 06 00 00       	call   80104900 <release>
    acquire(lk);
80104253:	89 75 08             	mov    %esi,0x8(%ebp)
80104256:	83 c4 10             	add    $0x10,%esp
}
80104259:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010425c:	5b                   	pop    %ebx
8010425d:	5e                   	pop    %esi
8010425e:	5f                   	pop    %edi
8010425f:	5d                   	pop    %ebp
    acquire(lk);
80104260:	e9 db 05 00 00       	jmp    80104840 <acquire>
80104265:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104268:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010426b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104272:	e8 e9 fc ff ff       	call   80103f60 <sched>
  p->chan = 0;
80104277:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010427e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104281:	5b                   	pop    %ebx
80104282:	5e                   	pop    %esi
80104283:	5f                   	pop    %edi
80104284:	5d                   	pop    %ebp
80104285:	c3                   	ret
    panic("sleep without lk");
80104286:	83 ec 0c             	sub    $0xc,%esp
80104289:	68 0c 7b 10 80       	push   $0x80107b0c
8010428e:	e8 fd c0 ff ff       	call   80100390 <panic>
    panic("sleep");
80104293:	83 ec 0c             	sub    $0xc,%esp
80104296:	68 06 7b 10 80       	push   $0x80107b06
8010429b:	e8 f0 c0 ff ff       	call   80100390 <panic>

801042a0 <wait>:
{
801042a0:	f3 0f 1e fb          	endbr32
801042a4:	55                   	push   %ebp
801042a5:	89 e5                	mov    %esp,%ebp
801042a7:	56                   	push   %esi
801042a8:	53                   	push   %ebx
  pushcli();
801042a9:	e8 92 04 00 00       	call   80104740 <pushcli>
  c = mycpu();
801042ae:	e8 ed f6 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
801042b3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042b9:	e8 d2 04 00 00       	call   80104790 <popcli>
  acquire(&ptable.lock);
801042be:	83 ec 0c             	sub    $0xc,%esp
801042c1:	68 00 44 11 80       	push   $0x80114400
801042c6:	e8 75 05 00 00       	call   80104840 <acquire>
801042cb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801042ce:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042d0:	bb 34 44 11 80       	mov    $0x80114434,%ebx
801042d5:	eb 17                	jmp    801042ee <wait+0x4e>
801042d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801042de:	00 
801042df:	90                   	nop
801042e0:	81 c3 f0 00 00 00    	add    $0xf0,%ebx
801042e6:	81 fb 34 80 11 80    	cmp    $0x80118034,%ebx
801042ec:	74 1e                	je     8010430c <wait+0x6c>
      if (p->parent != curproc)
801042ee:	39 73 14             	cmp    %esi,0x14(%ebx)
801042f1:	75 ed                	jne    801042e0 <wait+0x40>
      if (p->state == ZOMBIE)
801042f3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042f7:	74 37                	je     80104330 <wait+0x90>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042f9:	81 c3 f0 00 00 00    	add    $0xf0,%ebx
      havekids = 1;
801042ff:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104304:	81 fb 34 80 11 80    	cmp    $0x80118034,%ebx
8010430a:	75 e2                	jne    801042ee <wait+0x4e>
    if (!havekids || curproc->killed)
8010430c:	85 c0                	test   %eax,%eax
8010430e:	74 76                	je     80104386 <wait+0xe6>
80104310:	8b 46 24             	mov    0x24(%esi),%eax
80104313:	85 c0                	test   %eax,%eax
80104315:	75 6f                	jne    80104386 <wait+0xe6>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
80104317:	83 ec 08             	sub    $0x8,%esp
8010431a:	68 00 44 11 80       	push   $0x80114400
8010431f:	56                   	push   %esi
80104320:	e8 bb fe ff ff       	call   801041e0 <sleep>
    havekids = 0;
80104325:	83 c4 10             	add    $0x10,%esp
80104328:	eb a4                	jmp    801042ce <wait+0x2e>
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104330:	83 ec 0c             	sub    $0xc,%esp
80104333:	ff 73 08             	push   0x8(%ebx)
        pid = p->pid;
80104336:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104339:	e8 c2 e1 ff ff       	call   80102500 <kfree>
        freevm(p->pgdir);
8010433e:	5a                   	pop    %edx
8010433f:	ff 73 04             	push   0x4(%ebx)
        p->kstack = 0;
80104342:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104349:	e8 82 31 00 00       	call   801074d0 <freevm>
        release(&ptable.lock);
8010434e:	c7 04 24 00 44 11 80 	movl   $0x80114400,(%esp)
        p->pid = 0;
80104355:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010435c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104363:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104367:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010436e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104375:	e8 86 05 00 00       	call   80104900 <release>
        return pid;
8010437a:	83 c4 10             	add    $0x10,%esp
}
8010437d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104380:	89 f0                	mov    %esi,%eax
80104382:	5b                   	pop    %ebx
80104383:	5e                   	pop    %esi
80104384:	5d                   	pop    %ebp
80104385:	c3                   	ret
      release(&ptable.lock);
80104386:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104389:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010438e:	68 00 44 11 80       	push   $0x80114400
80104393:	e8 68 05 00 00       	call   80104900 <release>
      return -1;
80104398:	83 c4 10             	add    $0x10,%esp
8010439b:	eb e0                	jmp    8010437d <wait+0xdd>
8010439d:	8d 76 00             	lea    0x0(%esi),%esi

801043a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
801043a0:	f3 0f 1e fb          	endbr32
801043a4:	55                   	push   %ebp
801043a5:	89 e5                	mov    %esp,%ebp
801043a7:	53                   	push   %ebx
801043a8:	83 ec 10             	sub    $0x10,%esp
801043ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043ae:	68 00 44 11 80       	push   $0x80114400
801043b3:	e8 88 04 00 00       	call   80104840 <acquire>
801043b8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043bb:	b8 34 44 11 80       	mov    $0x80114434,%eax
801043c0:	eb 12                	jmp    801043d4 <wakeup+0x34>
801043c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043c8:	05 f0 00 00 00       	add    $0xf0,%eax
801043cd:	3d 34 80 11 80       	cmp    $0x80118034,%eax
801043d2:	74 1e                	je     801043f2 <wakeup+0x52>
    if (p->state == SLEEPING && p->chan == chan)
801043d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043d8:	75 ee                	jne    801043c8 <wakeup+0x28>
801043da:	3b 58 20             	cmp    0x20(%eax),%ebx
801043dd:	75 e9                	jne    801043c8 <wakeup+0x28>
      p->state = RUNNABLE;
801043df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043e6:	05 f0 00 00 00       	add    $0xf0,%eax
801043eb:	3d 34 80 11 80       	cmp    $0x80118034,%eax
801043f0:	75 e2                	jne    801043d4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
801043f2:	c7 45 08 00 44 11 80 	movl   $0x80114400,0x8(%ebp)
}
801043f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043fc:	c9                   	leave
  release(&ptable.lock);
801043fd:	e9 fe 04 00 00       	jmp    80104900 <release>
80104402:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104409:	00 
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).

int kill(int pid)
{
80104410:	f3 0f 1e fb          	endbr32
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	53                   	push   %ebx
80104418:	83 ec 10             	sub    $0x10,%esp
8010441b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010441e:	68 00 44 11 80       	push   $0x80114400
80104423:	e8 18 04 00 00       	call   80104840 <acquire>
80104428:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010442b:	b8 34 44 11 80       	mov    $0x80114434,%eax
80104430:	eb 12                	jmp    80104444 <kill+0x34>
80104432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104438:	05 f0 00 00 00       	add    $0xf0,%eax
8010443d:	3d 34 80 11 80       	cmp    $0x80118034,%eax
80104442:	74 34                	je     80104478 <kill+0x68>
  {
    if (p->pid == pid)
80104444:	39 58 10             	cmp    %ebx,0x10(%eax)
80104447:	75 ef                	jne    80104438 <kill+0x28>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104449:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010444d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
80104454:	75 07                	jne    8010445d <kill+0x4d>
        p->state = RUNNABLE;
80104456:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010445d:	83 ec 0c             	sub    $0xc,%esp
80104460:	68 00 44 11 80       	push   $0x80114400
80104465:	e8 96 04 00 00       	call   80104900 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010446a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010446d:	83 c4 10             	add    $0x10,%esp
80104470:	31 c0                	xor    %eax,%eax
}
80104472:	c9                   	leave
80104473:	c3                   	ret
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104478:	83 ec 0c             	sub    $0xc,%esp
8010447b:	68 00 44 11 80       	push   $0x80114400
80104480:	e8 7b 04 00 00       	call   80104900 <release>
}
80104485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104488:	83 c4 10             	add    $0x10,%esp
8010448b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104490:	c9                   	leave
80104491:	c3                   	ret
80104492:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104499:	00 
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044a0 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
801044a0:	f3 0f 1e fb          	endbr32
801044a4:	55                   	push   %ebp
801044a5:	89 e5                	mov    %esp,%ebp
801044a7:	57                   	push   %edi
801044a8:	56                   	push   %esi
801044a9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801044ac:	53                   	push   %ebx
801044ad:	bb a0 44 11 80       	mov    $0x801144a0,%ebx
801044b2:	83 ec 3c             	sub    $0x3c,%esp
801044b5:	eb 2b                	jmp    801044e2 <procdump+0x42>
801044b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044be:	00 
801044bf:	90                   	nop
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801044c0:	83 ec 0c             	sub    $0xc,%esp
801044c3:	68 d9 7b 10 80       	push   $0x80107bd9
801044c8:	e8 e3 c1 ff ff       	call   801006b0 <cprintf>
801044cd:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044d0:	81 c3 f0 00 00 00    	add    $0xf0,%ebx
801044d6:	81 fb a0 80 11 80    	cmp    $0x801180a0,%ebx
801044dc:	0f 84 8e 00 00 00    	je     80104570 <procdump+0xd0>
    if (p->state == UNUSED)
801044e2:	8b 43 a0             	mov    -0x60(%ebx),%eax
801044e5:	85 c0                	test   %eax,%eax
801044e7:	74 e7                	je     801044d0 <procdump+0x30>
      state = "???";
801044e9:	ba 1d 7b 10 80       	mov    $0x80107b1d,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044ee:	83 f8 05             	cmp    $0x5,%eax
801044f1:	77 11                	ja     80104504 <procdump+0x64>
801044f3:	8b 14 85 80 81 10 80 	mov    -0x7fef7e80(,%eax,4),%edx
      state = "???";
801044fa:	b8 1d 7b 10 80       	mov    $0x80107b1d,%eax
801044ff:	85 d2                	test   %edx,%edx
80104501:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104504:	53                   	push   %ebx
80104505:	52                   	push   %edx
80104506:	ff 73 a4             	push   -0x5c(%ebx)
80104509:	68 21 7b 10 80       	push   $0x80107b21
8010450e:	e8 9d c1 ff ff       	call   801006b0 <cprintf>
    if (p->state == SLEEPING)
80104513:	83 c4 10             	add    $0x10,%esp
80104516:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010451a:	75 a4                	jne    801044c0 <procdump+0x20>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
8010451c:	83 ec 08             	sub    $0x8,%esp
8010451f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104522:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104525:	50                   	push   %eax
80104526:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104529:	8b 40 0c             	mov    0xc(%eax),%eax
8010452c:	83 c0 08             	add    $0x8,%eax
8010452f:	50                   	push   %eax
80104530:	e8 ab 01 00 00       	call   801046e0 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104535:	83 c4 10             	add    $0x10,%esp
80104538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010453f:	00 
80104540:	8b 17                	mov    (%edi),%edx
80104542:	85 d2                	test   %edx,%edx
80104544:	0f 84 76 ff ff ff    	je     801044c0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010454a:	83 ec 08             	sub    $0x8,%esp
8010454d:	83 c7 04             	add    $0x4,%edi
80104550:	52                   	push   %edx
80104551:	68 21 78 10 80       	push   $0x80107821
80104556:	e8 55 c1 ff ff       	call   801006b0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
8010455b:	83 c4 10             	add    $0x10,%esp
8010455e:	39 fe                	cmp    %edi,%esi
80104560:	75 de                	jne    80104540 <procdump+0xa0>
80104562:	e9 59 ff ff ff       	jmp    801044c0 <procdump+0x20>
80104567:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010456e:	00 
8010456f:	90                   	nop
  }
}
80104570:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104573:	5b                   	pop    %ebx
80104574:	5e                   	pop    %esi
80104575:	5f                   	pop    %edi
80104576:	5d                   	pop    %ebp
80104577:	c3                   	ret
80104578:	66 90                	xchg   %ax,%ax
8010457a:	66 90                	xchg   %ax,%ax
8010457c:	66 90                	xchg   %ax,%ax
8010457e:	66 90                	xchg   %ax,%ax

80104580 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104580:	f3 0f 1e fb          	endbr32
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	53                   	push   %ebx
80104588:	83 ec 0c             	sub    $0xc,%esp
8010458b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010458e:	68 54 7b 10 80       	push   $0x80107b54
80104593:	8d 43 04             	lea    0x4(%ebx),%eax
80104596:	50                   	push   %eax
80104597:	e8 24 01 00 00       	call   801046c0 <initlock>
  lk->name = name;
8010459c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010459f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045a5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045a8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045af:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045b5:	c9                   	leave
801045b6:	c3                   	ret
801045b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045be:	00 
801045bf:	90                   	nop

801045c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045c0:	f3 0f 1e fb          	endbr32
801045c4:	55                   	push   %ebp
801045c5:	89 e5                	mov    %esp,%ebp
801045c7:	56                   	push   %esi
801045c8:	53                   	push   %ebx
801045c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045cc:	8d 73 04             	lea    0x4(%ebx),%esi
801045cf:	83 ec 0c             	sub    $0xc,%esp
801045d2:	56                   	push   %esi
801045d3:	e8 68 02 00 00       	call   80104840 <acquire>
  while (lk->locked) {
801045d8:	8b 13                	mov    (%ebx),%edx
801045da:	83 c4 10             	add    $0x10,%esp
801045dd:	85 d2                	test   %edx,%edx
801045df:	74 1a                	je     801045fb <acquiresleep+0x3b>
801045e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801045e8:	83 ec 08             	sub    $0x8,%esp
801045eb:	56                   	push   %esi
801045ec:	53                   	push   %ebx
801045ed:	e8 ee fb ff ff       	call   801041e0 <sleep>
  while (lk->locked) {
801045f2:	8b 03                	mov    (%ebx),%eax
801045f4:	83 c4 10             	add    $0x10,%esp
801045f7:	85 c0                	test   %eax,%eax
801045f9:	75 ed                	jne    801045e8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801045fb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104601:	e8 2a f4 ff ff       	call   80103a30 <myproc>
80104606:	8b 40 10             	mov    0x10(%eax),%eax
80104609:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010460c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010460f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104612:	5b                   	pop    %ebx
80104613:	5e                   	pop    %esi
80104614:	5d                   	pop    %ebp
  release(&lk->lk);
80104615:	e9 e6 02 00 00       	jmp    80104900 <release>
8010461a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104620 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104620:	f3 0f 1e fb          	endbr32
80104624:	55                   	push   %ebp
80104625:	89 e5                	mov    %esp,%ebp
80104627:	56                   	push   %esi
80104628:	53                   	push   %ebx
80104629:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010462c:	8d 73 04             	lea    0x4(%ebx),%esi
8010462f:	83 ec 0c             	sub    $0xc,%esp
80104632:	56                   	push   %esi
80104633:	e8 08 02 00 00       	call   80104840 <acquire>
  lk->locked = 0;
80104638:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010463e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104645:	89 1c 24             	mov    %ebx,(%esp)
80104648:	e8 53 fd ff ff       	call   801043a0 <wakeup>
  release(&lk->lk);
8010464d:	89 75 08             	mov    %esi,0x8(%ebp)
80104650:	83 c4 10             	add    $0x10,%esp
}
80104653:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104656:	5b                   	pop    %ebx
80104657:	5e                   	pop    %esi
80104658:	5d                   	pop    %ebp
  release(&lk->lk);
80104659:	e9 a2 02 00 00       	jmp    80104900 <release>
8010465e:	66 90                	xchg   %ax,%ax

80104660 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104660:	f3 0f 1e fb          	endbr32
80104664:	55                   	push   %ebp
80104665:	89 e5                	mov    %esp,%ebp
80104667:	57                   	push   %edi
80104668:	31 ff                	xor    %edi,%edi
8010466a:	56                   	push   %esi
8010466b:	53                   	push   %ebx
8010466c:	83 ec 18             	sub    $0x18,%esp
8010466f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104672:	8d 73 04             	lea    0x4(%ebx),%esi
80104675:	56                   	push   %esi
80104676:	e8 c5 01 00 00       	call   80104840 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010467b:	8b 03                	mov    (%ebx),%eax
8010467d:	83 c4 10             	add    $0x10,%esp
80104680:	85 c0                	test   %eax,%eax
80104682:	75 1c                	jne    801046a0 <holdingsleep+0x40>
  release(&lk->lk);
80104684:	83 ec 0c             	sub    $0xc,%esp
80104687:	56                   	push   %esi
80104688:	e8 73 02 00 00       	call   80104900 <release>
  return r;
}
8010468d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104690:	89 f8                	mov    %edi,%eax
80104692:	5b                   	pop    %ebx
80104693:	5e                   	pop    %esi
80104694:	5f                   	pop    %edi
80104695:	5d                   	pop    %ebp
80104696:	c3                   	ret
80104697:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010469e:	00 
8010469f:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801046a0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801046a3:	e8 88 f3 ff ff       	call   80103a30 <myproc>
801046a8:	39 58 10             	cmp    %ebx,0x10(%eax)
801046ab:	0f 94 c0             	sete   %al
801046ae:	0f b6 c0             	movzbl %al,%eax
801046b1:	89 c7                	mov    %eax,%edi
801046b3:	eb cf                	jmp    80104684 <holdingsleep+0x24>
801046b5:	66 90                	xchg   %ax,%ax
801046b7:	66 90                	xchg   %ax,%ax
801046b9:	66 90                	xchg   %ax,%ax
801046bb:	66 90                	xchg   %ax,%ax
801046bd:	66 90                	xchg   %ax,%ax
801046bf:	90                   	nop

801046c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046c0:	f3 0f 1e fb          	endbr32
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046d3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046dd:	5d                   	pop    %ebp
801046de:	c3                   	ret
801046df:	90                   	nop

801046e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046e0:	f3 0f 1e fb          	endbr32
801046e4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046e5:	31 d2                	xor    %edx,%edx
{
801046e7:	89 e5                	mov    %esp,%ebp
801046e9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046ea:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046f0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801046f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046f8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046fe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104704:	77 1a                	ja     80104720 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104706:	8b 58 04             	mov    0x4(%eax),%ebx
80104709:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010470c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010470f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104711:	83 fa 0a             	cmp    $0xa,%edx
80104714:	75 e2                	jne    801046f8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104716:	5b                   	pop    %ebx
80104717:	5d                   	pop    %ebp
80104718:	c3                   	ret
80104719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104720:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104723:	8d 51 28             	lea    0x28(%ecx),%edx
80104726:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010472d:	00 
8010472e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104736:	83 c0 04             	add    $0x4,%eax
80104739:	39 d0                	cmp    %edx,%eax
8010473b:	75 f3                	jne    80104730 <getcallerpcs+0x50>
}
8010473d:	5b                   	pop    %ebx
8010473e:	5d                   	pop    %ebp
8010473f:	c3                   	ret

80104740 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104740:	f3 0f 1e fb          	endbr32
80104744:	55                   	push   %ebp
80104745:	89 e5                	mov    %esp,%ebp
80104747:	53                   	push   %ebx
80104748:	83 ec 04             	sub    $0x4,%esp
8010474b:	9c                   	pushf
8010474c:	5b                   	pop    %ebx
  asm volatile("cli");
8010474d:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010474e:	e8 4d f2 ff ff       	call   801039a0 <mycpu>
80104753:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104759:	85 c0                	test   %eax,%eax
8010475b:	74 13                	je     80104770 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010475d:	e8 3e f2 ff ff       	call   801039a0 <mycpu>
80104762:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104769:	83 c4 04             	add    $0x4,%esp
8010476c:	5b                   	pop    %ebx
8010476d:	5d                   	pop    %ebp
8010476e:	c3                   	ret
8010476f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104770:	e8 2b f2 ff ff       	call   801039a0 <mycpu>
80104775:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010477b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104781:	eb da                	jmp    8010475d <pushcli+0x1d>
80104783:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010478a:	00 
8010478b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104790 <popcli>:

void
popcli(void)
{
80104790:	f3 0f 1e fb          	endbr32
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010479a:	9c                   	pushf
8010479b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010479c:	f6 c4 02             	test   $0x2,%ah
8010479f:	75 31                	jne    801047d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801047a1:	e8 fa f1 ff ff       	call   801039a0 <mycpu>
801047a6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801047ad:	78 30                	js     801047df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047af:	e8 ec f1 ff ff       	call   801039a0 <mycpu>
801047b4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801047ba:	85 d2                	test   %edx,%edx
801047bc:	74 02                	je     801047c0 <popcli+0x30>
    sti();
}
801047be:	c9                   	leave
801047bf:	c3                   	ret
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047c0:	e8 db f1 ff ff       	call   801039a0 <mycpu>
801047c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801047cb:	85 c0                	test   %eax,%eax
801047cd:	74 ef                	je     801047be <popcli+0x2e>
  asm volatile("sti");
801047cf:	fb                   	sti
}
801047d0:	c9                   	leave
801047d1:	c3                   	ret
    panic("popcli - interruptible");
801047d2:	83 ec 0c             	sub    $0xc,%esp
801047d5:	68 5f 7b 10 80       	push   $0x80107b5f
801047da:	e8 b1 bb ff ff       	call   80100390 <panic>
    panic("popcli");
801047df:	83 ec 0c             	sub    $0xc,%esp
801047e2:	68 76 7b 10 80       	push   $0x80107b76
801047e7:	e8 a4 bb ff ff       	call   80100390 <panic>
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047f0 <holding>:
{
801047f0:	f3 0f 1e fb          	endbr32
801047f4:	55                   	push   %ebp
801047f5:	89 e5                	mov    %esp,%ebp
801047f7:	56                   	push   %esi
801047f8:	53                   	push   %ebx
801047f9:	8b 75 08             	mov    0x8(%ebp),%esi
801047fc:	31 db                	xor    %ebx,%ebx
  pushcli();
801047fe:	e8 3d ff ff ff       	call   80104740 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104803:	8b 06                	mov    (%esi),%eax
80104805:	85 c0                	test   %eax,%eax
80104807:	75 0f                	jne    80104818 <holding+0x28>
  popcli();
80104809:	e8 82 ff ff ff       	call   80104790 <popcli>
}
8010480e:	89 d8                	mov    %ebx,%eax
80104810:	5b                   	pop    %ebx
80104811:	5e                   	pop    %esi
80104812:	5d                   	pop    %ebp
80104813:	c3                   	ret
80104814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104818:	8b 5e 08             	mov    0x8(%esi),%ebx
8010481b:	e8 80 f1 ff ff       	call   801039a0 <mycpu>
80104820:	39 c3                	cmp    %eax,%ebx
80104822:	0f 94 c3             	sete   %bl
  popcli();
80104825:	e8 66 ff ff ff       	call   80104790 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010482a:	0f b6 db             	movzbl %bl,%ebx
}
8010482d:	89 d8                	mov    %ebx,%eax
8010482f:	5b                   	pop    %ebx
80104830:	5e                   	pop    %esi
80104831:	5d                   	pop    %ebp
80104832:	c3                   	ret
80104833:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010483a:	00 
8010483b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104840 <acquire>:
{
80104840:	f3 0f 1e fb          	endbr32
80104844:	55                   	push   %ebp
80104845:	89 e5                	mov    %esp,%ebp
80104847:	56                   	push   %esi
80104848:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104849:	e8 f2 fe ff ff       	call   80104740 <pushcli>
  if(holding(lk))
8010484e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104851:	83 ec 0c             	sub    $0xc,%esp
80104854:	53                   	push   %ebx
80104855:	e8 96 ff ff ff       	call   801047f0 <holding>
8010485a:	83 c4 10             	add    $0x10,%esp
8010485d:	85 c0                	test   %eax,%eax
8010485f:	0f 85 7f 00 00 00    	jne    801048e4 <acquire+0xa4>
80104865:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104867:	ba 01 00 00 00       	mov    $0x1,%edx
8010486c:	eb 05                	jmp    80104873 <acquire+0x33>
8010486e:	66 90                	xchg   %ax,%ax
80104870:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104873:	89 d0                	mov    %edx,%eax
80104875:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104878:	85 c0                	test   %eax,%eax
8010487a:	75 f4                	jne    80104870 <acquire+0x30>
  __sync_synchronize();
8010487c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104881:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104884:	e8 17 f1 ff ff       	call   801039a0 <mycpu>
80104889:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010488c:	89 e8                	mov    %ebp,%eax
8010488e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104890:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104896:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010489c:	77 22                	ja     801048c0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010489e:	8b 50 04             	mov    0x4(%eax),%edx
801048a1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801048a5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801048a8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801048aa:	83 fe 0a             	cmp    $0xa,%esi
801048ad:	75 e1                	jne    80104890 <acquire+0x50>
}
801048af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048b2:	5b                   	pop    %ebx
801048b3:	5e                   	pop    %esi
801048b4:	5d                   	pop    %ebp
801048b5:	c3                   	ret
801048b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048bd:	00 
801048be:	66 90                	xchg   %ax,%ax
  for(; i < 10; i++)
801048c0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801048c4:	83 c3 34             	add    $0x34,%ebx
801048c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048ce:	00 
801048cf:	90                   	nop
    pcs[i] = 0;
801048d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801048d6:	83 c0 04             	add    $0x4,%eax
801048d9:	39 d8                	cmp    %ebx,%eax
801048db:	75 f3                	jne    801048d0 <acquire+0x90>
}
801048dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048e0:	5b                   	pop    %ebx
801048e1:	5e                   	pop    %esi
801048e2:	5d                   	pop    %ebp
801048e3:	c3                   	ret
    panic("acquire");
801048e4:	83 ec 0c             	sub    $0xc,%esp
801048e7:	68 7d 7b 10 80       	push   $0x80107b7d
801048ec:	e8 9f ba ff ff       	call   80100390 <panic>
801048f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048f8:	00 
801048f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104900 <release>:
{
80104900:	f3 0f 1e fb          	endbr32
80104904:	55                   	push   %ebp
80104905:	89 e5                	mov    %esp,%ebp
80104907:	53                   	push   %ebx
80104908:	83 ec 10             	sub    $0x10,%esp
8010490b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010490e:	53                   	push   %ebx
8010490f:	e8 dc fe ff ff       	call   801047f0 <holding>
80104914:	83 c4 10             	add    $0x10,%esp
80104917:	85 c0                	test   %eax,%eax
80104919:	74 22                	je     8010493d <release+0x3d>
  lk->pcs[0] = 0;
8010491b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104922:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104929:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010492e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104937:	c9                   	leave
  popcli();
80104938:	e9 53 fe ff ff       	jmp    80104790 <popcli>
    panic("release");
8010493d:	83 ec 0c             	sub    $0xc,%esp
80104940:	68 85 7b 10 80       	push   $0x80107b85
80104945:	e8 46 ba ff ff       	call   80100390 <panic>
8010494a:	66 90                	xchg   %ax,%ax
8010494c:	66 90                	xchg   %ax,%ax
8010494e:	66 90                	xchg   %ax,%ax

80104950 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104950:	f3 0f 1e fb          	endbr32
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	57                   	push   %edi
80104958:	8b 55 08             	mov    0x8(%ebp),%edx
8010495b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010495e:	53                   	push   %ebx
8010495f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104962:	89 d7                	mov    %edx,%edi
80104964:	09 cf                	or     %ecx,%edi
80104966:	83 e7 03             	and    $0x3,%edi
80104969:	75 25                	jne    80104990 <memset+0x40>
    c &= 0xFF;
8010496b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010496e:	c1 e0 18             	shl    $0x18,%eax
80104971:	89 fb                	mov    %edi,%ebx
80104973:	c1 e9 02             	shr    $0x2,%ecx
80104976:	c1 e3 10             	shl    $0x10,%ebx
80104979:	09 d8                	or     %ebx,%eax
8010497b:	09 f8                	or     %edi,%eax
8010497d:	c1 e7 08             	shl    $0x8,%edi
80104980:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104982:	89 d7                	mov    %edx,%edi
80104984:	fc                   	cld
80104985:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104987:	5b                   	pop    %ebx
80104988:	89 d0                	mov    %edx,%eax
8010498a:	5f                   	pop    %edi
8010498b:	5d                   	pop    %ebp
8010498c:	c3                   	ret
8010498d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104990:	89 d7                	mov    %edx,%edi
80104992:	fc                   	cld
80104993:	f3 aa                	rep stos %al,%es:(%edi)
80104995:	5b                   	pop    %ebx
80104996:	89 d0                	mov    %edx,%eax
80104998:	5f                   	pop    %edi
80104999:	5d                   	pop    %ebp
8010499a:	c3                   	ret
8010499b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801049a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049a0:	f3 0f 1e fb          	endbr32
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	56                   	push   %esi
801049a8:	8b 75 10             	mov    0x10(%ebp),%esi
801049ab:	8b 55 08             	mov    0x8(%ebp),%edx
801049ae:	53                   	push   %ebx
801049af:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049b2:	85 f6                	test   %esi,%esi
801049b4:	74 2a                	je     801049e0 <memcmp+0x40>
801049b6:	01 c6                	add    %eax,%esi
801049b8:	eb 10                	jmp    801049ca <memcmp+0x2a>
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801049c0:	83 c0 01             	add    $0x1,%eax
801049c3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801049c6:	39 f0                	cmp    %esi,%eax
801049c8:	74 16                	je     801049e0 <memcmp+0x40>
    if(*s1 != *s2)
801049ca:	0f b6 0a             	movzbl (%edx),%ecx
801049cd:	0f b6 18             	movzbl (%eax),%ebx
801049d0:	38 d9                	cmp    %bl,%cl
801049d2:	74 ec                	je     801049c0 <memcmp+0x20>
      return *s1 - *s2;
801049d4:	0f b6 c1             	movzbl %cl,%eax
801049d7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801049d9:	5b                   	pop    %ebx
801049da:	5e                   	pop    %esi
801049db:	5d                   	pop    %ebp
801049dc:	c3                   	ret
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
801049e0:	5b                   	pop    %ebx
  return 0;
801049e1:	31 c0                	xor    %eax,%eax
}
801049e3:	5e                   	pop    %esi
801049e4:	5d                   	pop    %ebp
801049e5:	c3                   	ret
801049e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049ed:	00 
801049ee:	66 90                	xchg   %ax,%ax

801049f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049f0:	f3 0f 1e fb          	endbr32
801049f4:	55                   	push   %ebp
801049f5:	89 e5                	mov    %esp,%ebp
801049f7:	57                   	push   %edi
801049f8:	8b 55 08             	mov    0x8(%ebp),%edx
801049fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049fe:	56                   	push   %esi
801049ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a02:	39 d6                	cmp    %edx,%esi
80104a04:	73 2a                	jae    80104a30 <memmove+0x40>
80104a06:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104a09:	39 fa                	cmp    %edi,%edx
80104a0b:	73 23                	jae    80104a30 <memmove+0x40>
80104a0d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104a10:	85 c9                	test   %ecx,%ecx
80104a12:	74 13                	je     80104a27 <memmove+0x37>
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104a18:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a1c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a1f:	83 e8 01             	sub    $0x1,%eax
80104a22:	83 f8 ff             	cmp    $0xffffffff,%eax
80104a25:	75 f1                	jne    80104a18 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a27:	5e                   	pop    %esi
80104a28:	89 d0                	mov    %edx,%eax
80104a2a:	5f                   	pop    %edi
80104a2b:	5d                   	pop    %ebp
80104a2c:	c3                   	ret
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a30:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104a33:	89 d7                	mov    %edx,%edi
80104a35:	85 c9                	test   %ecx,%ecx
80104a37:	74 ee                	je     80104a27 <memmove+0x37>
80104a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104a40:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a41:	39 f0                	cmp    %esi,%eax
80104a43:	75 fb                	jne    80104a40 <memmove+0x50>
}
80104a45:	5e                   	pop    %esi
80104a46:	89 d0                	mov    %edx,%eax
80104a48:	5f                   	pop    %edi
80104a49:	5d                   	pop    %ebp
80104a4a:	c3                   	ret
80104a4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104a50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a50:	f3 0f 1e fb          	endbr32
  return memmove(dst, src, n);
80104a54:	eb 9a                	jmp    801049f0 <memmove>
80104a56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a5d:	00 
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a60:	f3 0f 1e fb          	endbr32
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	56                   	push   %esi
80104a68:	8b 75 10             	mov    0x10(%ebp),%esi
80104a6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a6e:	53                   	push   %ebx
80104a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104a72:	85 f6                	test   %esi,%esi
80104a74:	74 32                	je     80104aa8 <strncmp+0x48>
80104a76:	01 c6                	add    %eax,%esi
80104a78:	eb 14                	jmp    80104a8e <strncmp+0x2e>
80104a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a80:	38 da                	cmp    %bl,%dl
80104a82:	75 14                	jne    80104a98 <strncmp+0x38>
    n--, p++, q++;
80104a84:	83 c0 01             	add    $0x1,%eax
80104a87:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a8a:	39 f0                	cmp    %esi,%eax
80104a8c:	74 1a                	je     80104aa8 <strncmp+0x48>
80104a8e:	0f b6 11             	movzbl (%ecx),%edx
80104a91:	0f b6 18             	movzbl (%eax),%ebx
80104a94:	84 d2                	test   %dl,%dl
80104a96:	75 e8                	jne    80104a80 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104a98:	0f b6 c2             	movzbl %dl,%eax
80104a9b:	29 d8                	sub    %ebx,%eax
}
80104a9d:	5b                   	pop    %ebx
80104a9e:	5e                   	pop    %esi
80104a9f:	5d                   	pop    %ebp
80104aa0:	c3                   	ret
80104aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aa8:	5b                   	pop    %ebx
    return 0;
80104aa9:	31 c0                	xor    %eax,%eax
}
80104aab:	5e                   	pop    %esi
80104aac:	5d                   	pop    %ebp
80104aad:	c3                   	ret
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ab0:	f3 0f 1e fb          	endbr32
80104ab4:	55                   	push   %ebp
80104ab5:	89 e5                	mov    %esp,%ebp
80104ab7:	57                   	push   %edi
80104ab8:	56                   	push   %esi
80104ab9:	8b 75 08             	mov    0x8(%ebp),%esi
80104abc:	53                   	push   %ebx
80104abd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ac0:	89 f2                	mov    %esi,%edx
80104ac2:	eb 1b                	jmp    80104adf <strncpy+0x2f>
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ac8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104acc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104acf:	83 c2 01             	add    $0x1,%edx
80104ad2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104ad6:	89 f9                	mov    %edi,%ecx
80104ad8:	88 4a ff             	mov    %cl,-0x1(%edx)
80104adb:	84 c9                	test   %cl,%cl
80104add:	74 09                	je     80104ae8 <strncpy+0x38>
80104adf:	89 c3                	mov    %eax,%ebx
80104ae1:	83 e8 01             	sub    $0x1,%eax
80104ae4:	85 db                	test   %ebx,%ebx
80104ae6:	7f e0                	jg     80104ac8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ae8:	89 d1                	mov    %edx,%ecx
80104aea:	85 c0                	test   %eax,%eax
80104aec:	7e 15                	jle    80104b03 <strncpy+0x53>
80104aee:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104af0:	83 c1 01             	add    $0x1,%ecx
80104af3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104af7:	89 c8                	mov    %ecx,%eax
80104af9:	f7 d0                	not    %eax
80104afb:	01 d0                	add    %edx,%eax
80104afd:	01 d8                	add    %ebx,%eax
80104aff:	85 c0                	test   %eax,%eax
80104b01:	7f ed                	jg     80104af0 <strncpy+0x40>
  return os;
}
80104b03:	5b                   	pop    %ebx
80104b04:	89 f0                	mov    %esi,%eax
80104b06:	5e                   	pop    %esi
80104b07:	5f                   	pop    %edi
80104b08:	5d                   	pop    %ebp
80104b09:	c3                   	ret
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b10:	f3 0f 1e fb          	endbr32
80104b14:	55                   	push   %ebp
80104b15:	89 e5                	mov    %esp,%ebp
80104b17:	56                   	push   %esi
80104b18:	8b 55 10             	mov    0x10(%ebp),%edx
80104b1b:	8b 75 08             	mov    0x8(%ebp),%esi
80104b1e:	53                   	push   %ebx
80104b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b22:	85 d2                	test   %edx,%edx
80104b24:	7e 21                	jle    80104b47 <safestrcpy+0x37>
80104b26:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b2a:	89 f2                	mov    %esi,%edx
80104b2c:	eb 12                	jmp    80104b40 <safestrcpy+0x30>
80104b2e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b30:	0f b6 08             	movzbl (%eax),%ecx
80104b33:	83 c0 01             	add    $0x1,%eax
80104b36:	83 c2 01             	add    $0x1,%edx
80104b39:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b3c:	84 c9                	test   %cl,%cl
80104b3e:	74 04                	je     80104b44 <safestrcpy+0x34>
80104b40:	39 d8                	cmp    %ebx,%eax
80104b42:	75 ec                	jne    80104b30 <safestrcpy+0x20>
    ;
  *s = 0;
80104b44:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b47:	89 f0                	mov    %esi,%eax
80104b49:	5b                   	pop    %ebx
80104b4a:	5e                   	pop    %esi
80104b4b:	5d                   	pop    %ebp
80104b4c:	c3                   	ret
80104b4d:	8d 76 00             	lea    0x0(%esi),%esi

80104b50 <strlen>:

int
strlen(const char *s)
{
80104b50:	f3 0f 1e fb          	endbr32
80104b54:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b55:	31 c0                	xor    %eax,%eax
{
80104b57:	89 e5                	mov    %esp,%ebp
80104b59:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b5c:	80 3a 00             	cmpb   $0x0,(%edx)
80104b5f:	74 10                	je     80104b71 <strlen+0x21>
80104b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b68:	83 c0 01             	add    $0x1,%eax
80104b6b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b6f:	75 f7                	jne    80104b68 <strlen+0x18>
    ;
  return n;
}
80104b71:	5d                   	pop    %ebp
80104b72:	c3                   	ret

80104b73 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b73:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b77:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b7b:	55                   	push   %ebp
  pushl %ebx
80104b7c:	53                   	push   %ebx
  pushl %esi
80104b7d:	56                   	push   %esi
  pushl %edi
80104b7e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b7f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b81:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b83:	5f                   	pop    %edi
  popl %esi
80104b84:	5e                   	pop    %esi
  popl %ebx
80104b85:	5b                   	pop    %ebx
  popl %ebp
80104b86:	5d                   	pop    %ebp
  ret
80104b87:	c3                   	ret
80104b88:	66 90                	xchg   %ax,%ax
80104b8a:	66 90                	xchg   %ax,%ax
80104b8c:	66 90                	xchg   %ax,%ax
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <fetchint>:
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip)
{
80104b90:	f3 0f 1e fb          	endbr32
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	53                   	push   %ebx
80104b98:	83 ec 04             	sub    $0x4,%esp
80104b9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b9e:	e8 8d ee ff ff       	call   80103a30 <myproc>

  if (addr >= curproc->sz || addr + 4 > curproc->sz)
80104ba3:	8b 00                	mov    (%eax),%eax
80104ba5:	39 d8                	cmp    %ebx,%eax
80104ba7:	76 17                	jbe    80104bc0 <fetchint+0x30>
80104ba9:	8d 53 04             	lea    0x4(%ebx),%edx
80104bac:	39 d0                	cmp    %edx,%eax
80104bae:	72 10                	jb     80104bc0 <fetchint+0x30>
    return -1;
  *ip = *(int *)(addr);
80104bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bb3:	8b 13                	mov    (%ebx),%edx
80104bb5:	89 10                	mov    %edx,(%eax)
  return 0;
80104bb7:	31 c0                	xor    %eax,%eax
}
80104bb9:	83 c4 04             	add    $0x4,%esp
80104bbc:	5b                   	pop    %ebx
80104bbd:	5d                   	pop    %ebp
80104bbe:	c3                   	ret
80104bbf:	90                   	nop
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc5:	eb f2                	jmp    80104bb9 <fetchint+0x29>
80104bc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bce:	00 
80104bcf:	90                   	nop

80104bd0 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp)
{
80104bd0:	f3 0f 1e fb          	endbr32
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	53                   	push   %ebx
80104bd8:	83 ec 04             	sub    $0x4,%esp
80104bdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bde:	e8 4d ee ff ff       	call   80103a30 <myproc>

  if (addr >= curproc->sz)
80104be3:	39 18                	cmp    %ebx,(%eax)
80104be5:	76 31                	jbe    80104c18 <fetchstr+0x48>
    return -1;
  *pp = (char *)addr;
80104be7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bea:	89 1a                	mov    %ebx,(%edx)
  ep = (char *)curproc->sz;
80104bec:	8b 10                	mov    (%eax),%edx
  for (s = *pp; s < ep; s++)
80104bee:	39 d3                	cmp    %edx,%ebx
80104bf0:	73 26                	jae    80104c18 <fetchstr+0x48>
80104bf2:	89 d8                	mov    %ebx,%eax
80104bf4:	eb 11                	jmp    80104c07 <fetchstr+0x37>
80104bf6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bfd:	00 
80104bfe:	66 90                	xchg   %ax,%ax
80104c00:	83 c0 01             	add    $0x1,%eax
80104c03:	39 c2                	cmp    %eax,%edx
80104c05:	76 11                	jbe    80104c18 <fetchstr+0x48>
  {
    if (*s == 0)
80104c07:	80 38 00             	cmpb   $0x0,(%eax)
80104c0a:	75 f4                	jne    80104c00 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104c0c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104c0f:	29 d8                	sub    %ebx,%eax
}
80104c11:	5b                   	pop    %ebx
80104c12:	5d                   	pop    %ebp
80104c13:	c3                   	ret
80104c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c18:	83 c4 04             	add    $0x4,%esp
    return -1;
80104c1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c20:	5b                   	pop    %ebx
80104c21:	5d                   	pop    %ebp
80104c22:	c3                   	ret
80104c23:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c2a:	00 
80104c2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104c30 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
80104c30:	f3 0f 1e fb          	endbr32
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	56                   	push   %esi
80104c38:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104c39:	e8 f2 ed ff ff       	call   80103a30 <myproc>
80104c3e:	8b 55 08             	mov    0x8(%ebp),%edx
80104c41:	8b 40 18             	mov    0x18(%eax),%eax
80104c44:	8b 40 44             	mov    0x44(%eax),%eax
80104c47:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c4a:	e8 e1 ed ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104c4f:	8d 73 04             	lea    0x4(%ebx),%esi
  if (addr >= curproc->sz || addr + 4 > curproc->sz)
80104c52:	8b 00                	mov    (%eax),%eax
80104c54:	39 c6                	cmp    %eax,%esi
80104c56:	73 18                	jae    80104c70 <argint+0x40>
80104c58:	8d 53 08             	lea    0x8(%ebx),%edx
80104c5b:	39 d0                	cmp    %edx,%eax
80104c5d:	72 11                	jb     80104c70 <argint+0x40>
  *ip = *(int *)(addr);
80104c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c62:	8b 53 04             	mov    0x4(%ebx),%edx
80104c65:	89 10                	mov    %edx,(%eax)
  return 0;
80104c67:	31 c0                	xor    %eax,%eax
}
80104c69:	5b                   	pop    %ebx
80104c6a:	5e                   	pop    %esi
80104c6b:	5d                   	pop    %ebp
80104c6c:	c3                   	ret
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104c75:	eb f2                	jmp    80104c69 <argint+0x39>
80104c77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c7e:	00 
80104c7f:	90                   	nop

80104c80 <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size)
{
80104c80:	f3 0f 1e fb          	endbr32
80104c84:	55                   	push   %ebp
80104c85:	89 e5                	mov    %esp,%ebp
80104c87:	56                   	push   %esi
80104c88:	53                   	push   %ebx
80104c89:	83 ec 10             	sub    $0x10,%esp
80104c8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104c8f:	e8 9c ed ff ff       	call   80103a30 <myproc>

  if (argint(n, &i) < 0)
80104c94:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104c97:	89 c6                	mov    %eax,%esi
  if (argint(n, &i) < 0)
80104c99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c9c:	50                   	push   %eax
80104c9d:	ff 75 08             	push   0x8(%ebp)
80104ca0:	e8 8b ff ff ff       	call   80104c30 <argint>
    return -1;
  if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz)
80104ca5:	83 c4 10             	add    $0x10,%esp
80104ca8:	85 c0                	test   %eax,%eax
80104caa:	78 24                	js     80104cd0 <argptr+0x50>
80104cac:	85 db                	test   %ebx,%ebx
80104cae:	78 20                	js     80104cd0 <argptr+0x50>
80104cb0:	8b 16                	mov    (%esi),%edx
80104cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb5:	39 c2                	cmp    %eax,%edx
80104cb7:	76 17                	jbe    80104cd0 <argptr+0x50>
80104cb9:	01 c3                	add    %eax,%ebx
80104cbb:	39 da                	cmp    %ebx,%edx
80104cbd:	72 11                	jb     80104cd0 <argptr+0x50>
    return -1;
  *pp = (char *)i;
80104cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cc2:	89 02                	mov    %eax,(%edx)
  return 0;
80104cc4:	31 c0                	xor    %eax,%eax
}
80104cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cc9:	5b                   	pop    %ebx
80104cca:	5e                   	pop    %esi
80104ccb:	5d                   	pop    %ebp
80104ccc:	c3                   	ret
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cd5:	eb ef                	jmp    80104cc6 <argptr+0x46>
80104cd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cde:	00 
80104cdf:	90                   	nop

80104ce0 <argstr>:
// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp)
{
80104ce0:	f3 0f 1e fb          	endbr32
80104ce4:	55                   	push   %ebp
80104ce5:	89 e5                	mov    %esp,%ebp
80104ce7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if (argint(n, &addr) < 0)
80104cea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ced:	50                   	push   %eax
80104cee:	ff 75 08             	push   0x8(%ebp)
80104cf1:	e8 3a ff ff ff       	call   80104c30 <argint>
80104cf6:	83 c4 10             	add    $0x10,%esp
80104cf9:	85 c0                	test   %eax,%eax
80104cfb:	78 13                	js     80104d10 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104cfd:	83 ec 08             	sub    $0x8,%esp
80104d00:	ff 75 0c             	push   0xc(%ebp)
80104d03:	ff 75 f4             	push   -0xc(%ebp)
80104d06:	e8 c5 fe ff ff       	call   80104bd0 <fetchstr>
80104d0b:	83 c4 10             	add    $0x10,%esp
}
80104d0e:	c9                   	leave
80104d0f:	c3                   	ret
80104d10:	c9                   	leave
    return -1;
80104d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d16:	c3                   	ret
80104d17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d1e:	00 
80104d1f:	90                   	nop

80104d20 <syscall>:
    [SYS_chmod] sys_chmod,
    [SYS_realsh] sys_realsh,
};

void syscall(void)
{
80104d20:	f3 0f 1e fb          	endbr32
80104d24:	55                   	push   %ebp
80104d25:	89 e5                	mov    %esp,%ebp
80104d27:	57                   	push   %edi
80104d28:	56                   	push   %esi
80104d29:	53                   	push   %ebx
80104d2a:	83 ec 0c             	sub    $0xc,%esp
  int num;
  struct proc *curproc = myproc();
80104d2d:	e8 fe ec ff ff       	call   80103a30 <myproc>
80104d32:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104d34:	8b 40 18             	mov    0x18(%eax),%eax
80104d37:	8b 70 1c             	mov    0x1c(%eax),%esi

  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
80104d3a:	8d 46 ff             	lea    -0x1(%esi),%eax
80104d3d:	83 f8 19             	cmp    $0x19,%eax
80104d40:	77 30                	ja     80104d72 <syscall+0x52>
80104d42:	8b 3c b5 a0 81 10 80 	mov    -0x7fef7e60(,%esi,4),%edi
80104d49:	85 ff                	test   %edi,%edi
80104d4b:	74 25                	je     80104d72 <syscall+0x52>
  {
    if (curproc->pid <= 2)
80104d4d:	8b 43 10             	mov    0x10(%ebx),%eax
80104d50:	83 f8 02             	cmp    $0x2,%eax
80104d53:	7e 2b                	jle    80104d80 <syscall+0x60>
    }
    if (curproc->pid > 2) // Ignore init/system processes
    {
      int bit = curproc->parent->syscall_bitmask[num];

      if (num == 7)
80104d55:	83 fe 07             	cmp    $0x7,%esi
80104d58:	74 66                	je     80104dc0 <syscall+0xa0>
      int bit = curproc->parent->syscall_bitmask[num];
80104d5a:	8b 53 14             	mov    0x14(%ebx),%edx
          curproc->tf->eax = -1; // Return error to indicate syscall is blocked
        }
      }
      else
      {
        if (bit == 0)
80104d5d:	8b 94 b2 80 00 00 00 	mov    0x80(%edx,%esi,4),%edx
80104d64:	85 d2                	test   %edx,%edx
80104d66:	75 38                	jne    80104da0 <syscall+0x80>
        {
          curproc->tf->eax = syscalls[num]();
80104d68:	ff d7                	call   *%edi
80104d6a:	89 c2                	mov    %eax,%edx
80104d6c:	8b 43 18             	mov    0x18(%ebx),%eax
80104d6f:	89 50 1c             	mov    %edx,0x1c(%eax)
          curproc->tf->eax = -1; // Return error to indicate syscall is blocked
        }
      }
    }
  }
}
80104d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d75:	5b                   	pop    %ebx
80104d76:	5e                   	pop    %esi
80104d77:	5f                   	pop    %edi
80104d78:	5d                   	pop    %ebp
80104d79:	c3                   	ret
80104d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      curproc->tf->eax = syscalls[num]();
80104d80:	ff d7                	call   *%edi
80104d82:	8b 53 18             	mov    0x18(%ebx),%edx
80104d85:	89 42 1c             	mov    %eax,0x1c(%edx)
    if (curproc->pid > 2) // Ignore init/system processes
80104d88:	8b 43 10             	mov    0x10(%ebx),%eax
80104d8b:	83 f8 02             	cmp    $0x2,%eax
80104d8e:	7f c5                	jg     80104d55 <syscall+0x35>
}
80104d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d93:	5b                   	pop    %ebx
80104d94:	5e                   	pop    %esi
80104d95:	5f                   	pop    %edi
80104d96:	5d                   	pop    %ebp
80104d97:	c3                   	ret
80104d98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d9f:	00 
          cprintf("Syscall %d blocked for PID %d\n", num, curproc->pid);
80104da0:	83 ec 04             	sub    $0x4,%esp
80104da3:	50                   	push   %eax
80104da4:	56                   	push   %esi
80104da5:	68 74 7e 10 80       	push   $0x80107e74
80104daa:	e8 01 b9 ff ff       	call   801006b0 <cprintf>
          curproc->tf->eax = -1; // Return error to indicate syscall is blocked
80104daf:	8b 43 18             	mov    0x18(%ebx),%eax
80104db2:	83 c4 10             	add    $0x10,%esp
80104db5:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104dbc:	eb b4                	jmp    80104d72 <syscall+0x52>
80104dbe:	66 90                	xchg   %ax,%ax
        struct proc *p = myproc();
80104dc0:	e8 6b ec ff ff       	call   80103a30 <myproc>
        p = p->parent;
80104dc5:	8b 70 14             	mov    0x14(%eax),%esi
          cprintf("curproc->pid=%d\n", myproc()->pid);
80104dc8:	e8 63 ec ff ff       	call   80103a30 <myproc>
80104dcd:	83 ec 08             	sub    $0x8,%esp
80104dd0:	ff 70 10             	push   0x10(%eax)
80104dd3:	68 8d 7b 10 80       	push   $0x80107b8d
80104dd8:	e8 d3 b8 ff ff       	call   801006b0 <cprintf>
          cprintf("curproc->parent->pid=%d\n", myproc()->parent->pid);
80104ddd:	e8 4e ec ff ff       	call   80103a30 <myproc>
80104de2:	5f                   	pop    %edi
80104de3:	5a                   	pop    %edx
80104de4:	8b 40 14             	mov    0x14(%eax),%eax
80104de7:	ff 70 10             	push   0x10(%eax)
80104dea:	68 9e 7b 10 80       	push   $0x80107b9e
80104def:	e8 bc b8 ff ff       	call   801006b0 <cprintf>
80104df4:	83 c4 10             	add    $0x10,%esp
80104df7:	eb 26                	jmp    80104e1f <syscall+0xff>
80104df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          cprintf("p->pid=%d\n", p->pid);
80104e00:	83 ec 08             	sub    $0x8,%esp
80104e03:	ff 76 10             	push   0x10(%esi)
80104e06:	68 b7 7b 10 80       	push   $0x80107bb7
80104e0b:	e8 a0 b8 ff ff       	call   801006b0 <cprintf>
          if (p->parent->syscall_bitmask[num] == 1)
80104e10:	8b 76 14             	mov    0x14(%esi),%esi
80104e13:	83 c4 10             	add    $0x10,%esp
80104e16:	83 be 9c 00 00 00 01 	cmpl   $0x1,0x9c(%esi)
80104e1d:	74 49                	je     80104e68 <syscall+0x148>
        while (p->parent->pid != 1)
80104e1f:	8b 46 14             	mov    0x14(%esi),%eax
80104e22:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
80104e26:	75 d8                	jne    80104e00 <syscall+0xe0>
        if ((curproc->real_sh != 2) && (is_bit_set_in_ancestors_except_parent == 0)) // Proper precedence
80104e28:	83 bb ec 00 00 00 02 	cmpl   $0x2,0xec(%ebx)
80104e2f:	74 4f                	je     80104e80 <syscall+0x160>
          curproc->tf->eax = syscalls[num](); // Allow
80104e31:	e8 3a 0b 00 00       	call   80105970 <sys_exec>
80104e36:	8b 53 18             	mov    0x18(%ebx),%edx
            cprintf("name==%s\n", curproc->name);
80104e39:	83 ec 08             	sub    $0x8,%esp
80104e3c:	83 c3 6c             	add    $0x6c,%ebx
          curproc->tf->eax = syscalls[num](); // Allow
80104e3f:	89 42 1c             	mov    %eax,0x1c(%edx)
            cprintf("name==%s\n", curproc->name);
80104e42:	53                   	push   %ebx
80104e43:	68 c2 7b 10 80       	push   $0x80107bc2
80104e48:	e8 63 b8 ff ff       	call   801006b0 <cprintf>
            cprintf("ancestral=%d\n\n", is_bit_set_in_ancestors_except_parent);
80104e4d:	59                   	pop    %ecx
80104e4e:	5b                   	pop    %ebx
80104e4f:	6a 00                	push   $0x0
80104e51:	68 cc 7b 10 80       	push   $0x80107bcc
80104e56:	e8 55 b8 ff ff       	call   801006b0 <cprintf>
80104e5b:	83 c4 10             	add    $0x10,%esp
80104e5e:	e9 0f ff ff ff       	jmp    80104d72 <syscall+0x52>
80104e63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        if ((curproc->real_sh != 2) && (is_bit_set_in_ancestors_except_parent == 0)) // Proper precedence
80104e68:	83 bb ec 00 00 00 02 	cmpl   $0x2,0xec(%ebx)
80104e6f:	74 0f                	je     80104e80 <syscall+0x160>
          cprintf("Syscall %d blocked for PID %d\n", num, curproc->pid);
80104e71:	83 ec 04             	sub    $0x4,%esp
80104e74:	ff 73 10             	push   0x10(%ebx)
80104e77:	6a 07                	push   $0x7
80104e79:	e9 27 ff ff ff       	jmp    80104da5 <syscall+0x85>
80104e7e:	66 90                	xchg   %ax,%ax
          curproc->tf->eax = syscalls[num](); // Allow
80104e80:	e8 eb 0a 00 00       	call   80105970 <sys_exec>
80104e85:	89 c2                	mov    %eax,%edx
80104e87:	8b 43 18             	mov    0x18(%ebx),%eax
80104e8a:	89 50 1c             	mov    %edx,0x1c(%eax)
80104e8d:	e9 e0 fe ff ff       	jmp    80104d72 <syscall+0x52>
80104e92:	66 90                	xchg   %ax,%ax
80104e94:	66 90                	xchg   %ax,%ax
80104e96:	66 90                	xchg   %ax,%ax
80104e98:	66 90                	xchg   %ax,%ax
80104e9a:	66 90                	xchg   %ax,%ax
80104e9c:	66 90                	xchg   %ax,%ax
80104e9e:	66 90                	xchg   %ax,%ax

80104ea0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	57                   	push   %edi
80104ea4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ea5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ea8:	53                   	push   %ebx
80104ea9:	83 ec 34             	sub    $0x34,%esp
80104eac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104eaf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104eb2:	57                   	push   %edi
80104eb3:	50                   	push   %eax
{
80104eb4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104eb7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104eba:	e8 21 d2 ff ff       	call   801020e0 <nameiparent>
80104ebf:	83 c4 10             	add    $0x10,%esp
80104ec2:	85 c0                	test   %eax,%eax
80104ec4:	0f 84 4e 01 00 00    	je     80105018 <create+0x178>
    return 0;
  ilock(dp);
80104eca:	83 ec 0c             	sub    $0xc,%esp
80104ecd:	89 c3                	mov    %eax,%ebx
80104ecf:	50                   	push   %eax
80104ed0:	e8 0b c9 ff ff       	call   801017e0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104ed5:	83 c4 0c             	add    $0xc,%esp
80104ed8:	6a 00                	push   $0x0
80104eda:	57                   	push   %edi
80104edb:	53                   	push   %ebx
80104edc:	e8 5f ce ff ff       	call   80101d40 <dirlookup>
80104ee1:	83 c4 10             	add    $0x10,%esp
80104ee4:	89 c6                	mov    %eax,%esi
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	74 56                	je     80104f40 <create+0xa0>
    iunlockput(dp);
80104eea:	83 ec 0c             	sub    $0xc,%esp
80104eed:	53                   	push   %ebx
80104eee:	e8 8d cb ff ff       	call   80101a80 <iunlockput>
    ilock(ip);
80104ef3:	89 34 24             	mov    %esi,(%esp)
80104ef6:	e8 e5 c8 ff ff       	call   801017e0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104efb:	83 c4 10             	add    $0x10,%esp
80104efe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104f03:	75 1b                	jne    80104f20 <create+0x80>
80104f05:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104f0a:	75 14                	jne    80104f20 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f0f:	89 f0                	mov    %esi,%eax
80104f11:	5b                   	pop    %ebx
80104f12:	5e                   	pop    %esi
80104f13:	5f                   	pop    %edi
80104f14:	5d                   	pop    %ebp
80104f15:	c3                   	ret
80104f16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f1d:	00 
80104f1e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104f20:	83 ec 0c             	sub    $0xc,%esp
80104f23:	56                   	push   %esi
    return 0;
80104f24:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104f26:	e8 55 cb ff ff       	call   80101a80 <iunlockput>
    return 0;
80104f2b:	83 c4 10             	add    $0x10,%esp
}
80104f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f31:	89 f0                	mov    %esi,%eax
80104f33:	5b                   	pop    %ebx
80104f34:	5e                   	pop    %esi
80104f35:	5f                   	pop    %edi
80104f36:	5d                   	pop    %ebp
80104f37:	c3                   	ret
80104f38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f3f:	00 
  if((ip = ialloc(dp->dev, type)) == 0)
80104f40:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f44:	83 ec 08             	sub    $0x8,%esp
80104f47:	50                   	push   %eax
80104f48:	ff 33                	push   (%ebx)
80104f4a:	e8 01 c7 ff ff       	call   80101650 <ialloc>
80104f4f:	83 c4 10             	add    $0x10,%esp
80104f52:	89 c6                	mov    %eax,%esi
80104f54:	85 c0                	test   %eax,%eax
80104f56:	0f 84 d5 00 00 00    	je     80105031 <create+0x191>
  ilock(ip);
80104f5c:	83 ec 0c             	sub    $0xc,%esp
80104f5f:	50                   	push   %eax
80104f60:	e8 7b c8 ff ff       	call   801017e0 <ilock>
  ip->major = major;
80104f65:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  ip->mode = 7;
80104f69:	c7 86 90 00 00 00 07 	movl   $0x7,0x90(%esi)
80104f70:	00 00 00 
  ip->major = major;
80104f73:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104f77:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104f7b:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104f7f:	b8 01 00 00 00       	mov    $0x1,%eax
80104f84:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104f88:	89 34 24             	mov    %esi,(%esp)
80104f8b:	e8 90 c7 ff ff       	call   80101720 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f90:	83 c4 10             	add    $0x10,%esp
80104f93:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f98:	74 2e                	je     80104fc8 <create+0x128>
  if(dirlink(dp, name, ip->inum) < 0)
80104f9a:	83 ec 04             	sub    $0x4,%esp
80104f9d:	ff 76 04             	push   0x4(%esi)
80104fa0:	57                   	push   %edi
80104fa1:	53                   	push   %ebx
80104fa2:	e8 59 d0 ff ff       	call   80102000 <dirlink>
80104fa7:	83 c4 10             	add    $0x10,%esp
80104faa:	85 c0                	test   %eax,%eax
80104fac:	78 76                	js     80105024 <create+0x184>
  iunlockput(dp);
80104fae:	83 ec 0c             	sub    $0xc,%esp
80104fb1:	53                   	push   %ebx
80104fb2:	e8 c9 ca ff ff       	call   80101a80 <iunlockput>
  return ip;
80104fb7:	83 c4 10             	add    $0x10,%esp
}
80104fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fbd:	89 f0                	mov    %esi,%eax
80104fbf:	5b                   	pop    %ebx
80104fc0:	5e                   	pop    %esi
80104fc1:	5f                   	pop    %edi
80104fc2:	5d                   	pop    %ebp
80104fc3:	c3                   	ret
80104fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iupdate(dp);
80104fc8:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104fcb:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104fd0:	53                   	push   %ebx
80104fd1:	e8 4a c7 ff ff       	call   80101720 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104fd6:	83 c4 0c             	add    $0xc,%esp
80104fd9:	ff 76 04             	push   0x4(%esi)
80104fdc:	68 f7 7b 10 80       	push   $0x80107bf7
80104fe1:	56                   	push   %esi
80104fe2:	e8 19 d0 ff ff       	call   80102000 <dirlink>
80104fe7:	83 c4 10             	add    $0x10,%esp
80104fea:	85 c0                	test   %eax,%eax
80104fec:	78 18                	js     80105006 <create+0x166>
80104fee:	83 ec 04             	sub    $0x4,%esp
80104ff1:	ff 73 04             	push   0x4(%ebx)
80104ff4:	68 f6 7b 10 80       	push   $0x80107bf6
80104ff9:	56                   	push   %esi
80104ffa:	e8 01 d0 ff ff       	call   80102000 <dirlink>
80104fff:	83 c4 10             	add    $0x10,%esp
80105002:	85 c0                	test   %eax,%eax
80105004:	79 94                	jns    80104f9a <create+0xfa>
      panic("create dots");
80105006:	83 ec 0c             	sub    $0xc,%esp
80105009:	68 ea 7b 10 80       	push   $0x80107bea
8010500e:	e8 7d b3 ff ff       	call   80100390 <panic>
80105013:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80105018:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
8010501b:	31 f6                	xor    %esi,%esi
}
8010501d:	5b                   	pop    %ebx
8010501e:	89 f0                	mov    %esi,%eax
80105020:	5e                   	pop    %esi
80105021:	5f                   	pop    %edi
80105022:	5d                   	pop    %ebp
80105023:	c3                   	ret
    panic("create: dirlink");
80105024:	83 ec 0c             	sub    $0xc,%esp
80105027:	68 f9 7b 10 80       	push   $0x80107bf9
8010502c:	e8 5f b3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105031:	83 ec 0c             	sub    $0xc,%esp
80105034:	68 db 7b 10 80       	push   $0x80107bdb
80105039:	e8 52 b3 ff ff       	call   80100390 <panic>
8010503e:	66 90                	xchg   %ax,%ax

80105040 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	89 d6                	mov    %edx,%esi
80105046:	53                   	push   %ebx
80105047:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105049:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010504c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010504f:	50                   	push   %eax
80105050:	6a 00                	push   $0x0
80105052:	e8 d9 fb ff ff       	call   80104c30 <argint>
80105057:	83 c4 10             	add    $0x10,%esp
8010505a:	85 c0                	test   %eax,%eax
8010505c:	78 2a                	js     80105088 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010505e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105062:	77 24                	ja     80105088 <argfd.constprop.0+0x48>
80105064:	e8 c7 e9 ff ff       	call   80103a30 <myproc>
80105069:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010506c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105070:	85 c0                	test   %eax,%eax
80105072:	74 14                	je     80105088 <argfd.constprop.0+0x48>
  if(pfd)
80105074:	85 db                	test   %ebx,%ebx
80105076:	74 02                	je     8010507a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105078:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010507a:	89 06                	mov    %eax,(%esi)
  return 0;
8010507c:	31 c0                	xor    %eax,%eax
}
8010507e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105081:	5b                   	pop    %ebx
80105082:	5e                   	pop    %esi
80105083:	5d                   	pop    %ebp
80105084:	c3                   	ret
80105085:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010508d:	eb ef                	jmp    8010507e <argfd.constprop.0+0x3e>
8010508f:	90                   	nop

80105090 <sys_dup>:
{
80105090:	f3 0f 1e fb          	endbr32
80105094:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105095:	31 c0                	xor    %eax,%eax
{
80105097:	89 e5                	mov    %esp,%ebp
80105099:	56                   	push   %esi
8010509a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010509b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010509e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801050a1:	e8 9a ff ff ff       	call   80105040 <argfd.constprop.0>
801050a6:	85 c0                	test   %eax,%eax
801050a8:	78 1e                	js     801050c8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801050aa:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050ad:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801050af:	e8 7c e9 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801050b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801050b8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801050bc:	85 d2                	test   %edx,%edx
801050be:	74 20                	je     801050e0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801050c0:	83 c3 01             	add    $0x1,%ebx
801050c3:	83 fb 10             	cmp    $0x10,%ebx
801050c6:	75 f0                	jne    801050b8 <sys_dup+0x28>
}
801050c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801050cb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801050d0:	89 d8                	mov    %ebx,%eax
801050d2:	5b                   	pop    %ebx
801050d3:	5e                   	pop    %esi
801050d4:	5d                   	pop    %ebp
801050d5:	c3                   	ret
801050d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801050dd:	00 
801050de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801050e0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801050e4:	83 ec 0c             	sub    $0xc,%esp
801050e7:	ff 75 f4             	push   -0xc(%ebp)
801050ea:	e8 e1 bd ff ff       	call   80100ed0 <filedup>
  return fd;
801050ef:	83 c4 10             	add    $0x10,%esp
}
801050f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050f5:	89 d8                	mov    %ebx,%eax
801050f7:	5b                   	pop    %ebx
801050f8:	5e                   	pop    %esi
801050f9:	5d                   	pop    %ebp
801050fa:	c3                   	ret
801050fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105100 <sys_read>:
{
80105100:	f3 0f 1e fb          	endbr32
80105104:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105105:	31 c0                	xor    %eax,%eax
{
80105107:	89 e5                	mov    %esp,%ebp
80105109:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010510c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010510f:	e8 2c ff ff ff       	call   80105040 <argfd.constprop.0>
80105114:	85 c0                	test   %eax,%eax
80105116:	0f 88 9e 00 00 00    	js     801051ba <sys_read+0xba>
8010511c:	83 ec 08             	sub    $0x8,%esp
8010511f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105122:	50                   	push   %eax
80105123:	6a 02                	push   $0x2
80105125:	e8 06 fb ff ff       	call   80104c30 <argint>
8010512a:	83 c4 10             	add    $0x10,%esp
8010512d:	85 c0                	test   %eax,%eax
8010512f:	0f 88 85 00 00 00    	js     801051ba <sys_read+0xba>
80105135:	83 ec 04             	sub    $0x4,%esp
80105138:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010513b:	ff 75 f0             	push   -0x10(%ebp)
8010513e:	50                   	push   %eax
8010513f:	6a 01                	push   $0x1
80105141:	e8 3a fb ff ff       	call   80104c80 <argptr>
80105146:	83 c4 10             	add    $0x10,%esp
80105149:	85 c0                	test   %eax,%eax
8010514b:	78 6d                	js     801051ba <sys_read+0xba>
  if(f->type == FD_INODE){
8010514d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105150:	83 38 02             	cmpl   $0x2,(%eax)
80105153:	74 1b                	je     80105170 <sys_read+0x70>
  return fileread(f, p, n);
80105155:	83 ec 04             	sub    $0x4,%esp
80105158:	ff 75 f0             	push   -0x10(%ebp)
8010515b:	ff 75 f4             	push   -0xc(%ebp)
8010515e:	50                   	push   %eax
8010515f:	e8 ec be ff ff       	call   80101050 <fileread>
80105164:	83 c4 10             	add    $0x10,%esp
}
80105167:	c9                   	leave
80105168:	c3                   	ret
80105169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ilock(f->ip);
80105170:	83 ec 0c             	sub    $0xc,%esp
80105173:	ff 70 10             	push   0x10(%eax)
80105176:	e8 65 c6 ff ff       	call   801017e0 <ilock>
    if (!(f->ip->mode & 0x1)) {
8010517b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010517e:	83 c4 10             	add    $0x10,%esp
80105181:	8b 40 10             	mov    0x10(%eax),%eax
80105184:	f6 80 90 00 00 00 01 	testb  $0x1,0x90(%eax)
8010518b:	74 11                	je     8010519e <sys_read+0x9e>
    iunlock(f->ip);
8010518d:	83 ec 0c             	sub    $0xc,%esp
80105190:	50                   	push   %eax
80105191:	e8 2a c7 ff ff       	call   801018c0 <iunlock>
80105196:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105199:	83 c4 10             	add    $0x10,%esp
8010519c:	eb b7                	jmp    80105155 <sys_read+0x55>
        cprintf("Operation read failed\n");
8010519e:	83 ec 0c             	sub    $0xc,%esp
801051a1:	68 09 7c 10 80       	push   $0x80107c09
801051a6:	e8 05 b5 ff ff       	call   801006b0 <cprintf>
        iunlock(f->ip);
801051ab:	58                   	pop    %eax
801051ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051af:	ff 70 10             	push   0x10(%eax)
801051b2:	e8 09 c7 ff ff       	call   801018c0 <iunlock>
        return -1;
801051b7:	83 c4 10             	add    $0x10,%esp
}
801051ba:	c9                   	leave
        return -1;
801051bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c0:	c3                   	ret
801051c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051c8:	00 
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051d0 <sys_write>:
{
801051d0:	f3 0f 1e fb          	endbr32
801051d4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d5:	31 c0                	xor    %eax,%eax
{
801051d7:	89 e5                	mov    %esp,%ebp
801051d9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051dc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051df:	e8 5c fe ff ff       	call   80105040 <argfd.constprop.0>
801051e4:	85 c0                	test   %eax,%eax
801051e6:	0f 88 9e 00 00 00    	js     8010528a <sys_write+0xba>
801051ec:	83 ec 08             	sub    $0x8,%esp
801051ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051f2:	50                   	push   %eax
801051f3:	6a 02                	push   $0x2
801051f5:	e8 36 fa ff ff       	call   80104c30 <argint>
801051fa:	83 c4 10             	add    $0x10,%esp
801051fd:	85 c0                	test   %eax,%eax
801051ff:	0f 88 85 00 00 00    	js     8010528a <sys_write+0xba>
80105205:	83 ec 04             	sub    $0x4,%esp
80105208:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010520b:	ff 75 f0             	push   -0x10(%ebp)
8010520e:	50                   	push   %eax
8010520f:	6a 01                	push   $0x1
80105211:	e8 6a fa ff ff       	call   80104c80 <argptr>
80105216:	83 c4 10             	add    $0x10,%esp
80105219:	85 c0                	test   %eax,%eax
8010521b:	78 6d                	js     8010528a <sys_write+0xba>
  if(f->type == FD_INODE){
8010521d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105220:	83 38 02             	cmpl   $0x2,(%eax)
80105223:	74 1b                	je     80105240 <sys_write+0x70>
  return filewrite(f, p, n);
80105225:	83 ec 04             	sub    $0x4,%esp
80105228:	ff 75 f0             	push   -0x10(%ebp)
8010522b:	ff 75 f4             	push   -0xc(%ebp)
8010522e:	50                   	push   %eax
8010522f:	e8 bc be ff ff       	call   801010f0 <filewrite>
80105234:	83 c4 10             	add    $0x10,%esp
}
80105237:	c9                   	leave
80105238:	c3                   	ret
80105239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ilock(f->ip);
80105240:	83 ec 0c             	sub    $0xc,%esp
80105243:	ff 70 10             	push   0x10(%eax)
80105246:	e8 95 c5 ff ff       	call   801017e0 <ilock>
    if (!(f->ip->mode & 0x2)) {
8010524b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010524e:	83 c4 10             	add    $0x10,%esp
80105251:	8b 40 10             	mov    0x10(%eax),%eax
80105254:	f6 80 90 00 00 00 02 	testb  $0x2,0x90(%eax)
8010525b:	74 11                	je     8010526e <sys_write+0x9e>
    iunlock(f->ip);
8010525d:	83 ec 0c             	sub    $0xc,%esp
80105260:	50                   	push   %eax
80105261:	e8 5a c6 ff ff       	call   801018c0 <iunlock>
80105266:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105269:	83 c4 10             	add    $0x10,%esp
8010526c:	eb b7                	jmp    80105225 <sys_write+0x55>
        cprintf("Operation write failed\n");
8010526e:	83 ec 0c             	sub    $0xc,%esp
80105271:	68 20 7c 10 80       	push   $0x80107c20
80105276:	e8 35 b4 ff ff       	call   801006b0 <cprintf>
        iunlock(f->ip);
8010527b:	58                   	pop    %eax
8010527c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010527f:	ff 70 10             	push   0x10(%eax)
80105282:	e8 39 c6 ff ff       	call   801018c0 <iunlock>
        return -1;
80105287:	83 c4 10             	add    $0x10,%esp
}
8010528a:	c9                   	leave
        return -1;
8010528b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105290:	c3                   	ret
80105291:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105298:	00 
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052a0 <sys_close>:
{
801052a0:	f3 0f 1e fb          	endbr32
801052a4:	55                   	push   %ebp
801052a5:	89 e5                	mov    %esp,%ebp
801052a7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801052aa:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052b0:	e8 8b fd ff ff       	call   80105040 <argfd.constprop.0>
801052b5:	85 c0                	test   %eax,%eax
801052b7:	78 27                	js     801052e0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801052b9:	e8 72 e7 ff ff       	call   80103a30 <myproc>
801052be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801052c1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801052c4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801052cb:	00 
  fileclose(f);
801052cc:	ff 75 f4             	push   -0xc(%ebp)
801052cf:	e8 4c bc ff ff       	call   80100f20 <fileclose>
  return 0;
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	31 c0                	xor    %eax,%eax
}
801052d9:	c9                   	leave
801052da:	c3                   	ret
801052db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801052e0:	c9                   	leave
    return -1;
801052e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052e6:	c3                   	ret
801052e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801052ee:	00 
801052ef:	90                   	nop

801052f0 <sys_fstat>:
{
801052f0:	f3 0f 1e fb          	endbr32
801052f4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052f5:	31 c0                	xor    %eax,%eax
{
801052f7:	89 e5                	mov    %esp,%ebp
801052f9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052fc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801052ff:	e8 3c fd ff ff       	call   80105040 <argfd.constprop.0>
80105304:	85 c0                	test   %eax,%eax
80105306:	78 30                	js     80105338 <sys_fstat+0x48>
80105308:	83 ec 04             	sub    $0x4,%esp
8010530b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010530e:	6a 18                	push   $0x18
80105310:	50                   	push   %eax
80105311:	6a 01                	push   $0x1
80105313:	e8 68 f9 ff ff       	call   80104c80 <argptr>
80105318:	83 c4 10             	add    $0x10,%esp
8010531b:	85 c0                	test   %eax,%eax
8010531d:	78 19                	js     80105338 <sys_fstat+0x48>
  return filestat(f, st);
8010531f:	83 ec 08             	sub    $0x8,%esp
80105322:	ff 75 f4             	push   -0xc(%ebp)
80105325:	ff 75 f0             	push   -0x10(%ebp)
80105328:	e8 d3 bc ff ff       	call   80101000 <filestat>
8010532d:	83 c4 10             	add    $0x10,%esp
}
80105330:	c9                   	leave
80105331:	c3                   	ret
80105332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105338:	c9                   	leave
    return -1;
80105339:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010533e:	c3                   	ret
8010533f:	90                   	nop

80105340 <sys_link>:
{
80105340:	f3 0f 1e fb          	endbr32
80105344:	55                   	push   %ebp
80105345:	89 e5                	mov    %esp,%ebp
80105347:	57                   	push   %edi
80105348:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105349:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010534c:	53                   	push   %ebx
8010534d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105350:	50                   	push   %eax
80105351:	6a 00                	push   $0x0
80105353:	e8 88 f9 ff ff       	call   80104ce0 <argstr>
80105358:	83 c4 10             	add    $0x10,%esp
8010535b:	85 c0                	test   %eax,%eax
8010535d:	0f 88 ff 00 00 00    	js     80105462 <sys_link+0x122>
80105363:	83 ec 08             	sub    $0x8,%esp
80105366:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105369:	50                   	push   %eax
8010536a:	6a 01                	push   $0x1
8010536c:	e8 6f f9 ff ff       	call   80104ce0 <argstr>
80105371:	83 c4 10             	add    $0x10,%esp
80105374:	85 c0                	test   %eax,%eax
80105376:	0f 88 e6 00 00 00    	js     80105462 <sys_link+0x122>
  begin_op();
8010537c:	e8 3f da ff ff       	call   80102dc0 <begin_op>
  if((ip = namei(old)) == 0){
80105381:	83 ec 0c             	sub    $0xc,%esp
80105384:	ff 75 d4             	push   -0x2c(%ebp)
80105387:	e8 34 cd ff ff       	call   801020c0 <namei>
8010538c:	83 c4 10             	add    $0x10,%esp
8010538f:	89 c3                	mov    %eax,%ebx
80105391:	85 c0                	test   %eax,%eax
80105393:	0f 84 e8 00 00 00    	je     80105481 <sys_link+0x141>
  ilock(ip);
80105399:	83 ec 0c             	sub    $0xc,%esp
8010539c:	50                   	push   %eax
8010539d:	e8 3e c4 ff ff       	call   801017e0 <ilock>
  if(ip->type == T_DIR){
801053a2:	83 c4 10             	add    $0x10,%esp
801053a5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053aa:	0f 84 b9 00 00 00    	je     80105469 <sys_link+0x129>
  iupdate(ip);
801053b0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801053b3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801053b8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801053bb:	53                   	push   %ebx
801053bc:	e8 5f c3 ff ff       	call   80101720 <iupdate>
  iunlock(ip);
801053c1:	89 1c 24             	mov    %ebx,(%esp)
801053c4:	e8 f7 c4 ff ff       	call   801018c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801053c9:	58                   	pop    %eax
801053ca:	5a                   	pop    %edx
801053cb:	57                   	push   %edi
801053cc:	ff 75 d0             	push   -0x30(%ebp)
801053cf:	e8 0c cd ff ff       	call   801020e0 <nameiparent>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	89 c6                	mov    %eax,%esi
801053d9:	85 c0                	test   %eax,%eax
801053db:	74 5f                	je     8010543c <sys_link+0xfc>
  ilock(dp);
801053dd:	83 ec 0c             	sub    $0xc,%esp
801053e0:	50                   	push   %eax
801053e1:	e8 fa c3 ff ff       	call   801017e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053e6:	8b 03                	mov    (%ebx),%eax
801053e8:	83 c4 10             	add    $0x10,%esp
801053eb:	39 06                	cmp    %eax,(%esi)
801053ed:	75 41                	jne    80105430 <sys_link+0xf0>
801053ef:	83 ec 04             	sub    $0x4,%esp
801053f2:	ff 73 04             	push   0x4(%ebx)
801053f5:	57                   	push   %edi
801053f6:	56                   	push   %esi
801053f7:	e8 04 cc ff ff       	call   80102000 <dirlink>
801053fc:	83 c4 10             	add    $0x10,%esp
801053ff:	85 c0                	test   %eax,%eax
80105401:	78 2d                	js     80105430 <sys_link+0xf0>
  iunlockput(dp);
80105403:	83 ec 0c             	sub    $0xc,%esp
80105406:	56                   	push   %esi
80105407:	e8 74 c6 ff ff       	call   80101a80 <iunlockput>
  iput(ip);
8010540c:	89 1c 24             	mov    %ebx,(%esp)
8010540f:	e8 fc c4 ff ff       	call   80101910 <iput>
  end_op();
80105414:	e8 17 da ff ff       	call   80102e30 <end_op>
  return 0;
80105419:	83 c4 10             	add    $0x10,%esp
8010541c:	31 c0                	xor    %eax,%eax
}
8010541e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105421:	5b                   	pop    %ebx
80105422:	5e                   	pop    %esi
80105423:	5f                   	pop    %edi
80105424:	5d                   	pop    %ebp
80105425:	c3                   	ret
80105426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010542d:	00 
8010542e:	66 90                	xchg   %ax,%ax
    iunlockput(dp);
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	56                   	push   %esi
80105434:	e8 47 c6 ff ff       	call   80101a80 <iunlockput>
    goto bad;
80105439:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010543c:	83 ec 0c             	sub    $0xc,%esp
8010543f:	53                   	push   %ebx
80105440:	e8 9b c3 ff ff       	call   801017e0 <ilock>
  ip->nlink--;
80105445:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010544a:	89 1c 24             	mov    %ebx,(%esp)
8010544d:	e8 ce c2 ff ff       	call   80101720 <iupdate>
  iunlockput(ip);
80105452:	89 1c 24             	mov    %ebx,(%esp)
80105455:	e8 26 c6 ff ff       	call   80101a80 <iunlockput>
  end_op();
8010545a:	e8 d1 d9 ff ff       	call   80102e30 <end_op>
  return -1;
8010545f:	83 c4 10             	add    $0x10,%esp
80105462:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105467:	eb b5                	jmp    8010541e <sys_link+0xde>
    iunlockput(ip);
80105469:	83 ec 0c             	sub    $0xc,%esp
8010546c:	53                   	push   %ebx
8010546d:	e8 0e c6 ff ff       	call   80101a80 <iunlockput>
    end_op();
80105472:	e8 b9 d9 ff ff       	call   80102e30 <end_op>
    return -1;
80105477:	83 c4 10             	add    $0x10,%esp
8010547a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010547f:	eb 9d                	jmp    8010541e <sys_link+0xde>
    end_op();
80105481:	e8 aa d9 ff ff       	call   80102e30 <end_op>
    return -1;
80105486:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010548b:	eb 91                	jmp    8010541e <sys_link+0xde>
8010548d:	8d 76 00             	lea    0x0(%esi),%esi

80105490 <sys_unlink>:
{
80105490:	f3 0f 1e fb          	endbr32
80105494:	55                   	push   %ebp
80105495:	89 e5                	mov    %esp,%ebp
80105497:	57                   	push   %edi
80105498:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105499:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010549c:	53                   	push   %ebx
8010549d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801054a0:	50                   	push   %eax
801054a1:	6a 00                	push   $0x0
801054a3:	e8 38 f8 ff ff       	call   80104ce0 <argstr>
801054a8:	83 c4 10             	add    $0x10,%esp
801054ab:	85 c0                	test   %eax,%eax
801054ad:	0f 88 7d 01 00 00    	js     80105630 <sys_unlink+0x1a0>
  begin_op();
801054b3:	e8 08 d9 ff ff       	call   80102dc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801054b8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801054bb:	83 ec 08             	sub    $0x8,%esp
801054be:	53                   	push   %ebx
801054bf:	ff 75 c0             	push   -0x40(%ebp)
801054c2:	e8 19 cc ff ff       	call   801020e0 <nameiparent>
801054c7:	83 c4 10             	add    $0x10,%esp
801054ca:	89 c6                	mov    %eax,%esi
801054cc:	85 c0                	test   %eax,%eax
801054ce:	0f 84 66 01 00 00    	je     8010563a <sys_unlink+0x1aa>
  ilock(dp);
801054d4:	83 ec 0c             	sub    $0xc,%esp
801054d7:	50                   	push   %eax
801054d8:	e8 03 c3 ff ff       	call   801017e0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801054dd:	58                   	pop    %eax
801054de:	5a                   	pop    %edx
801054df:	68 f7 7b 10 80       	push   $0x80107bf7
801054e4:	53                   	push   %ebx
801054e5:	e8 36 c8 ff ff       	call   80101d20 <namecmp>
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	85 c0                	test   %eax,%eax
801054ef:	0f 84 03 01 00 00    	je     801055f8 <sys_unlink+0x168>
801054f5:	83 ec 08             	sub    $0x8,%esp
801054f8:	68 f6 7b 10 80       	push   $0x80107bf6
801054fd:	53                   	push   %ebx
801054fe:	e8 1d c8 ff ff       	call   80101d20 <namecmp>
80105503:	83 c4 10             	add    $0x10,%esp
80105506:	85 c0                	test   %eax,%eax
80105508:	0f 84 ea 00 00 00    	je     801055f8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010550e:	83 ec 04             	sub    $0x4,%esp
80105511:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105514:	50                   	push   %eax
80105515:	53                   	push   %ebx
80105516:	56                   	push   %esi
80105517:	e8 24 c8 ff ff       	call   80101d40 <dirlookup>
8010551c:	83 c4 10             	add    $0x10,%esp
8010551f:	89 c3                	mov    %eax,%ebx
80105521:	85 c0                	test   %eax,%eax
80105523:	0f 84 cf 00 00 00    	je     801055f8 <sys_unlink+0x168>
  ilock(ip);
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	50                   	push   %eax
8010552d:	e8 ae c2 ff ff       	call   801017e0 <ilock>
  if(ip->nlink < 1)
80105532:	83 c4 10             	add    $0x10,%esp
80105535:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010553a:	0f 8e 23 01 00 00    	jle    80105663 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105540:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105545:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105548:	74 66                	je     801055b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010554a:	83 ec 04             	sub    $0x4,%esp
8010554d:	6a 10                	push   $0x10
8010554f:	6a 00                	push   $0x0
80105551:	57                   	push   %edi
80105552:	e8 f9 f3 ff ff       	call   80104950 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105557:	6a 10                	push   $0x10
80105559:	ff 75 c4             	push   -0x3c(%ebp)
8010555c:	57                   	push   %edi
8010555d:	56                   	push   %esi
8010555e:	e8 8d c6 ff ff       	call   80101bf0 <writei>
80105563:	83 c4 20             	add    $0x20,%esp
80105566:	83 f8 10             	cmp    $0x10,%eax
80105569:	0f 85 e7 00 00 00    	jne    80105656 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010556f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105574:	0f 84 96 00 00 00    	je     80105610 <sys_unlink+0x180>
  iunlockput(dp);
8010557a:	83 ec 0c             	sub    $0xc,%esp
8010557d:	56                   	push   %esi
8010557e:	e8 fd c4 ff ff       	call   80101a80 <iunlockput>
  ip->nlink--;
80105583:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105588:	89 1c 24             	mov    %ebx,(%esp)
8010558b:	e8 90 c1 ff ff       	call   80101720 <iupdate>
  iunlockput(ip);
80105590:	89 1c 24             	mov    %ebx,(%esp)
80105593:	e8 e8 c4 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105598:	e8 93 d8 ff ff       	call   80102e30 <end_op>
  return 0;
8010559d:	83 c4 10             	add    $0x10,%esp
801055a0:	31 c0                	xor    %eax,%eax
}
801055a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055a5:	5b                   	pop    %ebx
801055a6:	5e                   	pop    %esi
801055a7:	5f                   	pop    %edi
801055a8:	5d                   	pop    %ebp
801055a9:	c3                   	ret
801055aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801055b4:	76 94                	jbe    8010554a <sys_unlink+0xba>
801055b6:	ba 20 00 00 00       	mov    $0x20,%edx
801055bb:	eb 0b                	jmp    801055c8 <sys_unlink+0x138>
801055bd:	8d 76 00             	lea    0x0(%esi),%esi
801055c0:	83 c2 10             	add    $0x10,%edx
801055c3:	39 53 58             	cmp    %edx,0x58(%ebx)
801055c6:	76 82                	jbe    8010554a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055c8:	6a 10                	push   $0x10
801055ca:	52                   	push   %edx
801055cb:	57                   	push   %edi
801055cc:	53                   	push   %ebx
801055cd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801055d0:	e8 1b c5 ff ff       	call   80101af0 <readi>
801055d5:	83 c4 10             	add    $0x10,%esp
801055d8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801055db:	83 f8 10             	cmp    $0x10,%eax
801055de:	75 69                	jne    80105649 <sys_unlink+0x1b9>
    if(de.inum != 0)
801055e0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801055e5:	74 d9                	je     801055c0 <sys_unlink+0x130>
    iunlockput(ip);
801055e7:	83 ec 0c             	sub    $0xc,%esp
801055ea:	53                   	push   %ebx
801055eb:	e8 90 c4 ff ff       	call   80101a80 <iunlockput>
    goto bad;
801055f0:	83 c4 10             	add    $0x10,%esp
801055f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801055f8:	83 ec 0c             	sub    $0xc,%esp
801055fb:	56                   	push   %esi
801055fc:	e8 7f c4 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105601:	e8 2a d8 ff ff       	call   80102e30 <end_op>
  return -1;
80105606:	83 c4 10             	add    $0x10,%esp
80105609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010560e:	eb 92                	jmp    801055a2 <sys_unlink+0x112>
    iupdate(dp);
80105610:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105613:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105618:	56                   	push   %esi
80105619:	e8 02 c1 ff ff       	call   80101720 <iupdate>
8010561e:	83 c4 10             	add    $0x10,%esp
80105621:	e9 54 ff ff ff       	jmp    8010557a <sys_unlink+0xea>
80105626:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010562d:	00 
8010562e:	66 90                	xchg   %ax,%ax
    return -1;
80105630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105635:	e9 68 ff ff ff       	jmp    801055a2 <sys_unlink+0x112>
    end_op();
8010563a:	e8 f1 d7 ff ff       	call   80102e30 <end_op>
    return -1;
8010563f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105644:	e9 59 ff ff ff       	jmp    801055a2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105649:	83 ec 0c             	sub    $0xc,%esp
8010564c:	68 4a 7c 10 80       	push   $0x80107c4a
80105651:	e8 3a ad ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105656:	83 ec 0c             	sub    $0xc,%esp
80105659:	68 5c 7c 10 80       	push   $0x80107c5c
8010565e:	e8 2d ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105663:	83 ec 0c             	sub    $0xc,%esp
80105666:	68 38 7c 10 80       	push   $0x80107c38
8010566b:	e8 20 ad ff ff       	call   80100390 <panic>

80105670 <sys_open>:

int
sys_open(void)
{
80105670:	f3 0f 1e fb          	endbr32
80105674:	55                   	push   %ebp
80105675:	89 e5                	mov    %esp,%ebp
80105677:	57                   	push   %edi
80105678:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105679:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010567c:	53                   	push   %ebx
8010567d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105680:	50                   	push   %eax
80105681:	6a 00                	push   $0x0
80105683:	e8 58 f6 ff ff       	call   80104ce0 <argstr>
80105688:	83 c4 10             	add    $0x10,%esp
8010568b:	85 c0                	test   %eax,%eax
8010568d:	0f 88 8a 00 00 00    	js     8010571d <sys_open+0xad>
80105693:	83 ec 08             	sub    $0x8,%esp
80105696:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105699:	50                   	push   %eax
8010569a:	6a 01                	push   $0x1
8010569c:	e8 8f f5 ff ff       	call   80104c30 <argint>
801056a1:	83 c4 10             	add    $0x10,%esp
801056a4:	85 c0                	test   %eax,%eax
801056a6:	78 75                	js     8010571d <sys_open+0xad>
    return -1;

  begin_op();
801056a8:	e8 13 d7 ff ff       	call   80102dc0 <begin_op>

  if(omode & O_CREATE){
801056ad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801056b1:	75 75                	jne    80105728 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801056b3:	83 ec 0c             	sub    $0xc,%esp
801056b6:	ff 75 e0             	push   -0x20(%ebp)
801056b9:	e8 02 ca ff ff       	call   801020c0 <namei>
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	89 c6                	mov    %eax,%esi
801056c3:	85 c0                	test   %eax,%eax
801056c5:	74 7e                	je     80105745 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801056c7:	83 ec 0c             	sub    $0xc,%esp
801056ca:	50                   	push   %eax
801056cb:	e8 10 c1 ff ff       	call   801017e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801056d0:	83 c4 10             	add    $0x10,%esp
801056d3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801056d8:	0f 84 c2 00 00 00    	je     801057a0 <sys_open+0x130>
    //     end_op();
    //     return -1;
    // }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801056de:	e8 7d b7 ff ff       	call   80100e60 <filealloc>
801056e3:	89 c7                	mov    %eax,%edi
801056e5:	85 c0                	test   %eax,%eax
801056e7:	74 23                	je     8010570c <sys_open+0x9c>
  struct proc *curproc = myproc();
801056e9:	e8 42 e3 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056ee:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801056f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801056f4:	85 d2                	test   %edx,%edx
801056f6:	74 60                	je     80105758 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801056f8:	83 c3 01             	add    $0x1,%ebx
801056fb:	83 fb 10             	cmp    $0x10,%ebx
801056fe:	75 f0                	jne    801056f0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	57                   	push   %edi
80105704:	e8 17 b8 ff ff       	call   80100f20 <fileclose>
80105709:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010570c:	83 ec 0c             	sub    $0xc,%esp
8010570f:	56                   	push   %esi
80105710:	e8 6b c3 ff ff       	call   80101a80 <iunlockput>
    end_op();
80105715:	e8 16 d7 ff ff       	call   80102e30 <end_op>
    return -1;
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105722:	eb 6d                	jmp    80105791 <sys_open+0x121>
80105724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105728:	83 ec 0c             	sub    $0xc,%esp
8010572b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010572e:	31 c9                	xor    %ecx,%ecx
80105730:	ba 02 00 00 00       	mov    $0x2,%edx
80105735:	6a 00                	push   $0x0
80105737:	e8 64 f7 ff ff       	call   80104ea0 <create>
    if(ip == 0){
8010573c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010573f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105741:	85 c0                	test   %eax,%eax
80105743:	75 99                	jne    801056de <sys_open+0x6e>
      end_op();
80105745:	e8 e6 d6 ff ff       	call   80102e30 <end_op>
      return -1;
8010574a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010574f:	eb 40                	jmp    80105791 <sys_open+0x121>
80105751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105758:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010575b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010575f:	56                   	push   %esi
80105760:	e8 5b c1 ff ff       	call   801018c0 <iunlock>
  end_op();
80105765:	e8 c6 d6 ff ff       	call   80102e30 <end_op>

  f->type = FD_INODE;
8010576a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105770:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105773:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105776:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105779:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010577b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105782:	f7 d0                	not    %eax
80105784:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105787:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010578a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010578d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105794:	89 d8                	mov    %ebx,%eax
80105796:	5b                   	pop    %ebx
80105797:	5e                   	pop    %esi
80105798:	5f                   	pop    %edi
80105799:	5d                   	pop    %ebp
8010579a:	c3                   	ret
8010579b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801057a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801057a3:	85 c9                	test   %ecx,%ecx
801057a5:	0f 84 33 ff ff ff    	je     801056de <sys_open+0x6e>
801057ab:	e9 5c ff ff ff       	jmp    8010570c <sys_open+0x9c>

801057b0 <sys_mkdir>:

int
sys_mkdir(void)
{
801057b0:	f3 0f 1e fb          	endbr32
801057b4:	55                   	push   %ebp
801057b5:	89 e5                	mov    %esp,%ebp
801057b7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801057ba:	e8 01 d6 ff ff       	call   80102dc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801057bf:	83 ec 08             	sub    $0x8,%esp
801057c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057c5:	50                   	push   %eax
801057c6:	6a 00                	push   $0x0
801057c8:	e8 13 f5 ff ff       	call   80104ce0 <argstr>
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	85 c0                	test   %eax,%eax
801057d2:	78 34                	js     80105808 <sys_mkdir+0x58>
801057d4:	83 ec 0c             	sub    $0xc,%esp
801057d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057da:	31 c9                	xor    %ecx,%ecx
801057dc:	ba 01 00 00 00       	mov    $0x1,%edx
801057e1:	6a 00                	push   $0x0
801057e3:	e8 b8 f6 ff ff       	call   80104ea0 <create>
801057e8:	83 c4 10             	add    $0x10,%esp
801057eb:	85 c0                	test   %eax,%eax
801057ed:	74 19                	je     80105808 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057ef:	83 ec 0c             	sub    $0xc,%esp
801057f2:	50                   	push   %eax
801057f3:	e8 88 c2 ff ff       	call   80101a80 <iunlockput>
  end_op();
801057f8:	e8 33 d6 ff ff       	call   80102e30 <end_op>
  return 0;
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	31 c0                	xor    %eax,%eax
}
80105802:	c9                   	leave
80105803:	c3                   	ret
80105804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105808:	e8 23 d6 ff ff       	call   80102e30 <end_op>
    return -1;
8010580d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105812:	c9                   	leave
80105813:	c3                   	ret
80105814:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010581b:	00 
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105820 <sys_mknod>:

int
sys_mknod(void)
{
80105820:	f3 0f 1e fb          	endbr32
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010582a:	e8 91 d5 ff ff       	call   80102dc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010582f:	83 ec 08             	sub    $0x8,%esp
80105832:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105835:	50                   	push   %eax
80105836:	6a 00                	push   $0x0
80105838:	e8 a3 f4 ff ff       	call   80104ce0 <argstr>
8010583d:	83 c4 10             	add    $0x10,%esp
80105840:	85 c0                	test   %eax,%eax
80105842:	78 64                	js     801058a8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105844:	83 ec 08             	sub    $0x8,%esp
80105847:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010584a:	50                   	push   %eax
8010584b:	6a 01                	push   $0x1
8010584d:	e8 de f3 ff ff       	call   80104c30 <argint>
  if((argstr(0, &path)) < 0 ||
80105852:	83 c4 10             	add    $0x10,%esp
80105855:	85 c0                	test   %eax,%eax
80105857:	78 4f                	js     801058a8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105859:	83 ec 08             	sub    $0x8,%esp
8010585c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010585f:	50                   	push   %eax
80105860:	6a 02                	push   $0x2
80105862:	e8 c9 f3 ff ff       	call   80104c30 <argint>
     argint(1, &major) < 0 ||
80105867:	83 c4 10             	add    $0x10,%esp
8010586a:	85 c0                	test   %eax,%eax
8010586c:	78 3a                	js     801058a8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010586e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105872:	83 ec 0c             	sub    $0xc,%esp
80105875:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105879:	ba 03 00 00 00       	mov    $0x3,%edx
8010587e:	50                   	push   %eax
8010587f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105882:	e8 19 f6 ff ff       	call   80104ea0 <create>
     argint(2, &minor) < 0 ||
80105887:	83 c4 10             	add    $0x10,%esp
8010588a:	85 c0                	test   %eax,%eax
8010588c:	74 1a                	je     801058a8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010588e:	83 ec 0c             	sub    $0xc,%esp
80105891:	50                   	push   %eax
80105892:	e8 e9 c1 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105897:	e8 94 d5 ff ff       	call   80102e30 <end_op>
  return 0;
8010589c:	83 c4 10             	add    $0x10,%esp
8010589f:	31 c0                	xor    %eax,%eax
}
801058a1:	c9                   	leave
801058a2:	c3                   	ret
801058a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    end_op();
801058a8:	e8 83 d5 ff ff       	call   80102e30 <end_op>
    return -1;
801058ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b2:	c9                   	leave
801058b3:	c3                   	ret
801058b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058bb:	00 
801058bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_chdir>:

int
sys_chdir(void)
{
801058c0:	f3 0f 1e fb          	endbr32
801058c4:	55                   	push   %ebp
801058c5:	89 e5                	mov    %esp,%ebp
801058c7:	56                   	push   %esi
801058c8:	53                   	push   %ebx
801058c9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801058cc:	e8 5f e1 ff ff       	call   80103a30 <myproc>
801058d1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801058d3:	e8 e8 d4 ff ff       	call   80102dc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801058d8:	83 ec 08             	sub    $0x8,%esp
801058db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058de:	50                   	push   %eax
801058df:	6a 00                	push   $0x0
801058e1:	e8 fa f3 ff ff       	call   80104ce0 <argstr>
801058e6:	83 c4 10             	add    $0x10,%esp
801058e9:	85 c0                	test   %eax,%eax
801058eb:	78 73                	js     80105960 <sys_chdir+0xa0>
801058ed:	83 ec 0c             	sub    $0xc,%esp
801058f0:	ff 75 f4             	push   -0xc(%ebp)
801058f3:	e8 c8 c7 ff ff       	call   801020c0 <namei>
801058f8:	83 c4 10             	add    $0x10,%esp
801058fb:	89 c3                	mov    %eax,%ebx
801058fd:	85 c0                	test   %eax,%eax
801058ff:	74 5f                	je     80105960 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105901:	83 ec 0c             	sub    $0xc,%esp
80105904:	50                   	push   %eax
80105905:	e8 d6 be ff ff       	call   801017e0 <ilock>
  if(ip->type != T_DIR){
8010590a:	83 c4 10             	add    $0x10,%esp
8010590d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105912:	75 2c                	jne    80105940 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105914:	83 ec 0c             	sub    $0xc,%esp
80105917:	53                   	push   %ebx
80105918:	e8 a3 bf ff ff       	call   801018c0 <iunlock>
  iput(curproc->cwd);
8010591d:	58                   	pop    %eax
8010591e:	ff 76 68             	push   0x68(%esi)
80105921:	e8 ea bf ff ff       	call   80101910 <iput>
  end_op();
80105926:	e8 05 d5 ff ff       	call   80102e30 <end_op>
  curproc->cwd = ip;
8010592b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	31 c0                	xor    %eax,%eax
}
80105933:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105936:	5b                   	pop    %ebx
80105937:	5e                   	pop    %esi
80105938:	5d                   	pop    %ebp
80105939:	c3                   	ret
8010593a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105940:	83 ec 0c             	sub    $0xc,%esp
80105943:	53                   	push   %ebx
80105944:	e8 37 c1 ff ff       	call   80101a80 <iunlockput>
    end_op();
80105949:	e8 e2 d4 ff ff       	call   80102e30 <end_op>
    return -1;
8010594e:	83 c4 10             	add    $0x10,%esp
80105951:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105956:	eb db                	jmp    80105933 <sys_chdir+0x73>
80105958:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010595f:	00 
    end_op();
80105960:	e8 cb d4 ff ff       	call   80102e30 <end_op>
    return -1;
80105965:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596a:	eb c7                	jmp    80105933 <sys_chdir+0x73>
8010596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105970 <sys_exec>:

int
sys_exec(void)
{
80105970:	f3 0f 1e fb          	endbr32
80105974:	55                   	push   %ebp
80105975:	89 e5                	mov    %esp,%ebp
80105977:	57                   	push   %edi
80105978:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;
  struct inode* ip;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105979:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010597f:	53                   	push   %ebx
80105980:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105986:	50                   	push   %eax
80105987:	6a 00                	push   $0x0
80105989:	e8 52 f3 ff ff       	call   80104ce0 <argstr>
8010598e:	83 c4 10             	add    $0x10,%esp
80105991:	85 c0                	test   %eax,%eax
80105993:	0f 88 db 00 00 00    	js     80105a74 <sys_exec+0x104>
80105999:	83 ec 08             	sub    $0x8,%esp
8010599c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801059a2:	50                   	push   %eax
801059a3:	6a 01                	push   $0x1
801059a5:	e8 86 f2 ff ff       	call   80104c30 <argint>
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	85 c0                	test   %eax,%eax
801059af:	0f 88 bf 00 00 00    	js     80105a74 <sys_exec+0x104>
    return -1;
  }
  begin_op();
801059b5:	e8 06 d4 ff ff       	call   80102dc0 <begin_op>

  if((ip = namei(path)) == 0){
801059ba:	83 ec 0c             	sub    $0xc,%esp
801059bd:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801059c3:	e8 f8 c6 ff ff       	call   801020c0 <namei>
801059c8:	83 c4 10             	add    $0x10,%esp
801059cb:	89 c3                	mov    %eax,%ebx
801059cd:	85 c0                	test   %eax,%eax
801059cf:	0f 84 0a 01 00 00    	je     80105adf <sys_exec+0x16f>
    end_op();
    return -1;
  }
  ilock(ip);
801059d5:	83 ec 0c             	sub    $0xc,%esp
801059d8:	50                   	push   %eax
801059d9:	e8 02 be ff ff       	call   801017e0 <ilock>
  if (!(ip->mode & 0x4)) {
801059de:	83 c4 10             	add    $0x10,%esp
801059e1:	f6 83 90 00 00 00 04 	testb  $0x4,0x90(%ebx)
801059e8:	0f 84 c5 00 00 00    	je     80105ab3 <sys_exec+0x143>
      iunlock(ip);
      iput(ip);
      end_op();
      return -1;
  }
  iunlock(ip);
801059ee:	83 ec 0c             	sub    $0xc,%esp
801059f1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801059f7:	53                   	push   %ebx
801059f8:	e8 c3 be ff ff       	call   801018c0 <iunlock>
  iput(ip);
801059fd:	89 1c 24             	mov    %ebx,(%esp)
  end_op();
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105a00:	31 db                	xor    %ebx,%ebx
  iput(ip);
80105a02:	e8 09 bf ff ff       	call   80101910 <iput>
  end_op();
80105a07:	e8 24 d4 ff ff       	call   80102e30 <end_op>
  memset(argv, 0, sizeof(argv));
80105a0c:	83 c4 0c             	add    $0xc,%esp
80105a0f:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a15:	68 80 00 00 00       	push   $0x80
80105a1a:	6a 00                	push   $0x0
80105a1c:	50                   	push   %eax
80105a1d:	e8 2e ef ff ff       	call   80104950 <memset>
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	8d 76 00             	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a28:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a2e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105a35:	83 ec 08             	sub    $0x8,%esp
80105a38:	57                   	push   %edi
80105a39:	01 f0                	add    %esi,%eax
80105a3b:	50                   	push   %eax
80105a3c:	e8 4f f1 ff ff       	call   80104b90 <fetchint>
80105a41:	83 c4 10             	add    $0x10,%esp
80105a44:	85 c0                	test   %eax,%eax
80105a46:	78 2c                	js     80105a74 <sys_exec+0x104>
      return -1;
    if(uarg == 0){
80105a48:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a4e:	85 c0                	test   %eax,%eax
80105a50:	74 36                	je     80105a88 <sys_exec+0x118>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a52:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105a58:	83 ec 08             	sub    $0x8,%esp
80105a5b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105a5e:	52                   	push   %edx
80105a5f:	50                   	push   %eax
80105a60:	e8 6b f1 ff ff       	call   80104bd0 <fetchstr>
80105a65:	83 c4 10             	add    $0x10,%esp
80105a68:	85 c0                	test   %eax,%eax
80105a6a:	78 08                	js     80105a74 <sys_exec+0x104>
  for(i=0;; i++){
80105a6c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105a6f:	83 fb 20             	cmp    $0x20,%ebx
80105a72:	75 b4                	jne    80105a28 <sys_exec+0xb8>
    return -1;
80105a74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }

  return exec(path, argv);
}
80105a79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a7c:	5b                   	pop    %ebx
80105a7d:	5e                   	pop    %esi
80105a7e:	5f                   	pop    %edi
80105a7f:	5d                   	pop    %ebp
80105a80:	c3                   	ret
80105a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105a88:	83 ec 08             	sub    $0x8,%esp
80105a8b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105a91:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a98:	00 00 00 00 
  return exec(path, argv);
80105a9c:	50                   	push   %eax
80105a9d:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105aa3:	e8 d8 af ff ff       	call   80100a80 <exec>
80105aa8:	83 c4 10             	add    $0x10,%esp
}
80105aab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aae:	5b                   	pop    %ebx
80105aaf:	5e                   	pop    %esi
80105ab0:	5f                   	pop    %edi
80105ab1:	5d                   	pop    %ebp
80105ab2:	c3                   	ret
      cprintf("Oper exec fail\n");
80105ab3:	83 ec 0c             	sub    $0xc,%esp
80105ab6:	68 6b 7c 10 80       	push   $0x80107c6b
80105abb:	e8 f0 ab ff ff       	call   801006b0 <cprintf>
      iunlock(ip);
80105ac0:	89 1c 24             	mov    %ebx,(%esp)
80105ac3:	e8 f8 bd ff ff       	call   801018c0 <iunlock>
      iput(ip);
80105ac8:	89 1c 24             	mov    %ebx,(%esp)
80105acb:	e8 40 be ff ff       	call   80101910 <iput>
      end_op();
80105ad0:	e8 5b d3 ff ff       	call   80102e30 <end_op>
      return -1;
80105ad5:	83 c4 10             	add    $0x10,%esp
80105ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105add:	eb 9a                	jmp    80105a79 <sys_exec+0x109>
    end_op();
80105adf:	e8 4c d3 ff ff       	call   80102e30 <end_op>
    return -1;
80105ae4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae9:	eb 8e                	jmp    80105a79 <sys_exec+0x109>
80105aeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105af0 <sys_pipe>:

int
sys_pipe(void)
{
80105af0:	f3 0f 1e fb          	endbr32
80105af4:	55                   	push   %ebp
80105af5:	89 e5                	mov    %esp,%ebp
80105af7:	57                   	push   %edi
80105af8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105af9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105afc:	53                   	push   %ebx
80105afd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b00:	6a 08                	push   $0x8
80105b02:	50                   	push   %eax
80105b03:	6a 00                	push   $0x0
80105b05:	e8 76 f1 ff ff       	call   80104c80 <argptr>
80105b0a:	83 c4 10             	add    $0x10,%esp
80105b0d:	85 c0                	test   %eax,%eax
80105b0f:	78 4e                	js     80105b5f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b11:	83 ec 08             	sub    $0x8,%esp
80105b14:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b17:	50                   	push   %eax
80105b18:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b1b:	50                   	push   %eax
80105b1c:	e8 5f d9 ff ff       	call   80103480 <pipealloc>
80105b21:	83 c4 10             	add    $0x10,%esp
80105b24:	85 c0                	test   %eax,%eax
80105b26:	78 37                	js     80105b5f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b28:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b2b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b2d:	e8 fe de ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105b38:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b3c:	85 f6                	test   %esi,%esi
80105b3e:	74 30                	je     80105b70 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105b40:	83 c3 01             	add    $0x1,%ebx
80105b43:	83 fb 10             	cmp    $0x10,%ebx
80105b46:	75 f0                	jne    80105b38 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105b48:	83 ec 0c             	sub    $0xc,%esp
80105b4b:	ff 75 e0             	push   -0x20(%ebp)
80105b4e:	e8 cd b3 ff ff       	call   80100f20 <fileclose>
    fileclose(wf);
80105b53:	58                   	pop    %eax
80105b54:	ff 75 e4             	push   -0x1c(%ebp)
80105b57:	e8 c4 b3 ff ff       	call   80100f20 <fileclose>
    return -1;
80105b5c:	83 c4 10             	add    $0x10,%esp
80105b5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b64:	eb 5b                	jmp    80105bc1 <sys_pipe+0xd1>
80105b66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b6d:	00 
80105b6e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105b70:	8d 73 08             	lea    0x8(%ebx),%esi
80105b73:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105b7a:	e8 b1 de ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b7f:	31 d2                	xor    %edx,%edx
80105b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105b88:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b8c:	85 c9                	test   %ecx,%ecx
80105b8e:	74 20                	je     80105bb0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105b90:	83 c2 01             	add    $0x1,%edx
80105b93:	83 fa 10             	cmp    $0x10,%edx
80105b96:	75 f0                	jne    80105b88 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105b98:	e8 93 de ff ff       	call   80103a30 <myproc>
80105b9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ba4:	00 
80105ba5:	eb a1                	jmp    80105b48 <sys_pipe+0x58>
80105ba7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bae:	00 
80105baf:	90                   	nop
      curproc->ofile[fd] = f;
80105bb0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105bb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bb7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105bb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bbc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105bbf:	31 c0                	xor    %eax,%eax
}
80105bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bc4:	5b                   	pop    %ebx
80105bc5:	5e                   	pop    %esi
80105bc6:	5f                   	pop    %edi
80105bc7:	5d                   	pop    %ebp
80105bc8:	c3                   	ret
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_chmod>:

int sys_chmod(void) {
80105bd0:	f3 0f 1e fb          	endbr32
80105bd4:	55                   	push   %ebp
80105bd5:	89 e5                	mov    %esp,%ebp
80105bd7:	53                   	push   %ebx
    char *path;
    int mode;
    struct inode *ip;

    if (argstr(0, &path) < 0 || argint(1, &mode) < 0)
80105bd8:	8d 45 f0             	lea    -0x10(%ebp),%eax
int sys_chmod(void) {
80105bdb:	83 ec 1c             	sub    $0x1c,%esp
    if (argstr(0, &path) < 0 || argint(1, &mode) < 0)
80105bde:	50                   	push   %eax
80105bdf:	6a 00                	push   $0x0
80105be1:	e8 fa f0 ff ff       	call   80104ce0 <argstr>
80105be6:	83 c4 10             	add    $0x10,%esp
80105be9:	85 c0                	test   %eax,%eax
80105beb:	78 73                	js     80105c60 <sys_chmod+0x90>
80105bed:	83 ec 08             	sub    $0x8,%esp
80105bf0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bf3:	50                   	push   %eax
80105bf4:	6a 01                	push   $0x1
80105bf6:	e8 35 f0 ff ff       	call   80104c30 <argint>
80105bfb:	83 c4 10             	add    $0x10,%esp
80105bfe:	85 c0                	test   %eax,%eax
80105c00:	78 5e                	js     80105c60 <sys_chmod+0x90>
        return -1;

    begin_op();
80105c02:	e8 b9 d1 ff ff       	call   80102dc0 <begin_op>
    if ((ip = namei(path)) == 0) {
80105c07:	83 ec 0c             	sub    $0xc,%esp
80105c0a:	ff 75 f0             	push   -0x10(%ebp)
80105c0d:	e8 ae c4 ff ff       	call   801020c0 <namei>
80105c12:	83 c4 10             	add    $0x10,%esp
80105c15:	89 c3                	mov    %eax,%ebx
80105c17:	85 c0                	test   %eax,%eax
80105c19:	74 3f                	je     80105c5a <sys_chmod+0x8a>
        end_op();
        return -1;
    }

    ilock(ip);
80105c1b:	83 ec 0c             	sub    $0xc,%esp
80105c1e:	50                   	push   %eax
80105c1f:	e8 bc bb ff ff       	call   801017e0 <ilock>
    ip->mode = (ip->mode & ~0x7) | (mode & 0x7);
80105c24:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80105c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c2d:	83 e0 f8             	and    $0xfffffff8,%eax
80105c30:	83 e2 07             	and    $0x7,%edx
80105c33:	09 d0                	or     %edx,%eax
80105c35:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
    iupdate(ip);
80105c3b:	89 1c 24             	mov    %ebx,(%esp)
80105c3e:	e8 dd ba ff ff       	call   80101720 <iupdate>
    iunlockput(ip);
80105c43:	89 1c 24             	mov    %ebx,(%esp)
80105c46:	e8 35 be ff ff       	call   80101a80 <iunlockput>
    end_op();
80105c4b:	e8 e0 d1 ff ff       	call   80102e30 <end_op>
    
    return 0;
80105c50:	83 c4 10             	add    $0x10,%esp
80105c53:	31 c0                	xor    %eax,%eax
}
80105c55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c58:	c9                   	leave
80105c59:	c3                   	ret
        end_op();
80105c5a:	e8 d1 d1 ff ff       	call   80102e30 <end_op>
80105c5f:	90                   	nop
        return -1;
80105c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c65:	eb ee                	jmp    80105c55 <sys_chmod+0x85>
80105c67:	66 90                	xchg   %ax,%ax
80105c69:	66 90                	xchg   %ax,%ax
80105c6b:	66 90                	xchg   %ax,%ax
80105c6d:	66 90                	xchg   %ax,%ax
80105c6f:	90                   	nop

80105c70 <sys_gethistory>:
#include "proc.h"

int gethistory();

int sys_gethistory(void)
{
80105c70:	f3 0f 1e fb          	endbr32
  return gethistory(); // Call the helper function in `proc.c`
80105c74:	e9 77 de ff ff       	jmp    80103af0 <gethistory>
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_block>:
}

int sys_block(int syscall_id)
{
80105c80:	f3 0f 1e fb          	endbr32
80105c84:	55                   	push   %ebp
80105c85:	89 e5                	mov    %esp,%ebp
80105c87:	53                   	push   %ebx
80105c88:	83 ec 14             	sub    $0x14,%esp
  struct proc *p = myproc(); // Get current process
80105c8b:	e8 a0 dd ff ff       	call   80103a30 <myproc>

  int num;
  if (argint(0, &num) < 0) // Get argument from user space
80105c90:	83 ec 08             	sub    $0x8,%esp
  struct proc *p = myproc(); // Get current process
80105c93:	89 c3                	mov    %eax,%ebx
  if (argint(0, &num) < 0) // Get argument from user space
80105c95:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c98:	50                   	push   %eax
80105c99:	6a 00                	push   $0x0
80105c9b:	e8 90 ef ff ff       	call   80104c30 <argint>
80105ca0:	83 c4 10             	add    $0x10,%esp
80105ca3:	85 c0                	test   %eax,%eax
80105ca5:	78 15                	js     80105cbc <sys_block+0x3c>
    return -1;

  p->syscall_bitmask[num]=1;
80105ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105caa:	c7 84 83 80 00 00 00 	movl   $0x1,0x80(%ebx,%eax,4)
80105cb1:	01 00 00 00 
  return 0;
80105cb5:	31 c0                	xor    %eax,%eax
}
80105cb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cba:	c9                   	leave
80105cbb:	c3                   	ret
    return -1;
80105cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc1:	eb f4                	jmp    80105cb7 <sys_block+0x37>
80105cc3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cca:	00 
80105ccb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105cd0 <sys_unblock>:

int sys_unblock(int syscall_id)
{
80105cd0:	f3 0f 1e fb          	endbr32
80105cd4:	55                   	push   %ebp
80105cd5:	89 e5                	mov    %esp,%ebp
80105cd7:	53                   	push   %ebx
80105cd8:	83 ec 14             	sub    $0x14,%esp
  struct proc *p = myproc(); // Get current process
80105cdb:	e8 50 dd ff ff       	call   80103a30 <myproc>

  int num;
  if (argint(0, &num) < 0) // Get argument from user space
80105ce0:	83 ec 08             	sub    $0x8,%esp
  struct proc *p = myproc(); // Get current process
80105ce3:	89 c3                	mov    %eax,%ebx
  if (argint(0, &num) < 0) // Get argument from user space
80105ce5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ce8:	50                   	push   %eax
80105ce9:	6a 00                	push   $0x0
80105ceb:	e8 40 ef ff ff       	call   80104c30 <argint>
80105cf0:	83 c4 10             	add    $0x10,%esp
80105cf3:	85 c0                	test   %eax,%eax
80105cf5:	78 15                	js     80105d0c <sys_unblock+0x3c>
    return -1;

    p->syscall_bitmask[num]=0;
80105cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfa:	c7 84 83 80 00 00 00 	movl   $0x0,0x80(%ebx,%eax,4)
80105d01:	00 00 00 00 
  return 0;
80105d05:	31 c0                	xor    %eax,%eax
}
80105d07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d0a:	c9                   	leave
80105d0b:	c3                   	ret
    return -1;
80105d0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d11:	eb f4                	jmp    80105d07 <sys_unblock+0x37>
80105d13:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d1a:	00 
80105d1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105d20 <sys_realsh>:

int sys_realsh(void)
{
80105d20:	f3 0f 1e fb          	endbr32
80105d24:	55                   	push   %ebp
80105d25:	89 e5                	mov    %esp,%ebp
80105d27:	53                   	push   %ebx
80105d28:	83 ec 14             	sub    $0x14,%esp
  struct proc *p = myproc(); // Get current process
80105d2b:	e8 00 dd ff ff       	call   80103a30 <myproc>

  int new_value;
  if (argint(0, &new_value) < 0) // Get argument from user space
80105d30:	83 ec 08             	sub    $0x8,%esp
  struct proc *p = myproc(); // Get current process
80105d33:	89 c3                	mov    %eax,%ebx
  if (argint(0, &new_value) < 0) // Get argument from user space
80105d35:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d38:	50                   	push   %eax
80105d39:	6a 00                	push   $0x0
80105d3b:	e8 f0 ee ff ff       	call   80104c30 <argint>
80105d40:	83 c4 10             	add    $0x10,%esp
80105d43:	85 c0                	test   %eax,%eax
80105d45:	78 10                	js     80105d57 <sys_realsh+0x37>
    return -1;

  p->real_sh = new_value; // Modify process attribute
80105d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d4a:	89 83 ec 00 00 00    	mov    %eax,0xec(%ebx)
  return 0;
80105d50:	31 c0                	xor    %eax,%eax
}
80105d52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d55:	c9                   	leave
80105d56:	c3                   	ret
    return -1;
80105d57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d5c:	eb f4                	jmp    80105d52 <sys_realsh+0x32>
80105d5e:	66 90                	xchg   %ax,%ax

80105d60 <sys_allzeroes>:

int sys_allzeroes(void)
{
80105d60:	f3 0f 1e fb          	endbr32
80105d64:	55                   	push   %ebp
80105d65:	89 e5                	mov    %esp,%ebp
80105d67:	83 ec 08             	sub    $0x8,%esp
  struct proc *p = myproc(); // Get current process
80105d6a:	e8 c1 dc ff ff       	call   80103a30 <myproc>
  for(int i=0;i<22;i++)
80105d6f:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80105d75:	05 d8 00 00 00       	add    $0xd8,%eax
80105d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  {
    p->syscall_bitmask[i]=0; // Modify process attribute
80105d80:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(int i=0;i<22;i++)
80105d86:	83 c2 04             	add    $0x4,%edx
80105d89:	39 c2                	cmp    %eax,%edx
80105d8b:	75 f3                	jne    80105d80 <sys_allzeroes+0x20>
  }
  return 0;
}
80105d8d:	c9                   	leave
80105d8e:	31 c0                	xor    %eax,%eax
80105d90:	c3                   	ret
80105d91:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d98:	00 
80105d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_fork>:


int sys_fork(void)
{
80105da0:	f3 0f 1e fb          	endbr32
  return fork();
80105da4:	e9 b7 df ff ff       	jmp    80103d60 <fork>
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105db0 <sys_exit>:
}

int sys_exit(void)
{
80105db0:	f3 0f 1e fb          	endbr32
80105db4:	55                   	push   %ebp
80105db5:	89 e5                	mov    %esp,%ebp
80105db7:	83 ec 08             	sub    $0x8,%esp
  exit();
80105dba:	e8 61 e2 ff ff       	call   80104020 <exit>
  return 0; // not reached
}
80105dbf:	31 c0                	xor    %eax,%eax
80105dc1:	c9                   	leave
80105dc2:	c3                   	ret
80105dc3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dca:	00 
80105dcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105dd0 <sys_wait>:

int sys_wait(void)
{
80105dd0:	f3 0f 1e fb          	endbr32
  return wait();
80105dd4:	e9 c7 e4 ff ff       	jmp    801042a0 <wait>
80105dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105de0 <sys_kill>:
}

int sys_kill(void)
{
80105de0:	f3 0f 1e fb          	endbr32
80105de4:	55                   	push   %ebp
80105de5:	89 e5                	mov    %esp,%ebp
80105de7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80105dea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ded:	50                   	push   %eax
80105dee:	6a 00                	push   $0x0
80105df0:	e8 3b ee ff ff       	call   80104c30 <argint>
80105df5:	83 c4 10             	add    $0x10,%esp
80105df8:	85 c0                	test   %eax,%eax
80105dfa:	78 14                	js     80105e10 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105dfc:	83 ec 0c             	sub    $0xc,%esp
80105dff:	ff 75 f4             	push   -0xc(%ebp)
80105e02:	e8 09 e6 ff ff       	call   80104410 <kill>
80105e07:	83 c4 10             	add    $0x10,%esp
}
80105e0a:	c9                   	leave
80105e0b:	c3                   	ret
80105e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e10:	c9                   	leave
    return -1;
80105e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e16:	c3                   	ret
80105e17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e1e:	00 
80105e1f:	90                   	nop

80105e20 <sys_getpid>:

int sys_getpid(void)
{
80105e20:	f3 0f 1e fb          	endbr32
80105e24:	55                   	push   %ebp
80105e25:	89 e5                	mov    %esp,%ebp
80105e27:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e2a:	e8 01 dc ff ff       	call   80103a30 <myproc>
80105e2f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105e32:	c9                   	leave
80105e33:	c3                   	ret
80105e34:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e3b:	00 
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e40 <sys_sbrk>:

int sys_sbrk(void)
{
80105e40:	f3 0f 1e fb          	endbr32
80105e44:	55                   	push   %ebp
80105e45:	89 e5                	mov    %esp,%ebp
80105e47:	53                   	push   %ebx
  int addr;
  int n;

  if (argint(0, &n) < 0)
80105e48:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e4b:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
80105e4e:	50                   	push   %eax
80105e4f:	6a 00                	push   $0x0
80105e51:	e8 da ed ff ff       	call   80104c30 <argint>
80105e56:	83 c4 10             	add    $0x10,%esp
80105e59:	85 c0                	test   %eax,%eax
80105e5b:	78 23                	js     80105e80 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105e5d:	e8 ce db ff ff       	call   80103a30 <myproc>
  if (growproc(n) < 0)
80105e62:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105e65:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80105e67:	ff 75 f4             	push   -0xc(%ebp)
80105e6a:	e8 71 de ff ff       	call   80103ce0 <growproc>
80105e6f:	83 c4 10             	add    $0x10,%esp
80105e72:	85 c0                	test   %eax,%eax
80105e74:	78 0a                	js     80105e80 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105e76:	89 d8                	mov    %ebx,%eax
80105e78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e7b:	c9                   	leave
80105e7c:	c3                   	ret
80105e7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e80:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e85:	eb ef                	jmp    80105e76 <sys_sbrk+0x36>
80105e87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e8e:	00 
80105e8f:	90                   	nop

80105e90 <sys_sleep>:

int sys_sleep(void)
{
80105e90:	f3 0f 1e fb          	endbr32
80105e94:	55                   	push   %ebp
80105e95:	89 e5                	mov    %esp,%ebp
80105e97:	53                   	push   %ebx
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80105e98:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e9b:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, &n) < 0)
80105e9e:	50                   	push   %eax
80105e9f:	6a 00                	push   $0x0
80105ea1:	e8 8a ed ff ff       	call   80104c30 <argint>
80105ea6:	83 c4 10             	add    $0x10,%esp
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	0f 88 86 00 00 00    	js     80105f37 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105eb1:	83 ec 0c             	sub    $0xc,%esp
80105eb4:	68 40 80 11 80       	push   $0x80118040
80105eb9:	e8 82 e9 ff ff       	call   80104840 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
80105ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105ec1:	8b 1d 80 88 11 80    	mov    0x80118880,%ebx
  while (ticks - ticks0 < n)
80105ec7:	83 c4 10             	add    $0x10,%esp
80105eca:	85 d2                	test   %edx,%edx
80105ecc:	75 23                	jne    80105ef1 <sys_sleep+0x61>
80105ece:	eb 50                	jmp    80105f20 <sys_sleep+0x90>
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ed0:	83 ec 08             	sub    $0x8,%esp
80105ed3:	68 40 80 11 80       	push   $0x80118040
80105ed8:	68 80 88 11 80       	push   $0x80118880
80105edd:	e8 fe e2 ff ff       	call   801041e0 <sleep>
  while (ticks - ticks0 < n)
80105ee2:	a1 80 88 11 80       	mov    0x80118880,%eax
80105ee7:	83 c4 10             	add    $0x10,%esp
80105eea:	29 d8                	sub    %ebx,%eax
80105eec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105eef:	73 2f                	jae    80105f20 <sys_sleep+0x90>
    if (myproc()->killed)
80105ef1:	e8 3a db ff ff       	call   80103a30 <myproc>
80105ef6:	8b 40 24             	mov    0x24(%eax),%eax
80105ef9:	85 c0                	test   %eax,%eax
80105efb:	74 d3                	je     80105ed0 <sys_sleep+0x40>
      release(&tickslock);
80105efd:	83 ec 0c             	sub    $0xc,%esp
80105f00:	68 40 80 11 80       	push   $0x80118040
80105f05:	e8 f6 e9 ff ff       	call   80104900 <release>
  }
  release(&tickslock);
  return 0;
}
80105f0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105f0d:	83 c4 10             	add    $0x10,%esp
80105f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f15:	c9                   	leave
80105f16:	c3                   	ret
80105f17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f1e:	00 
80105f1f:	90                   	nop
  release(&tickslock);
80105f20:	83 ec 0c             	sub    $0xc,%esp
80105f23:	68 40 80 11 80       	push   $0x80118040
80105f28:	e8 d3 e9 ff ff       	call   80104900 <release>
  return 0;
80105f2d:	83 c4 10             	add    $0x10,%esp
80105f30:	31 c0                	xor    %eax,%eax
}
80105f32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f35:	c9                   	leave
80105f36:	c3                   	ret
    return -1;
80105f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3c:	eb f4                	jmp    80105f32 <sys_sleep+0xa2>
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80105f40:	f3 0f 1e fb          	endbr32
80105f44:	55                   	push   %ebp
80105f45:	89 e5                	mov    %esp,%ebp
80105f47:	53                   	push   %ebx
80105f48:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105f4b:	68 40 80 11 80       	push   $0x80118040
80105f50:	e8 eb e8 ff ff       	call   80104840 <acquire>
  xticks = ticks;
80105f55:	8b 1d 80 88 11 80    	mov    0x80118880,%ebx
  release(&tickslock);
80105f5b:	c7 04 24 40 80 11 80 	movl   $0x80118040,(%esp)
80105f62:	e8 99 e9 ff ff       	call   80104900 <release>
  return xticks;
}
80105f67:	89 d8                	mov    %ebx,%eax
80105f69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f6c:	c9                   	leave
80105f6d:	c3                   	ret

80105f6e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f6e:	1e                   	push   %ds
  pushl %es
80105f6f:	06                   	push   %es
  pushl %fs
80105f70:	0f a0                	push   %fs
  pushl %gs
80105f72:	0f a8                	push   %gs
  pushal
80105f74:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f75:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f79:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f7b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f7d:	54                   	push   %esp
  call trap
80105f7e:	e8 cd 00 00 00       	call   80106050 <trap>
  addl $4, %esp
80105f83:	83 c4 04             	add    $0x4,%esp

80105f86 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105f86:	61                   	popa
  popl %gs
80105f87:	0f a9                	pop    %gs
  popl %fs
80105f89:	0f a1                	pop    %fs
  popl %es
80105f8b:	07                   	pop    %es
  popl %ds
80105f8c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f8d:	83 c4 08             	add    $0x8,%esp
  iret
80105f90:	cf                   	iret
80105f91:	66 90                	xchg   %ax,%ax
80105f93:	66 90                	xchg   %ax,%ax
80105f95:	66 90                	xchg   %ax,%ax
80105f97:	66 90                	xchg   %ax,%ax
80105f99:	66 90                	xchg   %ax,%ax
80105f9b:	66 90                	xchg   %ax,%ax
80105f9d:	66 90                	xchg   %ax,%ax
80105f9f:	90                   	nop

80105fa0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105fa0:	f3 0f 1e fb          	endbr32
80105fa4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105fa5:	31 c0                	xor    %eax,%eax
{
80105fa7:	89 e5                	mov    %esp,%ebp
80105fa9:	83 ec 08             	sub    $0x8,%esp
80105fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105fb0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105fb7:	c7 04 c5 82 80 11 80 	movl   $0x8e000008,-0x7fee7f7e(,%eax,8)
80105fbe:	08 00 00 8e 
80105fc2:	66 89 14 c5 80 80 11 	mov    %dx,-0x7fee7f80(,%eax,8)
80105fc9:	80 
80105fca:	c1 ea 10             	shr    $0x10,%edx
80105fcd:	66 89 14 c5 86 80 11 	mov    %dx,-0x7fee7f7a(,%eax,8)
80105fd4:	80 
  for(i = 0; i < 256; i++)
80105fd5:	83 c0 01             	add    $0x1,%eax
80105fd8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105fdd:	75 d1                	jne    80105fb0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105fdf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fe2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105fe7:	c7 05 82 82 11 80 08 	movl   $0xef000008,0x80118282
80105fee:	00 00 ef 
  initlock(&tickslock, "time");
80105ff1:	68 7b 7c 10 80       	push   $0x80107c7b
80105ff6:	68 40 80 11 80       	push   $0x80118040
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ffb:	66 a3 80 82 11 80    	mov    %ax,0x80118280
80106001:	c1 e8 10             	shr    $0x10,%eax
80106004:	66 a3 86 82 11 80    	mov    %ax,0x80118286
  initlock(&tickslock, "time");
8010600a:	e8 b1 e6 ff ff       	call   801046c0 <initlock>
}
8010600f:	83 c4 10             	add    $0x10,%esp
80106012:	c9                   	leave
80106013:	c3                   	ret
80106014:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010601b:	00 
8010601c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106020 <idtinit>:

void
idtinit(void)
{
80106020:	f3 0f 1e fb          	endbr32
80106024:	55                   	push   %ebp
  pd[0] = size-1;
80106025:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010602a:	89 e5                	mov    %esp,%ebp
8010602c:	83 ec 10             	sub    $0x10,%esp
8010602f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106033:	b8 80 80 11 80       	mov    $0x80118080,%eax
80106038:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010603c:	c1 e8 10             	shr    $0x10,%eax
8010603f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106043:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106046:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106049:	c9                   	leave
8010604a:	c3                   	ret
8010604b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106050 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106050:	f3 0f 1e fb          	endbr32
80106054:	55                   	push   %ebp
80106055:	89 e5                	mov    %esp,%ebp
80106057:	57                   	push   %edi
80106058:	56                   	push   %esi
80106059:	53                   	push   %ebx
8010605a:	83 ec 1c             	sub    $0x1c,%esp
8010605d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106060:	8b 43 30             	mov    0x30(%ebx),%eax
80106063:	83 f8 40             	cmp    $0x40,%eax
80106066:	0f 84 bc 01 00 00    	je     80106228 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010606c:	83 e8 20             	sub    $0x20,%eax
8010606f:	83 f8 1f             	cmp    $0x1f,%eax
80106072:	77 08                	ja     8010607c <trap+0x2c>
80106074:	3e ff 24 85 0c 82 10 	notrack jmp *-0x7fef7df4(,%eax,4)
8010607b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010607c:	e8 af d9 ff ff       	call   80103a30 <myproc>
80106081:	8b 7b 38             	mov    0x38(%ebx),%edi
80106084:	85 c0                	test   %eax,%eax
80106086:	0f 84 eb 01 00 00    	je     80106277 <trap+0x227>
8010608c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106090:	0f 84 e1 01 00 00    	je     80106277 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106096:	0f 20 d1             	mov    %cr2,%ecx
80106099:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010609c:	e8 6f d9 ff ff       	call   80103a10 <cpuid>
801060a1:	8b 73 30             	mov    0x30(%ebx),%esi
801060a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801060a7:	8b 43 34             	mov    0x34(%ebx),%eax
801060aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801060ad:	e8 7e d9 ff ff       	call   80103a30 <myproc>
801060b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060b5:	e8 76 d9 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060ba:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801060bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801060c0:	51                   	push   %ecx
801060c1:	57                   	push   %edi
801060c2:	52                   	push   %edx
801060c3:	ff 75 e4             	push   -0x1c(%ebp)
801060c6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801060c7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801060ca:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060cd:	56                   	push   %esi
801060ce:	ff 70 10             	push   0x10(%eax)
801060d1:	68 ec 7e 10 80       	push   $0x80107eec
801060d6:	e8 d5 a5 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801060db:	83 c4 20             	add    $0x20,%esp
801060de:	e8 4d d9 ff ff       	call   80103a30 <myproc>
801060e3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060ea:	e8 41 d9 ff ff       	call   80103a30 <myproc>
801060ef:	85 c0                	test   %eax,%eax
801060f1:	74 1d                	je     80106110 <trap+0xc0>
801060f3:	e8 38 d9 ff ff       	call   80103a30 <myproc>
801060f8:	8b 50 24             	mov    0x24(%eax),%edx
801060fb:	85 d2                	test   %edx,%edx
801060fd:	74 11                	je     80106110 <trap+0xc0>
801060ff:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106103:	83 e0 03             	and    $0x3,%eax
80106106:	66 83 f8 03          	cmp    $0x3,%ax
8010610a:	0f 84 50 01 00 00    	je     80106260 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106110:	e8 1b d9 ff ff       	call   80103a30 <myproc>
80106115:	85 c0                	test   %eax,%eax
80106117:	74 0f                	je     80106128 <trap+0xd8>
80106119:	e8 12 d9 ff ff       	call   80103a30 <myproc>
8010611e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106122:	0f 84 e8 00 00 00    	je     80106210 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106128:	e8 03 d9 ff ff       	call   80103a30 <myproc>
8010612d:	85 c0                	test   %eax,%eax
8010612f:	74 1d                	je     8010614e <trap+0xfe>
80106131:	e8 fa d8 ff ff       	call   80103a30 <myproc>
80106136:	8b 40 24             	mov    0x24(%eax),%eax
80106139:	85 c0                	test   %eax,%eax
8010613b:	74 11                	je     8010614e <trap+0xfe>
8010613d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106141:	83 e0 03             	and    $0x3,%eax
80106144:	66 83 f8 03          	cmp    $0x3,%ax
80106148:	0f 84 03 01 00 00    	je     80106251 <trap+0x201>
    exit();
}
8010614e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106151:	5b                   	pop    %ebx
80106152:	5e                   	pop    %esi
80106153:	5f                   	pop    %edi
80106154:	5d                   	pop    %ebp
80106155:	c3                   	ret
    ideintr();
80106156:	e8 15 c1 ff ff       	call   80102270 <ideintr>
    lapiceoi();
8010615b:	e8 f0 c7 ff ff       	call   80102950 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106160:	e8 cb d8 ff ff       	call   80103a30 <myproc>
80106165:	85 c0                	test   %eax,%eax
80106167:	75 8a                	jne    801060f3 <trap+0xa3>
80106169:	eb a5                	jmp    80106110 <trap+0xc0>
    if(cpuid() == 0){
8010616b:	e8 a0 d8 ff ff       	call   80103a10 <cpuid>
80106170:	85 c0                	test   %eax,%eax
80106172:	75 e7                	jne    8010615b <trap+0x10b>
      acquire(&tickslock);
80106174:	83 ec 0c             	sub    $0xc,%esp
80106177:	68 40 80 11 80       	push   $0x80118040
8010617c:	e8 bf e6 ff ff       	call   80104840 <acquire>
      wakeup(&ticks);
80106181:	c7 04 24 80 88 11 80 	movl   $0x80118880,(%esp)
      ticks++;
80106188:	83 05 80 88 11 80 01 	addl   $0x1,0x80118880
      wakeup(&ticks);
8010618f:	e8 0c e2 ff ff       	call   801043a0 <wakeup>
      release(&tickslock);
80106194:	c7 04 24 40 80 11 80 	movl   $0x80118040,(%esp)
8010619b:	e8 60 e7 ff ff       	call   80104900 <release>
801061a0:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801061a3:	eb b6                	jmp    8010615b <trap+0x10b>
    kbdintr();
801061a5:	e8 66 c6 ff ff       	call   80102810 <kbdintr>
    lapiceoi();
801061aa:	e8 a1 c7 ff ff       	call   80102950 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061af:	e8 7c d8 ff ff       	call   80103a30 <myproc>
801061b4:	85 c0                	test   %eax,%eax
801061b6:	0f 85 37 ff ff ff    	jne    801060f3 <trap+0xa3>
801061bc:	e9 4f ff ff ff       	jmp    80106110 <trap+0xc0>
    uartintr();
801061c1:	e8 4a 02 00 00       	call   80106410 <uartintr>
    lapiceoi();
801061c6:	e8 85 c7 ff ff       	call   80102950 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061cb:	e8 60 d8 ff ff       	call   80103a30 <myproc>
801061d0:	85 c0                	test   %eax,%eax
801061d2:	0f 85 1b ff ff ff    	jne    801060f3 <trap+0xa3>
801061d8:	e9 33 ff ff ff       	jmp    80106110 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801061dd:	8b 7b 38             	mov    0x38(%ebx),%edi
801061e0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801061e4:	e8 27 d8 ff ff       	call   80103a10 <cpuid>
801061e9:	57                   	push   %edi
801061ea:	56                   	push   %esi
801061eb:	50                   	push   %eax
801061ec:	68 94 7e 10 80       	push   $0x80107e94
801061f1:	e8 ba a4 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801061f6:	e8 55 c7 ff ff       	call   80102950 <lapiceoi>
    break;
801061fb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061fe:	e8 2d d8 ff ff       	call   80103a30 <myproc>
80106203:	85 c0                	test   %eax,%eax
80106205:	0f 85 e8 fe ff ff    	jne    801060f3 <trap+0xa3>
8010620b:	e9 00 ff ff ff       	jmp    80106110 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106210:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106214:	0f 85 0e ff ff ff    	jne    80106128 <trap+0xd8>
    yield();
8010621a:	e8 71 df ff ff       	call   80104190 <yield>
8010621f:	e9 04 ff ff ff       	jmp    80106128 <trap+0xd8>
80106224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106228:	e8 03 d8 ff ff       	call   80103a30 <myproc>
8010622d:	8b 70 24             	mov    0x24(%eax),%esi
80106230:	85 f6                	test   %esi,%esi
80106232:	75 3c                	jne    80106270 <trap+0x220>
    myproc()->tf = tf;
80106234:	e8 f7 d7 ff ff       	call   80103a30 <myproc>
80106239:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010623c:	e8 df ea ff ff       	call   80104d20 <syscall>
    if(myproc()->killed)
80106241:	e8 ea d7 ff ff       	call   80103a30 <myproc>
80106246:	8b 48 24             	mov    0x24(%eax),%ecx
80106249:	85 c9                	test   %ecx,%ecx
8010624b:	0f 84 fd fe ff ff    	je     8010614e <trap+0xfe>
}
80106251:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106254:	5b                   	pop    %ebx
80106255:	5e                   	pop    %esi
80106256:	5f                   	pop    %edi
80106257:	5d                   	pop    %ebp
      exit();
80106258:	e9 c3 dd ff ff       	jmp    80104020 <exit>
8010625d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106260:	e8 bb dd ff ff       	call   80104020 <exit>
80106265:	e9 a6 fe ff ff       	jmp    80106110 <trap+0xc0>
8010626a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106270:	e8 ab dd ff ff       	call   80104020 <exit>
80106275:	eb bd                	jmp    80106234 <trap+0x1e4>
80106277:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010627a:	e8 91 d7 ff ff       	call   80103a10 <cpuid>
8010627f:	83 ec 0c             	sub    $0xc,%esp
80106282:	56                   	push   %esi
80106283:	57                   	push   %edi
80106284:	50                   	push   %eax
80106285:	ff 73 30             	push   0x30(%ebx)
80106288:	68 b8 7e 10 80       	push   $0x80107eb8
8010628d:	e8 1e a4 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106292:	83 c4 14             	add    $0x14,%esp
80106295:	68 80 7c 10 80       	push   $0x80107c80
8010629a:	e8 f1 a0 ff ff       	call   80100390 <panic>
8010629f:	90                   	nop

801062a0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801062a0:	f3 0f 1e fb          	endbr32
  if(!uart)
801062a4:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
801062a9:	85 c0                	test   %eax,%eax
801062ab:	74 1b                	je     801062c8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062ad:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062b2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801062b3:	a8 01                	test   $0x1,%al
801062b5:	74 11                	je     801062c8 <uartgetc+0x28>
801062b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062bc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801062bd:	0f b6 c0             	movzbl %al,%eax
801062c0:	c3                   	ret
801062c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062cd:	c3                   	ret
801062ce:	66 90                	xchg   %ax,%ax

801062d0 <uartputc.part.0>:
uartputc(int c)
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	57                   	push   %edi
801062d4:	89 c7                	mov    %eax,%edi
801062d6:	56                   	push   %esi
801062d7:	be fd 03 00 00       	mov    $0x3fd,%esi
801062dc:	53                   	push   %ebx
801062dd:	bb 80 00 00 00       	mov    $0x80,%ebx
801062e2:	83 ec 0c             	sub    $0xc,%esp
801062e5:	eb 1b                	jmp    80106302 <uartputc.part.0+0x32>
801062e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801062ee:	00 
801062ef:	90                   	nop
    microdelay(10);
801062f0:	83 ec 0c             	sub    $0xc,%esp
801062f3:	6a 0a                	push   $0xa
801062f5:	e8 76 c6 ff ff       	call   80102970 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801062fa:	83 c4 10             	add    $0x10,%esp
801062fd:	83 eb 01             	sub    $0x1,%ebx
80106300:	74 07                	je     80106309 <uartputc.part.0+0x39>
80106302:	89 f2                	mov    %esi,%edx
80106304:	ec                   	in     (%dx),%al
80106305:	a8 20                	test   $0x20,%al
80106307:	74 e7                	je     801062f0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106309:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010630e:	89 f8                	mov    %edi,%eax
80106310:	ee                   	out    %al,(%dx)
}
80106311:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106314:	5b                   	pop    %ebx
80106315:	5e                   	pop    %esi
80106316:	5f                   	pop    %edi
80106317:	5d                   	pop    %ebp
80106318:	c3                   	ret
80106319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106320 <uartinit>:
{
80106320:	f3 0f 1e fb          	endbr32
80106324:	55                   	push   %ebp
80106325:	31 c9                	xor    %ecx,%ecx
80106327:	89 c8                	mov    %ecx,%eax
80106329:	89 e5                	mov    %esp,%ebp
8010632b:	57                   	push   %edi
8010632c:	56                   	push   %esi
8010632d:	53                   	push   %ebx
8010632e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106333:	89 da                	mov    %ebx,%edx
80106335:	83 ec 0c             	sub    $0xc,%esp
80106338:	ee                   	out    %al,(%dx)
80106339:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010633e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106343:	89 fa                	mov    %edi,%edx
80106345:	ee                   	out    %al,(%dx)
80106346:	b8 0c 00 00 00       	mov    $0xc,%eax
8010634b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106350:	ee                   	out    %al,(%dx)
80106351:	be f9 03 00 00       	mov    $0x3f9,%esi
80106356:	89 c8                	mov    %ecx,%eax
80106358:	89 f2                	mov    %esi,%edx
8010635a:	ee                   	out    %al,(%dx)
8010635b:	b8 03 00 00 00       	mov    $0x3,%eax
80106360:	89 fa                	mov    %edi,%edx
80106362:	ee                   	out    %al,(%dx)
80106363:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106368:	89 c8                	mov    %ecx,%eax
8010636a:	ee                   	out    %al,(%dx)
8010636b:	b8 01 00 00 00       	mov    $0x1,%eax
80106370:	89 f2                	mov    %esi,%edx
80106372:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106373:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106378:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106379:	3c ff                	cmp    $0xff,%al
8010637b:	74 4d                	je     801063ca <uartinit+0xaa>
  uart = 1;
8010637d:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
80106384:	00 00 00 
80106387:	89 da                	mov    %ebx,%edx
80106389:	ec                   	in     (%dx),%al
8010638a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010638f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106390:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106393:	bb 85 7c 10 80       	mov    $0x80107c85,%ebx
  ioapicenable(IRQ_COM1, 0);
80106398:	6a 00                	push   $0x0
8010639a:	6a 04                	push   $0x4
8010639c:	e8 1f c1 ff ff       	call   801024c0 <ioapicenable>
801063a1:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801063a4:	b8 78 00 00 00       	mov    $0x78,%eax
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801063b0:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
801063b6:	85 d2                	test   %edx,%edx
801063b8:	74 05                	je     801063bf <uartinit+0x9f>
801063ba:	e8 11 ff ff ff       	call   801062d0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801063bf:	0f be 43 01          	movsbl 0x1(%ebx),%eax
801063c3:	83 c3 01             	add    $0x1,%ebx
801063c6:	84 c0                	test   %al,%al
801063c8:	75 e6                	jne    801063b0 <uartinit+0x90>
}
801063ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063cd:	5b                   	pop    %ebx
801063ce:	5e                   	pop    %esi
801063cf:	5f                   	pop    %edi
801063d0:	5d                   	pop    %ebp
801063d1:	c3                   	ret
801063d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801063d9:	00 
801063da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801063e0 <uartputc>:
{
801063e0:	f3 0f 1e fb          	endbr32
801063e4:	55                   	push   %ebp
  if(!uart)
801063e5:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
{
801063eb:	89 e5                	mov    %esp,%ebp
801063ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801063f0:	85 d2                	test   %edx,%edx
801063f2:	74 0c                	je     80106400 <uartputc+0x20>
}
801063f4:	5d                   	pop    %ebp
801063f5:	e9 d6 fe ff ff       	jmp    801062d0 <uartputc.part.0>
801063fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106400:	5d                   	pop    %ebp
80106401:	c3                   	ret
80106402:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106409:	00 
8010640a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106410 <uartintr>:

void
uartintr(void)
{
80106410:	f3 0f 1e fb          	endbr32
80106414:	55                   	push   %ebp
80106415:	89 e5                	mov    %esp,%ebp
80106417:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010641a:	68 a0 62 10 80       	push   $0x801062a0
8010641f:	e8 3c a4 ff ff       	call   80100860 <consoleintr>
}
80106424:	83 c4 10             	add    $0x10,%esp
80106427:	c9                   	leave
80106428:	c3                   	ret

80106429 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $0
8010642b:	6a 00                	push   $0x0
  jmp alltraps
8010642d:	e9 3c fb ff ff       	jmp    80105f6e <alltraps>

80106432 <vector1>:
.globl vector1
vector1:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $1
80106434:	6a 01                	push   $0x1
  jmp alltraps
80106436:	e9 33 fb ff ff       	jmp    80105f6e <alltraps>

8010643b <vector2>:
.globl vector2
vector2:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $2
8010643d:	6a 02                	push   $0x2
  jmp alltraps
8010643f:	e9 2a fb ff ff       	jmp    80105f6e <alltraps>

80106444 <vector3>:
.globl vector3
vector3:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $3
80106446:	6a 03                	push   $0x3
  jmp alltraps
80106448:	e9 21 fb ff ff       	jmp    80105f6e <alltraps>

8010644d <vector4>:
.globl vector4
vector4:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $4
8010644f:	6a 04                	push   $0x4
  jmp alltraps
80106451:	e9 18 fb ff ff       	jmp    80105f6e <alltraps>

80106456 <vector5>:
.globl vector5
vector5:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $5
80106458:	6a 05                	push   $0x5
  jmp alltraps
8010645a:	e9 0f fb ff ff       	jmp    80105f6e <alltraps>

8010645f <vector6>:
.globl vector6
vector6:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $6
80106461:	6a 06                	push   $0x6
  jmp alltraps
80106463:	e9 06 fb ff ff       	jmp    80105f6e <alltraps>

80106468 <vector7>:
.globl vector7
vector7:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $7
8010646a:	6a 07                	push   $0x7
  jmp alltraps
8010646c:	e9 fd fa ff ff       	jmp    80105f6e <alltraps>

80106471 <vector8>:
.globl vector8
vector8:
  pushl $8
80106471:	6a 08                	push   $0x8
  jmp alltraps
80106473:	e9 f6 fa ff ff       	jmp    80105f6e <alltraps>

80106478 <vector9>:
.globl vector9
vector9:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $9
8010647a:	6a 09                	push   $0x9
  jmp alltraps
8010647c:	e9 ed fa ff ff       	jmp    80105f6e <alltraps>

80106481 <vector10>:
.globl vector10
vector10:
  pushl $10
80106481:	6a 0a                	push   $0xa
  jmp alltraps
80106483:	e9 e6 fa ff ff       	jmp    80105f6e <alltraps>

80106488 <vector11>:
.globl vector11
vector11:
  pushl $11
80106488:	6a 0b                	push   $0xb
  jmp alltraps
8010648a:	e9 df fa ff ff       	jmp    80105f6e <alltraps>

8010648f <vector12>:
.globl vector12
vector12:
  pushl $12
8010648f:	6a 0c                	push   $0xc
  jmp alltraps
80106491:	e9 d8 fa ff ff       	jmp    80105f6e <alltraps>

80106496 <vector13>:
.globl vector13
vector13:
  pushl $13
80106496:	6a 0d                	push   $0xd
  jmp alltraps
80106498:	e9 d1 fa ff ff       	jmp    80105f6e <alltraps>

8010649d <vector14>:
.globl vector14
vector14:
  pushl $14
8010649d:	6a 0e                	push   $0xe
  jmp alltraps
8010649f:	e9 ca fa ff ff       	jmp    80105f6e <alltraps>

801064a4 <vector15>:
.globl vector15
vector15:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $15
801064a6:	6a 0f                	push   $0xf
  jmp alltraps
801064a8:	e9 c1 fa ff ff       	jmp    80105f6e <alltraps>

801064ad <vector16>:
.globl vector16
vector16:
  pushl $0
801064ad:	6a 00                	push   $0x0
  pushl $16
801064af:	6a 10                	push   $0x10
  jmp alltraps
801064b1:	e9 b8 fa ff ff       	jmp    80105f6e <alltraps>

801064b6 <vector17>:
.globl vector17
vector17:
  pushl $17
801064b6:	6a 11                	push   $0x11
  jmp alltraps
801064b8:	e9 b1 fa ff ff       	jmp    80105f6e <alltraps>

801064bd <vector18>:
.globl vector18
vector18:
  pushl $0
801064bd:	6a 00                	push   $0x0
  pushl $18
801064bf:	6a 12                	push   $0x12
  jmp alltraps
801064c1:	e9 a8 fa ff ff       	jmp    80105f6e <alltraps>

801064c6 <vector19>:
.globl vector19
vector19:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $19
801064c8:	6a 13                	push   $0x13
  jmp alltraps
801064ca:	e9 9f fa ff ff       	jmp    80105f6e <alltraps>

801064cf <vector20>:
.globl vector20
vector20:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $20
801064d1:	6a 14                	push   $0x14
  jmp alltraps
801064d3:	e9 96 fa ff ff       	jmp    80105f6e <alltraps>

801064d8 <vector21>:
.globl vector21
vector21:
  pushl $0
801064d8:	6a 00                	push   $0x0
  pushl $21
801064da:	6a 15                	push   $0x15
  jmp alltraps
801064dc:	e9 8d fa ff ff       	jmp    80105f6e <alltraps>

801064e1 <vector22>:
.globl vector22
vector22:
  pushl $0
801064e1:	6a 00                	push   $0x0
  pushl $22
801064e3:	6a 16                	push   $0x16
  jmp alltraps
801064e5:	e9 84 fa ff ff       	jmp    80105f6e <alltraps>

801064ea <vector23>:
.globl vector23
vector23:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $23
801064ec:	6a 17                	push   $0x17
  jmp alltraps
801064ee:	e9 7b fa ff ff       	jmp    80105f6e <alltraps>

801064f3 <vector24>:
.globl vector24
vector24:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $24
801064f5:	6a 18                	push   $0x18
  jmp alltraps
801064f7:	e9 72 fa ff ff       	jmp    80105f6e <alltraps>

801064fc <vector25>:
.globl vector25
vector25:
  pushl $0
801064fc:	6a 00                	push   $0x0
  pushl $25
801064fe:	6a 19                	push   $0x19
  jmp alltraps
80106500:	e9 69 fa ff ff       	jmp    80105f6e <alltraps>

80106505 <vector26>:
.globl vector26
vector26:
  pushl $0
80106505:	6a 00                	push   $0x0
  pushl $26
80106507:	6a 1a                	push   $0x1a
  jmp alltraps
80106509:	e9 60 fa ff ff       	jmp    80105f6e <alltraps>

8010650e <vector27>:
.globl vector27
vector27:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $27
80106510:	6a 1b                	push   $0x1b
  jmp alltraps
80106512:	e9 57 fa ff ff       	jmp    80105f6e <alltraps>

80106517 <vector28>:
.globl vector28
vector28:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $28
80106519:	6a 1c                	push   $0x1c
  jmp alltraps
8010651b:	e9 4e fa ff ff       	jmp    80105f6e <alltraps>

80106520 <vector29>:
.globl vector29
vector29:
  pushl $0
80106520:	6a 00                	push   $0x0
  pushl $29
80106522:	6a 1d                	push   $0x1d
  jmp alltraps
80106524:	e9 45 fa ff ff       	jmp    80105f6e <alltraps>

80106529 <vector30>:
.globl vector30
vector30:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $30
8010652b:	6a 1e                	push   $0x1e
  jmp alltraps
8010652d:	e9 3c fa ff ff       	jmp    80105f6e <alltraps>

80106532 <vector31>:
.globl vector31
vector31:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $31
80106534:	6a 1f                	push   $0x1f
  jmp alltraps
80106536:	e9 33 fa ff ff       	jmp    80105f6e <alltraps>

8010653b <vector32>:
.globl vector32
vector32:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $32
8010653d:	6a 20                	push   $0x20
  jmp alltraps
8010653f:	e9 2a fa ff ff       	jmp    80105f6e <alltraps>

80106544 <vector33>:
.globl vector33
vector33:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $33
80106546:	6a 21                	push   $0x21
  jmp alltraps
80106548:	e9 21 fa ff ff       	jmp    80105f6e <alltraps>

8010654d <vector34>:
.globl vector34
vector34:
  pushl $0
8010654d:	6a 00                	push   $0x0
  pushl $34
8010654f:	6a 22                	push   $0x22
  jmp alltraps
80106551:	e9 18 fa ff ff       	jmp    80105f6e <alltraps>

80106556 <vector35>:
.globl vector35
vector35:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $35
80106558:	6a 23                	push   $0x23
  jmp alltraps
8010655a:	e9 0f fa ff ff       	jmp    80105f6e <alltraps>

8010655f <vector36>:
.globl vector36
vector36:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $36
80106561:	6a 24                	push   $0x24
  jmp alltraps
80106563:	e9 06 fa ff ff       	jmp    80105f6e <alltraps>

80106568 <vector37>:
.globl vector37
vector37:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $37
8010656a:	6a 25                	push   $0x25
  jmp alltraps
8010656c:	e9 fd f9 ff ff       	jmp    80105f6e <alltraps>

80106571 <vector38>:
.globl vector38
vector38:
  pushl $0
80106571:	6a 00                	push   $0x0
  pushl $38
80106573:	6a 26                	push   $0x26
  jmp alltraps
80106575:	e9 f4 f9 ff ff       	jmp    80105f6e <alltraps>

8010657a <vector39>:
.globl vector39
vector39:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $39
8010657c:	6a 27                	push   $0x27
  jmp alltraps
8010657e:	e9 eb f9 ff ff       	jmp    80105f6e <alltraps>

80106583 <vector40>:
.globl vector40
vector40:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $40
80106585:	6a 28                	push   $0x28
  jmp alltraps
80106587:	e9 e2 f9 ff ff       	jmp    80105f6e <alltraps>

8010658c <vector41>:
.globl vector41
vector41:
  pushl $0
8010658c:	6a 00                	push   $0x0
  pushl $41
8010658e:	6a 29                	push   $0x29
  jmp alltraps
80106590:	e9 d9 f9 ff ff       	jmp    80105f6e <alltraps>

80106595 <vector42>:
.globl vector42
vector42:
  pushl $0
80106595:	6a 00                	push   $0x0
  pushl $42
80106597:	6a 2a                	push   $0x2a
  jmp alltraps
80106599:	e9 d0 f9 ff ff       	jmp    80105f6e <alltraps>

8010659e <vector43>:
.globl vector43
vector43:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $43
801065a0:	6a 2b                	push   $0x2b
  jmp alltraps
801065a2:	e9 c7 f9 ff ff       	jmp    80105f6e <alltraps>

801065a7 <vector44>:
.globl vector44
vector44:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $44
801065a9:	6a 2c                	push   $0x2c
  jmp alltraps
801065ab:	e9 be f9 ff ff       	jmp    80105f6e <alltraps>

801065b0 <vector45>:
.globl vector45
vector45:
  pushl $0
801065b0:	6a 00                	push   $0x0
  pushl $45
801065b2:	6a 2d                	push   $0x2d
  jmp alltraps
801065b4:	e9 b5 f9 ff ff       	jmp    80105f6e <alltraps>

801065b9 <vector46>:
.globl vector46
vector46:
  pushl $0
801065b9:	6a 00                	push   $0x0
  pushl $46
801065bb:	6a 2e                	push   $0x2e
  jmp alltraps
801065bd:	e9 ac f9 ff ff       	jmp    80105f6e <alltraps>

801065c2 <vector47>:
.globl vector47
vector47:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $47
801065c4:	6a 2f                	push   $0x2f
  jmp alltraps
801065c6:	e9 a3 f9 ff ff       	jmp    80105f6e <alltraps>

801065cb <vector48>:
.globl vector48
vector48:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $48
801065cd:	6a 30                	push   $0x30
  jmp alltraps
801065cf:	e9 9a f9 ff ff       	jmp    80105f6e <alltraps>

801065d4 <vector49>:
.globl vector49
vector49:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $49
801065d6:	6a 31                	push   $0x31
  jmp alltraps
801065d8:	e9 91 f9 ff ff       	jmp    80105f6e <alltraps>

801065dd <vector50>:
.globl vector50
vector50:
  pushl $0
801065dd:	6a 00                	push   $0x0
  pushl $50
801065df:	6a 32                	push   $0x32
  jmp alltraps
801065e1:	e9 88 f9 ff ff       	jmp    80105f6e <alltraps>

801065e6 <vector51>:
.globl vector51
vector51:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $51
801065e8:	6a 33                	push   $0x33
  jmp alltraps
801065ea:	e9 7f f9 ff ff       	jmp    80105f6e <alltraps>

801065ef <vector52>:
.globl vector52
vector52:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $52
801065f1:	6a 34                	push   $0x34
  jmp alltraps
801065f3:	e9 76 f9 ff ff       	jmp    80105f6e <alltraps>

801065f8 <vector53>:
.globl vector53
vector53:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $53
801065fa:	6a 35                	push   $0x35
  jmp alltraps
801065fc:	e9 6d f9 ff ff       	jmp    80105f6e <alltraps>

80106601 <vector54>:
.globl vector54
vector54:
  pushl $0
80106601:	6a 00                	push   $0x0
  pushl $54
80106603:	6a 36                	push   $0x36
  jmp alltraps
80106605:	e9 64 f9 ff ff       	jmp    80105f6e <alltraps>

8010660a <vector55>:
.globl vector55
vector55:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $55
8010660c:	6a 37                	push   $0x37
  jmp alltraps
8010660e:	e9 5b f9 ff ff       	jmp    80105f6e <alltraps>

80106613 <vector56>:
.globl vector56
vector56:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $56
80106615:	6a 38                	push   $0x38
  jmp alltraps
80106617:	e9 52 f9 ff ff       	jmp    80105f6e <alltraps>

8010661c <vector57>:
.globl vector57
vector57:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $57
8010661e:	6a 39                	push   $0x39
  jmp alltraps
80106620:	e9 49 f9 ff ff       	jmp    80105f6e <alltraps>

80106625 <vector58>:
.globl vector58
vector58:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $58
80106627:	6a 3a                	push   $0x3a
  jmp alltraps
80106629:	e9 40 f9 ff ff       	jmp    80105f6e <alltraps>

8010662e <vector59>:
.globl vector59
vector59:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $59
80106630:	6a 3b                	push   $0x3b
  jmp alltraps
80106632:	e9 37 f9 ff ff       	jmp    80105f6e <alltraps>

80106637 <vector60>:
.globl vector60
vector60:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $60
80106639:	6a 3c                	push   $0x3c
  jmp alltraps
8010663b:	e9 2e f9 ff ff       	jmp    80105f6e <alltraps>

80106640 <vector61>:
.globl vector61
vector61:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $61
80106642:	6a 3d                	push   $0x3d
  jmp alltraps
80106644:	e9 25 f9 ff ff       	jmp    80105f6e <alltraps>

80106649 <vector62>:
.globl vector62
vector62:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $62
8010664b:	6a 3e                	push   $0x3e
  jmp alltraps
8010664d:	e9 1c f9 ff ff       	jmp    80105f6e <alltraps>

80106652 <vector63>:
.globl vector63
vector63:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $63
80106654:	6a 3f                	push   $0x3f
  jmp alltraps
80106656:	e9 13 f9 ff ff       	jmp    80105f6e <alltraps>

8010665b <vector64>:
.globl vector64
vector64:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $64
8010665d:	6a 40                	push   $0x40
  jmp alltraps
8010665f:	e9 0a f9 ff ff       	jmp    80105f6e <alltraps>

80106664 <vector65>:
.globl vector65
vector65:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $65
80106666:	6a 41                	push   $0x41
  jmp alltraps
80106668:	e9 01 f9 ff ff       	jmp    80105f6e <alltraps>

8010666d <vector66>:
.globl vector66
vector66:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $66
8010666f:	6a 42                	push   $0x42
  jmp alltraps
80106671:	e9 f8 f8 ff ff       	jmp    80105f6e <alltraps>

80106676 <vector67>:
.globl vector67
vector67:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $67
80106678:	6a 43                	push   $0x43
  jmp alltraps
8010667a:	e9 ef f8 ff ff       	jmp    80105f6e <alltraps>

8010667f <vector68>:
.globl vector68
vector68:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $68
80106681:	6a 44                	push   $0x44
  jmp alltraps
80106683:	e9 e6 f8 ff ff       	jmp    80105f6e <alltraps>

80106688 <vector69>:
.globl vector69
vector69:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $69
8010668a:	6a 45                	push   $0x45
  jmp alltraps
8010668c:	e9 dd f8 ff ff       	jmp    80105f6e <alltraps>

80106691 <vector70>:
.globl vector70
vector70:
  pushl $0
80106691:	6a 00                	push   $0x0
  pushl $70
80106693:	6a 46                	push   $0x46
  jmp alltraps
80106695:	e9 d4 f8 ff ff       	jmp    80105f6e <alltraps>

8010669a <vector71>:
.globl vector71
vector71:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $71
8010669c:	6a 47                	push   $0x47
  jmp alltraps
8010669e:	e9 cb f8 ff ff       	jmp    80105f6e <alltraps>

801066a3 <vector72>:
.globl vector72
vector72:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $72
801066a5:	6a 48                	push   $0x48
  jmp alltraps
801066a7:	e9 c2 f8 ff ff       	jmp    80105f6e <alltraps>

801066ac <vector73>:
.globl vector73
vector73:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $73
801066ae:	6a 49                	push   $0x49
  jmp alltraps
801066b0:	e9 b9 f8 ff ff       	jmp    80105f6e <alltraps>

801066b5 <vector74>:
.globl vector74
vector74:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $74
801066b7:	6a 4a                	push   $0x4a
  jmp alltraps
801066b9:	e9 b0 f8 ff ff       	jmp    80105f6e <alltraps>

801066be <vector75>:
.globl vector75
vector75:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $75
801066c0:	6a 4b                	push   $0x4b
  jmp alltraps
801066c2:	e9 a7 f8 ff ff       	jmp    80105f6e <alltraps>

801066c7 <vector76>:
.globl vector76
vector76:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $76
801066c9:	6a 4c                	push   $0x4c
  jmp alltraps
801066cb:	e9 9e f8 ff ff       	jmp    80105f6e <alltraps>

801066d0 <vector77>:
.globl vector77
vector77:
  pushl $0
801066d0:	6a 00                	push   $0x0
  pushl $77
801066d2:	6a 4d                	push   $0x4d
  jmp alltraps
801066d4:	e9 95 f8 ff ff       	jmp    80105f6e <alltraps>

801066d9 <vector78>:
.globl vector78
vector78:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $78
801066db:	6a 4e                	push   $0x4e
  jmp alltraps
801066dd:	e9 8c f8 ff ff       	jmp    80105f6e <alltraps>

801066e2 <vector79>:
.globl vector79
vector79:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $79
801066e4:	6a 4f                	push   $0x4f
  jmp alltraps
801066e6:	e9 83 f8 ff ff       	jmp    80105f6e <alltraps>

801066eb <vector80>:
.globl vector80
vector80:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $80
801066ed:	6a 50                	push   $0x50
  jmp alltraps
801066ef:	e9 7a f8 ff ff       	jmp    80105f6e <alltraps>

801066f4 <vector81>:
.globl vector81
vector81:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $81
801066f6:	6a 51                	push   $0x51
  jmp alltraps
801066f8:	e9 71 f8 ff ff       	jmp    80105f6e <alltraps>

801066fd <vector82>:
.globl vector82
vector82:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $82
801066ff:	6a 52                	push   $0x52
  jmp alltraps
80106701:	e9 68 f8 ff ff       	jmp    80105f6e <alltraps>

80106706 <vector83>:
.globl vector83
vector83:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $83
80106708:	6a 53                	push   $0x53
  jmp alltraps
8010670a:	e9 5f f8 ff ff       	jmp    80105f6e <alltraps>

8010670f <vector84>:
.globl vector84
vector84:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $84
80106711:	6a 54                	push   $0x54
  jmp alltraps
80106713:	e9 56 f8 ff ff       	jmp    80105f6e <alltraps>

80106718 <vector85>:
.globl vector85
vector85:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $85
8010671a:	6a 55                	push   $0x55
  jmp alltraps
8010671c:	e9 4d f8 ff ff       	jmp    80105f6e <alltraps>

80106721 <vector86>:
.globl vector86
vector86:
  pushl $0
80106721:	6a 00                	push   $0x0
  pushl $86
80106723:	6a 56                	push   $0x56
  jmp alltraps
80106725:	e9 44 f8 ff ff       	jmp    80105f6e <alltraps>

8010672a <vector87>:
.globl vector87
vector87:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $87
8010672c:	6a 57                	push   $0x57
  jmp alltraps
8010672e:	e9 3b f8 ff ff       	jmp    80105f6e <alltraps>

80106733 <vector88>:
.globl vector88
vector88:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $88
80106735:	6a 58                	push   $0x58
  jmp alltraps
80106737:	e9 32 f8 ff ff       	jmp    80105f6e <alltraps>

8010673c <vector89>:
.globl vector89
vector89:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $89
8010673e:	6a 59                	push   $0x59
  jmp alltraps
80106740:	e9 29 f8 ff ff       	jmp    80105f6e <alltraps>

80106745 <vector90>:
.globl vector90
vector90:
  pushl $0
80106745:	6a 00                	push   $0x0
  pushl $90
80106747:	6a 5a                	push   $0x5a
  jmp alltraps
80106749:	e9 20 f8 ff ff       	jmp    80105f6e <alltraps>

8010674e <vector91>:
.globl vector91
vector91:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $91
80106750:	6a 5b                	push   $0x5b
  jmp alltraps
80106752:	e9 17 f8 ff ff       	jmp    80105f6e <alltraps>

80106757 <vector92>:
.globl vector92
vector92:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $92
80106759:	6a 5c                	push   $0x5c
  jmp alltraps
8010675b:	e9 0e f8 ff ff       	jmp    80105f6e <alltraps>

80106760 <vector93>:
.globl vector93
vector93:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $93
80106762:	6a 5d                	push   $0x5d
  jmp alltraps
80106764:	e9 05 f8 ff ff       	jmp    80105f6e <alltraps>

80106769 <vector94>:
.globl vector94
vector94:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $94
8010676b:	6a 5e                	push   $0x5e
  jmp alltraps
8010676d:	e9 fc f7 ff ff       	jmp    80105f6e <alltraps>

80106772 <vector95>:
.globl vector95
vector95:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $95
80106774:	6a 5f                	push   $0x5f
  jmp alltraps
80106776:	e9 f3 f7 ff ff       	jmp    80105f6e <alltraps>

8010677b <vector96>:
.globl vector96
vector96:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $96
8010677d:	6a 60                	push   $0x60
  jmp alltraps
8010677f:	e9 ea f7 ff ff       	jmp    80105f6e <alltraps>

80106784 <vector97>:
.globl vector97
vector97:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $97
80106786:	6a 61                	push   $0x61
  jmp alltraps
80106788:	e9 e1 f7 ff ff       	jmp    80105f6e <alltraps>

8010678d <vector98>:
.globl vector98
vector98:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $98
8010678f:	6a 62                	push   $0x62
  jmp alltraps
80106791:	e9 d8 f7 ff ff       	jmp    80105f6e <alltraps>

80106796 <vector99>:
.globl vector99
vector99:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $99
80106798:	6a 63                	push   $0x63
  jmp alltraps
8010679a:	e9 cf f7 ff ff       	jmp    80105f6e <alltraps>

8010679f <vector100>:
.globl vector100
vector100:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $100
801067a1:	6a 64                	push   $0x64
  jmp alltraps
801067a3:	e9 c6 f7 ff ff       	jmp    80105f6e <alltraps>

801067a8 <vector101>:
.globl vector101
vector101:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $101
801067aa:	6a 65                	push   $0x65
  jmp alltraps
801067ac:	e9 bd f7 ff ff       	jmp    80105f6e <alltraps>

801067b1 <vector102>:
.globl vector102
vector102:
  pushl $0
801067b1:	6a 00                	push   $0x0
  pushl $102
801067b3:	6a 66                	push   $0x66
  jmp alltraps
801067b5:	e9 b4 f7 ff ff       	jmp    80105f6e <alltraps>

801067ba <vector103>:
.globl vector103
vector103:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $103
801067bc:	6a 67                	push   $0x67
  jmp alltraps
801067be:	e9 ab f7 ff ff       	jmp    80105f6e <alltraps>

801067c3 <vector104>:
.globl vector104
vector104:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $104
801067c5:	6a 68                	push   $0x68
  jmp alltraps
801067c7:	e9 a2 f7 ff ff       	jmp    80105f6e <alltraps>

801067cc <vector105>:
.globl vector105
vector105:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $105
801067ce:	6a 69                	push   $0x69
  jmp alltraps
801067d0:	e9 99 f7 ff ff       	jmp    80105f6e <alltraps>

801067d5 <vector106>:
.globl vector106
vector106:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $106
801067d7:	6a 6a                	push   $0x6a
  jmp alltraps
801067d9:	e9 90 f7 ff ff       	jmp    80105f6e <alltraps>

801067de <vector107>:
.globl vector107
vector107:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $107
801067e0:	6a 6b                	push   $0x6b
  jmp alltraps
801067e2:	e9 87 f7 ff ff       	jmp    80105f6e <alltraps>

801067e7 <vector108>:
.globl vector108
vector108:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $108
801067e9:	6a 6c                	push   $0x6c
  jmp alltraps
801067eb:	e9 7e f7 ff ff       	jmp    80105f6e <alltraps>

801067f0 <vector109>:
.globl vector109
vector109:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $109
801067f2:	6a 6d                	push   $0x6d
  jmp alltraps
801067f4:	e9 75 f7 ff ff       	jmp    80105f6e <alltraps>

801067f9 <vector110>:
.globl vector110
vector110:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $110
801067fb:	6a 6e                	push   $0x6e
  jmp alltraps
801067fd:	e9 6c f7 ff ff       	jmp    80105f6e <alltraps>

80106802 <vector111>:
.globl vector111
vector111:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $111
80106804:	6a 6f                	push   $0x6f
  jmp alltraps
80106806:	e9 63 f7 ff ff       	jmp    80105f6e <alltraps>

8010680b <vector112>:
.globl vector112
vector112:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $112
8010680d:	6a 70                	push   $0x70
  jmp alltraps
8010680f:	e9 5a f7 ff ff       	jmp    80105f6e <alltraps>

80106814 <vector113>:
.globl vector113
vector113:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $113
80106816:	6a 71                	push   $0x71
  jmp alltraps
80106818:	e9 51 f7 ff ff       	jmp    80105f6e <alltraps>

8010681d <vector114>:
.globl vector114
vector114:
  pushl $0
8010681d:	6a 00                	push   $0x0
  pushl $114
8010681f:	6a 72                	push   $0x72
  jmp alltraps
80106821:	e9 48 f7 ff ff       	jmp    80105f6e <alltraps>

80106826 <vector115>:
.globl vector115
vector115:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $115
80106828:	6a 73                	push   $0x73
  jmp alltraps
8010682a:	e9 3f f7 ff ff       	jmp    80105f6e <alltraps>

8010682f <vector116>:
.globl vector116
vector116:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $116
80106831:	6a 74                	push   $0x74
  jmp alltraps
80106833:	e9 36 f7 ff ff       	jmp    80105f6e <alltraps>

80106838 <vector117>:
.globl vector117
vector117:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $117
8010683a:	6a 75                	push   $0x75
  jmp alltraps
8010683c:	e9 2d f7 ff ff       	jmp    80105f6e <alltraps>

80106841 <vector118>:
.globl vector118
vector118:
  pushl $0
80106841:	6a 00                	push   $0x0
  pushl $118
80106843:	6a 76                	push   $0x76
  jmp alltraps
80106845:	e9 24 f7 ff ff       	jmp    80105f6e <alltraps>

8010684a <vector119>:
.globl vector119
vector119:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $119
8010684c:	6a 77                	push   $0x77
  jmp alltraps
8010684e:	e9 1b f7 ff ff       	jmp    80105f6e <alltraps>

80106853 <vector120>:
.globl vector120
vector120:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $120
80106855:	6a 78                	push   $0x78
  jmp alltraps
80106857:	e9 12 f7 ff ff       	jmp    80105f6e <alltraps>

8010685c <vector121>:
.globl vector121
vector121:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $121
8010685e:	6a 79                	push   $0x79
  jmp alltraps
80106860:	e9 09 f7 ff ff       	jmp    80105f6e <alltraps>

80106865 <vector122>:
.globl vector122
vector122:
  pushl $0
80106865:	6a 00                	push   $0x0
  pushl $122
80106867:	6a 7a                	push   $0x7a
  jmp alltraps
80106869:	e9 00 f7 ff ff       	jmp    80105f6e <alltraps>

8010686e <vector123>:
.globl vector123
vector123:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $123
80106870:	6a 7b                	push   $0x7b
  jmp alltraps
80106872:	e9 f7 f6 ff ff       	jmp    80105f6e <alltraps>

80106877 <vector124>:
.globl vector124
vector124:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $124
80106879:	6a 7c                	push   $0x7c
  jmp alltraps
8010687b:	e9 ee f6 ff ff       	jmp    80105f6e <alltraps>

80106880 <vector125>:
.globl vector125
vector125:
  pushl $0
80106880:	6a 00                	push   $0x0
  pushl $125
80106882:	6a 7d                	push   $0x7d
  jmp alltraps
80106884:	e9 e5 f6 ff ff       	jmp    80105f6e <alltraps>

80106889 <vector126>:
.globl vector126
vector126:
  pushl $0
80106889:	6a 00                	push   $0x0
  pushl $126
8010688b:	6a 7e                	push   $0x7e
  jmp alltraps
8010688d:	e9 dc f6 ff ff       	jmp    80105f6e <alltraps>

80106892 <vector127>:
.globl vector127
vector127:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $127
80106894:	6a 7f                	push   $0x7f
  jmp alltraps
80106896:	e9 d3 f6 ff ff       	jmp    80105f6e <alltraps>

8010689b <vector128>:
.globl vector128
vector128:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $128
8010689d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801068a2:	e9 c7 f6 ff ff       	jmp    80105f6e <alltraps>

801068a7 <vector129>:
.globl vector129
vector129:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $129
801068a9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801068ae:	e9 bb f6 ff ff       	jmp    80105f6e <alltraps>

801068b3 <vector130>:
.globl vector130
vector130:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $130
801068b5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801068ba:	e9 af f6 ff ff       	jmp    80105f6e <alltraps>

801068bf <vector131>:
.globl vector131
vector131:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $131
801068c1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068c6:	e9 a3 f6 ff ff       	jmp    80105f6e <alltraps>

801068cb <vector132>:
.globl vector132
vector132:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $132
801068cd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068d2:	e9 97 f6 ff ff       	jmp    80105f6e <alltraps>

801068d7 <vector133>:
.globl vector133
vector133:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $133
801068d9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068de:	e9 8b f6 ff ff       	jmp    80105f6e <alltraps>

801068e3 <vector134>:
.globl vector134
vector134:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $134
801068e5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068ea:	e9 7f f6 ff ff       	jmp    80105f6e <alltraps>

801068ef <vector135>:
.globl vector135
vector135:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $135
801068f1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068f6:	e9 73 f6 ff ff       	jmp    80105f6e <alltraps>

801068fb <vector136>:
.globl vector136
vector136:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $136
801068fd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106902:	e9 67 f6 ff ff       	jmp    80105f6e <alltraps>

80106907 <vector137>:
.globl vector137
vector137:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $137
80106909:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010690e:	e9 5b f6 ff ff       	jmp    80105f6e <alltraps>

80106913 <vector138>:
.globl vector138
vector138:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $138
80106915:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010691a:	e9 4f f6 ff ff       	jmp    80105f6e <alltraps>

8010691f <vector139>:
.globl vector139
vector139:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $139
80106921:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106926:	e9 43 f6 ff ff       	jmp    80105f6e <alltraps>

8010692b <vector140>:
.globl vector140
vector140:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $140
8010692d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106932:	e9 37 f6 ff ff       	jmp    80105f6e <alltraps>

80106937 <vector141>:
.globl vector141
vector141:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $141
80106939:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010693e:	e9 2b f6 ff ff       	jmp    80105f6e <alltraps>

80106943 <vector142>:
.globl vector142
vector142:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $142
80106945:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010694a:	e9 1f f6 ff ff       	jmp    80105f6e <alltraps>

8010694f <vector143>:
.globl vector143
vector143:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $143
80106951:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106956:	e9 13 f6 ff ff       	jmp    80105f6e <alltraps>

8010695b <vector144>:
.globl vector144
vector144:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $144
8010695d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106962:	e9 07 f6 ff ff       	jmp    80105f6e <alltraps>

80106967 <vector145>:
.globl vector145
vector145:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $145
80106969:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010696e:	e9 fb f5 ff ff       	jmp    80105f6e <alltraps>

80106973 <vector146>:
.globl vector146
vector146:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $146
80106975:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010697a:	e9 ef f5 ff ff       	jmp    80105f6e <alltraps>

8010697f <vector147>:
.globl vector147
vector147:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $147
80106981:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106986:	e9 e3 f5 ff ff       	jmp    80105f6e <alltraps>

8010698b <vector148>:
.globl vector148
vector148:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $148
8010698d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106992:	e9 d7 f5 ff ff       	jmp    80105f6e <alltraps>

80106997 <vector149>:
.globl vector149
vector149:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $149
80106999:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010699e:	e9 cb f5 ff ff       	jmp    80105f6e <alltraps>

801069a3 <vector150>:
.globl vector150
vector150:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $150
801069a5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801069aa:	e9 bf f5 ff ff       	jmp    80105f6e <alltraps>

801069af <vector151>:
.globl vector151
vector151:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $151
801069b1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801069b6:	e9 b3 f5 ff ff       	jmp    80105f6e <alltraps>

801069bb <vector152>:
.globl vector152
vector152:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $152
801069bd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069c2:	e9 a7 f5 ff ff       	jmp    80105f6e <alltraps>

801069c7 <vector153>:
.globl vector153
vector153:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $153
801069c9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069ce:	e9 9b f5 ff ff       	jmp    80105f6e <alltraps>

801069d3 <vector154>:
.globl vector154
vector154:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $154
801069d5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069da:	e9 8f f5 ff ff       	jmp    80105f6e <alltraps>

801069df <vector155>:
.globl vector155
vector155:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $155
801069e1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069e6:	e9 83 f5 ff ff       	jmp    80105f6e <alltraps>

801069eb <vector156>:
.globl vector156
vector156:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $156
801069ed:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069f2:	e9 77 f5 ff ff       	jmp    80105f6e <alltraps>

801069f7 <vector157>:
.globl vector157
vector157:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $157
801069f9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069fe:	e9 6b f5 ff ff       	jmp    80105f6e <alltraps>

80106a03 <vector158>:
.globl vector158
vector158:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $158
80106a05:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a0a:	e9 5f f5 ff ff       	jmp    80105f6e <alltraps>

80106a0f <vector159>:
.globl vector159
vector159:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $159
80106a11:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a16:	e9 53 f5 ff ff       	jmp    80105f6e <alltraps>

80106a1b <vector160>:
.globl vector160
vector160:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $160
80106a1d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a22:	e9 47 f5 ff ff       	jmp    80105f6e <alltraps>

80106a27 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $161
80106a29:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a2e:	e9 3b f5 ff ff       	jmp    80105f6e <alltraps>

80106a33 <vector162>:
.globl vector162
vector162:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $162
80106a35:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a3a:	e9 2f f5 ff ff       	jmp    80105f6e <alltraps>

80106a3f <vector163>:
.globl vector163
vector163:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $163
80106a41:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a46:	e9 23 f5 ff ff       	jmp    80105f6e <alltraps>

80106a4b <vector164>:
.globl vector164
vector164:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $164
80106a4d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a52:	e9 17 f5 ff ff       	jmp    80105f6e <alltraps>

80106a57 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $165
80106a59:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a5e:	e9 0b f5 ff ff       	jmp    80105f6e <alltraps>

80106a63 <vector166>:
.globl vector166
vector166:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $166
80106a65:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a6a:	e9 ff f4 ff ff       	jmp    80105f6e <alltraps>

80106a6f <vector167>:
.globl vector167
vector167:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $167
80106a71:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a76:	e9 f3 f4 ff ff       	jmp    80105f6e <alltraps>

80106a7b <vector168>:
.globl vector168
vector168:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $168
80106a7d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a82:	e9 e7 f4 ff ff       	jmp    80105f6e <alltraps>

80106a87 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $169
80106a89:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a8e:	e9 db f4 ff ff       	jmp    80105f6e <alltraps>

80106a93 <vector170>:
.globl vector170
vector170:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $170
80106a95:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a9a:	e9 cf f4 ff ff       	jmp    80105f6e <alltraps>

80106a9f <vector171>:
.globl vector171
vector171:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $171
80106aa1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106aa6:	e9 c3 f4 ff ff       	jmp    80105f6e <alltraps>

80106aab <vector172>:
.globl vector172
vector172:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $172
80106aad:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106ab2:	e9 b7 f4 ff ff       	jmp    80105f6e <alltraps>

80106ab7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $173
80106ab9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106abe:	e9 ab f4 ff ff       	jmp    80105f6e <alltraps>

80106ac3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $174
80106ac5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106aca:	e9 9f f4 ff ff       	jmp    80105f6e <alltraps>

80106acf <vector175>:
.globl vector175
vector175:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $175
80106ad1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ad6:	e9 93 f4 ff ff       	jmp    80105f6e <alltraps>

80106adb <vector176>:
.globl vector176
vector176:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $176
80106add:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ae2:	e9 87 f4 ff ff       	jmp    80105f6e <alltraps>

80106ae7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $177
80106ae9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106aee:	e9 7b f4 ff ff       	jmp    80105f6e <alltraps>

80106af3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $178
80106af5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106afa:	e9 6f f4 ff ff       	jmp    80105f6e <alltraps>

80106aff <vector179>:
.globl vector179
vector179:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $179
80106b01:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b06:	e9 63 f4 ff ff       	jmp    80105f6e <alltraps>

80106b0b <vector180>:
.globl vector180
vector180:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $180
80106b0d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b12:	e9 57 f4 ff ff       	jmp    80105f6e <alltraps>

80106b17 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $181
80106b19:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b1e:	e9 4b f4 ff ff       	jmp    80105f6e <alltraps>

80106b23 <vector182>:
.globl vector182
vector182:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $182
80106b25:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b2a:	e9 3f f4 ff ff       	jmp    80105f6e <alltraps>

80106b2f <vector183>:
.globl vector183
vector183:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $183
80106b31:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b36:	e9 33 f4 ff ff       	jmp    80105f6e <alltraps>

80106b3b <vector184>:
.globl vector184
vector184:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $184
80106b3d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b42:	e9 27 f4 ff ff       	jmp    80105f6e <alltraps>

80106b47 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $185
80106b49:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b4e:	e9 1b f4 ff ff       	jmp    80105f6e <alltraps>

80106b53 <vector186>:
.globl vector186
vector186:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $186
80106b55:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b5a:	e9 0f f4 ff ff       	jmp    80105f6e <alltraps>

80106b5f <vector187>:
.globl vector187
vector187:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $187
80106b61:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b66:	e9 03 f4 ff ff       	jmp    80105f6e <alltraps>

80106b6b <vector188>:
.globl vector188
vector188:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $188
80106b6d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b72:	e9 f7 f3 ff ff       	jmp    80105f6e <alltraps>

80106b77 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $189
80106b79:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b7e:	e9 eb f3 ff ff       	jmp    80105f6e <alltraps>

80106b83 <vector190>:
.globl vector190
vector190:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $190
80106b85:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b8a:	e9 df f3 ff ff       	jmp    80105f6e <alltraps>

80106b8f <vector191>:
.globl vector191
vector191:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $191
80106b91:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b96:	e9 d3 f3 ff ff       	jmp    80105f6e <alltraps>

80106b9b <vector192>:
.globl vector192
vector192:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $192
80106b9d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106ba2:	e9 c7 f3 ff ff       	jmp    80105f6e <alltraps>

80106ba7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $193
80106ba9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106bae:	e9 bb f3 ff ff       	jmp    80105f6e <alltraps>

80106bb3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $194
80106bb5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106bba:	e9 af f3 ff ff       	jmp    80105f6e <alltraps>

80106bbf <vector195>:
.globl vector195
vector195:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $195
80106bc1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106bc6:	e9 a3 f3 ff ff       	jmp    80105f6e <alltraps>

80106bcb <vector196>:
.globl vector196
vector196:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $196
80106bcd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bd2:	e9 97 f3 ff ff       	jmp    80105f6e <alltraps>

80106bd7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $197
80106bd9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106bde:	e9 8b f3 ff ff       	jmp    80105f6e <alltraps>

80106be3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $198
80106be5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106bea:	e9 7f f3 ff ff       	jmp    80105f6e <alltraps>

80106bef <vector199>:
.globl vector199
vector199:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $199
80106bf1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106bf6:	e9 73 f3 ff ff       	jmp    80105f6e <alltraps>

80106bfb <vector200>:
.globl vector200
vector200:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $200
80106bfd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c02:	e9 67 f3 ff ff       	jmp    80105f6e <alltraps>

80106c07 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $201
80106c09:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c0e:	e9 5b f3 ff ff       	jmp    80105f6e <alltraps>

80106c13 <vector202>:
.globl vector202
vector202:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $202
80106c15:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c1a:	e9 4f f3 ff ff       	jmp    80105f6e <alltraps>

80106c1f <vector203>:
.globl vector203
vector203:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $203
80106c21:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c26:	e9 43 f3 ff ff       	jmp    80105f6e <alltraps>

80106c2b <vector204>:
.globl vector204
vector204:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $204
80106c2d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c32:	e9 37 f3 ff ff       	jmp    80105f6e <alltraps>

80106c37 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $205
80106c39:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c3e:	e9 2b f3 ff ff       	jmp    80105f6e <alltraps>

80106c43 <vector206>:
.globl vector206
vector206:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $206
80106c45:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c4a:	e9 1f f3 ff ff       	jmp    80105f6e <alltraps>

80106c4f <vector207>:
.globl vector207
vector207:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $207
80106c51:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c56:	e9 13 f3 ff ff       	jmp    80105f6e <alltraps>

80106c5b <vector208>:
.globl vector208
vector208:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $208
80106c5d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c62:	e9 07 f3 ff ff       	jmp    80105f6e <alltraps>

80106c67 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $209
80106c69:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c6e:	e9 fb f2 ff ff       	jmp    80105f6e <alltraps>

80106c73 <vector210>:
.globl vector210
vector210:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $210
80106c75:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c7a:	e9 ef f2 ff ff       	jmp    80105f6e <alltraps>

80106c7f <vector211>:
.globl vector211
vector211:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $211
80106c81:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c86:	e9 e3 f2 ff ff       	jmp    80105f6e <alltraps>

80106c8b <vector212>:
.globl vector212
vector212:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $212
80106c8d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c92:	e9 d7 f2 ff ff       	jmp    80105f6e <alltraps>

80106c97 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $213
80106c99:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c9e:	e9 cb f2 ff ff       	jmp    80105f6e <alltraps>

80106ca3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $214
80106ca5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106caa:	e9 bf f2 ff ff       	jmp    80105f6e <alltraps>

80106caf <vector215>:
.globl vector215
vector215:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $215
80106cb1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106cb6:	e9 b3 f2 ff ff       	jmp    80105f6e <alltraps>

80106cbb <vector216>:
.globl vector216
vector216:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $216
80106cbd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106cc2:	e9 a7 f2 ff ff       	jmp    80105f6e <alltraps>

80106cc7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $217
80106cc9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106cce:	e9 9b f2 ff ff       	jmp    80105f6e <alltraps>

80106cd3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $218
80106cd5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106cda:	e9 8f f2 ff ff       	jmp    80105f6e <alltraps>

80106cdf <vector219>:
.globl vector219
vector219:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $219
80106ce1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ce6:	e9 83 f2 ff ff       	jmp    80105f6e <alltraps>

80106ceb <vector220>:
.globl vector220
vector220:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $220
80106ced:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cf2:	e9 77 f2 ff ff       	jmp    80105f6e <alltraps>

80106cf7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $221
80106cf9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cfe:	e9 6b f2 ff ff       	jmp    80105f6e <alltraps>

80106d03 <vector222>:
.globl vector222
vector222:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $222
80106d05:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d0a:	e9 5f f2 ff ff       	jmp    80105f6e <alltraps>

80106d0f <vector223>:
.globl vector223
vector223:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $223
80106d11:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d16:	e9 53 f2 ff ff       	jmp    80105f6e <alltraps>

80106d1b <vector224>:
.globl vector224
vector224:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $224
80106d1d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d22:	e9 47 f2 ff ff       	jmp    80105f6e <alltraps>

80106d27 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $225
80106d29:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d2e:	e9 3b f2 ff ff       	jmp    80105f6e <alltraps>

80106d33 <vector226>:
.globl vector226
vector226:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $226
80106d35:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d3a:	e9 2f f2 ff ff       	jmp    80105f6e <alltraps>

80106d3f <vector227>:
.globl vector227
vector227:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $227
80106d41:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d46:	e9 23 f2 ff ff       	jmp    80105f6e <alltraps>

80106d4b <vector228>:
.globl vector228
vector228:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $228
80106d4d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d52:	e9 17 f2 ff ff       	jmp    80105f6e <alltraps>

80106d57 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $229
80106d59:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d5e:	e9 0b f2 ff ff       	jmp    80105f6e <alltraps>

80106d63 <vector230>:
.globl vector230
vector230:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $230
80106d65:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d6a:	e9 ff f1 ff ff       	jmp    80105f6e <alltraps>

80106d6f <vector231>:
.globl vector231
vector231:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $231
80106d71:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d76:	e9 f3 f1 ff ff       	jmp    80105f6e <alltraps>

80106d7b <vector232>:
.globl vector232
vector232:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $232
80106d7d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d82:	e9 e7 f1 ff ff       	jmp    80105f6e <alltraps>

80106d87 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $233
80106d89:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d8e:	e9 db f1 ff ff       	jmp    80105f6e <alltraps>

80106d93 <vector234>:
.globl vector234
vector234:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $234
80106d95:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d9a:	e9 cf f1 ff ff       	jmp    80105f6e <alltraps>

80106d9f <vector235>:
.globl vector235
vector235:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $235
80106da1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106da6:	e9 c3 f1 ff ff       	jmp    80105f6e <alltraps>

80106dab <vector236>:
.globl vector236
vector236:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $236
80106dad:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106db2:	e9 b7 f1 ff ff       	jmp    80105f6e <alltraps>

80106db7 <vector237>:
.globl vector237
vector237:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $237
80106db9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106dbe:	e9 ab f1 ff ff       	jmp    80105f6e <alltraps>

80106dc3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $238
80106dc5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106dca:	e9 9f f1 ff ff       	jmp    80105f6e <alltraps>

80106dcf <vector239>:
.globl vector239
vector239:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $239
80106dd1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106dd6:	e9 93 f1 ff ff       	jmp    80105f6e <alltraps>

80106ddb <vector240>:
.globl vector240
vector240:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $240
80106ddd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106de2:	e9 87 f1 ff ff       	jmp    80105f6e <alltraps>

80106de7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $241
80106de9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106dee:	e9 7b f1 ff ff       	jmp    80105f6e <alltraps>

80106df3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $242
80106df5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106dfa:	e9 6f f1 ff ff       	jmp    80105f6e <alltraps>

80106dff <vector243>:
.globl vector243
vector243:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $243
80106e01:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e06:	e9 63 f1 ff ff       	jmp    80105f6e <alltraps>

80106e0b <vector244>:
.globl vector244
vector244:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $244
80106e0d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e12:	e9 57 f1 ff ff       	jmp    80105f6e <alltraps>

80106e17 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $245
80106e19:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e1e:	e9 4b f1 ff ff       	jmp    80105f6e <alltraps>

80106e23 <vector246>:
.globl vector246
vector246:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $246
80106e25:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e2a:	e9 3f f1 ff ff       	jmp    80105f6e <alltraps>

80106e2f <vector247>:
.globl vector247
vector247:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $247
80106e31:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e36:	e9 33 f1 ff ff       	jmp    80105f6e <alltraps>

80106e3b <vector248>:
.globl vector248
vector248:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $248
80106e3d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e42:	e9 27 f1 ff ff       	jmp    80105f6e <alltraps>

80106e47 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $249
80106e49:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e4e:	e9 1b f1 ff ff       	jmp    80105f6e <alltraps>

80106e53 <vector250>:
.globl vector250
vector250:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $250
80106e55:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e5a:	e9 0f f1 ff ff       	jmp    80105f6e <alltraps>

80106e5f <vector251>:
.globl vector251
vector251:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $251
80106e61:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e66:	e9 03 f1 ff ff       	jmp    80105f6e <alltraps>

80106e6b <vector252>:
.globl vector252
vector252:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $252
80106e6d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e72:	e9 f7 f0 ff ff       	jmp    80105f6e <alltraps>

80106e77 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $253
80106e79:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e7e:	e9 eb f0 ff ff       	jmp    80105f6e <alltraps>

80106e83 <vector254>:
.globl vector254
vector254:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $254
80106e85:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e8a:	e9 df f0 ff ff       	jmp    80105f6e <alltraps>

80106e8f <vector255>:
.globl vector255
vector255:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $255
80106e91:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e96:	e9 d3 f0 ff ff       	jmp    80105f6e <alltraps>
80106e9b:	66 90                	xchg   %ax,%ax
80106e9d:	66 90                	xchg   %ax,%ax
80106e9f:	90                   	nop

80106ea0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ea7:	c1 ea 16             	shr    $0x16,%edx
{
80106eaa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106eab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106eae:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106eb1:	8b 1f                	mov    (%edi),%ebx
80106eb3:	f6 c3 01             	test   $0x1,%bl
80106eb6:	74 28                	je     80106ee0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106eb8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106ebe:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ec4:	89 f0                	mov    %esi,%eax
}
80106ec6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106ec9:	c1 e8 0a             	shr    $0xa,%eax
80106ecc:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ed1:	01 d8                	add    %ebx,%eax
}
80106ed3:	5b                   	pop    %ebx
80106ed4:	5e                   	pop    %esi
80106ed5:	5f                   	pop    %edi
80106ed6:	5d                   	pop    %ebp
80106ed7:	c3                   	ret
80106ed8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106edf:	00 
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ee0:	85 c9                	test   %ecx,%ecx
80106ee2:	74 2c                	je     80106f10 <walkpgdir+0x70>
80106ee4:	e8 d7 b7 ff ff       	call   801026c0 <kalloc>
80106ee9:	89 c3                	mov    %eax,%ebx
80106eeb:	85 c0                	test   %eax,%eax
80106eed:	74 21                	je     80106f10 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106eef:	83 ec 04             	sub    $0x4,%esp
80106ef2:	68 00 10 00 00       	push   $0x1000
80106ef7:	6a 00                	push   $0x0
80106ef9:	50                   	push   %eax
80106efa:	e8 51 da ff ff       	call   80104950 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106eff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f05:	83 c4 10             	add    $0x10,%esp
80106f08:	83 c8 07             	or     $0x7,%eax
80106f0b:	89 07                	mov    %eax,(%edi)
80106f0d:	eb b5                	jmp    80106ec4 <walkpgdir+0x24>
80106f0f:	90                   	nop
}
80106f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106f13:	31 c0                	xor    %eax,%eax
}
80106f15:	5b                   	pop    %ebx
80106f16:	5e                   	pop    %esi
80106f17:	5f                   	pop    %edi
80106f18:	5d                   	pop    %ebp
80106f19:	c3                   	ret
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f20 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f26:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106f2a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106f30:	89 d6                	mov    %edx,%esi
{
80106f32:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106f33:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106f39:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f42:	29 f0                	sub    %esi,%eax
80106f44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f47:	eb 1f                	jmp    80106f68 <mappages+0x48>
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106f50:	f6 00 01             	testb  $0x1,(%eax)
80106f53:	75 45                	jne    80106f9a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f55:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106f58:	83 cb 01             	or     $0x1,%ebx
80106f5b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106f5d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106f60:	74 2e                	je     80106f90 <mappages+0x70>
      break;
    a += PGSIZE;
80106f62:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106f68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f6b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f70:	89 f2                	mov    %esi,%edx
80106f72:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106f75:	89 f8                	mov    %edi,%eax
80106f77:	e8 24 ff ff ff       	call   80106ea0 <walkpgdir>
80106f7c:	85 c0                	test   %eax,%eax
80106f7e:	75 d0                	jne    80106f50 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f88:	5b                   	pop    %ebx
80106f89:	5e                   	pop    %esi
80106f8a:	5f                   	pop    %edi
80106f8b:	5d                   	pop    %ebp
80106f8c:	c3                   	ret
80106f8d:	8d 76 00             	lea    0x0(%esi),%esi
80106f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f93:	31 c0                	xor    %eax,%eax
}
80106f95:	5b                   	pop    %ebx
80106f96:	5e                   	pop    %esi
80106f97:	5f                   	pop    %edi
80106f98:	5d                   	pop    %ebp
80106f99:	c3                   	ret
      panic("remap");
80106f9a:	83 ec 0c             	sub    $0xc,%esp
80106f9d:	68 8d 7c 10 80       	push   $0x80107c8d
80106fa2:	e8 e9 93 ff ff       	call   80100390 <panic>
80106fa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fae:	00 
80106faf:	90                   	nop

80106fb0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	89 c6                	mov    %eax,%esi
80106fb7:	53                   	push   %ebx
80106fb8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106fba:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106fc0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fc6:	83 ec 1c             	sub    $0x1c,%esp
80106fc9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106fcc:	39 da                	cmp    %ebx,%edx
80106fce:	73 5b                	jae    8010702b <deallocuvm.part.0+0x7b>
80106fd0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106fd3:	89 d7                	mov    %edx,%edi
80106fd5:	eb 14                	jmp    80106feb <deallocuvm.part.0+0x3b>
80106fd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fde:	00 
80106fdf:	90                   	nop
80106fe0:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106fe6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106fe9:	76 40                	jbe    8010702b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106feb:	31 c9                	xor    %ecx,%ecx
80106fed:	89 fa                	mov    %edi,%edx
80106fef:	89 f0                	mov    %esi,%eax
80106ff1:	e8 aa fe ff ff       	call   80106ea0 <walkpgdir>
80106ff6:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106ff8:	85 c0                	test   %eax,%eax
80106ffa:	74 44                	je     80107040 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106ffc:	8b 00                	mov    (%eax),%eax
80106ffe:	a8 01                	test   $0x1,%al
80107000:	74 de                	je     80106fe0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107002:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107007:	74 47                	je     80107050 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107009:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010700c:	05 00 00 00 80       	add    $0x80000000,%eax
80107011:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107017:	50                   	push   %eax
80107018:	e8 e3 b4 ff ff       	call   80102500 <kfree>
      *pte = 0;
8010701d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107023:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107026:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107029:	77 c0                	ja     80106feb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010702b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010702e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107031:	5b                   	pop    %ebx
80107032:	5e                   	pop    %esi
80107033:	5f                   	pop    %edi
80107034:	5d                   	pop    %ebp
80107035:	c3                   	ret
80107036:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010703d:	00 
8010703e:	66 90                	xchg   %ax,%ax
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107040:	89 fa                	mov    %edi,%edx
80107042:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107048:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010704e:	eb 96                	jmp    80106fe6 <deallocuvm.part.0+0x36>
        panic("kfree");
80107050:	83 ec 0c             	sub    $0xc,%esp
80107053:	68 c9 79 10 80       	push   $0x801079c9
80107058:	e8 33 93 ff ff       	call   80100390 <panic>
8010705d:	8d 76 00             	lea    0x0(%esi),%esi

80107060 <seginit>:
{
80107060:	f3 0f 1e fb          	endbr32
80107064:	55                   	push   %ebp
80107065:	89 e5                	mov    %esp,%ebp
80107067:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010706a:	e8 a1 c9 ff ff       	call   80103a10 <cpuid>
  pd[0] = size-1;
8010706f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107074:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010707a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010707e:	c7 80 d8 38 11 80 ff 	movl   $0xffff,-0x7feec728(%eax)
80107085:	ff 00 00 
80107088:	c7 80 dc 38 11 80 00 	movl   $0xcf9a00,-0x7feec724(%eax)
8010708f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107092:	c7 80 e0 38 11 80 ff 	movl   $0xffff,-0x7feec720(%eax)
80107099:	ff 00 00 
8010709c:	c7 80 e4 38 11 80 00 	movl   $0xcf9200,-0x7feec71c(%eax)
801070a3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070a6:	c7 80 e8 38 11 80 ff 	movl   $0xffff,-0x7feec718(%eax)
801070ad:	ff 00 00 
801070b0:	c7 80 ec 38 11 80 00 	movl   $0xcffa00,-0x7feec714(%eax)
801070b7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801070ba:	c7 80 f0 38 11 80 ff 	movl   $0xffff,-0x7feec710(%eax)
801070c1:	ff 00 00 
801070c4:	c7 80 f4 38 11 80 00 	movl   $0xcff200,-0x7feec70c(%eax)
801070cb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801070ce:	05 d0 38 11 80       	add    $0x801138d0,%eax
  pd[1] = (uint)p;
801070d3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801070d7:	c1 e8 10             	shr    $0x10,%eax
801070da:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801070de:	8d 45 f2             	lea    -0xe(%ebp),%eax
801070e1:	0f 01 10             	lgdtl  (%eax)
}
801070e4:	c9                   	leave
801070e5:	c3                   	ret
801070e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070ed:	00 
801070ee:	66 90                	xchg   %ax,%ax

801070f0 <switchkvm>:
{
801070f0:	f3 0f 1e fb          	endbr32
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070f4:	a1 84 88 11 80       	mov    0x80118884,%eax
801070f9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070fe:	0f 22 d8             	mov    %eax,%cr3
}
80107101:	c3                   	ret
80107102:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107109:	00 
8010710a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107110 <switchuvm>:
{
80107110:	f3 0f 1e fb          	endbr32
80107114:	55                   	push   %ebp
80107115:	89 e5                	mov    %esp,%ebp
80107117:	57                   	push   %edi
80107118:	56                   	push   %esi
80107119:	53                   	push   %ebx
8010711a:	83 ec 1c             	sub    $0x1c,%esp
8010711d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107120:	85 f6                	test   %esi,%esi
80107122:	0f 84 cb 00 00 00    	je     801071f3 <switchuvm+0xe3>
  if(p->kstack == 0)
80107128:	8b 46 08             	mov    0x8(%esi),%eax
8010712b:	85 c0                	test   %eax,%eax
8010712d:	0f 84 da 00 00 00    	je     8010720d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107133:	8b 46 04             	mov    0x4(%esi),%eax
80107136:	85 c0                	test   %eax,%eax
80107138:	0f 84 c2 00 00 00    	je     80107200 <switchuvm+0xf0>
  pushcli();
8010713e:	e8 fd d5 ff ff       	call   80104740 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107143:	e8 58 c8 ff ff       	call   801039a0 <mycpu>
80107148:	89 c3                	mov    %eax,%ebx
8010714a:	e8 51 c8 ff ff       	call   801039a0 <mycpu>
8010714f:	89 c7                	mov    %eax,%edi
80107151:	e8 4a c8 ff ff       	call   801039a0 <mycpu>
80107156:	83 c7 08             	add    $0x8,%edi
80107159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010715c:	e8 3f c8 ff ff       	call   801039a0 <mycpu>
80107161:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107164:	ba 67 00 00 00       	mov    $0x67,%edx
80107169:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107170:	83 c0 08             	add    $0x8,%eax
80107173:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010717a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010717f:	83 c1 08             	add    $0x8,%ecx
80107182:	c1 e8 18             	shr    $0x18,%eax
80107185:	c1 e9 10             	shr    $0x10,%ecx
80107188:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010718e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107194:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107199:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071a0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801071a5:	e8 f6 c7 ff ff       	call   801039a0 <mycpu>
801071aa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071b1:	e8 ea c7 ff ff       	call   801039a0 <mycpu>
801071b6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801071ba:	8b 5e 08             	mov    0x8(%esi),%ebx
801071bd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071c3:	e8 d8 c7 ff ff       	call   801039a0 <mycpu>
801071c8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071cb:	e8 d0 c7 ff ff       	call   801039a0 <mycpu>
801071d0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801071d4:	b8 28 00 00 00       	mov    $0x28,%eax
801071d9:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801071dc:	8b 46 04             	mov    0x4(%esi),%eax
801071df:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071e4:	0f 22 d8             	mov    %eax,%cr3
}
801071e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ea:	5b                   	pop    %ebx
801071eb:	5e                   	pop    %esi
801071ec:	5f                   	pop    %edi
801071ed:	5d                   	pop    %ebp
  popcli();
801071ee:	e9 9d d5 ff ff       	jmp    80104790 <popcli>
    panic("switchuvm: no process");
801071f3:	83 ec 0c             	sub    $0xc,%esp
801071f6:	68 93 7c 10 80       	push   $0x80107c93
801071fb:	e8 90 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107200:	83 ec 0c             	sub    $0xc,%esp
80107203:	68 be 7c 10 80       	push   $0x80107cbe
80107208:	e8 83 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010720d:	83 ec 0c             	sub    $0xc,%esp
80107210:	68 a9 7c 10 80       	push   $0x80107ca9
80107215:	e8 76 91 ff ff       	call   80100390 <panic>
8010721a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107220 <inituvm>:
{
80107220:	f3 0f 1e fb          	endbr32
80107224:	55                   	push   %ebp
80107225:	89 e5                	mov    %esp,%ebp
80107227:	57                   	push   %edi
80107228:	56                   	push   %esi
80107229:	53                   	push   %ebx
8010722a:	83 ec 1c             	sub    $0x1c,%esp
8010722d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107230:	8b 75 10             	mov    0x10(%ebp),%esi
80107233:	8b 7d 08             	mov    0x8(%ebp),%edi
80107236:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107239:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010723f:	77 4b                	ja     8010728c <inituvm+0x6c>
  mem = kalloc();
80107241:	e8 7a b4 ff ff       	call   801026c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107246:	83 ec 04             	sub    $0x4,%esp
80107249:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010724e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107250:	6a 00                	push   $0x0
80107252:	50                   	push   %eax
80107253:	e8 f8 d6 ff ff       	call   80104950 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107258:	58                   	pop    %eax
80107259:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010725f:	5a                   	pop    %edx
80107260:	6a 06                	push   $0x6
80107262:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107267:	31 d2                	xor    %edx,%edx
80107269:	50                   	push   %eax
8010726a:	89 f8                	mov    %edi,%eax
8010726c:	e8 af fc ff ff       	call   80106f20 <mappages>
  memmove(mem, init, sz);
80107271:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107274:	89 75 10             	mov    %esi,0x10(%ebp)
80107277:	83 c4 10             	add    $0x10,%esp
8010727a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010727d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107283:	5b                   	pop    %ebx
80107284:	5e                   	pop    %esi
80107285:	5f                   	pop    %edi
80107286:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107287:	e9 64 d7 ff ff       	jmp    801049f0 <memmove>
    panic("inituvm: more than a page");
8010728c:	83 ec 0c             	sub    $0xc,%esp
8010728f:	68 d2 7c 10 80       	push   $0x80107cd2
80107294:	e8 f7 90 ff ff       	call   80100390 <panic>
80107299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072a0 <loaduvm>:
{
801072a0:	f3 0f 1e fb          	endbr32
801072a4:	55                   	push   %ebp
801072a5:	89 e5                	mov    %esp,%ebp
801072a7:	57                   	push   %edi
801072a8:	56                   	push   %esi
801072a9:	53                   	push   %ebx
801072aa:	83 ec 1c             	sub    $0x1c,%esp
801072ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801072b0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801072b3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801072b8:	0f 85 99 00 00 00    	jne    80107357 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
801072be:	01 f0                	add    %esi,%eax
801072c0:	89 f3                	mov    %esi,%ebx
801072c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072c5:	8b 45 14             	mov    0x14(%ebp),%eax
801072c8:	01 f0                	add    %esi,%eax
801072ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801072cd:	85 f6                	test   %esi,%esi
801072cf:	75 15                	jne    801072e6 <loaduvm+0x46>
801072d1:	eb 6d                	jmp    80107340 <loaduvm+0xa0>
801072d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801072d8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801072de:	89 f0                	mov    %esi,%eax
801072e0:	29 d8                	sub    %ebx,%eax
801072e2:	39 c6                	cmp    %eax,%esi
801072e4:	76 5a                	jbe    80107340 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801072e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801072e9:	8b 45 08             	mov    0x8(%ebp),%eax
801072ec:	31 c9                	xor    %ecx,%ecx
801072ee:	29 da                	sub    %ebx,%edx
801072f0:	e8 ab fb ff ff       	call   80106ea0 <walkpgdir>
801072f5:	85 c0                	test   %eax,%eax
801072f7:	74 51                	je     8010734a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801072f9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072fb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801072fe:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107303:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107308:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010730e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107311:	29 d9                	sub    %ebx,%ecx
80107313:	05 00 00 00 80       	add    $0x80000000,%eax
80107318:	57                   	push   %edi
80107319:	51                   	push   %ecx
8010731a:	50                   	push   %eax
8010731b:	ff 75 10             	push   0x10(%ebp)
8010731e:	e8 cd a7 ff ff       	call   80101af0 <readi>
80107323:	83 c4 10             	add    $0x10,%esp
80107326:	39 f8                	cmp    %edi,%eax
80107328:	74 ae                	je     801072d8 <loaduvm+0x38>
}
8010732a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010732d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107332:	5b                   	pop    %ebx
80107333:	5e                   	pop    %esi
80107334:	5f                   	pop    %edi
80107335:	5d                   	pop    %ebp
80107336:	c3                   	ret
80107337:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010733e:	00 
8010733f:	90                   	nop
80107340:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107343:	31 c0                	xor    %eax,%eax
}
80107345:	5b                   	pop    %ebx
80107346:	5e                   	pop    %esi
80107347:	5f                   	pop    %edi
80107348:	5d                   	pop    %ebp
80107349:	c3                   	ret
      panic("loaduvm: address should exist");
8010734a:	83 ec 0c             	sub    $0xc,%esp
8010734d:	68 ec 7c 10 80       	push   $0x80107cec
80107352:	e8 39 90 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107357:	83 ec 0c             	sub    $0xc,%esp
8010735a:	68 30 7f 10 80       	push   $0x80107f30
8010735f:	e8 2c 90 ff ff       	call   80100390 <panic>
80107364:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010736b:	00 
8010736c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107370 <allocuvm>:
{
80107370:	f3 0f 1e fb          	endbr32
80107374:	55                   	push   %ebp
80107375:	89 e5                	mov    %esp,%ebp
80107377:	57                   	push   %edi
80107378:	56                   	push   %esi
80107379:	53                   	push   %ebx
8010737a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010737d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107380:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107383:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107386:	85 c0                	test   %eax,%eax
80107388:	0f 88 b2 00 00 00    	js     80107440 <allocuvm+0xd0>
  if(newsz < oldsz)
8010738e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107391:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107394:	0f 82 96 00 00 00    	jb     80107430 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010739a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801073a0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801073a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801073a9:	77 40                	ja     801073eb <allocuvm+0x7b>
801073ab:	e9 83 00 00 00       	jmp    80107433 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
801073b0:	83 ec 04             	sub    $0x4,%esp
801073b3:	68 00 10 00 00       	push   $0x1000
801073b8:	6a 00                	push   $0x0
801073ba:	50                   	push   %eax
801073bb:	e8 90 d5 ff ff       	call   80104950 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801073c0:	58                   	pop    %eax
801073c1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073c7:	5a                   	pop    %edx
801073c8:	6a 06                	push   $0x6
801073ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073cf:	89 f2                	mov    %esi,%edx
801073d1:	50                   	push   %eax
801073d2:	89 f8                	mov    %edi,%eax
801073d4:	e8 47 fb ff ff       	call   80106f20 <mappages>
801073d9:	83 c4 10             	add    $0x10,%esp
801073dc:	85 c0                	test   %eax,%eax
801073de:	78 78                	js     80107458 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801073e0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073e6:	39 75 10             	cmp    %esi,0x10(%ebp)
801073e9:	76 48                	jbe    80107433 <allocuvm+0xc3>
    mem = kalloc();
801073eb:	e8 d0 b2 ff ff       	call   801026c0 <kalloc>
801073f0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801073f2:	85 c0                	test   %eax,%eax
801073f4:	75 ba                	jne    801073b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801073f6:	83 ec 0c             	sub    $0xc,%esp
801073f9:	68 0a 7d 10 80       	push   $0x80107d0a
801073fe:	e8 ad 92 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107403:	8b 45 0c             	mov    0xc(%ebp),%eax
80107406:	83 c4 10             	add    $0x10,%esp
80107409:	39 45 10             	cmp    %eax,0x10(%ebp)
8010740c:	74 32                	je     80107440 <allocuvm+0xd0>
8010740e:	8b 55 10             	mov    0x10(%ebp),%edx
80107411:	89 c1                	mov    %eax,%ecx
80107413:	89 f8                	mov    %edi,%eax
80107415:	e8 96 fb ff ff       	call   80106fb0 <deallocuvm.part.0>
      return 0;
8010741a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107424:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107427:	5b                   	pop    %ebx
80107428:	5e                   	pop    %esi
80107429:	5f                   	pop    %edi
8010742a:	5d                   	pop    %ebp
8010742b:	c3                   	ret
8010742c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107430:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107436:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107439:	5b                   	pop    %ebx
8010743a:	5e                   	pop    %esi
8010743b:	5f                   	pop    %edi
8010743c:	5d                   	pop    %ebp
8010743d:	c3                   	ret
8010743e:	66 90                	xchg   %ax,%ax
    return 0;
80107440:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010744a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010744d:	5b                   	pop    %ebx
8010744e:	5e                   	pop    %esi
8010744f:	5f                   	pop    %edi
80107450:	5d                   	pop    %ebp
80107451:	c3                   	ret
80107452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107458:	83 ec 0c             	sub    $0xc,%esp
8010745b:	68 22 7d 10 80       	push   $0x80107d22
80107460:	e8 4b 92 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107465:	8b 45 0c             	mov    0xc(%ebp),%eax
80107468:	83 c4 10             	add    $0x10,%esp
8010746b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010746e:	74 0c                	je     8010747c <allocuvm+0x10c>
80107470:	8b 55 10             	mov    0x10(%ebp),%edx
80107473:	89 c1                	mov    %eax,%ecx
80107475:	89 f8                	mov    %edi,%eax
80107477:	e8 34 fb ff ff       	call   80106fb0 <deallocuvm.part.0>
      kfree(mem);
8010747c:	83 ec 0c             	sub    $0xc,%esp
8010747f:	53                   	push   %ebx
80107480:	e8 7b b0 ff ff       	call   80102500 <kfree>
      return 0;
80107485:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010748c:	83 c4 10             	add    $0x10,%esp
}
8010748f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107492:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107495:	5b                   	pop    %ebx
80107496:	5e                   	pop    %esi
80107497:	5f                   	pop    %edi
80107498:	5d                   	pop    %ebp
80107499:	c3                   	ret
8010749a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074a0 <deallocuvm>:
{
801074a0:	f3 0f 1e fb          	endbr32
801074a4:	55                   	push   %ebp
801074a5:	89 e5                	mov    %esp,%ebp
801074a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801074aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
801074ad:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801074b0:	39 d1                	cmp    %edx,%ecx
801074b2:	73 0c                	jae    801074c0 <deallocuvm+0x20>
}
801074b4:	5d                   	pop    %ebp
801074b5:	e9 f6 fa ff ff       	jmp    80106fb0 <deallocuvm.part.0>
801074ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074c0:	89 d0                	mov    %edx,%eax
801074c2:	5d                   	pop    %ebp
801074c3:	c3                   	ret
801074c4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074cb:	00 
801074cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801074d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801074d0:	f3 0f 1e fb          	endbr32
801074d4:	55                   	push   %ebp
801074d5:	89 e5                	mov    %esp,%ebp
801074d7:	57                   	push   %edi
801074d8:	56                   	push   %esi
801074d9:	53                   	push   %ebx
801074da:	83 ec 0c             	sub    $0xc,%esp
801074dd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801074e0:	85 f6                	test   %esi,%esi
801074e2:	74 55                	je     80107539 <freevm+0x69>
  if(newsz >= oldsz)
801074e4:	31 c9                	xor    %ecx,%ecx
801074e6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801074eb:	89 f0                	mov    %esi,%eax
801074ed:	89 f3                	mov    %esi,%ebx
801074ef:	e8 bc fa ff ff       	call   80106fb0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801074f4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801074fa:	eb 0b                	jmp    80107507 <freevm+0x37>
801074fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107500:	83 c3 04             	add    $0x4,%ebx
80107503:	39 df                	cmp    %ebx,%edi
80107505:	74 23                	je     8010752a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107507:	8b 03                	mov    (%ebx),%eax
80107509:	a8 01                	test   $0x1,%al
8010750b:	74 f3                	je     80107500 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010750d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107512:	83 ec 0c             	sub    $0xc,%esp
80107515:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107518:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010751d:	50                   	push   %eax
8010751e:	e8 dd af ff ff       	call   80102500 <kfree>
80107523:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107526:	39 df                	cmp    %ebx,%edi
80107528:	75 dd                	jne    80107507 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010752a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010752d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107530:	5b                   	pop    %ebx
80107531:	5e                   	pop    %esi
80107532:	5f                   	pop    %edi
80107533:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107534:	e9 c7 af ff ff       	jmp    80102500 <kfree>
    panic("freevm: no pgdir");
80107539:	83 ec 0c             	sub    $0xc,%esp
8010753c:	68 3e 7d 10 80       	push   $0x80107d3e
80107541:	e8 4a 8e ff ff       	call   80100390 <panic>
80107546:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010754d:	00 
8010754e:	66 90                	xchg   %ax,%ax

80107550 <setupkvm>:
{
80107550:	f3 0f 1e fb          	endbr32
80107554:	55                   	push   %ebp
80107555:	89 e5                	mov    %esp,%ebp
80107557:	56                   	push   %esi
80107558:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107559:	e8 62 b1 ff ff       	call   801026c0 <kalloc>
8010755e:	89 c6                	mov    %eax,%esi
80107560:	85 c0                	test   %eax,%eax
80107562:	74 42                	je     801075a6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107564:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107567:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010756c:	68 00 10 00 00       	push   $0x1000
80107571:	6a 00                	push   $0x0
80107573:	50                   	push   %eax
80107574:	e8 d7 d3 ff ff       	call   80104950 <memset>
80107579:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010757c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010757f:	83 ec 08             	sub    $0x8,%esp
80107582:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107585:	ff 73 0c             	push   0xc(%ebx)
80107588:	8b 13                	mov    (%ebx),%edx
8010758a:	50                   	push   %eax
8010758b:	29 c1                	sub    %eax,%ecx
8010758d:	89 f0                	mov    %esi,%eax
8010758f:	e8 8c f9 ff ff       	call   80106f20 <mappages>
80107594:	83 c4 10             	add    $0x10,%esp
80107597:	85 c0                	test   %eax,%eax
80107599:	78 15                	js     801075b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010759b:	83 c3 10             	add    $0x10,%ebx
8010759e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801075a4:	75 d6                	jne    8010757c <setupkvm+0x2c>
}
801075a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075a9:	89 f0                	mov    %esi,%eax
801075ab:	5b                   	pop    %ebx
801075ac:	5e                   	pop    %esi
801075ad:	5d                   	pop    %ebp
801075ae:	c3                   	ret
801075af:	90                   	nop
      freevm(pgdir);
801075b0:	83 ec 0c             	sub    $0xc,%esp
801075b3:	56                   	push   %esi
      return 0;
801075b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801075b6:	e8 15 ff ff ff       	call   801074d0 <freevm>
      return 0;
801075bb:	83 c4 10             	add    $0x10,%esp
}
801075be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075c1:	89 f0                	mov    %esi,%eax
801075c3:	5b                   	pop    %ebx
801075c4:	5e                   	pop    %esi
801075c5:	5d                   	pop    %ebp
801075c6:	c3                   	ret
801075c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075ce:	00 
801075cf:	90                   	nop

801075d0 <kvmalloc>:
{
801075d0:	f3 0f 1e fb          	endbr32
801075d4:	55                   	push   %ebp
801075d5:	89 e5                	mov    %esp,%ebp
801075d7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801075da:	e8 71 ff ff ff       	call   80107550 <setupkvm>
801075df:	a3 84 88 11 80       	mov    %eax,0x80118884
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801075e4:	05 00 00 00 80       	add    $0x80000000,%eax
801075e9:	0f 22 d8             	mov    %eax,%cr3
}
801075ec:	c9                   	leave
801075ed:	c3                   	ret
801075ee:	66 90                	xchg   %ax,%ax

801075f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075f0:	f3 0f 1e fb          	endbr32
801075f4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075f5:	31 c9                	xor    %ecx,%ecx
{
801075f7:	89 e5                	mov    %esp,%ebp
801075f9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801075fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801075ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107602:	e8 99 f8 ff ff       	call   80106ea0 <walkpgdir>
  if(pte == 0)
80107607:	85 c0                	test   %eax,%eax
80107609:	74 05                	je     80107610 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010760b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010760e:	c9                   	leave
8010760f:	c3                   	ret
    panic("clearpteu");
80107610:	83 ec 0c             	sub    $0xc,%esp
80107613:	68 4f 7d 10 80       	push   $0x80107d4f
80107618:	e8 73 8d ff ff       	call   80100390 <panic>
8010761d:	8d 76 00             	lea    0x0(%esi),%esi

80107620 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107620:	f3 0f 1e fb          	endbr32
80107624:	55                   	push   %ebp
80107625:	89 e5                	mov    %esp,%ebp
80107627:	57                   	push   %edi
80107628:	56                   	push   %esi
80107629:	53                   	push   %ebx
8010762a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010762d:	e8 1e ff ff ff       	call   80107550 <setupkvm>
80107632:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107635:	85 c0                	test   %eax,%eax
80107637:	0f 84 9b 00 00 00    	je     801076d8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010763d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107640:	85 c9                	test   %ecx,%ecx
80107642:	0f 84 90 00 00 00    	je     801076d8 <copyuvm+0xb8>
80107648:	31 f6                	xor    %esi,%esi
8010764a:	eb 46                	jmp    80107692 <copyuvm+0x72>
8010764c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107650:	83 ec 04             	sub    $0x4,%esp
80107653:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107659:	68 00 10 00 00       	push   $0x1000
8010765e:	57                   	push   %edi
8010765f:	50                   	push   %eax
80107660:	e8 8b d3 ff ff       	call   801049f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107665:	58                   	pop    %eax
80107666:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010766c:	5a                   	pop    %edx
8010766d:	ff 75 e4             	push   -0x1c(%ebp)
80107670:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107675:	89 f2                	mov    %esi,%edx
80107677:	50                   	push   %eax
80107678:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010767b:	e8 a0 f8 ff ff       	call   80106f20 <mappages>
80107680:	83 c4 10             	add    $0x10,%esp
80107683:	85 c0                	test   %eax,%eax
80107685:	78 61                	js     801076e8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107687:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010768d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107690:	76 46                	jbe    801076d8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107692:	8b 45 08             	mov    0x8(%ebp),%eax
80107695:	31 c9                	xor    %ecx,%ecx
80107697:	89 f2                	mov    %esi,%edx
80107699:	e8 02 f8 ff ff       	call   80106ea0 <walkpgdir>
8010769e:	85 c0                	test   %eax,%eax
801076a0:	74 61                	je     80107703 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801076a2:	8b 00                	mov    (%eax),%eax
801076a4:	a8 01                	test   $0x1,%al
801076a6:	74 4e                	je     801076f6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801076a8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801076aa:	25 ff 0f 00 00       	and    $0xfff,%eax
801076af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801076b2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801076b8:	e8 03 b0 ff ff       	call   801026c0 <kalloc>
801076bd:	89 c3                	mov    %eax,%ebx
801076bf:	85 c0                	test   %eax,%eax
801076c1:	75 8d                	jne    80107650 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801076c3:	83 ec 0c             	sub    $0xc,%esp
801076c6:	ff 75 e0             	push   -0x20(%ebp)
801076c9:	e8 02 fe ff ff       	call   801074d0 <freevm>
  return 0;
801076ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801076d5:	83 c4 10             	add    $0x10,%esp
}
801076d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076de:	5b                   	pop    %ebx
801076df:	5e                   	pop    %esi
801076e0:	5f                   	pop    %edi
801076e1:	5d                   	pop    %ebp
801076e2:	c3                   	ret
801076e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      kfree(mem);
801076e8:	83 ec 0c             	sub    $0xc,%esp
801076eb:	53                   	push   %ebx
801076ec:	e8 0f ae ff ff       	call   80102500 <kfree>
      goto bad;
801076f1:	83 c4 10             	add    $0x10,%esp
801076f4:	eb cd                	jmp    801076c3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801076f6:	83 ec 0c             	sub    $0xc,%esp
801076f9:	68 73 7d 10 80       	push   $0x80107d73
801076fe:	e8 8d 8c ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107703:	83 ec 0c             	sub    $0xc,%esp
80107706:	68 59 7d 10 80       	push   $0x80107d59
8010770b:	e8 80 8c ff ff       	call   80100390 <panic>

80107710 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107710:	f3 0f 1e fb          	endbr32
80107714:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107715:	31 c9                	xor    %ecx,%ecx
{
80107717:	89 e5                	mov    %esp,%ebp
80107719:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010771c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010771f:	8b 45 08             	mov    0x8(%ebp),%eax
80107722:	e8 79 f7 ff ff       	call   80106ea0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107727:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107729:	c9                   	leave
  if((*pte & PTE_U) == 0)
8010772a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010772c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107731:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107734:	05 00 00 00 80       	add    $0x80000000,%eax
80107739:	83 fa 05             	cmp    $0x5,%edx
8010773c:	ba 00 00 00 00       	mov    $0x0,%edx
80107741:	0f 45 c2             	cmovne %edx,%eax
}
80107744:	c3                   	ret
80107745:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010774c:	00 
8010774d:	8d 76 00             	lea    0x0(%esi),%esi

80107750 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107750:	f3 0f 1e fb          	endbr32
80107754:	55                   	push   %ebp
80107755:	89 e5                	mov    %esp,%ebp
80107757:	57                   	push   %edi
80107758:	56                   	push   %esi
80107759:	53                   	push   %ebx
8010775a:	83 ec 0c             	sub    $0xc,%esp
8010775d:	8b 75 14             	mov    0x14(%ebp),%esi
80107760:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107763:	85 f6                	test   %esi,%esi
80107765:	75 3c                	jne    801077a3 <copyout+0x53>
80107767:	eb 67                	jmp    801077d0 <copyout+0x80>
80107769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107770:	8b 55 0c             	mov    0xc(%ebp),%edx
80107773:	89 fb                	mov    %edi,%ebx
80107775:	29 d3                	sub    %edx,%ebx
80107777:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010777d:	39 f3                	cmp    %esi,%ebx
8010777f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107782:	29 fa                	sub    %edi,%edx
80107784:	83 ec 04             	sub    $0x4,%esp
80107787:	01 c2                	add    %eax,%edx
80107789:	53                   	push   %ebx
8010778a:	ff 75 10             	push   0x10(%ebp)
8010778d:	52                   	push   %edx
8010778e:	e8 5d d2 ff ff       	call   801049f0 <memmove>
    len -= n;
    buf += n;
80107793:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107796:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010779c:	83 c4 10             	add    $0x10,%esp
8010779f:	29 de                	sub    %ebx,%esi
801077a1:	74 2d                	je     801077d0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801077a3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801077a5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801077a8:	89 55 0c             	mov    %edx,0xc(%ebp)
801077ab:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801077b1:	57                   	push   %edi
801077b2:	ff 75 08             	push   0x8(%ebp)
801077b5:	e8 56 ff ff ff       	call   80107710 <uva2ka>
    if(pa0 == 0)
801077ba:	83 c4 10             	add    $0x10,%esp
801077bd:	85 c0                	test   %eax,%eax
801077bf:	75 af                	jne    80107770 <copyout+0x20>
  }
  return 0;
}
801077c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077c9:	5b                   	pop    %ebx
801077ca:	5e                   	pop    %esi
801077cb:	5f                   	pop    %edi
801077cc:	5d                   	pop    %ebp
801077cd:	c3                   	ret
801077ce:	66 90                	xchg   %ax,%ax
801077d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077d3:	31 c0                	xor    %eax,%eax
}
801077d5:	5b                   	pop    %ebx
801077d6:	5e                   	pop    %esi
801077d7:	5f                   	pop    %edi
801077d8:	5d                   	pop    %ebp
801077d9:	c3                   	ret
