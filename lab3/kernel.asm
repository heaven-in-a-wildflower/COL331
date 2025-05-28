
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
80100028:	bc 60 81 11 80       	mov    $0x80118160,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 30 10 80       	mov    $0x801030e0,%eax
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
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx


  
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 83 10 80       	push   $0x80108300
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 f5 49 00 00       	call   80104a50 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 83 10 80       	push   $0x80108307
80100097:	50                   	push   %eax
80100098:	e8 83 48 00 00       	call   80104920 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
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


struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 57 4b 00 00       	call   80104c40 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 79 4a 00 00       	call   80104be0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 47 00 00       	call   80104960 <acquiresleep>
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
8010018c:	e8 af 21 00 00       	call   80102340 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 83 10 80       	push   $0x8010830e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:


void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 3d 48 00 00       	call   80104a00 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 67 21 00 00       	jmp    80102340 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 83 10 80       	push   $0x8010831f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:



void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 47 00 00       	call   80104a00 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ac 47 00 00       	call   801049c0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 20 4a 00 00       	call   80104c40 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 72 49 00 00       	jmp    80104be0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 26 83 10 80       	push   $0x80108326
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 57 16 00 00       	call   801018f0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 9b 49 00 00       	call   80104c40 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 1e 3e 00 00       	call   801040f0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 39 37 00 00       	call   80103a20 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 e5 48 00 00       	call   80104be0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 0c 15 00 00       	call   80101810 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 8f 48 00 00       	call   80104be0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 b6 14 00 00       	call   80101810 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 e2 25 00 00       	call   80102980 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 83 10 80       	push   $0x8010832d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 6a 87 10 80 	movl   $0x8010876a,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 a3 46 00 00       	call   80104a70 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 83 10 80       	push   $0x80108341
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; 
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 8c 5f 00 00       	call   801063b0 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 c1 5e 00 00       	call   801063b0 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 b5 5e 00 00       	call   801063b0 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 a9 5e 00 00       	call   801063b0 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 6a 48 00 00       	call   80104dd0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 c5 47 00 00       	call   80104d40 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 45 83 10 80       	push   $0x80108345
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 2c 13 00 00       	call   801018f0 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005cb:	e8 70 46 00 00       	call   80104c40 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ff 10 80       	push   $0x8010ff20
80100604:	e8 d7 45 00 00       	call   80104be0 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 fe 11 00 00       	call   80101810 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 44 88 10 80 	movzbl -0x7fef77bc(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ff 10 80       	push   $0x8010ff20
801007d8:	e8 63 44 00 00       	call   80104c40 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ff 10 80       	push   $0x8010ff20
801007fb:	e8 e0 43 00 00       	call   80104be0 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 58 83 10 80       	mov    $0x80108358,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 5f 83 10 80       	push   $0x8010835f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 28             	sub    $0x28,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ff 10 80       	push   $0x8010ff20
801008b3:	e8 88 43 00 00       	call   80104c40 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
  int ctrli = 0;
801008bb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((c = getc()) >= 0){
801008c2:	ff d6                	call   *%esi
801008c4:	89 c3                	mov    %eax,%ebx
801008c6:	85 c0                	test   %eax,%eax
801008c8:	78 2c                	js     801008f6 <consoleintr+0x56>
    switch(c){
801008ca:	83 fb 10             	cmp    $0x10,%ebx
801008cd:	0f 84 3d 01 00 00    	je     80100a10 <consoleintr+0x170>
801008d3:	7f 53                	jg     80100928 <consoleintr+0x88>
801008d5:	83 fb 08             	cmp    $0x8,%ebx
801008d8:	0f 84 0a 01 00 00    	je     801009e8 <consoleintr+0x148>
801008de:	83 fb 09             	cmp    $0x9,%ebx
801008e1:	0f 85 33 01 00 00    	jne    80100a1a <consoleintr+0x17a>
801008e7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  while((c = getc()) >= 0){
801008ee:	ff d6                	call   *%esi
801008f0:	89 c3                	mov    %eax,%ebx
801008f2:	85 c0                	test   %eax,%eax
801008f4:	79 d4                	jns    801008ca <consoleintr+0x2a>
  release(&cons.lock);
801008f6:	83 ec 0c             	sub    $0xc,%esp
801008f9:	68 20 ff 10 80       	push   $0x8010ff20
801008fe:	e8 dd 42 00 00       	call   80104be0 <release>
  if(doprocdump) {
80100903:	83 c4 10             	add    $0x10,%esp
80100906:	85 ff                	test   %edi,%edi
80100908:	0f 85 9e 01 00 00    	jne    80100aac <consoleintr+0x20c>
  if (ctrli)
8010090e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100911:	85 c0                	test   %eax,%eax
80100913:	0f 85 87 01 00 00    	jne    80100aa0 <consoleintr+0x200>
}
80100919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010091c:	5b                   	pop    %ebx
8010091d:	5e                   	pop    %esi
8010091e:	5f                   	pop    %edi
8010091f:	5d                   	pop    %ebp
80100920:	c3                   	ret
80100921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100928:	83 fb 15             	cmp    $0x15,%ebx
8010092b:	74 7d                	je     801009aa <consoleintr+0x10a>
8010092d:	83 fb 7f             	cmp    $0x7f,%ebx
80100930:	0f 84 b2 00 00 00    	je     801009e8 <consoleintr+0x148>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100936:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010093b:	89 c2                	mov    %eax,%edx
8010093d:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80100943:	83 fa 7f             	cmp    $0x7f,%edx
80100946:	0f 87 76 ff ff ff    	ja     801008c2 <consoleintr+0x22>
  if(panicked){
8010094c:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100952:	8d 50 01             	lea    0x1(%eax),%edx
80100955:	83 e0 7f             	and    $0x7f,%eax
80100958:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
8010095e:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100964:	85 c9                	test   %ecx,%ecx
80100966:	0f 85 2a 01 00 00    	jne    80100a96 <consoleintr+0x1f6>
8010096c:	89 d8                	mov    %ebx,%eax
8010096e:	e8 8d fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100973:	83 fb 0a             	cmp    $0xa,%ebx
80100976:	0f 84 ec 00 00 00    	je     80100a68 <consoleintr+0x1c8>
8010097c:	83 fb 04             	cmp    $0x4,%ebx
8010097f:	0f 84 e3 00 00 00    	je     80100a68 <consoleintr+0x1c8>
80100985:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010098a:	83 e8 80             	sub    $0xffffff80,%eax
8010098d:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100993:	0f 85 29 ff ff ff    	jne    801008c2 <consoleintr+0x22>
80100999:	e9 cf 00 00 00       	jmp    80100a6d <consoleintr+0x1cd>
8010099e:	66 90                	xchg   %ax,%ax
801009a0:	b8 00 01 00 00       	mov    $0x100,%eax
801009a5:	e8 56 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009aa:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009af:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009b5:	0f 84 07 ff ff ff    	je     801008c2 <consoleintr+0x22>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009bb:	83 e8 01             	sub    $0x1,%eax
801009be:	89 c2                	mov    %eax,%edx
801009c0:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801009c3:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
801009ca:	0f 84 f2 fe ff ff    	je     801008c2 <consoleintr+0x22>
  if(panicked){
801009d0:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.e--;
801009d6:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
801009db:	85 c9                	test   %ecx,%ecx
801009dd:	74 c1                	je     801009a0 <consoleintr+0x100>
801009df:	fa                   	cli
    for(;;)
801009e0:	eb fe                	jmp    801009e0 <consoleintr+0x140>
801009e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
801009e8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009ed:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009f3:	0f 84 c9 fe ff ff    	je     801008c2 <consoleintr+0x22>
  if(panicked){
801009f9:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
801009ff:	83 e8 01             	sub    $0x1,%eax
80100a02:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100a07:	85 d2                	test   %edx,%edx
80100a09:	74 7c                	je     80100a87 <consoleintr+0x1e7>
80100a0b:	fa                   	cli
    for(;;)
80100a0c:	eb fe                	jmp    80100a0c <consoleintr+0x16c>
80100a0e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100a10:	bf 01 00 00 00       	mov    $0x1,%edi
80100a15:	e9 a8 fe ff ff       	jmp    801008c2 <consoleintr+0x22>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a1a:	85 db                	test   %ebx,%ebx
80100a1c:	0f 84 a0 fe ff ff    	je     801008c2 <consoleintr+0x22>
80100a22:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a27:	89 c2                	mov    %eax,%edx
80100a29:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80100a2f:	83 fa 7f             	cmp    $0x7f,%edx
80100a32:	0f 87 8a fe ff ff    	ja     801008c2 <consoleintr+0x22>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a38:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
80100a3b:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a41:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a44:	83 fb 0d             	cmp    $0xd,%ebx
80100a47:	0f 85 0b ff ff ff    	jne    80100958 <consoleintr+0xb8>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a4d:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100a53:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a5a:	85 c9                	test   %ecx,%ecx
80100a5c:	75 38                	jne    80100a96 <consoleintr+0x1f6>
80100a5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a63:	e8 98 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a68:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a6d:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a70:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a75:	68 00 ff 10 80       	push   $0x8010ff00
80100a7a:	e8 31 37 00 00       	call   801041b0 <wakeup>
80100a7f:	83 c4 10             	add    $0x10,%esp
80100a82:	e9 3b fe ff ff       	jmp    801008c2 <consoleintr+0x22>
80100a87:	b8 00 01 00 00       	mov    $0x100,%eax
80100a8c:	e8 6f f9 ff ff       	call   80100400 <consputc.part.0>
80100a91:	e9 2c fe ff ff       	jmp    801008c2 <consoleintr+0x22>
80100a96:	fa                   	cli
    for(;;)
80100a97:	eb fe                	jmp    80100a97 <consoleintr+0x1f7>
80100a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80100aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aa3:	5b                   	pop    %ebx
80100aa4:	5e                   	pop    %esi
80100aa5:	5f                   	pop    %edi
80100aa6:	5d                   	pop    %ebp
      print_mem_pages();
80100aa7:	e9 84 39 00 00       	jmp    80104430 <print_mem_pages>
    procdump();  
80100aac:	e8 df 37 00 00       	call   80104290 <procdump>
80100ab1:	e9 58 fe ff ff       	jmp    8010090e <consoleintr+0x6e>
80100ab6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100abd:	00 
80100abe:	66 90                	xchg   %ax,%ax

80100ac0 <consoleinit>:

void
consoleinit(void)
{
80100ac0:	55                   	push   %ebp
80100ac1:	89 e5                	mov    %esp,%ebp
80100ac3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ac6:	68 68 83 10 80       	push   $0x80108368
80100acb:	68 20 ff 10 80       	push   $0x8010ff20
80100ad0:	e8 7b 3f 00 00       	call   80104a50 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ad5:	58                   	pop    %eax
80100ad6:	5a                   	pop    %edx
80100ad7:	6a 00                	push   $0x0
80100ad9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100adb:	c7 05 0c 09 11 80 b0 	movl   $0x801005b0,0x8011090c
80100ae2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ae5:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100aec:	02 10 80 
  cons.locking = 1;
80100aef:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100af6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100af9:	e8 d2 19 00 00       	call   801024d0 <ioapicenable>
}
80100afe:	83 c4 10             	add    $0x10,%esp
80100b01:	c9                   	leave
80100b02:	c3                   	ret
80100b03:	66 90                	xchg   %ax,%ax
80100b05:	66 90                	xchg   %ax,%ax
80100b07:	66 90                	xchg   %ax,%ax
80100b09:	66 90                	xchg   %ax,%ax
80100b0b:	66 90                	xchg   %ax,%ax
80100b0d:	66 90                	xchg   %ax,%ax
80100b0f:	90                   	nop

80100b10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b10:	55                   	push   %ebp
80100b11:	89 e5                	mov    %esp,%ebp
80100b13:	57                   	push   %edi
80100b14:	56                   	push   %esi
80100b15:	53                   	push   %ebx
80100b16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b1c:	e8 ff 2e 00 00       	call   80103a20 <myproc>
80100b21:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100b27:	e8 c4 22 00 00       	call   80102df0 <begin_op>

  if((ip = namei(path)) == 0){
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	ff 75 08             	push   0x8(%ebp)
80100b32:	e8 b9 15 00 00       	call   801020f0 <namei>
80100b37:	83 c4 10             	add    $0x10,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 84 37 03 00 00    	je     80100e79 <exec+0x369>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b42:	83 ec 0c             	sub    $0xc,%esp
80100b45:	89 c7                	mov    %eax,%edi
80100b47:	50                   	push   %eax
80100b48:	e8 c3 0c 00 00       	call   80101810 <ilock>
  pgdir = 0;

  
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b53:	6a 34                	push   $0x34
80100b55:	6a 00                	push   $0x0
80100b57:	50                   	push   %eax
80100b58:	57                   	push   %edi
80100b59:	e8 c2 0f 00 00       	call   80101b20 <readi>
80100b5e:	83 c4 20             	add    $0x20,%esp
80100b61:	83 f8 34             	cmp    $0x34,%eax
80100b64:	0f 85 01 01 00 00    	jne    80100c6b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b6a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b71:	45 4c 46 
80100b74:	0f 85 f1 00 00 00    	jne    80100c6b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b7a:	e8 71 6a 00 00       	call   801075f0 <setupkvm>
80100b7f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b85:	85 c0                	test   %eax,%eax
80100b87:	0f 84 de 00 00 00    	je     80100c6b <exec+0x15b>
    goto bad;

  
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b94:	00 
80100b95:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b9b:	0f 84 a8 02 00 00    	je     80100e49 <exec+0x339>
  sz = 0;
80100ba1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100ba8:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bab:	31 db                	xor    %ebx,%ebx
80100bad:	e9 8c 00 00 00       	jmp    80100c3e <exec+0x12e>
80100bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bb8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bbf:	75 6c                	jne    80100c2d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100bc1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bc7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bcd:	0f 82 87 00 00 00    	jb     80100c5a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100bd3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bd9:	72 7f                	jb     80100c5a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bdb:	83 ec 04             	sub    $0x4,%esp
80100bde:	50                   	push   %eax
80100bdf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100be5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100beb:	e8 30 68 00 00       	call   80107420 <allocuvm>
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bf9:	85 c0                	test   %eax,%eax
80100bfb:	74 5d                	je     80100c5a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bfd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c03:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c08:	75 50                	jne    80100c5a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c0a:	83 ec 0c             	sub    $0xc,%esp
80100c0d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100c13:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100c19:	57                   	push   %edi
80100c1a:	50                   	push   %eax
80100c1b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c21:	e8 1a 67 00 00       	call   80107340 <loaduvm>
80100c26:	83 c4 20             	add    $0x20,%esp
80100c29:	85 c0                	test   %eax,%eax
80100c2b:	78 2d                	js     80100c5a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c2d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c34:	83 c3 01             	add    $0x1,%ebx
80100c37:	83 c6 20             	add    $0x20,%esi
80100c3a:	39 d8                	cmp    %ebx,%eax
80100c3c:	7e 52                	jle    80100c90 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c3e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c44:	6a 20                	push   $0x20
80100c46:	56                   	push   %esi
80100c47:	50                   	push   %eax
80100c48:	57                   	push   %edi
80100c49:	e8 d2 0e 00 00       	call   80101b20 <readi>
80100c4e:	83 c4 10             	add    $0x10,%esp
80100c51:	83 f8 20             	cmp    $0x20,%eax
80100c54:	0f 84 5e ff ff ff    	je     80100bb8 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c5a:	83 ec 0c             	sub    $0xc,%esp
80100c5d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c63:	e8 e8 68 00 00       	call   80107550 <freevm>
  if(ip){
80100c68:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c6b:	83 ec 0c             	sub    $0xc,%esp
80100c6e:	57                   	push   %edi
80100c6f:	e8 2c 0e 00 00       	call   80101aa0 <iunlockput>
    end_op();
80100c74:	e8 e7 21 00 00       	call   80102e60 <end_op>
80100c79:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c84:	5b                   	pop    %ebx
80100c85:	5e                   	pop    %esi
80100c86:	5f                   	pop    %edi
80100c87:	5d                   	pop    %ebp
80100c88:	c3                   	ret
80100c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c90:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c96:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c9c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca2:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100ca8:	83 ec 0c             	sub    $0xc,%esp
80100cab:	57                   	push   %edi
80100cac:	e8 ef 0d 00 00       	call   80101aa0 <iunlockput>
  end_op();
80100cb1:	e8 aa 21 00 00       	call   80102e60 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cb6:	83 c4 0c             	add    $0xc,%esp
80100cb9:	53                   	push   %ebx
80100cba:	56                   	push   %esi
80100cbb:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cc1:	56                   	push   %esi
80100cc2:	e8 59 67 00 00       	call   80107420 <allocuvm>
80100cc7:	83 c4 10             	add    $0x10,%esp
80100cca:	89 c7                	mov    %eax,%edi
80100ccc:	85 c0                	test   %eax,%eax
80100cce:	0f 84 86 00 00 00    	je     80100d5a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd4:	83 ec 08             	sub    $0x8,%esp
80100cd7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100cdd:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cdf:	50                   	push   %eax
80100ce0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100ce1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ce3:	e8 a8 69 00 00       	call   80107690 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ceb:	83 c4 10             	add    $0x10,%esp
80100cee:	8b 10                	mov    (%eax),%edx
80100cf0:	85 d2                	test   %edx,%edx
80100cf2:	0f 84 5d 01 00 00    	je     80100e55 <exec+0x345>
80100cf8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cfe:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100d01:	eb 23                	jmp    80100d26 <exec+0x216>
80100d03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d08:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100d0b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100d12:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100d18:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100d1b:	85 d2                	test   %edx,%edx
80100d1d:	74 51                	je     80100d70 <exec+0x260>
    if(argc >= MAXARG)
80100d1f:	83 f8 20             	cmp    $0x20,%eax
80100d22:	74 36                	je     80100d5a <exec+0x24a>
80100d24:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d26:	83 ec 0c             	sub    $0xc,%esp
80100d29:	52                   	push   %edx
80100d2a:	e8 01 42 00 00       	call   80104f30 <strlen>
80100d2f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d31:	58                   	pop    %eax
80100d32:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d35:	83 eb 01             	sub    $0x1,%ebx
80100d38:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d3b:	e8 f0 41 00 00       	call   80104f30 <strlen>
80100d40:	83 c0 01             	add    $0x1,%eax
80100d43:	50                   	push   %eax
80100d44:	ff 34 b7             	push   (%edi,%esi,4)
80100d47:	53                   	push   %ebx
80100d48:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d4e:	e8 2d 6b 00 00       	call   80107880 <copyout>
80100d53:	83 c4 20             	add    $0x20,%esp
80100d56:	85 c0                	test   %eax,%eax
80100d58:	79 ae                	jns    80100d08 <exec+0x1f8>
    freevm(pgdir);
80100d5a:	83 ec 0c             	sub    $0xc,%esp
80100d5d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d63:	e8 e8 67 00 00       	call   80107550 <freevm>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	e9 0c ff ff ff       	jmp    80100c7c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  
80100d70:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d77:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d7d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d83:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d86:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d89:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d90:	00 00 00 00 
  ustack[1] = argc;
80100d94:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  
80100d9a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100da1:	ff ff ff 
  ustack[1] = argc;
80100da4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  
80100daa:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100dac:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  
80100dae:	29 d0                	sub    %edx,%eax
80100db0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100db6:	56                   	push   %esi
80100db7:	51                   	push   %ecx
80100db8:	53                   	push   %ebx
80100db9:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dbf:	e8 bc 6a 00 00       	call   80107880 <copyout>
80100dc4:	83 c4 10             	add    $0x10,%esp
80100dc7:	85 c0                	test   %eax,%eax
80100dc9:	78 8f                	js     80100d5a <exec+0x24a>
  for(last=s=path; *s; s++)
80100dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80100dce:	8b 55 08             	mov    0x8(%ebp),%edx
80100dd1:	0f b6 00             	movzbl (%eax),%eax
80100dd4:	84 c0                	test   %al,%al
80100dd6:	74 17                	je     80100def <exec+0x2df>
80100dd8:	89 d1                	mov    %edx,%ecx
80100dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100de0:	83 c1 01             	add    $0x1,%ecx
80100de3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100de5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100de8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100deb:	84 c0                	test   %al,%al
80100ded:	75 f1                	jne    80100de0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100def:	83 ec 04             	sub    $0x4,%esp
80100df2:	6a 10                	push   $0x10
80100df4:	52                   	push   %edx
80100df5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100dfb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dfe:	50                   	push   %eax
80100dff:	e8 ec 40 00 00       	call   80104ef0 <safestrcpy>
  curproc->pgdir = pgdir;
80100e04:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100e0a:	89 f0                	mov    %esi,%eax
80100e0c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100e0f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100e11:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  
80100e14:	89 c1                	mov    %eax,%ecx
80100e16:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  curproc->rss = 0;
80100e1c:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  curproc->tf->eip = elf.entry;  
80100e23:	8b 40 18             	mov    0x18(%eax),%eax
80100e26:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e29:	8b 41 18             	mov    0x18(%ecx),%eax
80100e2c:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e2f:	89 0c 24             	mov    %ecx,(%esp)
80100e32:	e8 59 63 00 00       	call   80107190 <switchuvm>
  freevm(oldpgdir);
80100e37:	89 34 24             	mov    %esi,(%esp)
80100e3a:	e8 11 67 00 00       	call   80107550 <freevm>
  return 0;
80100e3f:	83 c4 10             	add    $0x10,%esp
80100e42:	31 c0                	xor    %eax,%eax
80100e44:	e9 38 fe ff ff       	jmp    80100c81 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e49:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e4e:	31 f6                	xor    %esi,%esi
80100e50:	e9 53 fe ff ff       	jmp    80100ca8 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e55:	be 10 00 00 00       	mov    $0x10,%esi
80100e5a:	ba 04 00 00 00       	mov    $0x4,%edx
80100e5f:	b8 03 00 00 00       	mov    $0x3,%eax
80100e64:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e6b:	00 00 00 
80100e6e:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e74:	e9 10 ff ff ff       	jmp    80100d89 <exec+0x279>
    end_op();
80100e79:	e8 e2 1f 00 00       	call   80102e60 <end_op>
    cprintf("exec: fail\n");
80100e7e:	83 ec 0c             	sub    $0xc,%esp
80100e81:	68 70 83 10 80       	push   $0x80108370
80100e86:	e8 25 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	e9 e9 fd ff ff       	jmp    80100c7c <exec+0x16c>
80100e93:	66 90                	xchg   %ax,%ax
80100e95:	66 90                	xchg   %ax,%ax
80100e97:	66 90                	xchg   %ax,%ax
80100e99:	66 90                	xchg   %ax,%ax
80100e9b:	66 90                	xchg   %ax,%ax
80100e9d:	66 90                	xchg   %ax,%ax
80100e9f:	90                   	nop

80100ea0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100ea6:	68 7c 83 10 80       	push   $0x8010837c
80100eab:	68 60 ff 10 80       	push   $0x8010ff60
80100eb0:	e8 9b 3b 00 00       	call   80104a50 <initlock>
}
80100eb5:	83 c4 10             	add    $0x10,%esp
80100eb8:	c9                   	leave
80100eb9:	c3                   	ret
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ec0 <filealloc>:


struct file*
filealloc(void)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ec4:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100ec9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100ecc:	68 60 ff 10 80       	push   $0x8010ff60
80100ed1:	e8 6a 3d 00 00       	call   80104c40 <acquire>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb 10                	jmp    80100eeb <filealloc+0x2b>
80100edb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ee0:	83 c3 18             	add    $0x18,%ebx
80100ee3:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100ee9:	74 25                	je     80100f10 <filealloc+0x50>
    if(f->ref == 0){
80100eeb:	8b 43 04             	mov    0x4(%ebx),%eax
80100eee:	85 c0                	test   %eax,%eax
80100ef0:	75 ee                	jne    80100ee0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ef5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 da 3c 00 00       	call   80104be0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f06:	89 d8                	mov    %ebx,%eax
      return f;
80100f08:	83 c4 10             	add    $0x10,%esp
}
80100f0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f0e:	c9                   	leave
80100f0f:	c3                   	ret
  release(&ftable.lock);
80100f10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f13:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f15:	68 60 ff 10 80       	push   $0x8010ff60
80100f1a:	e8 c1 3c 00 00       	call   80104be0 <release>
}
80100f1f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f21:	83 c4 10             	add    $0x10,%esp
}
80100f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f27:	c9                   	leave
80100f28:	c3                   	ret
80100f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f30 <filedup>:


struct file*
filedup(struct file *f)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
80100f34:	83 ec 10             	sub    $0x10,%esp
80100f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f3a:	68 60 ff 10 80       	push   $0x8010ff60
80100f3f:	e8 fc 3c 00 00       	call   80104c40 <acquire>
  if(f->ref < 1)
80100f44:	8b 43 04             	mov    0x4(%ebx),%eax
80100f47:	83 c4 10             	add    $0x10,%esp
80100f4a:	85 c0                	test   %eax,%eax
80100f4c:	7e 1a                	jle    80100f68 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f4e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f51:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f54:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f57:	68 60 ff 10 80       	push   $0x8010ff60
80100f5c:	e8 7f 3c 00 00       	call   80104be0 <release>
  return f;
}
80100f61:	89 d8                	mov    %ebx,%eax
80100f63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f66:	c9                   	leave
80100f67:	c3                   	ret
    panic("filedup");
80100f68:	83 ec 0c             	sub    $0xc,%esp
80100f6b:	68 83 83 10 80       	push   $0x80108383
80100f70:	e8 0b f4 ff ff       	call   80100380 <panic>
80100f75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f7c:	00 
80100f7d:	8d 76 00             	lea    0x0(%esi),%esi

80100f80 <fileclose>:


void
fileclose(struct file *f)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	83 ec 28             	sub    $0x28,%esp
80100f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f8c:	68 60 ff 10 80       	push   $0x8010ff60
80100f91:	e8 aa 3c 00 00       	call   80104c40 <acquire>
  if(f->ref < 1)
80100f96:	8b 53 04             	mov    0x4(%ebx),%edx
80100f99:	83 c4 10             	add    $0x10,%esp
80100f9c:	85 d2                	test   %edx,%edx
80100f9e:	0f 8e a5 00 00 00    	jle    80101049 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100fa4:	83 ea 01             	sub    $0x1,%edx
80100fa7:	89 53 04             	mov    %edx,0x4(%ebx)
80100faa:	75 44                	jne    80100ff0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100fac:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100fb0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100fb3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100fb5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100fbb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100fbe:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fc1:	8b 43 10             	mov    0x10(%ebx),%eax
80100fc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fc7:	68 60 ff 10 80       	push   $0x8010ff60
80100fcc:	e8 0f 3c 00 00       	call   80104be0 <release>

  if(ff.type == FD_PIPE)
80100fd1:	83 c4 10             	add    $0x10,%esp
80100fd4:	83 ff 01             	cmp    $0x1,%edi
80100fd7:	74 57                	je     80101030 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fd9:	83 ff 02             	cmp    $0x2,%edi
80100fdc:	74 2a                	je     80101008 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe1:	5b                   	pop    %ebx
80100fe2:	5e                   	pop    %esi
80100fe3:	5f                   	pop    %edi
80100fe4:	5d                   	pop    %ebp
80100fe5:	c3                   	ret
80100fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fed:	00 
80100fee:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100ff0:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ffa:	5b                   	pop    %ebx
80100ffb:	5e                   	pop    %esi
80100ffc:	5f                   	pop    %edi
80100ffd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100ffe:	e9 dd 3b 00 00       	jmp    80104be0 <release>
80101003:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101008:	e8 e3 1d 00 00       	call   80102df0 <begin_op>
    iput(ff.ip);
8010100d:	83 ec 0c             	sub    $0xc,%esp
80101010:	ff 75 e0             	push   -0x20(%ebp)
80101013:	e8 28 09 00 00       	call   80101940 <iput>
    end_op();
80101018:	83 c4 10             	add    $0x10,%esp
}
8010101b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010101e:	5b                   	pop    %ebx
8010101f:	5e                   	pop    %esi
80101020:	5f                   	pop    %edi
80101021:	5d                   	pop    %ebp
    end_op();
80101022:	e9 39 1e 00 00       	jmp    80102e60 <end_op>
80101027:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010102e:	00 
8010102f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80101030:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101034:	83 ec 08             	sub    $0x8,%esp
80101037:	53                   	push   %ebx
80101038:	56                   	push   %esi
80101039:	e8 72 25 00 00       	call   801035b0 <pipeclose>
8010103e:	83 c4 10             	add    $0x10,%esp
}
80101041:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101044:	5b                   	pop    %ebx
80101045:	5e                   	pop    %esi
80101046:	5f                   	pop    %edi
80101047:	5d                   	pop    %ebp
80101048:	c3                   	ret
    panic("fileclose");
80101049:	83 ec 0c             	sub    $0xc,%esp
8010104c:	68 8b 83 10 80       	push   $0x8010838b
80101051:	e8 2a f3 ff ff       	call   80100380 <panic>
80101056:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010105d:	00 
8010105e:	66 90                	xchg   %ax,%ax

80101060 <filestat>:


int
filestat(struct file *f, struct stat *st)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	53                   	push   %ebx
80101064:	83 ec 04             	sub    $0x4,%esp
80101067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010106a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010106d:	75 31                	jne    801010a0 <filestat+0x40>
    ilock(f->ip);
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	ff 73 10             	push   0x10(%ebx)
80101075:	e8 96 07 00 00       	call   80101810 <ilock>
    stati(f->ip, st);
8010107a:	58                   	pop    %eax
8010107b:	5a                   	pop    %edx
8010107c:	ff 75 0c             	push   0xc(%ebp)
8010107f:	ff 73 10             	push   0x10(%ebx)
80101082:	e8 69 0a 00 00       	call   80101af0 <stati>
    iunlock(f->ip);
80101087:	59                   	pop    %ecx
80101088:	ff 73 10             	push   0x10(%ebx)
8010108b:	e8 60 08 00 00       	call   801018f0 <iunlock>
    return 0;
  }
  return -1;
}
80101090:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101093:	83 c4 10             	add    $0x10,%esp
80101096:	31 c0                	xor    %eax,%eax
}
80101098:	c9                   	leave
80101099:	c3                   	ret
8010109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801010a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801010a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010a8:	c9                   	leave
801010a9:	c3                   	ret
801010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010b0 <fileread>:


int
fileread(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 0c             	sub    $0xc,%esp
801010b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801010bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010c2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010c6:	74 60                	je     80101128 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010c8:	8b 03                	mov    (%ebx),%eax
801010ca:	83 f8 01             	cmp    $0x1,%eax
801010cd:	74 41                	je     80101110 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010cf:	83 f8 02             	cmp    $0x2,%eax
801010d2:	75 5b                	jne    8010112f <fileread+0x7f>
    ilock(f->ip);
801010d4:	83 ec 0c             	sub    $0xc,%esp
801010d7:	ff 73 10             	push   0x10(%ebx)
801010da:	e8 31 07 00 00       	call   80101810 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010df:	57                   	push   %edi
801010e0:	ff 73 14             	push   0x14(%ebx)
801010e3:	56                   	push   %esi
801010e4:	ff 73 10             	push   0x10(%ebx)
801010e7:	e8 34 0a 00 00       	call   80101b20 <readi>
801010ec:	83 c4 20             	add    $0x20,%esp
801010ef:	89 c6                	mov    %eax,%esi
801010f1:	85 c0                	test   %eax,%eax
801010f3:	7e 03                	jle    801010f8 <fileread+0x48>
      f->off += r;
801010f5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010f8:	83 ec 0c             	sub    $0xc,%esp
801010fb:	ff 73 10             	push   0x10(%ebx)
801010fe:	e8 ed 07 00 00       	call   801018f0 <iunlock>
    return r;
80101103:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101106:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101109:	89 f0                	mov    %esi,%eax
8010110b:	5b                   	pop    %ebx
8010110c:	5e                   	pop    %esi
8010110d:	5f                   	pop    %edi
8010110e:	5d                   	pop    %ebp
8010110f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101110:	8b 43 0c             	mov    0xc(%ebx),%eax
80101113:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	5b                   	pop    %ebx
8010111a:	5e                   	pop    %esi
8010111b:	5f                   	pop    %edi
8010111c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010111d:	e9 4e 26 00 00       	jmp    80103770 <piperead>
80101122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101128:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010112d:	eb d7                	jmp    80101106 <fileread+0x56>
  panic("fileread");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 95 83 10 80       	push   $0x80108395
80101137:	e8 44 f2 ff ff       	call   80100380 <panic>
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101140 <filewrite>:



int
filewrite(struct file *f, char *addr, int n)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 1c             	sub    $0x1c,%esp
80101149:	8b 45 0c             	mov    0xc(%ebp),%eax
8010114c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010114f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101152:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101155:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010115c:	0f 84 bb 00 00 00    	je     8010121d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101162:	8b 03                	mov    (%ebx),%eax
80101164:	83 f8 01             	cmp    $0x1,%eax
80101167:	0f 84 bf 00 00 00    	je     8010122c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010116d:	83 f8 02             	cmp    $0x2,%eax
80101170:	0f 85 c8 00 00 00    	jne    8010123e <filewrite+0xfe>
    
    
    
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101179:	31 f6                	xor    %esi,%esi
    while(i < n){
8010117b:	85 c0                	test   %eax,%eax
8010117d:	7f 30                	jg     801011af <filewrite+0x6f>
8010117f:	e9 94 00 00 00       	jmp    80101218 <filewrite+0xd8>
80101184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101188:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010118b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010118e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101191:	ff 73 10             	push   0x10(%ebx)
80101194:	e8 57 07 00 00       	call   801018f0 <iunlock>
      end_op();
80101199:	e8 c2 1c 00 00       	call   80102e60 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010119e:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011a1:	83 c4 10             	add    $0x10,%esp
801011a4:	39 c7                	cmp    %eax,%edi
801011a6:	75 5c                	jne    80101204 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801011a8:	01 fe                	add    %edi,%esi
    while(i < n){
801011aa:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ad:	7e 69                	jle    80101218 <filewrite+0xd8>
      int n1 = n - i;
801011af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
801011b2:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
801011b7:	29 f7                	sub    %esi,%edi
      if(n1 > max)
801011b9:	39 c7                	cmp    %eax,%edi
801011bb:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801011be:	e8 2d 1c 00 00       	call   80102df0 <begin_op>
      ilock(f->ip);
801011c3:	83 ec 0c             	sub    $0xc,%esp
801011c6:	ff 73 10             	push   0x10(%ebx)
801011c9:	e8 42 06 00 00       	call   80101810 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011ce:	57                   	push   %edi
801011cf:	ff 73 14             	push   0x14(%ebx)
801011d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011d5:	01 f0                	add    %esi,%eax
801011d7:	50                   	push   %eax
801011d8:	ff 73 10             	push   0x10(%ebx)
801011db:	e8 40 0a 00 00       	call   80101c20 <writei>
801011e0:	83 c4 20             	add    $0x20,%esp
801011e3:	85 c0                	test   %eax,%eax
801011e5:	7f a1                	jg     80101188 <filewrite+0x48>
801011e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011ea:	83 ec 0c             	sub    $0xc,%esp
801011ed:	ff 73 10             	push   0x10(%ebx)
801011f0:	e8 fb 06 00 00       	call   801018f0 <iunlock>
      end_op();
801011f5:	e8 66 1c 00 00       	call   80102e60 <end_op>
      if(r < 0)
801011fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011fd:	83 c4 10             	add    $0x10,%esp
80101200:	85 c0                	test   %eax,%eax
80101202:	75 14                	jne    80101218 <filewrite+0xd8>
        panic("short filewrite");
80101204:	83 ec 0c             	sub    $0xc,%esp
80101207:	68 9e 83 10 80       	push   $0x8010839e
8010120c:	e8 6f f1 ff ff       	call   80100380 <panic>
80101211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101218:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010121b:	74 05                	je     80101222 <filewrite+0xe2>
8010121d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80101222:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101225:	89 f0                	mov    %esi,%eax
80101227:	5b                   	pop    %ebx
80101228:	5e                   	pop    %esi
80101229:	5f                   	pop    %edi
8010122a:	5d                   	pop    %ebp
8010122b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010122c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010122f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101232:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101235:	5b                   	pop    %ebx
80101236:	5e                   	pop    %esi
80101237:	5f                   	pop    %edi
80101238:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101239:	e9 12 24 00 00       	jmp    80103650 <pipewrite>
  panic("filewrite");
8010123e:	83 ec 0c             	sub    $0xc,%esp
80101241:	68 a4 83 10 80       	push   $0x801083a4
80101246:	e8 35 f1 ff ff       	call   80100380 <panic>
8010124b:	66 90                	xchg   %ax,%ax
8010124d:	66 90                	xchg   %ax,%ax
8010124f:	90                   	nop

80101250 <balloc>:



static uint
balloc(uint dev)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d c0 25 11 80    	mov    0x801125c0,%ecx
{
8010125f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 8c 00 00 00    	je     801012f6 <balloc+0xa6>
8010126a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010126c:	89 f8                	mov    %edi,%eax
8010126e:	83 ec 08             	sub    $0x8,%esp
80101271:	89 fe                	mov    %edi,%esi
80101273:	c1 f8 0c             	sar    $0xc,%eax
80101276:	03 05 d8 25 11 80    	add    0x801125d8,%eax
8010127c:	50                   	push   %eax
8010127d:	ff 75 dc             	push   -0x24(%ebp)
80101280:	e8 4b ee ff ff       	call   801000d0 <bread>
80101285:	83 c4 10             	add    $0x10,%esp
80101288:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010128b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010128e:	a1 c0 25 11 80       	mov    0x801125c0,%eax
80101293:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101296:	31 c0                	xor    %eax,%eax
80101298:	eb 32                	jmp    801012cc <balloc+0x7c>
8010129a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  
801012a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 49                	je     80101308 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 07                	je     801012d3 <balloc+0x83>
801012cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801012cf:	39 d6                	cmp    %edx,%esi
801012d1:	72 cd                	jb     801012a0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012d3:	8b 7d d8             	mov    -0x28(%ebp),%edi
801012d6:	83 ec 0c             	sub    $0xc,%esp
801012d9:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012e2:	e8 09 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012e7:	83 c4 10             	add    $0x10,%esp
801012ea:	3b 3d c0 25 11 80    	cmp    0x801125c0,%edi
801012f0:	0f 82 76 ff ff ff    	jb     8010126c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012f6:	83 ec 0c             	sub    $0xc,%esp
801012f9:	68 ae 83 10 80       	push   $0x801083ae
801012fe:	e8 7d f0 ff ff       	call   80100380 <panic>
80101303:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  
80101308:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010130b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  
8010130e:	09 da                	or     %ebx,%edx
80101310:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101314:	57                   	push   %edi
80101315:	e8 b6 1c 00 00       	call   80102fd0 <log_write>
        brelse(bp);
8010131a:	89 3c 24             	mov    %edi,(%esp)
8010131d:	e8 ce ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101322:	58                   	pop    %eax
80101323:	5a                   	pop    %edx
80101324:	56                   	push   %esi
80101325:	ff 75 dc             	push   -0x24(%ebp)
80101328:	e8 a3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010132d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101330:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101332:	8d 40 5c             	lea    0x5c(%eax),%eax
80101335:	68 00 02 00 00       	push   $0x200
8010133a:	6a 00                	push   $0x0
8010133c:	50                   	push   %eax
8010133d:	e8 fe 39 00 00       	call   80104d40 <memset>
  log_write(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 86 1c 00 00       	call   80102fd0 <log_write>
  brelse(bp);
8010134a:	89 1c 24             	mov    %ebx,(%esp)
8010134d:	e8 9e ee ff ff       	call   801001f0 <brelse>
}
80101352:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101355:	89 f0                	mov    %esi,%eax
80101357:	5b                   	pop    %ebx
80101358:	5e                   	pop    %esi
80101359:	5f                   	pop    %edi
8010135a:	5d                   	pop    %ebp
8010135b:	c3                   	ret
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <iget>:



static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  
  empty = 0;
80101364:	31 ff                	xor    %edi,%edi
{
80101366:	56                   	push   %esi
80101367:	89 c6                	mov    %eax,%esi
80101369:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010136f:	83 ec 28             	sub    $0x28,%esp
80101372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101375:	68 60 09 11 80       	push   $0x80110960
8010137a:	e8 c1 38 00 00       	call   80104c40 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101382:	83 c4 10             	add    $0x10,%esp
80101385:	eb 1b                	jmp    801013a2 <iget+0x42>
80101387:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010138e:	00 
8010138f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 33                	cmp    %esi,(%ebx)
80101392:	74 6c                	je     80101400 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101394:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010139a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013a0:	74 26                	je     801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a2:	8b 43 08             	mov    0x8(%ebx),%eax
801013a5:	85 c0                	test   %eax,%eax
801013a7:	7f e7                	jg     80101390 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    
801013a9:	85 ff                	test   %edi,%edi
801013ab:	75 e7                	jne    80101394 <iget+0x34>
801013ad:	85 c0                	test   %eax,%eax
801013af:	75 76                	jne    80101427 <iget+0xc7>
      empty = ip;
801013b1:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013bf:	75 e1                	jne    801013a2 <iget+0x42>
801013c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  
  if(empty == 0)
801013c8:	85 ff                	test   %edi,%edi
801013ca:	74 79                	je     80101445 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cf:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
801013d1:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
801013d4:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
801013db:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013e2:	68 60 09 11 80       	push   $0x80110960
801013e7:	e8 f4 37 00 00       	call   80104be0 <release>

  return ip;
801013ec:	83 c4 10             	add    $0x10,%esp
}
801013ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f2:	89 f8                	mov    %edi,%eax
801013f4:	5b                   	pop    %ebx
801013f5:	5e                   	pop    %esi
801013f6:	5f                   	pop    %edi
801013f7:	5d                   	pop    %ebp
801013f8:	c3                   	ret
801013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 53 04             	cmp    %edx,0x4(%ebx)
80101403:	75 8f                	jne    80101394 <iget+0x34>
      ip->ref++;
80101405:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101408:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010140b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010140d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101410:	68 60 09 11 80       	push   $0x80110960
80101415:	e8 c6 37 00 00       	call   80104be0 <release>
      return ip;
8010141a:	83 c4 10             	add    $0x10,%esp
}
8010141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101420:	89 f8                	mov    %edi,%eax
80101422:	5b                   	pop    %ebx
80101423:	5e                   	pop    %esi
80101424:	5f                   	pop    %edi
80101425:	5d                   	pop    %ebp
80101426:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101427:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010142d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101433:	74 10                	je     80101445 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101435:	8b 43 08             	mov    0x8(%ebx),%eax
80101438:	85 c0                	test   %eax,%eax
8010143a:	0f 8f 50 ff ff ff    	jg     80101390 <iget+0x30>
80101440:	e9 68 ff ff ff       	jmp    801013ad <iget+0x4d>
    panic("iget: no inodes");
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	68 c4 83 10 80       	push   $0x801083c4
8010144d:	e8 2e ef ff ff       	call   80100380 <panic>
80101452:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101459:	00 
8010145a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101460 <bfree>:
{
80101460:	55                   	push   %ebp
80101461:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101463:	89 d0                	mov    %edx,%eax
80101465:	c1 e8 0c             	shr    $0xc,%eax
{
80101468:	89 e5                	mov    %esp,%ebp
8010146a:	56                   	push   %esi
8010146b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010146c:	03 05 d8 25 11 80    	add    0x801125d8,%eax
{
80101472:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101474:	83 ec 08             	sub    $0x8,%esp
80101477:	50                   	push   %eax
80101478:	51                   	push   %ecx
80101479:	e8 52 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010147e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101480:	c1 fb 03             	sar    $0x3,%ebx
80101483:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101486:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101488:	83 e1 07             	and    $0x7,%ecx
8010148b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101490:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101496:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101498:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010149d:	85 c1                	test   %eax,%ecx
8010149f:	74 23                	je     801014c4 <bfree+0x64>
  bp->data[bi/8] &= ~m;
801014a1:	f7 d0                	not    %eax
  log_write(bp);
801014a3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014a6:	21 c8                	and    %ecx,%eax
801014a8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801014ac:	56                   	push   %esi
801014ad:	e8 1e 1b 00 00       	call   80102fd0 <log_write>
  brelse(bp);
801014b2:	89 34 24             	mov    %esi,(%esp)
801014b5:	e8 36 ed ff ff       	call   801001f0 <brelse>
}
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014c0:	5b                   	pop    %ebx
801014c1:	5e                   	pop    %esi
801014c2:	5d                   	pop    %ebp
801014c3:	c3                   	ret
    panic("freeing free block");
801014c4:	83 ec 0c             	sub    $0xc,%esp
801014c7:	68 d4 83 10 80       	push   $0x801083d4
801014cc:	e8 af ee ff ff       	call   80100380 <panic>
801014d1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014d8:	00 
801014d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014e0 <bmap>:



static uint
bmap(struct inode *ip, uint bn)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	89 c6                	mov    %eax,%esi
801014e7:	53                   	push   %ebx
801014e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014eb:	83 fa 0b             	cmp    $0xb,%edx
801014ee:	0f 86 8c 00 00 00    	jbe    80101580 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014f4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014f7:	83 fb 7f             	cmp    $0x7f,%ebx
801014fa:	0f 87 a2 00 00 00    	ja     801015a2 <bmap+0xc2>
    
    if((addr = ip->addrs[NDIRECT]) == 0)
80101500:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101506:	85 c0                	test   %eax,%eax
80101508:	74 5e                	je     80101568 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010150a:	83 ec 08             	sub    $0x8,%esp
8010150d:	50                   	push   %eax
8010150e:	ff 36                	push   (%esi)
80101510:	e8 bb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101515:	83 c4 10             	add    $0x10,%esp
80101518:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010151c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010151e:	8b 3b                	mov    (%ebx),%edi
80101520:	85 ff                	test   %edi,%edi
80101522:	74 1c                	je     80101540 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101524:	83 ec 0c             	sub    $0xc,%esp
80101527:	52                   	push   %edx
80101528:	e8 c3 ec ff ff       	call   801001f0 <brelse>
8010152d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101530:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101533:	89 f8                	mov    %edi,%eax
80101535:	5b                   	pop    %ebx
80101536:	5e                   	pop    %esi
80101537:	5f                   	pop    %edi
80101538:	5d                   	pop    %ebp
80101539:	c3                   	ret
8010153a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101543:	8b 06                	mov    (%esi),%eax
80101545:	e8 06 fd ff ff       	call   80101250 <balloc>
      log_write(bp);
8010154a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010154d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101550:	89 03                	mov    %eax,(%ebx)
80101552:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101554:	52                   	push   %edx
80101555:	e8 76 1a 00 00       	call   80102fd0 <log_write>
8010155a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010155d:	83 c4 10             	add    $0x10,%esp
80101560:	eb c2                	jmp    80101524 <bmap+0x44>
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101568:	8b 06                	mov    (%esi),%eax
8010156a:	e8 e1 fc ff ff       	call   80101250 <balloc>
8010156f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101575:	eb 93                	jmp    8010150a <bmap+0x2a>
80101577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157e:	00 
8010157f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101580:	8d 5a 14             	lea    0x14(%edx),%ebx
80101583:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101587:	85 ff                	test   %edi,%edi
80101589:	75 a5                	jne    80101530 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010158b:	8b 00                	mov    (%eax),%eax
8010158d:	e8 be fc ff ff       	call   80101250 <balloc>
80101592:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101596:	89 c7                	mov    %eax,%edi
}
80101598:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010159b:	5b                   	pop    %ebx
8010159c:	89 f8                	mov    %edi,%eax
8010159e:	5e                   	pop    %esi
8010159f:	5f                   	pop    %edi
801015a0:	5d                   	pop    %ebp
801015a1:	c3                   	ret
  panic("bmap: out of range");
801015a2:	83 ec 0c             	sub    $0xc,%esp
801015a5:	68 e7 83 10 80       	push   $0x801083e7
801015aa:	e8 d1 ed ff ff       	call   80100380 <panic>
801015af:	90                   	nop

801015b0 <readsb>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	56                   	push   %esi
801015b4:	53                   	push   %ebx
801015b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	6a 01                	push   $0x1
801015bd:	ff 75 08             	push   0x8(%ebp)
801015c0:	e8 0b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015c5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015c8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015ca:	8d 40 5c             	lea    0x5c(%eax),%eax
801015cd:	6a 24                	push   $0x24
801015cf:	50                   	push   %eax
801015d0:	56                   	push   %esi
801015d1:	e8 fa 37 00 00       	call   80104dd0 <memmove>
  brelse(bp);
801015d6:	83 c4 10             	add    $0x10,%esp
801015d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801015dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015df:	5b                   	pop    %ebx
801015e0:	5e                   	pop    %esi
801015e1:	5d                   	pop    %ebp
  brelse(bp);
801015e2:	e9 09 ec ff ff       	jmp    801001f0 <brelse>
801015e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015ee:	00 
801015ef:	90                   	nop

801015f0 <iinit>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	53                   	push   %ebx
801015f4:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
801015f9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015fc:	68 fa 83 10 80       	push   $0x801083fa
80101601:	68 60 09 11 80       	push   $0x80110960
80101606:	e8 45 34 00 00       	call   80104a50 <initlock>
  for(i = 0; i < NINODE; i++) {
8010160b:	83 c4 10             	add    $0x10,%esp
8010160e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101610:	83 ec 08             	sub    $0x8,%esp
80101613:	68 01 84 10 80       	push   $0x80108401
80101618:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101619:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010161f:	e8 fc 32 00 00       	call   80104920 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101624:	83 c4 10             	add    $0x10,%esp
80101627:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010162d:	75 e1                	jne    80101610 <iinit+0x20>
  bp = bread(dev, 1);
8010162f:	83 ec 08             	sub    $0x8,%esp
80101632:	6a 01                	push   $0x1
80101634:	ff 75 08             	push   0x8(%ebp)
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010163c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010163f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101641:	8d 40 5c             	lea    0x5c(%eax),%eax
80101644:	6a 24                	push   $0x24
80101646:	50                   	push   %eax
80101647:	68 c0 25 11 80       	push   $0x801125c0
8010164c:	e8 7f 37 00 00       	call   80104dd0 <memmove>
  brelse(bp);
80101651:	89 1c 24             	mov    %ebx,(%esp)
80101654:	e8 97 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101659:	ff 35 d8 25 11 80    	push   0x801125d8
8010165f:	ff 35 d4 25 11 80    	push   0x801125d4
80101665:	ff 35 d0 25 11 80    	push   0x801125d0
8010166b:	ff 35 cc 25 11 80    	push   0x801125cc
80101671:	ff 35 c8 25 11 80    	push   0x801125c8
80101677:	ff 35 c4 25 11 80    	push   0x801125c4
8010167d:	ff 35 c0 25 11 80    	push   0x801125c0
80101683:	68 58 88 10 80       	push   $0x80108858
80101688:	e8 23 f0 ff ff       	call   801006b0 <cprintf>
}
8010168d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101690:	83 c4 30             	add    $0x30,%esp
80101693:	c9                   	leave
80101694:	c3                   	ret
80101695:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010169c:	00 
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <ialloc>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	57                   	push   %edi
801016a4:	56                   	push   %esi
801016a5:	53                   	push   %ebx
801016a6:	83 ec 1c             	sub    $0x1c,%esp
801016a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801016ac:	83 3d c8 25 11 80 01 	cmpl   $0x1,0x801125c8
{
801016b3:	8b 75 08             	mov    0x8(%ebp),%esi
801016b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016b9:	0f 86 91 00 00 00    	jbe    80101750 <ialloc+0xb0>
801016bf:	bf 01 00 00 00       	mov    $0x1,%edi
801016c4:	eb 21                	jmp    801016e7 <ialloc+0x47>
801016c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016cd:	00 
801016ce:	66 90                	xchg   %ax,%ax
    brelse(bp);
801016d0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016d3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016d6:	53                   	push   %ebx
801016d7:	e8 14 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016dc:	83 c4 10             	add    $0x10,%esp
801016df:	3b 3d c8 25 11 80    	cmp    0x801125c8,%edi
801016e5:	73 69                	jae    80101750 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016e7:	89 f8                	mov    %edi,%eax
801016e9:	83 ec 08             	sub    $0x8,%esp
801016ec:	c1 e8 03             	shr    $0x3,%eax
801016ef:	03 05 d4 25 11 80    	add    0x801125d4,%eax
801016f5:	50                   	push   %eax
801016f6:	56                   	push   %esi
801016f7:	e8 d4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  
801016fc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016ff:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101701:	89 f8                	mov    %edi,%eax
80101703:	83 e0 07             	and    $0x7,%eax
80101706:	c1 e0 06             	shl    $0x6,%eax
80101709:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  
8010170d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101711:	75 bd                	jne    801016d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101713:	83 ec 04             	sub    $0x4,%esp
80101716:	6a 40                	push   $0x40
80101718:	6a 00                	push   $0x0
8010171a:	51                   	push   %ecx
8010171b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010171e:	e8 1d 36 00 00       	call   80104d40 <memset>
      dip->type = type;
80101723:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101727:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010172a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   
8010172d:	89 1c 24             	mov    %ebx,(%esp)
80101730:	e8 9b 18 00 00       	call   80102fd0 <log_write>
      brelse(bp);
80101735:	89 1c 24             	mov    %ebx,(%esp)
80101738:	e8 b3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010173d:	83 c4 10             	add    $0x10,%esp
}
80101740:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101743:	89 fa                	mov    %edi,%edx
}
80101745:	5b                   	pop    %ebx
      return iget(dev, inum);
80101746:	89 f0                	mov    %esi,%eax
}
80101748:	5e                   	pop    %esi
80101749:	5f                   	pop    %edi
8010174a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010174b:	e9 10 fc ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
80101750:	83 ec 0c             	sub    $0xc,%esp
80101753:	68 07 84 10 80       	push   $0x80108407
80101758:	e8 23 ec ff ff       	call   80100380 <panic>
8010175d:	8d 76 00             	lea    0x0(%esi),%esi

80101760 <iupdate>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101768:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010176b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010176e:	83 ec 08             	sub    $0x8,%esp
80101771:	c1 e8 03             	shr    $0x3,%eax
80101774:	03 05 d4 25 11 80    	add    0x801125d4,%eax
8010177a:	50                   	push   %eax
8010177b:	ff 73 a4             	push   -0x5c(%ebx)
8010177e:	e8 4d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101783:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101787:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010178a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010178c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010178f:	83 e0 07             	and    $0x7,%eax
80101792:	c1 e0 06             	shl    $0x6,%eax
80101795:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101799:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010179c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017a0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801017a3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801017a7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801017ab:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801017af:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017b3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017b7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017ba:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017bd:	6a 34                	push   $0x34
801017bf:	53                   	push   %ebx
801017c0:	50                   	push   %eax
801017c1:	e8 0a 36 00 00       	call   80104dd0 <memmove>
  log_write(bp);
801017c6:	89 34 24             	mov    %esi,(%esp)
801017c9:	e8 02 18 00 00       	call   80102fd0 <log_write>
  brelse(bp);
801017ce:	83 c4 10             	add    $0x10,%esp
801017d1:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d7:	5b                   	pop    %ebx
801017d8:	5e                   	pop    %esi
801017d9:	5d                   	pop    %ebp
  brelse(bp);
801017da:	e9 11 ea ff ff       	jmp    801001f0 <brelse>
801017df:	90                   	nop

801017e0 <idup>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	53                   	push   %ebx
801017e4:	83 ec 10             	sub    $0x10,%esp
801017e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ea:	68 60 09 11 80       	push   $0x80110960
801017ef:	e8 4c 34 00 00       	call   80104c40 <acquire>
  ip->ref++;
801017f4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017f8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801017ff:	e8 dc 33 00 00       	call   80104be0 <release>
}
80101804:	89 d8                	mov    %ebx,%eax
80101806:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101809:	c9                   	leave
8010180a:	c3                   	ret
8010180b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101810 <ilock>:
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	56                   	push   %esi
80101814:	53                   	push   %ebx
80101815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101818:	85 db                	test   %ebx,%ebx
8010181a:	0f 84 b7 00 00 00    	je     801018d7 <ilock+0xc7>
80101820:	8b 53 08             	mov    0x8(%ebx),%edx
80101823:	85 d2                	test   %edx,%edx
80101825:	0f 8e ac 00 00 00    	jle    801018d7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010182b:	83 ec 0c             	sub    $0xc,%esp
8010182e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101831:	50                   	push   %eax
80101832:	e8 29 31 00 00       	call   80104960 <acquiresleep>
  if(ip->valid == 0){
80101837:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010183a:	83 c4 10             	add    $0x10,%esp
8010183d:	85 c0                	test   %eax,%eax
8010183f:	74 0f                	je     80101850 <ilock+0x40>
}
80101841:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101844:	5b                   	pop    %ebx
80101845:	5e                   	pop    %esi
80101846:	5d                   	pop    %ebp
80101847:	c3                   	ret
80101848:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010184f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101850:	8b 43 04             	mov    0x4(%ebx),%eax
80101853:	83 ec 08             	sub    $0x8,%esp
80101856:	c1 e8 03             	shr    $0x3,%eax
80101859:	03 05 d4 25 11 80    	add    0x801125d4,%eax
8010185f:	50                   	push   %eax
80101860:	ff 33                	push   (%ebx)
80101862:	e8 69 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101867:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010186a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010186c:	8b 43 04             	mov    0x4(%ebx),%eax
8010186f:	83 e0 07             	and    $0x7,%eax
80101872:	c1 e0 06             	shl    $0x6,%eax
80101875:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101879:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010187c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010187f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101883:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101887:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010188b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010188f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101893:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101897:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010189b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010189e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018a1:	6a 34                	push   $0x34
801018a3:	50                   	push   %eax
801018a4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801018a7:	50                   	push   %eax
801018a8:	e8 23 35 00 00       	call   80104dd0 <memmove>
    brelse(bp);
801018ad:	89 34 24             	mov    %esi,(%esp)
801018b0:	e8 3b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801018b5:	83 c4 10             	add    $0x10,%esp
801018b8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018bd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018c4:	0f 85 77 ff ff ff    	jne    80101841 <ilock+0x31>
      panic("ilock: no type");
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	68 1f 84 10 80       	push   $0x8010841f
801018d2:	e8 a9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018d7:	83 ec 0c             	sub    $0xc,%esp
801018da:	68 19 84 10 80       	push   $0x80108419
801018df:	e8 9c ea ff ff       	call   80100380 <panic>
801018e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018eb:	00 
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <iunlock>:
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	56                   	push   %esi
801018f4:	53                   	push   %ebx
801018f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018f8:	85 db                	test   %ebx,%ebx
801018fa:	74 28                	je     80101924 <iunlock+0x34>
801018fc:	83 ec 0c             	sub    $0xc,%esp
801018ff:	8d 73 0c             	lea    0xc(%ebx),%esi
80101902:	56                   	push   %esi
80101903:	e8 f8 30 00 00       	call   80104a00 <holdingsleep>
80101908:	83 c4 10             	add    $0x10,%esp
8010190b:	85 c0                	test   %eax,%eax
8010190d:	74 15                	je     80101924 <iunlock+0x34>
8010190f:	8b 43 08             	mov    0x8(%ebx),%eax
80101912:	85 c0                	test   %eax,%eax
80101914:	7e 0e                	jle    80101924 <iunlock+0x34>
  releasesleep(&ip->lock);
80101916:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101919:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010191f:	e9 9c 30 00 00       	jmp    801049c0 <releasesleep>
    panic("iunlock");
80101924:	83 ec 0c             	sub    $0xc,%esp
80101927:	68 2e 84 10 80       	push   $0x8010842e
8010192c:	e8 4f ea ff ff       	call   80100380 <panic>
80101931:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101938:	00 
80101939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101940 <iput>:
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 28             	sub    $0x28,%esp
80101949:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010194c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010194f:	57                   	push   %edi
80101950:	e8 0b 30 00 00       	call   80104960 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101955:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101958:	83 c4 10             	add    $0x10,%esp
8010195b:	85 d2                	test   %edx,%edx
8010195d:	74 07                	je     80101966 <iput+0x26>
8010195f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101964:	74 32                	je     80101998 <iput+0x58>
  releasesleep(&ip->lock);
80101966:	83 ec 0c             	sub    $0xc,%esp
80101969:	57                   	push   %edi
8010196a:	e8 51 30 00 00       	call   801049c0 <releasesleep>
  acquire(&icache.lock);
8010196f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101976:	e8 c5 32 00 00       	call   80104c40 <acquire>
  ip->ref--;
8010197b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010197f:	83 c4 10             	add    $0x10,%esp
80101982:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101989:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010198c:	5b                   	pop    %ebx
8010198d:	5e                   	pop    %esi
8010198e:	5f                   	pop    %edi
8010198f:	5d                   	pop    %ebp
  release(&icache.lock);
80101990:	e9 4b 32 00 00       	jmp    80104be0 <release>
80101995:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101998:	83 ec 0c             	sub    $0xc,%esp
8010199b:	68 60 09 11 80       	push   $0x80110960
801019a0:	e8 9b 32 00 00       	call   80104c40 <acquire>
    int r = ip->ref;
801019a5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019a8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801019af:	e8 2c 32 00 00       	call   80104be0 <release>
    if(r == 1){
801019b4:	83 c4 10             	add    $0x10,%esp
801019b7:	83 fe 01             	cmp    $0x1,%esi
801019ba:	75 aa                	jne    80101966 <iput+0x26>
801019bc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019c2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019c5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019c8:	89 df                	mov    %ebx,%edi
801019ca:	89 cb                	mov    %ecx,%ebx
801019cc:	eb 09                	jmp    801019d7 <iput+0x97>
801019ce:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019d0:	83 c6 04             	add    $0x4,%esi
801019d3:	39 de                	cmp    %ebx,%esi
801019d5:	74 19                	je     801019f0 <iput+0xb0>
    if(ip->addrs[i]){
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019dd:	8b 07                	mov    (%edi),%eax
801019df:	e8 7c fa ff ff       	call   80101460 <bfree>
      ip->addrs[i] = 0;
801019e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ea:	eb e4                	jmp    801019d0 <iput+0x90>
801019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019f0:	89 fb                	mov    %edi,%ebx
801019f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019f5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019fb:	85 c0                	test   %eax,%eax
801019fd:	75 2d                	jne    80101a2c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019ff:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a02:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a09:	53                   	push   %ebx
80101a0a:	e8 51 fd ff ff       	call   80101760 <iupdate>
      ip->type = 0;
80101a0f:	31 c0                	xor    %eax,%eax
80101a11:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a15:	89 1c 24             	mov    %ebx,(%esp)
80101a18:	e8 43 fd ff ff       	call   80101760 <iupdate>
      ip->valid = 0;
80101a1d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a24:	83 c4 10             	add    $0x10,%esp
80101a27:	e9 3a ff ff ff       	jmp    80101966 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a2c:	83 ec 08             	sub    $0x8,%esp
80101a2f:	50                   	push   %eax
80101a30:	ff 33                	push   (%ebx)
80101a32:	e8 99 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a37:	83 c4 10             	add    $0x10,%esp
80101a3a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a3d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a43:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a46:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a49:	89 cf                	mov    %ecx,%edi
80101a4b:	eb 0a                	jmp    80101a57 <iput+0x117>
80101a4d:	8d 76 00             	lea    0x0(%esi),%esi
80101a50:	83 c6 04             	add    $0x4,%esi
80101a53:	39 fe                	cmp    %edi,%esi
80101a55:	74 0f                	je     80101a66 <iput+0x126>
      if(a[j])
80101a57:	8b 16                	mov    (%esi),%edx
80101a59:	85 d2                	test   %edx,%edx
80101a5b:	74 f3                	je     80101a50 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a5d:	8b 03                	mov    (%ebx),%eax
80101a5f:	e8 fc f9 ff ff       	call   80101460 <bfree>
80101a64:	eb ea                	jmp    80101a50 <iput+0x110>
    brelse(bp);
80101a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a69:	83 ec 0c             	sub    $0xc,%esp
80101a6c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a6f:	50                   	push   %eax
80101a70:	e8 7b e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a75:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a7b:	8b 03                	mov    (%ebx),%eax
80101a7d:	e8 de f9 ff ff       	call   80101460 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a82:	83 c4 10             	add    $0x10,%esp
80101a85:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a8c:	00 00 00 
80101a8f:	e9 6b ff ff ff       	jmp    801019ff <iput+0xbf>
80101a94:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a9b:	00 
80101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101aa0 <iunlockput>:
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	56                   	push   %esi
80101aa4:	53                   	push   %ebx
80101aa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101aa8:	85 db                	test   %ebx,%ebx
80101aaa:	74 34                	je     80101ae0 <iunlockput+0x40>
80101aac:	83 ec 0c             	sub    $0xc,%esp
80101aaf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ab2:	56                   	push   %esi
80101ab3:	e8 48 2f 00 00       	call   80104a00 <holdingsleep>
80101ab8:	83 c4 10             	add    $0x10,%esp
80101abb:	85 c0                	test   %eax,%eax
80101abd:	74 21                	je     80101ae0 <iunlockput+0x40>
80101abf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ac2:	85 c0                	test   %eax,%eax
80101ac4:	7e 1a                	jle    80101ae0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ac6:	83 ec 0c             	sub    $0xc,%esp
80101ac9:	56                   	push   %esi
80101aca:	e8 f1 2e 00 00       	call   801049c0 <releasesleep>
  iput(ip);
80101acf:	83 c4 10             	add    $0x10,%esp
80101ad2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101ad5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ad8:	5b                   	pop    %ebx
80101ad9:	5e                   	pop    %esi
80101ada:	5d                   	pop    %ebp
  iput(ip);
80101adb:	e9 60 fe ff ff       	jmp    80101940 <iput>
    panic("iunlock");
80101ae0:	83 ec 0c             	sub    $0xc,%esp
80101ae3:	68 2e 84 10 80       	push   $0x8010842e
80101ae8:	e8 93 e8 ff ff       	call   80100380 <panic>
80101aed:	8d 76 00             	lea    0x0(%esi),%esi

80101af0 <stati>:



void
stati(struct inode *ip, struct stat *st)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	8b 55 08             	mov    0x8(%ebp),%edx
80101af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101af9:	8b 0a                	mov    (%edx),%ecx
80101afb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101afe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b01:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b04:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b08:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b0b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b0f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b13:	8b 52 58             	mov    0x58(%edx),%edx
80101b16:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b19:	5d                   	pop    %ebp
80101b1a:	c3                   	ret
80101b1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101b20 <readi>:



int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	57                   	push   %edi
80101b24:	56                   	push   %esi
80101b25:	53                   	push   %ebx
80101b26:	83 ec 1c             	sub    $0x1c,%esp
80101b29:	8b 75 08             	mov    0x8(%ebp),%esi
80101b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b32:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101b37:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b3a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b40:	0f 84 aa 00 00 00    	je     80101bf0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b46:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b49:	8b 56 58             	mov    0x58(%esi),%edx
80101b4c:	39 fa                	cmp    %edi,%edx
80101b4e:	0f 82 bd 00 00 00    	jb     80101c11 <readi+0xf1>
80101b54:	89 f9                	mov    %edi,%ecx
80101b56:	31 db                	xor    %ebx,%ebx
80101b58:	01 c1                	add    %eax,%ecx
80101b5a:	0f 92 c3             	setb   %bl
80101b5d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b60:	0f 82 ab 00 00 00    	jb     80101c11 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b66:	89 d3                	mov    %edx,%ebx
80101b68:	29 fb                	sub    %edi,%ebx
80101b6a:	39 ca                	cmp    %ecx,%edx
80101b6c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b6f:	85 c0                	test   %eax,%eax
80101b71:	74 73                	je     80101be6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b73:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b80:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b83:	89 fa                	mov    %edi,%edx
80101b85:	c1 ea 09             	shr    $0x9,%edx
80101b88:	89 d8                	mov    %ebx,%eax
80101b8a:	e8 51 f9 ff ff       	call   801014e0 <bmap>
80101b8f:	83 ec 08             	sub    $0x8,%esp
80101b92:	50                   	push   %eax
80101b93:	ff 33                	push   (%ebx)
80101b95:	e8 36 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b9d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ba2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba4:	89 f8                	mov    %edi,%eax
80101ba6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bab:	29 f3                	sub    %esi,%ebx
80101bad:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101baf:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bb3:	39 d9                	cmp    %ebx,%ecx
80101bb5:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bb8:	83 c4 0c             	add    $0xc,%esp
80101bbb:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bbc:	01 de                	add    %ebx,%esi
80101bbe:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101bc0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101bc3:	50                   	push   %eax
80101bc4:	ff 75 e0             	push   -0x20(%ebp)
80101bc7:	e8 04 32 00 00       	call   80104dd0 <memmove>
    brelse(bp);
80101bcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bcf:	89 14 24             	mov    %edx,(%esp)
80101bd2:	e8 19 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bd7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bda:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bdd:	83 c4 10             	add    $0x10,%esp
80101be0:	39 de                	cmp    %ebx,%esi
80101be2:	72 9c                	jb     80101b80 <readi+0x60>
80101be4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101be9:	5b                   	pop    %ebx
80101bea:	5e                   	pop    %esi
80101beb:	5f                   	pop    %edi
80101bec:	5d                   	pop    %ebp
80101bed:	c3                   	ret
80101bee:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bf0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101bf4:	66 83 fa 09          	cmp    $0x9,%dx
80101bf8:	77 17                	ja     80101c11 <readi+0xf1>
80101bfa:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80101c01:	85 d2                	test   %edx,%edx
80101c03:	74 0c                	je     80101c11 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c05:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0b:	5b                   	pop    %ebx
80101c0c:	5e                   	pop    %esi
80101c0d:	5f                   	pop    %edi
80101c0e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c0f:	ff e2                	jmp    *%edx
      return -1;
80101c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c16:	eb ce                	jmp    80101be6 <readi+0xc6>
80101c18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101c1f:	00 

80101c20 <writei>:



int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	83 ec 1c             	sub    $0x1c,%esp
80101c29:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c2f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c37:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101c3a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c3d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c40:	0f 84 ba 00 00 00    	je     80101d00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c46:	39 78 58             	cmp    %edi,0x58(%eax)
80101c49:	0f 82 ea 00 00 00    	jb     80101d39 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c4f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c52:	89 f2                	mov    %esi,%edx
80101c54:	01 fa                	add    %edi,%edx
80101c56:	0f 82 dd 00 00 00    	jb     80101d39 <writei+0x119>
80101c5c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c62:	0f 87 d1 00 00 00    	ja     80101d39 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c68:	85 f6                	test   %esi,%esi
80101c6a:	0f 84 85 00 00 00    	je     80101cf5 <writei+0xd5>
80101c70:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c77:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c80:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c83:	89 fa                	mov    %edi,%edx
80101c85:	c1 ea 09             	shr    $0x9,%edx
80101c88:	89 f0                	mov    %esi,%eax
80101c8a:	e8 51 f8 ff ff       	call   801014e0 <bmap>
80101c8f:	83 ec 08             	sub    $0x8,%esp
80101c92:	50                   	push   %eax
80101c93:	ff 36                	push   (%esi)
80101c95:	e8 36 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c9d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ca0:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ca5:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ca7:	89 f8                	mov    %edi,%eax
80101ca9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cae:	29 d3                	sub    %edx,%ebx
80101cb0:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101cb2:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101cb6:	39 d9                	cmp    %ebx,%ecx
80101cb8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cbb:	83 c4 0c             	add    $0xc,%esp
80101cbe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cbf:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101cc1:	ff 75 dc             	push   -0x24(%ebp)
80101cc4:	50                   	push   %eax
80101cc5:	e8 06 31 00 00       	call   80104dd0 <memmove>
    log_write(bp);
80101cca:	89 34 24             	mov    %esi,(%esp)
80101ccd:	e8 fe 12 00 00       	call   80102fd0 <log_write>
    brelse(bp);
80101cd2:	89 34 24             	mov    %esi,(%esp)
80101cd5:	e8 16 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cda:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ce0:	83 c4 10             	add    $0x10,%esp
80101ce3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ce6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ce9:	39 d8                	cmp    %ebx,%eax
80101ceb:	72 93                	jb     80101c80 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ced:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cf0:	39 78 58             	cmp    %edi,0x58(%eax)
80101cf3:	72 33                	jb     80101d28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cfb:	5b                   	pop    %ebx
80101cfc:	5e                   	pop    %esi
80101cfd:	5f                   	pop    %edi
80101cfe:	5d                   	pop    %ebp
80101cff:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d04:	66 83 f8 09          	cmp    $0x9,%ax
80101d08:	77 2f                	ja     80101d39 <writei+0x119>
80101d0a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101d11:	85 c0                	test   %eax,%eax
80101d13:	74 24                	je     80101d39 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101d15:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d1b:	5b                   	pop    %ebx
80101d1c:	5e                   	pop    %esi
80101d1d:	5f                   	pop    %edi
80101d1e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d1f:	ff e0                	jmp    *%eax
80101d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d2b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101d2e:	50                   	push   %eax
80101d2f:	e8 2c fa ff ff       	call   80101760 <iupdate>
80101d34:	83 c4 10             	add    $0x10,%esp
80101d37:	eb bc                	jmp    80101cf5 <writei+0xd5>
      return -1;
80101d39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d3e:	eb b8                	jmp    80101cf8 <writei+0xd8>

80101d40 <namecmp>:



int
namecmp(const char *s, const char *t)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d46:	6a 0e                	push   $0xe
80101d48:	ff 75 0c             	push   0xc(%ebp)
80101d4b:	ff 75 08             	push   0x8(%ebp)
80101d4e:	e8 ed 30 00 00       	call   80104e40 <strncmp>
}
80101d53:	c9                   	leave
80101d54:	c3                   	ret
80101d55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d5c:	00 
80101d5d:	8d 76 00             	lea    0x0(%esi),%esi

80101d60 <dirlookup>:



struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	57                   	push   %edi
80101d64:	56                   	push   %esi
80101d65:	53                   	push   %ebx
80101d66:	83 ec 1c             	sub    $0x1c,%esp
80101d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d71:	0f 85 85 00 00 00    	jne    80101dfc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d77:	8b 53 58             	mov    0x58(%ebx),%edx
80101d7a:	31 ff                	xor    %edi,%edi
80101d7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d7f:	85 d2                	test   %edx,%edx
80101d81:	74 3e                	je     80101dc1 <dirlookup+0x61>
80101d83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d88:	6a 10                	push   $0x10
80101d8a:	57                   	push   %edi
80101d8b:	56                   	push   %esi
80101d8c:	53                   	push   %ebx
80101d8d:	e8 8e fd ff ff       	call   80101b20 <readi>
80101d92:	83 c4 10             	add    $0x10,%esp
80101d95:	83 f8 10             	cmp    $0x10,%eax
80101d98:	75 55                	jne    80101def <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d9f:	74 18                	je     80101db9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101da1:	83 ec 04             	sub    $0x4,%esp
80101da4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101da7:	6a 0e                	push   $0xe
80101da9:	50                   	push   %eax
80101daa:	ff 75 0c             	push   0xc(%ebp)
80101dad:	e8 8e 30 00 00       	call   80104e40 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101db2:	83 c4 10             	add    $0x10,%esp
80101db5:	85 c0                	test   %eax,%eax
80101db7:	74 17                	je     80101dd0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101db9:	83 c7 10             	add    $0x10,%edi
80101dbc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101dbf:	72 c7                	jb     80101d88 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101dc4:	31 c0                	xor    %eax,%eax
}
80101dc6:	5b                   	pop    %ebx
80101dc7:	5e                   	pop    %esi
80101dc8:	5f                   	pop    %edi
80101dc9:	5d                   	pop    %ebp
80101dca:	c3                   	ret
80101dcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101dd0:	8b 45 10             	mov    0x10(%ebp),%eax
80101dd3:	85 c0                	test   %eax,%eax
80101dd5:	74 05                	je     80101ddc <dirlookup+0x7c>
        *poff = off;
80101dd7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dda:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ddc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101de0:	8b 03                	mov    (%ebx),%eax
80101de2:	e8 79 f5 ff ff       	call   80101360 <iget>
}
80101de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dea:	5b                   	pop    %ebx
80101deb:	5e                   	pop    %esi
80101dec:	5f                   	pop    %edi
80101ded:	5d                   	pop    %ebp
80101dee:	c3                   	ret
      panic("dirlookup read");
80101def:	83 ec 0c             	sub    $0xc,%esp
80101df2:	68 48 84 10 80       	push   $0x80108448
80101df7:	e8 84 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dfc:	83 ec 0c             	sub    $0xc,%esp
80101dff:	68 36 84 10 80       	push   $0x80108436
80101e04:	e8 77 e5 ff ff       	call   80100380 <panic>
80101e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e10 <namex>:



static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	89 c3                	mov    %eax,%ebx
80101e18:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e1b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e1e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e21:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e24:	0f 84 9e 01 00 00    	je     80101fc8 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e2a:	e8 f1 1b 00 00       	call   80103a20 <myproc>
  acquire(&icache.lock);
80101e2f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e32:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e35:	68 60 09 11 80       	push   $0x80110960
80101e3a:	e8 01 2e 00 00       	call   80104c40 <acquire>
  ip->ref++;
80101e3f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e43:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e4a:	e8 91 2d 00 00       	call   80104be0 <release>
80101e4f:	83 c4 10             	add    $0x10,%esp
80101e52:	eb 07                	jmp    80101e5b <namex+0x4b>
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e5b:	0f b6 03             	movzbl (%ebx),%eax
80101e5e:	3c 2f                	cmp    $0x2f,%al
80101e60:	74 f6                	je     80101e58 <namex+0x48>
  if(*path == 0)
80101e62:	84 c0                	test   %al,%al
80101e64:	0f 84 06 01 00 00    	je     80101f70 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e6a:	0f b6 03             	movzbl (%ebx),%eax
80101e6d:	84 c0                	test   %al,%al
80101e6f:	0f 84 10 01 00 00    	je     80101f85 <namex+0x175>
80101e75:	89 df                	mov    %ebx,%edi
80101e77:	3c 2f                	cmp    $0x2f,%al
80101e79:	0f 84 06 01 00 00    	je     80101f85 <namex+0x175>
80101e7f:	90                   	nop
80101e80:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e84:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e87:	3c 2f                	cmp    $0x2f,%al
80101e89:	74 04                	je     80101e8f <namex+0x7f>
80101e8b:	84 c0                	test   %al,%al
80101e8d:	75 f1                	jne    80101e80 <namex+0x70>
  len = path - s;
80101e8f:	89 f8                	mov    %edi,%eax
80101e91:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e93:	83 f8 0d             	cmp    $0xd,%eax
80101e96:	0f 8e ac 00 00 00    	jle    80101f48 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e9c:	83 ec 04             	sub    $0x4,%esp
80101e9f:	6a 0e                	push   $0xe
80101ea1:	53                   	push   %ebx
80101ea2:	89 fb                	mov    %edi,%ebx
80101ea4:	ff 75 e4             	push   -0x1c(%ebp)
80101ea7:	e8 24 2f 00 00       	call   80104dd0 <memmove>
80101eac:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101eaf:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101eb2:	75 0c                	jne    80101ec0 <namex+0xb0>
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101eb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ebb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ebe:	74 f8                	je     80101eb8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	56                   	push   %esi
80101ec4:	e8 47 f9 ff ff       	call   80101810 <ilock>
    if(ip->type != T_DIR){
80101ec9:	83 c4 10             	add    $0x10,%esp
80101ecc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ed1:	0f 85 b7 00 00 00    	jne    80101f8e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ed7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eda:	85 c0                	test   %eax,%eax
80101edc:	74 09                	je     80101ee7 <namex+0xd7>
80101ede:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ee1:	0f 84 f7 00 00 00    	je     80101fde <namex+0x1ce>
      
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ee7:	83 ec 04             	sub    $0x4,%esp
80101eea:	6a 00                	push   $0x0
80101eec:	ff 75 e4             	push   -0x1c(%ebp)
80101eef:	56                   	push   %esi
80101ef0:	e8 6b fe ff ff       	call   80101d60 <dirlookup>
80101ef5:	83 c4 10             	add    $0x10,%esp
80101ef8:	89 c7                	mov    %eax,%edi
80101efa:	85 c0                	test   %eax,%eax
80101efc:	0f 84 8c 00 00 00    	je     80101f8e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f02:	83 ec 0c             	sub    $0xc,%esp
80101f05:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101f08:	51                   	push   %ecx
80101f09:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f0c:	e8 ef 2a 00 00       	call   80104a00 <holdingsleep>
80101f11:	83 c4 10             	add    $0x10,%esp
80101f14:	85 c0                	test   %eax,%eax
80101f16:	0f 84 02 01 00 00    	je     8010201e <namex+0x20e>
80101f1c:	8b 56 08             	mov    0x8(%esi),%edx
80101f1f:	85 d2                	test   %edx,%edx
80101f21:	0f 8e f7 00 00 00    	jle    8010201e <namex+0x20e>
  releasesleep(&ip->lock);
80101f27:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f2a:	83 ec 0c             	sub    $0xc,%esp
80101f2d:	51                   	push   %ecx
80101f2e:	e8 8d 2a 00 00       	call   801049c0 <releasesleep>
  iput(ip);
80101f33:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101f36:	89 fe                	mov    %edi,%esi
  iput(ip);
80101f38:	e8 03 fa ff ff       	call   80101940 <iput>
80101f3d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f40:	e9 16 ff ff ff       	jmp    80101e5b <namex+0x4b>
80101f45:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f4b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101f4e:	83 ec 04             	sub    $0x4,%esp
80101f51:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f54:	50                   	push   %eax
80101f55:	53                   	push   %ebx
    name[len] = 0;
80101f56:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f58:	ff 75 e4             	push   -0x1c(%ebp)
80101f5b:	e8 70 2e 00 00       	call   80104dd0 <memmove>
    name[len] = 0;
80101f60:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f63:	83 c4 10             	add    $0x10,%esp
80101f66:	c6 01 00             	movb   $0x0,(%ecx)
80101f69:	e9 41 ff ff ff       	jmp    80101eaf <namex+0x9f>
80101f6e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f70:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f73:	85 c0                	test   %eax,%eax
80101f75:	0f 85 93 00 00 00    	jne    8010200e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7e:	89 f0                	mov    %esi,%eax
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
80101f84:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f85:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f88:	89 df                	mov    %ebx,%edi
80101f8a:	31 c0                	xor    %eax,%eax
80101f8c:	eb c0                	jmp    80101f4e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f8e:	83 ec 0c             	sub    $0xc,%esp
80101f91:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f94:	53                   	push   %ebx
80101f95:	e8 66 2a 00 00       	call   80104a00 <holdingsleep>
80101f9a:	83 c4 10             	add    $0x10,%esp
80101f9d:	85 c0                	test   %eax,%eax
80101f9f:	74 7d                	je     8010201e <namex+0x20e>
80101fa1:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fa4:	85 c9                	test   %ecx,%ecx
80101fa6:	7e 76                	jle    8010201e <namex+0x20e>
  releasesleep(&ip->lock);
80101fa8:	83 ec 0c             	sub    $0xc,%esp
80101fab:	53                   	push   %ebx
80101fac:	e8 0f 2a 00 00       	call   801049c0 <releasesleep>
  iput(ip);
80101fb1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fb4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fb6:	e8 85 f9 ff ff       	call   80101940 <iput>
      return 0;
80101fbb:	83 c4 10             	add    $0x10,%esp
}
80101fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc1:	89 f0                	mov    %esi,%eax
80101fc3:	5b                   	pop    %ebx
80101fc4:	5e                   	pop    %esi
80101fc5:	5f                   	pop    %edi
80101fc6:	5d                   	pop    %ebp
80101fc7:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101fc8:	ba 01 00 00 00       	mov    $0x1,%edx
80101fcd:	b8 01 00 00 00       	mov    $0x1,%eax
80101fd2:	e8 89 f3 ff ff       	call   80101360 <iget>
80101fd7:	89 c6                	mov    %eax,%esi
80101fd9:	e9 7d fe ff ff       	jmp    80101e5b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fde:	83 ec 0c             	sub    $0xc,%esp
80101fe1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fe4:	53                   	push   %ebx
80101fe5:	e8 16 2a 00 00       	call   80104a00 <holdingsleep>
80101fea:	83 c4 10             	add    $0x10,%esp
80101fed:	85 c0                	test   %eax,%eax
80101fef:	74 2d                	je     8010201e <namex+0x20e>
80101ff1:	8b 7e 08             	mov    0x8(%esi),%edi
80101ff4:	85 ff                	test   %edi,%edi
80101ff6:	7e 26                	jle    8010201e <namex+0x20e>
  releasesleep(&ip->lock);
80101ff8:	83 ec 0c             	sub    $0xc,%esp
80101ffb:	53                   	push   %ebx
80101ffc:	e8 bf 29 00 00       	call   801049c0 <releasesleep>
}
80102001:	83 c4 10             	add    $0x10,%esp
}
80102004:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102007:	89 f0                	mov    %esi,%eax
80102009:	5b                   	pop    %ebx
8010200a:	5e                   	pop    %esi
8010200b:	5f                   	pop    %edi
8010200c:	5d                   	pop    %ebp
8010200d:	c3                   	ret
    iput(ip);
8010200e:	83 ec 0c             	sub    $0xc,%esp
80102011:	56                   	push   %esi
      return 0;
80102012:	31 f6                	xor    %esi,%esi
    iput(ip);
80102014:	e8 27 f9 ff ff       	call   80101940 <iput>
    return 0;
80102019:	83 c4 10             	add    $0x10,%esp
8010201c:	eb a0                	jmp    80101fbe <namex+0x1ae>
    panic("iunlock");
8010201e:	83 ec 0c             	sub    $0xc,%esp
80102021:	68 2e 84 10 80       	push   $0x8010842e
80102026:	e8 55 e3 ff ff       	call   80100380 <panic>
8010202b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102030 <dirlink>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
80102036:	83 ec 20             	sub    $0x20,%esp
80102039:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010203c:	6a 00                	push   $0x0
8010203e:	ff 75 0c             	push   0xc(%ebp)
80102041:	53                   	push   %ebx
80102042:	e8 19 fd ff ff       	call   80101d60 <dirlookup>
80102047:	83 c4 10             	add    $0x10,%esp
8010204a:	85 c0                	test   %eax,%eax
8010204c:	75 67                	jne    801020b5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010204e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102051:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102054:	85 ff                	test   %edi,%edi
80102056:	74 29                	je     80102081 <dirlink+0x51>
80102058:	31 ff                	xor    %edi,%edi
8010205a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010205d:	eb 09                	jmp    80102068 <dirlink+0x38>
8010205f:	90                   	nop
80102060:	83 c7 10             	add    $0x10,%edi
80102063:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102066:	73 19                	jae    80102081 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102068:	6a 10                	push   $0x10
8010206a:	57                   	push   %edi
8010206b:	56                   	push   %esi
8010206c:	53                   	push   %ebx
8010206d:	e8 ae fa ff ff       	call   80101b20 <readi>
80102072:	83 c4 10             	add    $0x10,%esp
80102075:	83 f8 10             	cmp    $0x10,%eax
80102078:	75 4e                	jne    801020c8 <dirlink+0x98>
    if(de.inum == 0)
8010207a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010207f:	75 df                	jne    80102060 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102081:	83 ec 04             	sub    $0x4,%esp
80102084:	8d 45 da             	lea    -0x26(%ebp),%eax
80102087:	6a 0e                	push   $0xe
80102089:	ff 75 0c             	push   0xc(%ebp)
8010208c:	50                   	push   %eax
8010208d:	e8 fe 2d 00 00       	call   80104e90 <strncpy>
  de.inum = inum;
80102092:	8b 45 10             	mov    0x10(%ebp),%eax
80102095:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102099:	6a 10                	push   $0x10
8010209b:	57                   	push   %edi
8010209c:	56                   	push   %esi
8010209d:	53                   	push   %ebx
8010209e:	e8 7d fb ff ff       	call   80101c20 <writei>
801020a3:	83 c4 20             	add    $0x20,%esp
801020a6:	83 f8 10             	cmp    $0x10,%eax
801020a9:	75 2a                	jne    801020d5 <dirlink+0xa5>
  return 0;
801020ab:	31 c0                	xor    %eax,%eax
}
801020ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b0:	5b                   	pop    %ebx
801020b1:	5e                   	pop    %esi
801020b2:	5f                   	pop    %edi
801020b3:	5d                   	pop    %ebp
801020b4:	c3                   	ret
    iput(ip);
801020b5:	83 ec 0c             	sub    $0xc,%esp
801020b8:	50                   	push   %eax
801020b9:	e8 82 f8 ff ff       	call   80101940 <iput>
    return -1;
801020be:	83 c4 10             	add    $0x10,%esp
801020c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020c6:	eb e5                	jmp    801020ad <dirlink+0x7d>
      panic("dirlink read");
801020c8:	83 ec 0c             	sub    $0xc,%esp
801020cb:	68 57 84 10 80       	push   $0x80108457
801020d0:	e8 ab e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020d5:	83 ec 0c             	sub    $0xc,%esp
801020d8:	68 1f 87 10 80       	push   $0x8010871f
801020dd:	e8 9e e2 ff ff       	call   80100380 <panic>
801020e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020e9:	00 
801020ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020f0 <namei>:

struct inode*
namei(char *path)
{
801020f0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020f1:	31 d2                	xor    %edx,%edx
{
801020f3:	89 e5                	mov    %esp,%ebp
801020f5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020f8:	8b 45 08             	mov    0x8(%ebp),%eax
801020fb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020fe:	e8 0d fd ff ff       	call   80101e10 <namex>
}
80102103:	c9                   	leave
80102104:	c3                   	ret
80102105:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010210c:	00 
8010210d:	8d 76 00             	lea    0x0(%esi),%esi

80102110 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102110:	55                   	push   %ebp
  return namex(path, 1, name);
80102111:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102116:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010211b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010211e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010211f:	e9 ec fc ff ff       	jmp    80101e10 <namex>
80102124:	66 90                	xchg   %ax,%ax
80102126:	66 90                	xchg   %ax,%ax
80102128:	66 90                	xchg   %ax,%ax
8010212a:	66 90                	xchg   %ax,%ax
8010212c:	66 90                	xchg   %ax,%ax
8010212e:	66 90                	xchg   %ax,%ax

80102130 <idestart>:
}


static void
idestart(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	57                   	push   %edi
80102134:	56                   	push   %esi
80102135:	53                   	push   %ebx
80102136:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102139:	85 c0                	test   %eax,%eax
8010213b:	0f 84 b4 00 00 00    	je     801021f5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102141:	8b 70 08             	mov    0x8(%eax),%esi
80102144:	89 c3                	mov    %eax,%ebx
80102146:	81 fe e7 1c 00 00    	cmp    $0x1ce7,%esi
8010214c:	0f 87 96 00 00 00    	ja     801021e8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102152:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102157:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010215e:	00 
8010215f:	90                   	nop
80102160:	89 ca                	mov    %ecx,%edx
80102162:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102163:	83 e0 c0             	and    $0xffffffc0,%eax
80102166:	3c 40                	cmp    $0x40,%al
80102168:	75 f6                	jne    80102160 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010216a:	31 ff                	xor    %edi,%edi
8010216c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102171:	89 f8                	mov    %edi,%eax
80102173:	ee                   	out    %al,(%dx)
80102174:	b8 01 00 00 00       	mov    $0x1,%eax
80102179:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010217e:	ee                   	out    %al,(%dx)
8010217f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102184:	89 f0                	mov    %esi,%eax
80102186:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  
  outb(0x1f2, sector_per_block);  
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102187:	89 f0                	mov    %esi,%eax
80102189:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010218e:	c1 f8 08             	sar    $0x8,%eax
80102191:	ee                   	out    %al,(%dx)
80102192:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102197:	89 f8                	mov    %edi,%eax
80102199:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010219a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010219e:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021a3:	c1 e0 04             	shl    $0x4,%eax
801021a6:	83 e0 10             	and    $0x10,%eax
801021a9:	83 c8 e0             	or     $0xffffffe0,%eax
801021ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021ad:	f6 03 04             	testb  $0x4,(%ebx)
801021b0:	75 16                	jne    801021c8 <idestart+0x98>
801021b2:	b8 20 00 00 00       	mov    $0x20,%eax
801021b7:	89 ca                	mov    %ecx,%edx
801021b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021bd:	5b                   	pop    %ebx
801021be:	5e                   	pop    %esi
801021bf:	5f                   	pop    %edi
801021c0:	5d                   	pop    %ebp
801021c1:	c3                   	ret
801021c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021c8:	b8 30 00 00 00       	mov    $0x30,%eax
801021cd:	89 ca                	mov    %ecx,%edx
801021cf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021d0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021d8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021dd:	fc                   	cld
801021de:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021e3:	5b                   	pop    %ebx
801021e4:	5e                   	pop    %esi
801021e5:	5f                   	pop    %edi
801021e6:	5d                   	pop    %ebp
801021e7:	c3                   	ret
    panic("incorrect blockno");
801021e8:	83 ec 0c             	sub    $0xc,%esp
801021eb:	68 6d 84 10 80       	push   $0x8010846d
801021f0:	e8 8b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021f5:	83 ec 0c             	sub    $0xc,%esp
801021f8:	68 64 84 10 80       	push   $0x80108464
801021fd:	e8 7e e1 ff ff       	call   80100380 <panic>
80102202:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102209:	00 
8010220a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102210 <ideinit>:
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102216:	68 7f 84 10 80       	push   $0x8010847f
8010221b:	68 20 26 11 80       	push   $0x80112620
80102220:	e8 2b 28 00 00       	call   80104a50 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102225:	58                   	pop    %eax
80102226:	a1 a4 27 11 80       	mov    0x801127a4,%eax
8010222b:	5a                   	pop    %edx
8010222c:	83 e8 01             	sub    $0x1,%eax
8010222f:	50                   	push   %eax
80102230:	6a 0e                	push   $0xe
80102232:	e8 99 02 00 00       	call   801024d0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102237:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010223a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010223f:	90                   	nop
80102240:	89 ca                	mov    %ecx,%edx
80102242:	ec                   	in     (%dx),%al
80102243:	83 e0 c0             	and    $0xffffffc0,%eax
80102246:	3c 40                	cmp    $0x40,%al
80102248:	75 f6                	jne    80102240 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010224a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010224f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102254:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102255:	89 ca                	mov    %ecx,%edx
80102257:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102258:	84 c0                	test   %al,%al
8010225a:	75 1e                	jne    8010227a <ideinit+0x6a>
8010225c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102261:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102266:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010226d:	00 
8010226e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102270:	83 e9 01             	sub    $0x1,%ecx
80102273:	74 0f                	je     80102284 <ideinit+0x74>
80102275:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102276:	84 c0                	test   %al,%al
80102278:	74 f6                	je     80102270 <ideinit+0x60>
      havedisk1 = 1;
8010227a:	c7 05 00 26 11 80 01 	movl   $0x1,0x80112600
80102281:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102284:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102289:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010228e:	ee                   	out    %al,(%dx)
}
8010228f:	c9                   	leave
80102290:	c3                   	ret
80102291:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102298:	00 
80102299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022a0 <ideintr>:


void
ideintr(void)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	57                   	push   %edi
801022a4:	56                   	push   %esi
801022a5:	53                   	push   %ebx
801022a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  
  acquire(&idelock);
801022a9:	68 20 26 11 80       	push   $0x80112620
801022ae:	e8 8d 29 00 00       	call   80104c40 <acquire>

  if((b = idequeue) == 0){
801022b3:	8b 1d 04 26 11 80    	mov    0x80112604,%ebx
801022b9:	83 c4 10             	add    $0x10,%esp
801022bc:	85 db                	test   %ebx,%ebx
801022be:	74 63                	je     80102323 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022c0:	8b 43 58             	mov    0x58(%ebx),%eax
801022c3:	a3 04 26 11 80       	mov    %eax,0x80112604

  
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022c8:	8b 33                	mov    (%ebx),%esi
801022ca:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022d0:	75 2f                	jne    80102301 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022de:	00 
801022df:	90                   	nop
801022e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022e1:	89 c1                	mov    %eax,%ecx
801022e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022e6:	80 f9 40             	cmp    $0x40,%cl
801022e9:	75 f5                	jne    801022e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022eb:	a8 21                	test   $0x21,%al
801022ed:	75 12                	jne    80102301 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022fc:	fc                   	cld
801022fd:	f3 6d                	rep insl (%dx),%es:(%edi)

  
  b->flags |= B_VALID;
801022ff:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102301:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102304:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102307:	83 ce 02             	or     $0x2,%esi
8010230a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010230c:	53                   	push   %ebx
8010230d:	e8 9e 1e 00 00       	call   801041b0 <wakeup>

  
  if(idequeue != 0)
80102312:	a1 04 26 11 80       	mov    0x80112604,%eax
80102317:	83 c4 10             	add    $0x10,%esp
8010231a:	85 c0                	test   %eax,%eax
8010231c:	74 05                	je     80102323 <ideintr+0x83>
    idestart(idequeue);
8010231e:	e8 0d fe ff ff       	call   80102130 <idestart>
    release(&idelock);
80102323:	83 ec 0c             	sub    $0xc,%esp
80102326:	68 20 26 11 80       	push   $0x80112620
8010232b:	e8 b0 28 00 00       	call   80104be0 <release>

  release(&idelock);
}
80102330:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102333:	5b                   	pop    %ebx
80102334:	5e                   	pop    %esi
80102335:	5f                   	pop    %edi
80102336:	5d                   	pop    %ebp
80102337:	c3                   	ret
80102338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010233f:	00 

80102340 <iderw>:



void
iderw(struct buf *b)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 10             	sub    $0x10,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010234a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010234d:	50                   	push   %eax
8010234e:	e8 ad 26 00 00       	call   80104a00 <holdingsleep>
80102353:	83 c4 10             	add    $0x10,%esp
80102356:	85 c0                	test   %eax,%eax
80102358:	0f 84 c3 00 00 00    	je     80102421 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 e0 06             	and    $0x6,%eax
80102363:	83 f8 02             	cmp    $0x2,%eax
80102366:	0f 84 a8 00 00 00    	je     80102414 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010236c:	8b 53 04             	mov    0x4(%ebx),%edx
8010236f:	85 d2                	test   %edx,%edx
80102371:	74 0d                	je     80102380 <iderw+0x40>
80102373:	a1 00 26 11 80       	mov    0x80112600,%eax
80102378:	85 c0                	test   %eax,%eax
8010237a:	0f 84 87 00 00 00    	je     80102407 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 20 26 11 80       	push   $0x80112620
80102388:	e8 b3 28 00 00       	call   80104c40 <acquire>

  
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  
8010238d:	a1 04 26 11 80       	mov    0x80112604,%eax
  b->qnext = 0;
80102392:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  
80102399:	83 c4 10             	add    $0x10,%esp
8010239c:	85 c0                	test   %eax,%eax
8010239e:	74 60                	je     80102400 <iderw+0xc0>
801023a0:	89 c2                	mov    %eax,%edx
801023a2:	8b 40 58             	mov    0x58(%eax),%eax
801023a5:	85 c0                	test   %eax,%eax
801023a7:	75 f7                	jne    801023a0 <iderw+0x60>
801023a9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023ac:	89 1a                	mov    %ebx,(%edx)

  
  if(idequeue == b)
801023ae:	39 1d 04 26 11 80    	cmp    %ebx,0x80112604
801023b4:	74 3a                	je     801023f0 <iderw+0xb0>
    idestart(b);

  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023b6:	8b 03                	mov    (%ebx),%eax
801023b8:	83 e0 06             	and    $0x6,%eax
801023bb:	83 f8 02             	cmp    $0x2,%eax
801023be:	74 1b                	je     801023db <iderw+0x9b>
    sleep(b, &idelock);
801023c0:	83 ec 08             	sub    $0x8,%esp
801023c3:	68 20 26 11 80       	push   $0x80112620
801023c8:	53                   	push   %ebx
801023c9:	e8 22 1d 00 00       	call   801040f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023ce:	8b 03                	mov    (%ebx),%eax
801023d0:	83 c4 10             	add    $0x10,%esp
801023d3:	83 e0 06             	and    $0x6,%eax
801023d6:	83 f8 02             	cmp    $0x2,%eax
801023d9:	75 e5                	jne    801023c0 <iderw+0x80>
  }


  release(&idelock);
801023db:	c7 45 08 20 26 11 80 	movl   $0x80112620,0x8(%ebp)
}
801023e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023e5:	c9                   	leave
  release(&idelock);
801023e6:	e9 f5 27 00 00       	jmp    80104be0 <release>
801023eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801023f0:	89 d8                	mov    %ebx,%eax
801023f2:	e8 39 fd ff ff       	call   80102130 <idestart>
801023f7:	eb bd                	jmp    801023b6 <iderw+0x76>
801023f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  
80102400:	ba 04 26 11 80       	mov    $0x80112604,%edx
80102405:	eb a5                	jmp    801023ac <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 ae 84 10 80       	push   $0x801084ae
8010240f:	e8 6c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102414:	83 ec 0c             	sub    $0xc,%esp
80102417:	68 99 84 10 80       	push   $0x80108499
8010241c:	e8 5f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102421:	83 ec 0c             	sub    $0xc,%esp
80102424:	68 83 84 10 80       	push   $0x80108483
80102429:	e8 52 df ff ff       	call   80100380 <panic>
8010242e:	66 90                	xchg   %ax,%ax

80102430 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102435:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
8010243c:	00 c0 fe 
  ioapic->reg = reg;
8010243f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102446:	00 00 00 
  return ioapic->data;
80102449:	8b 15 54 26 11 80    	mov    0x80112654,%edx
8010244f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102452:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102458:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010245e:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102465:	c1 ee 10             	shr    $0x10,%esi
80102468:	89 f0                	mov    %esi,%eax
8010246a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010246d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102470:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102473:	39 c2                	cmp    %eax,%edx
80102475:	74 16                	je     8010248d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102477:	83 ec 0c             	sub    $0xc,%esp
8010247a:	68 ac 88 10 80       	push   $0x801088ac
8010247f:	e8 2c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102484:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
8010248a:	83 c4 10             	add    $0x10,%esp
{
8010248d:	ba 10 00 00 00       	mov    $0x10,%edx
80102492:	31 c0                	xor    %eax,%eax
80102494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102498:	89 13                	mov    %edx,(%ebx)
8010249a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010249d:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx

  
  
  for(i = 0; i <= maxintr; i++){
801024a3:	83 c0 01             	add    $0x1,%eax
801024a6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801024ac:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801024af:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801024b2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024b5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801024b7:	8b 1d 54 26 11 80    	mov    0x80112654,%ebx
801024bd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801024c4:	39 c6                	cmp    %eax,%esi
801024c6:	7d d0                	jge    80102498 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024cb:	5b                   	pop    %ebx
801024cc:	5e                   	pop    %esi
801024cd:	5d                   	pop    %ebp
801024ce:	c3                   	ret
801024cf:	90                   	nop

801024d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024d0:	55                   	push   %ebp
  ioapic->reg = reg;
801024d1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
801024d7:	89 e5                	mov    %esp,%ebp
801024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  
  
  
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024dc:	8d 50 20             	lea    0x20(%eax),%edx
801024df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024e5:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024f6:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102501:	5d                   	pop    %ebp
80102502:	c3                   	ret
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kfree>:



void
kfree(char *v)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	53                   	push   %ebx
80102514:	83 ec 04             	sub    $0x4,%esp
80102517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010251a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102520:	75 76                	jne    80102598 <kfree+0x88>
80102522:	81 fb 60 81 11 80    	cmp    $0x80118160,%ebx
80102528:	72 6e                	jb     80102598 <kfree+0x88>
8010252a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102530:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
80102535:	77 61                	ja     80102598 <kfree+0x88>
    panic("kfree");

  
  memset(v, 1, PGSIZE);
80102537:	83 ec 04             	sub    $0x4,%esp
8010253a:	68 00 10 00 00       	push   $0x1000
8010253f:	6a 01                	push   $0x1
80102541:	53                   	push   %ebx
80102542:	e8 f9 27 00 00       	call   80104d40 <memset>

  if(kmem.use_lock)
80102547:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	85 d2                	test   %edx,%edx
80102552:	75 1c                	jne    80102570 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102554:	a1 98 26 11 80       	mov    0x80112698,%eax
80102559:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010255b:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
80102560:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
80102566:	85 c0                	test   %eax,%eax
80102568:	75 1e                	jne    80102588 <kfree+0x78>
    release(&kmem.lock);
}
8010256a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010256d:	c9                   	leave
8010256e:	c3                   	ret
8010256f:	90                   	nop
    acquire(&kmem.lock);
80102570:	83 ec 0c             	sub    $0xc,%esp
80102573:	68 60 26 11 80       	push   $0x80112660
80102578:	e8 c3 26 00 00       	call   80104c40 <acquire>
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	eb d2                	jmp    80102554 <kfree+0x44>
80102582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102588:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010258f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102592:	c9                   	leave
    release(&kmem.lock);
80102593:	e9 48 26 00 00       	jmp    80104be0 <release>
    panic("kfree");
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	68 cc 84 10 80       	push   $0x801084cc
801025a0:	e8 db dd ff ff       	call   80100380 <panic>
801025a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ac:	00 
801025ad:	8d 76 00             	lea    0x0(%esi),%esi

801025b0 <freerange>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
801025b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <freerange+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 23 ff ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <freerange+0x28>
}
801025f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025f7:	5b                   	pop    %ebx
801025f8:	5e                   	pop    %esi
801025f9:	5d                   	pop    %ebp
801025fa:	c3                   	ret
801025fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102600 <kinit2>:
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	56                   	push   %esi
80102604:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102605:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102608:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010260b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102611:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102617:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010261d:	39 de                	cmp    %ebx,%esi
8010261f:	72 23                	jb     80102644 <kinit2+0x44>
80102621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102628:	83 ec 0c             	sub    $0xc,%esp
8010262b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102631:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102637:	50                   	push   %eax
80102638:	e8 d3 fe ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	39 de                	cmp    %ebx,%esi
80102642:	73 e4                	jae    80102628 <kinit2+0x28>
  kmem.use_lock = 1;
80102644:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010264b:	00 00 00 
}
8010264e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102651:	5b                   	pop    %ebx
80102652:	5e                   	pop    %esi
80102653:	5d                   	pop    %ebp
80102654:	c3                   	ret
80102655:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010265c:	00 
8010265d:	8d 76 00             	lea    0x0(%esi),%esi

80102660 <kinit1>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
80102664:	53                   	push   %ebx
80102665:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102668:	83 ec 08             	sub    $0x8,%esp
8010266b:	68 d2 84 10 80       	push   $0x801084d2
80102670:	68 60 26 11 80       	push   $0x80112660
80102675:	e8 d6 23 00 00       	call   80104a50 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010267a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010267d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102680:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102687:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010268a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102690:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102696:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010269c:	39 de                	cmp    %ebx,%esi
8010269e:	72 1c                	jb     801026bc <kinit1+0x5c>
    kfree(p);
801026a0:	83 ec 0c             	sub    $0xc,%esp
801026a3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026af:	50                   	push   %eax
801026b0:	e8 5b fe ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b5:	83 c4 10             	add    $0x10,%esp
801026b8:	39 de                	cmp    %ebx,%esi
801026ba:	73 e4                	jae    801026a0 <kinit1+0x40>
}
801026bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026bf:	5b                   	pop    %ebx
801026c0:	5e                   	pop    %esi
801026c1:	5d                   	pop    %ebp
801026c2:	c3                   	ret
801026c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026ca:	00 
801026cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801026d0 <count_free_pages>:


int count_free_pages(void) {
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	53                   	push   %ebx
    struct run *r;
    int count = 0;
801026d4:	31 db                	xor    %ebx,%ebx
int count_free_pages(void) {
801026d6:	83 ec 10             	sub    $0x10,%esp

    acquire(&kmem.lock);
801026d9:	68 60 26 11 80       	push   $0x80112660
801026de:	e8 5d 25 00 00       	call   80104c40 <acquire>
    for (r = kmem.freelist; r != 0; r = r->next)
801026e3:	a1 98 26 11 80       	mov    0x80112698,%eax
801026e8:	83 c4 10             	add    $0x10,%esp
801026eb:	85 c0                	test   %eax,%eax
801026ed:	74 0a                	je     801026f9 <count_free_pages+0x29>
801026ef:	90                   	nop
801026f0:	8b 00                	mov    (%eax),%eax
        count++;
801026f2:	83 c3 01             	add    $0x1,%ebx
    for (r = kmem.freelist; r != 0; r = r->next)
801026f5:	85 c0                	test   %eax,%eax
801026f7:	75 f7                	jne    801026f0 <count_free_pages+0x20>
    release(&kmem.lock);
801026f9:	83 ec 0c             	sub    $0xc,%esp
801026fc:	68 60 26 11 80       	push   $0x80112660
80102701:	e8 da 24 00 00       	call   80104be0 <release>

    return count;
}
80102706:	89 d8                	mov    %ebx,%eax
80102708:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010270b:	c9                   	leave
8010270c:	c3                   	ret
8010270d:	8d 76 00             	lea    0x0(%esi),%esi

80102710 <kalloc>:



char*
kalloc(void)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	53                   	push   %ebx
80102714:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102717:	a1 94 26 11 80       	mov    0x80112694,%eax
8010271c:	85 c0                	test   %eax,%eax
8010271e:	75 20                	jne    80102740 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102720:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
80102726:	85 db                	test   %ebx,%ebx
80102728:	74 07                	je     80102731 <kalloc+0x21>
    kmem.freelist = r->next;
8010272a:	8b 03                	mov    (%ebx),%eax
8010272c:	a3 98 26 11 80       	mov    %eax,0x80112698
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102731:	89 d8                	mov    %ebx,%eax
80102733:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102736:	c9                   	leave
80102737:	c3                   	ret
80102738:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010273f:	00 
    acquire(&kmem.lock);
80102740:	83 ec 0c             	sub    $0xc,%esp
80102743:	68 60 26 11 80       	push   $0x80112660
80102748:	e8 f3 24 00 00       	call   80104c40 <acquire>
  r = kmem.freelist;
8010274d:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(kmem.use_lock)
80102753:	a1 94 26 11 80       	mov    0x80112694,%eax
  if(r)
80102758:	83 c4 10             	add    $0x10,%esp
8010275b:	85 db                	test   %ebx,%ebx
8010275d:	74 08                	je     80102767 <kalloc+0x57>
    kmem.freelist = r->next;
8010275f:	8b 13                	mov    (%ebx),%edx
80102761:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
80102767:	85 c0                	test   %eax,%eax
80102769:	74 c6                	je     80102731 <kalloc+0x21>
    release(&kmem.lock);
8010276b:	83 ec 0c             	sub    $0xc,%esp
8010276e:	68 60 26 11 80       	push   $0x80112660
80102773:	e8 68 24 00 00       	call   80104be0 <release>
}
80102778:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010277a:	83 c4 10             	add    $0x10,%esp
}
8010277d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102780:	c9                   	leave
80102781:	c3                   	ret
80102782:	66 90                	xchg   %ax,%ax
80102784:	66 90                	xchg   %ax,%ax
80102786:	66 90                	xchg   %ax,%ax
80102788:	66 90                	xchg   %ax,%ax
8010278a:	66 90                	xchg   %ax,%ax
8010278c:	66 90                	xchg   %ax,%ax
8010278e:	66 90                	xchg   %ax,%ax

80102790 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102790:	ba 64 00 00 00       	mov    $0x64,%edx
80102795:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102796:	a8 01                	test   $0x1,%al
80102798:	0f 84 c2 00 00 00    	je     80102860 <kbdgetc+0xd0>
{
8010279e:	55                   	push   %ebp
8010279f:	ba 60 00 00 00       	mov    $0x60,%edx
801027a4:	89 e5                	mov    %esp,%ebp
801027a6:	53                   	push   %ebx
801027a7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801027a8:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  data = inb(KBDATAP);
801027ae:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801027b1:	3c e0                	cmp    $0xe0,%al
801027b3:	74 5b                	je     80102810 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    
    data = (shift & E0ESC ? data : data & 0x7F);
801027b5:	89 da                	mov    %ebx,%edx
801027b7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801027ba:	84 c0                	test   %al,%al
801027bc:	78 62                	js     80102820 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027be:	85 d2                	test   %edx,%edx
801027c0:	74 09                	je     801027cb <kbdgetc+0x3b>
    
    data |= 0x80;
801027c2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027c5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801027c8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801027cb:	0f b6 91 60 8b 10 80 	movzbl -0x7fef74a0(%ecx),%edx
  shift ^= togglecode[data];
801027d2:	0f b6 81 60 8a 10 80 	movzbl -0x7fef75a0(%ecx),%eax
  shift |= shiftcode[data];
801027d9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027db:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027dd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027df:	89 15 9c 26 11 80    	mov    %edx,0x8011269c
  c = charcode[shift & (CTL | SHIFT)][data];
801027e5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027e8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027eb:	8b 04 85 40 8a 10 80 	mov    -0x7fef75c0(,%eax,4),%eax
801027f2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027f6:	74 0b                	je     80102803 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027f8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027fb:	83 fa 19             	cmp    $0x19,%edx
801027fe:	77 48                	ja     80102848 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102800:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102803:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102806:	c9                   	leave
80102807:	c3                   	ret
80102808:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010280f:	00 
    shift |= E0ESC;
80102810:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102813:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102815:	89 1d 9c 26 11 80    	mov    %ebx,0x8011269c
}
8010281b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010281e:	c9                   	leave
8010281f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102820:	83 e0 7f             	and    $0x7f,%eax
80102823:	85 d2                	test   %edx,%edx
80102825:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102828:	0f b6 81 60 8b 10 80 	movzbl -0x7fef74a0(%ecx),%eax
8010282f:	83 c8 40             	or     $0x40,%eax
80102832:	0f b6 c0             	movzbl %al,%eax
80102835:	f7 d0                	not    %eax
80102837:	21 d8                	and    %ebx,%eax
80102839:	a3 9c 26 11 80       	mov    %eax,0x8011269c
    return 0;
8010283e:	31 c0                	xor    %eax,%eax
80102840:	eb d9                	jmp    8010281b <kbdgetc+0x8b>
80102842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102848:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010284b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010284e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102851:	c9                   	leave
      c += 'a' - 'A';
80102852:	83 f9 1a             	cmp    $0x1a,%ecx
80102855:	0f 42 c2             	cmovb  %edx,%eax
}
80102858:	c3                   	ret
80102859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102865:	c3                   	ret
80102866:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010286d:	00 
8010286e:	66 90                	xchg   %ax,%ax

80102870 <kbdintr>:

void
kbdintr(void)
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102876:	68 90 27 10 80       	push   $0x80102790
8010287b:	e8 20 e0 ff ff       	call   801008a0 <consoleintr>
}
80102880:	83 c4 10             	add    $0x10,%esp
80102883:	c9                   	leave
80102884:	c3                   	ret
80102885:	66 90                	xchg   %ax,%ax
80102887:	66 90                	xchg   %ax,%ax
80102889:	66 90                	xchg   %ax,%ax
8010288b:	66 90                	xchg   %ax,%ax
8010288d:	66 90                	xchg   %ax,%ax
8010288f:	90                   	nop

80102890 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102890:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102895:	85 c0                	test   %eax,%eax
80102897:	0f 84 c3 00 00 00    	je     80102960 <lapicinit+0xd0>
  lapic[index] = value;
8010289d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028a4:	01 00 00 
  lapic[ID];  
801028a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028aa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028b1:	00 00 00 
  lapic[ID];  
801028b4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028be:	00 02 00 
  lapic[ID];  
801028c1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028cb:	96 98 00 
  lapic[ID];  
801028ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028d8:	00 01 00 
  lapic[ID];  
801028db:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028de:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028e5:	00 01 00 
  lapic[ID];  
801028e8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  
  
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028eb:	8b 50 30             	mov    0x30(%eax),%edx
801028ee:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
801028f4:	75 72                	jne    80102968 <lapicinit+0xd8>
  lapic[index] = value;
801028f6:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028fd:	00 00 00 
  lapic[ID];  
80102900:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102903:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010290a:	00 00 00 
  lapic[ID];  
8010290d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102910:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102917:	00 00 00 
  lapic[ID];  
8010291a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102924:	00 00 00 
  lapic[ID];  
80102927:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010292a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102931:	00 00 00 
  lapic[ID];  
80102934:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102937:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010293e:	85 08 00 
  lapic[ID];  
80102941:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102948:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010294e:	80 e6 10             	and    $0x10,%dh
80102951:	75 f5                	jne    80102948 <lapicinit+0xb8>
  lapic[index] = value;
80102953:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010295a:	00 00 00 
  lapic[ID];  
8010295d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  
  lapicw(TPR, 0);
}
80102960:	c3                   	ret
80102961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102968:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010296f:	00 01 00 
  lapic[ID];  
80102972:	8b 50 20             	mov    0x20(%eax),%edx
}
80102975:	e9 7c ff ff ff       	jmp    801028f6 <lapicinit+0x66>
8010297a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102980 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102980:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102985:	85 c0                	test   %eax,%eax
80102987:	74 07                	je     80102990 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102989:	8b 40 20             	mov    0x20(%eax),%eax
8010298c:	c1 e8 18             	shr    $0x18,%eax
8010298f:	c3                   	ret
    return 0;
80102990:	31 c0                	xor    %eax,%eax
}
80102992:	c3                   	ret
80102993:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010299a:	00 
8010299b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801029a0 <lapiceoi>:


void
lapiceoi(void)
{
  if(lapic)
801029a0:	a1 a0 26 11 80       	mov    0x801126a0,%eax
801029a5:	85 c0                	test   %eax,%eax
801029a7:	74 0d                	je     801029b6 <lapiceoi+0x16>
  lapic[index] = value;
801029a9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029b0:	00 00 00 
  lapic[ID];  
801029b3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029b6:	c3                   	ret
801029b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029be:	00 
801029bf:	90                   	nop

801029c0 <microdelay>:


void
microdelay(int us)
{
}
801029c0:	c3                   	ret
801029c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029c8:	00 
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029d0 <lapicstartap>:



void
lapicstartap(uchar apicid, uint addr)
{
801029d0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	53                   	push   %ebx
801029de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029e4:	ee                   	out    %al,(%dx)
801029e5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029ea:	ba 71 00 00 00       	mov    $0x71,%edx
801029ef:	ee                   	out    %al,(%dx)
  
  
  outb(CMOS_PORT, 0xF);  
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  
  wrv[0] = 0;
801029f0:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
801029f2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029f5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029fb:	89 c8                	mov    %ecx,%eax
  
  
  
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029fd:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102a00:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a02:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a05:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a08:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a0e:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102a13:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  
80102a19:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a1c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a23:	c5 00 00 
  lapic[ID];  
80102a26:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a29:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a30:	85 00 00 
  lapic[ID];  
80102a33:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a36:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  
80102a3c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a3f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  
80102a45:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a48:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  
80102a4e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a51:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  
80102a57:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a5d:	c9                   	leave
80102a5e:	c3                   	ret
80102a5f:	90                   	nop

80102a60 <cmostime>:
}


void
cmostime(struct rtcdate *r)
{
80102a60:	55                   	push   %ebp
80102a61:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a66:	ba 70 00 00 00       	mov    $0x70,%edx
80102a6b:	89 e5                	mov    %esp,%ebp
80102a6d:	57                   	push   %edi
80102a6e:	56                   	push   %esi
80102a6f:	53                   	push   %ebx
80102a70:	83 ec 4c             	sub    $0x4c,%esp
80102a73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a74:	ba 71 00 00 00       	mov    $0x71,%edx
80102a79:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a7a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7d:	bf 70 00 00 00       	mov    $0x70,%edi
80102a82:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a85:	8d 76 00             	lea    0x0(%esi),%esi
80102a88:	31 c0                	xor    %eax,%eax
80102a8a:	89 fa                	mov    %edi,%edx
80102a8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a92:	89 ca                	mov    %ecx,%edx
80102a94:	ec                   	in     (%dx),%al
80102a95:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a98:	89 fa                	mov    %edi,%edx
80102a9a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa0:	89 ca                	mov    %ecx,%edx
80102aa2:	ec                   	in     (%dx),%al
80102aa3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa6:	89 fa                	mov    %edi,%edx
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 fa                	mov    %edi,%edx
80102ab6:	b8 07 00 00 00       	mov    $0x7,%eax
80102abb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abc:	89 ca                	mov    %ecx,%edx
80102abe:	ec                   	in     (%dx),%al
80102abf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac2:	89 fa                	mov    %edi,%edx
80102ac4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ac9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aca:	89 ca                	mov    %ecx,%edx
80102acc:	ec                   	in     (%dx),%al
80102acd:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acf:	89 fa                	mov    %edi,%edx
80102ad1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ad6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad7:	89 ca                	mov    %ecx,%edx
80102ad9:	ec                   	in     (%dx),%al
80102ada:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102add:	89 fa                	mov    %edi,%edx
80102adf:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ae4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae5:	89 ca                	mov    %ecx,%edx
80102ae7:	ec                   	in     (%dx),%al

  
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ae8:	84 c0                	test   %al,%al
80102aea:	78 9c                	js     80102a88 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102aec:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102af0:	89 f2                	mov    %esi,%edx
80102af2:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102af5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af8:	89 fa                	mov    %edi,%edx
80102afa:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102afd:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b01:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102b04:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b07:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b0b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b0e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b12:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b15:	31 c0                	xor    %eax,%eax
80102b17:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b18:	89 ca                	mov    %ecx,%edx
80102b1a:	ec                   	in     (%dx),%al
80102b1b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b1e:	89 fa                	mov    %edi,%edx
80102b20:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b23:	b8 02 00 00 00       	mov    $0x2,%eax
80102b28:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b29:	89 ca                	mov    %ecx,%edx
80102b2b:	ec                   	in     (%dx),%al
80102b2c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2f:	89 fa                	mov    %edi,%edx
80102b31:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b34:	b8 04 00 00 00       	mov    $0x4,%eax
80102b39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3a:	89 ca                	mov    %ecx,%edx
80102b3c:	ec                   	in     (%dx),%al
80102b3d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b40:	89 fa                	mov    %edi,%edx
80102b42:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b45:	b8 07 00 00 00       	mov    $0x7,%eax
80102b4a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4b:	89 ca                	mov    %ecx,%edx
80102b4d:	ec                   	in     (%dx),%al
80102b4e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b51:	89 fa                	mov    %edi,%edx
80102b53:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b56:	b8 08 00 00 00       	mov    $0x8,%eax
80102b5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5c:	89 ca                	mov    %ecx,%edx
80102b5e:	ec                   	in     (%dx),%al
80102b5f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b62:	89 fa                	mov    %edi,%edx
80102b64:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b67:	b8 09 00 00 00       	mov    $0x9,%eax
80102b6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6d:	89 ca                	mov    %ecx,%edx
80102b6f:	ec                   	in     (%dx),%al
80102b70:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b73:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b79:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b7c:	6a 18                	push   $0x18
80102b7e:	50                   	push   %eax
80102b7f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b82:	50                   	push   %eax
80102b83:	e8 f8 21 00 00       	call   80104d80 <memcmp>
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 c0                	test   %eax,%eax
80102b8d:	0f 85 f5 fe ff ff    	jne    80102a88 <cmostime+0x28>
      break;
  }

  
  if(bcd) {
80102b93:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b9a:	89 f0                	mov    %esi,%eax
80102b9c:	84 c0                	test   %al,%al
80102b9e:	75 78                	jne    80102c18 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ba0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ba3:	89 c2                	mov    %eax,%edx
80102ba5:	83 e0 0f             	and    $0xf,%eax
80102ba8:	c1 ea 04             	shr    $0x4,%edx
80102bab:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bae:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102bb4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bb7:	89 c2                	mov    %eax,%edx
80102bb9:	83 e0 0f             	and    $0xf,%eax
80102bbc:	c1 ea 04             	shr    $0x4,%edx
80102bbf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bc2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bc5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102bc8:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bcb:	89 c2                	mov    %eax,%edx
80102bcd:	83 e0 0f             	and    $0xf,%eax
80102bd0:	c1 ea 04             	shr    $0x4,%edx
80102bd3:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bd6:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bd9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bdc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bdf:	89 c2                	mov    %eax,%edx
80102be1:	83 e0 0f             	and    $0xf,%eax
80102be4:	c1 ea 04             	shr    $0x4,%edx
80102be7:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bea:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bf0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bf3:	89 c2                	mov    %eax,%edx
80102bf5:	83 e0 0f             	and    $0xf,%eax
80102bf8:	c1 ea 04             	shr    $0x4,%edx
80102bfb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bfe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c01:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c04:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c07:	89 c2                	mov    %eax,%edx
80102c09:	83 e0 0f             	and    $0xf,%eax
80102c0c:	c1 ea 04             	shr    $0x4,%edx
80102c0f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c12:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c15:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c18:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c1b:	89 03                	mov    %eax,(%ebx)
80102c1d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c20:	89 43 04             	mov    %eax,0x4(%ebx)
80102c23:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c26:	89 43 08             	mov    %eax,0x8(%ebx)
80102c29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c2c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102c2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c32:	89 43 10             	mov    %eax,0x10(%ebx)
80102c35:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c38:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102c3b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c45:	5b                   	pop    %ebx
80102c46:	5e                   	pop    %esi
80102c47:	5f                   	pop    %edi
80102c48:	5d                   	pop    %ebp
80102c49:	c3                   	ret
80102c4a:	66 90                	xchg   %ax,%ax
80102c4c:	66 90                	xchg   %ax,%ax
80102c4e:	66 90                	xchg   %ax,%ax

80102c50 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c50:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102c56:	85 c9                	test   %ecx,%ecx
80102c58:	0f 8e 8a 00 00 00    	jle    80102ce8 <install_trans+0x98>
{
80102c5e:	55                   	push   %ebp
80102c5f:	89 e5                	mov    %esp,%ebp
80102c61:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c62:	31 ff                	xor    %edi,%edi
{
80102c64:	56                   	push   %esi
80102c65:	53                   	push   %ebx
80102c66:	83 ec 0c             	sub    $0xc,%esp
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); 
80102c70:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102c75:	83 ec 08             	sub    $0x8,%esp
80102c78:	01 f8                	add    %edi,%eax
80102c7a:	83 c0 01             	add    $0x1,%eax
80102c7d:	50                   	push   %eax
80102c7e:	ff 35 04 27 11 80    	push   0x80112704
80102c84:	e8 47 d4 ff ff       	call   801000d0 <bread>
80102c89:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); 
80102c8b:	58                   	pop    %eax
80102c8c:	5a                   	pop    %edx
80102c8d:	ff 34 bd 0c 27 11 80 	push   -0x7feed8f4(,%edi,4)
80102c94:	ff 35 04 27 11 80    	push   0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); 
80102c9d:	e8 2e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  
80102ca2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); 
80102ca5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  
80102ca7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102caa:	68 00 02 00 00       	push   $0x200
80102caf:	50                   	push   %eax
80102cb0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102cb3:	50                   	push   %eax
80102cb4:	e8 17 21 00 00       	call   80104dd0 <memmove>
    bwrite(dbuf);  
80102cb9:	89 1c 24             	mov    %ebx,(%esp)
80102cbc:	e8 ef d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102cc1:	89 34 24             	mov    %esi,(%esp)
80102cc4:	e8 27 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102cc9:	89 1c 24             	mov    %ebx,(%esp)
80102ccc:	e8 1f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd1:	83 c4 10             	add    $0x10,%esp
80102cd4:	39 3d 08 27 11 80    	cmp    %edi,0x80112708
80102cda:	7f 94                	jg     80102c70 <install_trans+0x20>
  }
}
80102cdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cdf:	5b                   	pop    %ebx
80102ce0:	5e                   	pop    %esi
80102ce1:	5f                   	pop    %edi
80102ce2:	5d                   	pop    %ebp
80102ce3:	c3                   	ret
80102ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ce8:	c3                   	ret
80102ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cf0 <write_head>:



static void
write_head(void)
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	53                   	push   %ebx
80102cf4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cf7:	ff 35 f4 26 11 80    	push   0x801126f4
80102cfd:	ff 35 04 27 11 80    	push   0x80112704
80102d03:	e8 c8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d08:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d0b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d0d:	a1 08 27 11 80       	mov    0x80112708,%eax
80102d12:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d15:	85 c0                	test   %eax,%eax
80102d17:	7e 19                	jle    80102d32 <write_head+0x42>
80102d19:	31 d2                	xor    %edx,%edx
80102d1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102d20:	8b 0c 95 0c 27 11 80 	mov    -0x7feed8f4(,%edx,4),%ecx
80102d27:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d0                	cmp    %edx,%eax
80102d30:	75 ee                	jne    80102d20 <write_head+0x30>
  }
  bwrite(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	53                   	push   %ebx
80102d36:	e8 75 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d3b:	89 1c 24             	mov    %ebx,(%esp)
80102d3e:	e8 ad d4 ff ff       	call   801001f0 <brelse>
}
80102d43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d46:	83 c4 10             	add    $0x10,%esp
80102d49:	c9                   	leave
80102d4a:	c3                   	ret
80102d4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102d50 <initlog>:
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	53                   	push   %ebx
80102d54:	83 ec 3c             	sub    $0x3c,%esp
80102d57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d5a:	68 d7 84 10 80       	push   $0x801084d7
80102d5f:	68 c0 26 11 80       	push   $0x801126c0
80102d64:	e8 e7 1c 00 00       	call   80104a50 <initlock>
  readsb(dev, &sb);
80102d69:	58                   	pop    %eax
80102d6a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80102d6d:	5a                   	pop    %edx
80102d6e:	50                   	push   %eax
80102d6f:	53                   	push   %ebx
80102d70:	e8 3b e8 ff ff       	call   801015b0 <readsb>
  log.start = sb.logstart;
80102d75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d78:	59                   	pop    %ecx
  log.dev = dev;
80102d79:	89 1d 04 27 11 80    	mov    %ebx,0x80112704
  log.size = sb.nlog;
80102d7f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  log.start = sb.logstart;
80102d82:	a3 f4 26 11 80       	mov    %eax,0x801126f4
  log.size = sb.nlog;
80102d87:	89 15 f8 26 11 80    	mov    %edx,0x801126f8
  struct buf *buf = bread(log.dev, log.start);
80102d8d:	5a                   	pop    %edx
80102d8e:	50                   	push   %eax
80102d8f:	53                   	push   %ebx
80102d90:	e8 3b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d95:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d98:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d9b:	89 1d 08 27 11 80    	mov    %ebx,0x80112708
  for (i = 0; i < log.lh.n; i++) {
80102da1:	85 db                	test   %ebx,%ebx
80102da3:	7e 1d                	jle    80102dc2 <initlog+0x72>
80102da5:	31 d2                	xor    %edx,%edx
80102da7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dae:	00 
80102daf:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102db0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102db4:	89 0c 95 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dbb:	83 c2 01             	add    $0x1,%edx
80102dbe:	39 d3                	cmp    %edx,%ebx
80102dc0:	75 ee                	jne    80102db0 <initlog+0x60>
  brelse(buf);
80102dc2:	83 ec 0c             	sub    $0xc,%esp
80102dc5:	50                   	push   %eax
80102dc6:	e8 25 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); 
80102dcb:	e8 80 fe ff ff       	call   80102c50 <install_trans>
  log.lh.n = 0;
80102dd0:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
80102dd7:	00 00 00 
  write_head(); 
80102dda:	e8 11 ff ff ff       	call   80102cf0 <write_head>
}
80102ddf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102de2:	83 c4 10             	add    $0x10,%esp
80102de5:	c9                   	leave
80102de6:	c3                   	ret
80102de7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dee:	00 
80102def:	90                   	nop

80102df0 <begin_op>:
}


void
begin_op(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102df6:	68 c0 26 11 80       	push   $0x801126c0
80102dfb:	e8 40 1e 00 00       	call   80104c40 <acquire>
80102e00:	83 c4 10             	add    $0x10,%esp
80102e03:	eb 18                	jmp    80102e1d <begin_op+0x2d>
80102e05:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e08:	83 ec 08             	sub    $0x8,%esp
80102e0b:	68 c0 26 11 80       	push   $0x801126c0
80102e10:	68 c0 26 11 80       	push   $0x801126c0
80102e15:	e8 d6 12 00 00       	call   801040f0 <sleep>
80102e1a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e1d:	a1 00 27 11 80       	mov    0x80112700,%eax
80102e22:	85 c0                	test   %eax,%eax
80102e24:	75 e2                	jne    80102e08 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e26:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102e2b:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80102e31:	83 c0 01             	add    $0x1,%eax
80102e34:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e37:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e3a:	83 fa 1e             	cmp    $0x1e,%edx
80102e3d:	7f c9                	jg     80102e08 <begin_op+0x18>
      
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e3f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e42:	a3 fc 26 11 80       	mov    %eax,0x801126fc
      release(&log.lock);
80102e47:	68 c0 26 11 80       	push   $0x801126c0
80102e4c:	e8 8f 1d 00 00       	call   80104be0 <release>
      break;
    }
  }
}
80102e51:	83 c4 10             	add    $0x10,%esp
80102e54:	c9                   	leave
80102e55:	c3                   	ret
80102e56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e5d:	00 
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <end_op>:



void
end_op(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	57                   	push   %edi
80102e64:	56                   	push   %esi
80102e65:	53                   	push   %ebx
80102e66:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e69:	68 c0 26 11 80       	push   $0x801126c0
80102e6e:	e8 cd 1d 00 00       	call   80104c40 <acquire>
  log.outstanding -= 1;
80102e73:	a1 fc 26 11 80       	mov    0x801126fc,%eax
  if(log.committing)
80102e78:	8b 35 00 27 11 80    	mov    0x80112700,%esi
80102e7e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e81:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e84:	89 1d fc 26 11 80    	mov    %ebx,0x801126fc
  if(log.committing)
80102e8a:	85 f6                	test   %esi,%esi
80102e8c:	0f 85 22 01 00 00    	jne    80102fb4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e92:	85 db                	test   %ebx,%ebx
80102e94:	0f 85 f6 00 00 00    	jne    80102f90 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e9a:	c7 05 00 27 11 80 01 	movl   $0x1,0x80112700
80102ea1:	00 00 00 
    
    
    
    wakeup(&log);
  }
  release(&log.lock);
80102ea4:	83 ec 0c             	sub    $0xc,%esp
80102ea7:	68 c0 26 11 80       	push   $0x801126c0
80102eac:	e8 2f 1d 00 00       	call   80104be0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102eb1:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102eb7:	83 c4 10             	add    $0x10,%esp
80102eba:	85 c9                	test   %ecx,%ecx
80102ebc:	7f 42                	jg     80102f00 <end_op+0xa0>
    acquire(&log.lock);
80102ebe:	83 ec 0c             	sub    $0xc,%esp
80102ec1:	68 c0 26 11 80       	push   $0x801126c0
80102ec6:	e8 75 1d 00 00       	call   80104c40 <acquire>
    log.committing = 0;
80102ecb:	c7 05 00 27 11 80 00 	movl   $0x0,0x80112700
80102ed2:	00 00 00 
    wakeup(&log);
80102ed5:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80102edc:	e8 cf 12 00 00       	call   801041b0 <wakeup>
    release(&log.lock);
80102ee1:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80102ee8:	e8 f3 1c 00 00       	call   80104be0 <release>
80102eed:	83 c4 10             	add    $0x10,%esp
}
80102ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ef3:	5b                   	pop    %ebx
80102ef4:	5e                   	pop    %esi
80102ef5:	5f                   	pop    %edi
80102ef6:	5d                   	pop    %ebp
80102ef7:	c3                   	ret
80102ef8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102eff:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); 
80102f00:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102f05:	83 ec 08             	sub    $0x8,%esp
80102f08:	01 d8                	add    %ebx,%eax
80102f0a:	83 c0 01             	add    $0x1,%eax
80102f0d:	50                   	push   %eax
80102f0e:	ff 35 04 27 11 80    	push   0x80112704
80102f14:	e8 b7 d1 ff ff       	call   801000d0 <bread>
80102f19:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); 
80102f1b:	58                   	pop    %eax
80102f1c:	5a                   	pop    %edx
80102f1d:	ff 34 9d 0c 27 11 80 	push   -0x7feed8f4(,%ebx,4)
80102f24:	ff 35 04 27 11 80    	push   0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
80102f2a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); 
80102f2d:	e8 9e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f32:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); 
80102f35:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f37:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f3a:	68 00 02 00 00       	push   $0x200
80102f3f:	50                   	push   %eax
80102f40:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f43:	50                   	push   %eax
80102f44:	e8 87 1e 00 00       	call   80104dd0 <memmove>
    bwrite(to);  
80102f49:	89 34 24             	mov    %esi,(%esp)
80102f4c:	e8 5f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f51:	89 3c 24             	mov    %edi,(%esp)
80102f54:	e8 97 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f59:	89 34 24             	mov    %esi,(%esp)
80102f5c:	e8 8f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f61:	83 c4 10             	add    $0x10,%esp
80102f64:	3b 1d 08 27 11 80    	cmp    0x80112708,%ebx
80102f6a:	7c 94                	jl     80102f00 <end_op+0xa0>
    write_log();     
    write_head();    
80102f6c:	e8 7f fd ff ff       	call   80102cf0 <write_head>
    install_trans(); 
80102f71:	e8 da fc ff ff       	call   80102c50 <install_trans>
    log.lh.n = 0;
80102f76:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
80102f7d:	00 00 00 
    write_head();    
80102f80:	e8 6b fd ff ff       	call   80102cf0 <write_head>
80102f85:	e9 34 ff ff ff       	jmp    80102ebe <end_op+0x5e>
80102f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f90:	83 ec 0c             	sub    $0xc,%esp
80102f93:	68 c0 26 11 80       	push   $0x801126c0
80102f98:	e8 13 12 00 00       	call   801041b0 <wakeup>
  release(&log.lock);
80102f9d:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80102fa4:	e8 37 1c 00 00       	call   80104be0 <release>
80102fa9:	83 c4 10             	add    $0x10,%esp
}
80102fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102faf:	5b                   	pop    %ebx
80102fb0:	5e                   	pop    %esi
80102fb1:	5f                   	pop    %edi
80102fb2:	5d                   	pop    %ebp
80102fb3:	c3                   	ret
    panic("log.committing");
80102fb4:	83 ec 0c             	sub    $0xc,%esp
80102fb7:	68 db 84 10 80       	push   $0x801084db
80102fbc:	e8 bf d3 ff ff       	call   80100380 <panic>
80102fc1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fc8:	00 
80102fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fd0 <log_write>:



void
log_write(struct buf *b)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fd7:	8b 15 08 27 11 80    	mov    0x80112708,%edx
{
80102fdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fe0:	83 fa 1d             	cmp    $0x1d,%edx
80102fe3:	7f 7d                	jg     80103062 <log_write+0x92>
80102fe5:	a1 f8 26 11 80       	mov    0x801126f8,%eax
80102fea:	83 e8 01             	sub    $0x1,%eax
80102fed:	39 c2                	cmp    %eax,%edx
80102fef:	7d 71                	jge    80103062 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ff1:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102ff6:	85 c0                	test   %eax,%eax
80102ff8:	7e 75                	jle    8010306f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ffa:	83 ec 0c             	sub    $0xc,%esp
80102ffd:	68 c0 26 11 80       	push   $0x801126c0
80103002:	e8 39 1c 00 00       	call   80104c40 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   
80103007:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010300a:	83 c4 10             	add    $0x10,%esp
8010300d:	31 c0                	xor    %eax,%eax
8010300f:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80103015:	85 d2                	test   %edx,%edx
80103017:	7f 0e                	jg     80103027 <log_write+0x57>
80103019:	eb 15                	jmp    80103030 <log_write+0x60>
8010301b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103020:	83 c0 01             	add    $0x1,%eax
80103023:	39 c2                	cmp    %eax,%edx
80103025:	74 29                	je     80103050 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   
80103027:	39 0c 85 0c 27 11 80 	cmp    %ecx,-0x7feed8f4(,%eax,4)
8010302e:	75 f0                	jne    80103020 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103030:	89 0c 85 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%eax,4)
  if (i == log.lh.n)
80103037:	39 c2                	cmp    %eax,%edx
80103039:	74 1c                	je     80103057 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; 
8010303b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010303e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103041:	c7 45 08 c0 26 11 80 	movl   $0x801126c0,0x8(%ebp)
}
80103048:	c9                   	leave
  release(&log.lock);
80103049:	e9 92 1b 00 00       	jmp    80104be0 <release>
8010304e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103050:	89 0c 95 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%edx,4)
    log.lh.n++;
80103057:	83 c2 01             	add    $0x1,%edx
8010305a:	89 15 08 27 11 80    	mov    %edx,0x80112708
80103060:	eb d9                	jmp    8010303b <log_write+0x6b>
    panic("too big a transaction");
80103062:	83 ec 0c             	sub    $0xc,%esp
80103065:	68 ea 84 10 80       	push   $0x801084ea
8010306a:	e8 11 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010306f:	83 ec 0c             	sub    $0xc,%esp
80103072:	68 00 85 10 80       	push   $0x80108500
80103077:	e8 04 d3 ff ff       	call   80100380 <panic>
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <mpmain>:
}


static void
mpmain(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	53                   	push   %ebx
80103084:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103087:	e8 74 09 00 00       	call   80103a00 <cpuid>
8010308c:	89 c3                	mov    %eax,%ebx
8010308e:	e8 6d 09 00 00       	call   80103a00 <cpuid>
80103093:	83 ec 04             	sub    $0x4,%esp
80103096:	53                   	push   %ebx
80103097:	50                   	push   %eax
80103098:	68 1b 85 10 80       	push   $0x8010851b
8010309d:	e8 0e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       
801030a2:	e8 d9 2e 00 00       	call   80105f80 <idtinit>
  xchg(&(mycpu()->started), 1); 
801030a7:	e8 f4 08 00 00       	call   801039a0 <mycpu>
801030ac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  
  asm volatile("lock; xchgl %0, %1" :
801030ae:	b8 01 00 00 00       	mov    $0x1,%eax
801030b3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     
801030ba:	e8 11 0c 00 00       	call   80103cd0 <scheduler>
801030bf:	90                   	nop

801030c0 <mpenter>:
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030c6:	e8 b5 40 00 00       	call   80107180 <switchkvm>
  seginit();
801030cb:	e8 90 3f 00 00       	call   80107060 <seginit>
  lapicinit();
801030d0:	e8 bb f7 ff ff       	call   80102890 <lapicinit>
  mpmain();
801030d5:	e8 a6 ff ff ff       	call   80103080 <mpmain>
801030da:	66 90                	xchg   %ax,%ax
801030dc:	66 90                	xchg   %ax,%ax
801030de:	66 90                	xchg   %ax,%ax

801030e0 <main>:
{
801030e0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030e4:	83 e4 f0             	and    $0xfffffff0,%esp
801030e7:	ff 71 fc             	push   -0x4(%ecx)
801030ea:	55                   	push   %ebp
801030eb:	89 e5                	mov    %esp,%ebp
801030ed:	53                   	push   %ebx
801030ee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); 
801030ef:	83 ec 08             	sub    $0x8,%esp
801030f2:	68 00 00 40 80       	push   $0x80400000
801030f7:	68 60 81 11 80       	push   $0x80118160
801030fc:	e8 5f f5 ff ff       	call   80102660 <kinit1>
  kvmalloc();      
80103101:	e8 6a 45 00 00       	call   80107670 <kvmalloc>
  mpinit();        
80103106:	e8 85 01 00 00       	call   80103290 <mpinit>
  lapicinit();     
8010310b:	e8 80 f7 ff ff       	call   80102890 <lapicinit>
  seginit();       
80103110:	e8 4b 3f 00 00       	call   80107060 <seginit>
  picinit();       
80103115:	e8 86 03 00 00       	call   801034a0 <picinit>
  ioapicinit();    
8010311a:	e8 11 f3 ff ff       	call   80102430 <ioapicinit>
  consoleinit();   
8010311f:	e8 9c d9 ff ff       	call   80100ac0 <consoleinit>
  uartinit();      
80103124:	e8 97 31 00 00       	call   801062c0 <uartinit>
  pinit();         
80103129:	e8 52 08 00 00       	call   80103980 <pinit>
  tvinit();        
8010312e:	e8 cd 2d 00 00       	call   80105f00 <tvinit>
  binit();         
80103133:	e8 08 cf ff ff       	call   80100040 <binit>
  fileinit();      
80103138:	e8 63 dd ff ff       	call   80100ea0 <fileinit>
  ideinit();       
8010313d:	e8 ce f0 ff ff       	call   80102210 <ideinit>
  initialiseSwapSlots();
80103142:	e8 29 48 00 00       	call   80107970 <initialiseSwapSlots>

  
  
  
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103147:	83 c4 0c             	add    $0xc,%esp
8010314a:	68 8a 00 00 00       	push   $0x8a
8010314f:	68 94 b4 10 80       	push   $0x8010b494
80103154:	68 00 70 00 80       	push   $0x80007000
80103159:	e8 72 1c 00 00       	call   80104dd0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010315e:	83 c4 10             	add    $0x10,%esp
80103161:	69 05 a4 27 11 80 b0 	imul   $0xb0,0x801127a4,%eax
80103168:	00 00 00 
8010316b:	05 c0 27 11 80       	add    $0x801127c0,%eax
80103170:	3d c0 27 11 80       	cmp    $0x801127c0,%eax
80103175:	76 79                	jbe    801031f0 <main+0x110>
80103177:	bb c0 27 11 80       	mov    $0x801127c0,%ebx
8010317c:	eb 1b                	jmp    80103199 <main+0xb9>
8010317e:	66 90                	xchg   %ax,%ax
80103180:	69 05 a4 27 11 80 b0 	imul   $0xb0,0x801127a4,%eax
80103187:	00 00 00 
8010318a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103190:	05 c0 27 11 80       	add    $0x801127c0,%eax
80103195:	39 c3                	cmp    %eax,%ebx
80103197:	73 57                	jae    801031f0 <main+0x110>
    if(c == mycpu())  
80103199:	e8 02 08 00 00       	call   801039a0 <mycpu>
8010319e:	39 c3                	cmp    %eax,%ebx
801031a0:	74 de                	je     80103180 <main+0xa0>
      continue;

    
    
    
    stack = kalloc();
801031a2:	e8 69 f5 ff ff       	call   80102710 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801031a7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801031aa:	c7 05 f8 6f 00 80 c0 	movl   $0x801030c0,0x80006ff8
801031b1:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031b4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801031bb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031be:	05 00 10 00 00       	add    $0x1000,%eax
801031c3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031c8:	0f b6 03             	movzbl (%ebx),%eax
801031cb:	68 00 70 00 00       	push   $0x7000
801031d0:	50                   	push   %eax
801031d1:	e8 fa f7 ff ff       	call   801029d0 <lapicstartap>

    
    while(c->started == 0)
801031d6:	83 c4 10             	add    $0x10,%esp
801031d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031e0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031e6:	85 c0                	test   %eax,%eax
801031e8:	74 f6                	je     801031e0 <main+0x100>
801031ea:	eb 94                	jmp    80103180 <main+0xa0>
801031ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); 
801031f0:	83 ec 08             	sub    $0x8,%esp
801031f3:	68 00 00 40 80       	push   $0x80400000
801031f8:	68 00 00 40 80       	push   $0x80400000
801031fd:	e8 fe f3 ff ff       	call   80102600 <kinit2>
  userinit();      
80103202:	e8 49 08 00 00       	call   80103a50 <userinit>
  mpmain();        
80103207:	e8 74 fe ff ff       	call   80103080 <mpmain>
8010320c:	66 90                	xchg   %ax,%ax
8010320e:	66 90                	xchg   %ax,%ax

80103210 <mpsearch1>:
}


static struct mp*
mpsearch1(uint a, int len)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103215:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010321b:	53                   	push   %ebx
  e = addr+len;
8010321c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010321f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103222:	39 de                	cmp    %ebx,%esi
80103224:	72 10                	jb     80103236 <mpsearch1+0x26>
80103226:	eb 50                	jmp    80103278 <mpsearch1+0x68>
80103228:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010322f:	00 
80103230:	89 fe                	mov    %edi,%esi
80103232:	39 df                	cmp    %ebx,%edi
80103234:	73 42                	jae    80103278 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103236:	83 ec 04             	sub    $0x4,%esp
80103239:	8d 7e 10             	lea    0x10(%esi),%edi
8010323c:	6a 04                	push   $0x4
8010323e:	68 2f 85 10 80       	push   $0x8010852f
80103243:	56                   	push   %esi
80103244:	e8 37 1b 00 00       	call   80104d80 <memcmp>
80103249:	83 c4 10             	add    $0x10,%esp
8010324c:	85 c0                	test   %eax,%eax
8010324e:	75 e0                	jne    80103230 <mpsearch1+0x20>
80103250:	89 f2                	mov    %esi,%edx
80103252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103258:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010325b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010325e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103260:	39 fa                	cmp    %edi,%edx
80103262:	75 f4                	jne    80103258 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103264:	84 c0                	test   %al,%al
80103266:	75 c8                	jne    80103230 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103268:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010326b:	89 f0                	mov    %esi,%eax
8010326d:	5b                   	pop    %ebx
8010326e:	5e                   	pop    %esi
8010326f:	5f                   	pop    %edi
80103270:	5d                   	pop    %ebp
80103271:	c3                   	ret
80103272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103278:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010327b:	31 f6                	xor    %esi,%esi
}
8010327d:	5b                   	pop    %ebx
8010327e:	89 f0                	mov    %esi,%eax
80103280:	5e                   	pop    %esi
80103281:	5f                   	pop    %edi
80103282:	5d                   	pop    %ebp
80103283:	c3                   	ret
80103284:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010328b:	00 
8010328c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103290 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	57                   	push   %edi
80103294:	56                   	push   %esi
80103295:	53                   	push   %ebx
80103296:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103299:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032a7:	c1 e0 08             	shl    $0x8,%eax
801032aa:	09 d0                	or     %edx,%eax
801032ac:	c1 e0 04             	shl    $0x4,%eax
801032af:	75 1b                	jne    801032cc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032b1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032b8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032bf:	c1 e0 08             	shl    $0x8,%eax
801032c2:	09 d0                	or     %edx,%eax
801032c4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032c7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032cc:	ba 00 04 00 00       	mov    $0x400,%edx
801032d1:	e8 3a ff ff ff       	call   80103210 <mpsearch1>
801032d6:	89 c3                	mov    %eax,%ebx
801032d8:	85 c0                	test   %eax,%eax
801032da:	0f 84 58 01 00 00    	je     80103438 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032e0:	8b 73 04             	mov    0x4(%ebx),%esi
801032e3:	85 f6                	test   %esi,%esi
801032e5:	0f 84 3d 01 00 00    	je     80103428 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
801032eb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ee:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801032f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032f7:	6a 04                	push   $0x4
801032f9:	68 34 85 10 80       	push   $0x80108534
801032fe:	50                   	push   %eax
801032ff:	e8 7c 1a 00 00       	call   80104d80 <memcmp>
80103304:	83 c4 10             	add    $0x10,%esp
80103307:	85 c0                	test   %eax,%eax
80103309:	0f 85 19 01 00 00    	jne    80103428 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010330f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103316:	3c 01                	cmp    $0x1,%al
80103318:	74 08                	je     80103322 <mpinit+0x92>
8010331a:	3c 04                	cmp    $0x4,%al
8010331c:	0f 85 06 01 00 00    	jne    80103428 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103322:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103329:	66 85 d2             	test   %dx,%dx
8010332c:	74 22                	je     80103350 <mpinit+0xc0>
8010332e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103331:	89 f0                	mov    %esi,%eax
  sum = 0;
80103333:	31 d2                	xor    %edx,%edx
80103335:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103338:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010333f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103342:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103344:	39 f8                	cmp    %edi,%eax
80103346:	75 f0                	jne    80103338 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103348:	84 d2                	test   %dl,%dl
8010334a:	0f 85 d8 00 00 00    	jne    80103428 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103350:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103359:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010335c:	a3 a0 26 11 80       	mov    %eax,0x801126a0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103361:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103368:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010336e:	01 d7                	add    %edx,%edi
80103370:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103372:	bf 01 00 00 00       	mov    $0x1,%edi
80103377:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010337e:	00 
8010337f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103380:	39 d0                	cmp    %edx,%eax
80103382:	73 19                	jae    8010339d <mpinit+0x10d>
    switch(*p){
80103384:	0f b6 08             	movzbl (%eax),%ecx
80103387:	80 f9 02             	cmp    $0x2,%cl
8010338a:	0f 84 80 00 00 00    	je     80103410 <mpinit+0x180>
80103390:	77 6e                	ja     80103400 <mpinit+0x170>
80103392:	84 c9                	test   %cl,%cl
80103394:	74 3a                	je     801033d0 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103396:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103399:	39 d0                	cmp    %edx,%eax
8010339b:	72 e7                	jb     80103384 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010339d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801033a0:	85 ff                	test   %edi,%edi
801033a2:	0f 84 dd 00 00 00    	je     80103485 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033a8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801033ac:	74 15                	je     801033c3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ae:	b8 70 00 00 00       	mov    $0x70,%eax
801033b3:	ba 22 00 00 00       	mov    $0x22,%edx
801033b8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033b9:	ba 23 00 00 00       	mov    $0x23,%edx
801033be:	ec                   	in     (%dx),%al
    
    
    outb(0x22, 0x70);   
    outb(0x23, inb(0x23) | 1);  
801033bf:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033c2:	ee                   	out    %al,(%dx)
  }
}
801033c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033c6:	5b                   	pop    %ebx
801033c7:	5e                   	pop    %esi
801033c8:	5f                   	pop    %edi
801033c9:	5d                   	pop    %ebp
801033ca:	c3                   	ret
801033cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
801033d0:	8b 0d a4 27 11 80    	mov    0x801127a4,%ecx
801033d6:	83 f9 07             	cmp    $0x7,%ecx
801033d9:	7f 19                	jg     801033f4 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  
801033db:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
801033e1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033e5:	83 c1 01             	add    $0x1,%ecx
801033e8:	89 0d a4 27 11 80    	mov    %ecx,0x801127a4
        cpus[ncpu].apicid = proc->apicid;  
801033ee:	88 9e c0 27 11 80    	mov    %bl,-0x7feed840(%esi)
      p += sizeof(struct mpproc);
801033f4:	83 c0 14             	add    $0x14,%eax
      continue;
801033f7:	eb 87                	jmp    80103380 <mpinit+0xf0>
801033f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103400:	83 e9 03             	sub    $0x3,%ecx
80103403:	80 f9 01             	cmp    $0x1,%cl
80103406:	76 8e                	jbe    80103396 <mpinit+0x106>
80103408:	31 ff                	xor    %edi,%edi
8010340a:	e9 71 ff ff ff       	jmp    80103380 <mpinit+0xf0>
8010340f:	90                   	nop
      ioapicid = ioapic->apicno;
80103410:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103414:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103417:	88 0d a0 27 11 80    	mov    %cl,0x801127a0
      continue;
8010341d:	e9 5e ff ff ff       	jmp    80103380 <mpinit+0xf0>
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103428:	83 ec 0c             	sub    $0xc,%esp
8010342b:	68 39 85 10 80       	push   $0x80108539
80103430:	e8 4b cf ff ff       	call   80100380 <panic>
80103435:	8d 76 00             	lea    0x0(%esi),%esi
{
80103438:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010343d:	eb 0b                	jmp    8010344a <mpinit+0x1ba>
8010343f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103440:	89 f3                	mov    %esi,%ebx
80103442:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103448:	74 de                	je     80103428 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010344a:	83 ec 04             	sub    $0x4,%esp
8010344d:	8d 73 10             	lea    0x10(%ebx),%esi
80103450:	6a 04                	push   $0x4
80103452:	68 2f 85 10 80       	push   $0x8010852f
80103457:	53                   	push   %ebx
80103458:	e8 23 19 00 00       	call   80104d80 <memcmp>
8010345d:	83 c4 10             	add    $0x10,%esp
80103460:	85 c0                	test   %eax,%eax
80103462:	75 dc                	jne    80103440 <mpinit+0x1b0>
80103464:	89 da                	mov    %ebx,%edx
80103466:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010346d:	00 
8010346e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103470:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103473:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103476:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103478:	39 d6                	cmp    %edx,%esi
8010347a:	75 f4                	jne    80103470 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010347c:	84 c0                	test   %al,%al
8010347e:	75 c0                	jne    80103440 <mpinit+0x1b0>
80103480:	e9 5b fe ff ff       	jmp    801032e0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103485:	83 ec 0c             	sub    $0xc,%esp
80103488:	68 e0 88 10 80       	push   $0x801088e0
8010348d:	e8 ee ce ff ff       	call   80100380 <panic>
80103492:	66 90                	xchg   %ax,%ax
80103494:	66 90                	xchg   %ax,%ax
80103496:	66 90                	xchg   %ax,%ax
80103498:	66 90                	xchg   %ax,%ax
8010349a:	66 90                	xchg   %ax,%ax
8010349c:	66 90                	xchg   %ax,%ax
8010349e:	66 90                	xchg   %ax,%ax

801034a0 <picinit>:
801034a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034a5:	ba 21 00 00 00       	mov    $0x21,%edx
801034aa:	ee                   	out    %al,(%dx)
801034ab:	ba a1 00 00 00       	mov    $0xa1,%edx
801034b0:	ee                   	out    %al,(%dx)
picinit(void)
{
  
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034b1:	c3                   	ret
801034b2:	66 90                	xchg   %ax,%ax
801034b4:	66 90                	xchg   %ax,%ax
801034b6:	66 90                	xchg   %ax,%ax
801034b8:	66 90                	xchg   %ax,%ax
801034ba:	66 90                	xchg   %ax,%ax
801034bc:	66 90                	xchg   %ax,%ax
801034be:	66 90                	xchg   %ax,%ax

801034c0 <pipealloc>:
  int writeopen;  
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	57                   	push   %edi
801034c4:	56                   	push   %esi
801034c5:	53                   	push   %ebx
801034c6:	83 ec 0c             	sub    $0xc,%esp
801034c9:	8b 75 08             	mov    0x8(%ebp),%esi
801034cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034cf:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801034d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034db:	e8 e0 d9 ff ff       	call   80100ec0 <filealloc>
801034e0:	89 06                	mov    %eax,(%esi)
801034e2:	85 c0                	test   %eax,%eax
801034e4:	0f 84 a5 00 00 00    	je     8010358f <pipealloc+0xcf>
801034ea:	e8 d1 d9 ff ff       	call   80100ec0 <filealloc>
801034ef:	89 07                	mov    %eax,(%edi)
801034f1:	85 c0                	test   %eax,%eax
801034f3:	0f 84 84 00 00 00    	je     8010357d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034f9:	e8 12 f2 ff ff       	call   80102710 <kalloc>
801034fe:	89 c3                	mov    %eax,%ebx
80103500:	85 c0                	test   %eax,%eax
80103502:	0f 84 a0 00 00 00    	je     801035a8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103508:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010350f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103512:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103515:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010351c:	00 00 00 
  p->nwrite = 0;
8010351f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103526:	00 00 00 
  p->nread = 0;
80103529:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103530:	00 00 00 
  initlock(&p->lock, "pipe");
80103533:	68 51 85 10 80       	push   $0x80108551
80103538:	50                   	push   %eax
80103539:	e8 12 15 00 00       	call   80104a50 <initlock>
  (*f0)->type = FD_PIPE;
8010353e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103540:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103543:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103549:	8b 06                	mov    (%esi),%eax
8010354b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010354f:	8b 06                	mov    (%esi),%eax
80103551:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103555:	8b 06                	mov    (%esi),%eax
80103557:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010355a:	8b 07                	mov    (%edi),%eax
8010355c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103562:	8b 07                	mov    (%edi),%eax
80103564:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103568:	8b 07                	mov    (%edi),%eax
8010356a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010356e:	8b 07                	mov    (%edi),%eax
80103570:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103573:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103575:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103578:	5b                   	pop    %ebx
80103579:	5e                   	pop    %esi
8010357a:	5f                   	pop    %edi
8010357b:	5d                   	pop    %ebp
8010357c:	c3                   	ret
  if(*f0)
8010357d:	8b 06                	mov    (%esi),%eax
8010357f:	85 c0                	test   %eax,%eax
80103581:	74 1e                	je     801035a1 <pipealloc+0xe1>
    fileclose(*f0);
80103583:	83 ec 0c             	sub    $0xc,%esp
80103586:	50                   	push   %eax
80103587:	e8 f4 d9 ff ff       	call   80100f80 <fileclose>
8010358c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010358f:	8b 07                	mov    (%edi),%eax
80103591:	85 c0                	test   %eax,%eax
80103593:	74 0c                	je     801035a1 <pipealloc+0xe1>
    fileclose(*f1);
80103595:	83 ec 0c             	sub    $0xc,%esp
80103598:	50                   	push   %eax
80103599:	e8 e2 d9 ff ff       	call   80100f80 <fileclose>
8010359e:	83 c4 10             	add    $0x10,%esp
  return -1;
801035a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035a6:	eb cd                	jmp    80103575 <pipealloc+0xb5>
  if(*f0)
801035a8:	8b 06                	mov    (%esi),%eax
801035aa:	85 c0                	test   %eax,%eax
801035ac:	75 d5                	jne    80103583 <pipealloc+0xc3>
801035ae:	eb df                	jmp    8010358f <pipealloc+0xcf>

801035b0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	56                   	push   %esi
801035b4:	53                   	push   %ebx
801035b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035bb:	83 ec 0c             	sub    $0xc,%esp
801035be:	53                   	push   %ebx
801035bf:	e8 7c 16 00 00       	call   80104c40 <acquire>
  if(writable){
801035c4:	83 c4 10             	add    $0x10,%esp
801035c7:	85 f6                	test   %esi,%esi
801035c9:	74 65                	je     80103630 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801035cb:	83 ec 0c             	sub    $0xc,%esp
801035ce:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035d4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035db:	00 00 00 
    wakeup(&p->nread);
801035de:	50                   	push   %eax
801035df:	e8 cc 0b 00 00       	call   801041b0 <wakeup>
801035e4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035e7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035ed:	85 d2                	test   %edx,%edx
801035ef:	75 0a                	jne    801035fb <pipeclose+0x4b>
801035f1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035f7:	85 c0                	test   %eax,%eax
801035f9:	74 15                	je     80103610 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103601:	5b                   	pop    %ebx
80103602:	5e                   	pop    %esi
80103603:	5d                   	pop    %ebp
    release(&p->lock);
80103604:	e9 d7 15 00 00       	jmp    80104be0 <release>
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	53                   	push   %ebx
80103614:	e8 c7 15 00 00       	call   80104be0 <release>
    kfree((char*)p);
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010361f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103622:	5b                   	pop    %ebx
80103623:	5e                   	pop    %esi
80103624:	5d                   	pop    %ebp
    kfree((char*)p);
80103625:	e9 e6 ee ff ff       	jmp    80102510 <kfree>
8010362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103639:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103640:	00 00 00 
    wakeup(&p->nwrite);
80103643:	50                   	push   %eax
80103644:	e8 67 0b 00 00       	call   801041b0 <wakeup>
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	eb 99                	jmp    801035e7 <pipeclose+0x37>
8010364e:	66 90                	xchg   %ax,%ax

80103650 <pipewrite>:


int
pipewrite(struct pipe *p, char *addr, int n)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
80103655:	53                   	push   %ebx
80103656:	83 ec 28             	sub    $0x28,%esp
80103659:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010365c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010365f:	53                   	push   %ebx
80103660:	e8 db 15 00 00       	call   80104c40 <acquire>
  for(i = 0; i < n; i++){
80103665:	83 c4 10             	add    $0x10,%esp
80103668:	85 ff                	test   %edi,%edi
8010366a:	0f 8e ce 00 00 00    	jle    8010373e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  
80103670:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103676:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103679:	89 7d 10             	mov    %edi,0x10(%ebp)
8010367c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010367f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103682:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103685:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  
8010368b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  
80103691:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  
80103697:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010369d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801036a0:	0f 85 b6 00 00 00    	jne    8010375c <pipewrite+0x10c>
801036a6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801036a9:	eb 3b                	jmp    801036e6 <pipewrite+0x96>
801036ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801036b0:	e8 6b 03 00 00       	call   80103a20 <myproc>
801036b5:	8b 48 24             	mov    0x24(%eax),%ecx
801036b8:	85 c9                	test   %ecx,%ecx
801036ba:	75 34                	jne    801036f0 <pipewrite+0xa0>
      wakeup(&p->nread);
801036bc:	83 ec 0c             	sub    $0xc,%esp
801036bf:	56                   	push   %esi
801036c0:	e8 eb 0a 00 00       	call   801041b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  
801036c5:	58                   	pop    %eax
801036c6:	5a                   	pop    %edx
801036c7:	53                   	push   %ebx
801036c8:	57                   	push   %edi
801036c9:	e8 22 0a 00 00       	call   801040f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  
801036ce:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036d4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036da:	83 c4 10             	add    $0x10,%esp
801036dd:	05 00 02 00 00       	add    $0x200,%eax
801036e2:	39 c2                	cmp    %eax,%edx
801036e4:	75 2a                	jne    80103710 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036e6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036ec:	85 c0                	test   %eax,%eax
801036ee:	75 c0                	jne    801036b0 <pipewrite+0x60>
        release(&p->lock);
801036f0:	83 ec 0c             	sub    $0xc,%esp
801036f3:	53                   	push   %ebx
801036f4:	e8 e7 14 00 00       	call   80104be0 <release>
        return -1;
801036f9:	83 c4 10             	add    $0x10,%esp
801036fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  
  release(&p->lock);
  return n;
}
80103701:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103704:	5b                   	pop    %ebx
80103705:	5e                   	pop    %esi
80103706:	5f                   	pop    %edi
80103707:	5d                   	pop    %ebp
80103708:	c3                   	ret
80103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103710:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103713:	8d 42 01             	lea    0x1(%edx),%eax
80103716:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010371c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010371f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103725:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103728:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010372c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103730:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103733:	39 c1                	cmp    %eax,%ecx
80103735:	0f 85 50 ff ff ff    	jne    8010368b <pipewrite+0x3b>
8010373b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  
8010373e:	83 ec 0c             	sub    $0xc,%esp
80103741:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103747:	50                   	push   %eax
80103748:	e8 63 0a 00 00       	call   801041b0 <wakeup>
  release(&p->lock);
8010374d:	89 1c 24             	mov    %ebx,(%esp)
80103750:	e8 8b 14 00 00       	call   80104be0 <release>
  return n;
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	89 f8                	mov    %edi,%eax
8010375a:	eb a5                	jmp    80103701 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  
8010375c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010375f:	eb b2                	jmp    80103713 <pipewrite+0xc3>
80103761:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103768:	00 
80103769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103770 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	57                   	push   %edi
80103774:	56                   	push   %esi
80103775:	53                   	push   %ebx
80103776:	83 ec 18             	sub    $0x18,%esp
80103779:	8b 75 08             	mov    0x8(%ebp),%esi
8010377c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010377f:	56                   	push   %esi
80103780:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103786:	e8 b5 14 00 00       	call   80104c40 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  
8010378b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103791:	83 c4 10             	add    $0x10,%esp
80103794:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010379a:	74 2f                	je     801037cb <piperead+0x5b>
8010379c:	eb 37                	jmp    801037d5 <piperead+0x65>
8010379e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801037a0:	e8 7b 02 00 00       	call   80103a20 <myproc>
801037a5:	8b 40 24             	mov    0x24(%eax),%eax
801037a8:	85 c0                	test   %eax,%eax
801037aa:	0f 85 80 00 00 00    	jne    80103830 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); 
801037b0:	83 ec 08             	sub    $0x8,%esp
801037b3:	56                   	push   %esi
801037b4:	53                   	push   %ebx
801037b5:	e8 36 09 00 00       	call   801040f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  
801037ba:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037c0:	83 c4 10             	add    $0x10,%esp
801037c3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037c9:	75 0a                	jne    801037d5 <piperead+0x65>
801037cb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801037d1:	85 d2                	test   %edx,%edx
801037d3:	75 cb                	jne    801037a0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  
801037d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801037d8:	31 db                	xor    %ebx,%ebx
801037da:	85 c9                	test   %ecx,%ecx
801037dc:	7f 26                	jg     80103804 <piperead+0x94>
801037de:	eb 2c                	jmp    8010380c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037e0:	8d 48 01             	lea    0x1(%eax),%ecx
801037e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037e8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037ee:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037f3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  
801037f6:	83 c3 01             	add    $0x1,%ebx
801037f9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037fc:	74 0e                	je     8010380c <piperead+0x9c>
801037fe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103804:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010380a:	75 d4                	jne    801037e0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  
8010380c:	83 ec 0c             	sub    $0xc,%esp
8010380f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103815:	50                   	push   %eax
80103816:	e8 95 09 00 00       	call   801041b0 <wakeup>
  release(&p->lock);
8010381b:	89 34 24             	mov    %esi,(%esp)
8010381e:	e8 bd 13 00 00       	call   80104be0 <release>
  return i;
80103823:	83 c4 10             	add    $0x10,%esp
}
80103826:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103829:	89 d8                	mov    %ebx,%eax
8010382b:	5b                   	pop    %ebx
8010382c:	5e                   	pop    %esi
8010382d:	5f                   	pop    %edi
8010382e:	5d                   	pop    %ebp
8010382f:	c3                   	ret
      release(&p->lock);
80103830:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103833:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103838:	56                   	push   %esi
80103839:	e8 a2 13 00 00       	call   80104be0 <release>
      return -1;
8010383e:	83 c4 10             	add    $0x10,%esp
}
80103841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103844:	89 d8                	mov    %ebx,%eax
80103846:	5b                   	pop    %ebx
80103847:	5e                   	pop    %esi
80103848:	5f                   	pop    %edi
80103849:	5d                   	pop    %ebp
8010384a:	c3                   	ret
8010384b:	66 90                	xchg   %ax,%ax
8010384d:	66 90                	xchg   %ax,%ax
8010384f:	90                   	nop

80103850 <allocproc>:



static struct proc*
allocproc(void)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103854:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
80103859:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010385c:	68 40 2d 11 80       	push   $0x80112d40
80103861:	e8 da 13 00 00       	call   80104c40 <acquire>
80103866:	83 c4 10             	add    $0x10,%esp
80103869:	eb 17                	jmp    80103882 <allocproc+0x32>
8010386b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103870:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103876:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
8010387c:	0f 84 7e 00 00 00    	je     80103900 <allocproc+0xb0>
    if(p->state == UNUSED)
80103882:	8b 43 0c             	mov    0xc(%ebx),%eax
80103885:	85 c0                	test   %eax,%eax
80103887:	75 e7                	jne    80103870 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103889:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  
  p->rss = 0;

  release(&ptable.lock);
8010388e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103891:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->rss = 0;
80103898:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
8010389f:	89 43 10             	mov    %eax,0x10(%ebx)
801038a2:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801038a5:	68 40 2d 11 80       	push   $0x80112d40
  p->pid = nextpid++;
801038aa:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801038b0:	e8 2b 13 00 00       	call   80104be0 <release>

  
  if((p->kstack = kalloc()) == 0){
801038b5:	e8 56 ee ff ff       	call   80102710 <kalloc>
801038ba:	83 c4 10             	add    $0x10,%esp
801038bd:	89 43 08             	mov    %eax,0x8(%ebx)
801038c0:	85 c0                	test   %eax,%eax
801038c2:	74 55                	je     80103919 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  
  sp -= sizeof *p->tf;
801038c4:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038ca:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038cd:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038d2:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038d5:	c7 40 14 f2 5e 10 80 	movl   $0x80105ef2,0x14(%eax)
  p->context = (struct context*)sp;
801038dc:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038df:	6a 14                	push   $0x14
801038e1:	6a 00                	push   $0x0
801038e3:	50                   	push   %eax
801038e4:	e8 57 14 00 00       	call   80104d40 <memset>
  p->context->eip = (uint)forkret;
801038e9:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038ec:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038ef:	c7 40 10 30 39 10 80 	movl   $0x80103930,0x10(%eax)
}
801038f6:	89 d8                	mov    %ebx,%eax
801038f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038fb:	c9                   	leave
801038fc:	c3                   	ret
801038fd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103900:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103903:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103905:	68 40 2d 11 80       	push   $0x80112d40
8010390a:	e8 d1 12 00 00       	call   80104be0 <release>
  return 0;
8010390f:	83 c4 10             	add    $0x10,%esp
}
80103912:	89 d8                	mov    %ebx,%eax
80103914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103917:	c9                   	leave
80103918:	c3                   	ret
    p->state = UNUSED;
80103919:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103920:	31 db                	xor    %ebx,%ebx
80103922:	eb ee                	jmp    80103912 <allocproc+0xc2>
80103924:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010392b:	00 
8010392c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103930 <forkret>:



void
forkret(void)
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  
  release(&ptable.lock);
80103936:	68 40 2d 11 80       	push   $0x80112d40
8010393b:	e8 a0 12 00 00       	call   80104be0 <release>

  if (first) {
80103940:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103945:	83 c4 10             	add    $0x10,%esp
80103948:	85 c0                	test   %eax,%eax
8010394a:	75 04                	jne    80103950 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  
}
8010394c:	c9                   	leave
8010394d:	c3                   	ret
8010394e:	66 90                	xchg   %ax,%ax
    first = 0;
80103950:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103957:	00 00 00 
    iinit(ROOTDEV);
8010395a:	83 ec 0c             	sub    $0xc,%esp
8010395d:	6a 01                	push   $0x1
8010395f:	e8 8c dc ff ff       	call   801015f0 <iinit>
    initlog(ROOTDEV);
80103964:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010396b:	e8 e0 f3 ff ff       	call   80102d50 <initlog>
}
80103970:	83 c4 10             	add    $0x10,%esp
80103973:	c9                   	leave
80103974:	c3                   	ret
80103975:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010397c:	00 
8010397d:	8d 76 00             	lea    0x0(%esi),%esi

80103980 <pinit>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103986:	68 56 85 10 80       	push   $0x80108556
8010398b:	68 40 2d 11 80       	push   $0x80112d40
80103990:	e8 bb 10 00 00       	call   80104a50 <initlock>
}
80103995:	83 c4 10             	add    $0x10,%esp
80103998:	c9                   	leave
80103999:	c3                   	ret
8010399a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039a0 <mycpu>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	56                   	push   %esi
801039a4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039a5:	9c                   	pushf
801039a6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039a7:	f6 c4 02             	test   $0x2,%ah
801039aa:	75 46                	jne    801039f2 <mycpu+0x52>
  apicid = lapicid();
801039ac:	e8 cf ef ff ff       	call   80102980 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039b1:	8b 35 a4 27 11 80    	mov    0x801127a4,%esi
801039b7:	85 f6                	test   %esi,%esi
801039b9:	7e 2a                	jle    801039e5 <mycpu+0x45>
801039bb:	31 d2                	xor    %edx,%edx
801039bd:	eb 08                	jmp    801039c7 <mycpu+0x27>
801039bf:	90                   	nop
801039c0:	83 c2 01             	add    $0x1,%edx
801039c3:	39 f2                	cmp    %esi,%edx
801039c5:	74 1e                	je     801039e5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039c7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039cd:	0f b6 99 c0 27 11 80 	movzbl -0x7feed840(%ecx),%ebx
801039d4:	39 c3                	cmp    %eax,%ebx
801039d6:	75 e8                	jne    801039c0 <mycpu+0x20>
}
801039d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039db:	8d 81 c0 27 11 80    	lea    -0x7feed840(%ecx),%eax
}
801039e1:	5b                   	pop    %ebx
801039e2:	5e                   	pop    %esi
801039e3:	5d                   	pop    %ebp
801039e4:	c3                   	ret
  panic("unknown apicid\n");
801039e5:	83 ec 0c             	sub    $0xc,%esp
801039e8:	68 5d 85 10 80       	push   $0x8010855d
801039ed:	e8 8e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039f2:	83 ec 0c             	sub    $0xc,%esp
801039f5:	68 00 89 10 80       	push   $0x80108900
801039fa:	e8 81 c9 ff ff       	call   80100380 <panic>
801039ff:	90                   	nop

80103a00 <cpuid>:
cpuid() {
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a06:	e8 95 ff ff ff       	call   801039a0 <mycpu>
}
80103a0b:	c9                   	leave
  return mycpu()-cpus;
80103a0c:	2d c0 27 11 80       	sub    $0x801127c0,%eax
80103a11:	c1 f8 04             	sar    $0x4,%eax
80103a14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a1a:	c3                   	ret
80103a1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a20 <myproc>:
myproc(void) {
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	53                   	push   %ebx
80103a24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a27:	e8 c4 10 00 00       	call   80104af0 <pushcli>
  c = mycpu();
80103a2c:	e8 6f ff ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103a31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a37:	e8 04 11 00 00       	call   80104b40 <popcli>
}
80103a3c:	89 d8                	mov    %ebx,%eax
80103a3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a41:	c9                   	leave
80103a42:	c3                   	ret
80103a43:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a4a:	00 
80103a4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a50 <userinit>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
80103a54:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a57:	e8 f4 fd ff ff       	call   80103850 <allocproc>
80103a5c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a5e:	a3 74 4f 11 80       	mov    %eax,0x80114f74
  if((p->pgdir = setupkvm()) == 0)
80103a63:	e8 88 3b 00 00       	call   801075f0 <setupkvm>
80103a68:	89 43 04             	mov    %eax,0x4(%ebx)
80103a6b:	85 c0                	test   %eax,%eax
80103a6d:	0f 84 bd 00 00 00    	je     80103b30 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a73:	83 ec 04             	sub    $0x4,%esp
80103a76:	68 2c 00 00 00       	push   $0x2c
80103a7b:	68 68 b4 10 80       	push   $0x8010b468
80103a80:	50                   	push   %eax
80103a81:	e8 1a 38 00 00       	call   801072a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a86:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a8f:	6a 4c                	push   $0x4c
80103a91:	6a 00                	push   $0x0
80103a93:	ff 73 18             	push   0x18(%ebx)
80103a96:	e8 a5 12 00 00       	call   80104d40 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a9b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aa3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aa6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aaf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ab6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103abd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ac1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ac8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103acc:	8b 43 18             	mov    0x18(%ebx),%eax
80103acf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ad6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  
80103ae0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aea:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103aed:	6a 10                	push   $0x10
80103aef:	68 86 85 10 80       	push   $0x80108586
80103af4:	50                   	push   %eax
80103af5:	e8 f6 13 00 00       	call   80104ef0 <safestrcpy>
  p->cwd = namei("/");
80103afa:	c7 04 24 8f 85 10 80 	movl   $0x8010858f,(%esp)
80103b01:	e8 ea e5 ff ff       	call   801020f0 <namei>
80103b06:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b09:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103b10:	e8 2b 11 00 00       	call   80104c40 <acquire>
  p->state = RUNNABLE;
80103b15:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b1c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103b23:	e8 b8 10 00 00       	call   80104be0 <release>
}
80103b28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b2b:	83 c4 10             	add    $0x10,%esp
80103b2e:	c9                   	leave
80103b2f:	c3                   	ret
    panic("userinit: out of memory?");
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	68 6d 85 10 80       	push   $0x8010856d
80103b38:	e8 43 c8 ff ff       	call   80100380 <panic>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi

80103b40 <growproc>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	56                   	push   %esi
80103b44:	53                   	push   %ebx
80103b45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b48:	e8 a3 0f 00 00       	call   80104af0 <pushcli>
  c = mycpu();
80103b4d:	e8 4e fe ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103b52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b58:	e8 e3 0f 00 00       	call   80104b40 <popcli>
  sz = curproc->sz;
80103b5d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b5f:	85 f6                	test   %esi,%esi
80103b61:	7f 1d                	jg     80103b80 <growproc+0x40>
  } else if(n < 0){
80103b63:	75 3b                	jne    80103ba0 <growproc+0x60>
  switchuvm(curproc);
80103b65:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b68:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b6a:	53                   	push   %ebx
80103b6b:	e8 20 36 00 00       	call   80107190 <switchuvm>
  return 0;
80103b70:	83 c4 10             	add    $0x10,%esp
80103b73:	31 c0                	xor    %eax,%eax
}
80103b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b78:	5b                   	pop    %ebx
80103b79:	5e                   	pop    %esi
80103b7a:	5d                   	pop    %ebp
80103b7b:	c3                   	ret
80103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b80:	83 ec 04             	sub    $0x4,%esp
80103b83:	01 c6                	add    %eax,%esi
80103b85:	56                   	push   %esi
80103b86:	50                   	push   %eax
80103b87:	ff 73 04             	push   0x4(%ebx)
80103b8a:	e8 91 38 00 00       	call   80107420 <allocuvm>
80103b8f:	83 c4 10             	add    $0x10,%esp
80103b92:	85 c0                	test   %eax,%eax
80103b94:	75 cf                	jne    80103b65 <growproc+0x25>
      return -1;
80103b96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b9b:	eb d8                	jmp    80103b75 <growproc+0x35>
80103b9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ba0:	83 ec 04             	sub    $0x4,%esp
80103ba3:	01 c6                	add    %eax,%esi
80103ba5:	56                   	push   %esi
80103ba6:	50                   	push   %eax
80103ba7:	ff 73 04             	push   0x4(%ebx)
80103baa:	e8 71 39 00 00       	call   80107520 <deallocuvm>
80103baf:	83 c4 10             	add    $0x10,%esp
80103bb2:	85 c0                	test   %eax,%eax
80103bb4:	75 af                	jne    80103b65 <growproc+0x25>
80103bb6:	eb de                	jmp    80103b96 <growproc+0x56>
80103bb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bbf:	00 

80103bc0 <fork>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	57                   	push   %edi
80103bc4:	56                   	push   %esi
80103bc5:	53                   	push   %ebx
80103bc6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bc9:	e8 22 0f 00 00       	call   80104af0 <pushcli>
  c = mycpu();
80103bce:	e8 cd fd ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103bd3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bd9:	e8 62 0f 00 00       	call   80104b40 <popcli>
  if((np = allocproc()) == 0){
80103bde:	e8 6d fc ff ff       	call   80103850 <allocproc>
80103be3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103be6:	85 c0                	test   %eax,%eax
80103be8:	0f 84 d6 00 00 00    	je     80103cc4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bee:	83 ec 08             	sub    $0x8,%esp
80103bf1:	ff 33                	push   (%ebx)
80103bf3:	89 c7                	mov    %eax,%edi
80103bf5:	ff 73 04             	push   0x4(%ebx)
80103bf8:	e8 e3 3a 00 00       	call   801076e0 <copyuvm>
80103bfd:	83 c4 10             	add    $0x10,%esp
80103c00:	89 47 04             	mov    %eax,0x4(%edi)
80103c03:	85 c0                	test   %eax,%eax
80103c05:	0f 84 9a 00 00 00    	je     80103ca5 <fork+0xe5>
  np->sz = curproc->sz;
80103c0b:	8b 03                	mov    (%ebx),%eax
80103c0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c10:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c12:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c15:	89 c8                	mov    %ecx,%eax
80103c17:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c1a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c1f:	8b 73 18             	mov    0x18(%ebx),%esi
80103c22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c24:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c26:	8b 40 18             	mov    0x18(%eax),%eax
80103c29:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c30:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c34:	85 c0                	test   %eax,%eax
80103c36:	74 13                	je     80103c4b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c38:	83 ec 0c             	sub    $0xc,%esp
80103c3b:	50                   	push   %eax
80103c3c:	e8 ef d2 ff ff       	call   80100f30 <filedup>
80103c41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c44:	83 c4 10             	add    $0x10,%esp
80103c47:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c4b:	83 c6 01             	add    $0x1,%esi
80103c4e:	83 fe 10             	cmp    $0x10,%esi
80103c51:	75 dd                	jne    80103c30 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c53:	83 ec 0c             	sub    $0xc,%esp
80103c56:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c59:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c5c:	e8 7f db ff ff       	call   801017e0 <idup>
80103c61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c64:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c67:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c6a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c6d:	6a 10                	push   $0x10
80103c6f:	53                   	push   %ebx
80103c70:	50                   	push   %eax
80103c71:	e8 7a 12 00 00       	call   80104ef0 <safestrcpy>
  pid = np->pid;
80103c76:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c79:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c80:	e8 bb 0f 00 00       	call   80104c40 <acquire>
  np->state = RUNNABLE;
80103c85:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c8c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c93:	e8 48 0f 00 00       	call   80104be0 <release>
  return pid;
80103c98:	83 c4 10             	add    $0x10,%esp
}
80103c9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c9e:	89 d8                	mov    %ebx,%eax
80103ca0:	5b                   	pop    %ebx
80103ca1:	5e                   	pop    %esi
80103ca2:	5f                   	pop    %edi
80103ca3:	5d                   	pop    %ebp
80103ca4:	c3                   	ret
    kfree(np->kstack);
80103ca5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ca8:	83 ec 0c             	sub    $0xc,%esp
80103cab:	ff 73 08             	push   0x8(%ebx)
80103cae:	e8 5d e8 ff ff       	call   80102510 <kfree>
    np->kstack = 0;
80103cb3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103cba:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103cbd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103cc4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cc9:	eb d0                	jmp    80103c9b <fork+0xdb>
80103ccb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103cd0 <scheduler>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103cd9:	e8 c2 fc ff ff       	call   801039a0 <mycpu>
  c->proc = 0;
80103cde:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ce5:	00 00 00 
  struct cpu *c = mycpu();
80103ce8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103cea:	8d 78 04             	lea    0x4(%eax),%edi
80103ced:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103cf0:	fb                   	sti
    acquire(&ptable.lock);
80103cf1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf4:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
    acquire(&ptable.lock);
80103cf9:	68 40 2d 11 80       	push   $0x80112d40
80103cfe:	e8 3d 0f 00 00       	call   80104c40 <acquire>
80103d03:	83 c4 10             	add    $0x10,%esp
80103d06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d0d:	00 
80103d0e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103d10:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d14:	75 33                	jne    80103d49 <scheduler+0x79>
      switchuvm(p);
80103d16:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d19:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d1f:	53                   	push   %ebx
80103d20:	e8 6b 34 00 00       	call   80107190 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d25:	58                   	pop    %eax
80103d26:	5a                   	pop    %edx
80103d27:	ff 73 1c             	push   0x1c(%ebx)
80103d2a:	57                   	push   %edi
      p->state = RUNNING;
80103d2b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d32:	e8 14 12 00 00       	call   80104f4b <swtch>
      switchkvm();
80103d37:	e8 44 34 00 00       	call   80107180 <switchkvm>
      c->proc = 0;
80103d3c:	83 c4 10             	add    $0x10,%esp
80103d3f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d46:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d49:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103d4f:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
80103d55:	75 b9                	jne    80103d10 <scheduler+0x40>
    release(&ptable.lock);
80103d57:	83 ec 0c             	sub    $0xc,%esp
80103d5a:	68 40 2d 11 80       	push   $0x80112d40
80103d5f:	e8 7c 0e 00 00       	call   80104be0 <release>
    sti();
80103d64:	83 c4 10             	add    $0x10,%esp
80103d67:	eb 87                	jmp    80103cf0 <scheduler+0x20>
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d70 <sched>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	56                   	push   %esi
80103d74:	53                   	push   %ebx
  pushcli();
80103d75:	e8 76 0d 00 00       	call   80104af0 <pushcli>
  c = mycpu();
80103d7a:	e8 21 fc ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103d7f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d85:	e8 b6 0d 00 00       	call   80104b40 <popcli>
  if(!holding(&ptable.lock))
80103d8a:	83 ec 0c             	sub    $0xc,%esp
80103d8d:	68 40 2d 11 80       	push   $0x80112d40
80103d92:	e8 09 0e 00 00       	call   80104ba0 <holding>
80103d97:	83 c4 10             	add    $0x10,%esp
80103d9a:	85 c0                	test   %eax,%eax
80103d9c:	74 4f                	je     80103ded <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d9e:	e8 fd fb ff ff       	call   801039a0 <mycpu>
80103da3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103daa:	75 68                	jne    80103e14 <sched+0xa4>
  if(p->state == RUNNING)
80103dac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103db0:	74 55                	je     80103e07 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103db2:	9c                   	pushf
80103db3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103db4:	f6 c4 02             	test   $0x2,%ah
80103db7:	75 41                	jne    80103dfa <sched+0x8a>
  intena = mycpu()->intena;
80103db9:	e8 e2 fb ff ff       	call   801039a0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dbe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103dc1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103dc7:	e8 d4 fb ff ff       	call   801039a0 <mycpu>
80103dcc:	83 ec 08             	sub    $0x8,%esp
80103dcf:	ff 70 04             	push   0x4(%eax)
80103dd2:	53                   	push   %ebx
80103dd3:	e8 73 11 00 00       	call   80104f4b <swtch>
  mycpu()->intena = intena;
80103dd8:	e8 c3 fb ff ff       	call   801039a0 <mycpu>
}
80103ddd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103de0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103de6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103de9:	5b                   	pop    %ebx
80103dea:	5e                   	pop    %esi
80103deb:	5d                   	pop    %ebp
80103dec:	c3                   	ret
    panic("sched ptable.lock");
80103ded:	83 ec 0c             	sub    $0xc,%esp
80103df0:	68 91 85 10 80       	push   $0x80108591
80103df5:	e8 86 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103dfa:	83 ec 0c             	sub    $0xc,%esp
80103dfd:	68 bd 85 10 80       	push   $0x801085bd
80103e02:	e8 79 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e07:	83 ec 0c             	sub    $0xc,%esp
80103e0a:	68 af 85 10 80       	push   $0x801085af
80103e0f:	e8 6c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e14:	83 ec 0c             	sub    $0xc,%esp
80103e17:	68 a3 85 10 80       	push   $0x801085a3
80103e1c:	e8 5f c5 ff ff       	call   80100380 <panic>
80103e21:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e28:	00 
80103e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e30 <exit>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	57                   	push   %edi
80103e34:	56                   	push   %esi
80103e35:	53                   	push   %ebx
80103e36:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e39:	e8 e2 fb ff ff       	call   80103a20 <myproc>
  if(curproc == initproc)
80103e3e:	39 05 74 4f 11 80    	cmp    %eax,0x80114f74
80103e44:	0f 84 07 01 00 00    	je     80103f51 <exit+0x121>
80103e4a:	89 c3                	mov    %eax,%ebx
80103e4c:	8d 70 28             	lea    0x28(%eax),%esi
80103e4f:	8d 78 68             	lea    0x68(%eax),%edi
80103e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e58:	8b 06                	mov    (%esi),%eax
80103e5a:	85 c0                	test   %eax,%eax
80103e5c:	74 12                	je     80103e70 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e5e:	83 ec 0c             	sub    $0xc,%esp
80103e61:	50                   	push   %eax
80103e62:	e8 19 d1 ff ff       	call   80100f80 <fileclose>
      curproc->ofile[fd] = 0;
80103e67:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e6d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e70:	83 c6 04             	add    $0x4,%esi
80103e73:	39 f7                	cmp    %esi,%edi
80103e75:	75 e1                	jne    80103e58 <exit+0x28>
  begin_op();
80103e77:	e8 74 ef ff ff       	call   80102df0 <begin_op>
  iput(curproc->cwd);
80103e7c:	83 ec 0c             	sub    $0xc,%esp
80103e7f:	ff 73 68             	push   0x68(%ebx)
80103e82:	e8 b9 da ff ff       	call   80101940 <iput>
  end_op();
80103e87:	e8 d4 ef ff ff       	call   80102e60 <end_op>
  curproc->cwd = 0;
80103e8c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e93:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e9a:	e8 a1 0d 00 00       	call   80104c40 <acquire>
  wakeup1(curproc->parent);
80103e9f:	8b 53 14             	mov    0x14(%ebx),%edx
80103ea2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ea5:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103eaa:	eb 10                	jmp    80103ebc <exit+0x8c>
80103eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eb0:	05 88 00 00 00       	add    $0x88,%eax
80103eb5:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103eba:	74 1e                	je     80103eda <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
80103ebc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ec0:	75 ee                	jne    80103eb0 <exit+0x80>
80103ec2:	3b 50 20             	cmp    0x20(%eax),%edx
80103ec5:	75 e9                	jne    80103eb0 <exit+0x80>
      p->state = RUNNABLE;
80103ec7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ece:	05 88 00 00 00       	add    $0x88,%eax
80103ed3:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103ed8:	75 e2                	jne    80103ebc <exit+0x8c>
      p->parent = initproc;
80103eda:	8b 0d 74 4f 11 80    	mov    0x80114f74,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee0:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80103ee5:	eb 17                	jmp    80103efe <exit+0xce>
80103ee7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103eee:	00 
80103eef:	90                   	nop
80103ef0:	81 c2 88 00 00 00    	add    $0x88,%edx
80103ef6:	81 fa 74 4f 11 80    	cmp    $0x80114f74,%edx
80103efc:	74 3a                	je     80103f38 <exit+0x108>
    if(p->parent == curproc){
80103efe:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f01:	75 ed                	jne    80103ef0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103f03:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f07:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f0a:	75 e4                	jne    80103ef0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f0c:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103f11:	eb 11                	jmp    80103f24 <exit+0xf4>
80103f13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f18:	05 88 00 00 00       	add    $0x88,%eax
80103f1d:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103f22:	74 cc                	je     80103ef0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103f24:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f28:	75 ee                	jne    80103f18 <exit+0xe8>
80103f2a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f2d:	75 e9                	jne    80103f18 <exit+0xe8>
      p->state = RUNNABLE;
80103f2f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f36:	eb e0                	jmp    80103f18 <exit+0xe8>
  curproc->state = ZOMBIE;
80103f38:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f3f:	e8 2c fe ff ff       	call   80103d70 <sched>
  panic("zombie exit");
80103f44:	83 ec 0c             	sub    $0xc,%esp
80103f47:	68 de 85 10 80       	push   $0x801085de
80103f4c:	e8 2f c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f51:	83 ec 0c             	sub    $0xc,%esp
80103f54:	68 d1 85 10 80       	push   $0x801085d1
80103f59:	e8 22 c4 ff ff       	call   80100380 <panic>
80103f5e:	66 90                	xchg   %ax,%ax

80103f60 <wait>:
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	56                   	push   %esi
80103f64:	53                   	push   %ebx
  pushcli();
80103f65:	e8 86 0b 00 00       	call   80104af0 <pushcli>
  c = mycpu();
80103f6a:	e8 31 fa ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103f6f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f75:	e8 c6 0b 00 00       	call   80104b40 <popcli>
  acquire(&ptable.lock);
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	68 40 2d 11 80       	push   $0x80112d40
80103f82:	e8 b9 0c 00 00       	call   80104c40 <acquire>
80103f87:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f8a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f8c:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80103f91:	eb 13                	jmp    80103fa6 <wait+0x46>
80103f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f98:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103f9e:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
80103fa4:	74 1e                	je     80103fc4 <wait+0x64>
      if(p->parent != curproc)
80103fa6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fa9:	75 ed                	jne    80103f98 <wait+0x38>
      if(p->state == ZOMBIE){
80103fab:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103faf:	74 5f                	je     80104010 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb1:	81 c3 88 00 00 00    	add    $0x88,%ebx
      havekids = 1;
80103fb7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fbc:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
80103fc2:	75 e2                	jne    80103fa6 <wait+0x46>
    if(!havekids || curproc->killed){
80103fc4:	85 c0                	test   %eax,%eax
80103fc6:	0f 84 a1 00 00 00    	je     8010406d <wait+0x10d>
80103fcc:	8b 46 24             	mov    0x24(%esi),%eax
80103fcf:	85 c0                	test   %eax,%eax
80103fd1:	0f 85 96 00 00 00    	jne    8010406d <wait+0x10d>
  pushcli();
80103fd7:	e8 14 0b 00 00       	call   80104af0 <pushcli>
  c = mycpu();
80103fdc:	e8 bf f9 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103fe1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fe7:	e8 54 0b 00 00       	call   80104b40 <popcli>
  if(p == 0)
80103fec:	85 db                	test   %ebx,%ebx
80103fee:	0f 84 90 00 00 00    	je     80104084 <wait+0x124>
  p->chan = chan;
80103ff4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103ff7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ffe:	e8 6d fd ff ff       	call   80103d70 <sched>
  p->chan = 0;
80104003:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010400a:	e9 7b ff ff ff       	jmp    80103f8a <wait+0x2a>
8010400f:	90                   	nop
        releaseSwapSpaces(p);
80104010:	83 ec 0c             	sub    $0xc,%esp
80104013:	53                   	push   %ebx
80104014:	e8 17 3b 00 00       	call   80107b30 <releaseSwapSpaces>
        kfree(p->kstack);
80104019:	5a                   	pop    %edx
        pid = p->pid;
8010401a:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010401d:	ff 73 08             	push   0x8(%ebx)
80104020:	e8 eb e4 ff ff       	call   80102510 <kfree>
        p->kstack = 0;
80104025:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010402c:	59                   	pop    %ecx
8010402d:	ff 73 04             	push   0x4(%ebx)
80104030:	e8 1b 35 00 00       	call   80107550 <freevm>
        p->pid = 0;
80104035:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010403c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104043:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104047:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010404e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104055:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010405c:	e8 7f 0b 00 00       	call   80104be0 <release>
        return pid;
80104061:	83 c4 10             	add    $0x10,%esp
}
80104064:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104067:	89 f0                	mov    %esi,%eax
80104069:	5b                   	pop    %ebx
8010406a:	5e                   	pop    %esi
8010406b:	5d                   	pop    %ebp
8010406c:	c3                   	ret
      release(&ptable.lock);
8010406d:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104070:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104075:	68 40 2d 11 80       	push   $0x80112d40
8010407a:	e8 61 0b 00 00       	call   80104be0 <release>
      return -1;
8010407f:	83 c4 10             	add    $0x10,%esp
80104082:	eb e0                	jmp    80104064 <wait+0x104>
    panic("sleep");
80104084:	83 ec 0c             	sub    $0xc,%esp
80104087:	68 ea 85 10 80       	push   $0x801085ea
8010408c:	e8 ef c2 ff ff       	call   80100380 <panic>
80104091:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104098:	00 
80104099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040a0 <yield>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  
801040a7:	68 40 2d 11 80       	push   $0x80112d40
801040ac:	e8 8f 0b 00 00       	call   80104c40 <acquire>
  pushcli();
801040b1:	e8 3a 0a 00 00       	call   80104af0 <pushcli>
  c = mycpu();
801040b6:	e8 e5 f8 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
801040bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040c1:	e8 7a 0a 00 00       	call   80104b40 <popcli>
  myproc()->state = RUNNABLE;
801040c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040cd:	e8 9e fc ff ff       	call   80103d70 <sched>
  release(&ptable.lock);
801040d2:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801040d9:	e8 02 0b 00 00       	call   80104be0 <release>
}
801040de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040e1:	83 c4 10             	add    $0x10,%esp
801040e4:	c9                   	leave
801040e5:	c3                   	ret
801040e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040ed:	00 
801040ee:	66 90                	xchg   %ax,%ax

801040f0 <sleep>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	57                   	push   %edi
801040f4:	56                   	push   %esi
801040f5:	53                   	push   %ebx
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801040fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040ff:	e8 ec 09 00 00       	call   80104af0 <pushcli>
  c = mycpu();
80104104:	e8 97 f8 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104109:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010410f:	e8 2c 0a 00 00       	call   80104b40 <popcli>
  if(p == 0)
80104114:	85 db                	test   %ebx,%ebx
80104116:	0f 84 87 00 00 00    	je     801041a3 <sleep+0xb3>
  if(lk == 0)
8010411c:	85 f6                	test   %esi,%esi
8010411e:	74 76                	je     80104196 <sleep+0xa6>
  if(lk != &ptable.lock){  
80104120:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
80104126:	74 50                	je     80104178 <sleep+0x88>
    acquire(&ptable.lock);  
80104128:	83 ec 0c             	sub    $0xc,%esp
8010412b:	68 40 2d 11 80       	push   $0x80112d40
80104130:	e8 0b 0b 00 00       	call   80104c40 <acquire>
    release(lk);
80104135:	89 34 24             	mov    %esi,(%esp)
80104138:	e8 a3 0a 00 00       	call   80104be0 <release>
  p->chan = chan;
8010413d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104140:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104147:	e8 24 fc ff ff       	call   80103d70 <sched>
  p->chan = 0;
8010414c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104153:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010415a:	e8 81 0a 00 00       	call   80104be0 <release>
    acquire(lk);
8010415f:	83 c4 10             	add    $0x10,%esp
80104162:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104165:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104168:	5b                   	pop    %ebx
80104169:	5e                   	pop    %esi
8010416a:	5f                   	pop    %edi
8010416b:	5d                   	pop    %ebp
    acquire(lk);
8010416c:	e9 cf 0a 00 00       	jmp    80104c40 <acquire>
80104171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104178:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010417b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104182:	e8 e9 fb ff ff       	call   80103d70 <sched>
  p->chan = 0;
80104187:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010418e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104191:	5b                   	pop    %ebx
80104192:	5e                   	pop    %esi
80104193:	5f                   	pop    %edi
80104194:	5d                   	pop    %ebp
80104195:	c3                   	ret
    panic("sleep without lk");
80104196:	83 ec 0c             	sub    $0xc,%esp
80104199:	68 f0 85 10 80       	push   $0x801085f0
8010419e:	e8 dd c1 ff ff       	call   80100380 <panic>
    panic("sleep");
801041a3:	83 ec 0c             	sub    $0xc,%esp
801041a6:	68 ea 85 10 80       	push   $0x801085ea
801041ab:	e8 d0 c1 ff ff       	call   80100380 <panic>

801041b0 <wakeup>:
}


void
wakeup(void *chan)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	53                   	push   %ebx
801041b4:	83 ec 10             	sub    $0x10,%esp
801041b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041ba:	68 40 2d 11 80       	push   $0x80112d40
801041bf:	e8 7c 0a 00 00       	call   80104c40 <acquire>
801041c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041c7:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801041cc:	eb 0e                	jmp    801041dc <wakeup+0x2c>
801041ce:	66 90                	xchg   %ax,%ax
801041d0:	05 88 00 00 00       	add    $0x88,%eax
801041d5:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
801041da:	74 1e                	je     801041fa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801041dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041e0:	75 ee                	jne    801041d0 <wakeup+0x20>
801041e2:	3b 58 20             	cmp    0x20(%eax),%ebx
801041e5:	75 e9                	jne    801041d0 <wakeup+0x20>
      p->state = RUNNABLE;
801041e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041ee:	05 88 00 00 00       	add    $0x88,%eax
801041f3:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
801041f8:	75 e2                	jne    801041dc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801041fa:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
80104201:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104204:	c9                   	leave
  release(&ptable.lock);
80104205:	e9 d6 09 00 00       	jmp    80104be0 <release>
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104210 <kill>:



int
kill(int pid)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
80104214:	83 ec 10             	sub    $0x10,%esp
80104217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010421a:	68 40 2d 11 80       	push   $0x80112d40
8010421f:	e8 1c 0a 00 00       	call   80104c40 <acquire>
80104224:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104227:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010422c:	eb 0e                	jmp    8010423c <kill+0x2c>
8010422e:	66 90                	xchg   %ax,%ax
80104230:	05 88 00 00 00       	add    $0x88,%eax
80104235:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
8010423a:	74 34                	je     80104270 <kill+0x60>
    if(p->pid == pid){
8010423c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010423f:	75 ef                	jne    80104230 <kill+0x20>
      p->killed = 1;
      
      if(p->state == SLEEPING)
80104241:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104245:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010424c:	75 07                	jne    80104255 <kill+0x45>
        p->state = RUNNABLE;
8010424e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104255:	83 ec 0c             	sub    $0xc,%esp
80104258:	68 40 2d 11 80       	push   $0x80112d40
8010425d:	e8 7e 09 00 00       	call   80104be0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104262:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104265:	83 c4 10             	add    $0x10,%esp
80104268:	31 c0                	xor    %eax,%eax
}
8010426a:	c9                   	leave
8010426b:	c3                   	ret
8010426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	68 40 2d 11 80       	push   $0x80112d40
80104278:	e8 63 09 00 00       	call   80104be0 <release>
}
8010427d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104280:	83 c4 10             	add    $0x10,%esp
80104283:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104288:	c9                   	leave
80104289:	c3                   	ret
8010428a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104290 <procdump>:



void
procdump(void)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104298:	53                   	push   %ebx
80104299:	bb e0 2d 11 80       	mov    $0x80112de0,%ebx
8010429e:	83 ec 3c             	sub    $0x3c,%esp
801042a1:	eb 27                	jmp    801042ca <procdump+0x3a>
801042a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801042a8:	83 ec 0c             	sub    $0xc,%esp
801042ab:	68 6a 87 10 80       	push   $0x8010876a
801042b0:	e8 fb c3 ff ff       	call   801006b0 <cprintf>
801042b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b8:	81 c3 88 00 00 00    	add    $0x88,%ebx
801042be:	81 fb e0 4f 11 80    	cmp    $0x80114fe0,%ebx
801042c4:	0f 84 7e 00 00 00    	je     80104348 <procdump+0xb8>
    if(p->state == UNUSED)
801042ca:	8b 43 a0             	mov    -0x60(%ebx),%eax
801042cd:	85 c0                	test   %eax,%eax
801042cf:	74 e7                	je     801042b8 <procdump+0x28>
      state = "???";
801042d1:	ba 01 86 10 80       	mov    $0x80108601,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042d6:	83 f8 05             	cmp    $0x5,%eax
801042d9:	77 11                	ja     801042ec <procdump+0x5c>
801042db:	8b 14 85 60 8c 10 80 	mov    -0x7fef73a0(,%eax,4),%edx
      state = "???";
801042e2:	b8 01 86 10 80       	mov    $0x80108601,%eax
801042e7:	85 d2                	test   %edx,%edx
801042e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042ec:	53                   	push   %ebx
801042ed:	52                   	push   %edx
801042ee:	ff 73 a4             	push   -0x5c(%ebx)
801042f1:	68 05 86 10 80       	push   $0x80108605
801042f6:	e8 b5 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801042fb:	83 c4 10             	add    $0x10,%esp
801042fe:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104302:	75 a4                	jne    801042a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104304:	83 ec 08             	sub    $0x8,%esp
80104307:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010430a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010430d:	50                   	push   %eax
8010430e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104311:	8b 40 0c             	mov    0xc(%eax),%eax
80104314:	83 c0 08             	add    $0x8,%eax
80104317:	50                   	push   %eax
80104318:	e8 53 07 00 00       	call   80104a70 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010431d:	83 c4 10             	add    $0x10,%esp
80104320:	8b 17                	mov    (%edi),%edx
80104322:	85 d2                	test   %edx,%edx
80104324:	74 82                	je     801042a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104326:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104329:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010432c:	52                   	push   %edx
8010432d:	68 41 83 10 80       	push   $0x80108341
80104332:	e8 79 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104337:	83 c4 10             	add    $0x10,%esp
8010433a:	39 f7                	cmp    %esi,%edi
8010433c:	75 e2                	jne    80104320 <procdump+0x90>
8010433e:	e9 65 ff ff ff       	jmp    801042a8 <procdump+0x18>
80104343:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104348:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010434b:	5b                   	pop    %ebx
8010434c:	5e                   	pop    %esi
8010434d:	5f                   	pop    %edi
8010434e:	5d                   	pop    %ebp
8010434f:	c3                   	ret

80104350 <enumerateUserPages>:
    }
}


int enumerateUserPages(pde_t *pgdir)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	57                   	push   %edi
80104354:	56                   	push   %esi
    int totpages = 0;
    struct spinlock useless_lock;
    initlock(&useless_lock, "useless_counter_lock");
80104355:	8d 45 b4             	lea    -0x4c(%ebp),%eax
    int totpages = 0;
80104358:	31 f6                	xor    %esi,%esi
{
8010435a:	53                   	push   %ebx
8010435b:	83 ec 64             	sub    $0x64,%esp
8010435e:	8b 7d 08             	mov    0x8(%ebp),%edi
    initlock(&useless_lock, "useless_counter_lock");
80104361:	68 0e 86 10 80       	push   $0x8010860e
80104366:	50                   	push   %eax
80104367:	e8 e4 06 00 00       	call   80104a50 <initlock>
8010436c:	83 c4 10             	add    $0x10,%esp
    
    int i = 0;
8010436f:	31 d2                	xor    %edx,%edx
80104371:	89 f9                	mov    %edi,%ecx
80104373:	eb 0e                	jmp    80104383 <enumerateUserPages+0x33>
80104375:	8d 76 00             	lea    0x0(%esi),%esi
            if ((i & 15) == 0) {
                release(&useless_lock);
            }
        }
        
        i++;
80104378:	83 c2 01             	add    $0x1,%edx
    while (i < NPDENTRIES) {
8010437b:	81 fa 00 04 00 00    	cmp    $0x400,%edx
80104381:	74 7e                	je     80104401 <enumerateUserPages+0xb1>
        if (is_present(pgdir[i])) {
80104383:	8b 1c 91             	mov    (%ecx,%edx,4),%ebx
    if (pte_entry & PTE_P) {
80104386:	f6 c3 01             	test   $0x1,%bl
80104389:	74 ed                	je     80104378 <enumerateUserPages+0x28>
    return (pte_t *)P2V(PTE_ADDR(pde_entry));
8010438b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
            if ((i & 15) == 0) {
80104391:	89 d0                	mov    %edx,%eax
    return (pte_t *)P2V(PTE_ADDR(pde_entry));
80104393:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
            if ((i & 15) == 0) {
80104399:	83 e0 0f             	and    $0xf,%eax
8010439c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
8010439f:	74 6a                	je     8010440b <enumerateUserPages+0xbb>
    int i = 0;
801043a1:	89 55 a0             	mov    %edx,-0x60(%ebp)
801043a4:	89 d7                	mov    %edx,%edi
801043a6:	31 c0                	xor    %eax,%eax
801043a8:	c1 e7 16             	shl    $0x16,%edi
801043ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (pte_entry & PTE_P) {
801043b0:	f6 03 01             	testb  $0x1,(%ebx)
801043b3:	74 0d                	je     801043c2 <enumerateUserPages+0x72>
    return va1 | va2;
801043b5:	89 fa                	mov    %edi,%edx
801043b7:	09 c2                	or     %eax,%edx
    *counter = *counter + 1;
801043b9:	81 fa 00 00 00 80    	cmp    $0x80000000,%edx
801043bf:	83 d6 00             	adc    $0x0,%esi
    while (j < NPTENTRIES) {
801043c2:	05 00 10 00 00       	add    $0x1000,%eax
801043c7:	83 c3 04             	add    $0x4,%ebx
801043ca:	3d 00 00 40 00       	cmp    $0x400000,%eax
801043cf:	75 df                	jne    801043b0 <enumerateUserPages+0x60>
            if ((i & 15) == 0) {
801043d1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
801043d4:	8b 55 a0             	mov    -0x60(%ebp),%edx
801043d7:	85 c0                	test   %eax,%eax
801043d9:	75 9d                	jne    80104378 <enumerateUserPages+0x28>
                release(&useless_lock);
801043db:	83 ec 0c             	sub    $0xc,%esp
801043de:	8d 45 b4             	lea    -0x4c(%ebp),%eax
801043e1:	89 4d 08             	mov    %ecx,0x8(%ebp)
801043e4:	89 55 a4             	mov    %edx,-0x5c(%ebp)
801043e7:	50                   	push   %eax
801043e8:	e8 f3 07 00 00       	call   80104be0 <release>
801043ed:	8b 55 a4             	mov    -0x5c(%ebp),%edx
801043f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
801043f3:	83 c4 10             	add    $0x10,%esp
        i++;
801043f6:	83 c2 01             	add    $0x1,%edx
    while (i < NPDENTRIES) {
801043f9:	81 fa 00 04 00 00    	cmp    $0x400,%edx
801043ff:	75 82                	jne    80104383 <enumerateUserPages+0x33>
    }
    
    return totpages;
80104401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104404:	89 f0                	mov    %esi,%eax
80104406:	5b                   	pop    %ebx
80104407:	5e                   	pop    %esi
80104408:	5f                   	pop    %edi
80104409:	5d                   	pop    %ebp
8010440a:	c3                   	ret
                acquire(&useless_lock);
8010440b:	83 ec 0c             	sub    $0xc,%esp
8010440e:	8d 45 b4             	lea    -0x4c(%ebp),%eax
80104411:	89 4d 08             	mov    %ecx,0x8(%ebp)
80104414:	89 55 a0             	mov    %edx,-0x60(%ebp)
80104417:	50                   	push   %eax
80104418:	e8 23 08 00 00       	call   80104c40 <acquire>
8010441d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104420:	8b 55 a0             	mov    -0x60(%ebp),%edx
80104423:	83 c4 10             	add    $0x10,%esp
80104426:	e9 76 ff ff ff       	jmp    801043a1 <enumerateUserPages+0x51>
8010442b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104430 <print_mem_pages>:
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	56                   	push   %esi
    initlock(&print_lock, "print_lock");
80104435:	8d 75 b4             	lea    -0x4c(%ebp),%esi
{
80104438:	53                   	push   %ebx
    p = ptable.proc;
80104439:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
8010443e:	83 ec 58             	sub    $0x58,%esp
    cprintf("Ctrl+I is detected by xv6\n");
80104441:	68 23 86 10 80       	push   $0x80108623
80104446:	e8 65 c2 ff ff       	call   801006b0 <cprintf>
    cprintf("PID NUM_PAGES\n");
8010444b:	c7 04 24 3e 86 10 80 	movl   $0x8010863e,(%esp)
80104452:	e8 59 c2 ff ff       	call   801006b0 <cprintf>
    acquire(&ptable.lock);
80104457:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010445e:	e8 dd 07 00 00       	call   80104c40 <acquire>
80104463:	83 c4 10             	add    $0x10,%esp
80104466:	eb 28                	jmp    80104490 <print_mem_pages+0x60>
80104468:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010446f:	00 
    if (p->state == RUNNING) {
80104470:	83 f8 04             	cmp    $0x4,%eax
80104473:	74 77                	je     801044ec <print_mem_pages+0xbc>
    if (p->state == RUNNABLE) {
80104475:	83 f8 03             	cmp    $0x3,%eax
80104478:	0f 84 bb 00 00 00    	je     80104539 <print_mem_pages+0x109>
        p++;
8010447e:	81 c3 88 00 00 00    	add    $0x88,%ebx
    while (p < &ptable.proc[NPROC]) {
80104484:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
8010448a:	0f 84 fc 00 00 00    	je     8010458c <print_mem_pages+0x15c>
    if (p->state == UNUSED) {
80104490:	8b 43 0c             	mov    0xc(%ebx),%eax
80104493:	85 c0                	test   %eax,%eax
80104495:	74 e7                	je     8010447e <print_mem_pages+0x4e>
    if (p->pid < 1) {
80104497:	8b 4b 10             	mov    0x10(%ebx),%ecx
8010449a:	85 c9                	test   %ecx,%ecx
8010449c:	7e e0                	jle    8010447e <print_mem_pages+0x4e>
    if (p->state == SLEEPING) {
8010449e:	83 f8 02             	cmp    $0x2,%eax
801044a1:	75 cd                	jne    80104470 <print_mem_pages+0x40>
    uint num_pages = enumerateUserPages(p->pgdir);
801044a3:	83 ec 0c             	sub    $0xc,%esp
801044a6:	ff 73 04             	push   0x4(%ebx)
801044a9:	e8 a2 fe ff ff       	call   80104350 <enumerateUserPages>
    p->rss = num_pages;
801044ae:	89 43 7c             	mov    %eax,0x7c(%ebx)
    uint num_pages = enumerateUserPages(p->pgdir);
801044b1:	89 c7                	mov    %eax,%edi
    initlock(&print_lock, "print_lock");
801044b3:	58                   	pop    %eax
801044b4:	5a                   	pop    %edx
801044b5:	68 4d 86 10 80       	push   $0x8010864d
801044ba:	56                   	push   %esi
801044bb:	e8 90 05 00 00       	call   80104a50 <initlock>
    acquire(&print_lock); 
801044c0:	89 34 24             	mov    %esi,(%esp)
801044c3:	e8 78 07 00 00       	call   80104c40 <acquire>
    cprintf("%d %d\n", p->pid, num_pages);
801044c8:	83 c4 0c             	add    $0xc,%esp
801044cb:	57                   	push   %edi
801044cc:	ff 73 10             	push   0x10(%ebx)
801044cf:	68 58 86 10 80       	push   $0x80108658
801044d4:	e8 d7 c1 ff ff       	call   801006b0 <cprintf>
    release(&print_lock); 
801044d9:	89 34 24             	mov    %esi,(%esp)
801044dc:	e8 ff 06 00 00       	call   80104be0 <release>
    if (p->state == RUNNING) {
801044e1:	8b 43 0c             	mov    0xc(%ebx),%eax
}
801044e4:	83 c4 10             	add    $0x10,%esp
    if (p->state == RUNNING) {
801044e7:	83 f8 04             	cmp    $0x4,%eax
801044ea:	75 89                	jne    80104475 <print_mem_pages+0x45>
    uint num_pages = enumerateUserPages(p->pgdir);
801044ec:	83 ec 0c             	sub    $0xc,%esp
801044ef:	ff 73 04             	push   0x4(%ebx)
801044f2:	e8 59 fe ff ff       	call   80104350 <enumerateUserPages>
    p->rss = num_pages;
801044f7:	89 43 7c             	mov    %eax,0x7c(%ebx)
    uint num_pages = enumerateUserPages(p->pgdir);
801044fa:	89 c7                	mov    %eax,%edi
    initlock(&print_lock, "print_lock");
801044fc:	59                   	pop    %ecx
801044fd:	58                   	pop    %eax
801044fe:	68 4d 86 10 80       	push   $0x8010864d
80104503:	56                   	push   %esi
80104504:	e8 47 05 00 00       	call   80104a50 <initlock>
    acquire(&print_lock); 
80104509:	89 34 24             	mov    %esi,(%esp)
8010450c:	e8 2f 07 00 00       	call   80104c40 <acquire>
    cprintf("%d %d\n", p->pid, num_pages);
80104511:	83 c4 0c             	add    $0xc,%esp
80104514:	57                   	push   %edi
80104515:	ff 73 10             	push   0x10(%ebx)
80104518:	68 58 86 10 80       	push   $0x80108658
8010451d:	e8 8e c1 ff ff       	call   801006b0 <cprintf>
    release(&print_lock); 
80104522:	89 34 24             	mov    %esi,(%esp)
80104525:	e8 b6 06 00 00       	call   80104be0 <release>
    if (p->state == RUNNABLE) {
8010452a:	8b 43 0c             	mov    0xc(%ebx),%eax
}
8010452d:	83 c4 10             	add    $0x10,%esp
    if (p->state == RUNNABLE) {
80104530:	83 f8 03             	cmp    $0x3,%eax
80104533:	0f 85 45 ff ff ff    	jne    8010447e <print_mem_pages+0x4e>
    uint num_pages = enumerateUserPages(p->pgdir);
80104539:	83 ec 0c             	sub    $0xc,%esp
8010453c:	ff 73 04             	push   0x4(%ebx)
        p++;
8010453f:	81 c3 88 00 00 00    	add    $0x88,%ebx
    uint num_pages = enumerateUserPages(p->pgdir);
80104545:	e8 06 fe ff ff       	call   80104350 <enumerateUserPages>
    p->rss = num_pages;
8010454a:	89 43 f4             	mov    %eax,-0xc(%ebx)
    uint num_pages = enumerateUserPages(p->pgdir);
8010454d:	89 c7                	mov    %eax,%edi
    initlock(&print_lock, "print_lock");
8010454f:	58                   	pop    %eax
80104550:	5a                   	pop    %edx
80104551:	68 4d 86 10 80       	push   $0x8010864d
80104556:	56                   	push   %esi
80104557:	e8 f4 04 00 00       	call   80104a50 <initlock>
    acquire(&print_lock); 
8010455c:	89 34 24             	mov    %esi,(%esp)
8010455f:	e8 dc 06 00 00       	call   80104c40 <acquire>
    cprintf("%d %d\n", p->pid, num_pages);
80104564:	83 c4 0c             	add    $0xc,%esp
80104567:	57                   	push   %edi
80104568:	ff 73 88             	push   -0x78(%ebx)
8010456b:	68 58 86 10 80       	push   $0x80108658
80104570:	e8 3b c1 ff ff       	call   801006b0 <cprintf>
    release(&print_lock); 
80104575:	89 34 24             	mov    %esi,(%esp)
80104578:	e8 63 06 00 00       	call   80104be0 <release>
}
8010457d:	83 c4 10             	add    $0x10,%esp
    while (p < &ptable.proc[NPROC]) {
80104580:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
80104586:	0f 85 04 ff ff ff    	jne    80104490 <print_mem_pages+0x60>
    release(&ptable.lock);
8010458c:	83 ec 0c             	sub    $0xc,%esp
8010458f:	68 40 2d 11 80       	push   $0x80112d40
80104594:	e8 47 06 00 00       	call   80104be0 <release>
}
80104599:	83 c4 10             	add    $0x10,%esp
8010459c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010459f:	5b                   	pop    %ebx
801045a0:	5e                   	pop    %esi
801045a1:	5f                   	pop    %edi
801045a2:	5d                   	pop    %ebp
801045a3:	c3                   	ret
801045a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045ab:	00 
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045b0 <update_rss>:
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
    initlock(&temp_lock, "rss_temp_lock");
801045b5:	8d 75 c4             	lea    -0x3c(%ebp),%esi
    p = ptable.proc;
801045b8:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
801045bd:	83 ec 48             	sub    $0x48,%esp
    initlock(&temp_lock, "rss_temp_lock");
801045c0:	68 5f 86 10 80       	push   $0x8010865f
801045c5:	56                   	push   %esi
801045c6:	e8 85 04 00 00       	call   80104a50 <initlock>
    acquire(&ptable.lock);
801045cb:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801045d2:	e8 69 06 00 00       	call   80104c40 <acquire>
801045d7:	83 c4 10             	add    $0x10,%esp
801045da:	eb 16                	jmp    801045f2 <update_rss+0x42>
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == RUNNING) {
801045e0:	83 f8 04             	cmp    $0x4,%eax
801045e3:	74 51                	je     80104636 <update_rss+0x86>
        if (p->state == RUNNABLE) {
801045e5:	83 f8 03             	cmp    $0x3,%eax
801045e8:	74 68                	je     80104652 <update_rss+0xa2>
    while (p < &ptable.proc[NPROC]) {
801045ea:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
801045f0:	74 7c                	je     8010466e <update_rss+0xbe>
        if (p->state == UNUSED) {
801045f2:	8b 43 0c             	mov    0xc(%ebx),%eax
            p++;
801045f5:	81 c3 88 00 00 00    	add    $0x88,%ebx
        if (p->state == UNUSED) {
801045fb:	85 c0                	test   %eax,%eax
801045fd:	74 eb                	je     801045ea <update_rss+0x3a>
        if (p->pid < 1) {
801045ff:	8b 53 88             	mov    -0x78(%ebx),%edx
80104602:	85 d2                	test   %edx,%edx
80104604:	7e e4                	jle    801045ea <update_rss+0x3a>
        if (p->state == SLEEPING) {
80104606:	83 f8 02             	cmp    $0x2,%eax
80104609:	75 d5                	jne    801045e0 <update_rss+0x30>
            acquire(&temp_lock);  
8010460b:	83 ec 0c             	sub    $0xc,%esp
8010460e:	56                   	push   %esi
8010460f:	e8 2c 06 00 00       	call   80104c40 <acquire>
            uint num_pages = enumerateUserPages(p->pgdir);
80104614:	58                   	pop    %eax
80104615:	ff b3 7c ff ff ff    	push   -0x84(%ebx)
8010461b:	e8 30 fd ff ff       	call   80104350 <enumerateUserPages>
            p->rss = num_pages;
80104620:	89 43 f4             	mov    %eax,-0xc(%ebx)
            release(&temp_lock);  
80104623:	89 34 24             	mov    %esi,(%esp)
80104626:	e8 b5 05 00 00       	call   80104be0 <release>
        if (p->state == RUNNING) {
8010462b:	8b 43 84             	mov    -0x7c(%ebx),%eax
8010462e:	83 c4 10             	add    $0x10,%esp
80104631:	83 f8 04             	cmp    $0x4,%eax
80104634:	75 af                	jne    801045e5 <update_rss+0x35>
            uint num_pages = enumerateUserPages(p->pgdir);
80104636:	83 ec 0c             	sub    $0xc,%esp
80104639:	ff b3 7c ff ff ff    	push   -0x84(%ebx)
8010463f:	e8 0c fd ff ff       	call   80104350 <enumerateUserPages>
        if (p->state == RUNNABLE) {
80104644:	83 c4 10             	add    $0x10,%esp
            p->rss = num_pages;
80104647:	89 43 f4             	mov    %eax,-0xc(%ebx)
        if (p->state == RUNNABLE) {
8010464a:	8b 43 84             	mov    -0x7c(%ebx),%eax
8010464d:	83 f8 03             	cmp    $0x3,%eax
80104650:	75 98                	jne    801045ea <update_rss+0x3a>
            uint num_pages = enumerateUserPages(p->pgdir);
80104652:	83 ec 0c             	sub    $0xc,%esp
80104655:	ff b3 7c ff ff ff    	push   -0x84(%ebx)
8010465b:	e8 f0 fc ff ff       	call   80104350 <enumerateUserPages>
            p->rss = num_pages;
80104660:	83 c4 10             	add    $0x10,%esp
80104663:	89 43 f4             	mov    %eax,-0xc(%ebx)
    while (p < &ptable.proc[NPROC]) {
80104666:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
8010466c:	75 84                	jne    801045f2 <update_rss+0x42>
    release(&ptable.lock);
8010466e:	83 ec 0c             	sub    $0xc,%esp
80104671:	68 40 2d 11 80       	push   $0x80112d40
80104676:	e8 65 05 00 00       	call   80104be0 <release>
}
8010467b:	83 c4 10             	add    $0x10,%esp
8010467e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104681:	5b                   	pop    %ebx
80104682:	5e                   	pop    %esi
80104683:	5d                   	pop    %ebp
80104684:	c3                   	ret
80104685:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010468c:	00 
8010468d:	8d 76 00             	lea    0x0(%esi),%esi

80104690 <detectVictimProcess>:
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	57                   	push   %edi
80104694:	56                   	push   %esi
    initlock(&temp_lock, "useless_lock");
80104695:	8d 45 b4             	lea    -0x4c(%ebp),%eax
    struct proc *victim_p = 0;
80104698:	31 f6                	xor    %esi,%esi
{
8010469a:	53                   	push   %ebx
    p = ptable.proc;
8010469b:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
801046a0:	83 ec 64             	sub    $0x64,%esp
    initlock(&temp_lock, "useless_lock");
801046a3:	68 6d 86 10 80       	push   $0x8010866d
801046a8:	50                   	push   %eax
801046a9:	e8 a2 03 00 00       	call   80104a50 <initlock>
    acquire(&ptable.lock);
801046ae:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801046b5:	e8 86 05 00 00       	call   80104c40 <acquire>
801046ba:	83 c4 10             	add    $0x10,%esp
    int curr_max_rss = 0;
801046bd:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
    p = ptable.proc;
801046c4:	89 75 a0             	mov    %esi,-0x60(%ebp)
801046c7:	eb 21                	jmp    801046ea <detectVictimProcess+0x5a>
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == RUNNING) {
801046d0:	83 f8 04             	cmp    $0x4,%eax
801046d3:	74 7f                	je     80104754 <detectVictimProcess+0xc4>
        if (p->state == RUNNABLE) {
801046d5:	83 f8 03             	cmp    $0x3,%eax
801046d8:	0f 84 ae 00 00 00    	je     8010478c <detectVictimProcess+0xfc>
    while (p < &ptable.proc[NPROC]) {
801046de:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
801046e4:	0f 84 e6 00 00 00    	je     801047d0 <detectVictimProcess+0x140>
        if (p->state == UNUSED) {
801046ea:	8b 43 0c             	mov    0xc(%ebx),%eax
801046ed:	89 df                	mov    %ebx,%edi
            p++;
801046ef:	81 c3 88 00 00 00    	add    $0x88,%ebx
        if (p->state == UNUSED) {
801046f5:	85 c0                	test   %eax,%eax
801046f7:	74 e5                	je     801046de <detectVictimProcess+0x4e>
        if (p->pid < 1) {
801046f9:	8b 53 88             	mov    -0x78(%ebx),%edx
801046fc:	85 d2                	test   %edx,%edx
801046fe:	7e de                	jle    801046de <detectVictimProcess+0x4e>
        if (p->state == SLEEPING) {
80104700:	83 f8 02             	cmp    $0x2,%eax
80104703:	75 cb                	jne    801046d0 <detectVictimProcess+0x40>
            int rss = enumerateUserPages(p->pgdir);
80104705:	83 ec 0c             	sub    $0xc,%esp
80104708:	ff b3 7c ff ff ff    	push   -0x84(%ebx)
8010470e:	e8 3d fc ff ff       	call   80104350 <enumerateUserPages>
            p->rss = rss;
80104713:	89 43 f4             	mov    %eax,-0xc(%ebx)
            acquire(&temp_lock); 
80104716:	8d 45 b4             	lea    -0x4c(%ebp),%eax
80104719:	89 04 24             	mov    %eax,(%esp)
8010471c:	e8 1f 05 00 00       	call   80104c40 <acquire>
                curr_max_rss = p->rss;
80104721:	8b 43 f4             	mov    -0xc(%ebx),%eax
            if (!p_allocated) {
80104724:	83 c4 10             	add    $0x10,%esp
80104727:	85 f6                	test   %esi,%esi
80104729:	74 07                	je     80104732 <detectVictimProcess+0xa2>
                if (p->rss > curr_max_rss) {
8010472b:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
8010472e:	39 c8                	cmp    %ecx,%eax
80104730:	7e 06                	jle    80104738 <detectVictimProcess+0xa8>
                    curr_max_rss = p->rss;
80104732:	89 45 a4             	mov    %eax,-0x5c(%ebp)
                    victim_p = p;
80104735:	89 7d a0             	mov    %edi,-0x60(%ebp)
            release(&temp_lock); 
80104738:	83 ec 0c             	sub    $0xc,%esp
8010473b:	8d 45 b4             	lea    -0x4c(%ebp),%eax
        if (p->state == RUNNING) {
8010473e:	be 01 00 00 00       	mov    $0x1,%esi
            release(&temp_lock); 
80104743:	50                   	push   %eax
80104744:	e8 97 04 00 00       	call   80104be0 <release>
        if (p->state == RUNNING) {
80104749:	8b 43 84             	mov    -0x7c(%ebx),%eax
8010474c:	83 c4 10             	add    $0x10,%esp
8010474f:	83 f8 04             	cmp    $0x4,%eax
80104752:	75 81                	jne    801046d5 <detectVictimProcess+0x45>
            int rss = enumerateUserPages(p->pgdir);
80104754:	83 ec 0c             	sub    $0xc,%esp
80104757:	ff b3 7c ff ff ff    	push   -0x84(%ebx)
8010475d:	e8 ee fb ff ff       	call   80104350 <enumerateUserPages>
                if (p->rss > curr_max_rss) {
80104762:	83 c4 10             	add    $0x10,%esp
            p->rss = rss;
80104765:	89 43 f4             	mov    %eax,-0xc(%ebx)
            int rss = enumerateUserPages(p->pgdir);
80104768:	89 c1                	mov    %eax,%ecx
        if (p->state == RUNNABLE) {
8010476a:	8b 43 84             	mov    -0x7c(%ebx),%eax
                if (p->rss > curr_max_rss) {
8010476d:	39 4d a4             	cmp    %ecx,-0x5c(%ebp)
80104770:	0f 8c fa 00 00 00    	jl     80104870 <detectVictimProcess+0x1e0>
80104776:	85 f6                	test   %esi,%esi
80104778:	0f 84 f2 00 00 00    	je     80104870 <detectVictimProcess+0x1e0>
        if (p->state == RUNNABLE) {
8010477e:	be 01 00 00 00       	mov    $0x1,%esi
80104783:	83 f8 03             	cmp    $0x3,%eax
80104786:	0f 85 52 ff ff ff    	jne    801046de <detectVictimProcess+0x4e>
            int rss = enumerateUserPages(p->pgdir);
8010478c:	83 ec 0c             	sub    $0xc,%esp
8010478f:	ff b3 7c ff ff ff    	push   -0x84(%ebx)
80104795:	e8 b6 fb ff ff       	call   80104350 <enumerateUserPages>
                if (p->rss > curr_max_rss) {
8010479a:	83 c4 10             	add    $0x10,%esp
            p->rss = rss;
8010479d:	89 43 f4             	mov    %eax,-0xc(%ebx)
                if (p->rss > curr_max_rss) {
801047a0:	85 f6                	test   %esi,%esi
801047a2:	74 0e                	je     801047b2 <detectVictimProcess+0x122>
801047a4:	be 01 00 00 00       	mov    $0x1,%esi
801047a9:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
801047ac:	0f 8d 2c ff ff ff    	jge    801046de <detectVictimProcess+0x4e>
                    curr_max_rss = p->rss;
801047b2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
                if (p->rss > curr_max_rss) {
801047b5:	be 01 00 00 00       	mov    $0x1,%esi
                    victim_p = p;
801047ba:	89 7d a0             	mov    %edi,-0x60(%ebp)
    while (p < &ptable.proc[NPROC]) {
801047bd:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
801047c3:	0f 85 21 ff ff ff    	jne    801046ea <detectVictimProcess+0x5a>
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (!p_allocated) {
801047d0:	89 f2                	mov    %esi,%edx
801047d2:	8b 75 a0             	mov    -0x60(%ebp),%esi
801047d5:	85 d2                	test   %edx,%edx
801047d7:	0f 84 ad 00 00 00    	je     8010488a <detectVictimProcess+0x1fa>
    release(&ptable.lock);
801047dd:	83 ec 0c             	sub    $0xc,%esp
801047e0:	68 40 2d 11 80       	push   $0x80112d40
801047e5:	e8 f6 03 00 00       	call   80104be0 <release>
    if(!p) {
801047ea:	83 c4 10             	add    $0x10,%esp
801047ed:	85 f6                	test   %esi,%esi
801047ef:	0f 84 86 00 00 00    	je     8010487b <detectVictimProcess+0x1eb>
    if(!p->pgdir) {
801047f5:	8b 46 04             	mov    0x4(%esi),%eax
801047f8:	85 c0                	test   %eax,%eax
801047fa:	74 7f                	je     8010487b <detectVictimProcess+0x1eb>
    acquire(&temp_lock); 
801047fc:	83 ec 0c             	sub    $0xc,%esp
801047ff:	8d 45 b4             	lea    -0x4c(%ebp),%eax
80104802:	bb 00 10 00 00       	mov    $0x1000,%ebx
80104807:	50                   	push   %eax
80104808:	e8 33 04 00 00       	call   80104c40 <acquire>
8010480d:	83 c4 10             	add    $0x10,%esp
80104810:	eb 14                	jmp    80104826 <detectVictimProcess+0x196>
80104812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while (va < KERNBASE) {
80104818:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010481e:	81 fb 00 10 00 80    	cmp    $0x80001000,%ebx
80104824:	74 78                	je     8010489e <detectVictimProcess+0x20e>
        pte = walkpgdir(p->pgdir, (char*)va, 0);
80104826:	83 ec 04             	sub    $0x4,%esp
80104829:	8d bb 00 f0 ff ff    	lea    -0x1000(%ebx),%edi
8010482f:	6a 00                	push   $0x0
80104831:	57                   	push   %edi
80104832:	ff 76 04             	push   0x4(%esi)
80104835:	e8 b6 28 00 00       	call   801070f0 <walkpgdir>
        if(pte == 0) {
8010483a:	83 c4 10             	add    $0x10,%esp
8010483d:	85 c0                	test   %eax,%eax
8010483f:	74 d7                	je     80104818 <detectVictimProcess+0x188>
        if(!(*pte & PTE_P)) {
80104841:	8b 10                	mov    (%eax),%edx
80104843:	f6 c2 01             	test   $0x1,%dl
80104846:	74 d0                	je     80104818 <detectVictimProcess+0x188>
        if(!(*pte & PTE_A)) {
80104848:	83 e2 20             	and    $0x20,%edx
8010484b:	75 cb                	jne    80104818 <detectVictimProcess+0x188>
            *pte_store = pte;
8010484d:	8b 4d 08             	mov    0x8(%ebp),%ecx
            release(&temp_lock); 
80104850:	83 ec 0c             	sub    $0xc,%esp
            *pte_store = pte;
80104853:	89 01                	mov    %eax,(%ecx)
            *va_store = va;
80104855:	8b 45 0c             	mov    0xc(%ebp),%eax
80104858:	89 38                	mov    %edi,(%eax)
            release(&temp_lock); 
8010485a:	8d 45 b4             	lea    -0x4c(%ebp),%eax
8010485d:	50                   	push   %eax
8010485e:	e8 7d 03 00 00       	call   80104be0 <release>
            return p;
80104863:	83 c4 10             	add    $0x10,%esp
}
80104866:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104869:	89 f0                	mov    %esi,%eax
8010486b:	5b                   	pop    %ebx
8010486c:	5e                   	pop    %esi
8010486d:	5f                   	pop    %edi
8010486e:	5d                   	pop    %ebp
8010486f:	c3                   	ret
                    curr_max_rss = p->rss;
80104870:	89 4d a4             	mov    %ecx,-0x5c(%ebp)
                    victim_p = p;
80104873:	89 7d a0             	mov    %edi,-0x60(%ebp)
80104876:	e9 03 ff ff ff       	jmp    8010477e <detectVictimProcess+0xee>
}
8010487b:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010487e:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
80104883:	5b                   	pop    %ebx
80104884:	89 f0                	mov    %esi,%eax
80104886:	5e                   	pop    %esi
80104887:	5f                   	pop    %edi
80104888:	5d                   	pop    %ebp
80104889:	c3                   	ret
        release(&ptable.lock);
8010488a:	83 ec 0c             	sub    $0xc,%esp
8010488d:	68 40 2d 11 80       	push   $0x80112d40
80104892:	e8 49 03 00 00       	call   80104be0 <release>
        return 0;
80104897:	83 c4 10             	add    $0x10,%esp
8010489a:	31 f6                	xor    %esi,%esi
8010489c:	eb c8                	jmp    80104866 <detectVictimProcess+0x1d6>
    release(&temp_lock); 
8010489e:	83 ec 0c             	sub    $0xc,%esp
801048a1:	8d 45 b4             	lea    -0x4c(%ebp),%eax
    va = 0;
801048a4:	31 db                	xor    %ebx,%ebx
    release(&temp_lock); 
801048a6:	50                   	push   %eax
801048a7:	e8 34 03 00 00       	call   80104be0 <release>
801048ac:	83 c4 10             	add    $0x10,%esp
801048af:	90                   	nop
        pte = walkpgdir(p->pgdir, (char*)va, 0);
801048b0:	83 ec 04             	sub    $0x4,%esp
801048b3:	6a 00                	push   $0x0
801048b5:	53                   	push   %ebx
            va += PGSIZE;
801048b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        pte = walkpgdir(p->pgdir, (char*)va, 0);
801048bc:	ff 76 04             	push   0x4(%esi)
801048bf:	e8 2c 28 00 00       	call   801070f0 <walkpgdir>
        if(pte == 0) {
801048c4:	83 c4 10             	add    $0x10,%esp
801048c7:	85 c0                	test   %eax,%eax
801048c9:	74 0c                	je     801048d7 <detectVictimProcess+0x247>
        if(*pte & PTE_P) {
801048cb:	8b 10                	mov    (%eax),%edx
801048cd:	f6 c2 01             	test   $0x1,%dl
801048d0:	74 05                	je     801048d7 <detectVictimProcess+0x247>
            *pte &= ~PTE_A;
801048d2:	83 e2 df             	and    $0xffffffdf,%edx
801048d5:	89 10                	mov    %edx,(%eax)
    while (va < KERNBASE) {
801048d7:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801048dd:	75 d1                	jne    801048b0 <detectVictimProcess+0x220>
801048df:	31 db                	xor    %ebx,%ebx
801048e1:	eb 13                	jmp    801048f6 <detectVictimProcess+0x266>
801048e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        va += PGSIZE;
801048e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    while (va < KERNBASE) {
801048ee:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801048f4:	74 a4                	je     8010489a <detectVictimProcess+0x20a>
        pte = walkpgdir(p->pgdir, (char*)va, 0);
801048f6:	83 ec 04             	sub    $0x4,%esp
801048f9:	6a 00                	push   $0x0
801048fb:	53                   	push   %ebx
801048fc:	ff 76 04             	push   0x4(%esi)
801048ff:	e8 ec 27 00 00       	call   801070f0 <walkpgdir>
        if(pte == 0) {
80104904:	83 c4 10             	add    $0x10,%esp
80104907:	85 c0                	test   %eax,%eax
80104909:	74 dd                	je     801048e8 <detectVictimProcess+0x258>
        if(*pte & PTE_P) {
8010490b:	f6 00 01             	testb  $0x1,(%eax)
8010490e:	74 d8                	je     801048e8 <detectVictimProcess+0x258>
            *pte_store = pte;
80104910:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104913:	89 01                	mov    %eax,(%ecx)
            *va_store = va;
80104915:	8b 45 0c             	mov    0xc(%ebp),%eax
80104918:	89 18                	mov    %ebx,(%eax)
            return p;
8010491a:	e9 47 ff ff ff       	jmp    80104866 <detectVictimProcess+0x1d6>
8010491f:	90                   	nop

80104920 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 0c             	sub    $0xc,%esp
80104927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010492a:	68 a4 86 10 80       	push   $0x801086a4
8010492f:	8d 43 04             	lea    0x4(%ebx),%eax
80104932:	50                   	push   %eax
80104933:	e8 18 01 00 00       	call   80104a50 <initlock>
  lk->name = name;
80104938:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010493b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104941:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104944:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010494b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010494e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104951:	c9                   	leave
80104952:	c3                   	ret
80104953:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010495a:	00 
8010495b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104960 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
80104965:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104968:	8d 73 04             	lea    0x4(%ebx),%esi
8010496b:	83 ec 0c             	sub    $0xc,%esp
8010496e:	56                   	push   %esi
8010496f:	e8 cc 02 00 00       	call   80104c40 <acquire>
  while (lk->locked) {
80104974:	8b 13                	mov    (%ebx),%edx
80104976:	83 c4 10             	add    $0x10,%esp
80104979:	85 d2                	test   %edx,%edx
8010497b:	74 16                	je     80104993 <acquiresleep+0x33>
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104980:	83 ec 08             	sub    $0x8,%esp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	e8 66 f7 ff ff       	call   801040f0 <sleep>
  while (lk->locked) {
8010498a:	8b 03                	mov    (%ebx),%eax
8010498c:	83 c4 10             	add    $0x10,%esp
8010498f:	85 c0                	test   %eax,%eax
80104991:	75 ed                	jne    80104980 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104993:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104999:	e8 82 f0 ff ff       	call   80103a20 <myproc>
8010499e:	8b 40 10             	mov    0x10(%eax),%eax
801049a1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049a4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049aa:	5b                   	pop    %ebx
801049ab:	5e                   	pop    %esi
801049ac:	5d                   	pop    %ebp
  release(&lk->lk);
801049ad:	e9 2e 02 00 00       	jmp    80104be0 <release>
801049b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049b9:	00 
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049c0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
801049c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049c8:	8d 73 04             	lea    0x4(%ebx),%esi
801049cb:	83 ec 0c             	sub    $0xc,%esp
801049ce:	56                   	push   %esi
801049cf:	e8 6c 02 00 00       	call   80104c40 <acquire>
  lk->locked = 0;
801049d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049da:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801049e1:	89 1c 24             	mov    %ebx,(%esp)
801049e4:	e8 c7 f7 ff ff       	call   801041b0 <wakeup>
  release(&lk->lk);
801049e9:	83 c4 10             	add    $0x10,%esp
801049ec:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049f2:	5b                   	pop    %ebx
801049f3:	5e                   	pop    %esi
801049f4:	5d                   	pop    %ebp
  release(&lk->lk);
801049f5:	e9 e6 01 00 00       	jmp    80104be0 <release>
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a00 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	57                   	push   %edi
80104a04:	31 ff                	xor    %edi,%edi
80104a06:	56                   	push   %esi
80104a07:	53                   	push   %ebx
80104a08:	83 ec 18             	sub    $0x18,%esp
80104a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a0e:	8d 73 04             	lea    0x4(%ebx),%esi
80104a11:	56                   	push   %esi
80104a12:	e8 29 02 00 00       	call   80104c40 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a17:	8b 03                	mov    (%ebx),%eax
80104a19:	83 c4 10             	add    $0x10,%esp
80104a1c:	85 c0                	test   %eax,%eax
80104a1e:	75 18                	jne    80104a38 <holdingsleep+0x38>
  release(&lk->lk);
80104a20:	83 ec 0c             	sub    $0xc,%esp
80104a23:	56                   	push   %esi
80104a24:	e8 b7 01 00 00       	call   80104be0 <release>
  return r;
}
80104a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a2c:	89 f8                	mov    %edi,%eax
80104a2e:	5b                   	pop    %ebx
80104a2f:	5e                   	pop    %esi
80104a30:	5f                   	pop    %edi
80104a31:	5d                   	pop    %ebp
80104a32:	c3                   	ret
80104a33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104a38:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a3b:	e8 e0 ef ff ff       	call   80103a20 <myproc>
80104a40:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a43:	0f 94 c0             	sete   %al
80104a46:	0f b6 c0             	movzbl %al,%eax
80104a49:	89 c7                	mov    %eax,%edi
80104a4b:	eb d3                	jmp    80104a20 <holdingsleep+0x20>
80104a4d:	66 90                	xchg   %ax,%ax
80104a4f:	90                   	nop

80104a50 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a5f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a69:	5d                   	pop    %ebp
80104a6a:	c3                   	ret
80104a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104a70 <getcallerpcs>:
}


void
getcallerpcs(void *v, uint pcs[])
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
80104a74:	8b 45 08             	mov    0x8(%ebp),%eax
80104a77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a7a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a7d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104a82:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104a87:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a8c:	76 10                	jbe    80104a9e <getcallerpcs+0x2e>
80104a8e:	eb 28                	jmp    80104ab8 <getcallerpcs+0x48>
80104a90:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104a96:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a9c:	77 1a                	ja     80104ab8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     
80104a9e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104aa1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104aa4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; 
80104aa7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104aa9:	83 f8 0a             	cmp    $0xa,%eax
80104aac:	75 e2                	jne    80104a90 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104aae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab1:	c9                   	leave
80104ab2:	c3                   	ret
80104ab3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ab8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80104abb:	83 c1 28             	add    $0x28,%ecx
80104abe:	89 ca                	mov    %ecx,%edx
80104ac0:	29 c2                	sub    %eax,%edx
80104ac2:	83 e2 04             	and    $0x4,%edx
80104ac5:	74 11                	je     80104ad8 <getcallerpcs+0x68>
    pcs[i] = 0;
80104ac7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104acd:	83 c0 04             	add    $0x4,%eax
80104ad0:	39 c1                	cmp    %eax,%ecx
80104ad2:	74 da                	je     80104aae <getcallerpcs+0x3e>
80104ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104ad8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ade:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104ae1:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104ae8:	39 c1                	cmp    %eax,%ecx
80104aea:	75 ec                	jne    80104ad8 <getcallerpcs+0x68>
80104aec:	eb c0                	jmp    80104aae <getcallerpcs+0x3e>
80104aee:	66 90                	xchg   %ax,%ax

80104af0 <pushcli>:



void
pushcli(void)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 04             	sub    $0x4,%esp
80104af7:	9c                   	pushf
80104af8:	5b                   	pop    %ebx
  asm volatile("cli");
80104af9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104afa:	e8 a1 ee ff ff       	call   801039a0 <mycpu>
80104aff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b05:	85 c0                	test   %eax,%eax
80104b07:	74 17                	je     80104b20 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104b09:	e8 92 ee ff ff       	call   801039a0 <mycpu>
80104b0e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b18:	c9                   	leave
80104b19:	c3                   	ret
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104b20:	e8 7b ee ff ff       	call   801039a0 <mycpu>
80104b25:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b2b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104b31:	eb d6                	jmp    80104b09 <pushcli+0x19>
80104b33:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b3a:	00 
80104b3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104b40 <popcli>:

void
popcli(void)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b46:	9c                   	pushf
80104b47:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b48:	f6 c4 02             	test   $0x2,%ah
80104b4b:	75 35                	jne    80104b82 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b4d:	e8 4e ee ff ff       	call   801039a0 <mycpu>
80104b52:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b59:	78 34                	js     80104b8f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b5b:	e8 40 ee ff ff       	call   801039a0 <mycpu>
80104b60:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b66:	85 d2                	test   %edx,%edx
80104b68:	74 06                	je     80104b70 <popcli+0x30>
    sti();
}
80104b6a:	c9                   	leave
80104b6b:	c3                   	ret
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b70:	e8 2b ee ff ff       	call   801039a0 <mycpu>
80104b75:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b7b:	85 c0                	test   %eax,%eax
80104b7d:	74 eb                	je     80104b6a <popcli+0x2a>
  asm volatile("sti");
80104b7f:	fb                   	sti
}
80104b80:	c9                   	leave
80104b81:	c3                   	ret
    panic("popcli - interruptible");
80104b82:	83 ec 0c             	sub    $0xc,%esp
80104b85:	68 af 86 10 80       	push   $0x801086af
80104b8a:	e8 f1 b7 ff ff       	call   80100380 <panic>
    panic("popcli");
80104b8f:	83 ec 0c             	sub    $0xc,%esp
80104b92:	68 c6 86 10 80       	push   $0x801086c6
80104b97:	e8 e4 b7 ff ff       	call   80100380 <panic>
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ba0 <holding>:
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	56                   	push   %esi
80104ba4:	53                   	push   %ebx
80104ba5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ba8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104baa:	e8 41 ff ff ff       	call   80104af0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104baf:	8b 06                	mov    (%esi),%eax
80104bb1:	85 c0                	test   %eax,%eax
80104bb3:	75 0b                	jne    80104bc0 <holding+0x20>
  popcli();
80104bb5:	e8 86 ff ff ff       	call   80104b40 <popcli>
}
80104bba:	89 d8                	mov    %ebx,%eax
80104bbc:	5b                   	pop    %ebx
80104bbd:	5e                   	pop    %esi
80104bbe:	5d                   	pop    %ebp
80104bbf:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104bc0:	8b 5e 08             	mov    0x8(%esi),%ebx
80104bc3:	e8 d8 ed ff ff       	call   801039a0 <mycpu>
80104bc8:	39 c3                	cmp    %eax,%ebx
80104bca:	0f 94 c3             	sete   %bl
  popcli();
80104bcd:	e8 6e ff ff ff       	call   80104b40 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104bd2:	0f b6 db             	movzbl %bl,%ebx
}
80104bd5:	89 d8                	mov    %ebx,%eax
80104bd7:	5b                   	pop    %ebx
80104bd8:	5e                   	pop    %esi
80104bd9:	5d                   	pop    %ebp
80104bda:	c3                   	ret
80104bdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104be0 <release>:
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
80104be5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104be8:	e8 03 ff ff ff       	call   80104af0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104bed:	8b 03                	mov    (%ebx),%eax
80104bef:	85 c0                	test   %eax,%eax
80104bf1:	75 15                	jne    80104c08 <release+0x28>
  popcli();
80104bf3:	e8 48 ff ff ff       	call   80104b40 <popcli>
    panic("release");
80104bf8:	83 ec 0c             	sub    $0xc,%esp
80104bfb:	68 cd 86 10 80       	push   $0x801086cd
80104c00:	e8 7b b7 ff ff       	call   80100380 <panic>
80104c05:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104c08:	8b 73 08             	mov    0x8(%ebx),%esi
80104c0b:	e8 90 ed ff ff       	call   801039a0 <mycpu>
80104c10:	39 c6                	cmp    %eax,%esi
80104c12:	75 df                	jne    80104bf3 <release+0x13>
  popcli();
80104c14:	e8 27 ff ff ff       	call   80104b40 <popcli>
  lk->pcs[0] = 0;
80104c19:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c20:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104c27:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104c2c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104c32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c35:	5b                   	pop    %ebx
80104c36:	5e                   	pop    %esi
80104c37:	5d                   	pop    %ebp
  popcli();
80104c38:	e9 03 ff ff ff       	jmp    80104b40 <popcli>
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi

80104c40 <acquire>:
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	53                   	push   %ebx
80104c44:	83 ec 04             	sub    $0x4,%esp
  pushcli(); 
80104c47:	e8 a4 fe ff ff       	call   80104af0 <pushcli>
  if(holding(lk))
80104c4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104c4f:	e8 9c fe ff ff       	call   80104af0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c54:	8b 03                	mov    (%ebx),%eax
80104c56:	85 c0                	test   %eax,%eax
80104c58:	0f 85 b2 00 00 00    	jne    80104d10 <acquire+0xd0>
  popcli();
80104c5e:	e8 dd fe ff ff       	call   80104b40 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104c63:	b9 01 00 00 00       	mov    $0x1,%ecx
80104c68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c6f:	00 
  while(xchg(&lk->locked, 1) != 0)
80104c70:	8b 55 08             	mov    0x8(%ebp),%edx
80104c73:	89 c8                	mov    %ecx,%eax
80104c75:	f0 87 02             	lock xchg %eax,(%edx)
80104c78:	85 c0                	test   %eax,%eax
80104c7a:	75 f4                	jne    80104c70 <acquire+0x30>
  __sync_synchronize();
80104c7c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c84:	e8 17 ed ff ff       	call   801039a0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104c89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104c8c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
80104c8e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c91:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104c97:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104c9c:	77 32                	ja     80104cd0 <acquire+0x90>
  ebp = (uint*)v - 2;
80104c9e:	89 e8                	mov    %ebp,%eax
80104ca0:	eb 14                	jmp    80104cb6 <acquire+0x76>
80104ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ca8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104cae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cb4:	77 1a                	ja     80104cd0 <acquire+0x90>
    pcs[i] = ebp[1];     
80104cb6:	8b 58 04             	mov    0x4(%eax),%ebx
80104cb9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104cbd:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; 
80104cc0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104cc2:	83 fa 0a             	cmp    $0xa,%edx
80104cc5:	75 e1                	jne    80104ca8 <acquire+0x68>
}
80104cc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cca:	c9                   	leave
80104ccb:	c3                   	ret
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cd0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104cd4:	83 c1 34             	add    $0x34,%ecx
80104cd7:	89 ca                	mov    %ecx,%edx
80104cd9:	29 c2                	sub    %eax,%edx
80104cdb:	83 e2 04             	and    $0x4,%edx
80104cde:	74 10                	je     80104cf0 <acquire+0xb0>
    pcs[i] = 0;
80104ce0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ce6:	83 c0 04             	add    $0x4,%eax
80104ce9:	39 c1                	cmp    %eax,%ecx
80104ceb:	74 da                	je     80104cc7 <acquire+0x87>
80104ced:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104cf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104cf6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104cf9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104d00:	39 c1                	cmp    %eax,%ecx
80104d02:	75 ec                	jne    80104cf0 <acquire+0xb0>
80104d04:	eb c1                	jmp    80104cc7 <acquire+0x87>
80104d06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d0d:	00 
80104d0e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104d10:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104d13:	e8 88 ec ff ff       	call   801039a0 <mycpu>
80104d18:	39 c3                	cmp    %eax,%ebx
80104d1a:	0f 85 3e ff ff ff    	jne    80104c5e <acquire+0x1e>
  popcli();
80104d20:	e8 1b fe ff ff       	call   80104b40 <popcli>
    panic("acquire");
80104d25:	83 ec 0c             	sub    $0xc,%esp
80104d28:	68 d5 86 10 80       	push   $0x801086d5
80104d2d:	e8 4e b6 ff ff       	call   80100380 <panic>
80104d32:	66 90                	xchg   %ax,%ax
80104d34:	66 90                	xchg   %ax,%ax
80104d36:	66 90                	xchg   %ax,%ax
80104d38:	66 90                	xchg   %ax,%ax
80104d3a:	66 90                	xchg   %ax,%ax
80104d3c:	66 90                	xchg   %ax,%ax
80104d3e:	66 90                	xchg   %ax,%ax

80104d40 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	57                   	push   %edi
80104d44:	8b 55 08             	mov    0x8(%ebp),%edx
80104d47:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104d4a:	89 d0                	mov    %edx,%eax
80104d4c:	09 c8                	or     %ecx,%eax
80104d4e:	a8 03                	test   $0x3,%al
80104d50:	75 1e                	jne    80104d70 <memset+0x30>
    c &= 0xFF;
80104d52:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d56:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104d59:	89 d7                	mov    %edx,%edi
80104d5b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104d61:	fc                   	cld
80104d62:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104d64:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104d67:	89 d0                	mov    %edx,%eax
80104d69:	c9                   	leave
80104d6a:	c3                   	ret
80104d6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104d70:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d73:	89 d7                	mov    %edx,%edi
80104d75:	fc                   	cld
80104d76:	f3 aa                	rep stos %al,%es:(%edi)
80104d78:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104d7b:	89 d0                	mov    %edx,%eax
80104d7d:	c9                   	leave
80104d7e:	c3                   	ret
80104d7f:	90                   	nop

80104d80 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	8b 75 10             	mov    0x10(%ebp),%esi
80104d87:	8b 45 08             	mov    0x8(%ebp),%eax
80104d8a:	53                   	push   %ebx
80104d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d8e:	85 f6                	test   %esi,%esi
80104d90:	74 2e                	je     80104dc0 <memcmp+0x40>
80104d92:	01 c6                	add    %eax,%esi
80104d94:	eb 14                	jmp    80104daa <memcmp+0x2a>
80104d96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d9d:	00 
80104d9e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104da0:	83 c0 01             	add    $0x1,%eax
80104da3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104da6:	39 f0                	cmp    %esi,%eax
80104da8:	74 16                	je     80104dc0 <memcmp+0x40>
    if(*s1 != *s2)
80104daa:	0f b6 08             	movzbl (%eax),%ecx
80104dad:	0f b6 1a             	movzbl (%edx),%ebx
80104db0:	38 d9                	cmp    %bl,%cl
80104db2:	74 ec                	je     80104da0 <memcmp+0x20>
      return *s1 - *s2;
80104db4:	0f b6 c1             	movzbl %cl,%eax
80104db7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104db9:	5b                   	pop    %ebx
80104dba:	5e                   	pop    %esi
80104dbb:	5d                   	pop    %ebp
80104dbc:	c3                   	ret
80104dbd:	8d 76 00             	lea    0x0(%esi),%esi
80104dc0:	5b                   	pop    %ebx
  return 0;
80104dc1:	31 c0                	xor    %eax,%eax
}
80104dc3:	5e                   	pop    %esi
80104dc4:	5d                   	pop    %ebp
80104dc5:	c3                   	ret
80104dc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dcd:	00 
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	8b 55 08             	mov    0x8(%ebp),%edx
80104dd7:	8b 45 10             	mov    0x10(%ebp),%eax
80104dda:	56                   	push   %esi
80104ddb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104dde:	39 d6                	cmp    %edx,%esi
80104de0:	73 26                	jae    80104e08 <memmove+0x38>
80104de2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104de5:	39 ca                	cmp    %ecx,%edx
80104de7:	73 1f                	jae    80104e08 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104de9:	85 c0                	test   %eax,%eax
80104deb:	74 0f                	je     80104dfc <memmove+0x2c>
80104ded:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104df0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104df4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104df7:	83 e8 01             	sub    $0x1,%eax
80104dfa:	73 f4                	jae    80104df0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104dfc:	5e                   	pop    %esi
80104dfd:	89 d0                	mov    %edx,%eax
80104dff:	5f                   	pop    %edi
80104e00:	5d                   	pop    %ebp
80104e01:	c3                   	ret
80104e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104e08:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104e0b:	89 d7                	mov    %edx,%edi
80104e0d:	85 c0                	test   %eax,%eax
80104e0f:	74 eb                	je     80104dfc <memmove+0x2c>
80104e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104e18:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104e19:	39 ce                	cmp    %ecx,%esi
80104e1b:	75 fb                	jne    80104e18 <memmove+0x48>
}
80104e1d:	5e                   	pop    %esi
80104e1e:	89 d0                	mov    %edx,%eax
80104e20:	5f                   	pop    %edi
80104e21:	5d                   	pop    %ebp
80104e22:	c3                   	ret
80104e23:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e2a:	00 
80104e2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104e30 <memcpy>:


void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104e30:	eb 9e                	jmp    80104dd0 <memmove>
80104e32:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e39:	00 
80104e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e40 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	53                   	push   %ebx
80104e44:	8b 55 10             	mov    0x10(%ebp),%edx
80104e47:	8b 45 08             	mov    0x8(%ebp),%eax
80104e4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104e4d:	85 d2                	test   %edx,%edx
80104e4f:	75 16                	jne    80104e67 <strncmp+0x27>
80104e51:	eb 2d                	jmp    80104e80 <strncmp+0x40>
80104e53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e58:	3a 19                	cmp    (%ecx),%bl
80104e5a:	75 12                	jne    80104e6e <strncmp+0x2e>
    n--, p++, q++;
80104e5c:	83 c0 01             	add    $0x1,%eax
80104e5f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e62:	83 ea 01             	sub    $0x1,%edx
80104e65:	74 19                	je     80104e80 <strncmp+0x40>
80104e67:	0f b6 18             	movzbl (%eax),%ebx
80104e6a:	84 db                	test   %bl,%bl
80104e6c:	75 ea                	jne    80104e58 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e6e:	0f b6 00             	movzbl (%eax),%eax
80104e71:	0f b6 11             	movzbl (%ecx),%edx
}
80104e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e77:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104e78:	29 d0                	sub    %edx,%eax
}
80104e7a:	c3                   	ret
80104e7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104e83:	31 c0                	xor    %eax,%eax
}
80104e85:	c9                   	leave
80104e86:	c3                   	ret
80104e87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e8e:	00 
80104e8f:	90                   	nop

80104e90 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	57                   	push   %edi
80104e94:	56                   	push   %esi
80104e95:	8b 75 08             	mov    0x8(%ebp),%esi
80104e98:	53                   	push   %ebx
80104e99:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e9c:	89 f0                	mov    %esi,%eax
80104e9e:	eb 15                	jmp    80104eb5 <strncpy+0x25>
80104ea0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104ea4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104ea7:	83 c0 01             	add    $0x1,%eax
80104eaa:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104eae:	88 48 ff             	mov    %cl,-0x1(%eax)
80104eb1:	84 c9                	test   %cl,%cl
80104eb3:	74 13                	je     80104ec8 <strncpy+0x38>
80104eb5:	89 d3                	mov    %edx,%ebx
80104eb7:	83 ea 01             	sub    $0x1,%edx
80104eba:	85 db                	test   %ebx,%ebx
80104ebc:	7f e2                	jg     80104ea0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104ebe:	5b                   	pop    %ebx
80104ebf:	89 f0                	mov    %esi,%eax
80104ec1:	5e                   	pop    %esi
80104ec2:	5f                   	pop    %edi
80104ec3:	5d                   	pop    %ebp
80104ec4:	c3                   	ret
80104ec5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104ec8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104ecb:	83 e9 01             	sub    $0x1,%ecx
80104ece:	85 d2                	test   %edx,%edx
80104ed0:	74 ec                	je     80104ebe <strncpy+0x2e>
80104ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104ed8:	83 c0 01             	add    $0x1,%eax
80104edb:	89 ca                	mov    %ecx,%edx
80104edd:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104ee1:	29 c2                	sub    %eax,%edx
80104ee3:	85 d2                	test   %edx,%edx
80104ee5:	7f f1                	jg     80104ed8 <strncpy+0x48>
}
80104ee7:	5b                   	pop    %ebx
80104ee8:	89 f0                	mov    %esi,%eax
80104eea:	5e                   	pop    %esi
80104eeb:	5f                   	pop    %edi
80104eec:	5d                   	pop    %ebp
80104eed:	c3                   	ret
80104eee:	66 90                	xchg   %ax,%ax

80104ef0 <safestrcpy>:


char*
safestrcpy(char *s, const char *t, int n)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	8b 55 10             	mov    0x10(%ebp),%edx
80104ef7:	8b 75 08             	mov    0x8(%ebp),%esi
80104efa:	53                   	push   %ebx
80104efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104efe:	85 d2                	test   %edx,%edx
80104f00:	7e 25                	jle    80104f27 <safestrcpy+0x37>
80104f02:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104f06:	89 f2                	mov    %esi,%edx
80104f08:	eb 16                	jmp    80104f20 <safestrcpy+0x30>
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f10:	0f b6 08             	movzbl (%eax),%ecx
80104f13:	83 c0 01             	add    $0x1,%eax
80104f16:	83 c2 01             	add    $0x1,%edx
80104f19:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f1c:	84 c9                	test   %cl,%cl
80104f1e:	74 04                	je     80104f24 <safestrcpy+0x34>
80104f20:	39 d8                	cmp    %ebx,%eax
80104f22:	75 ec                	jne    80104f10 <safestrcpy+0x20>
    ;
  *s = 0;
80104f24:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104f27:	89 f0                	mov    %esi,%eax
80104f29:	5b                   	pop    %ebx
80104f2a:	5e                   	pop    %esi
80104f2b:	5d                   	pop    %ebp
80104f2c:	c3                   	ret
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi

80104f30 <strlen>:

int
strlen(const char *s)
{
80104f30:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f31:	31 c0                	xor    %eax,%eax
{
80104f33:	89 e5                	mov    %esp,%ebp
80104f35:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104f38:	80 3a 00             	cmpb   $0x0,(%edx)
80104f3b:	74 0c                	je     80104f49 <strlen+0x19>
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
80104f40:	83 c0 01             	add    $0x1,%eax
80104f43:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f47:	75 f7                	jne    80104f40 <strlen+0x10>
    ;
  return n;
}
80104f49:	5d                   	pop    %ebp
80104f4a:	c3                   	ret

80104f4b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f4b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f4f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f53:	55                   	push   %ebp
  pushl %ebx
80104f54:	53                   	push   %ebx
  pushl %esi
80104f55:	56                   	push   %esi
  pushl %edi
80104f56:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f57:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f59:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f5b:	5f                   	pop    %edi
  popl %esi
80104f5c:	5e                   	pop    %esi
  popl %ebx
80104f5d:	5b                   	pop    %ebx
  popl %ebp
80104f5e:	5d                   	pop    %ebp
  ret
80104f5f:	c3                   	ret

80104f60 <fetchint>:



int
fetchint(uint addr, int *ip)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	53                   	push   %ebx
80104f64:	83 ec 04             	sub    $0x4,%esp
80104f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f6a:	e8 b1 ea ff ff       	call   80103a20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f6f:	8b 00                	mov    (%eax),%eax
80104f71:	39 c3                	cmp    %eax,%ebx
80104f73:	73 1b                	jae    80104f90 <fetchint+0x30>
80104f75:	8d 53 04             	lea    0x4(%ebx),%edx
80104f78:	39 d0                	cmp    %edx,%eax
80104f7a:	72 14                	jb     80104f90 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f7f:	8b 13                	mov    (%ebx),%edx
80104f81:	89 10                	mov    %edx,(%eax)
  return 0;
80104f83:	31 c0                	xor    %eax,%eax
}
80104f85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f88:	c9                   	leave
80104f89:	c3                   	ret
80104f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f95:	eb ee                	jmp    80104f85 <fetchint+0x25>
80104f97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f9e:	00 
80104f9f:	90                   	nop

80104fa0 <fetchstr>:



int
fetchstr(uint addr, char **pp)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	53                   	push   %ebx
80104fa4:	83 ec 04             	sub    $0x4,%esp
80104fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104faa:	e8 71 ea ff ff       	call   80103a20 <myproc>

  if(addr >= curproc->sz)
80104faf:	3b 18                	cmp    (%eax),%ebx
80104fb1:	73 2d                	jae    80104fe0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fb6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104fb8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104fba:	39 d3                	cmp    %edx,%ebx
80104fbc:	73 22                	jae    80104fe0 <fetchstr+0x40>
80104fbe:	89 d8                	mov    %ebx,%eax
80104fc0:	eb 0d                	jmp    80104fcf <fetchstr+0x2f>
80104fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fc8:	83 c0 01             	add    $0x1,%eax
80104fcb:	39 d0                	cmp    %edx,%eax
80104fcd:	73 11                	jae    80104fe0 <fetchstr+0x40>
    if(*s == 0)
80104fcf:	80 38 00             	cmpb   $0x0,(%eax)
80104fd2:	75 f4                	jne    80104fc8 <fetchstr+0x28>
      return s - *pp;
80104fd4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104fd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fd9:	c9                   	leave
80104fda:	c3                   	ret
80104fdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fe8:	c9                   	leave
80104fe9:	c3                   	ret
80104fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ff0 <argint>:


int
argint(int n, int *ip)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ff5:	e8 26 ea ff ff       	call   80103a20 <myproc>
80104ffa:	8b 55 08             	mov    0x8(%ebp),%edx
80104ffd:	8b 40 18             	mov    0x18(%eax),%eax
80105000:	8b 40 44             	mov    0x44(%eax),%eax
80105003:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105006:	e8 15 ea ff ff       	call   80103a20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010500b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010500e:	8b 00                	mov    (%eax),%eax
80105010:	39 c6                	cmp    %eax,%esi
80105012:	73 1c                	jae    80105030 <argint+0x40>
80105014:	8d 53 08             	lea    0x8(%ebx),%edx
80105017:	39 d0                	cmp    %edx,%eax
80105019:	72 15                	jb     80105030 <argint+0x40>
  *ip = *(int*)(addr);
8010501b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010501e:	8b 53 04             	mov    0x4(%ebx),%edx
80105021:	89 10                	mov    %edx,(%eax)
  return 0;
80105023:	31 c0                	xor    %eax,%eax
}
80105025:	5b                   	pop    %ebx
80105026:	5e                   	pop    %esi
80105027:	5d                   	pop    %ebp
80105028:	c3                   	ret
80105029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105035:	eb ee                	jmp    80105025 <argint+0x35>
80105037:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010503e:	00 
8010503f:	90                   	nop

80105040 <argptr>:



int
argptr(int n, char **pp, int size)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	56                   	push   %esi
80105045:	53                   	push   %ebx
80105046:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105049:	e8 d2 e9 ff ff       	call   80103a20 <myproc>
8010504e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105050:	e8 cb e9 ff ff       	call   80103a20 <myproc>
80105055:	8b 55 08             	mov    0x8(%ebp),%edx
80105058:	8b 40 18             	mov    0x18(%eax),%eax
8010505b:	8b 40 44             	mov    0x44(%eax),%eax
8010505e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105061:	e8 ba e9 ff ff       	call   80103a20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105066:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105069:	8b 00                	mov    (%eax),%eax
8010506b:	39 c7                	cmp    %eax,%edi
8010506d:	73 31                	jae    801050a0 <argptr+0x60>
8010506f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105072:	39 c8                	cmp    %ecx,%eax
80105074:	72 2a                	jb     801050a0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105076:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105079:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010507c:	85 d2                	test   %edx,%edx
8010507e:	78 20                	js     801050a0 <argptr+0x60>
80105080:	8b 16                	mov    (%esi),%edx
80105082:	39 d0                	cmp    %edx,%eax
80105084:	73 1a                	jae    801050a0 <argptr+0x60>
80105086:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105089:	01 c3                	add    %eax,%ebx
8010508b:	39 da                	cmp    %ebx,%edx
8010508d:	72 11                	jb     801050a0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010508f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105092:	89 02                	mov    %eax,(%edx)
  return 0;
80105094:	31 c0                	xor    %eax,%eax
}
80105096:	83 c4 0c             	add    $0xc,%esp
80105099:	5b                   	pop    %ebx
8010509a:	5e                   	pop    %esi
8010509b:	5f                   	pop    %edi
8010509c:	5d                   	pop    %ebp
8010509d:	c3                   	ret
8010509e:	66 90                	xchg   %ax,%ax
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a5:	eb ef                	jmp    80105096 <argptr+0x56>
801050a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801050ae:	00 
801050af:	90                   	nop

801050b0 <argstr>:



int
argstr(int n, char **pp)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	56                   	push   %esi
801050b4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050b5:	e8 66 e9 ff ff       	call   80103a20 <myproc>
801050ba:	8b 55 08             	mov    0x8(%ebp),%edx
801050bd:	8b 40 18             	mov    0x18(%eax),%eax
801050c0:	8b 40 44             	mov    0x44(%eax),%eax
801050c3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050c6:	e8 55 e9 ff ff       	call   80103a20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050cb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050ce:	8b 00                	mov    (%eax),%eax
801050d0:	39 c6                	cmp    %eax,%esi
801050d2:	73 44                	jae    80105118 <argstr+0x68>
801050d4:	8d 53 08             	lea    0x8(%ebx),%edx
801050d7:	39 d0                	cmp    %edx,%eax
801050d9:	72 3d                	jb     80105118 <argstr+0x68>
  *ip = *(int*)(addr);
801050db:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801050de:	e8 3d e9 ff ff       	call   80103a20 <myproc>
  if(addr >= curproc->sz)
801050e3:	3b 18                	cmp    (%eax),%ebx
801050e5:	73 31                	jae    80105118 <argstr+0x68>
  *pp = (char*)addr;
801050e7:	8b 55 0c             	mov    0xc(%ebp),%edx
801050ea:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801050ec:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801050ee:	39 d3                	cmp    %edx,%ebx
801050f0:	73 26                	jae    80105118 <argstr+0x68>
801050f2:	89 d8                	mov    %ebx,%eax
801050f4:	eb 11                	jmp    80105107 <argstr+0x57>
801050f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801050fd:	00 
801050fe:	66 90                	xchg   %ax,%ax
80105100:	83 c0 01             	add    $0x1,%eax
80105103:	39 d0                	cmp    %edx,%eax
80105105:	73 11                	jae    80105118 <argstr+0x68>
    if(*s == 0)
80105107:	80 38 00             	cmpb   $0x0,(%eax)
8010510a:	75 f4                	jne    80105100 <argstr+0x50>
      return s - *pp;
8010510c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010510e:	5b                   	pop    %ebx
8010510f:	5e                   	pop    %esi
80105110:	5d                   	pop    %ebp
80105111:	c3                   	ret
80105112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105118:	5b                   	pop    %ebx
    return -1;
80105119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010511e:	5e                   	pop    %esi
8010511f:	5d                   	pop    %ebp
80105120:	c3                   	ret
80105121:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105128:	00 
80105129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105130 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	53                   	push   %ebx
80105134:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105137:	e8 e4 e8 ff ff       	call   80103a20 <myproc>
8010513c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010513e:	8b 40 18             	mov    0x18(%eax),%eax
80105141:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105144:	8d 50 ff             	lea    -0x1(%eax),%edx
80105147:	83 fa 14             	cmp    $0x14,%edx
8010514a:	77 24                	ja     80105170 <syscall+0x40>
8010514c:	8b 14 85 80 8c 10 80 	mov    -0x7fef7380(,%eax,4),%edx
80105153:	85 d2                	test   %edx,%edx
80105155:	74 19                	je     80105170 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105157:	ff d2                	call   *%edx
80105159:	89 c2                	mov    %eax,%edx
8010515b:	8b 43 18             	mov    0x18(%ebx),%eax
8010515e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105164:	c9                   	leave
80105165:	c3                   	ret
80105166:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010516d:	00 
8010516e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80105170:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105171:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105174:	50                   	push   %eax
80105175:	ff 73 10             	push   0x10(%ebx)
80105178:	68 dd 86 10 80       	push   $0x801086dd
8010517d:	e8 2e b5 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105182:	8b 43 18             	mov    0x18(%ebx),%eax
80105185:	83 c4 10             	add    $0x10,%esp
80105188:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010518f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105192:	c9                   	leave
80105193:	c3                   	ret
80105194:	66 90                	xchg   %ax,%ax
80105196:	66 90                	xchg   %ax,%ax
80105198:	66 90                	xchg   %ax,%ax
8010519a:	66 90                	xchg   %ax,%ax
8010519c:	66 90                	xchg   %ax,%ax
8010519e:	66 90                	xchg   %ax,%ax

801051a0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	57                   	push   %edi
801051a4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051a5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801051a8:	53                   	push   %ebx
801051a9:	83 ec 34             	sub    $0x34,%esp
801051ac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801051af:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801051b5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801051b8:	57                   	push   %edi
801051b9:	50                   	push   %eax
801051ba:	e8 51 cf ff ff       	call   80102110 <nameiparent>
801051bf:	83 c4 10             	add    $0x10,%esp
801051c2:	85 c0                	test   %eax,%eax
801051c4:	74 5e                	je     80105224 <create+0x84>
    return 0;
  ilock(dp);
801051c6:	83 ec 0c             	sub    $0xc,%esp
801051c9:	89 c3                	mov    %eax,%ebx
801051cb:	50                   	push   %eax
801051cc:	e8 3f c6 ff ff       	call   80101810 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801051d1:	83 c4 0c             	add    $0xc,%esp
801051d4:	6a 00                	push   $0x0
801051d6:	57                   	push   %edi
801051d7:	53                   	push   %ebx
801051d8:	e8 83 cb ff ff       	call   80101d60 <dirlookup>
801051dd:	83 c4 10             	add    $0x10,%esp
801051e0:	89 c6                	mov    %eax,%esi
801051e2:	85 c0                	test   %eax,%eax
801051e4:	74 4a                	je     80105230 <create+0x90>
    iunlockput(dp);
801051e6:	83 ec 0c             	sub    $0xc,%esp
801051e9:	53                   	push   %ebx
801051ea:	e8 b1 c8 ff ff       	call   80101aa0 <iunlockput>
    ilock(ip);
801051ef:	89 34 24             	mov    %esi,(%esp)
801051f2:	e8 19 c6 ff ff       	call   80101810 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801051f7:	83 c4 10             	add    $0x10,%esp
801051fa:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801051ff:	75 17                	jne    80105218 <create+0x78>
80105201:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105206:	75 10                	jne    80105218 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010520b:	89 f0                	mov    %esi,%eax
8010520d:	5b                   	pop    %ebx
8010520e:	5e                   	pop    %esi
8010520f:	5f                   	pop    %edi
80105210:	5d                   	pop    %ebp
80105211:	c3                   	ret
80105212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	56                   	push   %esi
8010521c:	e8 7f c8 ff ff       	call   80101aa0 <iunlockput>
    return 0;
80105221:	83 c4 10             	add    $0x10,%esp
}
80105224:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105227:	31 f6                	xor    %esi,%esi
}
80105229:	5b                   	pop    %ebx
8010522a:	89 f0                	mov    %esi,%eax
8010522c:	5e                   	pop    %esi
8010522d:	5f                   	pop    %edi
8010522e:	5d                   	pop    %ebp
8010522f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105230:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105234:	83 ec 08             	sub    $0x8,%esp
80105237:	50                   	push   %eax
80105238:	ff 33                	push   (%ebx)
8010523a:	e8 61 c4 ff ff       	call   801016a0 <ialloc>
8010523f:	83 c4 10             	add    $0x10,%esp
80105242:	89 c6                	mov    %eax,%esi
80105244:	85 c0                	test   %eax,%eax
80105246:	0f 84 bc 00 00 00    	je     80105308 <create+0x168>
  ilock(ip);
8010524c:	83 ec 0c             	sub    $0xc,%esp
8010524f:	50                   	push   %eax
80105250:	e8 bb c5 ff ff       	call   80101810 <ilock>
  ip->major = major;
80105255:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105259:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010525d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105261:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105265:	b8 01 00 00 00       	mov    $0x1,%eax
8010526a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010526e:	89 34 24             	mov    %esi,(%esp)
80105271:	e8 ea c4 ff ff       	call   80101760 <iupdate>
  if(type == T_DIR){  
80105276:	83 c4 10             	add    $0x10,%esp
80105279:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010527e:	74 30                	je     801052b0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80105280:	83 ec 04             	sub    $0x4,%esp
80105283:	ff 76 04             	push   0x4(%esi)
80105286:	57                   	push   %edi
80105287:	53                   	push   %ebx
80105288:	e8 a3 cd ff ff       	call   80102030 <dirlink>
8010528d:	83 c4 10             	add    $0x10,%esp
80105290:	85 c0                	test   %eax,%eax
80105292:	78 67                	js     801052fb <create+0x15b>
  iunlockput(dp);
80105294:	83 ec 0c             	sub    $0xc,%esp
80105297:	53                   	push   %ebx
80105298:	e8 03 c8 ff ff       	call   80101aa0 <iunlockput>
  return ip;
8010529d:	83 c4 10             	add    $0x10,%esp
}
801052a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052a3:	89 f0                	mov    %esi,%eax
801052a5:	5b                   	pop    %ebx
801052a6:	5e                   	pop    %esi
801052a7:	5f                   	pop    %edi
801052a8:	5d                   	pop    %ebp
801052a9:	c3                   	ret
801052aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801052b0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  
801052b3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801052b8:	53                   	push   %ebx
801052b9:	e8 a2 c4 ff ff       	call   80101760 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801052be:	83 c4 0c             	add    $0xc,%esp
801052c1:	ff 76 04             	push   0x4(%esi)
801052c4:	68 15 87 10 80       	push   $0x80108715
801052c9:	56                   	push   %esi
801052ca:	e8 61 cd ff ff       	call   80102030 <dirlink>
801052cf:	83 c4 10             	add    $0x10,%esp
801052d2:	85 c0                	test   %eax,%eax
801052d4:	78 18                	js     801052ee <create+0x14e>
801052d6:	83 ec 04             	sub    $0x4,%esp
801052d9:	ff 73 04             	push   0x4(%ebx)
801052dc:	68 14 87 10 80       	push   $0x80108714
801052e1:	56                   	push   %esi
801052e2:	e8 49 cd ff ff       	call   80102030 <dirlink>
801052e7:	83 c4 10             	add    $0x10,%esp
801052ea:	85 c0                	test   %eax,%eax
801052ec:	79 92                	jns    80105280 <create+0xe0>
      panic("create dots");
801052ee:	83 ec 0c             	sub    $0xc,%esp
801052f1:	68 08 87 10 80       	push   $0x80108708
801052f6:	e8 85 b0 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
801052fb:	83 ec 0c             	sub    $0xc,%esp
801052fe:	68 17 87 10 80       	push   $0x80108717
80105303:	e8 78 b0 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105308:	83 ec 0c             	sub    $0xc,%esp
8010530b:	68 f9 86 10 80       	push   $0x801086f9
80105310:	e8 6b b0 ff ff       	call   80100380 <panic>
80105315:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010531c:	00 
8010531d:	8d 76 00             	lea    0x0(%esi),%esi

80105320 <sys_dup>:
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	56                   	push   %esi
80105324:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105325:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105328:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010532b:	50                   	push   %eax
8010532c:	6a 00                	push   $0x0
8010532e:	e8 bd fc ff ff       	call   80104ff0 <argint>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	85 c0                	test   %eax,%eax
80105338:	78 36                	js     80105370 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010533a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010533e:	77 30                	ja     80105370 <sys_dup+0x50>
80105340:	e8 db e6 ff ff       	call   80103a20 <myproc>
80105345:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105348:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010534c:	85 f6                	test   %esi,%esi
8010534e:	74 20                	je     80105370 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105350:	e8 cb e6 ff ff       	call   80103a20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105355:	31 db                	xor    %ebx,%ebx
80105357:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010535e:	00 
8010535f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105360:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105364:	85 d2                	test   %edx,%edx
80105366:	74 18                	je     80105380 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105368:	83 c3 01             	add    $0x1,%ebx
8010536b:	83 fb 10             	cmp    $0x10,%ebx
8010536e:	75 f0                	jne    80105360 <sys_dup+0x40>
}
80105370:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105373:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105378:	89 d8                	mov    %ebx,%eax
8010537a:	5b                   	pop    %ebx
8010537b:	5e                   	pop    %esi
8010537c:	5d                   	pop    %ebp
8010537d:	c3                   	ret
8010537e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105380:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105383:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105387:	56                   	push   %esi
80105388:	e8 a3 bb ff ff       	call   80100f30 <filedup>
  return fd;
8010538d:	83 c4 10             	add    $0x10,%esp
}
80105390:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105393:	89 d8                	mov    %ebx,%eax
80105395:	5b                   	pop    %ebx
80105396:	5e                   	pop    %esi
80105397:	5d                   	pop    %ebp
80105398:	c3                   	ret
80105399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053a0 <sys_read>:
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	56                   	push   %esi
801053a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801053a5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801053a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801053ab:	53                   	push   %ebx
801053ac:	6a 00                	push   $0x0
801053ae:	e8 3d fc ff ff       	call   80104ff0 <argint>
801053b3:	83 c4 10             	add    $0x10,%esp
801053b6:	85 c0                	test   %eax,%eax
801053b8:	78 5e                	js     80105418 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053be:	77 58                	ja     80105418 <sys_read+0x78>
801053c0:	e8 5b e6 ff ff       	call   80103a20 <myproc>
801053c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053c8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801053cc:	85 f6                	test   %esi,%esi
801053ce:	74 48                	je     80105418 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053d0:	83 ec 08             	sub    $0x8,%esp
801053d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053d6:	50                   	push   %eax
801053d7:	6a 02                	push   $0x2
801053d9:	e8 12 fc ff ff       	call   80104ff0 <argint>
801053de:	83 c4 10             	add    $0x10,%esp
801053e1:	85 c0                	test   %eax,%eax
801053e3:	78 33                	js     80105418 <sys_read+0x78>
801053e5:	83 ec 04             	sub    $0x4,%esp
801053e8:	ff 75 f0             	push   -0x10(%ebp)
801053eb:	53                   	push   %ebx
801053ec:	6a 01                	push   $0x1
801053ee:	e8 4d fc ff ff       	call   80105040 <argptr>
801053f3:	83 c4 10             	add    $0x10,%esp
801053f6:	85 c0                	test   %eax,%eax
801053f8:	78 1e                	js     80105418 <sys_read+0x78>
  return fileread(f, p, n);
801053fa:	83 ec 04             	sub    $0x4,%esp
801053fd:	ff 75 f0             	push   -0x10(%ebp)
80105400:	ff 75 f4             	push   -0xc(%ebp)
80105403:	56                   	push   %esi
80105404:	e8 a7 bc ff ff       	call   801010b0 <fileread>
80105409:	83 c4 10             	add    $0x10,%esp
}
8010540c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010540f:	5b                   	pop    %ebx
80105410:	5e                   	pop    %esi
80105411:	5d                   	pop    %ebp
80105412:	c3                   	ret
80105413:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541d:	eb ed                	jmp    8010540c <sys_read+0x6c>
8010541f:	90                   	nop

80105420 <sys_write>:
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	56                   	push   %esi
80105424:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105425:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105428:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010542b:	53                   	push   %ebx
8010542c:	6a 00                	push   $0x0
8010542e:	e8 bd fb ff ff       	call   80104ff0 <argint>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	78 5e                	js     80105498 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010543a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010543e:	77 58                	ja     80105498 <sys_write+0x78>
80105440:	e8 db e5 ff ff       	call   80103a20 <myproc>
80105445:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105448:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010544c:	85 f6                	test   %esi,%esi
8010544e:	74 48                	je     80105498 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105450:	83 ec 08             	sub    $0x8,%esp
80105453:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105456:	50                   	push   %eax
80105457:	6a 02                	push   $0x2
80105459:	e8 92 fb ff ff       	call   80104ff0 <argint>
8010545e:	83 c4 10             	add    $0x10,%esp
80105461:	85 c0                	test   %eax,%eax
80105463:	78 33                	js     80105498 <sys_write+0x78>
80105465:	83 ec 04             	sub    $0x4,%esp
80105468:	ff 75 f0             	push   -0x10(%ebp)
8010546b:	53                   	push   %ebx
8010546c:	6a 01                	push   $0x1
8010546e:	e8 cd fb ff ff       	call   80105040 <argptr>
80105473:	83 c4 10             	add    $0x10,%esp
80105476:	85 c0                	test   %eax,%eax
80105478:	78 1e                	js     80105498 <sys_write+0x78>
  return filewrite(f, p, n);
8010547a:	83 ec 04             	sub    $0x4,%esp
8010547d:	ff 75 f0             	push   -0x10(%ebp)
80105480:	ff 75 f4             	push   -0xc(%ebp)
80105483:	56                   	push   %esi
80105484:	e8 b7 bc ff ff       	call   80101140 <filewrite>
80105489:	83 c4 10             	add    $0x10,%esp
}
8010548c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010548f:	5b                   	pop    %ebx
80105490:	5e                   	pop    %esi
80105491:	5d                   	pop    %ebp
80105492:	c3                   	ret
80105493:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549d:	eb ed                	jmp    8010548c <sys_write+0x6c>
8010549f:	90                   	nop

801054a0 <sys_close>:
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	56                   	push   %esi
801054a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801054a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054ab:	50                   	push   %eax
801054ac:	6a 00                	push   $0x0
801054ae:	e8 3d fb ff ff       	call   80104ff0 <argint>
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	85 c0                	test   %eax,%eax
801054b8:	78 3e                	js     801054f8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054be:	77 38                	ja     801054f8 <sys_close+0x58>
801054c0:	e8 5b e5 ff ff       	call   80103a20 <myproc>
801054c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054c8:	8d 5a 08             	lea    0x8(%edx),%ebx
801054cb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801054cf:	85 f6                	test   %esi,%esi
801054d1:	74 25                	je     801054f8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801054d3:	e8 48 e5 ff ff       	call   80103a20 <myproc>
  fileclose(f);
801054d8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801054db:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801054e2:	00 
  fileclose(f);
801054e3:	56                   	push   %esi
801054e4:	e8 97 ba ff ff       	call   80100f80 <fileclose>
  return 0;
801054e9:	83 c4 10             	add    $0x10,%esp
801054ec:	31 c0                	xor    %eax,%eax
}
801054ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054f1:	5b                   	pop    %ebx
801054f2:	5e                   	pop    %esi
801054f3:	5d                   	pop    %ebp
801054f4:	c3                   	ret
801054f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fd:	eb ef                	jmp    801054ee <sys_close+0x4e>
801054ff:	90                   	nop

80105500 <sys_fstat>:
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	56                   	push   %esi
80105504:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105505:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105508:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010550b:	53                   	push   %ebx
8010550c:	6a 00                	push   $0x0
8010550e:	e8 dd fa ff ff       	call   80104ff0 <argint>
80105513:	83 c4 10             	add    $0x10,%esp
80105516:	85 c0                	test   %eax,%eax
80105518:	78 46                	js     80105560 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010551a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010551e:	77 40                	ja     80105560 <sys_fstat+0x60>
80105520:	e8 fb e4 ff ff       	call   80103a20 <myproc>
80105525:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105528:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010552c:	85 f6                	test   %esi,%esi
8010552e:	74 30                	je     80105560 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105530:	83 ec 04             	sub    $0x4,%esp
80105533:	6a 14                	push   $0x14
80105535:	53                   	push   %ebx
80105536:	6a 01                	push   $0x1
80105538:	e8 03 fb ff ff       	call   80105040 <argptr>
8010553d:	83 c4 10             	add    $0x10,%esp
80105540:	85 c0                	test   %eax,%eax
80105542:	78 1c                	js     80105560 <sys_fstat+0x60>
  return filestat(f, st);
80105544:	83 ec 08             	sub    $0x8,%esp
80105547:	ff 75 f4             	push   -0xc(%ebp)
8010554a:	56                   	push   %esi
8010554b:	e8 10 bb ff ff       	call   80101060 <filestat>
80105550:	83 c4 10             	add    $0x10,%esp
}
80105553:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105556:	5b                   	pop    %ebx
80105557:	5e                   	pop    %esi
80105558:	5d                   	pop    %ebp
80105559:	c3                   	ret
8010555a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105565:	eb ec                	jmp    80105553 <sys_fstat+0x53>
80105567:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010556e:	00 
8010556f:	90                   	nop

80105570 <sys_link>:
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	57                   	push   %edi
80105574:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105575:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105578:	53                   	push   %ebx
80105579:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010557c:	50                   	push   %eax
8010557d:	6a 00                	push   $0x0
8010557f:	e8 2c fb ff ff       	call   801050b0 <argstr>
80105584:	83 c4 10             	add    $0x10,%esp
80105587:	85 c0                	test   %eax,%eax
80105589:	0f 88 fb 00 00 00    	js     8010568a <sys_link+0x11a>
8010558f:	83 ec 08             	sub    $0x8,%esp
80105592:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105595:	50                   	push   %eax
80105596:	6a 01                	push   $0x1
80105598:	e8 13 fb ff ff       	call   801050b0 <argstr>
8010559d:	83 c4 10             	add    $0x10,%esp
801055a0:	85 c0                	test   %eax,%eax
801055a2:	0f 88 e2 00 00 00    	js     8010568a <sys_link+0x11a>
  begin_op();
801055a8:	e8 43 d8 ff ff       	call   80102df0 <begin_op>
  if((ip = namei(old)) == 0){
801055ad:	83 ec 0c             	sub    $0xc,%esp
801055b0:	ff 75 d4             	push   -0x2c(%ebp)
801055b3:	e8 38 cb ff ff       	call   801020f0 <namei>
801055b8:	83 c4 10             	add    $0x10,%esp
801055bb:	89 c3                	mov    %eax,%ebx
801055bd:	85 c0                	test   %eax,%eax
801055bf:	0f 84 df 00 00 00    	je     801056a4 <sys_link+0x134>
  ilock(ip);
801055c5:	83 ec 0c             	sub    $0xc,%esp
801055c8:	50                   	push   %eax
801055c9:	e8 42 c2 ff ff       	call   80101810 <ilock>
  if(ip->type == T_DIR){
801055ce:	83 c4 10             	add    $0x10,%esp
801055d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055d6:	0f 84 b5 00 00 00    	je     80105691 <sys_link+0x121>
  iupdate(ip);
801055dc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801055df:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801055e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801055e7:	53                   	push   %ebx
801055e8:	e8 73 c1 ff ff       	call   80101760 <iupdate>
  iunlock(ip);
801055ed:	89 1c 24             	mov    %ebx,(%esp)
801055f0:	e8 fb c2 ff ff       	call   801018f0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801055f5:	58                   	pop    %eax
801055f6:	5a                   	pop    %edx
801055f7:	57                   	push   %edi
801055f8:	ff 75 d0             	push   -0x30(%ebp)
801055fb:	e8 10 cb ff ff       	call   80102110 <nameiparent>
80105600:	83 c4 10             	add    $0x10,%esp
80105603:	89 c6                	mov    %eax,%esi
80105605:	85 c0                	test   %eax,%eax
80105607:	74 5b                	je     80105664 <sys_link+0xf4>
  ilock(dp);
80105609:	83 ec 0c             	sub    $0xc,%esp
8010560c:	50                   	push   %eax
8010560d:	e8 fe c1 ff ff       	call   80101810 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105612:	8b 03                	mov    (%ebx),%eax
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	39 06                	cmp    %eax,(%esi)
80105619:	75 3d                	jne    80105658 <sys_link+0xe8>
8010561b:	83 ec 04             	sub    $0x4,%esp
8010561e:	ff 73 04             	push   0x4(%ebx)
80105621:	57                   	push   %edi
80105622:	56                   	push   %esi
80105623:	e8 08 ca ff ff       	call   80102030 <dirlink>
80105628:	83 c4 10             	add    $0x10,%esp
8010562b:	85 c0                	test   %eax,%eax
8010562d:	78 29                	js     80105658 <sys_link+0xe8>
  iunlockput(dp);
8010562f:	83 ec 0c             	sub    $0xc,%esp
80105632:	56                   	push   %esi
80105633:	e8 68 c4 ff ff       	call   80101aa0 <iunlockput>
  iput(ip);
80105638:	89 1c 24             	mov    %ebx,(%esp)
8010563b:	e8 00 c3 ff ff       	call   80101940 <iput>
  end_op();
80105640:	e8 1b d8 ff ff       	call   80102e60 <end_op>
  return 0;
80105645:	83 c4 10             	add    $0x10,%esp
80105648:	31 c0                	xor    %eax,%eax
}
8010564a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010564d:	5b                   	pop    %ebx
8010564e:	5e                   	pop    %esi
8010564f:	5f                   	pop    %edi
80105650:	5d                   	pop    %ebp
80105651:	c3                   	ret
80105652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105658:	83 ec 0c             	sub    $0xc,%esp
8010565b:	56                   	push   %esi
8010565c:	e8 3f c4 ff ff       	call   80101aa0 <iunlockput>
    goto bad;
80105661:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105664:	83 ec 0c             	sub    $0xc,%esp
80105667:	53                   	push   %ebx
80105668:	e8 a3 c1 ff ff       	call   80101810 <ilock>
  ip->nlink--;
8010566d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105672:	89 1c 24             	mov    %ebx,(%esp)
80105675:	e8 e6 c0 ff ff       	call   80101760 <iupdate>
  iunlockput(ip);
8010567a:	89 1c 24             	mov    %ebx,(%esp)
8010567d:	e8 1e c4 ff ff       	call   80101aa0 <iunlockput>
  end_op();
80105682:	e8 d9 d7 ff ff       	call   80102e60 <end_op>
  return -1;
80105687:	83 c4 10             	add    $0x10,%esp
    return -1;
8010568a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568f:	eb b9                	jmp    8010564a <sys_link+0xda>
    iunlockput(ip);
80105691:	83 ec 0c             	sub    $0xc,%esp
80105694:	53                   	push   %ebx
80105695:	e8 06 c4 ff ff       	call   80101aa0 <iunlockput>
    end_op();
8010569a:	e8 c1 d7 ff ff       	call   80102e60 <end_op>
    return -1;
8010569f:	83 c4 10             	add    $0x10,%esp
801056a2:	eb e6                	jmp    8010568a <sys_link+0x11a>
    end_op();
801056a4:	e8 b7 d7 ff ff       	call   80102e60 <end_op>
    return -1;
801056a9:	eb df                	jmp    8010568a <sys_link+0x11a>
801056ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801056b0 <sys_unlink>:
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801056b5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801056b8:	53                   	push   %ebx
801056b9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801056bc:	50                   	push   %eax
801056bd:	6a 00                	push   $0x0
801056bf:	e8 ec f9 ff ff       	call   801050b0 <argstr>
801056c4:	83 c4 10             	add    $0x10,%esp
801056c7:	85 c0                	test   %eax,%eax
801056c9:	0f 88 54 01 00 00    	js     80105823 <sys_unlink+0x173>
  begin_op();
801056cf:	e8 1c d7 ff ff       	call   80102df0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801056d4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801056d7:	83 ec 08             	sub    $0x8,%esp
801056da:	53                   	push   %ebx
801056db:	ff 75 c0             	push   -0x40(%ebp)
801056de:	e8 2d ca ff ff       	call   80102110 <nameiparent>
801056e3:	83 c4 10             	add    $0x10,%esp
801056e6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801056e9:	85 c0                	test   %eax,%eax
801056eb:	0f 84 58 01 00 00    	je     80105849 <sys_unlink+0x199>
  ilock(dp);
801056f1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801056f4:	83 ec 0c             	sub    $0xc,%esp
801056f7:	57                   	push   %edi
801056f8:	e8 13 c1 ff ff       	call   80101810 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056fd:	58                   	pop    %eax
801056fe:	5a                   	pop    %edx
801056ff:	68 15 87 10 80       	push   $0x80108715
80105704:	53                   	push   %ebx
80105705:	e8 36 c6 ff ff       	call   80101d40 <namecmp>
8010570a:	83 c4 10             	add    $0x10,%esp
8010570d:	85 c0                	test   %eax,%eax
8010570f:	0f 84 fb 00 00 00    	je     80105810 <sys_unlink+0x160>
80105715:	83 ec 08             	sub    $0x8,%esp
80105718:	68 14 87 10 80       	push   $0x80108714
8010571d:	53                   	push   %ebx
8010571e:	e8 1d c6 ff ff       	call   80101d40 <namecmp>
80105723:	83 c4 10             	add    $0x10,%esp
80105726:	85 c0                	test   %eax,%eax
80105728:	0f 84 e2 00 00 00    	je     80105810 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010572e:	83 ec 04             	sub    $0x4,%esp
80105731:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105734:	50                   	push   %eax
80105735:	53                   	push   %ebx
80105736:	57                   	push   %edi
80105737:	e8 24 c6 ff ff       	call   80101d60 <dirlookup>
8010573c:	83 c4 10             	add    $0x10,%esp
8010573f:	89 c3                	mov    %eax,%ebx
80105741:	85 c0                	test   %eax,%eax
80105743:	0f 84 c7 00 00 00    	je     80105810 <sys_unlink+0x160>
  ilock(ip);
80105749:	83 ec 0c             	sub    $0xc,%esp
8010574c:	50                   	push   %eax
8010574d:	e8 be c0 ff ff       	call   80101810 <ilock>
  if(ip->nlink < 1)
80105752:	83 c4 10             	add    $0x10,%esp
80105755:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010575a:	0f 8e 0a 01 00 00    	jle    8010586a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105760:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105765:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105768:	74 66                	je     801057d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010576a:	83 ec 04             	sub    $0x4,%esp
8010576d:	6a 10                	push   $0x10
8010576f:	6a 00                	push   $0x0
80105771:	57                   	push   %edi
80105772:	e8 c9 f5 ff ff       	call   80104d40 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105777:	6a 10                	push   $0x10
80105779:	ff 75 c4             	push   -0x3c(%ebp)
8010577c:	57                   	push   %edi
8010577d:	ff 75 b4             	push   -0x4c(%ebp)
80105780:	e8 9b c4 ff ff       	call   80101c20 <writei>
80105785:	83 c4 20             	add    $0x20,%esp
80105788:	83 f8 10             	cmp    $0x10,%eax
8010578b:	0f 85 cc 00 00 00    	jne    8010585d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105791:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105796:	0f 84 94 00 00 00    	je     80105830 <sys_unlink+0x180>
  iunlockput(dp);
8010579c:	83 ec 0c             	sub    $0xc,%esp
8010579f:	ff 75 b4             	push   -0x4c(%ebp)
801057a2:	e8 f9 c2 ff ff       	call   80101aa0 <iunlockput>
  ip->nlink--;
801057a7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057ac:	89 1c 24             	mov    %ebx,(%esp)
801057af:	e8 ac bf ff ff       	call   80101760 <iupdate>
  iunlockput(ip);
801057b4:	89 1c 24             	mov    %ebx,(%esp)
801057b7:	e8 e4 c2 ff ff       	call   80101aa0 <iunlockput>
  end_op();
801057bc:	e8 9f d6 ff ff       	call   80102e60 <end_op>
  return 0;
801057c1:	83 c4 10             	add    $0x10,%esp
801057c4:	31 c0                	xor    %eax,%eax
}
801057c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057c9:	5b                   	pop    %ebx
801057ca:	5e                   	pop    %esi
801057cb:	5f                   	pop    %edi
801057cc:	5d                   	pop    %ebp
801057cd:	c3                   	ret
801057ce:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801057d4:	76 94                	jbe    8010576a <sys_unlink+0xba>
801057d6:	be 20 00 00 00       	mov    $0x20,%esi
801057db:	eb 0b                	jmp    801057e8 <sys_unlink+0x138>
801057dd:	8d 76 00             	lea    0x0(%esi),%esi
801057e0:	83 c6 10             	add    $0x10,%esi
801057e3:	3b 73 58             	cmp    0x58(%ebx),%esi
801057e6:	73 82                	jae    8010576a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057e8:	6a 10                	push   $0x10
801057ea:	56                   	push   %esi
801057eb:	57                   	push   %edi
801057ec:	53                   	push   %ebx
801057ed:	e8 2e c3 ff ff       	call   80101b20 <readi>
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	83 f8 10             	cmp    $0x10,%eax
801057f8:	75 56                	jne    80105850 <sys_unlink+0x1a0>
    if(de.inum != 0)
801057fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801057ff:	74 df                	je     801057e0 <sys_unlink+0x130>
    iunlockput(ip);
80105801:	83 ec 0c             	sub    $0xc,%esp
80105804:	53                   	push   %ebx
80105805:	e8 96 c2 ff ff       	call   80101aa0 <iunlockput>
    goto bad;
8010580a:	83 c4 10             	add    $0x10,%esp
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	ff 75 b4             	push   -0x4c(%ebp)
80105816:	e8 85 c2 ff ff       	call   80101aa0 <iunlockput>
  end_op();
8010581b:	e8 40 d6 ff ff       	call   80102e60 <end_op>
  return -1;
80105820:	83 c4 10             	add    $0x10,%esp
    return -1;
80105823:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105828:	eb 9c                	jmp    801057c6 <sys_unlink+0x116>
8010582a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105830:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105833:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105836:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010583b:	50                   	push   %eax
8010583c:	e8 1f bf ff ff       	call   80101760 <iupdate>
80105841:	83 c4 10             	add    $0x10,%esp
80105844:	e9 53 ff ff ff       	jmp    8010579c <sys_unlink+0xec>
    end_op();
80105849:	e8 12 d6 ff ff       	call   80102e60 <end_op>
    return -1;
8010584e:	eb d3                	jmp    80105823 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105850:	83 ec 0c             	sub    $0xc,%esp
80105853:	68 39 87 10 80       	push   $0x80108739
80105858:	e8 23 ab ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	68 4b 87 10 80       	push   $0x8010874b
80105865:	e8 16 ab ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010586a:	83 ec 0c             	sub    $0xc,%esp
8010586d:	68 27 87 10 80       	push   $0x80108727
80105872:	e8 09 ab ff ff       	call   80100380 <panic>
80105877:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010587e:	00 
8010587f:	90                   	nop

80105880 <sys_open>:

int
sys_open(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	57                   	push   %edi
80105884:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105885:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105888:	53                   	push   %ebx
80105889:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010588c:	50                   	push   %eax
8010588d:	6a 00                	push   $0x0
8010588f:	e8 1c f8 ff ff       	call   801050b0 <argstr>
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	85 c0                	test   %eax,%eax
80105899:	0f 88 8e 00 00 00    	js     8010592d <sys_open+0xad>
8010589f:	83 ec 08             	sub    $0x8,%esp
801058a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058a5:	50                   	push   %eax
801058a6:	6a 01                	push   $0x1
801058a8:	e8 43 f7 ff ff       	call   80104ff0 <argint>
801058ad:	83 c4 10             	add    $0x10,%esp
801058b0:	85 c0                	test   %eax,%eax
801058b2:	78 79                	js     8010592d <sys_open+0xad>
    return -1;

  begin_op();
801058b4:	e8 37 d5 ff ff       	call   80102df0 <begin_op>

  if(omode & O_CREATE){
801058b9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058bd:	75 79                	jne    80105938 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058bf:	83 ec 0c             	sub    $0xc,%esp
801058c2:	ff 75 e0             	push   -0x20(%ebp)
801058c5:	e8 26 c8 ff ff       	call   801020f0 <namei>
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	89 c6                	mov    %eax,%esi
801058cf:	85 c0                	test   %eax,%eax
801058d1:	0f 84 7e 00 00 00    	je     80105955 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801058d7:	83 ec 0c             	sub    $0xc,%esp
801058da:	50                   	push   %eax
801058db:	e8 30 bf ff ff       	call   80101810 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058e0:	83 c4 10             	add    $0x10,%esp
801058e3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058e8:	0f 84 ba 00 00 00    	je     801059a8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058ee:	e8 cd b5 ff ff       	call   80100ec0 <filealloc>
801058f3:	89 c7                	mov    %eax,%edi
801058f5:	85 c0                	test   %eax,%eax
801058f7:	74 23                	je     8010591c <sys_open+0x9c>
  struct proc *curproc = myproc();
801058f9:	e8 22 e1 ff ff       	call   80103a20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058fe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105900:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105904:	85 d2                	test   %edx,%edx
80105906:	74 58                	je     80105960 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105908:	83 c3 01             	add    $0x1,%ebx
8010590b:	83 fb 10             	cmp    $0x10,%ebx
8010590e:	75 f0                	jne    80105900 <sys_open+0x80>
    if(f)
      fileclose(f);
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	57                   	push   %edi
80105914:	e8 67 b6 ff ff       	call   80100f80 <fileclose>
80105919:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010591c:	83 ec 0c             	sub    $0xc,%esp
8010591f:	56                   	push   %esi
80105920:	e8 7b c1 ff ff       	call   80101aa0 <iunlockput>
    end_op();
80105925:	e8 36 d5 ff ff       	call   80102e60 <end_op>
    return -1;
8010592a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010592d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105932:	eb 65                	jmp    80105999 <sys_open+0x119>
80105934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105938:	83 ec 0c             	sub    $0xc,%esp
8010593b:	31 c9                	xor    %ecx,%ecx
8010593d:	ba 02 00 00 00       	mov    $0x2,%edx
80105942:	6a 00                	push   $0x0
80105944:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105947:	e8 54 f8 ff ff       	call   801051a0 <create>
    if(ip == 0){
8010594c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010594f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105951:	85 c0                	test   %eax,%eax
80105953:	75 99                	jne    801058ee <sys_open+0x6e>
      end_op();
80105955:	e8 06 d5 ff ff       	call   80102e60 <end_op>
      return -1;
8010595a:	eb d1                	jmp    8010592d <sys_open+0xad>
8010595c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105960:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105963:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105967:	56                   	push   %esi
80105968:	e8 83 bf ff ff       	call   801018f0 <iunlock>
  end_op();
8010596d:	e8 ee d4 ff ff       	call   80102e60 <end_op>

  f->type = FD_INODE;
80105972:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105978:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010597b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010597e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105981:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105983:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010598a:	f7 d0                	not    %eax
8010598c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010598f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105992:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105995:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105999:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010599c:	89 d8                	mov    %ebx,%eax
8010599e:	5b                   	pop    %ebx
8010599f:	5e                   	pop    %esi
801059a0:	5f                   	pop    %edi
801059a1:	5d                   	pop    %ebp
801059a2:	c3                   	ret
801059a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801059a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059ab:	85 c9                	test   %ecx,%ecx
801059ad:	0f 84 3b ff ff ff    	je     801058ee <sys_open+0x6e>
801059b3:	e9 64 ff ff ff       	jmp    8010591c <sys_open+0x9c>
801059b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059bf:	00 

801059c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059c6:	e8 25 d4 ff ff       	call   80102df0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059cb:	83 ec 08             	sub    $0x8,%esp
801059ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059d1:	50                   	push   %eax
801059d2:	6a 00                	push   $0x0
801059d4:	e8 d7 f6 ff ff       	call   801050b0 <argstr>
801059d9:	83 c4 10             	add    $0x10,%esp
801059dc:	85 c0                	test   %eax,%eax
801059de:	78 30                	js     80105a10 <sys_mkdir+0x50>
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e6:	31 c9                	xor    %ecx,%ecx
801059e8:	ba 01 00 00 00       	mov    $0x1,%edx
801059ed:	6a 00                	push   $0x0
801059ef:	e8 ac f7 ff ff       	call   801051a0 <create>
801059f4:	83 c4 10             	add    $0x10,%esp
801059f7:	85 c0                	test   %eax,%eax
801059f9:	74 15                	je     80105a10 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059fb:	83 ec 0c             	sub    $0xc,%esp
801059fe:	50                   	push   %eax
801059ff:	e8 9c c0 ff ff       	call   80101aa0 <iunlockput>
  end_op();
80105a04:	e8 57 d4 ff ff       	call   80102e60 <end_op>
  return 0;
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	31 c0                	xor    %eax,%eax
}
80105a0e:	c9                   	leave
80105a0f:	c3                   	ret
    end_op();
80105a10:	e8 4b d4 ff ff       	call   80102e60 <end_op>
    return -1;
80105a15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a1a:	c9                   	leave
80105a1b:	c3                   	ret
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_mknod>:

int
sys_mknod(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a26:	e8 c5 d3 ff ff       	call   80102df0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a2b:	83 ec 08             	sub    $0x8,%esp
80105a2e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a31:	50                   	push   %eax
80105a32:	6a 00                	push   $0x0
80105a34:	e8 77 f6 ff ff       	call   801050b0 <argstr>
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	85 c0                	test   %eax,%eax
80105a3e:	78 60                	js     80105aa0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a40:	83 ec 08             	sub    $0x8,%esp
80105a43:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a46:	50                   	push   %eax
80105a47:	6a 01                	push   $0x1
80105a49:	e8 a2 f5 ff ff       	call   80104ff0 <argint>
  if((argstr(0, &path)) < 0 ||
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	85 c0                	test   %eax,%eax
80105a53:	78 4b                	js     80105aa0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a55:	83 ec 08             	sub    $0x8,%esp
80105a58:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a5b:	50                   	push   %eax
80105a5c:	6a 02                	push   $0x2
80105a5e:	e8 8d f5 ff ff       	call   80104ff0 <argint>
     argint(1, &major) < 0 ||
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	85 c0                	test   %eax,%eax
80105a68:	78 36                	js     80105aa0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a6a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105a6e:	83 ec 0c             	sub    $0xc,%esp
80105a71:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105a75:	ba 03 00 00 00       	mov    $0x3,%edx
80105a7a:	50                   	push   %eax
80105a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a7e:	e8 1d f7 ff ff       	call   801051a0 <create>
     argint(2, &minor) < 0 ||
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	85 c0                	test   %eax,%eax
80105a88:	74 16                	je     80105aa0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a8a:	83 ec 0c             	sub    $0xc,%esp
80105a8d:	50                   	push   %eax
80105a8e:	e8 0d c0 ff ff       	call   80101aa0 <iunlockput>
  end_op();
80105a93:	e8 c8 d3 ff ff       	call   80102e60 <end_op>
  return 0;
80105a98:	83 c4 10             	add    $0x10,%esp
80105a9b:	31 c0                	xor    %eax,%eax
}
80105a9d:	c9                   	leave
80105a9e:	c3                   	ret
80105a9f:	90                   	nop
    end_op();
80105aa0:	e8 bb d3 ff ff       	call   80102e60 <end_op>
    return -1;
80105aa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aaa:	c9                   	leave
80105aab:	c3                   	ret
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_chdir>:

int
sys_chdir(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	56                   	push   %esi
80105ab4:	53                   	push   %ebx
80105ab5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ab8:	e8 63 df ff ff       	call   80103a20 <myproc>
80105abd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105abf:	e8 2c d3 ff ff       	call   80102df0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ac4:	83 ec 08             	sub    $0x8,%esp
80105ac7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 de f5 ff ff       	call   801050b0 <argstr>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 77                	js     80105b50 <sys_chdir+0xa0>
80105ad9:	83 ec 0c             	sub    $0xc,%esp
80105adc:	ff 75 f4             	push   -0xc(%ebp)
80105adf:	e8 0c c6 ff ff       	call   801020f0 <namei>
80105ae4:	83 c4 10             	add    $0x10,%esp
80105ae7:	89 c3                	mov    %eax,%ebx
80105ae9:	85 c0                	test   %eax,%eax
80105aeb:	74 63                	je     80105b50 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105aed:	83 ec 0c             	sub    $0xc,%esp
80105af0:	50                   	push   %eax
80105af1:	e8 1a bd ff ff       	call   80101810 <ilock>
  if(ip->type != T_DIR){
80105af6:	83 c4 10             	add    $0x10,%esp
80105af9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105afe:	75 30                	jne    80105b30 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	53                   	push   %ebx
80105b04:	e8 e7 bd ff ff       	call   801018f0 <iunlock>
  iput(curproc->cwd);
80105b09:	58                   	pop    %eax
80105b0a:	ff 76 68             	push   0x68(%esi)
80105b0d:	e8 2e be ff ff       	call   80101940 <iput>
  end_op();
80105b12:	e8 49 d3 ff ff       	call   80102e60 <end_op>
  curproc->cwd = ip;
80105b17:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	31 c0                	xor    %eax,%eax
}
80105b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b22:	5b                   	pop    %ebx
80105b23:	5e                   	pop    %esi
80105b24:	5d                   	pop    %ebp
80105b25:	c3                   	ret
80105b26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b2d:	00 
80105b2e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	53                   	push   %ebx
80105b34:	e8 67 bf ff ff       	call   80101aa0 <iunlockput>
    end_op();
80105b39:	e8 22 d3 ff ff       	call   80102e60 <end_op>
    return -1;
80105b3e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105b41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b46:	eb d7                	jmp    80105b1f <sys_chdir+0x6f>
80105b48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b4f:	00 
    end_op();
80105b50:	e8 0b d3 ff ff       	call   80102e60 <end_op>
    return -1;
80105b55:	eb ea                	jmp    80105b41 <sys_chdir+0x91>
80105b57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b5e:	00 
80105b5f:	90                   	nop

80105b60 <sys_exec>:

int
sys_exec(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b65:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b6b:	53                   	push   %ebx
80105b6c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b72:	50                   	push   %eax
80105b73:	6a 00                	push   $0x0
80105b75:	e8 36 f5 ff ff       	call   801050b0 <argstr>
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	0f 88 87 00 00 00    	js     80105c0c <sys_exec+0xac>
80105b85:	83 ec 08             	sub    $0x8,%esp
80105b88:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b8e:	50                   	push   %eax
80105b8f:	6a 01                	push   $0x1
80105b91:	e8 5a f4 ff ff       	call   80104ff0 <argint>
80105b96:	83 c4 10             	add    $0x10,%esp
80105b99:	85 c0                	test   %eax,%eax
80105b9b:	78 6f                	js     80105c0c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b9d:	83 ec 04             	sub    $0x4,%esp
80105ba0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105ba6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105ba8:	68 80 00 00 00       	push   $0x80
80105bad:	6a 00                	push   $0x0
80105baf:	56                   	push   %esi
80105bb0:	e8 8b f1 ff ff       	call   80104d40 <memset>
80105bb5:	83 c4 10             	add    $0x10,%esp
80105bb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bbf:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bc0:	83 ec 08             	sub    $0x8,%esp
80105bc3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105bc9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105bd0:	50                   	push   %eax
80105bd1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105bd7:	01 f8                	add    %edi,%eax
80105bd9:	50                   	push   %eax
80105bda:	e8 81 f3 ff ff       	call   80104f60 <fetchint>
80105bdf:	83 c4 10             	add    $0x10,%esp
80105be2:	85 c0                	test   %eax,%eax
80105be4:	78 26                	js     80105c0c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105be6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bec:	85 c0                	test   %eax,%eax
80105bee:	74 30                	je     80105c20 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bf0:	83 ec 08             	sub    $0x8,%esp
80105bf3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105bf6:	52                   	push   %edx
80105bf7:	50                   	push   %eax
80105bf8:	e8 a3 f3 ff ff       	call   80104fa0 <fetchstr>
80105bfd:	83 c4 10             	add    $0x10,%esp
80105c00:	85 c0                	test   %eax,%eax
80105c02:	78 08                	js     80105c0c <sys_exec+0xac>
  for(i=0;; i++){
80105c04:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105c07:	83 fb 20             	cmp    $0x20,%ebx
80105c0a:	75 b4                	jne    80105bc0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c14:	5b                   	pop    %ebx
80105c15:	5e                   	pop    %esi
80105c16:	5f                   	pop    %edi
80105c17:	5d                   	pop    %ebp
80105c18:	c3                   	ret
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105c20:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c27:	00 00 00 00 
  return exec(path, argv);
80105c2b:	83 ec 08             	sub    $0x8,%esp
80105c2e:	56                   	push   %esi
80105c2f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105c35:	e8 d6 ae ff ff       	call   80100b10 <exec>
80105c3a:	83 c4 10             	add    $0x10,%esp
}
80105c3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c40:	5b                   	pop    %ebx
80105c41:	5e                   	pop    %esi
80105c42:	5f                   	pop    %edi
80105c43:	5d                   	pop    %ebp
80105c44:	c3                   	ret
80105c45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c4c:	00 
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi

80105c50 <sys_pipe>:

int
sys_pipe(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	57                   	push   %edi
80105c54:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c55:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c58:	53                   	push   %ebx
80105c59:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c5c:	6a 08                	push   $0x8
80105c5e:	50                   	push   %eax
80105c5f:	6a 00                	push   $0x0
80105c61:	e8 da f3 ff ff       	call   80105040 <argptr>
80105c66:	83 c4 10             	add    $0x10,%esp
80105c69:	85 c0                	test   %eax,%eax
80105c6b:	0f 88 8b 00 00 00    	js     80105cfc <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c71:	83 ec 08             	sub    $0x8,%esp
80105c74:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c77:	50                   	push   %eax
80105c78:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c7b:	50                   	push   %eax
80105c7c:	e8 3f d8 ff ff       	call   801034c0 <pipealloc>
80105c81:	83 c4 10             	add    $0x10,%esp
80105c84:	85 c0                	test   %eax,%eax
80105c86:	78 74                	js     80105cfc <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c88:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c8b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c8d:	e8 8e dd ff ff       	call   80103a20 <myproc>
    if(curproc->ofile[fd] == 0){
80105c92:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c96:	85 f6                	test   %esi,%esi
80105c98:	74 16                	je     80105cb0 <sys_pipe+0x60>
80105c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105ca0:	83 c3 01             	add    $0x1,%ebx
80105ca3:	83 fb 10             	cmp    $0x10,%ebx
80105ca6:	74 3d                	je     80105ce5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105ca8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105cac:	85 f6                	test   %esi,%esi
80105cae:	75 f0                	jne    80105ca0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105cb0:	8d 73 08             	lea    0x8(%ebx),%esi
80105cb3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105cba:	e8 61 dd ff ff       	call   80103a20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cbf:	31 d2                	xor    %edx,%edx
80105cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105cc8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105ccc:	85 c9                	test   %ecx,%ecx
80105cce:	74 38                	je     80105d08 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105cd0:	83 c2 01             	add    $0x1,%edx
80105cd3:	83 fa 10             	cmp    $0x10,%edx
80105cd6:	75 f0                	jne    80105cc8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105cd8:	e8 43 dd ff ff       	call   80103a20 <myproc>
80105cdd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ce4:	00 
    fileclose(rf);
80105ce5:	83 ec 0c             	sub    $0xc,%esp
80105ce8:	ff 75 e0             	push   -0x20(%ebp)
80105ceb:	e8 90 b2 ff ff       	call   80100f80 <fileclose>
    fileclose(wf);
80105cf0:	58                   	pop    %eax
80105cf1:	ff 75 e4             	push   -0x1c(%ebp)
80105cf4:	e8 87 b2 ff ff       	call   80100f80 <fileclose>
    return -1;
80105cf9:	83 c4 10             	add    $0x10,%esp
    return -1;
80105cfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d01:	eb 16                	jmp    80105d19 <sys_pipe+0xc9>
80105d03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105d08:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105d0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d0f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d11:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d14:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d17:	31 c0                	xor    %eax,%eax
}
80105d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d1c:	5b                   	pop    %ebx
80105d1d:	5e                   	pop    %esi
80105d1e:	5f                   	pop    %edi
80105d1f:	5d                   	pop    %ebp
80105d20:	c3                   	ret
80105d21:	66 90                	xchg   %ax,%ax
80105d23:	66 90                	xchg   %ax,%ax
80105d25:	66 90                	xchg   %ax,%ax
80105d27:	66 90                	xchg   %ax,%ax
80105d29:	66 90                	xchg   %ax,%ax
80105d2b:	66 90                	xchg   %ax,%ax
80105d2d:	66 90                	xchg   %ax,%ax
80105d2f:	90                   	nop

80105d30 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105d30:	e9 8b de ff ff       	jmp    80103bc0 <fork>
80105d35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d3c:	00 
80105d3d:	8d 76 00             	lea    0x0(%esi),%esi

80105d40 <sys_exit>:
}

int
sys_exit(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d46:	e8 e5 e0 ff ff       	call   80103e30 <exit>
  return 0;  
}
80105d4b:	31 c0                	xor    %eax,%eax
80105d4d:	c9                   	leave
80105d4e:	c3                   	ret
80105d4f:	90                   	nop

80105d50 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105d50:	e9 0b e2 ff ff       	jmp    80103f60 <wait>
80105d55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d5c:	00 
80105d5d:	8d 76 00             	lea    0x0(%esi),%esi

80105d60 <sys_kill>:
}

int
sys_kill(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d69:	50                   	push   %eax
80105d6a:	6a 00                	push   $0x0
80105d6c:	e8 7f f2 ff ff       	call   80104ff0 <argint>
80105d71:	83 c4 10             	add    $0x10,%esp
80105d74:	85 c0                	test   %eax,%eax
80105d76:	78 18                	js     80105d90 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d78:	83 ec 0c             	sub    $0xc,%esp
80105d7b:	ff 75 f4             	push   -0xc(%ebp)
80105d7e:	e8 8d e4 ff ff       	call   80104210 <kill>
80105d83:	83 c4 10             	add    $0x10,%esp
}
80105d86:	c9                   	leave
80105d87:	c3                   	ret
80105d88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d8f:	00 
80105d90:	c9                   	leave
    return -1;
80105d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d96:	c3                   	ret
80105d97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d9e:	00 
80105d9f:	90                   	nop

80105da0 <sys_getpid>:

int
sys_getpid(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105da6:	e8 75 dc ff ff       	call   80103a20 <myproc>
80105dab:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dae:	c9                   	leave
80105daf:	c3                   	ret

80105db0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105db4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105db7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dba:	50                   	push   %eax
80105dbb:	6a 00                	push   $0x0
80105dbd:	e8 2e f2 ff ff       	call   80104ff0 <argint>
80105dc2:	83 c4 10             	add    $0x10,%esp
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	78 27                	js     80105df0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105dc9:	e8 52 dc ff ff       	call   80103a20 <myproc>
  if(growproc(n) < 0)
80105dce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105dd1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105dd3:	ff 75 f4             	push   -0xc(%ebp)
80105dd6:	e8 65 dd ff ff       	call   80103b40 <growproc>
80105ddb:	83 c4 10             	add    $0x10,%esp
80105dde:	85 c0                	test   %eax,%eax
80105de0:	78 0e                	js     80105df0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105de2:	89 d8                	mov    %ebx,%eax
80105de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105de7:	c9                   	leave
80105de8:	c3                   	ret
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105df0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105df5:	eb eb                	jmp    80105de2 <sys_sbrk+0x32>
80105df7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dfe:	00 
80105dff:	90                   	nop

80105e00 <sys_sleep>:

int
sys_sleep(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e0a:	50                   	push   %eax
80105e0b:	6a 00                	push   $0x0
80105e0d:	e8 de f1 ff ff       	call   80104ff0 <argint>
80105e12:	83 c4 10             	add    $0x10,%esp
80105e15:	85 c0                	test   %eax,%eax
80105e17:	78 64                	js     80105e7d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105e19:	83 ec 0c             	sub    $0xc,%esp
80105e1c:	68 a0 4f 11 80       	push   $0x80114fa0
80105e21:	e8 1a ee ff ff       	call   80104c40 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105e29:	8b 1d 80 4f 11 80    	mov    0x80114f80,%ebx
  while(ticks - ticks0 < n){
80105e2f:	83 c4 10             	add    $0x10,%esp
80105e32:	85 d2                	test   %edx,%edx
80105e34:	75 2b                	jne    80105e61 <sys_sleep+0x61>
80105e36:	eb 58                	jmp    80105e90 <sys_sleep+0x90>
80105e38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e3f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e40:	83 ec 08             	sub    $0x8,%esp
80105e43:	68 a0 4f 11 80       	push   $0x80114fa0
80105e48:	68 80 4f 11 80       	push   $0x80114f80
80105e4d:	e8 9e e2 ff ff       	call   801040f0 <sleep>
  while(ticks - ticks0 < n){
80105e52:	a1 80 4f 11 80       	mov    0x80114f80,%eax
80105e57:	83 c4 10             	add    $0x10,%esp
80105e5a:	29 d8                	sub    %ebx,%eax
80105e5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e5f:	73 2f                	jae    80105e90 <sys_sleep+0x90>
    if(myproc()->killed){
80105e61:	e8 ba db ff ff       	call   80103a20 <myproc>
80105e66:	8b 40 24             	mov    0x24(%eax),%eax
80105e69:	85 c0                	test   %eax,%eax
80105e6b:	74 d3                	je     80105e40 <sys_sleep+0x40>
      release(&tickslock);
80105e6d:	83 ec 0c             	sub    $0xc,%esp
80105e70:	68 a0 4f 11 80       	push   $0x80114fa0
80105e75:	e8 66 ed ff ff       	call   80104be0 <release>
      return -1;
80105e7a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105e7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e85:	c9                   	leave
80105e86:	c3                   	ret
80105e87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e8e:	00 
80105e8f:	90                   	nop
  release(&tickslock);
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	68 a0 4f 11 80       	push   $0x80114fa0
80105e98:	e8 43 ed ff ff       	call   80104be0 <release>
}
80105e9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105ea0:	83 c4 10             	add    $0x10,%esp
80105ea3:	31 c0                	xor    %eax,%eax
}
80105ea5:	c9                   	leave
80105ea6:	c3                   	ret
80105ea7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105eae:	00 
80105eaf:	90                   	nop

80105eb0 <sys_uptime>:



int
sys_uptime(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	53                   	push   %ebx
80105eb4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105eb7:	68 a0 4f 11 80       	push   $0x80114fa0
80105ebc:	e8 7f ed ff ff       	call   80104c40 <acquire>
  xticks = ticks;
80105ec1:	8b 1d 80 4f 11 80    	mov    0x80114f80,%ebx
  release(&tickslock);
80105ec7:	c7 04 24 a0 4f 11 80 	movl   $0x80114fa0,(%esp)
80105ece:	e8 0d ed ff ff       	call   80104be0 <release>
  return xticks;
}
80105ed3:	89 d8                	mov    %ebx,%eax
80105ed5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ed8:	c9                   	leave
80105ed9:	c3                   	ret

80105eda <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105eda:	1e                   	push   %ds
  pushl %es
80105edb:	06                   	push   %es
  pushl %fs
80105edc:	0f a0                	push   %fs
  pushl %gs
80105ede:	0f a8                	push   %gs
  pushal
80105ee0:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ee1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ee5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ee7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ee9:	54                   	push   %esp
  call trap
80105eea:	e8 c1 00 00 00       	call   80105fb0 <trap>
  addl $4, %esp
80105eef:	83 c4 04             	add    $0x4,%esp

80105ef2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ef2:	61                   	popa
  popl %gs
80105ef3:	0f a9                	pop    %gs
  popl %fs
80105ef5:	0f a1                	pop    %fs
  popl %es
80105ef7:	07                   	pop    %es
  popl %ds
80105ef8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ef9:	83 c4 08             	add    $0x8,%esp
  iret
80105efc:	cf                   	iret
80105efd:	66 90                	xchg   %ax,%ax
80105eff:	90                   	nop

80105f00 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f00:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f01:	31 c0                	xor    %eax,%eax
{
80105f03:	89 e5                	mov    %esp,%ebp
80105f05:	83 ec 08             	sub    $0x8,%esp
80105f08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f0f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f10:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105f17:	c7 04 c5 e2 4f 11 80 	movl   $0x8e000008,-0x7feeb01e(,%eax,8)
80105f1e:	08 00 00 8e 
80105f22:	66 89 14 c5 e0 4f 11 	mov    %dx,-0x7feeb020(,%eax,8)
80105f29:	80 
80105f2a:	c1 ea 10             	shr    $0x10,%edx
80105f2d:	66 89 14 c5 e6 4f 11 	mov    %dx,-0x7feeb01a(,%eax,8)
80105f34:	80 
  for(i = 0; i < 256; i++)
80105f35:	83 c0 01             	add    $0x1,%eax
80105f38:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f3d:	75 d1                	jne    80105f10 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105f3f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f42:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105f47:	c7 05 e2 51 11 80 08 	movl   $0xef000008,0x801151e2
80105f4e:	00 00 ef 
  initlock(&tickslock, "time");
80105f51:	68 5a 87 10 80       	push   $0x8010875a
80105f56:	68 a0 4f 11 80       	push   $0x80114fa0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f5b:	66 a3 e0 51 11 80    	mov    %ax,0x801151e0
80105f61:	c1 e8 10             	shr    $0x10,%eax
80105f64:	66 a3 e6 51 11 80    	mov    %ax,0x801151e6
  initlock(&tickslock, "time");
80105f6a:	e8 e1 ea ff ff       	call   80104a50 <initlock>
}
80105f6f:	83 c4 10             	add    $0x10,%esp
80105f72:	c9                   	leave
80105f73:	c3                   	ret
80105f74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f7b:	00 
80105f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f80 <idtinit>:

void
idtinit(void)
{
80105f80:	55                   	push   %ebp
  pd[0] = size-1;
80105f81:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f86:	89 e5                	mov    %esp,%ebp
80105f88:	83 ec 10             	sub    $0x10,%esp
80105f8b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f8f:	b8 e0 4f 11 80       	mov    $0x80114fe0,%eax
80105f94:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f98:	c1 e8 10             	shr    $0x10,%eax
80105f9b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f9f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fa2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105fa5:	c9                   	leave
80105fa6:	c3                   	ret
80105fa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105fae:	00 
80105faf:	90                   	nop

80105fb0 <trap>:


void
trap(struct trapframe *tf)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	57                   	push   %edi
80105fb4:	56                   	push   %esi
80105fb5:	53                   	push   %ebx
80105fb6:	83 ec 1c             	sub    $0x1c,%esp
80105fb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105fbc:	8b 43 30             	mov    0x30(%ebx),%eax
80105fbf:	83 f8 40             	cmp    $0x40,%eax
80105fc2:	0f 84 20 01 00 00    	je     801060e8 <trap+0x138>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105fc8:	83 e8 0e             	sub    $0xe,%eax
80105fcb:	83 f8 31             	cmp    $0x31,%eax
80105fce:	0f 87 7c 00 00 00    	ja     80106050 <trap+0xa0>
80105fd4:	ff 24 85 d8 8c 10 80 	jmp    *-0x7fef7328(,%eax,4)
80105fdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

  case T_IRQ0 + IRQ_IDE+1:
    
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105fe0:	e8 8b c8 ff ff       	call   80102870 <kbdintr>
    lapiceoi();
80105fe5:	e8 b6 c9 ff ff       	call   801029a0 <lapiceoi>
  }

  
  
  
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fea:	e8 31 da ff ff       	call   80103a20 <myproc>
80105fef:	85 c0                	test   %eax,%eax
80105ff1:	74 1a                	je     8010600d <trap+0x5d>
80105ff3:	e8 28 da ff ff       	call   80103a20 <myproc>
80105ff8:	8b 50 24             	mov    0x24(%eax),%edx
80105ffb:	85 d2                	test   %edx,%edx
80105ffd:	74 0e                	je     8010600d <trap+0x5d>
80105fff:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106003:	f7 d0                	not    %eax
80106005:	a8 03                	test   $0x3,%al
80106007:	0f 84 33 02 00 00    	je     80106240 <trap+0x290>
    exit();

  
  
  if(myproc() && myproc()->state == RUNNING &&
8010600d:	e8 0e da ff ff       	call   80103a20 <myproc>
80106012:	85 c0                	test   %eax,%eax
80106014:	74 0f                	je     80106025 <trap+0x75>
80106016:	e8 05 da ff ff       	call   80103a20 <myproc>
8010601b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010601f:	0f 84 ab 00 00 00    	je     801060d0 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106025:	e8 f6 d9 ff ff       	call   80103a20 <myproc>
8010602a:	85 c0                	test   %eax,%eax
8010602c:	74 1a                	je     80106048 <trap+0x98>
8010602e:	e8 ed d9 ff ff       	call   80103a20 <myproc>
80106033:	8b 40 24             	mov    0x24(%eax),%eax
80106036:	85 c0                	test   %eax,%eax
80106038:	74 0e                	je     80106048 <trap+0x98>
8010603a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010603e:	f7 d0                	not    %eax
80106040:	a8 03                	test   $0x3,%al
80106042:	0f 84 cd 00 00 00    	je     80106115 <trap+0x165>
    exit();
}
80106048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010604b:	5b                   	pop    %ebx
8010604c:	5e                   	pop    %esi
8010604d:	5f                   	pop    %edi
8010604e:	5d                   	pop    %ebp
8010604f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80106050:	e8 cb d9 ff ff       	call   80103a20 <myproc>
80106055:	8b 7b 38             	mov    0x38(%ebx),%edi
80106058:	85 c0                	test   %eax,%eax
8010605a:	0f 84 fa 01 00 00    	je     8010625a <trap+0x2aa>
80106060:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106064:	0f 84 f0 01 00 00    	je     8010625a <trap+0x2aa>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010606a:	0f 20 d1             	mov    %cr2,%ecx
8010606d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106070:	e8 8b d9 ff ff       	call   80103a00 <cpuid>
80106075:	8b 73 30             	mov    0x30(%ebx),%esi
80106078:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010607b:	8b 43 34             	mov    0x34(%ebx),%eax
8010607e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106081:	e8 9a d9 ff ff       	call   80103a20 <myproc>
80106086:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106089:	e8 92 d9 ff ff       	call   80103a20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010608e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106091:	51                   	push   %ecx
80106092:	57                   	push   %edi
80106093:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106096:	52                   	push   %edx
80106097:	ff 75 e4             	push   -0x1c(%ebp)
8010609a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010609b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010609e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060a1:	56                   	push   %esi
801060a2:	ff 70 10             	push   0x10(%eax)
801060a5:	68 80 89 10 80       	push   $0x80108980
801060aa:	e8 01 a6 ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
801060af:	83 c4 20             	add    $0x20,%esp
801060b2:	e8 69 d9 ff ff       	call   80103a20 <myproc>
801060b7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060be:	e8 5d d9 ff ff       	call   80103a20 <myproc>
801060c3:	85 c0                	test   %eax,%eax
801060c5:	0f 85 28 ff ff ff    	jne    80105ff3 <trap+0x43>
801060cb:	e9 3d ff ff ff       	jmp    8010600d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
801060d0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801060d4:	0f 85 4b ff ff ff    	jne    80106025 <trap+0x75>
    yield();
801060da:	e8 c1 df ff ff       	call   801040a0 <yield>
801060df:	e9 41 ff ff ff       	jmp    80106025 <trap+0x75>
801060e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801060e8:	e8 33 d9 ff ff       	call   80103a20 <myproc>
801060ed:	8b 70 24             	mov    0x24(%eax),%esi
801060f0:	85 f6                	test   %esi,%esi
801060f2:	0f 85 58 01 00 00    	jne    80106250 <trap+0x2a0>
    myproc()->tf = tf;
801060f8:	e8 23 d9 ff ff       	call   80103a20 <myproc>
801060fd:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106100:	e8 2b f0 ff ff       	call   80105130 <syscall>
    if(myproc()->killed)
80106105:	e8 16 d9 ff ff       	call   80103a20 <myproc>
8010610a:	8b 48 24             	mov    0x24(%eax),%ecx
8010610d:	85 c9                	test   %ecx,%ecx
8010610f:	0f 84 33 ff ff ff    	je     80106048 <trap+0x98>
}
80106115:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106118:	5b                   	pop    %ebx
80106119:	5e                   	pop    %esi
8010611a:	5f                   	pop    %edi
8010611b:	5d                   	pop    %ebp
      exit();
8010611c:	e9 0f dd ff ff       	jmp    80103e30 <exit>
80106121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106128:	8b 7b 38             	mov    0x38(%ebx),%edi
8010612b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010612f:	e8 cc d8 ff ff       	call   80103a00 <cpuid>
80106134:	57                   	push   %edi
80106135:	56                   	push   %esi
80106136:	50                   	push   %eax
80106137:	68 28 89 10 80       	push   $0x80108928
8010613c:	e8 6f a5 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106141:	e8 5a c8 ff ff       	call   801029a0 <lapiceoi>
    break;
80106146:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106149:	e8 d2 d8 ff ff       	call   80103a20 <myproc>
8010614e:	85 c0                	test   %eax,%eax
80106150:	0f 85 9d fe ff ff    	jne    80105ff3 <trap+0x43>
80106156:	e9 b2 fe ff ff       	jmp    8010600d <trap+0x5d>
8010615b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartintr();
80106160:	e8 ab 02 00 00       	call   80106410 <uartintr>
    lapiceoi();
80106165:	e8 36 c8 ff ff       	call   801029a0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010616a:	e8 b1 d8 ff ff       	call   80103a20 <myproc>
8010616f:	85 c0                	test   %eax,%eax
80106171:	0f 85 7c fe ff ff    	jne    80105ff3 <trap+0x43>
80106177:	e9 91 fe ff ff       	jmp    8010600d <trap+0x5d>
8010617c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106180:	e8 7b d8 ff ff       	call   80103a00 <cpuid>
80106185:	85 c0                	test   %eax,%eax
80106187:	0f 85 58 fe ff ff    	jne    80105fe5 <trap+0x35>
      acquire(&tickslock);
8010618d:	83 ec 0c             	sub    $0xc,%esp
80106190:	68 a0 4f 11 80       	push   $0x80114fa0
80106195:	e8 a6 ea ff ff       	call   80104c40 <acquire>
      ticks++;
8010619a:	83 05 80 4f 11 80 01 	addl   $0x1,0x80114f80
      wakeup(&ticks);
801061a1:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
801061a8:	e8 03 e0 ff ff       	call   801041b0 <wakeup>
      release(&tickslock);
801061ad:	c7 04 24 a0 4f 11 80 	movl   $0x80114fa0,(%esp)
801061b4:	e8 27 ea ff ff       	call   80104be0 <release>
801061b9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801061bc:	e9 24 fe ff ff       	jmp    80105fe5 <trap+0x35>
801061c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801061c8:	e8 d3 c0 ff ff       	call   801022a0 <ideintr>
    lapiceoi();
801061cd:	e8 ce c7 ff ff       	call   801029a0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061d2:	e8 49 d8 ff ff       	call   80103a20 <myproc>
801061d7:	85 c0                	test   %eax,%eax
801061d9:	0f 85 14 fe ff ff    	jne    80105ff3 <trap+0x43>
801061df:	e9 29 fe ff ff       	jmp    8010600d <trap+0x5d>
801061e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() == 0 || (tf->cs & 3) == 0) {
801061e8:	e8 33 d8 ff ff       	call   80103a20 <myproc>
801061ed:	0f 20 d7             	mov    %cr2,%edi
      pte_t *pte = walkpgdir(myproc()->pgdir, (char *)va, 0);
801061f0:	e8 2b d8 ff ff       	call   80103a20 <myproc>
      uint va = PGROUNDDOWN(rcr2());
801061f5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      pte_t *pte = walkpgdir(myproc()->pgdir, (char *)va, 0);
801061fb:	83 ec 04             	sub    $0x4,%esp
801061fe:	6a 00                	push   $0x0
80106200:	57                   	push   %edi
80106201:	ff 70 04             	push   0x4(%eax)
80106204:	e8 e7 0e 00 00       	call   801070f0 <walkpgdir>
      if (*pte & PTE_P)
80106209:	83 c4 10             	add    $0x10,%esp
      pte_t *pte = walkpgdir(myproc()->pgdir, (char *)va, 0);
8010620c:	89 c6                	mov    %eax,%esi
      if (*pte & PTE_P)
8010620e:	f6 00 01             	testb  $0x1,(%eax)
80106211:	0f 85 9b fe ff ff    	jne    801060b2 <trap+0x102>
      else if (swapInAPage(myproc(), pte, va) < 0)
80106217:	e8 04 d8 ff ff       	call   80103a20 <myproc>
8010621c:	83 ec 04             	sub    $0x4,%esp
8010621f:	57                   	push   %edi
80106220:	56                   	push   %esi
80106221:	50                   	push   %eax
80106222:	e8 c9 1f 00 00       	call   801081f0 <swapInAPage>
80106227:	83 c4 10             	add    $0x10,%esp
8010622a:	85 c0                	test   %eax,%eax
8010622c:	0f 89 b8 fd ff ff    	jns    80105fea <trap+0x3a>
80106232:	e9 7b fe ff ff       	jmp    801060b2 <trap+0x102>
80106237:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010623e:	00 
8010623f:	90                   	nop
    exit();
80106240:	e8 eb db ff ff       	call   80103e30 <exit>
80106245:	e9 c3 fd ff ff       	jmp    8010600d <trap+0x5d>
8010624a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106250:	e8 db db ff ff       	call   80103e30 <exit>
80106255:	e9 9e fe ff ff       	jmp    801060f8 <trap+0x148>
8010625a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010625d:	e8 9e d7 ff ff       	call   80103a00 <cpuid>
80106262:	83 ec 0c             	sub    $0xc,%esp
80106265:	56                   	push   %esi
80106266:	57                   	push   %edi
80106267:	50                   	push   %eax
80106268:	ff 73 30             	push   0x30(%ebx)
8010626b:	68 4c 89 10 80       	push   $0x8010894c
80106270:	e8 3b a4 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106275:	83 c4 14             	add    $0x14,%esp
80106278:	68 5f 87 10 80       	push   $0x8010875f
8010627d:	e8 fe a0 ff ff       	call   80100380 <panic>
80106282:	66 90                	xchg   %ax,%ax
80106284:	66 90                	xchg   %ax,%ax
80106286:	66 90                	xchg   %ax,%ax
80106288:	66 90                	xchg   %ax,%ax
8010628a:	66 90                	xchg   %ax,%ax
8010628c:	66 90                	xchg   %ax,%ax
8010628e:	66 90                	xchg   %ax,%ax

80106290 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106290:	a1 e0 57 11 80       	mov    0x801157e0,%eax
80106295:	85 c0                	test   %eax,%eax
80106297:	74 17                	je     801062b0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106299:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010629e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010629f:	a8 01                	test   $0x1,%al
801062a1:	74 0d                	je     801062b0 <uartgetc+0x20>
801062a3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062a8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801062a9:	0f b6 c0             	movzbl %al,%eax
801062ac:	c3                   	ret
801062ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801062b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062b5:	c3                   	ret
801062b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801062bd:	00 
801062be:	66 90                	xchg   %ax,%ax

801062c0 <uartinit>:
{
801062c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062c1:	31 c9                	xor    %ecx,%ecx
801062c3:	89 c8                	mov    %ecx,%eax
801062c5:	89 e5                	mov    %esp,%ebp
801062c7:	57                   	push   %edi
801062c8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801062cd:	56                   	push   %esi
801062ce:	89 fa                	mov    %edi,%edx
801062d0:	53                   	push   %ebx
801062d1:	83 ec 1c             	sub    $0x1c,%esp
801062d4:	ee                   	out    %al,(%dx)
801062d5:	be fb 03 00 00       	mov    $0x3fb,%esi
801062da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062df:	89 f2                	mov    %esi,%edx
801062e1:	ee                   	out    %al,(%dx)
801062e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801062e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062ec:	ee                   	out    %al,(%dx)
801062ed:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801062f2:	89 c8                	mov    %ecx,%eax
801062f4:	89 da                	mov    %ebx,%edx
801062f6:	ee                   	out    %al,(%dx)
801062f7:	b8 03 00 00 00       	mov    $0x3,%eax
801062fc:	89 f2                	mov    %esi,%edx
801062fe:	ee                   	out    %al,(%dx)
801062ff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106304:	89 c8                	mov    %ecx,%eax
80106306:	ee                   	out    %al,(%dx)
80106307:	b8 01 00 00 00       	mov    $0x1,%eax
8010630c:	89 da                	mov    %ebx,%edx
8010630e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010630f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106314:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106315:	3c ff                	cmp    $0xff,%al
80106317:	0f 84 7c 00 00 00    	je     80106399 <uartinit+0xd9>
  uart = 1;
8010631d:	c7 05 e0 57 11 80 01 	movl   $0x1,0x801157e0
80106324:	00 00 00 
80106327:	89 fa                	mov    %edi,%edx
80106329:	ec                   	in     (%dx),%al
8010632a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010632f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106330:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106333:	bf 64 87 10 80       	mov    $0x80108764,%edi
80106338:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010633d:	6a 00                	push   $0x0
8010633f:	6a 04                	push   $0x4
80106341:	e8 8a c1 ff ff       	call   801024d0 <ioapicenable>
80106346:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106349:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
8010634d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106350:	a1 e0 57 11 80       	mov    0x801157e0,%eax
80106355:	85 c0                	test   %eax,%eax
80106357:	74 32                	je     8010638b <uartinit+0xcb>
80106359:	89 f2                	mov    %esi,%edx
8010635b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010635c:	a8 20                	test   $0x20,%al
8010635e:	75 21                	jne    80106381 <uartinit+0xc1>
80106360:	bb 80 00 00 00       	mov    $0x80,%ebx
80106365:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106368:	83 ec 0c             	sub    $0xc,%esp
8010636b:	6a 0a                	push   $0xa
8010636d:	e8 4e c6 ff ff       	call   801029c0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106372:	83 c4 10             	add    $0x10,%esp
80106375:	83 eb 01             	sub    $0x1,%ebx
80106378:	74 07                	je     80106381 <uartinit+0xc1>
8010637a:	89 f2                	mov    %esi,%edx
8010637c:	ec                   	in     (%dx),%al
8010637d:	a8 20                	test   $0x20,%al
8010637f:	74 e7                	je     80106368 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106381:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106386:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010638a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010638b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010638f:	83 c7 01             	add    $0x1,%edi
80106392:	88 45 e7             	mov    %al,-0x19(%ebp)
80106395:	84 c0                	test   %al,%al
80106397:	75 b7                	jne    80106350 <uartinit+0x90>
}
80106399:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010639c:	5b                   	pop    %ebx
8010639d:	5e                   	pop    %esi
8010639e:	5f                   	pop    %edi
8010639f:	5d                   	pop    %ebp
801063a0:	c3                   	ret
801063a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801063a8:	00 
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063b0 <uartputc>:
  if(!uart)
801063b0:	a1 e0 57 11 80       	mov    0x801157e0,%eax
801063b5:	85 c0                	test   %eax,%eax
801063b7:	74 4f                	je     80106408 <uartputc+0x58>
{
801063b9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063ba:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063bf:	89 e5                	mov    %esp,%ebp
801063c1:	56                   	push   %esi
801063c2:	53                   	push   %ebx
801063c3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063c4:	a8 20                	test   $0x20,%al
801063c6:	75 29                	jne    801063f1 <uartputc+0x41>
801063c8:	bb 80 00 00 00       	mov    $0x80,%ebx
801063cd:	be fd 03 00 00       	mov    $0x3fd,%esi
801063d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801063d8:	83 ec 0c             	sub    $0xc,%esp
801063db:	6a 0a                	push   $0xa
801063dd:	e8 de c5 ff ff       	call   801029c0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063e2:	83 c4 10             	add    $0x10,%esp
801063e5:	83 eb 01             	sub    $0x1,%ebx
801063e8:	74 07                	je     801063f1 <uartputc+0x41>
801063ea:	89 f2                	mov    %esi,%edx
801063ec:	ec                   	in     (%dx),%al
801063ed:	a8 20                	test   $0x20,%al
801063ef:	74 e7                	je     801063d8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063f1:	8b 45 08             	mov    0x8(%ebp),%eax
801063f4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063f9:	ee                   	out    %al,(%dx)
}
801063fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063fd:	5b                   	pop    %ebx
801063fe:	5e                   	pop    %esi
801063ff:	5d                   	pop    %ebp
80106400:	c3                   	ret
80106401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106408:	c3                   	ret
80106409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106410 <uartintr>:

void
uartintr(void)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106416:	68 90 62 10 80       	push   $0x80106290
8010641b:	e8 80 a4 ff ff       	call   801008a0 <consoleintr>
}
80106420:	83 c4 10             	add    $0x10,%esp
80106423:	c9                   	leave
80106424:	c3                   	ret

80106425 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $0
80106427:	6a 00                	push   $0x0
  jmp alltraps
80106429:	e9 ac fa ff ff       	jmp    80105eda <alltraps>

8010642e <vector1>:
.globl vector1
vector1:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $1
80106430:	6a 01                	push   $0x1
  jmp alltraps
80106432:	e9 a3 fa ff ff       	jmp    80105eda <alltraps>

80106437 <vector2>:
.globl vector2
vector2:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $2
80106439:	6a 02                	push   $0x2
  jmp alltraps
8010643b:	e9 9a fa ff ff       	jmp    80105eda <alltraps>

80106440 <vector3>:
.globl vector3
vector3:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $3
80106442:	6a 03                	push   $0x3
  jmp alltraps
80106444:	e9 91 fa ff ff       	jmp    80105eda <alltraps>

80106449 <vector4>:
.globl vector4
vector4:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $4
8010644b:	6a 04                	push   $0x4
  jmp alltraps
8010644d:	e9 88 fa ff ff       	jmp    80105eda <alltraps>

80106452 <vector5>:
.globl vector5
vector5:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $5
80106454:	6a 05                	push   $0x5
  jmp alltraps
80106456:	e9 7f fa ff ff       	jmp    80105eda <alltraps>

8010645b <vector6>:
.globl vector6
vector6:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $6
8010645d:	6a 06                	push   $0x6
  jmp alltraps
8010645f:	e9 76 fa ff ff       	jmp    80105eda <alltraps>

80106464 <vector7>:
.globl vector7
vector7:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $7
80106466:	6a 07                	push   $0x7
  jmp alltraps
80106468:	e9 6d fa ff ff       	jmp    80105eda <alltraps>

8010646d <vector8>:
.globl vector8
vector8:
  pushl $8
8010646d:	6a 08                	push   $0x8
  jmp alltraps
8010646f:	e9 66 fa ff ff       	jmp    80105eda <alltraps>

80106474 <vector9>:
.globl vector9
vector9:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $9
80106476:	6a 09                	push   $0x9
  jmp alltraps
80106478:	e9 5d fa ff ff       	jmp    80105eda <alltraps>

8010647d <vector10>:
.globl vector10
vector10:
  pushl $10
8010647d:	6a 0a                	push   $0xa
  jmp alltraps
8010647f:	e9 56 fa ff ff       	jmp    80105eda <alltraps>

80106484 <vector11>:
.globl vector11
vector11:
  pushl $11
80106484:	6a 0b                	push   $0xb
  jmp alltraps
80106486:	e9 4f fa ff ff       	jmp    80105eda <alltraps>

8010648b <vector12>:
.globl vector12
vector12:
  pushl $12
8010648b:	6a 0c                	push   $0xc
  jmp alltraps
8010648d:	e9 48 fa ff ff       	jmp    80105eda <alltraps>

80106492 <vector13>:
.globl vector13
vector13:
  pushl $13
80106492:	6a 0d                	push   $0xd
  jmp alltraps
80106494:	e9 41 fa ff ff       	jmp    80105eda <alltraps>

80106499 <vector14>:
.globl vector14
vector14:
  pushl $14
80106499:	6a 0e                	push   $0xe
  jmp alltraps
8010649b:	e9 3a fa ff ff       	jmp    80105eda <alltraps>

801064a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $15
801064a2:	6a 0f                	push   $0xf
  jmp alltraps
801064a4:	e9 31 fa ff ff       	jmp    80105eda <alltraps>

801064a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $16
801064ab:	6a 10                	push   $0x10
  jmp alltraps
801064ad:	e9 28 fa ff ff       	jmp    80105eda <alltraps>

801064b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801064b2:	6a 11                	push   $0x11
  jmp alltraps
801064b4:	e9 21 fa ff ff       	jmp    80105eda <alltraps>

801064b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $18
801064bb:	6a 12                	push   $0x12
  jmp alltraps
801064bd:	e9 18 fa ff ff       	jmp    80105eda <alltraps>

801064c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $19
801064c4:	6a 13                	push   $0x13
  jmp alltraps
801064c6:	e9 0f fa ff ff       	jmp    80105eda <alltraps>

801064cb <vector20>:
.globl vector20
vector20:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $20
801064cd:	6a 14                	push   $0x14
  jmp alltraps
801064cf:	e9 06 fa ff ff       	jmp    80105eda <alltraps>

801064d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $21
801064d6:	6a 15                	push   $0x15
  jmp alltraps
801064d8:	e9 fd f9 ff ff       	jmp    80105eda <alltraps>

801064dd <vector22>:
.globl vector22
vector22:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $22
801064df:	6a 16                	push   $0x16
  jmp alltraps
801064e1:	e9 f4 f9 ff ff       	jmp    80105eda <alltraps>

801064e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $23
801064e8:	6a 17                	push   $0x17
  jmp alltraps
801064ea:	e9 eb f9 ff ff       	jmp    80105eda <alltraps>

801064ef <vector24>:
.globl vector24
vector24:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $24
801064f1:	6a 18                	push   $0x18
  jmp alltraps
801064f3:	e9 e2 f9 ff ff       	jmp    80105eda <alltraps>

801064f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $25
801064fa:	6a 19                	push   $0x19
  jmp alltraps
801064fc:	e9 d9 f9 ff ff       	jmp    80105eda <alltraps>

80106501 <vector26>:
.globl vector26
vector26:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $26
80106503:	6a 1a                	push   $0x1a
  jmp alltraps
80106505:	e9 d0 f9 ff ff       	jmp    80105eda <alltraps>

8010650a <vector27>:
.globl vector27
vector27:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $27
8010650c:	6a 1b                	push   $0x1b
  jmp alltraps
8010650e:	e9 c7 f9 ff ff       	jmp    80105eda <alltraps>

80106513 <vector28>:
.globl vector28
vector28:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $28
80106515:	6a 1c                	push   $0x1c
  jmp alltraps
80106517:	e9 be f9 ff ff       	jmp    80105eda <alltraps>

8010651c <vector29>:
.globl vector29
vector29:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $29
8010651e:	6a 1d                	push   $0x1d
  jmp alltraps
80106520:	e9 b5 f9 ff ff       	jmp    80105eda <alltraps>

80106525 <vector30>:
.globl vector30
vector30:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $30
80106527:	6a 1e                	push   $0x1e
  jmp alltraps
80106529:	e9 ac f9 ff ff       	jmp    80105eda <alltraps>

8010652e <vector31>:
.globl vector31
vector31:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $31
80106530:	6a 1f                	push   $0x1f
  jmp alltraps
80106532:	e9 a3 f9 ff ff       	jmp    80105eda <alltraps>

80106537 <vector32>:
.globl vector32
vector32:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $32
80106539:	6a 20                	push   $0x20
  jmp alltraps
8010653b:	e9 9a f9 ff ff       	jmp    80105eda <alltraps>

80106540 <vector33>:
.globl vector33
vector33:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $33
80106542:	6a 21                	push   $0x21
  jmp alltraps
80106544:	e9 91 f9 ff ff       	jmp    80105eda <alltraps>

80106549 <vector34>:
.globl vector34
vector34:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $34
8010654b:	6a 22                	push   $0x22
  jmp alltraps
8010654d:	e9 88 f9 ff ff       	jmp    80105eda <alltraps>

80106552 <vector35>:
.globl vector35
vector35:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $35
80106554:	6a 23                	push   $0x23
  jmp alltraps
80106556:	e9 7f f9 ff ff       	jmp    80105eda <alltraps>

8010655b <vector36>:
.globl vector36
vector36:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $36
8010655d:	6a 24                	push   $0x24
  jmp alltraps
8010655f:	e9 76 f9 ff ff       	jmp    80105eda <alltraps>

80106564 <vector37>:
.globl vector37
vector37:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $37
80106566:	6a 25                	push   $0x25
  jmp alltraps
80106568:	e9 6d f9 ff ff       	jmp    80105eda <alltraps>

8010656d <vector38>:
.globl vector38
vector38:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $38
8010656f:	6a 26                	push   $0x26
  jmp alltraps
80106571:	e9 64 f9 ff ff       	jmp    80105eda <alltraps>

80106576 <vector39>:
.globl vector39
vector39:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $39
80106578:	6a 27                	push   $0x27
  jmp alltraps
8010657a:	e9 5b f9 ff ff       	jmp    80105eda <alltraps>

8010657f <vector40>:
.globl vector40
vector40:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $40
80106581:	6a 28                	push   $0x28
  jmp alltraps
80106583:	e9 52 f9 ff ff       	jmp    80105eda <alltraps>

80106588 <vector41>:
.globl vector41
vector41:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $41
8010658a:	6a 29                	push   $0x29
  jmp alltraps
8010658c:	e9 49 f9 ff ff       	jmp    80105eda <alltraps>

80106591 <vector42>:
.globl vector42
vector42:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $42
80106593:	6a 2a                	push   $0x2a
  jmp alltraps
80106595:	e9 40 f9 ff ff       	jmp    80105eda <alltraps>

8010659a <vector43>:
.globl vector43
vector43:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $43
8010659c:	6a 2b                	push   $0x2b
  jmp alltraps
8010659e:	e9 37 f9 ff ff       	jmp    80105eda <alltraps>

801065a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $44
801065a5:	6a 2c                	push   $0x2c
  jmp alltraps
801065a7:	e9 2e f9 ff ff       	jmp    80105eda <alltraps>

801065ac <vector45>:
.globl vector45
vector45:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $45
801065ae:	6a 2d                	push   $0x2d
  jmp alltraps
801065b0:	e9 25 f9 ff ff       	jmp    80105eda <alltraps>

801065b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $46
801065b7:	6a 2e                	push   $0x2e
  jmp alltraps
801065b9:	e9 1c f9 ff ff       	jmp    80105eda <alltraps>

801065be <vector47>:
.globl vector47
vector47:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $47
801065c0:	6a 2f                	push   $0x2f
  jmp alltraps
801065c2:	e9 13 f9 ff ff       	jmp    80105eda <alltraps>

801065c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $48
801065c9:	6a 30                	push   $0x30
  jmp alltraps
801065cb:	e9 0a f9 ff ff       	jmp    80105eda <alltraps>

801065d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $49
801065d2:	6a 31                	push   $0x31
  jmp alltraps
801065d4:	e9 01 f9 ff ff       	jmp    80105eda <alltraps>

801065d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $50
801065db:	6a 32                	push   $0x32
  jmp alltraps
801065dd:	e9 f8 f8 ff ff       	jmp    80105eda <alltraps>

801065e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $51
801065e4:	6a 33                	push   $0x33
  jmp alltraps
801065e6:	e9 ef f8 ff ff       	jmp    80105eda <alltraps>

801065eb <vector52>:
.globl vector52
vector52:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $52
801065ed:	6a 34                	push   $0x34
  jmp alltraps
801065ef:	e9 e6 f8 ff ff       	jmp    80105eda <alltraps>

801065f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $53
801065f6:	6a 35                	push   $0x35
  jmp alltraps
801065f8:	e9 dd f8 ff ff       	jmp    80105eda <alltraps>

801065fd <vector54>:
.globl vector54
vector54:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $54
801065ff:	6a 36                	push   $0x36
  jmp alltraps
80106601:	e9 d4 f8 ff ff       	jmp    80105eda <alltraps>

80106606 <vector55>:
.globl vector55
vector55:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $55
80106608:	6a 37                	push   $0x37
  jmp alltraps
8010660a:	e9 cb f8 ff ff       	jmp    80105eda <alltraps>

8010660f <vector56>:
.globl vector56
vector56:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $56
80106611:	6a 38                	push   $0x38
  jmp alltraps
80106613:	e9 c2 f8 ff ff       	jmp    80105eda <alltraps>

80106618 <vector57>:
.globl vector57
vector57:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $57
8010661a:	6a 39                	push   $0x39
  jmp alltraps
8010661c:	e9 b9 f8 ff ff       	jmp    80105eda <alltraps>

80106621 <vector58>:
.globl vector58
vector58:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $58
80106623:	6a 3a                	push   $0x3a
  jmp alltraps
80106625:	e9 b0 f8 ff ff       	jmp    80105eda <alltraps>

8010662a <vector59>:
.globl vector59
vector59:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $59
8010662c:	6a 3b                	push   $0x3b
  jmp alltraps
8010662e:	e9 a7 f8 ff ff       	jmp    80105eda <alltraps>

80106633 <vector60>:
.globl vector60
vector60:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $60
80106635:	6a 3c                	push   $0x3c
  jmp alltraps
80106637:	e9 9e f8 ff ff       	jmp    80105eda <alltraps>

8010663c <vector61>:
.globl vector61
vector61:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $61
8010663e:	6a 3d                	push   $0x3d
  jmp alltraps
80106640:	e9 95 f8 ff ff       	jmp    80105eda <alltraps>

80106645 <vector62>:
.globl vector62
vector62:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $62
80106647:	6a 3e                	push   $0x3e
  jmp alltraps
80106649:	e9 8c f8 ff ff       	jmp    80105eda <alltraps>

8010664e <vector63>:
.globl vector63
vector63:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $63
80106650:	6a 3f                	push   $0x3f
  jmp alltraps
80106652:	e9 83 f8 ff ff       	jmp    80105eda <alltraps>

80106657 <vector64>:
.globl vector64
vector64:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $64
80106659:	6a 40                	push   $0x40
  jmp alltraps
8010665b:	e9 7a f8 ff ff       	jmp    80105eda <alltraps>

80106660 <vector65>:
.globl vector65
vector65:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $65
80106662:	6a 41                	push   $0x41
  jmp alltraps
80106664:	e9 71 f8 ff ff       	jmp    80105eda <alltraps>

80106669 <vector66>:
.globl vector66
vector66:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $66
8010666b:	6a 42                	push   $0x42
  jmp alltraps
8010666d:	e9 68 f8 ff ff       	jmp    80105eda <alltraps>

80106672 <vector67>:
.globl vector67
vector67:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $67
80106674:	6a 43                	push   $0x43
  jmp alltraps
80106676:	e9 5f f8 ff ff       	jmp    80105eda <alltraps>

8010667b <vector68>:
.globl vector68
vector68:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $68
8010667d:	6a 44                	push   $0x44
  jmp alltraps
8010667f:	e9 56 f8 ff ff       	jmp    80105eda <alltraps>

80106684 <vector69>:
.globl vector69
vector69:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $69
80106686:	6a 45                	push   $0x45
  jmp alltraps
80106688:	e9 4d f8 ff ff       	jmp    80105eda <alltraps>

8010668d <vector70>:
.globl vector70
vector70:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $70
8010668f:	6a 46                	push   $0x46
  jmp alltraps
80106691:	e9 44 f8 ff ff       	jmp    80105eda <alltraps>

80106696 <vector71>:
.globl vector71
vector71:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $71
80106698:	6a 47                	push   $0x47
  jmp alltraps
8010669a:	e9 3b f8 ff ff       	jmp    80105eda <alltraps>

8010669f <vector72>:
.globl vector72
vector72:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $72
801066a1:	6a 48                	push   $0x48
  jmp alltraps
801066a3:	e9 32 f8 ff ff       	jmp    80105eda <alltraps>

801066a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $73
801066aa:	6a 49                	push   $0x49
  jmp alltraps
801066ac:	e9 29 f8 ff ff       	jmp    80105eda <alltraps>

801066b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $74
801066b3:	6a 4a                	push   $0x4a
  jmp alltraps
801066b5:	e9 20 f8 ff ff       	jmp    80105eda <alltraps>

801066ba <vector75>:
.globl vector75
vector75:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $75
801066bc:	6a 4b                	push   $0x4b
  jmp alltraps
801066be:	e9 17 f8 ff ff       	jmp    80105eda <alltraps>

801066c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $76
801066c5:	6a 4c                	push   $0x4c
  jmp alltraps
801066c7:	e9 0e f8 ff ff       	jmp    80105eda <alltraps>

801066cc <vector77>:
.globl vector77
vector77:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $77
801066ce:	6a 4d                	push   $0x4d
  jmp alltraps
801066d0:	e9 05 f8 ff ff       	jmp    80105eda <alltraps>

801066d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $78
801066d7:	6a 4e                	push   $0x4e
  jmp alltraps
801066d9:	e9 fc f7 ff ff       	jmp    80105eda <alltraps>

801066de <vector79>:
.globl vector79
vector79:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $79
801066e0:	6a 4f                	push   $0x4f
  jmp alltraps
801066e2:	e9 f3 f7 ff ff       	jmp    80105eda <alltraps>

801066e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $80
801066e9:	6a 50                	push   $0x50
  jmp alltraps
801066eb:	e9 ea f7 ff ff       	jmp    80105eda <alltraps>

801066f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $81
801066f2:	6a 51                	push   $0x51
  jmp alltraps
801066f4:	e9 e1 f7 ff ff       	jmp    80105eda <alltraps>

801066f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $82
801066fb:	6a 52                	push   $0x52
  jmp alltraps
801066fd:	e9 d8 f7 ff ff       	jmp    80105eda <alltraps>

80106702 <vector83>:
.globl vector83
vector83:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $83
80106704:	6a 53                	push   $0x53
  jmp alltraps
80106706:	e9 cf f7 ff ff       	jmp    80105eda <alltraps>

8010670b <vector84>:
.globl vector84
vector84:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $84
8010670d:	6a 54                	push   $0x54
  jmp alltraps
8010670f:	e9 c6 f7 ff ff       	jmp    80105eda <alltraps>

80106714 <vector85>:
.globl vector85
vector85:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $85
80106716:	6a 55                	push   $0x55
  jmp alltraps
80106718:	e9 bd f7 ff ff       	jmp    80105eda <alltraps>

8010671d <vector86>:
.globl vector86
vector86:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $86
8010671f:	6a 56                	push   $0x56
  jmp alltraps
80106721:	e9 b4 f7 ff ff       	jmp    80105eda <alltraps>

80106726 <vector87>:
.globl vector87
vector87:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $87
80106728:	6a 57                	push   $0x57
  jmp alltraps
8010672a:	e9 ab f7 ff ff       	jmp    80105eda <alltraps>

8010672f <vector88>:
.globl vector88
vector88:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $88
80106731:	6a 58                	push   $0x58
  jmp alltraps
80106733:	e9 a2 f7 ff ff       	jmp    80105eda <alltraps>

80106738 <vector89>:
.globl vector89
vector89:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $89
8010673a:	6a 59                	push   $0x59
  jmp alltraps
8010673c:	e9 99 f7 ff ff       	jmp    80105eda <alltraps>

80106741 <vector90>:
.globl vector90
vector90:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $90
80106743:	6a 5a                	push   $0x5a
  jmp alltraps
80106745:	e9 90 f7 ff ff       	jmp    80105eda <alltraps>

8010674a <vector91>:
.globl vector91
vector91:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $91
8010674c:	6a 5b                	push   $0x5b
  jmp alltraps
8010674e:	e9 87 f7 ff ff       	jmp    80105eda <alltraps>

80106753 <vector92>:
.globl vector92
vector92:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $92
80106755:	6a 5c                	push   $0x5c
  jmp alltraps
80106757:	e9 7e f7 ff ff       	jmp    80105eda <alltraps>

8010675c <vector93>:
.globl vector93
vector93:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $93
8010675e:	6a 5d                	push   $0x5d
  jmp alltraps
80106760:	e9 75 f7 ff ff       	jmp    80105eda <alltraps>

80106765 <vector94>:
.globl vector94
vector94:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $94
80106767:	6a 5e                	push   $0x5e
  jmp alltraps
80106769:	e9 6c f7 ff ff       	jmp    80105eda <alltraps>

8010676e <vector95>:
.globl vector95
vector95:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $95
80106770:	6a 5f                	push   $0x5f
  jmp alltraps
80106772:	e9 63 f7 ff ff       	jmp    80105eda <alltraps>

80106777 <vector96>:
.globl vector96
vector96:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $96
80106779:	6a 60                	push   $0x60
  jmp alltraps
8010677b:	e9 5a f7 ff ff       	jmp    80105eda <alltraps>

80106780 <vector97>:
.globl vector97
vector97:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $97
80106782:	6a 61                	push   $0x61
  jmp alltraps
80106784:	e9 51 f7 ff ff       	jmp    80105eda <alltraps>

80106789 <vector98>:
.globl vector98
vector98:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $98
8010678b:	6a 62                	push   $0x62
  jmp alltraps
8010678d:	e9 48 f7 ff ff       	jmp    80105eda <alltraps>

80106792 <vector99>:
.globl vector99
vector99:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $99
80106794:	6a 63                	push   $0x63
  jmp alltraps
80106796:	e9 3f f7 ff ff       	jmp    80105eda <alltraps>

8010679b <vector100>:
.globl vector100
vector100:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $100
8010679d:	6a 64                	push   $0x64
  jmp alltraps
8010679f:	e9 36 f7 ff ff       	jmp    80105eda <alltraps>

801067a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $101
801067a6:	6a 65                	push   $0x65
  jmp alltraps
801067a8:	e9 2d f7 ff ff       	jmp    80105eda <alltraps>

801067ad <vector102>:
.globl vector102
vector102:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $102
801067af:	6a 66                	push   $0x66
  jmp alltraps
801067b1:	e9 24 f7 ff ff       	jmp    80105eda <alltraps>

801067b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $103
801067b8:	6a 67                	push   $0x67
  jmp alltraps
801067ba:	e9 1b f7 ff ff       	jmp    80105eda <alltraps>

801067bf <vector104>:
.globl vector104
vector104:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $104
801067c1:	6a 68                	push   $0x68
  jmp alltraps
801067c3:	e9 12 f7 ff ff       	jmp    80105eda <alltraps>

801067c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $105
801067ca:	6a 69                	push   $0x69
  jmp alltraps
801067cc:	e9 09 f7 ff ff       	jmp    80105eda <alltraps>

801067d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $106
801067d3:	6a 6a                	push   $0x6a
  jmp alltraps
801067d5:	e9 00 f7 ff ff       	jmp    80105eda <alltraps>

801067da <vector107>:
.globl vector107
vector107:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $107
801067dc:	6a 6b                	push   $0x6b
  jmp alltraps
801067de:	e9 f7 f6 ff ff       	jmp    80105eda <alltraps>

801067e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $108
801067e5:	6a 6c                	push   $0x6c
  jmp alltraps
801067e7:	e9 ee f6 ff ff       	jmp    80105eda <alltraps>

801067ec <vector109>:
.globl vector109
vector109:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $109
801067ee:	6a 6d                	push   $0x6d
  jmp alltraps
801067f0:	e9 e5 f6 ff ff       	jmp    80105eda <alltraps>

801067f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $110
801067f7:	6a 6e                	push   $0x6e
  jmp alltraps
801067f9:	e9 dc f6 ff ff       	jmp    80105eda <alltraps>

801067fe <vector111>:
.globl vector111
vector111:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $111
80106800:	6a 6f                	push   $0x6f
  jmp alltraps
80106802:	e9 d3 f6 ff ff       	jmp    80105eda <alltraps>

80106807 <vector112>:
.globl vector112
vector112:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $112
80106809:	6a 70                	push   $0x70
  jmp alltraps
8010680b:	e9 ca f6 ff ff       	jmp    80105eda <alltraps>

80106810 <vector113>:
.globl vector113
vector113:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $113
80106812:	6a 71                	push   $0x71
  jmp alltraps
80106814:	e9 c1 f6 ff ff       	jmp    80105eda <alltraps>

80106819 <vector114>:
.globl vector114
vector114:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $114
8010681b:	6a 72                	push   $0x72
  jmp alltraps
8010681d:	e9 b8 f6 ff ff       	jmp    80105eda <alltraps>

80106822 <vector115>:
.globl vector115
vector115:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $115
80106824:	6a 73                	push   $0x73
  jmp alltraps
80106826:	e9 af f6 ff ff       	jmp    80105eda <alltraps>

8010682b <vector116>:
.globl vector116
vector116:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $116
8010682d:	6a 74                	push   $0x74
  jmp alltraps
8010682f:	e9 a6 f6 ff ff       	jmp    80105eda <alltraps>

80106834 <vector117>:
.globl vector117
vector117:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $117
80106836:	6a 75                	push   $0x75
  jmp alltraps
80106838:	e9 9d f6 ff ff       	jmp    80105eda <alltraps>

8010683d <vector118>:
.globl vector118
vector118:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $118
8010683f:	6a 76                	push   $0x76
  jmp alltraps
80106841:	e9 94 f6 ff ff       	jmp    80105eda <alltraps>

80106846 <vector119>:
.globl vector119
vector119:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $119
80106848:	6a 77                	push   $0x77
  jmp alltraps
8010684a:	e9 8b f6 ff ff       	jmp    80105eda <alltraps>

8010684f <vector120>:
.globl vector120
vector120:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $120
80106851:	6a 78                	push   $0x78
  jmp alltraps
80106853:	e9 82 f6 ff ff       	jmp    80105eda <alltraps>

80106858 <vector121>:
.globl vector121
vector121:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $121
8010685a:	6a 79                	push   $0x79
  jmp alltraps
8010685c:	e9 79 f6 ff ff       	jmp    80105eda <alltraps>

80106861 <vector122>:
.globl vector122
vector122:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $122
80106863:	6a 7a                	push   $0x7a
  jmp alltraps
80106865:	e9 70 f6 ff ff       	jmp    80105eda <alltraps>

8010686a <vector123>:
.globl vector123
vector123:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $123
8010686c:	6a 7b                	push   $0x7b
  jmp alltraps
8010686e:	e9 67 f6 ff ff       	jmp    80105eda <alltraps>

80106873 <vector124>:
.globl vector124
vector124:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $124
80106875:	6a 7c                	push   $0x7c
  jmp alltraps
80106877:	e9 5e f6 ff ff       	jmp    80105eda <alltraps>

8010687c <vector125>:
.globl vector125
vector125:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $125
8010687e:	6a 7d                	push   $0x7d
  jmp alltraps
80106880:	e9 55 f6 ff ff       	jmp    80105eda <alltraps>

80106885 <vector126>:
.globl vector126
vector126:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $126
80106887:	6a 7e                	push   $0x7e
  jmp alltraps
80106889:	e9 4c f6 ff ff       	jmp    80105eda <alltraps>

8010688e <vector127>:
.globl vector127
vector127:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $127
80106890:	6a 7f                	push   $0x7f
  jmp alltraps
80106892:	e9 43 f6 ff ff       	jmp    80105eda <alltraps>

80106897 <vector128>:
.globl vector128
vector128:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $128
80106899:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010689e:	e9 37 f6 ff ff       	jmp    80105eda <alltraps>

801068a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $129
801068a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801068aa:	e9 2b f6 ff ff       	jmp    80105eda <alltraps>

801068af <vector130>:
.globl vector130
vector130:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $130
801068b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801068b6:	e9 1f f6 ff ff       	jmp    80105eda <alltraps>

801068bb <vector131>:
.globl vector131
vector131:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $131
801068bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068c2:	e9 13 f6 ff ff       	jmp    80105eda <alltraps>

801068c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $132
801068c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068ce:	e9 07 f6 ff ff       	jmp    80105eda <alltraps>

801068d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $133
801068d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068da:	e9 fb f5 ff ff       	jmp    80105eda <alltraps>

801068df <vector134>:
.globl vector134
vector134:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $134
801068e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068e6:	e9 ef f5 ff ff       	jmp    80105eda <alltraps>

801068eb <vector135>:
.globl vector135
vector135:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $135
801068ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068f2:	e9 e3 f5 ff ff       	jmp    80105eda <alltraps>

801068f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $136
801068f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068fe:	e9 d7 f5 ff ff       	jmp    80105eda <alltraps>

80106903 <vector137>:
.globl vector137
vector137:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $137
80106905:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010690a:	e9 cb f5 ff ff       	jmp    80105eda <alltraps>

8010690f <vector138>:
.globl vector138
vector138:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $138
80106911:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106916:	e9 bf f5 ff ff       	jmp    80105eda <alltraps>

8010691b <vector139>:
.globl vector139
vector139:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $139
8010691d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106922:	e9 b3 f5 ff ff       	jmp    80105eda <alltraps>

80106927 <vector140>:
.globl vector140
vector140:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $140
80106929:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010692e:	e9 a7 f5 ff ff       	jmp    80105eda <alltraps>

80106933 <vector141>:
.globl vector141
vector141:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $141
80106935:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010693a:	e9 9b f5 ff ff       	jmp    80105eda <alltraps>

8010693f <vector142>:
.globl vector142
vector142:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $142
80106941:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106946:	e9 8f f5 ff ff       	jmp    80105eda <alltraps>

8010694b <vector143>:
.globl vector143
vector143:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $143
8010694d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106952:	e9 83 f5 ff ff       	jmp    80105eda <alltraps>

80106957 <vector144>:
.globl vector144
vector144:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $144
80106959:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010695e:	e9 77 f5 ff ff       	jmp    80105eda <alltraps>

80106963 <vector145>:
.globl vector145
vector145:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $145
80106965:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010696a:	e9 6b f5 ff ff       	jmp    80105eda <alltraps>

8010696f <vector146>:
.globl vector146
vector146:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $146
80106971:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106976:	e9 5f f5 ff ff       	jmp    80105eda <alltraps>

8010697b <vector147>:
.globl vector147
vector147:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $147
8010697d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106982:	e9 53 f5 ff ff       	jmp    80105eda <alltraps>

80106987 <vector148>:
.globl vector148
vector148:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $148
80106989:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010698e:	e9 47 f5 ff ff       	jmp    80105eda <alltraps>

80106993 <vector149>:
.globl vector149
vector149:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $149
80106995:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010699a:	e9 3b f5 ff ff       	jmp    80105eda <alltraps>

8010699f <vector150>:
.globl vector150
vector150:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $150
801069a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801069a6:	e9 2f f5 ff ff       	jmp    80105eda <alltraps>

801069ab <vector151>:
.globl vector151
vector151:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $151
801069ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801069b2:	e9 23 f5 ff ff       	jmp    80105eda <alltraps>

801069b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $152
801069b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069be:	e9 17 f5 ff ff       	jmp    80105eda <alltraps>

801069c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $153
801069c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069ca:	e9 0b f5 ff ff       	jmp    80105eda <alltraps>

801069cf <vector154>:
.globl vector154
vector154:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $154
801069d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069d6:	e9 ff f4 ff ff       	jmp    80105eda <alltraps>

801069db <vector155>:
.globl vector155
vector155:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $155
801069dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069e2:	e9 f3 f4 ff ff       	jmp    80105eda <alltraps>

801069e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $156
801069e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069ee:	e9 e7 f4 ff ff       	jmp    80105eda <alltraps>

801069f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $157
801069f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069fa:	e9 db f4 ff ff       	jmp    80105eda <alltraps>

801069ff <vector158>:
.globl vector158
vector158:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $158
80106a01:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a06:	e9 cf f4 ff ff       	jmp    80105eda <alltraps>

80106a0b <vector159>:
.globl vector159
vector159:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $159
80106a0d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a12:	e9 c3 f4 ff ff       	jmp    80105eda <alltraps>

80106a17 <vector160>:
.globl vector160
vector160:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $160
80106a19:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a1e:	e9 b7 f4 ff ff       	jmp    80105eda <alltraps>

80106a23 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $161
80106a25:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a2a:	e9 ab f4 ff ff       	jmp    80105eda <alltraps>

80106a2f <vector162>:
.globl vector162
vector162:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $162
80106a31:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a36:	e9 9f f4 ff ff       	jmp    80105eda <alltraps>

80106a3b <vector163>:
.globl vector163
vector163:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $163
80106a3d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a42:	e9 93 f4 ff ff       	jmp    80105eda <alltraps>

80106a47 <vector164>:
.globl vector164
vector164:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $164
80106a49:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a4e:	e9 87 f4 ff ff       	jmp    80105eda <alltraps>

80106a53 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $165
80106a55:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a5a:	e9 7b f4 ff ff       	jmp    80105eda <alltraps>

80106a5f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $166
80106a61:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a66:	e9 6f f4 ff ff       	jmp    80105eda <alltraps>

80106a6b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $167
80106a6d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a72:	e9 63 f4 ff ff       	jmp    80105eda <alltraps>

80106a77 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $168
80106a79:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a7e:	e9 57 f4 ff ff       	jmp    80105eda <alltraps>

80106a83 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $169
80106a85:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a8a:	e9 4b f4 ff ff       	jmp    80105eda <alltraps>

80106a8f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $170
80106a91:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a96:	e9 3f f4 ff ff       	jmp    80105eda <alltraps>

80106a9b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $171
80106a9d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106aa2:	e9 33 f4 ff ff       	jmp    80105eda <alltraps>

80106aa7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $172
80106aa9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106aae:	e9 27 f4 ff ff       	jmp    80105eda <alltraps>

80106ab3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $173
80106ab5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106aba:	e9 1b f4 ff ff       	jmp    80105eda <alltraps>

80106abf <vector174>:
.globl vector174
vector174:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $174
80106ac1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ac6:	e9 0f f4 ff ff       	jmp    80105eda <alltraps>

80106acb <vector175>:
.globl vector175
vector175:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $175
80106acd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ad2:	e9 03 f4 ff ff       	jmp    80105eda <alltraps>

80106ad7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $176
80106ad9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ade:	e9 f7 f3 ff ff       	jmp    80105eda <alltraps>

80106ae3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $177
80106ae5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106aea:	e9 eb f3 ff ff       	jmp    80105eda <alltraps>

80106aef <vector178>:
.globl vector178
vector178:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $178
80106af1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106af6:	e9 df f3 ff ff       	jmp    80105eda <alltraps>

80106afb <vector179>:
.globl vector179
vector179:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $179
80106afd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b02:	e9 d3 f3 ff ff       	jmp    80105eda <alltraps>

80106b07 <vector180>:
.globl vector180
vector180:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $180
80106b09:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b0e:	e9 c7 f3 ff ff       	jmp    80105eda <alltraps>

80106b13 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $181
80106b15:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b1a:	e9 bb f3 ff ff       	jmp    80105eda <alltraps>

80106b1f <vector182>:
.globl vector182
vector182:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $182
80106b21:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b26:	e9 af f3 ff ff       	jmp    80105eda <alltraps>

80106b2b <vector183>:
.globl vector183
vector183:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $183
80106b2d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b32:	e9 a3 f3 ff ff       	jmp    80105eda <alltraps>

80106b37 <vector184>:
.globl vector184
vector184:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $184
80106b39:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b3e:	e9 97 f3 ff ff       	jmp    80105eda <alltraps>

80106b43 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $185
80106b45:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b4a:	e9 8b f3 ff ff       	jmp    80105eda <alltraps>

80106b4f <vector186>:
.globl vector186
vector186:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $186
80106b51:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b56:	e9 7f f3 ff ff       	jmp    80105eda <alltraps>

80106b5b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $187
80106b5d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b62:	e9 73 f3 ff ff       	jmp    80105eda <alltraps>

80106b67 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $188
80106b69:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b6e:	e9 67 f3 ff ff       	jmp    80105eda <alltraps>

80106b73 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $189
80106b75:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b7a:	e9 5b f3 ff ff       	jmp    80105eda <alltraps>

80106b7f <vector190>:
.globl vector190
vector190:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $190
80106b81:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b86:	e9 4f f3 ff ff       	jmp    80105eda <alltraps>

80106b8b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $191
80106b8d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b92:	e9 43 f3 ff ff       	jmp    80105eda <alltraps>

80106b97 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $192
80106b99:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b9e:	e9 37 f3 ff ff       	jmp    80105eda <alltraps>

80106ba3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $193
80106ba5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106baa:	e9 2b f3 ff ff       	jmp    80105eda <alltraps>

80106baf <vector194>:
.globl vector194
vector194:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $194
80106bb1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106bb6:	e9 1f f3 ff ff       	jmp    80105eda <alltraps>

80106bbb <vector195>:
.globl vector195
vector195:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $195
80106bbd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106bc2:	e9 13 f3 ff ff       	jmp    80105eda <alltraps>

80106bc7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $196
80106bc9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bce:	e9 07 f3 ff ff       	jmp    80105eda <alltraps>

80106bd3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $197
80106bd5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106bda:	e9 fb f2 ff ff       	jmp    80105eda <alltraps>

80106bdf <vector198>:
.globl vector198
vector198:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $198
80106be1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106be6:	e9 ef f2 ff ff       	jmp    80105eda <alltraps>

80106beb <vector199>:
.globl vector199
vector199:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $199
80106bed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106bf2:	e9 e3 f2 ff ff       	jmp    80105eda <alltraps>

80106bf7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $200
80106bf9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106bfe:	e9 d7 f2 ff ff       	jmp    80105eda <alltraps>

80106c03 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $201
80106c05:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c0a:	e9 cb f2 ff ff       	jmp    80105eda <alltraps>

80106c0f <vector202>:
.globl vector202
vector202:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $202
80106c11:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c16:	e9 bf f2 ff ff       	jmp    80105eda <alltraps>

80106c1b <vector203>:
.globl vector203
vector203:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $203
80106c1d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c22:	e9 b3 f2 ff ff       	jmp    80105eda <alltraps>

80106c27 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $204
80106c29:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c2e:	e9 a7 f2 ff ff       	jmp    80105eda <alltraps>

80106c33 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $205
80106c35:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c3a:	e9 9b f2 ff ff       	jmp    80105eda <alltraps>

80106c3f <vector206>:
.globl vector206
vector206:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $206
80106c41:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c46:	e9 8f f2 ff ff       	jmp    80105eda <alltraps>

80106c4b <vector207>:
.globl vector207
vector207:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $207
80106c4d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c52:	e9 83 f2 ff ff       	jmp    80105eda <alltraps>

80106c57 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $208
80106c59:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c5e:	e9 77 f2 ff ff       	jmp    80105eda <alltraps>

80106c63 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $209
80106c65:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c6a:	e9 6b f2 ff ff       	jmp    80105eda <alltraps>

80106c6f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $210
80106c71:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c76:	e9 5f f2 ff ff       	jmp    80105eda <alltraps>

80106c7b <vector211>:
.globl vector211
vector211:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $211
80106c7d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c82:	e9 53 f2 ff ff       	jmp    80105eda <alltraps>

80106c87 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $212
80106c89:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c8e:	e9 47 f2 ff ff       	jmp    80105eda <alltraps>

80106c93 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $213
80106c95:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c9a:	e9 3b f2 ff ff       	jmp    80105eda <alltraps>

80106c9f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $214
80106ca1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ca6:	e9 2f f2 ff ff       	jmp    80105eda <alltraps>

80106cab <vector215>:
.globl vector215
vector215:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $215
80106cad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106cb2:	e9 23 f2 ff ff       	jmp    80105eda <alltraps>

80106cb7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $216
80106cb9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106cbe:	e9 17 f2 ff ff       	jmp    80105eda <alltraps>

80106cc3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $217
80106cc5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106cca:	e9 0b f2 ff ff       	jmp    80105eda <alltraps>

80106ccf <vector218>:
.globl vector218
vector218:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $218
80106cd1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106cd6:	e9 ff f1 ff ff       	jmp    80105eda <alltraps>

80106cdb <vector219>:
.globl vector219
vector219:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $219
80106cdd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ce2:	e9 f3 f1 ff ff       	jmp    80105eda <alltraps>

80106ce7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $220
80106ce9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cee:	e9 e7 f1 ff ff       	jmp    80105eda <alltraps>

80106cf3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $221
80106cf5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cfa:	e9 db f1 ff ff       	jmp    80105eda <alltraps>

80106cff <vector222>:
.globl vector222
vector222:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $222
80106d01:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d06:	e9 cf f1 ff ff       	jmp    80105eda <alltraps>

80106d0b <vector223>:
.globl vector223
vector223:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $223
80106d0d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d12:	e9 c3 f1 ff ff       	jmp    80105eda <alltraps>

80106d17 <vector224>:
.globl vector224
vector224:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $224
80106d19:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d1e:	e9 b7 f1 ff ff       	jmp    80105eda <alltraps>

80106d23 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $225
80106d25:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d2a:	e9 ab f1 ff ff       	jmp    80105eda <alltraps>

80106d2f <vector226>:
.globl vector226
vector226:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $226
80106d31:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d36:	e9 9f f1 ff ff       	jmp    80105eda <alltraps>

80106d3b <vector227>:
.globl vector227
vector227:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $227
80106d3d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d42:	e9 93 f1 ff ff       	jmp    80105eda <alltraps>

80106d47 <vector228>:
.globl vector228
vector228:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $228
80106d49:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d4e:	e9 87 f1 ff ff       	jmp    80105eda <alltraps>

80106d53 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $229
80106d55:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d5a:	e9 7b f1 ff ff       	jmp    80105eda <alltraps>

80106d5f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $230
80106d61:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d66:	e9 6f f1 ff ff       	jmp    80105eda <alltraps>

80106d6b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $231
80106d6d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d72:	e9 63 f1 ff ff       	jmp    80105eda <alltraps>

80106d77 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $232
80106d79:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d7e:	e9 57 f1 ff ff       	jmp    80105eda <alltraps>

80106d83 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $233
80106d85:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d8a:	e9 4b f1 ff ff       	jmp    80105eda <alltraps>

80106d8f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $234
80106d91:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d96:	e9 3f f1 ff ff       	jmp    80105eda <alltraps>

80106d9b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $235
80106d9d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106da2:	e9 33 f1 ff ff       	jmp    80105eda <alltraps>

80106da7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $236
80106da9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106dae:	e9 27 f1 ff ff       	jmp    80105eda <alltraps>

80106db3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $237
80106db5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106dba:	e9 1b f1 ff ff       	jmp    80105eda <alltraps>

80106dbf <vector238>:
.globl vector238
vector238:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $238
80106dc1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106dc6:	e9 0f f1 ff ff       	jmp    80105eda <alltraps>

80106dcb <vector239>:
.globl vector239
vector239:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $239
80106dcd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106dd2:	e9 03 f1 ff ff       	jmp    80105eda <alltraps>

80106dd7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $240
80106dd9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106dde:	e9 f7 f0 ff ff       	jmp    80105eda <alltraps>

80106de3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $241
80106de5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106dea:	e9 eb f0 ff ff       	jmp    80105eda <alltraps>

80106def <vector242>:
.globl vector242
vector242:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $242
80106df1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106df6:	e9 df f0 ff ff       	jmp    80105eda <alltraps>

80106dfb <vector243>:
.globl vector243
vector243:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $243
80106dfd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e02:	e9 d3 f0 ff ff       	jmp    80105eda <alltraps>

80106e07 <vector244>:
.globl vector244
vector244:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $244
80106e09:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e0e:	e9 c7 f0 ff ff       	jmp    80105eda <alltraps>

80106e13 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $245
80106e15:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e1a:	e9 bb f0 ff ff       	jmp    80105eda <alltraps>

80106e1f <vector246>:
.globl vector246
vector246:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $246
80106e21:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e26:	e9 af f0 ff ff       	jmp    80105eda <alltraps>

80106e2b <vector247>:
.globl vector247
vector247:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $247
80106e2d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e32:	e9 a3 f0 ff ff       	jmp    80105eda <alltraps>

80106e37 <vector248>:
.globl vector248
vector248:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $248
80106e39:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e3e:	e9 97 f0 ff ff       	jmp    80105eda <alltraps>

80106e43 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $249
80106e45:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e4a:	e9 8b f0 ff ff       	jmp    80105eda <alltraps>

80106e4f <vector250>:
.globl vector250
vector250:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $250
80106e51:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e56:	e9 7f f0 ff ff       	jmp    80105eda <alltraps>

80106e5b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $251
80106e5d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e62:	e9 73 f0 ff ff       	jmp    80105eda <alltraps>

80106e67 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $252
80106e69:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e6e:	e9 67 f0 ff ff       	jmp    80105eda <alltraps>

80106e73 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $253
80106e75:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e7a:	e9 5b f0 ff ff       	jmp    80105eda <alltraps>

80106e7f <vector254>:
.globl vector254
vector254:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $254
80106e81:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e86:	e9 4f f0 ff ff       	jmp    80105eda <alltraps>

80106e8b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $255
80106e8d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e92:	e9 43 f0 ff ff       	jmp    80105eda <alltraps>
80106e97:	66 90                	xchg   %ax,%ax
80106e99:	66 90                	xchg   %ax,%ax
80106e9b:	66 90                	xchg   %ax,%ax
80106e9d:	66 90                	xchg   %ax,%ax
80106e9f:	90                   	nop

80106ea0 <deallocuvm.part.0>:
  }
}


int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	89 c6                	mov    %eax,%esi
80106ea7:	89 c8                	mov    %ecx,%eax
80106ea9:	53                   	push   %ebx
          return newsz;
      }
  }
  
  
  current_addr = PGROUNDUP(newsz);
80106eaa:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106eb0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106eb6:	83 ec 1c             	sub    $0x1c,%esp
  }
  
  
  while (1) {
      
      if (current_addr >= oldsz) {
80106eb9:	39 d3                	cmp    %edx,%ebx
80106ebb:	0f 83 92 00 00 00    	jae    80106f53 <deallocuvm.part.0+0xb3>
80106ec1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106ec4:	89 d7                	mov    %edx,%edi
80106ec6:	eb 1f                	jmp    80106ee7 <deallocuvm.part.0+0x47>
80106ec8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ecf:	00 
          
          
          if (pte == 0) {
              
              uint pde_index = PDX(current_addr);
              current_addr = PGADDR(pde_index + 1, 0, 0) - PGSIZE;
80106ed0:	c1 e2 16             	shl    $0x16,%edx
80106ed3:	8d 9a 00 f0 3f 00    	lea    0x3ff000(%edx),%ebx
              }
          }
      }
      
      
      if (current_addr < oldsz) {
80106ed9:	39 fb                	cmp    %edi,%ebx
80106edb:	73 73                	jae    80106f50 <deallocuvm.part.0+0xb0>
          current_addr = current_addr + PGSIZE;
80106edd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      if (current_addr >= oldsz) {
80106ee3:	39 fb                	cmp    %edi,%ebx
80106ee5:	73 69                	jae    80106f50 <deallocuvm.part.0+0xb0>
  pde = &pgdir[PDX(va)];
80106ee7:	89 da                	mov    %ebx,%edx
80106ee9:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106eec:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106eef:	a8 01                	test   $0x1,%al
80106ef1:	74 dd                	je     80106ed0 <deallocuvm.part.0+0x30>
  return &pgtab[PTX(va)];
80106ef3:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ef5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106efa:	c1 e9 0a             	shr    $0xa,%ecx
80106efd:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106f03:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
          if (pte == 0) {
80106f0a:	85 c0                	test   %eax,%eax
80106f0c:	74 c2                	je     80106ed0 <deallocuvm.part.0+0x30>
              if ((*pte & PTE_P) != 0) {
80106f0e:	8b 10                	mov    (%eax),%edx
80106f10:	f6 c2 01             	test   $0x1,%dl
80106f13:	74 c4                	je     80106ed9 <deallocuvm.part.0+0x39>
                  if (phys_addr == 0) {
80106f15:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106f1b:	74 3e                	je     80106f5b <deallocuvm.part.0+0xbb>
                  if (virt_addr != 0) {
80106f1d:	81 fa 00 00 00 80    	cmp    $0x80000000,%edx
80106f23:	74 18                	je     80106f3d <deallocuvm.part.0+0x9d>
                      kfree(virt_addr);
80106f25:	83 ec 0c             	sub    $0xc,%esp
                  char *virt_addr = P2V(phys_addr);
80106f28:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106f2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                      kfree(virt_addr);
80106f31:	52                   	push   %edx
80106f32:	e8 d9 b5 ff ff       	call   80102510 <kfree>
80106f37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f3a:	83 c4 10             	add    $0x10,%esp
                  *pte = 0;
80106f3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      if (current_addr < oldsz) {
80106f43:	39 fb                	cmp    %edi,%ebx
80106f45:	72 96                	jb     80106edd <deallocuvm.part.0+0x3d>
80106f47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f4e:	00 
80106f4f:	90                   	nop
80106f50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  
  
  if (1) {
      return newsz;
  }
}
80106f53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f56:	5b                   	pop    %ebx
80106f57:	5e                   	pop    %esi
80106f58:	5f                   	pop    %edi
80106f59:	5d                   	pop    %ebp
80106f5a:	c3                   	ret
                          panic("kfree");
80106f5b:	83 ec 0c             	sub    $0xc,%esp
80106f5e:	68 cc 84 10 80       	push   $0x801084cc
80106f63:	e8 18 94 ff ff       	call   80100380 <panic>
80106f68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f6f:	00 

80106f70 <mappages>:
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	56                   	push   %esi
80106f75:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106f76:	89 d3                	mov    %edx,%ebx
80106f78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106f7e:	83 ec 1c             	sub    $0x1c,%esp
80106f81:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f84:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f90:	8b 45 08             	mov    0x8(%ebp),%eax
80106f93:	29 d8                	sub    %ebx,%eax
80106f95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f98:	eb 3f                	jmp    80106fd9 <mappages+0x69>
80106f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106fa0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fa2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106fa7:	c1 ea 0a             	shr    $0xa,%edx
80106faa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106fb0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106fb7:	85 c0                	test   %eax,%eax
80106fb9:	74 75                	je     80107030 <mappages+0xc0>
    if(*pte & PTE_P)
80106fbb:	f6 00 01             	testb  $0x1,(%eax)
80106fbe:	0f 85 86 00 00 00    	jne    8010704a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106fc4:	0b 75 0c             	or     0xc(%ebp),%esi
80106fc7:	83 ce 01             	or     $0x1,%esi
80106fca:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106fcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106fcf:	39 c3                	cmp    %eax,%ebx
80106fd1:	74 6d                	je     80107040 <mappages+0xd0>
    a += PGSIZE;
80106fd3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106fdc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106fdf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106fe2:	89 d8                	mov    %ebx,%eax
80106fe4:	c1 e8 16             	shr    $0x16,%eax
80106fe7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106fea:	8b 07                	mov    (%edi),%eax
80106fec:	a8 01                	test   $0x1,%al
80106fee:	75 b0                	jne    80106fa0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ff0:	e8 1b b7 ff ff       	call   80102710 <kalloc>
80106ff5:	85 c0                	test   %eax,%eax
80106ff7:	74 37                	je     80107030 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106ff9:	83 ec 04             	sub    $0x4,%esp
80106ffc:	68 00 10 00 00       	push   $0x1000
80107001:	6a 00                	push   $0x0
80107003:	50                   	push   %eax
80107004:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107007:	e8 34 dd ff ff       	call   80104d40 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010700c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010700f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107012:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107018:	83 c8 07             	or     $0x7,%eax
8010701b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010701d:	89 d8                	mov    %ebx,%eax
8010701f:	c1 e8 0a             	shr    $0xa,%eax
80107022:	25 fc 0f 00 00       	and    $0xffc,%eax
80107027:	01 d0                	add    %edx,%eax
80107029:	eb 90                	jmp    80106fbb <mappages+0x4b>
8010702b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80107030:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107038:	5b                   	pop    %ebx
80107039:	5e                   	pop    %esi
8010703a:	5f                   	pop    %edi
8010703b:	5d                   	pop    %ebp
8010703c:	c3                   	ret
8010703d:	8d 76 00             	lea    0x0(%esi),%esi
80107040:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107043:	31 c0                	xor    %eax,%eax
}
80107045:	5b                   	pop    %ebx
80107046:	5e                   	pop    %esi
80107047:	5f                   	pop    %edi
80107048:	5d                   	pop    %ebp
80107049:	c3                   	ret
      panic("remap");
8010704a:	83 ec 0c             	sub    $0xc,%esp
8010704d:	68 6c 87 10 80       	push   $0x8010876c
80107052:	e8 29 93 ff ff       	call   80100380 <panic>
80107057:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010705e:	00 
8010705f:	90                   	nop

80107060 <seginit>:
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107066:	e8 95 c9 ff ff       	call   80103a00 <cpuid>
  pd[0] = size-1;
8010706b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107070:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107076:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
8010707a:	c7 80 38 28 11 80 ff 	movl   $0xffff,-0x7feed7c8(%eax)
80107081:	ff 00 00 
80107084:	c7 80 3c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7c4(%eax)
8010708b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010708e:	c7 80 40 28 11 80 ff 	movl   $0xffff,-0x7feed7c0(%eax)
80107095:	ff 00 00 
80107098:	c7 80 44 28 11 80 00 	movl   $0xcf9200,-0x7feed7bc(%eax)
8010709f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070a2:	c7 80 48 28 11 80 ff 	movl   $0xffff,-0x7feed7b8(%eax)
801070a9:	ff 00 00 
801070ac:	c7 80 4c 28 11 80 00 	movl   $0xcffa00,-0x7feed7b4(%eax)
801070b3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801070b6:	c7 80 50 28 11 80 ff 	movl   $0xffff,-0x7feed7b0(%eax)
801070bd:	ff 00 00 
801070c0:	c7 80 54 28 11 80 00 	movl   $0xcff200,-0x7feed7ac(%eax)
801070c7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801070ca:	05 30 28 11 80       	add    $0x80112830,%eax
  pd[1] = (uint)p;
801070cf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801070d3:	c1 e8 10             	shr    $0x10,%eax
801070d6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801070da:	8d 45 f2             	lea    -0xe(%ebp),%eax
801070dd:	0f 01 10             	lgdtl  (%eax)
}
801070e0:	c9                   	leave
801070e1:	c3                   	ret
801070e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070e9:	00 
801070ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070f0 <walkpgdir>:
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
801070f6:	83 ec 0c             	sub    $0xc,%esp
801070f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
801070fc:	8b 55 08             	mov    0x8(%ebp),%edx
801070ff:	89 fe                	mov    %edi,%esi
80107101:	c1 ee 16             	shr    $0x16,%esi
80107104:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80107107:	8b 1e                	mov    (%esi),%ebx
80107109:	f6 c3 01             	test   $0x1,%bl
8010710c:	74 22                	je     80107130 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010710e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107114:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
8010711a:	89 f8                	mov    %edi,%eax
}
8010711c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010711f:	c1 e8 0a             	shr    $0xa,%eax
80107122:	25 fc 0f 00 00       	and    $0xffc,%eax
80107127:	01 d8                	add    %ebx,%eax
}
80107129:	5b                   	pop    %ebx
8010712a:	5e                   	pop    %esi
8010712b:	5f                   	pop    %edi
8010712c:	5d                   	pop    %ebp
8010712d:	c3                   	ret
8010712e:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107130:	8b 45 10             	mov    0x10(%ebp),%eax
80107133:	85 c0                	test   %eax,%eax
80107135:	74 31                	je     80107168 <walkpgdir+0x78>
80107137:	e8 d4 b5 ff ff       	call   80102710 <kalloc>
8010713c:	89 c3                	mov    %eax,%ebx
8010713e:	85 c0                	test   %eax,%eax
80107140:	74 26                	je     80107168 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80107142:	83 ec 04             	sub    $0x4,%esp
80107145:	68 00 10 00 00       	push   $0x1000
8010714a:	6a 00                	push   $0x0
8010714c:	50                   	push   %eax
8010714d:	e8 ee db ff ff       	call   80104d40 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107152:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107158:	83 c4 10             	add    $0x10,%esp
8010715b:	83 c8 07             	or     $0x7,%eax
8010715e:	89 06                	mov    %eax,(%esi)
80107160:	eb b8                	jmp    8010711a <walkpgdir+0x2a>
80107162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80107168:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
8010716b:	31 c0                	xor    %eax,%eax
}
8010716d:	5b                   	pop    %ebx
8010716e:	5e                   	pop    %esi
8010716f:	5f                   	pop    %edi
80107170:	5d                   	pop    %ebp
80107171:	c3                   	ret
80107172:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107179:	00 
8010717a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107180 <switchkvm>:
  lcr3(V2P(kpgdir));   
80107180:	a1 e4 57 11 80       	mov    0x801157e4,%eax
80107185:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010718a:	0f 22 d8             	mov    %eax,%cr3
}
8010718d:	c3                   	ret
8010718e:	66 90                	xchg   %ax,%ax

80107190 <switchuvm>:
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	53                   	push   %ebx
80107196:	83 ec 1c             	sub    $0x1c,%esp
80107199:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010719c:	85 f6                	test   %esi,%esi
8010719e:	0f 84 cb 00 00 00    	je     8010726f <switchuvm+0xdf>
  if(p->kstack == 0)
801071a4:	8b 46 08             	mov    0x8(%esi),%eax
801071a7:	85 c0                	test   %eax,%eax
801071a9:	0f 84 da 00 00 00    	je     80107289 <switchuvm+0xf9>
  if(p->pgdir == 0)
801071af:	8b 46 04             	mov    0x4(%esi),%eax
801071b2:	85 c0                	test   %eax,%eax
801071b4:	0f 84 c2 00 00 00    	je     8010727c <switchuvm+0xec>
  pushcli();
801071ba:	e8 31 d9 ff ff       	call   80104af0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071bf:	e8 dc c7 ff ff       	call   801039a0 <mycpu>
801071c4:	89 c3                	mov    %eax,%ebx
801071c6:	e8 d5 c7 ff ff       	call   801039a0 <mycpu>
801071cb:	89 c7                	mov    %eax,%edi
801071cd:	e8 ce c7 ff ff       	call   801039a0 <mycpu>
801071d2:	83 c7 08             	add    $0x8,%edi
801071d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071d8:	e8 c3 c7 ff ff       	call   801039a0 <mycpu>
801071dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071e0:	ba 67 00 00 00       	mov    $0x67,%edx
801071e5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801071ec:	83 c0 08             	add    $0x8,%eax
801071ef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071f6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071fb:	83 c1 08             	add    $0x8,%ecx
801071fe:	c1 e8 18             	shr    $0x18,%eax
80107201:	c1 e9 10             	shr    $0x10,%ecx
80107204:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010720a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107210:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107215:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010721c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107221:	e8 7a c7 ff ff       	call   801039a0 <mycpu>
80107226:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010722d:	e8 6e c7 ff ff       	call   801039a0 <mycpu>
80107232:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107236:	8b 5e 08             	mov    0x8(%esi),%ebx
80107239:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010723f:	e8 5c c7 ff ff       	call   801039a0 <mycpu>
80107244:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107247:	e8 54 c7 ff ff       	call   801039a0 <mycpu>
8010724c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107250:	b8 28 00 00 00       	mov    $0x28,%eax
80107255:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  
80107258:	8b 46 04             	mov    0x4(%esi),%eax
8010725b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107260:	0f 22 d8             	mov    %eax,%cr3
}
80107263:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107266:	5b                   	pop    %ebx
80107267:	5e                   	pop    %esi
80107268:	5f                   	pop    %edi
80107269:	5d                   	pop    %ebp
  popcli();
8010726a:	e9 d1 d8 ff ff       	jmp    80104b40 <popcli>
    panic("switchuvm: no process");
8010726f:	83 ec 0c             	sub    $0xc,%esp
80107272:	68 72 87 10 80       	push   $0x80108772
80107277:	e8 04 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010727c:	83 ec 0c             	sub    $0xc,%esp
8010727f:	68 9d 87 10 80       	push   $0x8010879d
80107284:	e8 f7 90 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107289:	83 ec 0c             	sub    $0xc,%esp
8010728c:	68 88 87 10 80       	push   $0x80108788
80107291:	e8 ea 90 ff ff       	call   80100380 <panic>
80107296:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010729d:	00 
8010729e:	66 90                	xchg   %ax,%ax

801072a0 <inituvm>:
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
801072a6:	83 ec 1c             	sub    $0x1c,%esp
801072a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801072ac:	8b 75 10             	mov    0x10(%ebp),%esi
801072af:	8b 7d 08             	mov    0x8(%ebp),%edi
801072b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (sz < PGSIZE) {
801072b5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801072bb:	77 68                	ja     80107325 <inituvm+0x85>
  char *ptr = kalloc();
801072bd:	e8 4e b4 ff ff       	call   80102710 <kalloc>
801072c2:	89 c3                	mov    %eax,%ebx
  if (ptr) {
801072c4:	85 c0                	test   %eax,%eax
801072c6:	74 3f                	je     80107307 <inituvm+0x67>
          memset(ptr, 0, size);
801072c8:	83 ec 04             	sub    $0x4,%esp
801072cb:	68 00 10 00 00       	push   $0x1000
801072d0:	6a 00                	push   $0x0
801072d2:	50                   	push   %eax
801072d3:	e8 68 da ff ff       	call   80104d40 <memset>
      if (pgdir != 0) {
801072d8:	83 c4 10             	add    $0x10,%esp
801072db:	85 ff                	test   %edi,%edi
801072dd:	74 28                	je     80107307 <inituvm+0x67>
              mappages(pgdir, 0, PGSIZE, V2P(mem), flags);
801072df:	83 ec 08             	sub    $0x8,%esp
801072e2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072e8:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072ed:	31 d2                	xor    %edx,%edx
801072ef:	6a 06                	push   $0x6
801072f1:	50                   	push   %eax
801072f2:	89 f8                	mov    %edi,%eax
801072f4:	e8 77 fc ff ff       	call   80106f70 <mappages>
                  if (init != 0) {
801072f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072fc:	83 c4 10             	add    $0x10,%esp
801072ff:	85 c0                	test   %eax,%eax
80107301:	74 04                	je     80107307 <inituvm+0x67>
80107303:	85 f6                	test   %esi,%esi
80107305:	75 09                	jne    80107310 <inituvm+0x70>
}
80107307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010730a:	5b                   	pop    %ebx
8010730b:	5e                   	pop    %esi
8010730c:	5f                   	pop    %edi
8010730d:	5d                   	pop    %ebp
8010730e:	c3                   	ret
8010730f:	90                   	nop
                      memmove(mem, init, sz);
80107310:	89 75 10             	mov    %esi,0x10(%ebp)
80107313:	89 45 0c             	mov    %eax,0xc(%ebp)
80107316:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107319:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010731c:	5b                   	pop    %ebx
8010731d:	5e                   	pop    %esi
8010731e:	5f                   	pop    %edi
8010731f:	5d                   	pop    %ebp
                      memmove(mem, init, sz);
80107320:	e9 ab da ff ff       	jmp    80104dd0 <memmove>
          panic("inituvm: more than a page");
80107325:	83 ec 0c             	sub    $0xc,%esp
80107328:	68 b1 87 10 80       	push   $0x801087b1
8010732d:	e8 4e 90 ff ff       	call   80100380 <panic>
80107332:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107339:	00 
8010733a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107340 <loaduvm>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	83 ec 0c             	sub    $0xc,%esp
  if (!check_alignment((uint)addr, PGSIZE)) {
80107349:	8b 75 0c             	mov    0xc(%ebp),%esi
8010734c:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107352:	0f 85 ad 00 00 00    	jne    80107405 <loaduvm+0xc5>
      if (current_offset >= sz) {
80107358:	8b 45 18             	mov    0x18(%ebp),%eax
8010735b:	85 c0                	test   %eax,%eax
8010735d:	0f 84 88 00 00 00    	je     801073eb <loaduvm+0xab>
  uint remaining_size = sz;
80107363:	8b 7d 18             	mov    0x18(%ebp),%edi
80107366:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010736d:	00 
8010736e:	66 90                	xchg   %ax,%ax
  pde = &pgdir[PDX(va)];
80107370:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107373:	8b 55 08             	mov    0x8(%ebp),%edx
80107376:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107378:	89 c1                	mov    %eax,%ecx
8010737a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010737d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80107380:	f6 c1 01             	test   $0x1,%cl
80107383:	75 13                	jne    80107398 <loaduvm+0x58>
                  panic("loaduvm: address should exist");
80107385:	83 ec 0c             	sub    $0xc,%esp
80107388:	68 cb 87 10 80       	push   $0x801087cb
8010738d:	e8 ee 8f ff ff       	call   80100380 <panic>
80107392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107398:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010739b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801073a1:	25 fc 0f 00 00       	and    $0xffc,%eax
801073a6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
          if (pte == 0) {
801073ad:	85 c9                	test   %ecx,%ecx
801073af:	74 d4                	je     80107385 <loaduvm+0x45>
      if (remaining_size < PGSIZE) {
801073b1:	bb 00 10 00 00       	mov    $0x1000,%ebx
801073b6:	39 df                	cmp    %ebx,%edi
801073b8:	0f 46 df             	cmovbe %edi,%ebx
          int bytes_read = readi(ip, P2V(phys_addr_copy), offset + current_offset, chunk_size);
801073bb:	53                   	push   %ebx
801073bc:	8b 45 14             	mov    0x14(%ebp),%eax
801073bf:	01 f0                	add    %esi,%eax
801073c1:	50                   	push   %eax
      physical_addr = PTE_ADDR(*pte);
801073c2:	8b 01                	mov    (%ecx),%eax
801073c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          int bytes_read = readi(ip, P2V(phys_addr_copy), offset + current_offset, chunk_size);
801073c9:	05 00 00 00 80       	add    $0x80000000,%eax
801073ce:	50                   	push   %eax
801073cf:	ff 75 10             	push   0x10(%ebp)
801073d2:	e8 49 a7 ff ff       	call   80101b20 <readi>
          if (bytes_read != chunk_size) {
801073d7:	83 c4 10             	add    $0x10,%esp
801073da:	39 d8                	cmp    %ebx,%eax
801073dc:	75 1a                	jne    801073f8 <loaduvm+0xb8>
      remaining_size = remaining_size - chunk_size;
801073de:	29 c7                	sub    %eax,%edi
          current_offset = current_offset + PGSIZE;
801073e0:	81 c6 00 10 00 00    	add    $0x1000,%esi
      if (current_offset >= sz) {
801073e6:	3b 75 18             	cmp    0x18(%ebp),%esi
801073e9:	72 85                	jb     80107370 <loaduvm+0x30>
}
801073eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  int result = 0;
801073ee:	31 c0                	xor    %eax,%eax
}
801073f0:	5b                   	pop    %ebx
801073f1:	5e                   	pop    %esi
801073f2:	5f                   	pop    %edi
801073f3:	5d                   	pop    %ebp
801073f4:	c3                   	ret
801073f5:	8d 76 00             	lea    0x0(%esi),%esi
801073f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
                  result = -1;
801073fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107400:	5b                   	pop    %ebx
80107401:	5e                   	pop    %esi
80107402:	5f                   	pop    %edi
80107403:	5d                   	pop    %ebp
80107404:	c3                   	ret
          panic("loaduvm: addr must be page aligned");
80107405:	83 ec 0c             	sub    $0xc,%esp
80107408:	68 c4 89 10 80       	push   $0x801089c4
8010740d:	e8 6e 8f ff ff       	call   80100380 <panic>
80107412:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107419:	00 
8010741a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107420 <allocuvm>:
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
80107426:	83 ec 1c             	sub    $0x1c,%esp
80107429:	8b 75 10             	mov    0x10(%ebp),%esi
  if (newsz >= KERNBASE) {
8010742c:	85 f6                	test   %esi,%esi
8010742e:	0f 88 a9 00 00 00    	js     801074dd <allocuvm+0xbd>
80107434:	89 f2                	mov    %esi,%edx
  if (newsz < oldsz) {
80107436:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107439:	0f 82 b1 00 00 00    	jb     801074f0 <allocuvm+0xd0>
      current_addr = PGROUNDUP(current_addr);
8010743f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107442:	05 ff 0f 00 00       	add    $0xfff,%eax
80107447:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010744c:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107453:	0f 44 45 0c          	cmove  0xc(%ebp),%eax
80107457:	89 c7                	mov    %eax,%edi
      if (current_addr >= newsz) {
80107459:	39 f0                	cmp    %esi,%eax
8010745b:	0f 83 92 00 00 00    	jae    801074f3 <allocuvm+0xd3>
80107461:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107464:	eb 45                	jmp    801074ab <allocuvm+0x8b>
80107466:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010746d:	00 
8010746e:	66 90                	xchg   %ax,%ax
          memset(ptr, 0, size);
80107470:	83 ec 04             	sub    $0x4,%esp
80107473:	68 00 10 00 00       	push   $0x1000
80107478:	6a 00                	push   $0x0
8010747a:	50                   	push   %eax
8010747b:	e8 c0 d8 ff ff       	call   80104d40 <memset>
  if (mappages(pgdir, (char*)addr, PGSIZE, V2P(*mem_ptr), PTE_W|PTE_U) < 0) {
80107480:	58                   	pop    %eax
80107481:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107487:	5a                   	pop    %edx
80107488:	6a 06                	push   $0x6
8010748a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010748f:	89 fa                	mov    %edi,%edx
80107491:	50                   	push   %eax
80107492:	8b 45 08             	mov    0x8(%ebp),%eax
80107495:	e8 d6 fa ff ff       	call   80106f70 <mappages>
8010749a:	83 c4 10             	add    $0x10,%esp
8010749d:	85 c0                	test   %eax,%eax
8010749f:	78 5f                	js     80107500 <allocuvm+0xe0>
          current_addr = current_addr + PGSIZE;
801074a1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      if (current_addr >= newsz) {
801074a7:	39 f7                	cmp    %esi,%edi
801074a9:	73 65                	jae    80107510 <allocuvm+0xf0>
  mightyPageSwapMechanism();
801074ab:	e8 80 0b 00 00       	call   80108030 <mightyPageSwapMechanism>
  char *ptr = kalloc();
801074b0:	e8 5b b2 ff ff       	call   80102710 <kalloc>
801074b5:	89 c3                	mov    %eax,%ebx
  if (ptr) {
801074b7:	85 c0                	test   %eax,%eax
801074b9:	75 b5                	jne    80107470 <allocuvm+0x50>
              cprintf("allocuvm is now out of memory\n");
801074bb:	83 ec 0c             	sub    $0xc,%esp
801074be:	68 e8 89 10 80       	push   $0x801089e8
801074c3:	e8 e8 91 ff ff       	call   801006b0 <cprintf>
  if (newsz >= oldsz) {
801074c8:	83 c4 10             	add    $0x10,%esp
801074cb:	3b 75 0c             	cmp    0xc(%ebp),%esi
801074ce:	74 0d                	je     801074dd <allocuvm+0xbd>
801074d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074d3:	8b 45 08             	mov    0x8(%ebp),%eax
801074d6:	89 f2                	mov    %esi,%edx
801074d8:	e8 c3 f9 ff ff       	call   80106ea0 <deallocuvm.part.0>
}
801074dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
          return 0;
801074e0:	31 d2                	xor    %edx,%edx
}
801074e2:	5b                   	pop    %ebx
801074e3:	89 d0                	mov    %edx,%eax
801074e5:	5e                   	pop    %esi
801074e6:	5f                   	pop    %edi
801074e7:	5d                   	pop    %ebp
801074e8:	c3                   	ret
801074e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          return oldsz;
801074f0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801074f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074f6:	89 d0                	mov    %edx,%eax
801074f8:	5b                   	pop    %ebx
801074f9:	5e                   	pop    %esi
801074fa:	5f                   	pop    %edi
801074fb:	5d                   	pop    %ebp
801074fc:	c3                   	ret
801074fd:	8d 76 00             	lea    0x0(%esi),%esi
      kfree(*mem_ptr);
80107500:	83 ec 0c             	sub    $0xc,%esp
80107503:	53                   	push   %ebx
80107504:	e8 07 b0 ff ff       	call   80102510 <kfree>
80107509:	83 c4 10             	add    $0x10,%esp
8010750c:	eb ad                	jmp    801074bb <allocuvm+0x9b>
8010750e:	66 90                	xchg   %ax,%ax
80107510:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80107513:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107516:	5b                   	pop    %ebx
80107517:	5e                   	pop    %esi
80107518:	89 d0                	mov    %edx,%eax
8010751a:	5f                   	pop    %edi
8010751b:	5d                   	pop    %ebp
8010751c:	c3                   	ret
8010751d:	8d 76 00             	lea    0x0(%esi),%esi

80107520 <deallocuvm>:
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	8b 55 0c             	mov    0xc(%ebp),%edx
80107526:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107529:	8b 45 08             	mov    0x8(%ebp),%eax
  if (newsz >= oldsz) {
8010752c:	39 d1                	cmp    %edx,%ecx
8010752e:	73 10                	jae    80107540 <deallocuvm+0x20>
}
80107530:	5d                   	pop    %ebp
80107531:	e9 6a f9 ff ff       	jmp    80106ea0 <deallocuvm.part.0>
80107536:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010753d:	00 
8010753e:	66 90                	xchg   %ax,%ax
80107540:	89 d0                	mov    %edx,%eax
80107542:	5d                   	pop    %ebp
80107543:	c3                   	ret
80107544:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010754b:	00 
8010754c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107550 <freevm>:


void
freevm(pde_t *pgdir)
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	56                   	push   %esi
80107554:	53                   	push   %ebx
80107555:	8b 75 08             	mov    0x8(%ebp),%esi
  uint index = 0;
  int entries_processed = 0;
  
  
  if (pgdir == 0) {
80107558:	85 f6                	test   %esi,%esi
8010755a:	74 7f                	je     801075db <freevm+0x8b>
  if (newsz >= oldsz) {
8010755c:	31 c9                	xor    %ecx,%ecx
8010755e:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107563:	89 f0                	mov    %esi,%eax
  uint index = 0;
80107565:	31 db                	xor    %ebx,%ebx
80107567:	e8 34 f9 ff ff       	call   80106ea0 <deallocuvm.part.0>
freevm(pde_t *pgdir)
8010756c:	eb 35                	jmp    801075a3 <freevm+0x53>
8010756e:	66 90                	xchg   %ax,%ax
      }
      
      
      if (index % 2 == 0) {
          
          if (pgdir[index] & PTE_P) {
80107570:	a8 01                	test   $0x1,%al
80107572:	74 24                	je     80107598 <freevm+0x48>
              char *virt_addr = P2V(PTE_ADDR(pgdir[index]));
80107574:	25 00 f0 ff ff       	and    $0xfffff000,%eax
              if (virt_addr != 0) {
80107579:	3d 00 00 00 80       	cmp    $0x80000000,%eax
8010757e:	74 18                	je     80107598 <freevm+0x48>
                  kfree(virt_addr);
80107580:	83 ec 0c             	sub    $0xc,%esp
              char *virt_addr = P2V(PTE_ADDR(pgdir[index]));
80107583:	05 00 00 00 80       	add    $0x80000000,%eax
                  kfree(virt_addr);
80107588:	50                   	push   %eax
80107589:	e8 82 af ff ff       	call   80102510 <kfree>
8010758e:	83 c4 10             	add    $0x10,%esp
80107591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
              }
          }
      }
      
      
      if (index < NPDENTRIES - 1) {
80107598:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
8010759e:	74 2d                	je     801075cd <freevm+0x7d>
          index++;
801075a0:	83 c3 01             	add    $0x1,%ebx
          if (pgdir[index] & PTE_P) {
801075a3:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
      if (index % 2 == 0) {
801075a6:	f6 c3 01             	test   $0x1,%bl
801075a9:	74 c5                	je     80107570 <freevm+0x20>
              if (pgdir[index] & PTE_P) {
801075ab:	a8 01                	test   $0x1,%al
801075ad:	74 e9                	je     80107598 <freevm+0x48>
                  uint phys_addr = PTE_ADDR(pgdir[index]);
801075af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
                  kfree(virt_addr);
801075b4:	83 ec 0c             	sub    $0xc,%esp
                  char *virt_addr = P2V(phys_addr);
801075b7:	05 00 00 00 80       	add    $0x80000000,%eax
                  kfree(virt_addr);
801075bc:	50                   	push   %eax
801075bd:	e8 4e af ff ff       	call   80102510 <kfree>
801075c2:	83 c4 10             	add    $0x10,%esp
      if (index < NPDENTRIES - 1) {
801075c5:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
801075cb:	75 d3                	jne    801075a0 <freevm+0x50>
      }
  }
  
  
  if (pgdir != 0) {
      kfree((char*)pgdir);
801075cd:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
801075d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075d3:	5b                   	pop    %ebx
801075d4:	5e                   	pop    %esi
801075d5:	5d                   	pop    %ebp
      kfree((char*)pgdir);
801075d6:	e9 35 af ff ff       	jmp    80102510 <kfree>
          panic("freevm: no pgdir");
801075db:	83 ec 0c             	sub    $0xc,%esp
801075de:	68 e9 87 10 80       	push   $0x801087e9
801075e3:	e8 98 8d ff ff       	call   80100380 <panic>
801075e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075ef:	00 

801075f0 <setupkvm>:
{
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	56                   	push   %esi
801075f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801075f5:	e8 16 b1 ff ff       	call   80102710 <kalloc>
801075fa:	85 c0                	test   %eax,%eax
801075fc:	74 5e                	je     8010765c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801075fe:	83 ec 04             	sub    $0x4,%esp
80107601:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107603:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107608:	68 00 10 00 00       	push   $0x1000
8010760d:	6a 00                	push   $0x0
8010760f:	50                   	push   %eax
80107610:	e8 2b d7 ff ff       	call   80104d40 <memset>
80107615:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107618:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010761b:	83 ec 08             	sub    $0x8,%esp
8010761e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107621:	8b 13                	mov    (%ebx),%edx
80107623:	ff 73 0c             	push   0xc(%ebx)
80107626:	50                   	push   %eax
80107627:	29 c1                	sub    %eax,%ecx
80107629:	89 f0                	mov    %esi,%eax
8010762b:	e8 40 f9 ff ff       	call   80106f70 <mappages>
80107630:	83 c4 10             	add    $0x10,%esp
80107633:	85 c0                	test   %eax,%eax
80107635:	78 19                	js     80107650 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107637:	83 c3 10             	add    $0x10,%ebx
8010763a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107640:	75 d6                	jne    80107618 <setupkvm+0x28>
}
80107642:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107645:	89 f0                	mov    %esi,%eax
80107647:	5b                   	pop    %ebx
80107648:	5e                   	pop    %esi
80107649:	5d                   	pop    %ebp
8010764a:	c3                   	ret
8010764b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107650:	83 ec 0c             	sub    $0xc,%esp
80107653:	56                   	push   %esi
80107654:	e8 f7 fe ff ff       	call   80107550 <freevm>
      return 0;
80107659:	83 c4 10             	add    $0x10,%esp
}
8010765c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010765f:	31 f6                	xor    %esi,%esi
}
80107661:	89 f0                	mov    %esi,%eax
80107663:	5b                   	pop    %ebx
80107664:	5e                   	pop    %esi
80107665:	5d                   	pop    %ebp
80107666:	c3                   	ret
80107667:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010766e:	00 
8010766f:	90                   	nop

80107670 <kvmalloc>:
{
80107670:	55                   	push   %ebp
80107671:	89 e5                	mov    %esp,%ebp
80107673:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107676:	e8 75 ff ff ff       	call   801075f0 <setupkvm>
8010767b:	a3 e4 57 11 80       	mov    %eax,0x801157e4
  lcr3(V2P(kpgdir));   
80107680:	05 00 00 00 80       	add    $0x80000000,%eax
80107685:	0f 22 d8             	mov    %eax,%cr3
}
80107688:	c9                   	leave
80107689:	c3                   	ret
8010768a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107690 <clearpteu>:


void
clearpteu(pde_t *pgdir, char *uva)
{
80107690:	55                   	push   %ebp
80107691:	89 e5                	mov    %esp,%ebp
80107693:	83 ec 08             	sub    $0x8,%esp
80107696:	8b 55 08             	mov    0x8(%ebp),%edx
80107699:	8b 45 0c             	mov    0xc(%ebp),%eax
  pte_t *pte = 0;
  int pte_valid = 0;
  
  
  if (pgdir != 0 && uva != 0) {
8010769c:	85 d2                	test   %edx,%edx
8010769e:	74 2f                	je     801076cf <clearpteu+0x3f>
801076a0:	85 c0                	test   %eax,%eax
801076a2:	74 2b                	je     801076cf <clearpteu+0x3f>
  pde = &pgdir[PDX(va)];
801076a4:	89 c1                	mov    %eax,%ecx
801076a6:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801076a9:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801076ac:	f6 c2 01             	test   $0x1,%dl
801076af:	74 1e                	je     801076cf <clearpteu+0x3f>
  return &pgtab[PTX(va)];
801076b1:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801076ba:	25 fc 0f 00 00       	and    $0xffc,%eax
801076bf:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
      
      pte = 0;
  }
  
  
  if (pte != 0) {
801076c6:	85 c0                	test   %eax,%eax
801076c8:	74 05                	je     801076cf <clearpteu+0x3f>
  }
  
  
  if (pte_valid) {
      uint old_flags = *pte & PTE_U;
      uint new_flags = *pte & ~PTE_U;
801076ca:	83 20 fb             	andl   $0xfffffffb,(%eax)
      } else {
          
          *pte = *pte & ~old_flags;
      }
  }
}
801076cd:	c9                   	leave
801076ce:	c3                   	ret
          panic("clearpteu");
801076cf:	83 ec 0c             	sub    $0xc,%esp
801076d2:	68 fa 87 10 80       	push   $0x801087fa
801076d7:	e8 a4 8c ff ff       	call   80100380 <panic>
801076dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801076e0 <copyuvm>:
}


pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	57                   	push   %edi
801076e4:	56                   	push   %esi
801076e5:	53                   	push   %ebx
801076e6:	83 ec 1c             	sub    $0x1c,%esp
  pte_t *pte;
  uint phys_addr, current_addr, flags;
  int copy_successful = 1;
  
  
  dst_pgdir = setupkvm();
801076e9:	e8 02 ff ff ff       	call   801075f0 <setupkvm>
801076ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (dst_pgdir == 0) {
801076f1:	85 c0                	test   %eax,%eax
801076f3:	0f 84 f5 00 00 00    	je     801077ee <copyuvm+0x10e>
  current_addr = 0;
  
  
  while (1) {
      
      if (current_addr >= sz) {
801076f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801076fc:	85 c9                	test   %ecx,%ecx
801076fe:	0f 84 c0 00 00 00    	je     801077c4 <copyuvm+0xe4>
  current_addr = 0;
80107704:	31 ff                	xor    %edi,%edi
80107706:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010770d:	00 
8010770e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107710:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107713:	89 f8                	mov    %edi,%eax
80107715:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107718:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010771b:	a8 01                	test   $0x1,%al
8010771d:	75 11                	jne    80107730 <copyuvm+0x50>
      if (1) {
          pte = walkpgdir(pgdir, (void *)current_addr, 0);
          
          if (pte == 0) {
              if (1) {
                  panic("copyuvm: pte should exist");
8010771f:	83 ec 0c             	sub    $0xc,%esp
80107722:	68 04 88 10 80       	push   $0x80108804
80107727:	e8 54 8c ff ff       	call   80100380 <panic>
8010772c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107730:	89 fa                	mov    %edi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107732:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107737:	c1 ea 0a             	shr    $0xa,%edx
8010773a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107740:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
          if (pte == 0) {
80107747:	85 c0                	test   %eax,%eax
80107749:	74 d4                	je     8010771f <copyuvm+0x3f>
              }
          }
      }
      
      
      if (!(*pte & PTE_P)) {
8010774b:	8b 30                	mov    (%eax),%esi
8010774d:	f7 c6 01 00 00 00    	test   $0x1,%esi
80107753:	0f 84 a7 00 00 00    	je     80107800 <copyuvm+0x120>
  char *ptr = kalloc();
80107759:	e8 b2 af ff ff       	call   80102710 <kalloc>
8010775e:	89 c3                	mov    %eax,%ebx
  if (ptr) {
80107760:	85 c0                	test   %eax,%eax
80107762:	74 7c                	je     801077e0 <copyuvm+0x100>
          memset(ptr, 0, size);
80107764:	83 ec 04             	sub    $0x4,%esp
80107767:	68 00 10 00 00       	push   $0x1000
8010776c:	6a 00                	push   $0x0
8010776e:	50                   	push   %eax
8010776f:	e8 cc d5 ff ff       	call   80104d40 <memset>
              copy_successful = 0;
          }
      }
      
      
      phys_addr = PTE_ADDR(*pte);
80107774:	89 f0                	mov    %esi,%eax
  memmove(mem, (char*)P2V(phys_addr), PGSIZE);
80107776:	83 c4 0c             	add    $0xc,%esp
      flags = PTE_FLAGS(*pte);
80107779:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
      phys_addr = PTE_ADDR(*pte);
8010777f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  memmove(mem, (char*)P2V(phys_addr), PGSIZE);
80107784:	68 00 10 00 00       	push   $0x1000
80107789:	05 00 00 00 80       	add    $0x80000000,%eax
8010778e:	50                   	push   %eax
8010778f:	53                   	push   %ebx
80107790:	e8 3b d6 ff ff       	call   80104dd0 <memmove>
  if (mappages(dst_pgdir, (void*)virt_addr, PGSIZE, V2P(mem), flags) < 0) {
80107795:	58                   	pop    %eax
80107796:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010779c:	5a                   	pop    %edx
8010779d:	56                   	push   %esi
8010779e:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077a3:	89 fa                	mov    %edi,%edx
801077a5:	50                   	push   %eax
801077a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077a9:	e8 c2 f7 ff ff       	call   80106f70 <mappages>
801077ae:	83 c4 10             	add    $0x10,%esp
801077b1:	85 c0                	test   %eax,%eax
801077b3:	78 1b                	js     801077d0 <copyuvm+0xf0>
          }
      }
      
      
      if (current_addr < sz - PGSIZE) {
          current_addr = current_addr + PGSIZE;
801077b5:	81 c7 00 10 00 00    	add    $0x1000,%edi
      if (current_addr >= sz) {
801077bb:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801077be:	0f 82 4c ff ff ff    	jb     80107710 <copyuvm+0x30>
  } else {
      
      freevm(dst_pgdir);
      return 0;
  }
}
801077c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ca:	5b                   	pop    %ebx
801077cb:	5e                   	pop    %esi
801077cc:	5f                   	pop    %edi
801077cd:	5d                   	pop    %ebp
801077ce:	c3                   	ret
801077cf:	90                   	nop
      kfree(mem);
801077d0:	83 ec 0c             	sub    $0xc,%esp
801077d3:	53                   	push   %ebx
801077d4:	e8 37 ad ff ff       	call   80102510 <kfree>
801077d9:	83 c4 10             	add    $0x10,%esp
801077dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(dst_pgdir);
801077e0:	83 ec 0c             	sub    $0xc,%esp
801077e3:	ff 75 e4             	push   -0x1c(%ebp)
801077e6:	e8 65 fd ff ff       	call   80107550 <freevm>
      return 0;
801077eb:	83 c4 10             	add    $0x10,%esp
          return 0;
801077ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077fb:	5b                   	pop    %ebx
801077fc:	5e                   	pop    %esi
801077fd:	5f                   	pop    %edi
801077fe:	5d                   	pop    %ebp
801077ff:	c3                   	ret
              panic("copyuvm: page not present");
80107800:	83 ec 0c             	sub    $0xc,%esp
80107803:	68 1e 88 10 80       	push   $0x8010881e
80107808:	e8 73 8b ff ff       	call   80100380 <panic>
8010780d:	8d 76 00             	lea    0x0(%esi),%esi

80107810 <uva2ka>:


char*
uva2ka(pde_t *pgdir, char *uva)
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	8b 55 08             	mov    0x8(%ebp),%edx
80107816:	8b 45 0c             	mov    0xc(%ebp),%eax
  uint phys_addr = 0;
  char *kern_addr = 0;
  int permissions_valid = 0;
  
  
  if (pgdir != 0 && uva != 0) {
80107819:	85 d2                	test   %edx,%edx
8010781b:	74 53                	je     80107870 <uva2ka+0x60>
8010781d:	85 c0                	test   %eax,%eax
8010781f:	74 4f                	je     80107870 <uva2ka+0x60>
  pde = &pgdir[PDX(va)];
80107821:	89 c1                	mov    %eax,%ecx
80107823:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107826:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
      pte = walkpgdir(pgdir, uva, 0);
  } else {
      return 0;
80107829:	31 d2                	xor    %edx,%edx
  if(*pde & PTE_P){
8010782b:	f6 c1 01             	test   $0x1,%cl
8010782e:	74 39                	je     80107869 <uva2ka+0x59>
  return &pgtab[PTX(va)];
80107830:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107833:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107839:	25 fc 0f 00 00       	and    $0xffc,%eax
8010783e:	8d 84 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%eax
  }
  
  
  if (pte != 0) {
80107845:	85 c0                	test   %eax,%eax
80107847:	74 20                	je     80107869 <uva2ka+0x59>
      if ((*pte & PTE_P) == 0) {
80107849:	8b 00                	mov    (%eax),%eax
      return 0;
  }
  
  
  if (permissions_valid) {
      if ((*pte & PTE_U) == 0) {
8010784b:	89 c1                	mov    %eax,%ecx
8010784d:	f7 d1                	not    %ecx
8010784f:	83 e1 05             	and    $0x5,%ecx
80107852:	75 15                	jne    80107869 <uva2ka+0x59>
  }
  
  
  if (permissions_valid) {
      phys_addr = PTE_ADDR(*pte);
      if (phys_addr != 0) {
80107854:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107859:	74 0e                	je     80107869 <uva2ka+0x59>
      return 0;
8010785b:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107861:	3d 00 00 00 80       	cmp    $0x80000000,%eax
80107866:	0f 45 d1             	cmovne %ecx,%edx
  if (kern_addr != 0) {
      return kern_addr;
  } else {
      return 0;
  }
}
80107869:	89 d0                	mov    %edx,%eax
8010786b:	5d                   	pop    %ebp
8010786c:	c3                   	ret
8010786d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
80107870:	31 d2                	xor    %edx,%edx
}
80107872:	5d                   	pop    %ebp
80107873:	89 d0                	mov    %edx,%eax
80107875:	c3                   	ret
80107876:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010787d:	00 
8010787e:	66 90                	xchg   %ax,%ax

80107880 <copyout>:


int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
80107886:	83 ec 1c             	sub    $0x1c,%esp
80107889:	8b 7d 14             	mov    0x14(%ebp),%edi
8010788c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  original_len = len;
  
  
  while (1) {
      
      if (len <= 0) {
8010788f:	85 ff                	test   %edi,%edi
80107891:	74 7d                	je     80107910 <copyout+0x90>
      
      virt_addr = (uint)PGROUNDDOWN(va);
      
      
      kernel_addr = 0;
      if (pgdir != 0) {
80107893:	8b 45 08             	mov    0x8(%ebp),%eax
      virt_addr = (uint)PGROUNDDOWN(va);
80107896:	89 ce                	mov    %ecx,%esi
80107898:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
      if (pgdir != 0) {
8010789e:	85 c0                	test   %eax,%eax
801078a0:	75 47                	jne    801078e9 <copyout+0x69>
801078a2:	eb 5b                	jmp    801078ff <copyout+0x7f>
801078a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      
      
      chunk_size = 0;
      if (1) {
          uint offset = va - virt_addr;
          uint remaining = PGSIZE - offset;
801078a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801078ab:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
801078b1:	89 d3                	mov    %edx,%ebx
801078b3:	29 cb                	sub    %ecx,%ebx
          
          if (remaining < len) {
801078b5:	39 fb                	cmp    %edi,%ebx
801078b7:	0f 47 df             	cmova  %edi,%ebx
              }
          }
      }
      
      
      if (chunk_size > 0) {
801078ba:	85 db                	test   %ebx,%ebx
801078bc:	74 27                	je     801078e5 <copyout+0x65>
          uint offset = va - virt_addr;
          if (kernel_addr != 0 && buffer != 0) {
801078be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801078c2:	74 1a                	je     801078de <copyout+0x5e>
          uint offset = va - virt_addr;
801078c4:	29 f1                	sub    %esi,%ecx
              memmove(kernel_addr + offset, buffer, chunk_size);
801078c6:	83 ec 04             	sub    $0x4,%esp
801078c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801078cc:	01 c8                	add    %ecx,%eax
801078ce:	53                   	push   %ebx
801078cf:	ff 75 10             	push   0x10(%ebp)
801078d2:	50                   	push   %eax
801078d3:	e8 f8 d4 ff ff       	call   80104dd0 <memmove>
801078d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801078db:	83 c4 10             	add    $0x10,%esp
      }
      
      
      if (len >= chunk_size) {
          len = len - chunk_size;
          buffer = buffer + chunk_size;
801078de:	01 5d 10             	add    %ebx,0x10(%ebp)
      if (len <= 0) {
801078e1:	29 df                	sub    %ebx,%edi
801078e3:	74 2b                	je     80107910 <copyout+0x90>
{
801078e5:	89 d6                	mov    %edx,%esi
801078e7:	89 d1                	mov    %edx,%ecx
          kernel_addr = uva2ka(pgdir, (char*)virt_addr);
801078e9:	83 ec 08             	sub    $0x8,%esp
801078ec:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801078ef:	56                   	push   %esi
801078f0:	ff 75 08             	push   0x8(%ebp)
801078f3:	e8 18 ff ff ff       	call   80107810 <uva2ka>
801078f8:	83 c4 10             	add    $0x10,%esp
          if (kernel_addr == 0) {
801078fb:	85 c0                	test   %eax,%eax
801078fd:	75 a9                	jne    801078a8 <copyout+0x28>
  if (result == 0) {
      return 0;
  } else {
      return -1;
  }
}
801078ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
                  result = -1;
80107902:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107907:	5b                   	pop    %ebx
80107908:	5e                   	pop    %esi
80107909:	5f                   	pop    %edi
8010790a:	5d                   	pop    %ebp
8010790b:	c3                   	ret
8010790c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107910:	8d 65 f4             	lea    -0xc(%ebp),%esp
  int result = 0;
80107913:	31 c0                	xor    %eax,%eax
}
80107915:	5b                   	pop    %ebx
80107916:	5e                   	pop    %esi
80107917:	5f                   	pop    %edi
80107918:	5d                   	pop    %ebp
80107919:	c3                   	ret
8010791a:	66 90                	xchg   %ax,%ax
8010791c:	66 90                	xchg   %ax,%ax
8010791e:	66 90                	xchg   %ax,%ax

80107920 <mark_slot_as_free>:
char *disk;

extern struct proc *detectVictimProcess(pte_t **, uint *);


void mark_slot_as_free(int idx, int is_free_val) {
80107920:	55                   	push   %ebp
80107921:	89 e5                	mov    %esp,%ebp
80107923:	8b 45 08             	mov    0x8(%ebp),%eax
    if (idx >= 0) {
        if (idx < SWAP_PAGES) {
80107926:	3d 1f 03 00 00       	cmp    $0x31f,%eax
8010792b:	76 03                	jbe    80107930 <mark_slot_as_free+0x10>
                swap_table[idx].is_free = 0;
                swap_table[idx].page_perm = 0;
            }
        }
    }
}
8010792d:	5d                   	pop    %ebp
8010792e:	c3                   	ret
8010792f:	90                   	nop
            if (is_free_val) {
80107930:	8b 55 0c             	mov    0xc(%ebp),%edx
80107933:	85 d2                	test   %edx,%edx
80107935:	74 19                	je     80107950 <mark_slot_as_free+0x30>
                swap_table[idx].page_perm = 0;
80107937:	c7 04 c5 60 58 11 80 	movl   $0x0,-0x7feea7a0(,%eax,8)
8010793e:	00 00 00 00 
                swap_table[idx].is_free = is_free_val;
80107942:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80107945:	5d                   	pop    %ebp
                swap_table[idx].is_free = is_free_val;
80107946:	89 14 c5 64 58 11 80 	mov    %edx,-0x7feea79c(,%eax,8)
}
8010794d:	c3                   	ret
8010794e:	66 90                	xchg   %ax,%ax
                swap_table[idx].is_free = 0;
80107950:	c7 04 c5 64 58 11 80 	movl   $0x0,-0x7feea79c(,%eax,8)
80107957:	00 00 00 00 
}
8010795b:	5d                   	pop    %ebp
                swap_table[idx].page_perm = 0;
8010795c:	c7 04 c5 60 58 11 80 	movl   $0x0,-0x7feea7a0(,%eax,8)
80107963:	00 00 00 00 
}
80107967:	c3                   	ret
80107968:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010796f:	00 

80107970 <initialiseSwapSlots>:


void initialiseSwapSlots()
{
80107970:	55                   	push   %ebp
80107971:	89 e5                	mov    %esp,%ebp
80107973:	83 ec 10             	sub    $0x10,%esp
    int counter = 0;
    int upper_limit = SWAP_PAGES;
    
    
    if (1) {
        initlock(&s_table_lock, "swap lock");
80107976:	68 38 88 10 80       	push   $0x80108838
8010797b:	68 20 58 11 80       	push   $0x80115820
80107980:	e8 cb d0 ff ff       	call   80104a50 <initlock>
80107985:	83 c4 10             	add    $0x10,%esp
    int counter = 0;
80107988:	31 c0                	xor    %eax,%eax
8010798a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                swap_table[idx].is_free = is_free_val;
80107990:	c7 04 c5 64 58 11 80 	movl   $0x1,-0x7feea79c(,%eax,8)
80107997:	01 00 00 00 
                swap_table[idx].page_perm = 0;
8010799b:	c7 04 c5 60 58 11 80 	movl   $0x0,-0x7feea7a0(,%eax,8)
801079a2:	00 00 00 00 
        if (counter >= upper_limit) {
            break;
        }
        
        
        if (counter % 2 == 0) {
801079a6:	a8 01                	test   $0x1,%al
801079a8:	75 07                	jne    801079b1 <initialiseSwapSlots+0x41>
            if (counter < SWAP_PAGES / 2) {
801079aa:	3d 8f 01 00 00       	cmp    $0x18f,%eax
801079af:	7e 0f                	jle    801079c0 <initialiseSwapSlots+0x50>
            int reversed_idx = (SWAP_PAGES - 1) - ((SWAP_PAGES - 1) - counter);
            mark_slot_as_free(reversed_idx, 1);
        }
        
        
        if (counter < upper_limit - 1) {
801079b1:	3d 1f 03 00 00       	cmp    $0x31f,%eax
801079b6:	75 08                	jne    801079c0 <initialiseSwapSlots+0x50>
            if (counter == upper_limit - 1) {
                counter = counter + 1;
            }
        }
    }
}
801079b8:	c9                   	leave
801079b9:	c3                   	ret
801079ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            counter++;
801079c0:	83 c0 01             	add    $0x1,%eax
        if (counter >= upper_limit) {
801079c3:	eb cb                	jmp    80107990 <initialiseSwapSlots+0x20>
801079c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801079cc:	00 
801079cd:	8d 76 00             	lea    0x0(%esi),%esi

801079d0 <check_and_mark_slot>:


int check_and_mark_slot(int start_idx, int end_idx) {
801079d0:	55                   	push   %ebp
801079d1:	89 e5                	mov    %esp,%ebp
801079d3:	8b 45 08             	mov    0x8(%ebp),%eax
801079d6:	8b 55 0c             	mov    0xc(%ebp),%edx
    int result = -1;
    
    if (start_idx < end_idx) {
801079d9:	39 d0                	cmp    %edx,%eax
801079db:	7d 14                	jge    801079f1 <check_and_mark_slot+0x21>
801079dd:	8d 76 00             	lea    0x0(%esi),%esi
        int i = start_idx;
        while (i < end_idx) {
            if (swap_table[i].is_free != 0) {
                if (swap_table[i].is_free == 1) {
801079e0:	83 3c c5 64 58 11 80 	cmpl   $0x1,-0x7feea79c(,%eax,8)
801079e7:	01 
801079e8:	74 16                	je     80107a00 <check_and_mark_slot+0x30>
                    swap_table[i].is_free = 0;
                    result = i;
                    break;
                }
            }
            i++;
801079ea:	83 c0 01             	add    $0x1,%eax
        while (i < end_idx) {
801079ed:	39 c2                	cmp    %eax,%edx
801079ef:	75 ef                	jne    801079e0 <check_and_mark_slot+0x10>
    int result = -1;
801079f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }
    }
    
    return result;
}
801079f6:	5d                   	pop    %ebp
801079f7:	c3                   	ret
801079f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801079ff:	00 
                    swap_table[i].is_free = 0;
80107a00:	c7 04 c5 64 58 11 80 	movl   $0x0,-0x7feea79c(,%eax,8)
80107a07:	00 00 00 00 
}
80107a0b:	5d                   	pop    %ebp
80107a0c:	c3                   	ret
80107a0d:	8d 76 00             	lea    0x0(%esi),%esi

80107a10 <find_releaseSwapSlot>:


int find_releaseSwapSlot(void)
{
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	53                   	push   %ebx
        int i = start_idx;
80107a14:	31 db                	xor    %ebx,%ebx
{
80107a16:	83 ec 10             	sub    $0x10,%esp
    int searched_first_half = 0;
    int searched_second_half = 0;
    
    
    if (1) {
        acquire(&s_table_lock);
80107a19:	68 20 58 11 80       	push   $0x80115820
80107a1e:	e8 1d d2 ff ff       	call   80104c40 <acquire>
80107a23:	83 c4 10             	add    $0x10,%esp
                if (swap_table[i].is_free == 1) {
80107a26:	83 3c dd 64 58 11 80 	cmpl   $0x1,-0x7feea79c(,%ebx,8)
80107a2d:	01 
80107a2e:	74 15                	je     80107a45 <find_releaseSwapSlot+0x35>
            i++;
80107a30:	83 c3 01             	add    $0x1,%ebx
        while (i < end_idx) {
80107a33:	81 fb 90 01 00 00    	cmp    $0x190,%ebx
80107a39:	74 38                	je     80107a73 <find_releaseSwapSlot+0x63>
                if (swap_table[i].is_free == 1) {
80107a3b:	83 3c dd 64 58 11 80 	cmpl   $0x1,-0x7feea79c(,%ebx,8)
80107a42:	01 
80107a43:	75 eb                	jne    80107a30 <find_releaseSwapSlot+0x20>
            
            do {
                if (i < SWAP_PAGES) {
                    if (swap_table[i].is_free == 1) {
                        if (1) {
                            swap_table[i].is_free = 0;
80107a45:	c7 04 dd 64 58 11 80 	movl   $0x0,-0x7feea79c(,%ebx,8)
80107a4c:	00 00 00 00 
    }
    
    
    if (searched_first_half || searched_second_half) {
        if (1) {
            release(&s_table_lock);
80107a50:	83 ec 0c             	sub    $0xc,%esp
80107a53:	68 20 58 11 80       	push   $0x80115820
80107a58:	e8 83 d1 ff ff       	call   80104be0 <release>
            return -1;
        } else {
            return -1; 
        }
    }
}
80107a5d:	89 d8                	mov    %ebx,%eax
80107a5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107a62:	c9                   	leave
80107a63:	c3                   	ret
80107a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                i++;
80107a68:	83 c3 01             	add    $0x1,%ebx
            } while (i < SWAP_PAGES);
80107a6b:	81 fb 20 03 00 00    	cmp    $0x320,%ebx
80107a71:	74 0c                	je     80107a7f <find_releaseSwapSlot+0x6f>
                    if (swap_table[i].is_free == 1) {
80107a73:	83 3c dd 64 58 11 80 	cmpl   $0x1,-0x7feea79c(,%ebx,8)
80107a7a:	01 
80107a7b:	75 eb                	jne    80107a68 <find_releaseSwapSlot+0x58>
80107a7d:	eb c6                	jmp    80107a45 <find_releaseSwapSlot+0x35>
    result = check_and_mark_slot(0, half_way);
80107a7f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80107a84:	eb ca                	jmp    80107a50 <find_releaseSwapSlot+0x40>
80107a86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107a8d:	00 
80107a8e:	66 90                	xchg   %ax,%ax

80107a90 <is_pde_present>:


int is_pde_present(pde_t pde) {
80107a90:	55                   	push   %ebp
80107a91:	89 e5                	mov    %esp,%ebp
    if (pde & PTE_P) {
80107a93:	8b 45 08             	mov    0x8(%ebp),%eax
        return 1;
    } else {
        return 0;
    }
}
80107a96:	5d                   	pop    %ebp
    if (pde & PTE_P) {
80107a97:	83 e0 01             	and    $0x1,%eax
}
80107a9a:	c3                   	ret
80107a9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107aa0 <process_virtual_address>:
        return 0; 
    }
}


void process_virtual_address(pde_t *pgdir, uint va) {
80107aa0:	55                   	push   %ebp
80107aa1:	89 e5                	mov    %esp,%ebp
80107aa3:	83 ec 18             	sub    $0x18,%esp
80107aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aa9:	8b 55 08             	mov    0x8(%ebp),%edx
        pde_idx = va >> 22;
80107aac:	89 c1                	mov    %eax,%ecx
80107aae:	c1 e9 16             	shr    $0x16,%ecx
    if (pgdir != 0) {
80107ab1:	85 d2                	test   %edx,%edx
80107ab3:	74 39                	je     80107aee <process_virtual_address+0x4e>
    if (!is_pde_present(*pde_ptr)) {
80107ab5:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
    if (pde & PTE_P) {
80107ab8:	f6 c2 01             	test   $0x1,%dl
80107abb:	74 31                	je     80107aee <process_virtual_address+0x4e>
    pte_idx = (va >> 12) & 0x3FF;
80107abd:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde_ptr));
80107ac0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107ac6:	25 ff 03 00 00       	and    $0x3ff,%eax
80107acb:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
    if (pgtab != 0) {
80107ad1:	81 fa 00 00 00 80    	cmp    $0x80000000,%edx
80107ad7:	74 15                	je     80107aee <process_virtual_address+0x4e>
    pte_t *pte = traversePgDir(pgdir, va);
    
    if (pte != 0) {
        if (!(*pte & PTE_P)) {
80107ad9:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80107adc:	a8 01                	test   $0x1,%al
80107ade:	75 0e                	jne    80107aee <process_virtual_address+0x4e>
            int slot_num = *pte >> 12;
80107ae0:	c1 e8 0c             	shr    $0xc,%eax



inline int validate_swap_range(int s) {
    if (s > 0) {
        if (s < SWAP_PAGES) {
80107ae3:	8d 50 ff             	lea    -0x1(%eax),%edx
80107ae6:	81 fa 1e 03 00 00    	cmp    $0x31e,%edx
80107aec:	76 02                	jbe    80107af0 <process_virtual_address+0x50>
}
80107aee:	c9                   	leave
80107aef:	c3                   	ret
        
        if (slot >= 0) {
            if (1) {
                
                if (validation_status == 1) {
                    acquire(&s_table_lock);
80107af0:	83 ec 0c             	sub    $0xc,%esp
80107af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107af6:	68 20 58 11 80       	push   $0x80115820
80107afb:	e8 40 d1 ff ff       	call   80104c40 <acquire>
        swap_table[s].page_perm = perm_val;
80107b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
                
                update_slot_metadata(slot, 0, 1);
                
                
                if (validation_status >= 0) {
                    release(&s_table_lock);
80107b03:	83 c4 10             	add    $0x10,%esp
80107b06:	c7 45 08 20 58 11 80 	movl   $0x80115820,0x8(%ebp)
        swap_table[s].page_perm = perm_val;
80107b0d:	c7 04 c5 60 58 11 80 	movl   $0x0,-0x7feea7a0(,%eax,8)
80107b14:	00 00 00 00 
            swap_table[s].is_free = 1;
80107b18:	c7 04 c5 64 58 11 80 	movl   $0x1,-0x7feea79c(,%eax,8)
80107b1f:	01 00 00 00 
}
80107b23:	c9                   	leave
                    release(&s_table_lock);
80107b24:	e9 b7 d0 ff ff       	jmp    80104be0 <release>
80107b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b30 <releaseSwapSpaces>:
{
80107b30:	55                   	push   %ebp
80107b31:	89 e5                	mov    %esp,%ebp
80107b33:	56                   	push   %esi
80107b34:	53                   	push   %ebx
80107b35:	83 ec 10             	sub    $0x10,%esp
80107b38:	8b 45 08             	mov    0x8(%ebp),%eax
    if (p != 0) {
80107b3b:	85 c0                	test   %eax,%eax
80107b3d:	74 23                	je     80107b62 <releaseSwapSpaces+0x32>
        pgdir = p->pgdir;
80107b3f:	8b 70 04             	mov    0x4(%eax),%esi
    uint current_va = va_start;
80107b42:	31 db                	xor    %ebx,%ebx
        if (current_va < (va_end / 2)) {
80107b44:	81 fb ff ff ff 3f    	cmp    $0x3fffffff,%ebx
80107b4a:	0f 86 b5 00 00 00    	jbe    80107c05 <releaseSwapSpaces+0xd5>
    if (pgdir != 0) {
80107b50:	85 f6                	test   %esi,%esi
80107b52:	75 3a                	jne    80107b8e <releaseSwapSpaces+0x5e>
            current_va += PGSIZE;
80107b54:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if (current_va >= va_end) {
80107b5a:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107b60:	75 e2                	jne    80107b44 <releaseSwapSpaces+0x14>
}
80107b62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b65:	5b                   	pop    %ebx
80107b66:	5e                   	pop    %esi
80107b67:	5d                   	pop    %ebp
80107b68:	c3                   	ret
80107b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (s < SWAP_PAGES) {
80107b70:	3d 1f 03 00 00       	cmp    $0x31f,%eax
80107b75:	76 51                	jbe    80107bc8 <releaseSwapSpaces+0x98>
80107b77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107b7e:	00 
80107b7f:	90                   	nop
            current_va += PGSIZE;
80107b80:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if (current_va >= va_end) {
80107b86:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107b8c:	74 d4                	je     80107b62 <releaseSwapSpaces+0x32>
        pde_idx = va >> 22;
80107b8e:	89 d8                	mov    %ebx,%eax
80107b90:	c1 e8 16             	shr    $0x16,%eax
    if (!is_pde_present(*pde_ptr)) {
80107b93:	8b 04 86             	mov    (%esi,%eax,4),%eax
    if (pde & PTE_P) {
80107b96:	a8 01                	test   $0x1,%al
80107b98:	74 e6                	je     80107b80 <releaseSwapSpaces+0x50>
    pte_idx = (va >> 12) & 0x3FF;
80107b9a:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde_ptr));
80107b9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    pte_idx = (va >> 12) & 0x3FF;
80107ba1:	c1 ea 0c             	shr    $0xc,%edx
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde_ptr));
80107ba4:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107baa:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
    if (pgtab != 0) {
80107bb0:	3d 00 00 00 80       	cmp    $0x80000000,%eax
80107bb5:	74 c9                	je     80107b80 <releaseSwapSpaces+0x50>
                if (!(*pte & PTE_P)) {
80107bb7:	8b 04 91             	mov    (%ecx,%edx,4),%eax
80107bba:	a8 01                	test   $0x1,%al
80107bbc:	75 c2                	jne    80107b80 <releaseSwapSpaces+0x50>
                    if (shifted != 0) {
80107bbe:	c1 e8 0c             	shr    $0xc,%eax
80107bc1:	74 bd                	je     80107b80 <releaseSwapSpaces+0x50>
80107bc3:	eb ab                	jmp    80107b70 <releaseSwapSpaces+0x40>
80107bc5:	8d 76 00             	lea    0x0(%esi),%esi
                    acquire(&s_table_lock);
80107bc8:	83 ec 0c             	sub    $0xc,%esp
80107bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107bce:	68 20 58 11 80       	push   $0x80115820
80107bd3:	e8 68 d0 ff ff       	call   80104c40 <acquire>
        swap_table[s].page_perm = perm_val;
80107bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bdb:	c7 04 c5 60 58 11 80 	movl   $0x0,-0x7feea7a0(,%eax,8)
80107be2:	00 00 00 00 
            swap_table[s].is_free = 1;
80107be6:	c7 04 c5 64 58 11 80 	movl   $0x1,-0x7feea79c(,%eax,8)
80107bed:	01 00 00 00 
                    release(&s_table_lock);
80107bf1:	c7 04 24 20 58 11 80 	movl   $0x80115820,(%esp)
80107bf8:	e8 e3 cf ff ff       	call   80104be0 <release>
80107bfd:	83 c4 10             	add    $0x10,%esp
80107c00:	e9 7b ff ff ff       	jmp    80107b80 <releaseSwapSpaces+0x50>
            process_virtual_address(pgdir, current_va);
80107c05:	50                   	push   %eax
80107c06:	50                   	push   %eax
80107c07:	53                   	push   %ebx
            current_va += PGSIZE;
80107c08:	81 c3 00 10 00 00    	add    $0x1000,%ebx
            process_virtual_address(pgdir, current_va);
80107c0e:	56                   	push   %esi
80107c0f:	e8 8c fe ff ff       	call   80107aa0 <process_virtual_address>
            current_va += PGSIZE;
80107c14:	83 c4 10             	add    $0x10,%esp
80107c17:	e9 28 ff ff ff       	jmp    80107b44 <releaseSwapSpaces+0x14>
80107c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107c20 <check_slot_availability>:
int check_slot_availability(int slot) {
80107c20:	55                   	push   %ebp
80107c21:	89 e5                	mov    %esp,%ebp
    if (slot < 0) {
80107c23:	8b 45 08             	mov    0x8(%ebp),%eax
}
80107c26:	5d                   	pop    %ebp
    if (slot < 0) {
80107c27:	f7 d0                	not    %eax
80107c29:	c1 e8 1f             	shr    $0x1f,%eax
}
80107c2c:	c3                   	ret
80107c2d:	8d 76 00             	lea    0x0(%esi),%esi

80107c30 <locate_page_entry>:
pte_t* locate_page_entry(struct proc *proc, uint va, int *valid) {
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
    pte_t *pte = traversePgDir(proc->pgdir, va);
80107c33:	8b 45 08             	mov    0x8(%ebp),%eax
pte_t* locate_page_entry(struct proc *proc, uint va, int *valid) {
80107c36:	8b 55 0c             	mov    0xc(%ebp),%edx
    pte_t *pte = traversePgDir(proc->pgdir, va);
80107c39:	8b 40 04             	mov    0x4(%eax),%eax
        pde_idx = va >> 22;
80107c3c:	89 d1                	mov    %edx,%ecx
80107c3e:	c1 e9 16             	shr    $0x16,%ecx
    if (pgdir != 0) {
80107c41:	85 c0                	test   %eax,%eax
80107c43:	74 4b                	je     80107c90 <locate_page_entry+0x60>
    if (!is_pde_present(*pde_ptr)) {
80107c45:	8b 04 88             	mov    (%eax,%ecx,4),%eax
    if (pde & PTE_P) {
80107c48:	a8 01                	test   $0x1,%al
80107c4a:	74 34                	je     80107c80 <locate_page_entry+0x50>
    pte_idx = (va >> 12) & 0x3FF;
80107c4c:	c1 ea 0c             	shr    $0xc,%edx
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde_ptr));
80107c4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c54:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
80107c5a:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
    if (pgtab != 0) {
80107c60:	3d 00 00 00 80       	cmp    $0x80000000,%eax
80107c65:	74 19                	je     80107c80 <locate_page_entry+0x50>
            return &pgtab[pte_idx];
80107c67:	8d 04 91             	lea    (%ecx,%edx,4),%eax
    *valid = (pte != 0);
80107c6a:	8b 55 10             	mov    0x10(%ebp),%edx
            return &pgtab[pte_idx];
80107c6d:	b9 01 00 00 00       	mov    $0x1,%ecx
    *valid = (pte != 0);
80107c72:	89 0a                	mov    %ecx,(%edx)
}
80107c74:	5d                   	pop    %ebp
80107c75:	c3                   	ret
80107c76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107c7d:	00 
80107c7e:	66 90                	xchg   %ax,%ax
80107c80:	31 c9                	xor    %ecx,%ecx
        return 0; 
80107c82:	31 c0                	xor    %eax,%eax
    *valid = (pte != 0);
80107c84:	8b 55 10             	mov    0x10(%ebp),%edx
80107c87:	89 0a                	mov    %ecx,(%edx)
}
80107c89:	5d                   	pop    %ebp
80107c8a:	c3                   	ret
80107c8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80107c90:	31 c9                	xor    %ecx,%ecx
80107c92:	eb f0                	jmp    80107c84 <locate_page_entry+0x54>
80107c94:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107c9b:	00 
80107c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107ca0 <verify_page_present>:
int verify_page_present(pte_t *pte) {
80107ca0:	55                   	push   %ebp
80107ca1:	31 c0                	xor    %eax,%eax
80107ca3:	89 e5                	mov    %esp,%ebp
80107ca5:	8b 55 08             	mov    0x8(%ebp),%edx
    if (pte) {
80107ca8:	85 d2                	test   %edx,%edx
80107caa:	74 05                	je     80107cb1 <verify_page_present+0x11>
        return (*pte & PTE_P) ? 1 : 0;
80107cac:	8b 02                	mov    (%edx),%eax
80107cae:	83 e0 01             	and    $0x1,%eax
}
80107cb1:	5d                   	pop    %ebp
80107cb2:	c3                   	ret
80107cb3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107cba:	00 
80107cbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107cc0 <write_block_to_disk>:
void write_block_to_disk(char *src, int slot_idx, int block_offset) {
80107cc0:	55                   	push   %ebp
80107cc1:	89 e5                	mov    %esp,%ebp
80107cc3:	57                   	push   %edi
80107cc4:	56                   	push   %esi
80107cc5:	53                   	push   %ebx
80107cc6:	83 ec 0c             	sub    $0xc,%esp
80107cc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
80107ccc:	8b 75 08             	mov    0x8(%ebp),%esi
80107ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
    if (i >= 0 && i < SWAP_BLOCKS_PER_PAGE) {
80107cd2:	83 fb 07             	cmp    $0x7,%ebx
80107cd5:	77 69                	ja     80107d40 <write_block_to_disk+0x80>
            blockno = sb.swap_start + (slot_idx * SWAP_BLOCKS_PER_PAGE) + i;
80107cd7:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80107cdc:	c1 e2 03             	shl    $0x3,%edx
        if (i % 2 == 0) {
80107cdf:	f6 c3 01             	test   $0x1,%bl
80107ce2:	74 6c                	je     80107d50 <write_block_to_disk+0x90>
            blockno = sb.swap_start + (slot_idx * SWAP_BLOCKS_PER_PAGE) + (i - i % 2 + 1);
80107ce4:	8d 44 10 01          	lea    0x1(%eax,%edx,1),%eax
80107ce8:	89 da                	mov    %ebx,%edx
80107cea:	83 e2 fe             	and    $0xfffffffe,%edx
80107ced:	01 d0                	add    %edx,%eax
        struct buf *disk_buf = bread(0, blockno);
80107cef:	83 ec 08             	sub    $0x8,%esp
80107cf2:	50                   	push   %eax
80107cf3:	6a 00                	push   $0x0
80107cf5:	e8 d6 83 ff ff       	call   801000d0 <bread>
        if (disk_buf) {
80107cfa:	83 c4 10             	add    $0x10,%esp
        struct buf *disk_buf = bread(0, blockno);
80107cfd:	89 c7                	mov    %eax,%edi
        if (disk_buf) {
80107cff:	85 c0                	test   %eax,%eax
80107d01:	74 3d                	je     80107d40 <write_block_to_disk+0x80>
            if (src) {
80107d03:	85 f6                	test   %esi,%esi
80107d05:	74 22                	je     80107d29 <write_block_to_disk+0x69>
                memmove(disk_buf->data, src + i * BSIZE, BSIZE);
80107d07:	c1 e3 09             	shl    $0x9,%ebx
80107d0a:	83 ec 04             	sub    $0x4,%esp
80107d0d:	8d 40 5c             	lea    0x5c(%eax),%eax
80107d10:	01 de                	add    %ebx,%esi
80107d12:	68 00 02 00 00       	push   $0x200
80107d17:	56                   	push   %esi
80107d18:	50                   	push   %eax
80107d19:	e8 b2 d0 ff ff       	call   80104dd0 <memmove>
                bwrite(disk_buf);
80107d1e:	89 3c 24             	mov    %edi,(%esp)
80107d21:	e8 8a 84 ff ff       	call   801001b0 <bwrite>
80107d26:	83 c4 10             	add    $0x10,%esp
            brelse(disk_buf);
80107d29:	89 7d 08             	mov    %edi,0x8(%ebp)
}
80107d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d2f:	5b                   	pop    %ebx
80107d30:	5e                   	pop    %esi
80107d31:	5f                   	pop    %edi
80107d32:	5d                   	pop    %ebp
            brelse(disk_buf);
80107d33:	e9 b8 84 ff ff       	jmp    801001f0 <brelse>
80107d38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107d3f:	00 
}
80107d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d43:	5b                   	pop    %ebx
80107d44:	5e                   	pop    %esi
80107d45:	5f                   	pop    %edi
80107d46:	5d                   	pop    %ebp
80107d47:	c3                   	ret
80107d48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107d4f:	00 
            blockno = sb.swap_start + (slot_idx * SWAP_BLOCKS_PER_PAGE) + i;
80107d50:	01 d0                	add    %edx,%eax
80107d52:	01 d8                	add    %ebx,%eax
80107d54:	eb 99                	jmp    80107cef <write_block_to_disk+0x2f>
80107d56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107d5d:	00 
80107d5e:	66 90                	xchg   %ax,%ax

80107d60 <update_swap_metadata>:
void update_swap_metadata(int slot_idx, pte_t *pte, struct proc *proc) {
80107d60:	55                   	push   %ebp
80107d61:	89 e5                	mov    %esp,%ebp
80107d63:	53                   	push   %ebx
80107d64:	8b 45 08             	mov    0x8(%ebp),%eax
80107d67:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
    if (swap_table && slot_idx >= 0 && pte) {
80107d6d:	85 c0                	test   %eax,%eax
80107d6f:	78 40                	js     80107db1 <update_swap_metadata+0x51>
80107d71:	85 d2                	test   %edx,%edx
80107d73:	74 3c                	je     80107db1 <update_swap_metadata+0x51>
        swap_table[slot_idx].page_perm = PTE_FLAGS(*pte) & 0xFFF;
80107d75:	8b 1a                	mov    (%edx),%ebx
        swap_table[slot_idx].is_free = 0;
80107d77:	c7 04 c5 64 58 11 80 	movl   $0x0,-0x7feea79c(,%eax,8)
80107d7e:	00 00 00 00 
        swap_table[slot_idx].page_perm = PTE_FLAGS(*pte) & 0xFFF;
80107d82:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80107d88:	89 1c c5 60 58 11 80 	mov    %ebx,-0x7feea7a0(,%eax,8)
        int perm = *pte & (PTE_W | PTE_U);
80107d8f:	8b 1a                	mov    (%edx),%ebx
        *pte = ((slot_idx & 0xFFFFF) << 12) | (perm & 0xFFF);
80107d91:	c1 e0 0c             	shl    $0xc,%eax
        int perm = *pte & (PTE_W | PTE_U);
80107d94:	83 e3 06             	and    $0x6,%ebx
        *pte = ((slot_idx & 0xFFFFF) << 12) | (perm & 0xFFF);
80107d97:	09 d8                	or     %ebx,%eax
        *pte |= PTE_IS_SWAPPED;
80107d99:	80 cc 02             	or     $0x2,%ah
80107d9c:	89 02                	mov    %eax,(%edx)
        if (proc) {
80107d9e:	85 c9                	test   %ecx,%ecx
80107da0:	74 0f                	je     80107db1 <update_swap_metadata+0x51>
            lcr3(V2P(proc->pgdir));
80107da2:	8b 41 04             	mov    0x4(%ecx),%eax
            proc->rss--;
80107da5:	83 69 7c 01          	subl   $0x1,0x7c(%ecx)
            lcr3(V2P(proc->pgdir));
80107da9:	05 00 00 00 80       	add    $0x80000000,%eax
80107dae:	0f 22 d8             	mov    %eax,%cr3
}
80107db1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107db4:	c9                   	leave
80107db5:	c3                   	ret
80107db6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107dbd:	00 
80107dbe:	66 90                	xchg   %ax,%ax

80107dc0 <swapOutAPage>:
{
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	57                   	push   %edi
80107dc4:	56                   	push   %esi
80107dc5:	53                   	push   %ebx
80107dc6:	83 ec 1c             	sub    $0x1c,%esp
80107dc9:	8b 75 08             	mov    0x8(%ebp),%esi
80107dcc:	8b 7d 10             	mov    0x10(%ebp),%edi
    if (victim_proc != 0) {
80107dcf:	85 f6                	test   %esi,%esi
80107dd1:	0f 84 9a 00 00 00    	je     80107e71 <swapOutAPage+0xb1>
        ctx.slot_idx = find_releaseSwapSlot();
80107dd7:	e8 34 fc ff ff       	call   80107a10 <find_releaseSwapSlot>
80107ddc:	89 c3                	mov    %eax,%ebx
    if (slot < 0) {
80107dde:	85 c0                	test   %eax,%eax
80107de0:	0f 88 8b 00 00 00    	js     80107e71 <swapOutAPage+0xb1>
    ctx.page_va = *va;
80107de6:	8b 07                	mov    (%edi),%eax
    pte_t *pte = traversePgDir(proc->pgdir, va);
80107de8:	8b 56 04             	mov    0x4(%esi),%edx
        pde_idx = va >> 22;
80107deb:	89 c1                	mov    %eax,%ecx
80107ded:	c1 e9 16             	shr    $0x16,%ecx
    if (pgdir != 0) {
80107df0:	85 d2                	test   %edx,%edx
80107df2:	74 7d                	je     80107e71 <swapOutAPage+0xb1>
    if (!is_pde_present(*pde_ptr)) {
80107df4:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
    if (pde & PTE_P) {
80107df7:	f6 c2 01             	test   $0x1,%dl
80107dfa:	74 75                	je     80107e71 <swapOutAPage+0xb1>
    pte_idx = (va >> 12) & 0x3FF;
80107dfc:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t *)P2V(PTE_ADDR(*pde_ptr));
80107dff:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107e05:	25 ff 03 00 00       	and    $0x3ff,%eax
80107e0a:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
    if (pgtab != 0) {
80107e10:	81 fa 00 00 00 80    	cmp    $0x80000000,%edx
80107e16:	74 59                	je     80107e71 <swapOutAPage+0xb1>
            return &pgtab[pte_idx];
80107e18:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80107e1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        return (*pte & PTE_P) ? 1 : 0;
80107e1e:	8b 00                	mov    (%eax),%eax
    if (verify_page_present(ctx.entry)) {
80107e20:	a8 01                	test   $0x1,%al
80107e22:	74 4d                	je     80107e71 <swapOutAPage+0xb1>
        ctx.phys_page = (char *)P2V(PTE_ADDR(*ctx.entry));
80107e24:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    int block_idx = 0;
80107e29:	31 ff                	xor    %edi,%edi
        ctx.phys_page = (char *)P2V(PTE_ADDR(*ctx.entry));
80107e2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107e2e:	05 00 00 00 80       	add    $0x80000000,%eax
80107e33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            if (block_idx >= SWAP_BLOCKS_PER_PAGE) {
80107e36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107e3d:	00 
80107e3e:	66 90                	xchg   %ax,%ax
                write_block_to_disk(ctx.phys_page, ctx.slot_idx, reversed_idx);
80107e40:	83 ec 04             	sub    $0x4,%esp
80107e43:	57                   	push   %edi
            block_idx++;
80107e44:	83 c7 01             	add    $0x1,%edi
                write_block_to_disk(ctx.phys_page, ctx.slot_idx, reversed_idx);
80107e47:	53                   	push   %ebx
80107e48:	ff 75 e4             	push   -0x1c(%ebp)
80107e4b:	e8 70 fe ff ff       	call   80107cc0 <write_block_to_disk>
            if (block_idx >= SWAP_BLOCKS_PER_PAGE) {
80107e50:	83 c4 10             	add    $0x10,%esp
80107e53:	83 ff 08             	cmp    $0x8,%edi
80107e56:	75 e8                	jne    80107e40 <swapOutAPage+0x80>
                    update_swap_metadata(ctx.slot_idx, ctx.entry, victim_proc);
80107e58:	83 ec 04             	sub    $0x4,%esp
80107e5b:	56                   	push   %esi
80107e5c:	ff 75 e0             	push   -0x20(%ebp)
80107e5f:	53                   	push   %ebx
80107e60:	e8 fb fe ff ff       	call   80107d60 <update_swap_metadata>
                    if (ctx.phys_page && ctx.phys_page != 0) {
80107e65:	83 c4 10             	add    $0x10,%esp
80107e68:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
80107e6f:	75 0f                	jne    80107e80 <swapOutAPage+0xc0>
}
80107e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e74:	5b                   	pop    %ebx
80107e75:	5e                   	pop    %esi
80107e76:	5f                   	pop    %edi
80107e77:	5d                   	pop    %ebp
80107e78:	c3                   	ret
80107e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                            kfree(ctx.phys_page);
80107e80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e83:	89 45 08             	mov    %eax,0x8(%ebp)
}
80107e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e89:	5b                   	pop    %ebx
80107e8a:	5e                   	pop    %esi
80107e8b:	5f                   	pop    %edi
80107e8c:	5d                   	pop    %ebp
                            kfree(ctx.phys_page);
80107e8d:	e9 7e a6 ff ff       	jmp    80102510 <kfree>
80107e92:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107e99:	00 
80107e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ea0 <validate_slot>:
int validate_slot(uint slot) {
80107ea0:	55                   	push   %ebp
80107ea1:	31 c0                	xor    %eax,%eax
80107ea3:	89 e5                	mov    %esp,%ebp
80107ea5:	8b 55 08             	mov    0x8(%ebp),%edx
    if (slot >= SWAP_PAGES || swap_table[slot].is_free) {
80107ea8:	81 fa 1f 03 00 00    	cmp    $0x31f,%edx
80107eae:	77 0e                	ja     80107ebe <validate_slot+0x1e>
80107eb0:	8b 14 d5 64 58 11 80 	mov    -0x7feea79c(,%edx,8),%edx
80107eb7:	31 c0                	xor    %eax,%eax
80107eb9:	85 d2                	test   %edx,%edx
80107ebb:	0f 94 c0             	sete   %al
}
80107ebe:	5d                   	pop    %ebp
80107ebf:	c3                   	ret

80107ec0 <read_block_to_mem>:
void read_block_to_mem(char *dest, int blockno, int offset) {
80107ec0:	55                   	push   %ebp
80107ec1:	89 e5                	mov    %esp,%ebp
80107ec3:	57                   	push   %edi
80107ec4:	56                   	push   %esi
80107ec5:	53                   	push   %ebx
80107ec6:	83 ec 0c             	sub    $0xc,%esp
80107ec9:	8b 5d 10             	mov    0x10(%ebp),%ebx
80107ecc:	8b 75 08             	mov    0x8(%ebp),%esi
80107ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
        if (dest != 0) {
80107ed2:	83 fb 07             	cmp    $0x7,%ebx
80107ed5:	7f 04                	jg     80107edb <read_block_to_mem+0x1b>
80107ed7:	85 f6                	test   %esi,%esi
80107ed9:	75 0d                	jne    80107ee8 <read_block_to_mem+0x28>
}
80107edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ede:	5b                   	pop    %ebx
80107edf:	5e                   	pop    %esi
80107ee0:	5f                   	pop    %edi
80107ee1:	5d                   	pop    %ebp
80107ee2:	c3                   	ret
80107ee3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
            buf = bread(0, blockno);
80107ee8:	83 ec 08             	sub    $0x8,%esp
80107eeb:	50                   	push   %eax
80107eec:	6a 00                	push   $0x0
80107eee:	e8 dd 81 ff ff       	call   801000d0 <bread>
            if (buf != 0) {
80107ef3:	83 c4 10             	add    $0x10,%esp
            buf = bread(0, blockno);
80107ef6:	89 c7                	mov    %eax,%edi
            if (buf != 0) {
80107ef8:	85 c0                	test   %eax,%eax
80107efa:	74 df                	je     80107edb <read_block_to_mem+0x1b>
                memmove(dest + offset * BSIZE, buf->data, BSIZE);
80107efc:	c1 e3 09             	shl    $0x9,%ebx
80107eff:	83 ec 04             	sub    $0x4,%esp
80107f02:	8d 40 5c             	lea    0x5c(%eax),%eax
80107f05:	01 de                	add    %ebx,%esi
80107f07:	68 00 02 00 00       	push   $0x200
80107f0c:	50                   	push   %eax
80107f0d:	56                   	push   %esi
80107f0e:	e8 bd ce ff ff       	call   80104dd0 <memmove>
                brelse(buf);
80107f13:	83 c4 10             	add    $0x10,%esp
80107f16:	89 7d 08             	mov    %edi,0x8(%ebp)
}
80107f19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f1c:	5b                   	pop    %ebx
80107f1d:	5e                   	pop    %esi
80107f1e:	5f                   	pop    %edi
80107f1f:	5d                   	pop    %ebp
                brelse(buf);
80107f20:	e9 cb 82 ff ff       	jmp    801001f0 <brelse>
80107f25:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107f2c:	00 
80107f2d:	8d 76 00             	lea    0x0(%esi),%esi

80107f30 <mark_slot_and_update>:
int mark_slot_and_update(struct proc *p, uint slot_num, pte_t *pte, char *mem) {
80107f30:	55                   	push   %ebp
80107f31:	89 e5                	mov    %esp,%ebp
80107f33:	53                   	push   %ebx
80107f34:	83 ec 04             	sub    $0x4,%esp
80107f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (p != 0 && pte != 0) {
80107f3a:	85 db                	test   %ebx,%ebx
80107f3c:	74 07                	je     80107f45 <mark_slot_and_update+0x15>
80107f3e:	8b 55 10             	mov    0x10(%ebp),%edx
80107f41:	85 d2                	test   %edx,%edx
80107f43:	75 0b                	jne    80107f50 <mark_slot_and_update+0x20>
}
80107f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    int result = 0;
80107f48:	31 c0                	xor    %eax,%eax
}
80107f4a:	c9                   	leave
80107f4b:	c3                   	ret
80107f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        *pte = V2P(mem) | swap_table[slot_num].page_perm;
80107f50:	8b 45 14             	mov    0x14(%ebp),%eax
80107f53:	8b 55 0c             	mov    0xc(%ebp),%edx
        acquire(&s_table_lock);
80107f56:	83 ec 0c             	sub    $0xc,%esp
        *pte &= ~PTE_IS_SWAPPED;
80107f59:	8b 4d 10             	mov    0x10(%ebp),%ecx
        *pte = V2P(mem) | swap_table[slot_num].page_perm;
80107f5c:	05 00 00 00 80       	add    $0x80000000,%eax
80107f61:	0b 04 d5 60 58 11 80 	or     -0x7feea7a0(,%edx,8),%eax
        *pte &= ~PTE_IS_SWAPPED;
80107f68:	80 e4 fd             	and    $0xfd,%ah
80107f6b:	83 c8 01             	or     $0x1,%eax
80107f6e:	89 01                	mov    %eax,(%ecx)
        acquire(&s_table_lock);
80107f70:	68 20 58 11 80       	push   $0x80115820
80107f75:	e8 c6 cc ff ff       	call   80104c40 <acquire>
        if (!swap_table[slot_num].is_free) {
80107f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f7d:	83 c4 10             	add    $0x10,%esp
80107f80:	8b 04 c5 64 58 11 80 	mov    -0x7feea79c(,%eax,8),%eax
80107f87:	85 c0                	test   %eax,%eax
80107f89:	75 2d                	jne    80107fb8 <mark_slot_and_update+0x88>
        release(&s_table_lock);
80107f8b:	83 ec 0c             	sub    $0xc,%esp
80107f8e:	68 20 58 11 80       	push   $0x80115820
80107f93:	e8 48 cc ff ff       	call   80104be0 <release>
            lcr3(V2P(p->pgdir));
80107f98:	8b 43 04             	mov    0x4(%ebx),%eax
            p->rss++;
80107f9b:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
            lcr3(V2P(p->pgdir));
80107f9f:	05 00 00 00 80       	add    $0x80000000,%eax
80107fa4:	0f 22 d8             	mov    %eax,%cr3
}
80107fa7:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107fac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107faf:	83 c4 10             	add    $0x10,%esp
80107fb2:	c9                   	leave
80107fb3:	c3                   	ret
80107fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&s_table_lock);
80107fb8:	83 ec 0c             	sub    $0xc,%esp
80107fbb:	68 20 58 11 80       	push   $0x80115820
80107fc0:	e8 1b cc ff ff       	call   80104be0 <release>
80107fc5:	83 c4 10             	add    $0x10,%esp
80107fc8:	e9 78 ff ff ff       	jmp    80107f45 <mark_slot_and_update+0x15>
80107fcd:	8d 76 00             	lea    0x0(%esi),%esi

80107fd0 <releaseSwapSlot>:
int releaseSwapSlot(int slot) {
80107fd0:	55                   	push   %ebp
80107fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fd6:	89 e5                	mov    %esp,%ebp
80107fd8:	53                   	push   %ebx
80107fd9:	83 ec 04             	sub    $0x4,%esp
80107fdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
        if (s < SWAP_PAGES) {
80107fdf:	8d 53 ff             	lea    -0x1(%ebx),%edx
80107fe2:	81 fa 1e 03 00 00    	cmp    $0x31e,%edx
80107fe8:	76 06                	jbe    80107ff0 <releaseSwapSlot+0x20>
            return -1;
        } else {
            return result; 
        }
    }
}
80107fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107fed:	c9                   	leave
80107fee:	c3                   	ret
80107fef:	90                   	nop
                    acquire(&s_table_lock);
80107ff0:	83 ec 0c             	sub    $0xc,%esp
80107ff3:	68 20 58 11 80       	push   $0x80115820
80107ff8:	e8 43 cc ff ff       	call   80104c40 <acquire>
                    release(&s_table_lock);
80107ffd:	c7 04 24 20 58 11 80 	movl   $0x80115820,(%esp)
        swap_table[s].page_perm = perm_val;
80108004:	c7 04 dd 60 58 11 80 	movl   $0x0,-0x7feea7a0(,%ebx,8)
8010800b:	00 00 00 00 
            swap_table[s].is_free = 1;
8010800f:	c7 04 dd 64 58 11 80 	movl   $0x1,-0x7feea79c(,%ebx,8)
80108016:	01 00 00 00 
                    release(&s_table_lock);
8010801a:	e8 c1 cb ff ff       	call   80104be0 <release>
}
8010801f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
                    release(&s_table_lock);
80108022:	83 c4 10             	add    $0x10,%esp
80108025:	31 c0                	xor    %eax,%eax
}
80108027:	c9                   	leave
80108028:	c3                   	ret
80108029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108030 <mightyPageSwapMechanism>:


void mightyPageSwapMechanism(void) {
80108030:	55                   	push   %ebp
80108031:	89 e5                	mov    %esp,%ebp
80108033:	57                   	push   %edi
80108034:	56                   	push   %esi
80108035:	53                   	push   %ebx
80108036:	83 ec 1c             	sub    $0x1c,%esp
    int swap_completed = 0;
    int swap_index = 0;
    int continue_swapping = 1;
    
    
    pages_free = count_free_pages();
80108039:	e8 92 a6 ff ff       	call   801026d0 <count_free_pages>
8010803e:	89 c2                	mov    %eax,%edx
    if (pages_free != 0) {
        pages_free = pages_free; 
    }
    
    
    if (pages_free <= Th) {
80108040:	a1 64 b4 10 80       	mov    0x8010b464,%eax
80108045:	39 d0                	cmp    %edx,%eax
80108047:	7d 0f                	jge    80108058 <mightyPageSwapMechanism+0x28>
            Npg = LIMIT;
        } else {
            Npg = (Npg * (100 + ALPHA)) / 100;
        }
    }
80108049:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010804c:	5b                   	pop    %ebx
8010804d:	5e                   	pop    %esi
8010804e:	5f                   	pop    %edi
8010804f:	5d                   	pop    %ebp
80108050:	c3                   	ret
80108051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                cprintf("Current Threshold = %d, Swapping %d pages\n", Th, Npg);
80108058:	83 ec 04             	sub    $0x4,%esp
8010805b:	ff 35 60 b4 10 80    	push   0x8010b460
80108061:	50                   	push   %eax
80108062:	68 08 8a 10 80       	push   $0x80108a08
80108067:	e8 44 86 ff ff       	call   801006b0 <cprintf>
        if (swap_index >= Npg) {
8010806c:	8b 0d 60 b4 10 80    	mov    0x8010b460,%ecx
80108072:	83 c4 10             	add    $0x10,%esp
80108075:	85 c9                	test   %ecx,%ecx
80108077:	0f 8e 07 01 00 00    	jle    80108184 <mightyPageSwapMechanism+0x154>
8010807d:	31 db                	xor    %ebx,%ebx
8010807f:	8d 7d e4             	lea    -0x1c(%ebp),%edi
80108082:	8d 75 e0             	lea    -0x20(%ebp),%esi
80108085:	eb 5c                	jmp    801080e3 <mightyPageSwapMechanism+0xb3>
80108087:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010808e:	00 
8010808f:	90                   	nop
            victim_proc = detectVictimProcess(&pte, &va);
80108090:	83 ec 08             	sub    $0x8,%esp
            pte_t *pte = 0;
80108093:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            uint *va = 0;
8010809a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            victim_proc = detectVictimProcess(&pte, &va);
801080a1:	57                   	push   %edi
801080a2:	56                   	push   %esi
801080a3:	e8 e8 c5 ff ff       	call   80104690 <detectVictimProcess>
            if (victim_proc != 0) {
801080a8:	83 c4 10             	add    $0x10,%esp
801080ab:	85 c0                	test   %eax,%eax
801080ad:	0f 84 c5 00 00 00    	je     80108178 <mightyPageSwapMechanism+0x148>
                if (pte != 0 && va != 0) {
801080b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
801080b6:	85 d2                	test   %edx,%edx
801080b8:	74 15                	je     801080cf <mightyPageSwapMechanism+0x9f>
801080ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801080bd:	85 c9                	test   %ecx,%ecx
801080bf:	74 0e                	je     801080cf <mightyPageSwapMechanism+0x9f>
            swapOutAPage(victim, p, v);
801080c1:	83 ec 04             	sub    $0x4,%esp
801080c4:	51                   	push   %ecx
801080c5:	52                   	push   %edx
801080c6:	50                   	push   %eax
801080c7:	e8 f4 fc ff ff       	call   80107dc0 <swapOutAPage>
801080cc:	83 c4 10             	add    $0x10,%esp
        if (swap_index < Npg - 1) {
801080cf:	8b 0d 60 b4 10 80    	mov    0x8010b460,%ecx
801080d5:	8d 41 ff             	lea    -0x1(%ecx),%eax
801080d8:	39 d8                	cmp    %ebx,%eax
801080da:	7e 3c                	jle    80108118 <mightyPageSwapMechanism+0xe8>
            swap_index++;
801080dc:	83 c3 01             	add    $0x1,%ebx
        if (swap_index >= Npg) {
801080df:	39 d9                	cmp    %ebx,%ecx
801080e1:	7e 3c                	jle    8010811f <mightyPageSwapMechanism+0xef>
        if (swap_index % 2 == 0) {
801080e3:	f6 c3 01             	test   $0x1,%bl
801080e6:	74 a8                	je     80108090 <mightyPageSwapMechanism+0x60>
            victim_proc = detectVictimProcess(&pte, &va);
801080e8:	83 ec 08             	sub    $0x8,%esp
801080eb:	57                   	push   %edi
801080ec:	56                   	push   %esi
801080ed:	e8 9e c5 ff ff       	call   80104690 <detectVictimProcess>
            if (!victim_proc) {
801080f2:	83 c4 10             	add    $0x10,%esp
801080f5:	85 c0                	test   %eax,%eax
801080f7:	74 7f                	je     80108178 <mightyPageSwapMechanism+0x148>
            swapOutAPage(victim_proc, pte, va);
801080f9:	83 ec 04             	sub    $0x4,%esp
801080fc:	ff 75 e4             	push   -0x1c(%ebp)
801080ff:	ff 75 e0             	push   -0x20(%ebp)
80108102:	50                   	push   %eax
80108103:	e8 b8 fc ff ff       	call   80107dc0 <swapOutAPage>
        if (swap_index < Npg - 1) {
80108108:	8b 0d 60 b4 10 80    	mov    0x8010b460,%ecx
8010810e:	83 c4 10             	add    $0x10,%esp
80108111:	8d 41 ff             	lea    -0x1(%ecx),%eax
80108114:	39 d8                	cmp    %ebx,%eax
80108116:	7f c4                	jg     801080dc <mightyPageSwapMechanism+0xac>
                swap_index = swap_index + 1;
80108118:	0f 44 d9             	cmove  %ecx,%ebx
        if (swap_index >= Npg) {
8010811b:	39 d9                	cmp    %ebx,%ecx
8010811d:	7f c4                	jg     801080e3 <mightyPageSwapMechanism+0xb3>
    Th = update_threshold(Th, BETA);
8010811f:	8b 15 64 b4 10 80    	mov    0x8010b464,%edx
    int dividend = current_th * (100 - beta_factor);
80108125:	6b da 5a             	imul   $0x5a,%edx,%ebx
    if (dividend > 0) {
80108128:	85 db                	test   %ebx,%ebx
8010812a:	7e 0f                	jle    8010813b <mightyPageSwapMechanism+0x10b>
            return dividend / divisor;
8010812c:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80108131:	f7 eb                	imul   %ebx
80108133:	c1 fb 1f             	sar    $0x1f,%ebx
80108136:	c1 fa 05             	sar    $0x5,%edx
80108139:	29 da                	sub    %ebx,%edx
        if (LIMIT < (Npg * (100 + ALPHA)) / 100) {
8010813b:	6b c9 7d             	imul   $0x7d,%ecx,%ecx
    Th = update_threshold(Th, BETA);
8010813e:	89 15 64 b4 10 80    	mov    %edx,0x8010b464
                new_npg = LIMIT;
80108144:	ba 64 00 00 00       	mov    $0x64,%edx
        if (LIMIT < (Npg * (100 + ALPHA)) / 100) {
80108149:	81 f9 73 27 00 00    	cmp    $0x2773,%ecx
8010814f:	7f 13                	jg     80108164 <mightyPageSwapMechanism+0x134>
    if (product > 0) {
80108151:	85 c9                	test   %ecx,%ecx
80108153:	7e 2b                	jle    80108180 <mightyPageSwapMechanism+0x150>
            int new_val = product / divisor;
80108155:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
8010815a:	f7 e9                	imul   %ecx
8010815c:	c1 f9 1f             	sar    $0x1f,%ecx
8010815f:	c1 fa 05             	sar    $0x5,%edx
80108162:	29 ca                	sub    %ecx,%edx
            Npg = new_npg;
80108164:	89 15 60 b4 10 80    	mov    %edx,0x8010b460
8010816a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010816d:	5b                   	pop    %ebx
8010816e:	5e                   	pop    %esi
8010816f:	5f                   	pop    %edi
80108170:	5d                   	pop    %ebp
80108171:	c3                   	ret
80108172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (LIMIT < (Npg * (100 + ALPHA)) / 100) {
80108178:	8b 0d 60 b4 10 80    	mov    0x8010b460,%ecx
8010817e:	eb 9f                	jmp    8010811f <mightyPageSwapMechanism+0xef>
    int result = 0;
80108180:	31 d2                	xor    %edx,%edx
80108182:	eb e0                	jmp    80108164 <mightyPageSwapMechanism+0x134>
    int dividend = current_th * (100 - beta_factor);
80108184:	6b 1d 64 b4 10 80 5a 	imul   $0x5a,0x8010b464,%ebx
    if (dividend > 0) {
8010818b:	85 db                	test   %ebx,%ebx
8010818d:	7e f1                	jle    80108180 <mightyPageSwapMechanism+0x150>
            return dividend / divisor;
8010818f:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
        if (LIMIT < (Npg * (100 + ALPHA)) / 100) {
80108194:	6b c9 7d             	imul   $0x7d,%ecx,%ecx
            return dividend / divisor;
80108197:	f7 eb                	imul   %ebx
80108199:	c1 fb 1f             	sar    $0x1f,%ebx
8010819c:	89 d0                	mov    %edx,%eax
8010819e:	c1 f8 05             	sar    $0x5,%eax
801081a1:	29 d8                	sub    %ebx,%eax
801081a3:	a3 64 b4 10 80       	mov    %eax,0x8010b464
        if (LIMIT < (Npg * (100 + ALPHA)) / 100) {
801081a8:	eb a7                	jmp    80108151 <mightyPageSwapMechanism+0x121>
801081aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801081b0 <prepare_memory>:
int prepare_memory(char **mem_ptr) {
801081b0:	55                   	push   %ebp
801081b1:	89 e5                	mov    %esp,%ebp
801081b3:	83 ec 08             	sub    $0x8,%esp
    mightyPageSwapMechanism();
801081b6:	e8 75 fe ff ff       	call   80108030 <mightyPageSwapMechanism>
    *mem_ptr = kalloc();
801081bb:	e8 50 a5 ff ff       	call   80102710 <kalloc>
801081c0:	8b 55 08             	mov    0x8(%ebp),%edx
801081c3:	89 02                	mov    %eax,(%edx)
    if (*mem_ptr == 0) {
801081c5:	31 d2                	xor    %edx,%edx
801081c7:	85 c0                	test   %eax,%eax
801081c9:	74 18                	je     801081e3 <prepare_memory+0x33>
    memset(*mem_ptr, 0, PGSIZE);
801081cb:	83 ec 04             	sub    $0x4,%esp
801081ce:	68 00 10 00 00       	push   $0x1000
801081d3:	6a 00                	push   $0x0
801081d5:	50                   	push   %eax
801081d6:	e8 65 cb ff ff       	call   80104d40 <memset>
    return 1;
801081db:	83 c4 10             	add    $0x10,%esp
801081de:	ba 01 00 00 00       	mov    $0x1,%edx
}
801081e3:	c9                   	leave
801081e4:	89 d0                	mov    %edx,%eax
801081e6:	c3                   	ret
801081e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801081ee:	00 
801081ef:	90                   	nop

801081f0 <swapInAPage>:
{
801081f0:	55                   	push   %ebp
801081f1:	89 e5                	mov    %esp,%ebp
801081f3:	57                   	push   %edi
801081f4:	56                   	push   %esi
801081f5:	53                   	push   %ebx
801081f6:	83 ec 1c             	sub    $0x1c,%esp
    if (!p || !pte) {
801081f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801081fc:	8b 55 0c             	mov    0xc(%ebp),%edx
    if (!p || !pte) {
801081ff:	85 c0                	test   %eax,%eax
80108201:	0f 84 e9 00 00 00    	je     801082f0 <swapInAPage+0x100>
80108207:	85 d2                	test   %edx,%edx
80108209:	0f 84 e1 00 00 00    	je     801082f0 <swapInAPage+0x100>
    slot_num = ((*pte) & 0xFFFFF000) >> 12;
8010820f:	8b 02                	mov    (%edx),%eax
80108211:	89 c7                	mov    %eax,%edi
80108213:	c1 ef 0c             	shr    $0xc,%edi
80108216:	89 7d dc             	mov    %edi,-0x24(%ebp)
    if (slot >= SWAP_PAGES || swap_table[slot].is_free) {
80108219:	3d ff ff 31 00       	cmp    $0x31ffff,%eax
8010821e:	0f 87 cc 00 00 00    	ja     801082f0 <swapInAPage+0x100>
80108224:	8b 04 fd 64 58 11 80 	mov    -0x7feea79c(,%edi,8),%eax
8010822b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010822e:	85 c0                	test   %eax,%eax
80108230:	0f 85 ba 00 00 00    	jne    801082f0 <swapInAPage+0x100>
    mightyPageSwapMechanism();
80108236:	e8 f5 fd ff ff       	call   80108030 <mightyPageSwapMechanism>
    *mem_ptr = kalloc();
8010823b:	e8 d0 a4 ff ff       	call   80102710 <kalloc>
80108240:	89 45 d8             	mov    %eax,-0x28(%ebp)
80108243:	89 c6                	mov    %eax,%esi
    if (*mem_ptr == 0) {
80108245:	85 c0                	test   %eax,%eax
80108247:	0f 84 a3 00 00 00    	je     801082f0 <swapInAPage+0x100>
    memset(*mem_ptr, 0, PGSIZE);
8010824d:	83 ec 04             	sub    $0x4,%esp
            blockno = sb.swap_start + (slot_num * SWAP_BLOCKS_PER_PAGE) + 
80108250:	c1 e7 03             	shl    $0x3,%edi
    uint slot_num, i = 0;
80108253:	31 db                	xor    %ebx,%ebx
    memset(*mem_ptr, 0, PGSIZE);
80108255:	68 00 10 00 00       	push   $0x1000
8010825a:	6a 00                	push   $0x0
8010825c:	50                   	push   %eax
8010825d:	e8 de ca ff ff       	call   80104d40 <memset>
        if (i >= SWAP_BLOCKS_PER_PAGE) {
80108262:	83 c4 10             	add    $0x10,%esp
80108265:	8d 76 00             	lea    0x0(%esi),%esi
            blockno = sb.swap_start + (slot_num * SWAP_BLOCKS_PER_PAGE) + i;
80108268:	8b 0d e0 25 11 80    	mov    0x801125e0,%ecx
            struct buf *buf = bread(0, blockno);
8010826e:	83 ec 08             	sub    $0x8,%esp
            blockno = sb.swap_start + (slot_num * SWAP_BLOCKS_PER_PAGE) + i;
80108271:	8d 04 0f             	lea    (%edi,%ecx,1),%eax
80108274:	01 d8                	add    %ebx,%eax
            struct buf *buf = bread(0, blockno);
80108276:	50                   	push   %eax
80108277:	6a 00                	push   $0x0
80108279:	e8 52 7e ff ff       	call   801000d0 <bread>
            if (buf) {
8010827e:	83 c4 10             	add    $0x10,%esp
            struct buf *buf = bread(0, blockno);
80108281:	89 c1                	mov    %eax,%ecx
            if (buf) {
80108283:	85 c0                	test   %eax,%eax
80108285:	74 23                	je     801082aa <swapInAPage+0xba>
                memmove(mem + i * BSIZE, buf->data, BSIZE);
80108287:	83 ec 04             	sub    $0x4,%esp
8010828a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010828d:	68 00 02 00 00       	push   $0x200
80108292:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80108295:	50                   	push   %eax
80108296:	56                   	push   %esi
80108297:	e8 34 cb ff ff       	call   80104dd0 <memmove>
                brelse(buf);
8010829c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010829f:	89 0c 24             	mov    %ecx,(%esp)
801082a2:	e8 49 7f ff ff       	call   801001f0 <brelse>
801082a7:	83 c4 10             	add    $0x10,%esp
        i = i + (i >= SWAP_BLOCKS_PER_PAGE ? 0 : 1);
801082aa:	83 c3 01             	add    $0x1,%ebx
        if (i >= SWAP_BLOCKS_PER_PAGE) {
801082ad:	81 c6 00 02 00 00    	add    $0x200,%esi
801082b3:	83 fb 08             	cmp    $0x8,%ebx
801082b6:	75 b0                	jne    80108268 <swapInAPage+0x78>
    if (mark_slot_and_update(p, slot_num, pte, mem)) {
801082b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801082bb:	ff 75 d8             	push   -0x28(%ebp)
801082be:	52                   	push   %edx
801082bf:	ff 75 dc             	push   -0x24(%ebp)
801082c2:	ff 75 08             	push   0x8(%ebp)
801082c5:	e8 66 fc ff ff       	call   80107f30 <mark_slot_and_update>
801082ca:	83 c4 10             	add    $0x10,%esp
801082cd:	85 c0                	test   %eax,%eax
801082cf:	74 0b                	je     801082dc <swapInAPage+0xec>
}
801082d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082d7:	5b                   	pop    %ebx
801082d8:	5e                   	pop    %esi
801082d9:	5f                   	pop    %edi
801082da:	5d                   	pop    %ebp
801082db:	c3                   	ret
            kfree(mem);
801082dc:	83 ec 0c             	sub    $0xc,%esp
801082df:	ff 75 d8             	push   -0x28(%ebp)
801082e2:	e8 29 a2 ff ff       	call   80102510 <kfree>
801082e7:	83 c4 10             	add    $0x10,%esp
801082ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
801082f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
801082f7:	eb d8                	jmp    801082d1 <swapInAPage+0xe1>
