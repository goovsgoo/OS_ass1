
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 5d 37 10 80       	mov    $0x8010375d,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 9c 8a 10 	movl   $0x80108a9c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 58 52 00 00       	call   801052a6 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100055:	15 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
8010005f:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 15 11 80       	mov    0x80111594,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 15 11 80       	mov    %eax,0x80111594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801000bd:	e8 05 52 00 00       	call   801052c7 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 15 11 80       	mov    0x80111594,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100104:	e8 20 52 00 00       	call   80105329 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 ae 4a 00 00       	call   80104bd2 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 15 11 80       	mov    0x80111590,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010017c:	e8 a8 51 00 00       	call   80105329 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 a3 8a 10 80 	movl   $0x80108aa3,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 0f 26 00 00       	call   801027e7 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 b4 8a 10 80 	movl   $0x80108ab4,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 d2 25 00 00       	call   801027e7 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 bb 8a 10 80 	movl   $0x80108abb,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 86 50 00 00       	call   801052c7 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 15 11 80       	mov    0x80111594,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 15 11 80       	mov    %eax,0x80111594

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 0c 4a 00 00       	call   80104cae <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 7b 50 00 00       	call   80105329 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 c1 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801003bb:	e8 07 4f 00 00       	call   801052c7 <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 c2 8a 10 80 	movl   $0x80108ac2,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 5a 03 00 00       	call   80100750 <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec cb 8a 10 80 	movl   $0x80108acb,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 84 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100533:	e8 f1 4d 00 00       	call   80105329 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 d2 8a 10 80 	movl   $0x80108ad2,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 e1 8a 10 80 	movl   $0x80108ae1,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 e4 4d 00 00       	call   80105378 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 e3 8a 10 80 	movl   $0x80108ae3,(%esp)
801005af:	e8 ec fd ff ff       	call   801003a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 e9 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c0 fc ff ff       	call   801002b0 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c0 fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 97 fc ff ff       	call   801002b0 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	29 c1                	sub    %eax,%ecx
80100647:	89 ca                	mov    %ecx,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 35                	jmp    8010068a <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 26                	jle    8010068a <cgaputc+0xc0>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 20                	jmp    8010068a <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
80100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100673:	8d 50 01             	lea    0x1(%eax),%edx
80100676:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100679:	01 c0                	add    %eax,%eax
8010067b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	0f b6 c0             	movzbl %al,%eax
80100684:	80 cc 07             	or     $0x7,%ah
80100687:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x11c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 33 4f 00 00       	call   801055ea <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 35 4e 00 00       	call   8010551b <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 d3 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 ba fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 a6 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 90 fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 87 fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 62 69 00 00       	call   801070dd <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 56 69 00 00       	call   801070dd <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 4a 69 00 00       	call   801070dd <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 3d 69 00 00       	call   801070dd <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 1f fe ff ff       	call   801005ca <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
801007ba:	e8 08 4b 00 00       	call   801052c7 <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 37 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 64                	je     8010083a <consoleintr+0x8d>
801007d6:	e9 91 00 00 00       	jmp    8010086c <consoleintr+0xbf>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 55                	je     8010083a <consoleintr+0x8d>
801007e5:	e9 82 00 00 00       	jmp    8010086c <consoleintr+0xbf>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 72 45 00 00       	call   80104d61 <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 5c 18 11 80       	mov    %eax,0x8011185c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
80100816:	a1 58 18 11 80       	mov    0x80111858,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 5c 18 11 80       	mov    0x8011185c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 d4 17 11 80 	movzbl -0x7feee82c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100831:	3c 0a                	cmp    $0xa,%al
80100833:	75 bf                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100835:	e9 c1 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083a:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
80100840:	a1 58 18 11 80       	mov    0x80111858,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 5c 18 11 80       	mov    0x8011185c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 5c 18 11 80       	mov    %eax,0x8011185c
        consputc(BACKSPACE);
80100856:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010085d:	e8 ee fe ff ff       	call   80100750 <consputc>
      }
      break;
80100862:	e9 94 00 00 00       	jmp    801008fb <consoleintr+0x14e>
80100867:	e9 8f 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100870:	0f 84 84 00 00 00    	je     801008fa <consoleintr+0x14d>
80100876:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
8010087c:	a1 54 18 11 80       	mov    0x80111854,%eax
80100881:	29 c2                	sub    %eax,%edx
80100883:	89 d0                	mov    %edx,%eax
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	77 70                	ja     801008fa <consoleintr+0x14d>
        c = (c == '\r') ? '\n' : c;
8010088a:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010088e:	74 05                	je     80100895 <consoleintr+0xe8>
80100890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100893:	eb 05                	jmp    8010089a <consoleintr+0xed>
80100895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010089d:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 5c 18 11 80    	mov    %edx,0x8011185c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 d4 17 11 80    	mov    %al,-0x7feee82c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801008d5:	8b 15 54 18 11 80    	mov    0x80111854,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801008e7:	a3 58 18 11 80       	mov    %eax,0x80111858
          wakeup(&input.r);
801008ec:	c7 04 24 54 18 11 80 	movl   $0x80111854,(%esp)
801008f3:	e8 b6 43 00 00       	call   80104cae <wakeup>
        }
      }
      break;
801008f8:	eb 00                	jmp    801008fa <consoleintr+0x14d>
801008fa:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008fb:	8b 45 08             	mov    0x8(%ebp),%eax
801008fe:	ff d0                	call   *%eax
80100900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100907:	0f 89 b7 fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010090d:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100914:	e8 10 4a 00 00       	call   80105329 <release>
}
80100919:	c9                   	leave  
8010091a:	c3                   	ret    

8010091b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010091b:	55                   	push   %ebp
8010091c:	89 e5                	mov    %esp,%ebp
8010091e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100921:	8b 45 08             	mov    0x8(%ebp),%eax
80100924:	89 04 24             	mov    %eax,(%esp)
80100927:	e8 c3 10 00 00       	call   801019ef <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100939:	e8 89 49 00 00       	call   801052c7 <acquire>
  while(n > 0){
8010093e:	e9 aa 00 00 00       	jmp    801009ed <consoleread+0xd2>
    while(input.r == input.w){
80100943:	eb 42                	jmp    80100987 <consoleread+0x6c>
      if(proc->killed){
80100945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094b:	8b 40 24             	mov    0x24(%eax),%eax
8010094e:	85 c0                	test   %eax,%eax
80100950:	74 21                	je     80100973 <consoleread+0x58>
        release(&input.lock);
80100952:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100959:	e8 cb 49 00 00       	call   80105329 <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 38 0f 00 00       	call   801018a1 <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 a0 17 11 	movl   $0x801117a0,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 54 18 11 80 	movl   $0x80111854,(%esp)
80100982:	e8 4b 42 00 00       	call   80104bd2 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100987:	8b 15 54 18 11 80    	mov    0x80111854,%edx
8010098d:	a1 58 18 11 80       	mov    0x80111858,%eax
80100992:	39 c2                	cmp    %eax,%edx
80100994:	74 af                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100996:	a1 54 18 11 80       	mov    0x80111854,%eax
8010099b:	8d 50 01             	lea    0x1(%eax),%edx
8010099e:	89 15 54 18 11 80    	mov    %edx,0x80111854
801009a4:	83 e0 7f             	and    $0x7f,%eax
801009a7:	0f b6 80 d4 17 11 80 	movzbl -0x7feee82c(%eax),%eax
801009ae:	0f be c0             	movsbl %al,%eax
801009b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009b4:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009b8:	75 19                	jne    801009d3 <consoleread+0xb8>
      if(n < target){
801009ba:	8b 45 10             	mov    0x10(%ebp),%eax
801009bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009c0:	73 0f                	jae    801009d1 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c2:	a1 54 18 11 80       	mov    0x80111854,%eax
801009c7:	83 e8 01             	sub    $0x1,%eax
801009ca:	a3 54 18 11 80       	mov    %eax,0x80111854
      }
      break;
801009cf:	eb 26                	jmp    801009f7 <consoleread+0xdc>
801009d1:	eb 24                	jmp    801009f7 <consoleread+0xdc>
    }
    *dst++ = c;
801009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801009d6:	8d 50 01             	lea    0x1(%eax),%edx
801009d9:	89 55 0c             	mov    %edx,0xc(%ebp)
801009dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009df:	88 10                	mov    %dl,(%eax)
    --n;
801009e1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009e5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009e9:	75 02                	jne    801009ed <consoleread+0xd2>
      break;
801009eb:	eb 0a                	jmp    801009f7 <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f1:	0f 8f 4c ff ff ff    	jg     80100943 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801009f7:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
801009fe:	e8 26 49 00 00       	call   80105329 <release>
  ilock(ip);
80100a03:	8b 45 08             	mov    0x8(%ebp),%eax
80100a06:	89 04 24             	mov    %eax,(%esp)
80100a09:	e8 93 0e 00 00       	call   801018a1 <ilock>

  return target - n;
80100a0e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a14:	29 c2                	sub    %eax,%edx
80100a16:	89 d0                	mov    %edx,%eax
}
80100a18:	c9                   	leave  
80100a19:	c3                   	ret    

80100a1a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a1a:	55                   	push   %ebp
80100a1b:	89 e5                	mov    %esp,%ebp
80100a1d:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a20:	8b 45 08             	mov    0x8(%ebp),%eax
80100a23:	89 04 24             	mov    %eax,(%esp)
80100a26:	e8 c4 0f 00 00       	call   801019ef <iunlock>
  acquire(&cons.lock);
80100a2b:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a32:	e8 90 48 00 00       	call   801052c7 <acquire>
  for(i = 0; i < n; i++)
80100a37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a3e:	eb 1d                	jmp    80100a5d <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a43:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a46:	01 d0                	add    %edx,%eax
80100a48:	0f b6 00             	movzbl (%eax),%eax
80100a4b:	0f be c0             	movsbl %al,%eax
80100a4e:	0f b6 c0             	movzbl %al,%eax
80100a51:	89 04 24             	mov    %eax,(%esp)
80100a54:	e8 f7 fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a60:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a63:	7c db                	jl     80100a40 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a65:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a6c:	e8 b8 48 00 00       	call   80105329 <release>
  ilock(ip);
80100a71:	8b 45 08             	mov    0x8(%ebp),%eax
80100a74:	89 04 24             	mov    %eax,(%esp)
80100a77:	e8 25 0e 00 00       	call   801018a1 <ilock>

  return n;
80100a7c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a7f:	c9                   	leave  
80100a80:	c3                   	ret    

80100a81 <consoleinit>:

void
consoleinit(void)
{
80100a81:	55                   	push   %ebp
80100a82:	89 e5                	mov    %esp,%ebp
80100a84:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a87:	c7 44 24 04 e7 8a 10 	movl   $0x80108ae7,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a96:	e8 0b 48 00 00       	call   801052a6 <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 ef 8a 10 	movl   $0x80108aef,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100aaa:	e8 f7 47 00 00       	call   801052a6 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aaf:	c7 05 0c 22 11 80 1a 	movl   $0x80100a1a,0x8011220c
80100ab6:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab9:	c7 05 08 22 11 80 1b 	movl   $0x8010091b,0x80112208
80100ac0:	09 10 80 
  cons.locking = 1;
80100ac3:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100aca:	00 00 00 

  picenable(IRQ_KBD);
80100acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad4:	e8 21 33 00 00       	call   80103dfa <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ad9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae0:	00 
80100ae1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae8:	e8 b6 1e 00 00       	call   801029a3 <ioapicenable>
}
80100aed:	c9                   	leave  
80100aee:	c3                   	ret    

80100aef <exec>:
extern int implicit_exit();
extern int end_of_exit();

int
exec(char *path, char **argv)
{
80100aef:	55                   	push   %ebp
80100af0:	89 e5                	mov    %esp,%ebp
80100af2:	81 ec 48 01 00 00    	sub    $0x148,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100af8:	e8 59 29 00 00       	call   80103456 <begin_op>
  if((ip = namei(path)) == 0){
80100afd:	8b 45 08             	mov    0x8(%ebp),%eax
80100b00:	89 04 24             	mov    %eax,(%esp)
80100b03:	e8 44 19 00 00       	call   8010244c <namei>
80100b08:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b0b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b0f:	75 0f                	jne    80100b20 <exec+0x31>
    end_op();
80100b11:	e8 c4 29 00 00       	call   801034da <end_op>
    return -1;
80100b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1b:	e9 2e 04 00 00       	jmp    80100f4e <exec+0x45f>
  }
  ilock(ip);
80100b20:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b23:	89 04 24             	mov    %eax,(%esp)
80100b26:	e8 76 0d 00 00       	call   801018a1 <ilock>
  pgdir = 0;
80100b2b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b32:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b39:	00 
80100b3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b41:	00 
80100b42:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b48:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b4c:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b4f:	89 04 24             	mov    %eax,(%esp)
80100b52:	e8 57 12 00 00       	call   80101dae <readi>
80100b57:	83 f8 33             	cmp    $0x33,%eax
80100b5a:	77 05                	ja     80100b61 <exec+0x72>
    goto bad;
80100b5c:	e9 c1 03 00 00       	jmp    80100f22 <exec+0x433>
  if(elf.magic != ELF_MAGIC)
80100b61:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
80100b67:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6c:	74 05                	je     80100b73 <exec+0x84>
    goto bad;
80100b6e:	e9 af 03 00 00       	jmp    80100f22 <exec+0x433>

  if((pgdir = setupkvm()) == 0)
80100b73:	e8 b6 76 00 00       	call   8010822e <setupkvm>
80100b78:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b7b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b7f:	75 05                	jne    80100b86 <exec+0x97>
    goto bad;
80100b81:	e9 9c 03 00 00       	jmp    80100f22 <exec+0x433>

  // Load program into memory.
  sz = 0;
80100b86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b94:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
80100b9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100b9d:	e9 cb 00 00 00       	jmp    80100c6d <exec+0x17e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ba2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ba5:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bac:	00 
80100bad:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bb1:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
80100bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbb:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bbe:	89 04 24             	mov    %eax,(%esp)
80100bc1:	e8 e8 11 00 00       	call   80101dae <readi>
80100bc6:	83 f8 20             	cmp    $0x20,%eax
80100bc9:	74 05                	je     80100bd0 <exec+0xe1>
      goto bad;
80100bcb:	e9 52 03 00 00       	jmp    80100f22 <exec+0x433>
    if(ph.type != ELF_PROG_LOAD)
80100bd0:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
80100bd6:	83 f8 01             	cmp    $0x1,%eax
80100bd9:	74 05                	je     80100be0 <exec+0xf1>
      continue;
80100bdb:	e9 80 00 00 00       	jmp    80100c60 <exec+0x171>
    if(ph.memsz < ph.filesz)
80100be0:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100be6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100bec:	39 c2                	cmp    %eax,%edx
80100bee:	73 05                	jae    80100bf5 <exec+0x106>
      goto bad;
80100bf0:	e9 2d 03 00 00       	jmp    80100f22 <exec+0x433>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf5:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100bfb:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c01:	01 d0                	add    %edx,%eax
80100c03:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c11:	89 04 24             	mov    %eax,(%esp)
80100c14:	e8 e3 79 00 00       	call   801085fc <allocuvm>
80100c19:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c20:	75 05                	jne    80100c27 <exec+0x138>
      goto bad;
80100c22:	e9 fb 02 00 00       	jmp    80100f22 <exec+0x433>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c27:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c2d:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
80100c33:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c39:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c3d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c41:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c44:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c48:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c4f:	89 04 24             	mov    %eax,(%esp)
80100c52:	e8 ba 78 00 00       	call   80108511 <loaduvm>
80100c57:	85 c0                	test   %eax,%eax
80100c59:	79 05                	jns    80100c60 <exec+0x171>
      goto bad;
80100c5b:	e9 c2 02 00 00       	jmp    80100f22 <exec+0x433>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c60:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c67:	83 c0 20             	add    $0x20,%eax
80100c6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c6d:	0f b7 85 30 ff ff ff 	movzwl -0xd0(%ebp),%eax
80100c74:	0f b7 c0             	movzwl %ax,%eax
80100c77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c7a:	0f 8f 22 ff ff ff    	jg     80100ba2 <exec+0xb3>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c80:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c83:	89 04 24             	mov    %eax,(%esp)
80100c86:	e8 9a 0e 00 00       	call   80101b25 <iunlockput>
  end_op();
80100c8b:	e8 4a 28 00 00       	call   801034da <end_op>
  ip = 0;
80100c90:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c97:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9a:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ca4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100caa:	05 00 20 00 00       	add    $0x2000,%eax
80100caf:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cbd:	89 04 24             	mov    %eax,(%esp)
80100cc0:	e8 37 79 00 00       	call   801085fc <allocuvm>
80100cc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100ccc:	75 05                	jne    80100cd3 <exec+0x1e4>
    goto bad;
80100cce:	e9 4f 02 00 00       	jmp    80100f22 <exec+0x433>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cdf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ce2:	89 04 24             	mov    %eax,(%esp)
80100ce5:	e8 42 7b 00 00       	call   8010882c <clearpteu>
  sp = sz;
80100cea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ced:	89 45 dc             	mov    %eax,-0x24(%ebp)

  int funcSize = (int)&end_of_exit - (int)&implicit_exit;			//implicit_exit assmbly
80100cf0:	ba c9 57 10 80       	mov    $0x801057c9,%edx
80100cf5:	b8 c1 57 10 80       	mov    $0x801057c1,%eax
80100cfa:	29 c2                	sub    %eax,%edx
80100cfc:	89 d0                	mov    %edx,%eax
80100cfe:	89 45 d0             	mov    %eax,-0x30(%ebp)
   sp = sp - funcSize;												//Pointer
80100d01:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100d04:	29 45 dc             	sub    %eax,-0x24(%ebp)
   int adrr = sp;
80100d07:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d0a:	89 45 cc             	mov    %eax,-0x34(%ebp)
   if(copyout(pgdir, sp, &implicit_exit, funcSize) < 0)				//Push implicit_exit argument to stack
80100d0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100d10:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100d14:	c7 44 24 08 c1 57 10 	movl   $0x801057c1,0x8(%esp)
80100d1b:	80 
80100d1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d26:	89 04 24             	mov    %eax,(%esp)
80100d29:	e8 c3 7c 00 00       	call   801089f1 <copyout>
80100d2e:	85 c0                	test   %eax,%eax
80100d30:	79 05                	jns    80100d37 <exec+0x248>
        goto bad;
80100d32:	e9 eb 01 00 00       	jmp    80100f22 <exec+0x433>

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d3e:	e9 9a 00 00 00       	jmp    80100ddd <exec+0x2ee>
    if(argc >= MAXARG)
80100d43:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d47:	76 05                	jbe    80100d4e <exec+0x25f>
      goto bad;
80100d49:	e9 d4 01 00 00       	jmp    80100f22 <exec+0x433>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d5b:	01 d0                	add    %edx,%eax
80100d5d:	8b 00                	mov    (%eax),%eax
80100d5f:	89 04 24             	mov    %eax,(%esp)
80100d62:	e8 1e 4a 00 00       	call   80105785 <strlen>
80100d67:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d6a:	29 c2                	sub    %eax,%edx
80100d6c:	89 d0                	mov    %edx,%eax
80100d6e:	83 e8 01             	sub    $0x1,%eax
80100d71:	83 e0 fc             	and    $0xfffffffc,%eax
80100d74:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d7a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d81:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d84:	01 d0                	add    %edx,%eax
80100d86:	8b 00                	mov    (%eax),%eax
80100d88:	89 04 24             	mov    %eax,(%esp)
80100d8b:	e8 f5 49 00 00       	call   80105785 <strlen>
80100d90:	83 c0 01             	add    $0x1,%eax
80100d93:	89 c2                	mov    %eax,%edx
80100d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d98:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da2:	01 c8                	add    %ecx,%eax
80100da4:	8b 00                	mov    (%eax),%eax
80100da6:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100daa:	89 44 24 08          	mov    %eax,0x8(%esp)
80100dae:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100db1:	89 44 24 04          	mov    %eax,0x4(%esp)
80100db5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100db8:	89 04 24             	mov    %eax,(%esp)
80100dbb:	e8 31 7c 00 00       	call   801089f1 <copyout>
80100dc0:	85 c0                	test   %eax,%eax
80100dc2:	79 05                	jns    80100dc9 <exec+0x2da>
      goto bad;
80100dc4:	e9 59 01 00 00       	jmp    80100f22 <exec+0x433>
    ustack[3+argc] = sp;
80100dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dcc:	8d 50 03             	lea    0x3(%eax),%edx
80100dcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dd2:	89 84 95 38 ff ff ff 	mov    %eax,-0xc8(%ebp,%edx,4)
   int adrr = sp;
   if(copyout(pgdir, sp, &implicit_exit, funcSize) < 0)				//Push implicit_exit argument to stack
        goto bad;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dd9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100ddd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dea:	01 d0                	add    %edx,%eax
80100dec:	8b 00                	mov    (%eax),%eax
80100dee:	85 c0                	test   %eax,%eax
80100df0:	0f 85 4d ff ff ff    	jne    80100d43 <exec+0x254>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df9:	83 c0 03             	add    $0x3,%eax
80100dfc:	c7 84 85 38 ff ff ff 	movl   $0x0,-0xc8(%ebp,%eax,4)
80100e03:	00 00 00 00 

  //ustack[0] = 0xffffffff;  // fake return PC
  ustack[0] = adrr;			 //  Go to implicit_exit
80100e07:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100e0a:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  ustack[1] = argc;
80100e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e13:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1c:	83 c0 01             	add    $0x1,%eax
80100e1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e26:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e29:	29 d0                	sub    %edx,%eax
80100e2b:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

  sp -= (3+argc+1) * 4;
80100e31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e34:	83 c0 04             	add    $0x4,%eax
80100e37:	c1 e0 02             	shl    $0x2,%eax
80100e3a:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e40:	83 c0 04             	add    $0x4,%eax
80100e43:	c1 e0 02             	shl    $0x2,%eax
80100e46:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e4a:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
80100e50:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e57:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e5e:	89 04 24             	mov    %eax,(%esp)
80100e61:	e8 8b 7b 00 00       	call   801089f1 <copyout>
80100e66:	85 c0                	test   %eax,%eax
80100e68:	79 05                	jns    80100e6f <exec+0x380>
    goto bad;
80100e6a:	e9 b3 00 00 00       	jmp    80100f22 <exec+0x433>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e7b:	eb 17                	jmp    80100e94 <exec+0x3a5>
    if(*s == '/')
80100e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e80:	0f b6 00             	movzbl (%eax),%eax
80100e83:	3c 2f                	cmp    $0x2f,%al
80100e85:	75 09                	jne    80100e90 <exec+0x3a1>
      last = s+1;
80100e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e8a:	83 c0 01             	add    $0x1,%eax
80100e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e90:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e97:	0f b6 00             	movzbl (%eax),%eax
80100e9a:	84 c0                	test   %al,%al
80100e9c:	75 df                	jne    80100e7d <exec+0x38e>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea4:	8d 50 6c             	lea    0x6c(%eax),%edx
80100ea7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100eae:	00 
80100eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100eb2:	89 44 24 04          	mov    %eax,0x4(%esp)
80100eb6:	89 14 24             	mov    %edx,(%esp)
80100eb9:	e8 7d 48 00 00       	call   8010573b <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ebe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec4:	8b 40 04             	mov    0x4(%eax),%eax
80100ec7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  proc->pgdir = pgdir;
80100eca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ed3:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ed6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100edc:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100edf:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ee1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee7:	8b 40 18             	mov    0x18(%eax),%eax
80100eea:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
80100ef0:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ef3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef9:	8b 40 18             	mov    0x18(%eax),%eax
80100efc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100eff:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f08:	89 04 24             	mov    %eax,(%esp)
80100f0b:	e8 0f 74 00 00       	call   8010831f <switchuvm>
  freevm(oldpgdir);
80100f10:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100f13:	89 04 24             	mov    %eax,(%esp)
80100f16:	e8 77 78 00 00       	call   80108792 <freevm>
  return 0;
80100f1b:	b8 00 00 00 00       	mov    $0x0,%eax
80100f20:	eb 2c                	jmp    80100f4e <exec+0x45f>

 bad:
  if(pgdir)
80100f22:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f26:	74 0b                	je     80100f33 <exec+0x444>
    freevm(pgdir);
80100f28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f2b:	89 04 24             	mov    %eax,(%esp)
80100f2e:	e8 5f 78 00 00       	call   80108792 <freevm>
  if(ip){
80100f33:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f37:	74 10                	je     80100f49 <exec+0x45a>
    iunlockput(ip);
80100f39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f3c:	89 04 24             	mov    %eax,(%esp)
80100f3f:	e8 e1 0b 00 00       	call   80101b25 <iunlockput>
    end_op();
80100f44:	e8 91 25 00 00       	call   801034da <end_op>
  }
  return -1;
80100f49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f4e:	c9                   	leave  
80100f4f:	c3                   	ret    

80100f50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f56:	c7 44 24 04 f5 8a 10 	movl   $0x80108af5,0x4(%esp)
80100f5d:	80 
80100f5e:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f65:	e8 3c 43 00 00       	call   801052a6 <initlock>
}
80100f6a:	c9                   	leave  
80100f6b:	c3                   	ret    

80100f6c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f6c:	55                   	push   %ebp
80100f6d:	89 e5                	mov    %esp,%ebp
80100f6f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f72:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f79:	e8 49 43 00 00       	call   801052c7 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f7e:	c7 45 f4 94 18 11 80 	movl   $0x80111894,-0xc(%ebp)
80100f85:	eb 29                	jmp    80100fb0 <filealloc+0x44>
    if(f->ref == 0){
80100f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f8a:	8b 40 04             	mov    0x4(%eax),%eax
80100f8d:	85 c0                	test   %eax,%eax
80100f8f:	75 1b                	jne    80100fac <filealloc+0x40>
      f->ref = 1;
80100f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f94:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f9b:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100fa2:	e8 82 43 00 00       	call   80105329 <release>
      return f;
80100fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100faa:	eb 1e                	jmp    80100fca <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fac:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fb0:	81 7d f4 f4 21 11 80 	cmpl   $0x801121f4,-0xc(%ebp)
80100fb7:	72 ce                	jb     80100f87 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fb9:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100fc0:	e8 64 43 00 00       	call   80105329 <release>
  return 0;
80100fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fca:	c9                   	leave  
80100fcb:	c3                   	ret    

80100fcc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fcc:	55                   	push   %ebp
80100fcd:	89 e5                	mov    %esp,%ebp
80100fcf:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fd2:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100fd9:	e8 e9 42 00 00       	call   801052c7 <acquire>
  if(f->ref < 1)
80100fde:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe1:	8b 40 04             	mov    0x4(%eax),%eax
80100fe4:	85 c0                	test   %eax,%eax
80100fe6:	7f 0c                	jg     80100ff4 <filedup+0x28>
    panic("filedup");
80100fe8:	c7 04 24 fc 8a 10 80 	movl   $0x80108afc,(%esp)
80100fef:	e8 46 f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff7:	8b 40 04             	mov    0x4(%eax),%eax
80100ffa:	8d 50 01             	lea    0x1(%eax),%edx
80100ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80101000:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101003:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
8010100a:	e8 1a 43 00 00       	call   80105329 <release>
  return f;
8010100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101012:	c9                   	leave  
80101013:	c3                   	ret    

80101014 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101014:	55                   	push   %ebp
80101015:	89 e5                	mov    %esp,%ebp
80101017:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
8010101a:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80101021:	e8 a1 42 00 00       	call   801052c7 <acquire>
  if(f->ref < 1)
80101026:	8b 45 08             	mov    0x8(%ebp),%eax
80101029:	8b 40 04             	mov    0x4(%eax),%eax
8010102c:	85 c0                	test   %eax,%eax
8010102e:	7f 0c                	jg     8010103c <fileclose+0x28>
    panic("fileclose");
80101030:	c7 04 24 04 8b 10 80 	movl   $0x80108b04,(%esp)
80101037:	e8 fe f4 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
8010103c:	8b 45 08             	mov    0x8(%ebp),%eax
8010103f:	8b 40 04             	mov    0x4(%eax),%eax
80101042:	8d 50 ff             	lea    -0x1(%eax),%edx
80101045:	8b 45 08             	mov    0x8(%ebp),%eax
80101048:	89 50 04             	mov    %edx,0x4(%eax)
8010104b:	8b 45 08             	mov    0x8(%ebp),%eax
8010104e:	8b 40 04             	mov    0x4(%eax),%eax
80101051:	85 c0                	test   %eax,%eax
80101053:	7e 11                	jle    80101066 <fileclose+0x52>
    release(&ftable.lock);
80101055:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
8010105c:	e8 c8 42 00 00       	call   80105329 <release>
80101061:	e9 82 00 00 00       	jmp    801010e8 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101066:	8b 45 08             	mov    0x8(%ebp),%eax
80101069:	8b 10                	mov    (%eax),%edx
8010106b:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010106e:	8b 50 04             	mov    0x4(%eax),%edx
80101071:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101074:	8b 50 08             	mov    0x8(%eax),%edx
80101077:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010107a:	8b 50 0c             	mov    0xc(%eax),%edx
8010107d:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101080:	8b 50 10             	mov    0x10(%eax),%edx
80101083:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101086:	8b 40 14             	mov    0x14(%eax),%eax
80101089:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010108c:	8b 45 08             	mov    0x8(%ebp),%eax
8010108f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101096:	8b 45 08             	mov    0x8(%ebp),%eax
80101099:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010109f:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
801010a6:	e8 7e 42 00 00       	call   80105329 <release>
  
  if(ff.type == FD_PIPE)
801010ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ae:	83 f8 01             	cmp    $0x1,%eax
801010b1:	75 18                	jne    801010cb <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
801010b3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010b7:	0f be d0             	movsbl %al,%edx
801010ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010bd:	89 54 24 04          	mov    %edx,0x4(%esp)
801010c1:	89 04 24             	mov    %eax,(%esp)
801010c4:	e8 e1 2f 00 00       	call   801040aa <pipeclose>
801010c9:	eb 1d                	jmp    801010e8 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ce:	83 f8 02             	cmp    $0x2,%eax
801010d1:	75 15                	jne    801010e8 <fileclose+0xd4>
    begin_op();
801010d3:	e8 7e 23 00 00       	call   80103456 <begin_op>
    iput(ff.ip);
801010d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010db:	89 04 24             	mov    %eax,(%esp)
801010de:	e8 71 09 00 00       	call   80101a54 <iput>
    end_op();
801010e3:	e8 f2 23 00 00       	call   801034da <end_op>
  }
}
801010e8:	c9                   	leave  
801010e9:	c3                   	ret    

801010ea <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010ea:	55                   	push   %ebp
801010eb:	89 e5                	mov    %esp,%ebp
801010ed:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010f0:	8b 45 08             	mov    0x8(%ebp),%eax
801010f3:	8b 00                	mov    (%eax),%eax
801010f5:	83 f8 02             	cmp    $0x2,%eax
801010f8:	75 38                	jne    80101132 <filestat+0x48>
    ilock(f->ip);
801010fa:	8b 45 08             	mov    0x8(%ebp),%eax
801010fd:	8b 40 10             	mov    0x10(%eax),%eax
80101100:	89 04 24             	mov    %eax,(%esp)
80101103:	e8 99 07 00 00       	call   801018a1 <ilock>
    stati(f->ip, st);
80101108:	8b 45 08             	mov    0x8(%ebp),%eax
8010110b:	8b 40 10             	mov    0x10(%eax),%eax
8010110e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101111:	89 54 24 04          	mov    %edx,0x4(%esp)
80101115:	89 04 24             	mov    %eax,(%esp)
80101118:	e8 4c 0c 00 00       	call   80101d69 <stati>
    iunlock(f->ip);
8010111d:	8b 45 08             	mov    0x8(%ebp),%eax
80101120:	8b 40 10             	mov    0x10(%eax),%eax
80101123:	89 04 24             	mov    %eax,(%esp)
80101126:	e8 c4 08 00 00       	call   801019ef <iunlock>
    return 0;
8010112b:	b8 00 00 00 00       	mov    $0x0,%eax
80101130:	eb 05                	jmp    80101137 <filestat+0x4d>
  }
  return -1;
80101132:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101137:	c9                   	leave  
80101138:	c3                   	ret    

80101139 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101139:	55                   	push   %ebp
8010113a:	89 e5                	mov    %esp,%ebp
8010113c:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010113f:	8b 45 08             	mov    0x8(%ebp),%eax
80101142:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101146:	84 c0                	test   %al,%al
80101148:	75 0a                	jne    80101154 <fileread+0x1b>
    return -1;
8010114a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010114f:	e9 9f 00 00 00       	jmp    801011f3 <fileread+0xba>
  if(f->type == FD_PIPE)
80101154:	8b 45 08             	mov    0x8(%ebp),%eax
80101157:	8b 00                	mov    (%eax),%eax
80101159:	83 f8 01             	cmp    $0x1,%eax
8010115c:	75 1e                	jne    8010117c <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010115e:	8b 45 08             	mov    0x8(%ebp),%eax
80101161:	8b 40 0c             	mov    0xc(%eax),%eax
80101164:	8b 55 10             	mov    0x10(%ebp),%edx
80101167:	89 54 24 08          	mov    %edx,0x8(%esp)
8010116b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010116e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101172:	89 04 24             	mov    %eax,(%esp)
80101175:	e8 b1 30 00 00       	call   8010422b <piperead>
8010117a:	eb 77                	jmp    801011f3 <fileread+0xba>
  if(f->type == FD_INODE){
8010117c:	8b 45 08             	mov    0x8(%ebp),%eax
8010117f:	8b 00                	mov    (%eax),%eax
80101181:	83 f8 02             	cmp    $0x2,%eax
80101184:	75 61                	jne    801011e7 <fileread+0xae>
    ilock(f->ip);
80101186:	8b 45 08             	mov    0x8(%ebp),%eax
80101189:	8b 40 10             	mov    0x10(%eax),%eax
8010118c:	89 04 24             	mov    %eax,(%esp)
8010118f:	e8 0d 07 00 00       	call   801018a1 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101194:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101197:	8b 45 08             	mov    0x8(%ebp),%eax
8010119a:	8b 50 14             	mov    0x14(%eax),%edx
8010119d:	8b 45 08             	mov    0x8(%ebp),%eax
801011a0:	8b 40 10             	mov    0x10(%eax),%eax
801011a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801011a7:	89 54 24 08          	mov    %edx,0x8(%esp)
801011ab:	8b 55 0c             	mov    0xc(%ebp),%edx
801011ae:	89 54 24 04          	mov    %edx,0x4(%esp)
801011b2:	89 04 24             	mov    %eax,(%esp)
801011b5:	e8 f4 0b 00 00       	call   80101dae <readi>
801011ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011c1:	7e 11                	jle    801011d4 <fileread+0x9b>
      f->off += r;
801011c3:	8b 45 08             	mov    0x8(%ebp),%eax
801011c6:	8b 50 14             	mov    0x14(%eax),%edx
801011c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011cc:	01 c2                	add    %eax,%edx
801011ce:	8b 45 08             	mov    0x8(%ebp),%eax
801011d1:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011d4:	8b 45 08             	mov    0x8(%ebp),%eax
801011d7:	8b 40 10             	mov    0x10(%eax),%eax
801011da:	89 04 24             	mov    %eax,(%esp)
801011dd:	e8 0d 08 00 00       	call   801019ef <iunlock>
    return r;
801011e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011e5:	eb 0c                	jmp    801011f3 <fileread+0xba>
  }
  panic("fileread");
801011e7:	c7 04 24 0e 8b 10 80 	movl   $0x80108b0e,(%esp)
801011ee:	e8 47 f3 ff ff       	call   8010053a <panic>
}
801011f3:	c9                   	leave  
801011f4:	c3                   	ret    

801011f5 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011f5:	55                   	push   %ebp
801011f6:	89 e5                	mov    %esp,%ebp
801011f8:	53                   	push   %ebx
801011f9:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011fc:	8b 45 08             	mov    0x8(%ebp),%eax
801011ff:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101203:	84 c0                	test   %al,%al
80101205:	75 0a                	jne    80101211 <filewrite+0x1c>
    return -1;
80101207:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010120c:	e9 20 01 00 00       	jmp    80101331 <filewrite+0x13c>
  if(f->type == FD_PIPE)
80101211:	8b 45 08             	mov    0x8(%ebp),%eax
80101214:	8b 00                	mov    (%eax),%eax
80101216:	83 f8 01             	cmp    $0x1,%eax
80101219:	75 21                	jne    8010123c <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
8010121b:	8b 45 08             	mov    0x8(%ebp),%eax
8010121e:	8b 40 0c             	mov    0xc(%eax),%eax
80101221:	8b 55 10             	mov    0x10(%ebp),%edx
80101224:	89 54 24 08          	mov    %edx,0x8(%esp)
80101228:	8b 55 0c             	mov    0xc(%ebp),%edx
8010122b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010122f:	89 04 24             	mov    %eax,(%esp)
80101232:	e8 05 2f 00 00       	call   8010413c <pipewrite>
80101237:	e9 f5 00 00 00       	jmp    80101331 <filewrite+0x13c>
  if(f->type == FD_INODE){
8010123c:	8b 45 08             	mov    0x8(%ebp),%eax
8010123f:	8b 00                	mov    (%eax),%eax
80101241:	83 f8 02             	cmp    $0x2,%eax
80101244:	0f 85 db 00 00 00    	jne    80101325 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010124a:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101251:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101258:	e9 a8 00 00 00       	jmp    80101305 <filewrite+0x110>
      int n1 = n - i;
8010125d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101260:	8b 55 10             	mov    0x10(%ebp),%edx
80101263:	29 c2                	sub    %eax,%edx
80101265:	89 d0                	mov    %edx,%eax
80101267:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010126a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010126d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101270:	7e 06                	jle    80101278 <filewrite+0x83>
        n1 = max;
80101272:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101275:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101278:	e8 d9 21 00 00       	call   80103456 <begin_op>
      ilock(f->ip);
8010127d:	8b 45 08             	mov    0x8(%ebp),%eax
80101280:	8b 40 10             	mov    0x10(%eax),%eax
80101283:	89 04 24             	mov    %eax,(%esp)
80101286:	e8 16 06 00 00       	call   801018a1 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010128b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010128e:	8b 45 08             	mov    0x8(%ebp),%eax
80101291:	8b 50 14             	mov    0x14(%eax),%edx
80101294:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101297:	8b 45 0c             	mov    0xc(%ebp),%eax
8010129a:	01 c3                	add    %eax,%ebx
8010129c:	8b 45 08             	mov    0x8(%ebp),%eax
8010129f:	8b 40 10             	mov    0x10(%eax),%eax
801012a2:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801012a6:	89 54 24 08          	mov    %edx,0x8(%esp)
801012aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801012ae:	89 04 24             	mov    %eax,(%esp)
801012b1:	e8 5c 0c 00 00       	call   80101f12 <writei>
801012b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012bd:	7e 11                	jle    801012d0 <filewrite+0xdb>
        f->off += r;
801012bf:	8b 45 08             	mov    0x8(%ebp),%eax
801012c2:	8b 50 14             	mov    0x14(%eax),%edx
801012c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012c8:	01 c2                	add    %eax,%edx
801012ca:	8b 45 08             	mov    0x8(%ebp),%eax
801012cd:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012d0:	8b 45 08             	mov    0x8(%ebp),%eax
801012d3:	8b 40 10             	mov    0x10(%eax),%eax
801012d6:	89 04 24             	mov    %eax,(%esp)
801012d9:	e8 11 07 00 00       	call   801019ef <iunlock>
      end_op();
801012de:	e8 f7 21 00 00       	call   801034da <end_op>

      if(r < 0)
801012e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012e7:	79 02                	jns    801012eb <filewrite+0xf6>
        break;
801012e9:	eb 26                	jmp    80101311 <filewrite+0x11c>
      if(r != n1)
801012eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012f1:	74 0c                	je     801012ff <filewrite+0x10a>
        panic("short filewrite");
801012f3:	c7 04 24 17 8b 10 80 	movl   $0x80108b17,(%esp)
801012fa:	e8 3b f2 ff ff       	call   8010053a <panic>
      i += r;
801012ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101302:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101308:	3b 45 10             	cmp    0x10(%ebp),%eax
8010130b:	0f 8c 4c ff ff ff    	jl     8010125d <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101311:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101314:	3b 45 10             	cmp    0x10(%ebp),%eax
80101317:	75 05                	jne    8010131e <filewrite+0x129>
80101319:	8b 45 10             	mov    0x10(%ebp),%eax
8010131c:	eb 05                	jmp    80101323 <filewrite+0x12e>
8010131e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101323:	eb 0c                	jmp    80101331 <filewrite+0x13c>
  }
  panic("filewrite");
80101325:	c7 04 24 27 8b 10 80 	movl   $0x80108b27,(%esp)
8010132c:	e8 09 f2 ff ff       	call   8010053a <panic>
}
80101331:	83 c4 24             	add    $0x24,%esp
80101334:	5b                   	pop    %ebx
80101335:	5d                   	pop    %ebp
80101336:	c3                   	ret    

80101337 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101337:	55                   	push   %ebp
80101338:	89 e5                	mov    %esp,%ebp
8010133a:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010133d:	8b 45 08             	mov    0x8(%ebp),%eax
80101340:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101347:	00 
80101348:	89 04 24             	mov    %eax,(%esp)
8010134b:	e8 56 ee ff ff       	call   801001a6 <bread>
80101350:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101353:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101356:	83 c0 18             	add    $0x18,%eax
80101359:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101360:	00 
80101361:	89 44 24 04          	mov    %eax,0x4(%esp)
80101365:	8b 45 0c             	mov    0xc(%ebp),%eax
80101368:	89 04 24             	mov    %eax,(%esp)
8010136b:	e8 7a 42 00 00       	call   801055ea <memmove>
  brelse(bp);
80101370:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101373:	89 04 24             	mov    %eax,(%esp)
80101376:	e8 9c ee ff ff       	call   80100217 <brelse>
}
8010137b:	c9                   	leave  
8010137c:	c3                   	ret    

8010137d <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010137d:	55                   	push   %ebp
8010137e:	89 e5                	mov    %esp,%ebp
80101380:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101383:	8b 55 0c             	mov    0xc(%ebp),%edx
80101386:	8b 45 08             	mov    0x8(%ebp),%eax
80101389:	89 54 24 04          	mov    %edx,0x4(%esp)
8010138d:	89 04 24             	mov    %eax,(%esp)
80101390:	e8 11 ee ff ff       	call   801001a6 <bread>
80101395:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101398:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010139b:	83 c0 18             	add    $0x18,%eax
8010139e:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801013a5:	00 
801013a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801013ad:	00 
801013ae:	89 04 24             	mov    %eax,(%esp)
801013b1:	e8 65 41 00 00       	call   8010551b <memset>
  log_write(bp);
801013b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b9:	89 04 24             	mov    %eax,(%esp)
801013bc:	e8 a0 22 00 00       	call   80103661 <log_write>
  brelse(bp);
801013c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c4:	89 04 24             	mov    %eax,(%esp)
801013c7:	e8 4b ee ff ff       	call   80100217 <brelse>
}
801013cc:	c9                   	leave  
801013cd:	c3                   	ret    

801013ce <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013ce:	55                   	push   %ebp
801013cf:	89 e5                	mov    %esp,%ebp
801013d1:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013db:	8b 45 08             	mov    0x8(%ebp),%eax
801013de:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013e1:	89 54 24 04          	mov    %edx,0x4(%esp)
801013e5:	89 04 24             	mov    %eax,(%esp)
801013e8:	e8 4a ff ff ff       	call   80101337 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013f4:	e9 07 01 00 00       	jmp    80101500 <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013fc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101402:	85 c0                	test   %eax,%eax
80101404:	0f 48 c2             	cmovs  %edx,%eax
80101407:	c1 f8 0c             	sar    $0xc,%eax
8010140a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010140d:	c1 ea 03             	shr    $0x3,%edx
80101410:	01 d0                	add    %edx,%eax
80101412:	83 c0 03             	add    $0x3,%eax
80101415:	89 44 24 04          	mov    %eax,0x4(%esp)
80101419:	8b 45 08             	mov    0x8(%ebp),%eax
8010141c:	89 04 24             	mov    %eax,(%esp)
8010141f:	e8 82 ed ff ff       	call   801001a6 <bread>
80101424:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101427:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010142e:	e9 9d 00 00 00       	jmp    801014d0 <balloc+0x102>
      m = 1 << (bi % 8);
80101433:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101436:	99                   	cltd   
80101437:	c1 ea 1d             	shr    $0x1d,%edx
8010143a:	01 d0                	add    %edx,%eax
8010143c:	83 e0 07             	and    $0x7,%eax
8010143f:	29 d0                	sub    %edx,%eax
80101441:	ba 01 00 00 00       	mov    $0x1,%edx
80101446:	89 c1                	mov    %eax,%ecx
80101448:	d3 e2                	shl    %cl,%edx
8010144a:	89 d0                	mov    %edx,%eax
8010144c:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010144f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101452:	8d 50 07             	lea    0x7(%eax),%edx
80101455:	85 c0                	test   %eax,%eax
80101457:	0f 48 c2             	cmovs  %edx,%eax
8010145a:	c1 f8 03             	sar    $0x3,%eax
8010145d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101460:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101465:	0f b6 c0             	movzbl %al,%eax
80101468:	23 45 e8             	and    -0x18(%ebp),%eax
8010146b:	85 c0                	test   %eax,%eax
8010146d:	75 5d                	jne    801014cc <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
8010146f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101472:	8d 50 07             	lea    0x7(%eax),%edx
80101475:	85 c0                	test   %eax,%eax
80101477:	0f 48 c2             	cmovs  %edx,%eax
8010147a:	c1 f8 03             	sar    $0x3,%eax
8010147d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101480:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101485:	89 d1                	mov    %edx,%ecx
80101487:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010148a:	09 ca                	or     %ecx,%edx
8010148c:	89 d1                	mov    %edx,%ecx
8010148e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101491:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101495:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101498:	89 04 24             	mov    %eax,(%esp)
8010149b:	e8 c1 21 00 00       	call   80103661 <log_write>
        brelse(bp);
801014a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014a3:	89 04 24             	mov    %eax,(%esp)
801014a6:	e8 6c ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
801014ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014b1:	01 c2                	add    %eax,%edx
801014b3:	8b 45 08             	mov    0x8(%ebp),%eax
801014b6:	89 54 24 04          	mov    %edx,0x4(%esp)
801014ba:	89 04 24             	mov    %eax,(%esp)
801014bd:	e8 bb fe ff ff       	call   8010137d <bzero>
        return b + bi;
801014c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014c8:	01 d0                	add    %edx,%eax
801014ca:	eb 4e                	jmp    8010151a <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014cc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014d0:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014d7:	7f 15                	jg     801014ee <balloc+0x120>
801014d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014df:	01 d0                	add    %edx,%eax
801014e1:	89 c2                	mov    %eax,%edx
801014e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014e6:	39 c2                	cmp    %eax,%edx
801014e8:	0f 82 45 ff ff ff    	jb     80101433 <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014f1:	89 04 24             	mov    %eax,(%esp)
801014f4:	e8 1e ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014f9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101500:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101503:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101506:	39 c2                	cmp    %eax,%edx
80101508:	0f 82 eb fe ff ff    	jb     801013f9 <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010150e:	c7 04 24 31 8b 10 80 	movl   $0x80108b31,(%esp)
80101515:	e8 20 f0 ff ff       	call   8010053a <panic>
}
8010151a:	c9                   	leave  
8010151b:	c3                   	ret    

8010151c <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010151c:	55                   	push   %ebp
8010151d:	89 e5                	mov    %esp,%ebp
8010151f:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101522:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101525:	89 44 24 04          	mov    %eax,0x4(%esp)
80101529:	8b 45 08             	mov    0x8(%ebp),%eax
8010152c:	89 04 24             	mov    %eax,(%esp)
8010152f:	e8 03 fe ff ff       	call   80101337 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101534:	8b 45 0c             	mov    0xc(%ebp),%eax
80101537:	c1 e8 0c             	shr    $0xc,%eax
8010153a:	89 c2                	mov    %eax,%edx
8010153c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010153f:	c1 e8 03             	shr    $0x3,%eax
80101542:	01 d0                	add    %edx,%eax
80101544:	8d 50 03             	lea    0x3(%eax),%edx
80101547:	8b 45 08             	mov    0x8(%ebp),%eax
8010154a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010154e:	89 04 24             	mov    %eax,(%esp)
80101551:	e8 50 ec ff ff       	call   801001a6 <bread>
80101556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101559:	8b 45 0c             	mov    0xc(%ebp),%eax
8010155c:	25 ff 0f 00 00       	and    $0xfff,%eax
80101561:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101564:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101567:	99                   	cltd   
80101568:	c1 ea 1d             	shr    $0x1d,%edx
8010156b:	01 d0                	add    %edx,%eax
8010156d:	83 e0 07             	and    $0x7,%eax
80101570:	29 d0                	sub    %edx,%eax
80101572:	ba 01 00 00 00       	mov    $0x1,%edx
80101577:	89 c1                	mov    %eax,%ecx
80101579:	d3 e2                	shl    %cl,%edx
8010157b:	89 d0                	mov    %edx,%eax
8010157d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101580:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101583:	8d 50 07             	lea    0x7(%eax),%edx
80101586:	85 c0                	test   %eax,%eax
80101588:	0f 48 c2             	cmovs  %edx,%eax
8010158b:	c1 f8 03             	sar    $0x3,%eax
8010158e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101591:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101596:	0f b6 c0             	movzbl %al,%eax
80101599:	23 45 ec             	and    -0x14(%ebp),%eax
8010159c:	85 c0                	test   %eax,%eax
8010159e:	75 0c                	jne    801015ac <bfree+0x90>
    panic("freeing free block");
801015a0:	c7 04 24 47 8b 10 80 	movl   $0x80108b47,(%esp)
801015a7:	e8 8e ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
801015ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015af:	8d 50 07             	lea    0x7(%eax),%edx
801015b2:	85 c0                	test   %eax,%eax
801015b4:	0f 48 c2             	cmovs  %edx,%eax
801015b7:	c1 f8 03             	sar    $0x3,%eax
801015ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015bd:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015c2:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015c5:	f7 d1                	not    %ecx
801015c7:	21 ca                	and    %ecx,%edx
801015c9:	89 d1                	mov    %edx,%ecx
801015cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ce:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015d5:	89 04 24             	mov    %eax,(%esp)
801015d8:	e8 84 20 00 00       	call   80103661 <log_write>
  brelse(bp);
801015dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015e0:	89 04 24             	mov    %eax,(%esp)
801015e3:	e8 2f ec ff ff       	call   80100217 <brelse>
}
801015e8:	c9                   	leave  
801015e9:	c3                   	ret    

801015ea <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015ea:	55                   	push   %ebp
801015eb:	89 e5                	mov    %esp,%ebp
801015ed:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015f0:	c7 44 24 04 5a 8b 10 	movl   $0x80108b5a,0x4(%esp)
801015f7:	80 
801015f8:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801015ff:	e8 a2 3c 00 00       	call   801052a6 <initlock>
}
80101604:	c9                   	leave  
80101605:	c3                   	ret    

80101606 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101606:	55                   	push   %ebp
80101607:	89 e5                	mov    %esp,%ebp
80101609:	83 ec 38             	sub    $0x38,%esp
8010160c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010160f:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101613:	8b 45 08             	mov    0x8(%ebp),%eax
80101616:	8d 55 dc             	lea    -0x24(%ebp),%edx
80101619:	89 54 24 04          	mov    %edx,0x4(%esp)
8010161d:	89 04 24             	mov    %eax,(%esp)
80101620:	e8 12 fd ff ff       	call   80101337 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
80101625:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010162c:	e9 98 00 00 00       	jmp    801016c9 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
80101631:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101634:	c1 e8 03             	shr    $0x3,%eax
80101637:	83 c0 02             	add    $0x2,%eax
8010163a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010163e:	8b 45 08             	mov    0x8(%ebp),%eax
80101641:	89 04 24             	mov    %eax,(%esp)
80101644:	e8 5d eb ff ff       	call   801001a6 <bread>
80101649:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164f:	8d 50 18             	lea    0x18(%eax),%edx
80101652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101655:	83 e0 07             	and    $0x7,%eax
80101658:	c1 e0 06             	shl    $0x6,%eax
8010165b:	01 d0                	add    %edx,%eax
8010165d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101660:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101663:	0f b7 00             	movzwl (%eax),%eax
80101666:	66 85 c0             	test   %ax,%ax
80101669:	75 4f                	jne    801016ba <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
8010166b:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101672:	00 
80101673:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010167a:	00 
8010167b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010167e:	89 04 24             	mov    %eax,(%esp)
80101681:	e8 95 3e 00 00       	call   8010551b <memset>
      dip->type = type;
80101686:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101689:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
8010168d:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101690:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101693:	89 04 24             	mov    %eax,(%esp)
80101696:	e8 c6 1f 00 00       	call   80103661 <log_write>
      brelse(bp);
8010169b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010169e:	89 04 24             	mov    %eax,(%esp)
801016a1:	e8 71 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
801016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801016ad:	8b 45 08             	mov    0x8(%ebp),%eax
801016b0:	89 04 24             	mov    %eax,(%esp)
801016b3:	e8 e5 00 00 00       	call   8010179d <iget>
801016b8:	eb 29                	jmp    801016e3 <ialloc+0xdd>
    }
    brelse(bp);
801016ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016bd:	89 04 24             	mov    %eax,(%esp)
801016c0:	e8 52 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016cf:	39 c2                	cmp    %eax,%edx
801016d1:	0f 82 5a ff ff ff    	jb     80101631 <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016d7:	c7 04 24 61 8b 10 80 	movl   $0x80108b61,(%esp)
801016de:	e8 57 ee ff ff       	call   8010053a <panic>
}
801016e3:	c9                   	leave  
801016e4:	c3                   	ret    

801016e5 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016e5:	55                   	push   %ebp
801016e6:	89 e5                	mov    %esp,%ebp
801016e8:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016eb:	8b 45 08             	mov    0x8(%ebp),%eax
801016ee:	8b 40 04             	mov    0x4(%eax),%eax
801016f1:	c1 e8 03             	shr    $0x3,%eax
801016f4:	8d 50 02             	lea    0x2(%eax),%edx
801016f7:	8b 45 08             	mov    0x8(%ebp),%eax
801016fa:	8b 00                	mov    (%eax),%eax
801016fc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101700:	89 04 24             	mov    %eax,(%esp)
80101703:	e8 9e ea ff ff       	call   801001a6 <bread>
80101708:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010170e:	8d 50 18             	lea    0x18(%eax),%edx
80101711:	8b 45 08             	mov    0x8(%ebp),%eax
80101714:	8b 40 04             	mov    0x4(%eax),%eax
80101717:	83 e0 07             	and    $0x7,%eax
8010171a:	c1 e0 06             	shl    $0x6,%eax
8010171d:	01 d0                	add    %edx,%eax
8010171f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101722:	8b 45 08             	mov    0x8(%ebp),%eax
80101725:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101729:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010172c:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172f:	8b 45 08             	mov    0x8(%ebp),%eax
80101732:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101736:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101739:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010173d:	8b 45 08             	mov    0x8(%ebp),%eax
80101740:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101744:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101747:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010174b:	8b 45 08             	mov    0x8(%ebp),%eax
8010174e:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101752:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101755:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101759:	8b 45 08             	mov    0x8(%ebp),%eax
8010175c:	8b 50 18             	mov    0x18(%eax),%edx
8010175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101762:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101765:	8b 45 08             	mov    0x8(%ebp),%eax
80101768:	8d 50 1c             	lea    0x1c(%eax),%edx
8010176b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176e:	83 c0 0c             	add    $0xc,%eax
80101771:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101778:	00 
80101779:	89 54 24 04          	mov    %edx,0x4(%esp)
8010177d:	89 04 24             	mov    %eax,(%esp)
80101780:	e8 65 3e 00 00       	call   801055ea <memmove>
  log_write(bp);
80101785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101788:	89 04 24             	mov    %eax,(%esp)
8010178b:	e8 d1 1e 00 00       	call   80103661 <log_write>
  brelse(bp);
80101790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101793:	89 04 24             	mov    %eax,(%esp)
80101796:	e8 7c ea ff ff       	call   80100217 <brelse>
}
8010179b:	c9                   	leave  
8010179c:	c3                   	ret    

8010179d <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010179d:	55                   	push   %ebp
8010179e:	89 e5                	mov    %esp,%ebp
801017a0:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017a3:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801017aa:	e8 18 3b 00 00       	call   801052c7 <acquire>

  // Is the inode already cached?
  empty = 0;
801017af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017b6:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
801017bd:	eb 59                	jmp    80101818 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c2:	8b 40 08             	mov    0x8(%eax),%eax
801017c5:	85 c0                	test   %eax,%eax
801017c7:	7e 35                	jle    801017fe <iget+0x61>
801017c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017cc:	8b 00                	mov    (%eax),%eax
801017ce:	3b 45 08             	cmp    0x8(%ebp),%eax
801017d1:	75 2b                	jne    801017fe <iget+0x61>
801017d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d6:	8b 40 04             	mov    0x4(%eax),%eax
801017d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017dc:	75 20                	jne    801017fe <iget+0x61>
      ip->ref++;
801017de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e1:	8b 40 08             	mov    0x8(%eax),%eax
801017e4:	8d 50 01             	lea    0x1(%eax),%edx
801017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ea:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017ed:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801017f4:	e8 30 3b 00 00       	call   80105329 <release>
      return ip;
801017f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fc:	eb 6f                	jmp    8010186d <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101802:	75 10                	jne    80101814 <iget+0x77>
80101804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101807:	8b 40 08             	mov    0x8(%eax),%eax
8010180a:	85 c0                	test   %eax,%eax
8010180c:	75 06                	jne    80101814 <iget+0x77>
      empty = ip;
8010180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101811:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101814:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101818:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
8010181f:	72 9e                	jb     801017bf <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101821:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101825:	75 0c                	jne    80101833 <iget+0x96>
    panic("iget: no inodes");
80101827:	c7 04 24 73 8b 10 80 	movl   $0x80108b73,(%esp)
8010182e:	e8 07 ed ff ff       	call   8010053a <panic>

  ip = empty;
80101833:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101836:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183c:	8b 55 08             	mov    0x8(%ebp),%edx
8010183f:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101844:	8b 55 0c             	mov    0xc(%ebp),%edx
80101847:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010184a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101854:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101857:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010185e:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101865:	e8 bf 3a 00 00       	call   80105329 <release>

  return ip;
8010186a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010186d:	c9                   	leave  
8010186e:	c3                   	ret    

8010186f <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010186f:	55                   	push   %ebp
80101870:	89 e5                	mov    %esp,%ebp
80101872:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101875:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010187c:	e8 46 3a 00 00       	call   801052c7 <acquire>
  ip->ref++;
80101881:	8b 45 08             	mov    0x8(%ebp),%eax
80101884:	8b 40 08             	mov    0x8(%eax),%eax
80101887:	8d 50 01             	lea    0x1(%eax),%edx
8010188a:	8b 45 08             	mov    0x8(%ebp),%eax
8010188d:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101890:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101897:	e8 8d 3a 00 00       	call   80105329 <release>
  return ip;
8010189c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010189f:	c9                   	leave  
801018a0:	c3                   	ret    

801018a1 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018a1:	55                   	push   %ebp
801018a2:	89 e5                	mov    %esp,%ebp
801018a4:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018ab:	74 0a                	je     801018b7 <ilock+0x16>
801018ad:	8b 45 08             	mov    0x8(%ebp),%eax
801018b0:	8b 40 08             	mov    0x8(%eax),%eax
801018b3:	85 c0                	test   %eax,%eax
801018b5:	7f 0c                	jg     801018c3 <ilock+0x22>
    panic("ilock");
801018b7:	c7 04 24 83 8b 10 80 	movl   $0x80108b83,(%esp)
801018be:	e8 77 ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801018c3:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801018ca:	e8 f8 39 00 00       	call   801052c7 <acquire>
  while(ip->flags & I_BUSY)
801018cf:	eb 13                	jmp    801018e4 <ilock+0x43>
    sleep(ip, &icache.lock);
801018d1:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
801018d8:	80 
801018d9:	8b 45 08             	mov    0x8(%ebp),%eax
801018dc:	89 04 24             	mov    %eax,(%esp)
801018df:	e8 ee 32 00 00       	call   80104bd2 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018e4:	8b 45 08             	mov    0x8(%ebp),%eax
801018e7:	8b 40 0c             	mov    0xc(%eax),%eax
801018ea:	83 e0 01             	and    $0x1,%eax
801018ed:	85 c0                	test   %eax,%eax
801018ef:	75 e0                	jne    801018d1 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018f1:	8b 45 08             	mov    0x8(%ebp),%eax
801018f4:	8b 40 0c             	mov    0xc(%eax),%eax
801018f7:	83 c8 01             	or     $0x1,%eax
801018fa:	89 c2                	mov    %eax,%edx
801018fc:	8b 45 08             	mov    0x8(%ebp),%eax
801018ff:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101902:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101909:	e8 1b 3a 00 00       	call   80105329 <release>

  if(!(ip->flags & I_VALID)){
8010190e:	8b 45 08             	mov    0x8(%ebp),%eax
80101911:	8b 40 0c             	mov    0xc(%eax),%eax
80101914:	83 e0 02             	and    $0x2,%eax
80101917:	85 c0                	test   %eax,%eax
80101919:	0f 85 ce 00 00 00    	jne    801019ed <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
8010191f:	8b 45 08             	mov    0x8(%ebp),%eax
80101922:	8b 40 04             	mov    0x4(%eax),%eax
80101925:	c1 e8 03             	shr    $0x3,%eax
80101928:	8d 50 02             	lea    0x2(%eax),%edx
8010192b:	8b 45 08             	mov    0x8(%ebp),%eax
8010192e:	8b 00                	mov    (%eax),%eax
80101930:	89 54 24 04          	mov    %edx,0x4(%esp)
80101934:	89 04 24             	mov    %eax,(%esp)
80101937:	e8 6a e8 ff ff       	call   801001a6 <bread>
8010193c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010193f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101942:	8d 50 18             	lea    0x18(%eax),%edx
80101945:	8b 45 08             	mov    0x8(%ebp),%eax
80101948:	8b 40 04             	mov    0x4(%eax),%eax
8010194b:	83 e0 07             	and    $0x7,%eax
8010194e:	c1 e0 06             	shl    $0x6,%eax
80101951:	01 d0                	add    %edx,%eax
80101953:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101956:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101959:	0f b7 10             	movzwl (%eax),%edx
8010195c:	8b 45 08             	mov    0x8(%ebp),%eax
8010195f:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101963:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101966:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010196a:	8b 45 08             	mov    0x8(%ebp),%eax
8010196d:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101971:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101974:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101978:	8b 45 08             	mov    0x8(%ebp),%eax
8010197b:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
8010197f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101982:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101986:	8b 45 08             	mov    0x8(%ebp),%eax
80101989:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
8010198d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101990:	8b 50 08             	mov    0x8(%eax),%edx
80101993:	8b 45 08             	mov    0x8(%ebp),%eax
80101996:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101999:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010199c:	8d 50 0c             	lea    0xc(%eax),%edx
8010199f:	8b 45 08             	mov    0x8(%ebp),%eax
801019a2:	83 c0 1c             	add    $0x1c,%eax
801019a5:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801019ac:	00 
801019ad:	89 54 24 04          	mov    %edx,0x4(%esp)
801019b1:	89 04 24             	mov    %eax,(%esp)
801019b4:	e8 31 3c 00 00       	call   801055ea <memmove>
    brelse(bp);
801019b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019bc:	89 04 24             	mov    %eax,(%esp)
801019bf:	e8 53 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
801019c4:	8b 45 08             	mov    0x8(%ebp),%eax
801019c7:	8b 40 0c             	mov    0xc(%eax),%eax
801019ca:	83 c8 02             	or     $0x2,%eax
801019cd:	89 c2                	mov    %eax,%edx
801019cf:	8b 45 08             	mov    0x8(%ebp),%eax
801019d2:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019d5:	8b 45 08             	mov    0x8(%ebp),%eax
801019d8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019dc:	66 85 c0             	test   %ax,%ax
801019df:	75 0c                	jne    801019ed <ilock+0x14c>
      panic("ilock: no type");
801019e1:	c7 04 24 89 8b 10 80 	movl   $0x80108b89,(%esp)
801019e8:	e8 4d eb ff ff       	call   8010053a <panic>
  }
}
801019ed:	c9                   	leave  
801019ee:	c3                   	ret    

801019ef <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019ef:	55                   	push   %ebp
801019f0:	89 e5                	mov    %esp,%ebp
801019f2:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019f9:	74 17                	je     80101a12 <iunlock+0x23>
801019fb:	8b 45 08             	mov    0x8(%ebp),%eax
801019fe:	8b 40 0c             	mov    0xc(%eax),%eax
80101a01:	83 e0 01             	and    $0x1,%eax
80101a04:	85 c0                	test   %eax,%eax
80101a06:	74 0a                	je     80101a12 <iunlock+0x23>
80101a08:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0b:	8b 40 08             	mov    0x8(%eax),%eax
80101a0e:	85 c0                	test   %eax,%eax
80101a10:	7f 0c                	jg     80101a1e <iunlock+0x2f>
    panic("iunlock");
80101a12:	c7 04 24 98 8b 10 80 	movl   $0x80108b98,(%esp)
80101a19:	e8 1c eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101a1e:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a25:	e8 9d 38 00 00       	call   801052c7 <acquire>
  ip->flags &= ~I_BUSY;
80101a2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2d:	8b 40 0c             	mov    0xc(%eax),%eax
80101a30:	83 e0 fe             	and    $0xfffffffe,%eax
80101a33:	89 c2                	mov    %eax,%edx
80101a35:	8b 45 08             	mov    0x8(%ebp),%eax
80101a38:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3e:	89 04 24             	mov    %eax,(%esp)
80101a41:	e8 68 32 00 00       	call   80104cae <wakeup>
  release(&icache.lock);
80101a46:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a4d:	e8 d7 38 00 00       	call   80105329 <release>
}
80101a52:	c9                   	leave  
80101a53:	c3                   	ret    

80101a54 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a54:	55                   	push   %ebp
80101a55:	89 e5                	mov    %esp,%ebp
80101a57:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a5a:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a61:	e8 61 38 00 00       	call   801052c7 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a66:	8b 45 08             	mov    0x8(%ebp),%eax
80101a69:	8b 40 08             	mov    0x8(%eax),%eax
80101a6c:	83 f8 01             	cmp    $0x1,%eax
80101a6f:	0f 85 93 00 00 00    	jne    80101b08 <iput+0xb4>
80101a75:	8b 45 08             	mov    0x8(%ebp),%eax
80101a78:	8b 40 0c             	mov    0xc(%eax),%eax
80101a7b:	83 e0 02             	and    $0x2,%eax
80101a7e:	85 c0                	test   %eax,%eax
80101a80:	0f 84 82 00 00 00    	je     80101b08 <iput+0xb4>
80101a86:	8b 45 08             	mov    0x8(%ebp),%eax
80101a89:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a8d:	66 85 c0             	test   %ax,%ax
80101a90:	75 76                	jne    80101b08 <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101a92:	8b 45 08             	mov    0x8(%ebp),%eax
80101a95:	8b 40 0c             	mov    0xc(%eax),%eax
80101a98:	83 e0 01             	and    $0x1,%eax
80101a9b:	85 c0                	test   %eax,%eax
80101a9d:	74 0c                	je     80101aab <iput+0x57>
      panic("iput busy");
80101a9f:	c7 04 24 a0 8b 10 80 	movl   $0x80108ba0,(%esp)
80101aa6:	e8 8f ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101aab:	8b 45 08             	mov    0x8(%ebp),%eax
80101aae:	8b 40 0c             	mov    0xc(%eax),%eax
80101ab1:	83 c8 01             	or     $0x1,%eax
80101ab4:	89 c2                	mov    %eax,%edx
80101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab9:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101abc:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101ac3:	e8 61 38 00 00       	call   80105329 <release>
    itrunc(ip);
80101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80101acb:	89 04 24             	mov    %eax,(%esp)
80101ace:	e8 7d 01 00 00       	call   80101c50 <itrunc>
    ip->type = 0;
80101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad6:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101adc:	8b 45 08             	mov    0x8(%ebp),%eax
80101adf:	89 04 24             	mov    %eax,(%esp)
80101ae2:	e8 fe fb ff ff       	call   801016e5 <iupdate>
    acquire(&icache.lock);
80101ae7:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101aee:	e8 d4 37 00 00       	call   801052c7 <acquire>
    ip->flags = 0;
80101af3:	8b 45 08             	mov    0x8(%ebp),%eax
80101af6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101afd:	8b 45 08             	mov    0x8(%ebp),%eax
80101b00:	89 04 24             	mov    %eax,(%esp)
80101b03:	e8 a6 31 00 00       	call   80104cae <wakeup>
  }
  ip->ref--;
80101b08:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0b:	8b 40 08             	mov    0x8(%eax),%eax
80101b0e:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b11:	8b 45 08             	mov    0x8(%ebp),%eax
80101b14:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b17:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101b1e:	e8 06 38 00 00       	call   80105329 <release>
}
80101b23:	c9                   	leave  
80101b24:	c3                   	ret    

80101b25 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b25:	55                   	push   %ebp
80101b26:	89 e5                	mov    %esp,%ebp
80101b28:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2e:	89 04 24             	mov    %eax,(%esp)
80101b31:	e8 b9 fe ff ff       	call   801019ef <iunlock>
  iput(ip);
80101b36:	8b 45 08             	mov    0x8(%ebp),%eax
80101b39:	89 04 24             	mov    %eax,(%esp)
80101b3c:	e8 13 ff ff ff       	call   80101a54 <iput>
}
80101b41:	c9                   	leave  
80101b42:	c3                   	ret    

80101b43 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b43:	55                   	push   %ebp
80101b44:	89 e5                	mov    %esp,%ebp
80101b46:	53                   	push   %ebx
80101b47:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b4a:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b4e:	77 3e                	ja     80101b8e <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b50:	8b 45 08             	mov    0x8(%ebp),%eax
80101b53:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b56:	83 c2 04             	add    $0x4,%edx
80101b59:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b64:	75 20                	jne    80101b86 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b66:	8b 45 08             	mov    0x8(%ebp),%eax
80101b69:	8b 00                	mov    (%eax),%eax
80101b6b:	89 04 24             	mov    %eax,(%esp)
80101b6e:	e8 5b f8 ff ff       	call   801013ce <balloc>
80101b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b76:	8b 45 08             	mov    0x8(%ebp),%eax
80101b79:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b7c:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b82:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b89:	e9 bc 00 00 00       	jmp    80101c4a <bmap+0x107>
  }
  bn -= NDIRECT;
80101b8e:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b92:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b96:	0f 87 a2 00 00 00    	ja     80101c3e <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9f:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ba5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ba9:	75 19                	jne    80101bc4 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101bab:	8b 45 08             	mov    0x8(%ebp),%eax
80101bae:	8b 00                	mov    (%eax),%eax
80101bb0:	89 04 24             	mov    %eax,(%esp)
80101bb3:	e8 16 f8 ff ff       	call   801013ce <balloc>
80101bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bc1:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc7:	8b 00                	mov    (%eax),%eax
80101bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bcc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bd0:	89 04 24             	mov    %eax,(%esp)
80101bd3:	e8 ce e5 ff ff       	call   801001a6 <bread>
80101bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bde:	83 c0 18             	add    $0x18,%eax
80101be1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101be4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101be7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bf1:	01 d0                	add    %edx,%eax
80101bf3:	8b 00                	mov    (%eax),%eax
80101bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bfc:	75 30                	jne    80101c2e <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c0b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c11:	8b 00                	mov    (%eax),%eax
80101c13:	89 04 24             	mov    %eax,(%esp)
80101c16:	e8 b3 f7 ff ff       	call   801013ce <balloc>
80101c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c21:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c26:	89 04 24             	mov    %eax,(%esp)
80101c29:	e8 33 1a 00 00       	call   80103661 <log_write>
    }
    brelse(bp);
80101c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c31:	89 04 24             	mov    %eax,(%esp)
80101c34:	e8 de e5 ff ff       	call   80100217 <brelse>
    return addr;
80101c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c3c:	eb 0c                	jmp    80101c4a <bmap+0x107>
  }

  panic("bmap: out of range");
80101c3e:	c7 04 24 aa 8b 10 80 	movl   $0x80108baa,(%esp)
80101c45:	e8 f0 e8 ff ff       	call   8010053a <panic>
}
80101c4a:	83 c4 24             	add    $0x24,%esp
80101c4d:	5b                   	pop    %ebx
80101c4e:	5d                   	pop    %ebp
80101c4f:	c3                   	ret    

80101c50 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c5d:	eb 44                	jmp    80101ca3 <itrunc+0x53>
    if(ip->addrs[i]){
80101c5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c65:	83 c2 04             	add    $0x4,%edx
80101c68:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c6c:	85 c0                	test   %eax,%eax
80101c6e:	74 2f                	je     80101c9f <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c70:	8b 45 08             	mov    0x8(%ebp),%eax
80101c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c76:	83 c2 04             	add    $0x4,%edx
80101c79:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c80:	8b 00                	mov    (%eax),%eax
80101c82:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c86:	89 04 24             	mov    %eax,(%esp)
80101c89:	e8 8e f8 ff ff       	call   8010151c <bfree>
      ip->addrs[i] = 0;
80101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c94:	83 c2 04             	add    $0x4,%edx
80101c97:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c9e:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c9f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101ca3:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101ca7:	7e b6                	jle    80101c5f <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cac:	8b 40 4c             	mov    0x4c(%eax),%eax
80101caf:	85 c0                	test   %eax,%eax
80101cb1:	0f 84 9b 00 00 00    	je     80101d52 <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cba:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc0:	8b 00                	mov    (%eax),%eax
80101cc2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cc6:	89 04 24             	mov    %eax,(%esp)
80101cc9:	e8 d8 e4 ff ff       	call   801001a6 <bread>
80101cce:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101cd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cd4:	83 c0 18             	add    $0x18,%eax
80101cd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101ce1:	eb 3b                	jmp    80101d1e <itrunc+0xce>
      if(a[j])
80101ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ce6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ced:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cf0:	01 d0                	add    %edx,%eax
80101cf2:	8b 00                	mov    (%eax),%eax
80101cf4:	85 c0                	test   %eax,%eax
80101cf6:	74 22                	je     80101d1a <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cfb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d02:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d05:	01 d0                	add    %edx,%eax
80101d07:	8b 10                	mov    (%eax),%edx
80101d09:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0c:	8b 00                	mov    (%eax),%eax
80101d0e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d12:	89 04 24             	mov    %eax,(%esp)
80101d15:	e8 02 f8 ff ff       	call   8010151c <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d1a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d21:	83 f8 7f             	cmp    $0x7f,%eax
80101d24:	76 bd                	jbe    80101ce3 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d29:	89 04 24             	mov    %eax,(%esp)
80101d2c:	e8 e6 e4 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d31:	8b 45 08             	mov    0x8(%ebp),%eax
80101d34:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d37:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3a:	8b 00                	mov    (%eax),%eax
80101d3c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d40:	89 04 24             	mov    %eax,(%esp)
80101d43:	e8 d4 f7 ff ff       	call   8010151c <bfree>
    ip->addrs[NDIRECT] = 0;
80101d48:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4b:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d52:	8b 45 08             	mov    0x8(%ebp),%eax
80101d55:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5f:	89 04 24             	mov    %eax,(%esp)
80101d62:	e8 7e f9 ff ff       	call   801016e5 <iupdate>
}
80101d67:	c9                   	leave  
80101d68:	c3                   	ret    

80101d69 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d69:	55                   	push   %ebp
80101d6a:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6f:	8b 00                	mov    (%eax),%eax
80101d71:	89 c2                	mov    %eax,%edx
80101d73:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d76:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d79:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7c:	8b 50 04             	mov    0x4(%eax),%edx
80101d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d82:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d85:	8b 45 08             	mov    0x8(%ebp),%eax
80101d88:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d8f:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d92:	8b 45 08             	mov    0x8(%ebp),%eax
80101d95:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d99:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d9c:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101da0:	8b 45 08             	mov    0x8(%ebp),%eax
80101da3:	8b 50 18             	mov    0x18(%eax),%edx
80101da6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101da9:	89 50 10             	mov    %edx,0x10(%eax)
}
80101dac:	5d                   	pop    %ebp
80101dad:	c3                   	ret    

80101dae <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101dae:	55                   	push   %ebp
80101daf:	89 e5                	mov    %esp,%ebp
80101db1:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101db4:	8b 45 08             	mov    0x8(%ebp),%eax
80101db7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101dbb:	66 83 f8 03          	cmp    $0x3,%ax
80101dbf:	75 60                	jne    80101e21 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101dc1:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dc8:	66 85 c0             	test   %ax,%ax
80101dcb:	78 20                	js     80101ded <readi+0x3f>
80101dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dd4:	66 83 f8 09          	cmp    $0x9,%ax
80101dd8:	7f 13                	jg     80101ded <readi+0x3f>
80101dda:	8b 45 08             	mov    0x8(%ebp),%eax
80101ddd:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101de1:	98                   	cwtl   
80101de2:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
80101de9:	85 c0                	test   %eax,%eax
80101deb:	75 0a                	jne    80101df7 <readi+0x49>
      return -1;
80101ded:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101df2:	e9 19 01 00 00       	jmp    80101f10 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101df7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfa:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dfe:	98                   	cwtl   
80101dff:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
80101e06:	8b 55 14             	mov    0x14(%ebp),%edx
80101e09:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e10:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e14:	8b 55 08             	mov    0x8(%ebp),%edx
80101e17:	89 14 24             	mov    %edx,(%esp)
80101e1a:	ff d0                	call   *%eax
80101e1c:	e9 ef 00 00 00       	jmp    80101f10 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101e21:	8b 45 08             	mov    0x8(%ebp),%eax
80101e24:	8b 40 18             	mov    0x18(%eax),%eax
80101e27:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e2a:	72 0d                	jb     80101e39 <readi+0x8b>
80101e2c:	8b 45 14             	mov    0x14(%ebp),%eax
80101e2f:	8b 55 10             	mov    0x10(%ebp),%edx
80101e32:	01 d0                	add    %edx,%eax
80101e34:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e37:	73 0a                	jae    80101e43 <readi+0x95>
    return -1;
80101e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e3e:	e9 cd 00 00 00       	jmp    80101f10 <readi+0x162>
  if(off + n > ip->size)
80101e43:	8b 45 14             	mov    0x14(%ebp),%eax
80101e46:	8b 55 10             	mov    0x10(%ebp),%edx
80101e49:	01 c2                	add    %eax,%edx
80101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4e:	8b 40 18             	mov    0x18(%eax),%eax
80101e51:	39 c2                	cmp    %eax,%edx
80101e53:	76 0c                	jbe    80101e61 <readi+0xb3>
    n = ip->size - off;
80101e55:	8b 45 08             	mov    0x8(%ebp),%eax
80101e58:	8b 40 18             	mov    0x18(%eax),%eax
80101e5b:	2b 45 10             	sub    0x10(%ebp),%eax
80101e5e:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e68:	e9 94 00 00 00       	jmp    80101f01 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e6d:	8b 45 10             	mov    0x10(%ebp),%eax
80101e70:	c1 e8 09             	shr    $0x9,%eax
80101e73:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e77:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7a:	89 04 24             	mov    %eax,(%esp)
80101e7d:	e8 c1 fc ff ff       	call   80101b43 <bmap>
80101e82:	8b 55 08             	mov    0x8(%ebp),%edx
80101e85:	8b 12                	mov    (%edx),%edx
80101e87:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e8b:	89 14 24             	mov    %edx,(%esp)
80101e8e:	e8 13 e3 ff ff       	call   801001a6 <bread>
80101e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e96:	8b 45 10             	mov    0x10(%ebp),%eax
80101e99:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e9e:	89 c2                	mov    %eax,%edx
80101ea0:	b8 00 02 00 00       	mov    $0x200,%eax
80101ea5:	29 d0                	sub    %edx,%eax
80101ea7:	89 c2                	mov    %eax,%edx
80101ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eac:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101eaf:	29 c1                	sub    %eax,%ecx
80101eb1:	89 c8                	mov    %ecx,%eax
80101eb3:	39 c2                	cmp    %eax,%edx
80101eb5:	0f 46 c2             	cmovbe %edx,%eax
80101eb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101ebb:	8b 45 10             	mov    0x10(%ebp),%eax
80101ebe:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ec3:	8d 50 10             	lea    0x10(%eax),%edx
80101ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ec9:	01 d0                	add    %edx,%eax
80101ecb:	8d 50 08             	lea    0x8(%eax),%edx
80101ece:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ed1:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ed5:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101edc:	89 04 24             	mov    %eax,(%esp)
80101edf:	e8 06 37 00 00       	call   801055ea <memmove>
    brelse(bp);
80101ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ee7:	89 04 24             	mov    %eax,(%esp)
80101eea:	e8 28 e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ef2:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ef8:	01 45 10             	add    %eax,0x10(%ebp)
80101efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101efe:	01 45 0c             	add    %eax,0xc(%ebp)
80101f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f04:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f07:	0f 82 60 ff ff ff    	jb     80101e6d <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f0d:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f10:	c9                   	leave  
80101f11:	c3                   	ret    

80101f12 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f12:	55                   	push   %ebp
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f1f:	66 83 f8 03          	cmp    $0x3,%ax
80101f23:	75 60                	jne    80101f85 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f25:	8b 45 08             	mov    0x8(%ebp),%eax
80101f28:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f2c:	66 85 c0             	test   %ax,%ax
80101f2f:	78 20                	js     80101f51 <writei+0x3f>
80101f31:	8b 45 08             	mov    0x8(%ebp),%eax
80101f34:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f38:	66 83 f8 09          	cmp    $0x9,%ax
80101f3c:	7f 13                	jg     80101f51 <writei+0x3f>
80101f3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f41:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f45:	98                   	cwtl   
80101f46:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
80101f4d:	85 c0                	test   %eax,%eax
80101f4f:	75 0a                	jne    80101f5b <writei+0x49>
      return -1;
80101f51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f56:	e9 44 01 00 00       	jmp    8010209f <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f62:	98                   	cwtl   
80101f63:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
80101f6a:	8b 55 14             	mov    0x14(%ebp),%edx
80101f6d:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f71:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f74:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f78:	8b 55 08             	mov    0x8(%ebp),%edx
80101f7b:	89 14 24             	mov    %edx,(%esp)
80101f7e:	ff d0                	call   *%eax
80101f80:	e9 1a 01 00 00       	jmp    8010209f <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f85:	8b 45 08             	mov    0x8(%ebp),%eax
80101f88:	8b 40 18             	mov    0x18(%eax),%eax
80101f8b:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f8e:	72 0d                	jb     80101f9d <writei+0x8b>
80101f90:	8b 45 14             	mov    0x14(%ebp),%eax
80101f93:	8b 55 10             	mov    0x10(%ebp),%edx
80101f96:	01 d0                	add    %edx,%eax
80101f98:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f9b:	73 0a                	jae    80101fa7 <writei+0x95>
    return -1;
80101f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fa2:	e9 f8 00 00 00       	jmp    8010209f <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101fa7:	8b 45 14             	mov    0x14(%ebp),%eax
80101faa:	8b 55 10             	mov    0x10(%ebp),%edx
80101fad:	01 d0                	add    %edx,%eax
80101faf:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101fb4:	76 0a                	jbe    80101fc0 <writei+0xae>
    return -1;
80101fb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fbb:	e9 df 00 00 00       	jmp    8010209f <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fc7:	e9 9f 00 00 00       	jmp    8010206b <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fcc:	8b 45 10             	mov    0x10(%ebp),%eax
80101fcf:	c1 e8 09             	shr    $0x9,%eax
80101fd2:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd9:	89 04 24             	mov    %eax,(%esp)
80101fdc:	e8 62 fb ff ff       	call   80101b43 <bmap>
80101fe1:	8b 55 08             	mov    0x8(%ebp),%edx
80101fe4:	8b 12                	mov    (%edx),%edx
80101fe6:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fea:	89 14 24             	mov    %edx,(%esp)
80101fed:	e8 b4 e1 ff ff       	call   801001a6 <bread>
80101ff2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ff5:	8b 45 10             	mov    0x10(%ebp),%eax
80101ff8:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ffd:	89 c2                	mov    %eax,%edx
80101fff:	b8 00 02 00 00       	mov    $0x200,%eax
80102004:	29 d0                	sub    %edx,%eax
80102006:	89 c2                	mov    %eax,%edx
80102008:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010200b:	8b 4d 14             	mov    0x14(%ebp),%ecx
8010200e:	29 c1                	sub    %eax,%ecx
80102010:	89 c8                	mov    %ecx,%eax
80102012:	39 c2                	cmp    %eax,%edx
80102014:	0f 46 c2             	cmovbe %edx,%eax
80102017:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010201a:	8b 45 10             	mov    0x10(%ebp),%eax
8010201d:	25 ff 01 00 00       	and    $0x1ff,%eax
80102022:	8d 50 10             	lea    0x10(%eax),%edx
80102025:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102028:	01 d0                	add    %edx,%eax
8010202a:	8d 50 08             	lea    0x8(%eax),%edx
8010202d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102030:	89 44 24 08          	mov    %eax,0x8(%esp)
80102034:	8b 45 0c             	mov    0xc(%ebp),%eax
80102037:	89 44 24 04          	mov    %eax,0x4(%esp)
8010203b:	89 14 24             	mov    %edx,(%esp)
8010203e:	e8 a7 35 00 00       	call   801055ea <memmove>
    log_write(bp);
80102043:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102046:	89 04 24             	mov    %eax,(%esp)
80102049:	e8 13 16 00 00       	call   80103661 <log_write>
    brelse(bp);
8010204e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102051:	89 04 24             	mov    %eax,(%esp)
80102054:	e8 be e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102059:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010205c:	01 45 f4             	add    %eax,-0xc(%ebp)
8010205f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102062:	01 45 10             	add    %eax,0x10(%ebp)
80102065:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102068:	01 45 0c             	add    %eax,0xc(%ebp)
8010206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010206e:	3b 45 14             	cmp    0x14(%ebp),%eax
80102071:	0f 82 55 ff ff ff    	jb     80101fcc <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102077:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010207b:	74 1f                	je     8010209c <writei+0x18a>
8010207d:	8b 45 08             	mov    0x8(%ebp),%eax
80102080:	8b 40 18             	mov    0x18(%eax),%eax
80102083:	3b 45 10             	cmp    0x10(%ebp),%eax
80102086:	73 14                	jae    8010209c <writei+0x18a>
    ip->size = off;
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8b 55 10             	mov    0x10(%ebp),%edx
8010208e:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102091:	8b 45 08             	mov    0x8(%ebp),%eax
80102094:	89 04 24             	mov    %eax,(%esp)
80102097:	e8 49 f6 ff ff       	call   801016e5 <iupdate>
  }
  return n;
8010209c:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010209f:	c9                   	leave  
801020a0:	c3                   	ret    

801020a1 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020a1:	55                   	push   %ebp
801020a2:	89 e5                	mov    %esp,%ebp
801020a4:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801020a7:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020ae:	00 
801020af:	8b 45 0c             	mov    0xc(%ebp),%eax
801020b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801020b6:	8b 45 08             	mov    0x8(%ebp),%eax
801020b9:	89 04 24             	mov    %eax,(%esp)
801020bc:	e8 cc 35 00 00       	call   8010568d <strncmp>
}
801020c1:	c9                   	leave  
801020c2:	c3                   	ret    

801020c3 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020c3:	55                   	push   %ebp
801020c4:	89 e5                	mov    %esp,%ebp
801020c6:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020c9:	8b 45 08             	mov    0x8(%ebp),%eax
801020cc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020d0:	66 83 f8 01          	cmp    $0x1,%ax
801020d4:	74 0c                	je     801020e2 <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020d6:	c7 04 24 bd 8b 10 80 	movl   $0x80108bbd,(%esp)
801020dd:	e8 58 e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020e9:	e9 88 00 00 00       	jmp    80102176 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ee:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020f5:	00 
801020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020f9:	89 44 24 08          	mov    %eax,0x8(%esp)
801020fd:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102100:	89 44 24 04          	mov    %eax,0x4(%esp)
80102104:	8b 45 08             	mov    0x8(%ebp),%eax
80102107:	89 04 24             	mov    %eax,(%esp)
8010210a:	e8 9f fc ff ff       	call   80101dae <readi>
8010210f:	83 f8 10             	cmp    $0x10,%eax
80102112:	74 0c                	je     80102120 <dirlookup+0x5d>
      panic("dirlink read");
80102114:	c7 04 24 cf 8b 10 80 	movl   $0x80108bcf,(%esp)
8010211b:	e8 1a e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
80102120:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102124:	66 85 c0             	test   %ax,%ax
80102127:	75 02                	jne    8010212b <dirlookup+0x68>
      continue;
80102129:	eb 47                	jmp    80102172 <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
8010212b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010212e:	83 c0 02             	add    $0x2,%eax
80102131:	89 44 24 04          	mov    %eax,0x4(%esp)
80102135:	8b 45 0c             	mov    0xc(%ebp),%eax
80102138:	89 04 24             	mov    %eax,(%esp)
8010213b:	e8 61 ff ff ff       	call   801020a1 <namecmp>
80102140:	85 c0                	test   %eax,%eax
80102142:	75 2e                	jne    80102172 <dirlookup+0xaf>
      // entry matches path element
      if(poff)
80102144:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102148:	74 08                	je     80102152 <dirlookup+0x8f>
        *poff = off;
8010214a:	8b 45 10             	mov    0x10(%ebp),%eax
8010214d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102150:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102152:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102156:	0f b7 c0             	movzwl %ax,%eax
80102159:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010215c:	8b 45 08             	mov    0x8(%ebp),%eax
8010215f:	8b 00                	mov    (%eax),%eax
80102161:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102164:	89 54 24 04          	mov    %edx,0x4(%esp)
80102168:	89 04 24             	mov    %eax,(%esp)
8010216b:	e8 2d f6 ff ff       	call   8010179d <iget>
80102170:	eb 18                	jmp    8010218a <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102172:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102176:	8b 45 08             	mov    0x8(%ebp),%eax
80102179:	8b 40 18             	mov    0x18(%eax),%eax
8010217c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010217f:	0f 87 69 ff ff ff    	ja     801020ee <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102185:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010218a:	c9                   	leave  
8010218b:	c3                   	ret    

8010218c <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010218c:	55                   	push   %ebp
8010218d:	89 e5                	mov    %esp,%ebp
8010218f:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102192:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102199:	00 
8010219a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010219d:	89 44 24 04          	mov    %eax,0x4(%esp)
801021a1:	8b 45 08             	mov    0x8(%ebp),%eax
801021a4:	89 04 24             	mov    %eax,(%esp)
801021a7:	e8 17 ff ff ff       	call   801020c3 <dirlookup>
801021ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021b3:	74 15                	je     801021ca <dirlink+0x3e>
    iput(ip);
801021b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021b8:	89 04 24             	mov    %eax,(%esp)
801021bb:	e8 94 f8 ff ff       	call   80101a54 <iput>
    return -1;
801021c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c5:	e9 b7 00 00 00       	jmp    80102281 <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021d1:	eb 46                	jmp    80102219 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021d6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021dd:	00 
801021de:	89 44 24 08          	mov    %eax,0x8(%esp)
801021e2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021e5:	89 44 24 04          	mov    %eax,0x4(%esp)
801021e9:	8b 45 08             	mov    0x8(%ebp),%eax
801021ec:	89 04 24             	mov    %eax,(%esp)
801021ef:	e8 ba fb ff ff       	call   80101dae <readi>
801021f4:	83 f8 10             	cmp    $0x10,%eax
801021f7:	74 0c                	je     80102205 <dirlink+0x79>
      panic("dirlink read");
801021f9:	c7 04 24 cf 8b 10 80 	movl   $0x80108bcf,(%esp)
80102200:	e8 35 e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
80102205:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102209:	66 85 c0             	test   %ax,%ax
8010220c:	75 02                	jne    80102210 <dirlink+0x84>
      break;
8010220e:	eb 16                	jmp    80102226 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102210:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102213:	83 c0 10             	add    $0x10,%eax
80102216:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102219:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010221c:	8b 45 08             	mov    0x8(%ebp),%eax
8010221f:	8b 40 18             	mov    0x18(%eax),%eax
80102222:	39 c2                	cmp    %eax,%edx
80102224:	72 ad                	jb     801021d3 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102226:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010222d:	00 
8010222e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102231:	89 44 24 04          	mov    %eax,0x4(%esp)
80102235:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102238:	83 c0 02             	add    $0x2,%eax
8010223b:	89 04 24             	mov    %eax,(%esp)
8010223e:	e8 a0 34 00 00       	call   801056e3 <strncpy>
  de.inum = inum;
80102243:	8b 45 10             	mov    0x10(%ebp),%eax
80102246:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010224d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102254:	00 
80102255:	89 44 24 08          	mov    %eax,0x8(%esp)
80102259:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010225c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102260:	8b 45 08             	mov    0x8(%ebp),%eax
80102263:	89 04 24             	mov    %eax,(%esp)
80102266:	e8 a7 fc ff ff       	call   80101f12 <writei>
8010226b:	83 f8 10             	cmp    $0x10,%eax
8010226e:	74 0c                	je     8010227c <dirlink+0xf0>
    panic("dirlink");
80102270:	c7 04 24 dc 8b 10 80 	movl   $0x80108bdc,(%esp)
80102277:	e8 be e2 ff ff       	call   8010053a <panic>
  
  return 0;
8010227c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102281:	c9                   	leave  
80102282:	c3                   	ret    

80102283 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102283:	55                   	push   %ebp
80102284:	89 e5                	mov    %esp,%ebp
80102286:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102289:	eb 04                	jmp    8010228f <skipelem+0xc>
    path++;
8010228b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010228f:	8b 45 08             	mov    0x8(%ebp),%eax
80102292:	0f b6 00             	movzbl (%eax),%eax
80102295:	3c 2f                	cmp    $0x2f,%al
80102297:	74 f2                	je     8010228b <skipelem+0x8>
    path++;
  if(*path == 0)
80102299:	8b 45 08             	mov    0x8(%ebp),%eax
8010229c:	0f b6 00             	movzbl (%eax),%eax
8010229f:	84 c0                	test   %al,%al
801022a1:	75 0a                	jne    801022ad <skipelem+0x2a>
    return 0;
801022a3:	b8 00 00 00 00       	mov    $0x0,%eax
801022a8:	e9 86 00 00 00       	jmp    80102333 <skipelem+0xb0>
  s = path;
801022ad:	8b 45 08             	mov    0x8(%ebp),%eax
801022b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022b3:	eb 04                	jmp    801022b9 <skipelem+0x36>
    path++;
801022b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022b9:	8b 45 08             	mov    0x8(%ebp),%eax
801022bc:	0f b6 00             	movzbl (%eax),%eax
801022bf:	3c 2f                	cmp    $0x2f,%al
801022c1:	74 0a                	je     801022cd <skipelem+0x4a>
801022c3:	8b 45 08             	mov    0x8(%ebp),%eax
801022c6:	0f b6 00             	movzbl (%eax),%eax
801022c9:	84 c0                	test   %al,%al
801022cb:	75 e8                	jne    801022b5 <skipelem+0x32>
    path++;
  len = path - s;
801022cd:	8b 55 08             	mov    0x8(%ebp),%edx
801022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d3:	29 c2                	sub    %eax,%edx
801022d5:	89 d0                	mov    %edx,%eax
801022d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022da:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022de:	7e 1c                	jle    801022fc <skipelem+0x79>
    memmove(name, s, DIRSIZ);
801022e0:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022e7:	00 
801022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801022ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801022f2:	89 04 24             	mov    %eax,(%esp)
801022f5:	e8 f0 32 00 00       	call   801055ea <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022fa:	eb 2a                	jmp    80102326 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022ff:	89 44 24 08          	mov    %eax,0x8(%esp)
80102303:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102306:	89 44 24 04          	mov    %eax,0x4(%esp)
8010230a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010230d:	89 04 24             	mov    %eax,(%esp)
80102310:	e8 d5 32 00 00       	call   801055ea <memmove>
    name[len] = 0;
80102315:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102318:	8b 45 0c             	mov    0xc(%ebp),%eax
8010231b:	01 d0                	add    %edx,%eax
8010231d:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102320:	eb 04                	jmp    80102326 <skipelem+0xa3>
    path++;
80102322:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102326:	8b 45 08             	mov    0x8(%ebp),%eax
80102329:	0f b6 00             	movzbl (%eax),%eax
8010232c:	3c 2f                	cmp    $0x2f,%al
8010232e:	74 f2                	je     80102322 <skipelem+0x9f>
    path++;
  return path;
80102330:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102333:	c9                   	leave  
80102334:	c3                   	ret    

80102335 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102335:	55                   	push   %ebp
80102336:	89 e5                	mov    %esp,%ebp
80102338:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010233b:	8b 45 08             	mov    0x8(%ebp),%eax
8010233e:	0f b6 00             	movzbl (%eax),%eax
80102341:	3c 2f                	cmp    $0x2f,%al
80102343:	75 1c                	jne    80102361 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102345:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010234c:	00 
8010234d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102354:	e8 44 f4 ff ff       	call   8010179d <iget>
80102359:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010235c:	e9 af 00 00 00       	jmp    80102410 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80102361:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102367:	8b 40 68             	mov    0x68(%eax),%eax
8010236a:	89 04 24             	mov    %eax,(%esp)
8010236d:	e8 fd f4 ff ff       	call   8010186f <idup>
80102372:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102375:	e9 96 00 00 00       	jmp    80102410 <namex+0xdb>
    ilock(ip);
8010237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010237d:	89 04 24             	mov    %eax,(%esp)
80102380:	e8 1c f5 ff ff       	call   801018a1 <ilock>
    if(ip->type != T_DIR){
80102385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102388:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010238c:	66 83 f8 01          	cmp    $0x1,%ax
80102390:	74 15                	je     801023a7 <namex+0x72>
      iunlockput(ip);
80102392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102395:	89 04 24             	mov    %eax,(%esp)
80102398:	e8 88 f7 ff ff       	call   80101b25 <iunlockput>
      return 0;
8010239d:	b8 00 00 00 00       	mov    $0x0,%eax
801023a2:	e9 a3 00 00 00       	jmp    8010244a <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
801023a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023ab:	74 1d                	je     801023ca <namex+0x95>
801023ad:	8b 45 08             	mov    0x8(%ebp),%eax
801023b0:	0f b6 00             	movzbl (%eax),%eax
801023b3:	84 c0                	test   %al,%al
801023b5:	75 13                	jne    801023ca <namex+0x95>
      // Stop one level early.
      iunlock(ip);
801023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ba:	89 04 24             	mov    %eax,(%esp)
801023bd:	e8 2d f6 ff ff       	call   801019ef <iunlock>
      return ip;
801023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c5:	e9 80 00 00 00       	jmp    8010244a <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023d1:	00 
801023d2:	8b 45 10             	mov    0x10(%ebp),%eax
801023d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023dc:	89 04 24             	mov    %eax,(%esp)
801023df:	e8 df fc ff ff       	call   801020c3 <dirlookup>
801023e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023eb:	75 12                	jne    801023ff <namex+0xca>
      iunlockput(ip);
801023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f0:	89 04 24             	mov    %eax,(%esp)
801023f3:	e8 2d f7 ff ff       	call   80101b25 <iunlockput>
      return 0;
801023f8:	b8 00 00 00 00       	mov    $0x0,%eax
801023fd:	eb 4b                	jmp    8010244a <namex+0x115>
    }
    iunlockput(ip);
801023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102402:	89 04 24             	mov    %eax,(%esp)
80102405:	e8 1b f7 ff ff       	call   80101b25 <iunlockput>
    ip = next;
8010240a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010240d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102410:	8b 45 10             	mov    0x10(%ebp),%eax
80102413:	89 44 24 04          	mov    %eax,0x4(%esp)
80102417:	8b 45 08             	mov    0x8(%ebp),%eax
8010241a:	89 04 24             	mov    %eax,(%esp)
8010241d:	e8 61 fe ff ff       	call   80102283 <skipelem>
80102422:	89 45 08             	mov    %eax,0x8(%ebp)
80102425:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102429:	0f 85 4b ff ff ff    	jne    8010237a <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010242f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102433:	74 12                	je     80102447 <namex+0x112>
    iput(ip);
80102435:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102438:	89 04 24             	mov    %eax,(%esp)
8010243b:	e8 14 f6 ff ff       	call   80101a54 <iput>
    return 0;
80102440:	b8 00 00 00 00       	mov    $0x0,%eax
80102445:	eb 03                	jmp    8010244a <namex+0x115>
  }
  return ip;
80102447:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010244a:	c9                   	leave  
8010244b:	c3                   	ret    

8010244c <namei>:

struct inode*
namei(char *path)
{
8010244c:	55                   	push   %ebp
8010244d:	89 e5                	mov    %esp,%ebp
8010244f:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102452:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102455:	89 44 24 08          	mov    %eax,0x8(%esp)
80102459:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102460:	00 
80102461:	8b 45 08             	mov    0x8(%ebp),%eax
80102464:	89 04 24             	mov    %eax,(%esp)
80102467:	e8 c9 fe ff ff       	call   80102335 <namex>
}
8010246c:	c9                   	leave  
8010246d:	c3                   	ret    

8010246e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010246e:	55                   	push   %ebp
8010246f:	89 e5                	mov    %esp,%ebp
80102471:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102474:	8b 45 0c             	mov    0xc(%ebp),%eax
80102477:	89 44 24 08          	mov    %eax,0x8(%esp)
8010247b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102482:	00 
80102483:	8b 45 08             	mov    0x8(%ebp),%eax
80102486:	89 04 24             	mov    %eax,(%esp)
80102489:	e8 a7 fe ff ff       	call   80102335 <namex>
}
8010248e:	c9                   	leave  
8010248f:	c3                   	ret    

80102490 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	83 ec 14             	sub    $0x14,%esp
80102496:	8b 45 08             	mov    0x8(%ebp),%eax
80102499:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010249d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024a1:	89 c2                	mov    %eax,%edx
801024a3:	ec                   	in     (%dx),%al
801024a4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024a7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024ab:	c9                   	leave  
801024ac:	c3                   	ret    

801024ad <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024ad:	55                   	push   %ebp
801024ae:	89 e5                	mov    %esp,%ebp
801024b0:	57                   	push   %edi
801024b1:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024b2:	8b 55 08             	mov    0x8(%ebp),%edx
801024b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024b8:	8b 45 10             	mov    0x10(%ebp),%eax
801024bb:	89 cb                	mov    %ecx,%ebx
801024bd:	89 df                	mov    %ebx,%edi
801024bf:	89 c1                	mov    %eax,%ecx
801024c1:	fc                   	cld    
801024c2:	f3 6d                	rep insl (%dx),%es:(%edi)
801024c4:	89 c8                	mov    %ecx,%eax
801024c6:	89 fb                	mov    %edi,%ebx
801024c8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024cb:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024ce:	5b                   	pop    %ebx
801024cf:	5f                   	pop    %edi
801024d0:	5d                   	pop    %ebp
801024d1:	c3                   	ret    

801024d2 <outb>:

static inline void
outb(ushort port, uchar data)
{
801024d2:	55                   	push   %ebp
801024d3:	89 e5                	mov    %esp,%ebp
801024d5:	83 ec 08             	sub    $0x8,%esp
801024d8:	8b 55 08             	mov    0x8(%ebp),%edx
801024db:	8b 45 0c             	mov    0xc(%ebp),%eax
801024de:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024e2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024e5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024e9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024ed:	ee                   	out    %al,(%dx)
}
801024ee:	c9                   	leave  
801024ef:	c3                   	ret    

801024f0 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	56                   	push   %esi
801024f4:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024f5:	8b 55 08             	mov    0x8(%ebp),%edx
801024f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024fb:	8b 45 10             	mov    0x10(%ebp),%eax
801024fe:	89 cb                	mov    %ecx,%ebx
80102500:	89 de                	mov    %ebx,%esi
80102502:	89 c1                	mov    %eax,%ecx
80102504:	fc                   	cld    
80102505:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102507:	89 c8                	mov    %ecx,%eax
80102509:	89 f3                	mov    %esi,%ebx
8010250b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010250e:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102511:	5b                   	pop    %ebx
80102512:	5e                   	pop    %esi
80102513:	5d                   	pop    %ebp
80102514:	c3                   	ret    

80102515 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102515:	55                   	push   %ebp
80102516:	89 e5                	mov    %esp,%ebp
80102518:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010251b:	90                   	nop
8010251c:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102523:	e8 68 ff ff ff       	call   80102490 <inb>
80102528:	0f b6 c0             	movzbl %al,%eax
8010252b:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010252e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102531:	25 c0 00 00 00       	and    $0xc0,%eax
80102536:	83 f8 40             	cmp    $0x40,%eax
80102539:	75 e1                	jne    8010251c <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010253b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010253f:	74 11                	je     80102552 <idewait+0x3d>
80102541:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102544:	83 e0 21             	and    $0x21,%eax
80102547:	85 c0                	test   %eax,%eax
80102549:	74 07                	je     80102552 <idewait+0x3d>
    return -1;
8010254b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102550:	eb 05                	jmp    80102557 <idewait+0x42>
  return 0;
80102552:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102557:	c9                   	leave  
80102558:	c3                   	ret    

80102559 <ideinit>:

void
ideinit(void)
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010255f:	c7 44 24 04 e4 8b 10 	movl   $0x80108be4,0x4(%esp)
80102566:	80 
80102567:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010256e:	e8 33 2d 00 00       	call   801052a6 <initlock>
  picenable(IRQ_IDE);
80102573:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010257a:	e8 7b 18 00 00       	call   80103dfa <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010257f:	a1 60 39 11 80       	mov    0x80113960,%eax
80102584:	83 e8 01             	sub    $0x1,%eax
80102587:	89 44 24 04          	mov    %eax,0x4(%esp)
8010258b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102592:	e8 0c 04 00 00       	call   801029a3 <ioapicenable>
  idewait(0);
80102597:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010259e:	e8 72 ff ff ff       	call   80102515 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025a3:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025aa:	00 
801025ab:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025b2:	e8 1b ff ff ff       	call   801024d2 <outb>
  for(i=0; i<1000; i++){
801025b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025be:	eb 20                	jmp    801025e0 <ideinit+0x87>
    if(inb(0x1f7) != 0){
801025c0:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025c7:	e8 c4 fe ff ff       	call   80102490 <inb>
801025cc:	84 c0                	test   %al,%al
801025ce:	74 0c                	je     801025dc <ideinit+0x83>
      havedisk1 = 1;
801025d0:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
801025d7:	00 00 00 
      break;
801025da:	eb 0d                	jmp    801025e9 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025e0:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025e7:	7e d7                	jle    801025c0 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025e9:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025f0:	00 
801025f1:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025f8:	e8 d5 fe ff ff       	call   801024d2 <outb>
}
801025fd:	c9                   	leave  
801025fe:	c3                   	ret    

801025ff <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025ff:	55                   	push   %ebp
80102600:	89 e5                	mov    %esp,%ebp
80102602:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102605:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102609:	75 0c                	jne    80102617 <idestart+0x18>
    panic("idestart");
8010260b:	c7 04 24 e8 8b 10 80 	movl   $0x80108be8,(%esp)
80102612:	e8 23 df ff ff       	call   8010053a <panic>

  idewait(0);
80102617:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010261e:	e8 f2 fe ff ff       	call   80102515 <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102623:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010262a:	00 
8010262b:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102632:	e8 9b fe ff ff       	call   801024d2 <outb>
  outb(0x1f2, 1);  // number of sectors
80102637:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010263e:	00 
8010263f:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102646:	e8 87 fe ff ff       	call   801024d2 <outb>
  outb(0x1f3, b->sector & 0xff);
8010264b:	8b 45 08             	mov    0x8(%ebp),%eax
8010264e:	8b 40 08             	mov    0x8(%eax),%eax
80102651:	0f b6 c0             	movzbl %al,%eax
80102654:	89 44 24 04          	mov    %eax,0x4(%esp)
80102658:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010265f:	e8 6e fe ff ff       	call   801024d2 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102664:	8b 45 08             	mov    0x8(%ebp),%eax
80102667:	8b 40 08             	mov    0x8(%eax),%eax
8010266a:	c1 e8 08             	shr    $0x8,%eax
8010266d:	0f b6 c0             	movzbl %al,%eax
80102670:	89 44 24 04          	mov    %eax,0x4(%esp)
80102674:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
8010267b:	e8 52 fe ff ff       	call   801024d2 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102680:	8b 45 08             	mov    0x8(%ebp),%eax
80102683:	8b 40 08             	mov    0x8(%eax),%eax
80102686:	c1 e8 10             	shr    $0x10,%eax
80102689:	0f b6 c0             	movzbl %al,%eax
8010268c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102690:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102697:	e8 36 fe ff ff       	call   801024d2 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
8010269c:	8b 45 08             	mov    0x8(%ebp),%eax
8010269f:	8b 40 04             	mov    0x4(%eax),%eax
801026a2:	83 e0 01             	and    $0x1,%eax
801026a5:	c1 e0 04             	shl    $0x4,%eax
801026a8:	89 c2                	mov    %eax,%edx
801026aa:	8b 45 08             	mov    0x8(%ebp),%eax
801026ad:	8b 40 08             	mov    0x8(%eax),%eax
801026b0:	c1 e8 18             	shr    $0x18,%eax
801026b3:	83 e0 0f             	and    $0xf,%eax
801026b6:	09 d0                	or     %edx,%eax
801026b8:	83 c8 e0             	or     $0xffffffe0,%eax
801026bb:	0f b6 c0             	movzbl %al,%eax
801026be:	89 44 24 04          	mov    %eax,0x4(%esp)
801026c2:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026c9:	e8 04 fe ff ff       	call   801024d2 <outb>
  if(b->flags & B_DIRTY){
801026ce:	8b 45 08             	mov    0x8(%ebp),%eax
801026d1:	8b 00                	mov    (%eax),%eax
801026d3:	83 e0 04             	and    $0x4,%eax
801026d6:	85 c0                	test   %eax,%eax
801026d8:	74 34                	je     8010270e <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026da:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026e1:	00 
801026e2:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026e9:	e8 e4 fd ff ff       	call   801024d2 <outb>
    outsl(0x1f0, b->data, 512/4);
801026ee:	8b 45 08             	mov    0x8(%ebp),%eax
801026f1:	83 c0 18             	add    $0x18,%eax
801026f4:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026fb:	00 
801026fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80102700:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102707:	e8 e4 fd ff ff       	call   801024f0 <outsl>
8010270c:	eb 14                	jmp    80102722 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
8010270e:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80102715:	00 
80102716:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010271d:	e8 b0 fd ff ff       	call   801024d2 <outb>
  }
}
80102722:	c9                   	leave  
80102723:	c3                   	ret    

80102724 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102724:	55                   	push   %ebp
80102725:	89 e5                	mov    %esp,%ebp
80102727:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010272a:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102731:	e8 91 2b 00 00       	call   801052c7 <acquire>
  if((b = idequeue) == 0){
80102736:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010273b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010273e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102742:	75 11                	jne    80102755 <ideintr+0x31>
    release(&idelock);
80102744:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010274b:	e8 d9 2b 00 00       	call   80105329 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102750:	e9 90 00 00 00       	jmp    801027e5 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102758:	8b 40 14             	mov    0x14(%eax),%eax
8010275b:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102760:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102763:	8b 00                	mov    (%eax),%eax
80102765:	83 e0 04             	and    $0x4,%eax
80102768:	85 c0                	test   %eax,%eax
8010276a:	75 2e                	jne    8010279a <ideintr+0x76>
8010276c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102773:	e8 9d fd ff ff       	call   80102515 <idewait>
80102778:	85 c0                	test   %eax,%eax
8010277a:	78 1e                	js     8010279a <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
8010277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010277f:	83 c0 18             	add    $0x18,%eax
80102782:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102789:	00 
8010278a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010278e:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102795:	e8 13 fd ff ff       	call   801024ad <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010279d:	8b 00                	mov    (%eax),%eax
8010279f:	83 c8 02             	or     $0x2,%eax
801027a2:	89 c2                	mov    %eax,%edx
801027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a7:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ac:	8b 00                	mov    (%eax),%eax
801027ae:	83 e0 fb             	and    $0xfffffffb,%eax
801027b1:	89 c2                	mov    %eax,%edx
801027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027b6:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027bb:	89 04 24             	mov    %eax,(%esp)
801027be:	e8 eb 24 00 00       	call   80104cae <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801027c3:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027c8:	85 c0                	test   %eax,%eax
801027ca:	74 0d                	je     801027d9 <ideintr+0xb5>
    idestart(idequeue);
801027cc:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027d1:	89 04 24             	mov    %eax,(%esp)
801027d4:	e8 26 fe ff ff       	call   801025ff <idestart>

  release(&idelock);
801027d9:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801027e0:	e8 44 2b 00 00       	call   80105329 <release>
}
801027e5:	c9                   	leave  
801027e6:	c3                   	ret    

801027e7 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027e7:	55                   	push   %ebp
801027e8:	89 e5                	mov    %esp,%ebp
801027ea:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027ed:	8b 45 08             	mov    0x8(%ebp),%eax
801027f0:	8b 00                	mov    (%eax),%eax
801027f2:	83 e0 01             	and    $0x1,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	75 0c                	jne    80102805 <iderw+0x1e>
    panic("iderw: buf not busy");
801027f9:	c7 04 24 f1 8b 10 80 	movl   $0x80108bf1,(%esp)
80102800:	e8 35 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102805:	8b 45 08             	mov    0x8(%ebp),%eax
80102808:	8b 00                	mov    (%eax),%eax
8010280a:	83 e0 06             	and    $0x6,%eax
8010280d:	83 f8 02             	cmp    $0x2,%eax
80102810:	75 0c                	jne    8010281e <iderw+0x37>
    panic("iderw: nothing to do");
80102812:	c7 04 24 05 8c 10 80 	movl   $0x80108c05,(%esp)
80102819:	e8 1c dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
8010281e:	8b 45 08             	mov    0x8(%ebp),%eax
80102821:	8b 40 04             	mov    0x4(%eax),%eax
80102824:	85 c0                	test   %eax,%eax
80102826:	74 15                	je     8010283d <iderw+0x56>
80102828:	a1 58 c6 10 80       	mov    0x8010c658,%eax
8010282d:	85 c0                	test   %eax,%eax
8010282f:	75 0c                	jne    8010283d <iderw+0x56>
    panic("iderw: ide disk 1 not present");
80102831:	c7 04 24 1a 8c 10 80 	movl   $0x80108c1a,(%esp)
80102838:	e8 fd dc ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010283d:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102844:	e8 7e 2a 00 00       	call   801052c7 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102849:	8b 45 08             	mov    0x8(%ebp),%eax
8010284c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102853:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
8010285a:	eb 0b                	jmp    80102867 <iderw+0x80>
8010285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010285f:	8b 00                	mov    (%eax),%eax
80102861:	83 c0 14             	add    $0x14,%eax
80102864:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102867:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010286a:	8b 00                	mov    (%eax),%eax
8010286c:	85 c0                	test   %eax,%eax
8010286e:	75 ec                	jne    8010285c <iderw+0x75>
    ;
  *pp = b;
80102870:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102873:	8b 55 08             	mov    0x8(%ebp),%edx
80102876:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102878:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010287d:	3b 45 08             	cmp    0x8(%ebp),%eax
80102880:	75 0d                	jne    8010288f <iderw+0xa8>
    idestart(b);
80102882:	8b 45 08             	mov    0x8(%ebp),%eax
80102885:	89 04 24             	mov    %eax,(%esp)
80102888:	e8 72 fd ff ff       	call   801025ff <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010288d:	eb 15                	jmp    801028a4 <iderw+0xbd>
8010288f:	eb 13                	jmp    801028a4 <iderw+0xbd>
    sleep(b, &idelock);
80102891:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
80102898:	80 
80102899:	8b 45 08             	mov    0x8(%ebp),%eax
8010289c:	89 04 24             	mov    %eax,(%esp)
8010289f:	e8 2e 23 00 00       	call   80104bd2 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028a4:	8b 45 08             	mov    0x8(%ebp),%eax
801028a7:	8b 00                	mov    (%eax),%eax
801028a9:	83 e0 06             	and    $0x6,%eax
801028ac:	83 f8 02             	cmp    $0x2,%eax
801028af:	75 e0                	jne    80102891 <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
801028b1:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801028b8:	e8 6c 2a 00 00       	call   80105329 <release>
}
801028bd:	c9                   	leave  
801028be:	c3                   	ret    

801028bf <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801028bf:	55                   	push   %ebp
801028c0:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028c2:	a1 34 32 11 80       	mov    0x80113234,%eax
801028c7:	8b 55 08             	mov    0x8(%ebp),%edx
801028ca:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801028cc:	a1 34 32 11 80       	mov    0x80113234,%eax
801028d1:	8b 40 10             	mov    0x10(%eax),%eax
}
801028d4:	5d                   	pop    %ebp
801028d5:	c3                   	ret    

801028d6 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028d6:	55                   	push   %ebp
801028d7:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028d9:	a1 34 32 11 80       	mov    0x80113234,%eax
801028de:	8b 55 08             	mov    0x8(%ebp),%edx
801028e1:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028e3:	a1 34 32 11 80       	mov    0x80113234,%eax
801028e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801028eb:	89 50 10             	mov    %edx,0x10(%eax)
}
801028ee:	5d                   	pop    %ebp
801028ef:	c3                   	ret    

801028f0 <ioapicinit>:

void
ioapicinit(void)
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028f6:	a1 64 33 11 80       	mov    0x80113364,%eax
801028fb:	85 c0                	test   %eax,%eax
801028fd:	75 05                	jne    80102904 <ioapicinit+0x14>
    return;
801028ff:	e9 9d 00 00 00       	jmp    801029a1 <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
80102904:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
8010290b:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010290e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102915:	e8 a5 ff ff ff       	call   801028bf <ioapicread>
8010291a:	c1 e8 10             	shr    $0x10,%eax
8010291d:	25 ff 00 00 00       	and    $0xff,%eax
80102922:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102925:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010292c:	e8 8e ff ff ff       	call   801028bf <ioapicread>
80102931:	c1 e8 18             	shr    $0x18,%eax
80102934:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102937:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
8010293e:	0f b6 c0             	movzbl %al,%eax
80102941:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102944:	74 0c                	je     80102952 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102946:	c7 04 24 38 8c 10 80 	movl   $0x80108c38,(%esp)
8010294d:	e8 4e da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102952:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102959:	eb 3e                	jmp    80102999 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010295e:	83 c0 20             	add    $0x20,%eax
80102961:	0d 00 00 01 00       	or     $0x10000,%eax
80102966:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102969:	83 c2 08             	add    $0x8,%edx
8010296c:	01 d2                	add    %edx,%edx
8010296e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102972:	89 14 24             	mov    %edx,(%esp)
80102975:	e8 5c ff ff ff       	call   801028d6 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010297d:	83 c0 08             	add    $0x8,%eax
80102980:	01 c0                	add    %eax,%eax
80102982:	83 c0 01             	add    $0x1,%eax
80102985:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010298c:	00 
8010298d:	89 04 24             	mov    %eax,(%esp)
80102990:	e8 41 ff ff ff       	call   801028d6 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102995:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102999:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010299c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010299f:	7e ba                	jle    8010295b <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029a1:	c9                   	leave  
801029a2:	c3                   	ret    

801029a3 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029a3:	55                   	push   %ebp
801029a4:	89 e5                	mov    %esp,%ebp
801029a6:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
801029a9:	a1 64 33 11 80       	mov    0x80113364,%eax
801029ae:	85 c0                	test   %eax,%eax
801029b0:	75 02                	jne    801029b4 <ioapicenable+0x11>
    return;
801029b2:	eb 37                	jmp    801029eb <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801029b4:	8b 45 08             	mov    0x8(%ebp),%eax
801029b7:	83 c0 20             	add    $0x20,%eax
801029ba:	8b 55 08             	mov    0x8(%ebp),%edx
801029bd:	83 c2 08             	add    $0x8,%edx
801029c0:	01 d2                	add    %edx,%edx
801029c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c6:	89 14 24             	mov    %edx,(%esp)
801029c9:	e8 08 ff ff ff       	call   801028d6 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801029d1:	c1 e0 18             	shl    $0x18,%eax
801029d4:	8b 55 08             	mov    0x8(%ebp),%edx
801029d7:	83 c2 08             	add    $0x8,%edx
801029da:	01 d2                	add    %edx,%edx
801029dc:	83 c2 01             	add    $0x1,%edx
801029df:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e3:	89 14 24             	mov    %edx,(%esp)
801029e6:	e8 eb fe ff ff       	call   801028d6 <ioapicwrite>
}
801029eb:	c9                   	leave  
801029ec:	c3                   	ret    

801029ed <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029ed:	55                   	push   %ebp
801029ee:	89 e5                	mov    %esp,%ebp
801029f0:	8b 45 08             	mov    0x8(%ebp),%eax
801029f3:	05 00 00 00 80       	add    $0x80000000,%eax
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    

801029fa <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029fa:	55                   	push   %ebp
801029fb:	89 e5                	mov    %esp,%ebp
801029fd:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a00:	c7 44 24 04 6a 8c 10 	movl   $0x80108c6a,0x4(%esp)
80102a07:	80 
80102a08:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102a0f:	e8 92 28 00 00       	call   801052a6 <initlock>
  kmem.use_lock = 0;
80102a14:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
80102a1b:	00 00 00 
  freerange(vstart, vend);
80102a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a21:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a25:	8b 45 08             	mov    0x8(%ebp),%eax
80102a28:	89 04 24             	mov    %eax,(%esp)
80102a2b:	e8 26 00 00 00       	call   80102a56 <freerange>
}
80102a30:	c9                   	leave  
80102a31:	c3                   	ret    

80102a32 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a32:	55                   	push   %ebp
80102a33:	89 e5                	mov    %esp,%ebp
80102a35:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a38:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a3f:	8b 45 08             	mov    0x8(%ebp),%eax
80102a42:	89 04 24             	mov    %eax,(%esp)
80102a45:	e8 0c 00 00 00       	call   80102a56 <freerange>
  kmem.use_lock = 1;
80102a4a:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102a51:	00 00 00 
}
80102a54:	c9                   	leave  
80102a55:	c3                   	ret    

80102a56 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a56:	55                   	push   %ebp
80102a57:	89 e5                	mov    %esp,%ebp
80102a59:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a5f:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a6c:	eb 12                	jmp    80102a80 <freerange+0x2a>
    kfree(p);
80102a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a71:	89 04 24             	mov    %eax,(%esp)
80102a74:	e8 16 00 00 00       	call   80102a8f <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a79:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a83:	05 00 10 00 00       	add    $0x1000,%eax
80102a88:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a8b:	76 e1                	jbe    80102a6e <freerange+0x18>
    kfree(p);
}
80102a8d:	c9                   	leave  
80102a8e:	c3                   	ret    

80102a8f <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a8f:	55                   	push   %ebp
80102a90:	89 e5                	mov    %esp,%ebp
80102a92:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a95:	8b 45 08             	mov    0x8(%ebp),%eax
80102a98:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a9d:	85 c0                	test   %eax,%eax
80102a9f:	75 1b                	jne    80102abc <kfree+0x2d>
80102aa1:	81 7d 08 5c 63 11 80 	cmpl   $0x8011635c,0x8(%ebp)
80102aa8:	72 12                	jb     80102abc <kfree+0x2d>
80102aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80102aad:	89 04 24             	mov    %eax,(%esp)
80102ab0:	e8 38 ff ff ff       	call   801029ed <v2p>
80102ab5:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102aba:	76 0c                	jbe    80102ac8 <kfree+0x39>
    panic("kfree");
80102abc:	c7 04 24 6f 8c 10 80 	movl   $0x80108c6f,(%esp)
80102ac3:	e8 72 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ac8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102acf:	00 
80102ad0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102ad7:	00 
80102ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80102adb:	89 04 24             	mov    %eax,(%esp)
80102ade:	e8 38 2a 00 00       	call   8010551b <memset>

  if(kmem.use_lock)
80102ae3:	a1 74 32 11 80       	mov    0x80113274,%eax
80102ae8:	85 c0                	test   %eax,%eax
80102aea:	74 0c                	je     80102af8 <kfree+0x69>
    acquire(&kmem.lock);
80102aec:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102af3:	e8 cf 27 00 00       	call   801052c7 <acquire>
  r = (struct run*)v;
80102af8:	8b 45 08             	mov    0x8(%ebp),%eax
80102afb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102afe:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b07:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b0c:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102b11:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b16:	85 c0                	test   %eax,%eax
80102b18:	74 0c                	je     80102b26 <kfree+0x97>
    release(&kmem.lock);
80102b1a:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b21:	e8 03 28 00 00       	call   80105329 <release>
}
80102b26:	c9                   	leave  
80102b27:	c3                   	ret    

80102b28 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b28:	55                   	push   %ebp
80102b29:	89 e5                	mov    %esp,%ebp
80102b2b:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b2e:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b33:	85 c0                	test   %eax,%eax
80102b35:	74 0c                	je     80102b43 <kalloc+0x1b>
    acquire(&kmem.lock);
80102b37:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b3e:	e8 84 27 00 00       	call   801052c7 <acquire>
  r = kmem.freelist;
80102b43:	a1 78 32 11 80       	mov    0x80113278,%eax
80102b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b4f:	74 0a                	je     80102b5b <kalloc+0x33>
    kmem.freelist = r->next;
80102b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b54:	8b 00                	mov    (%eax),%eax
80102b56:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102b5b:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b60:	85 c0                	test   %eax,%eax
80102b62:	74 0c                	je     80102b70 <kalloc+0x48>
    release(&kmem.lock);
80102b64:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b6b:	e8 b9 27 00 00       	call   80105329 <release>
  return (char*)r;
80102b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b73:	c9                   	leave  
80102b74:	c3                   	ret    

80102b75 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b75:	55                   	push   %ebp
80102b76:	89 e5                	mov    %esp,%ebp
80102b78:	83 ec 14             	sub    $0x14,%esp
80102b7b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b7e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b82:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b86:	89 c2                	mov    %eax,%edx
80102b88:	ec                   	in     (%dx),%al
80102b89:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b8c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b90:	c9                   	leave  
80102b91:	c3                   	ret    

80102b92 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b92:	55                   	push   %ebp
80102b93:	89 e5                	mov    %esp,%ebp
80102b95:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b98:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b9f:	e8 d1 ff ff ff       	call   80102b75 <inb>
80102ba4:	0f b6 c0             	movzbl %al,%eax
80102ba7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bad:	83 e0 01             	and    $0x1,%eax
80102bb0:	85 c0                	test   %eax,%eax
80102bb2:	75 0a                	jne    80102bbe <kbdgetc+0x2c>
    return -1;
80102bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102bb9:	e9 25 01 00 00       	jmp    80102ce3 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102bbe:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102bc5:	e8 ab ff ff ff       	call   80102b75 <inb>
80102bca:	0f b6 c0             	movzbl %al,%eax
80102bcd:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102bd0:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102bd7:	75 17                	jne    80102bf0 <kbdgetc+0x5e>
    shift |= E0ESC;
80102bd9:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102bde:	83 c8 40             	or     $0x40,%eax
80102be1:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102be6:	b8 00 00 00 00       	mov    $0x0,%eax
80102beb:	e9 f3 00 00 00       	jmp    80102ce3 <kbdgetc+0x151>
  } else if(data & 0x80){
80102bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bf3:	25 80 00 00 00       	and    $0x80,%eax
80102bf8:	85 c0                	test   %eax,%eax
80102bfa:	74 45                	je     80102c41 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bfc:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c01:	83 e0 40             	and    $0x40,%eax
80102c04:	85 c0                	test   %eax,%eax
80102c06:	75 08                	jne    80102c10 <kbdgetc+0x7e>
80102c08:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c0b:	83 e0 7f             	and    $0x7f,%eax
80102c0e:	eb 03                	jmp    80102c13 <kbdgetc+0x81>
80102c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c13:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c16:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c19:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c1e:	0f b6 00             	movzbl (%eax),%eax
80102c21:	83 c8 40             	or     $0x40,%eax
80102c24:	0f b6 c0             	movzbl %al,%eax
80102c27:	f7 d0                	not    %eax
80102c29:	89 c2                	mov    %eax,%edx
80102c2b:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c30:	21 d0                	and    %edx,%eax
80102c32:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c37:	b8 00 00 00 00       	mov    $0x0,%eax
80102c3c:	e9 a2 00 00 00       	jmp    80102ce3 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c41:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c46:	83 e0 40             	and    $0x40,%eax
80102c49:	85 c0                	test   %eax,%eax
80102c4b:	74 14                	je     80102c61 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c4d:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c54:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c59:	83 e0 bf             	and    $0xffffffbf,%eax
80102c5c:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c64:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c69:	0f b6 00             	movzbl (%eax),%eax
80102c6c:	0f b6 d0             	movzbl %al,%edx
80102c6f:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c74:	09 d0                	or     %edx,%eax
80102c76:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102c7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c7e:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102c83:	0f b6 00             	movzbl (%eax),%eax
80102c86:	0f b6 d0             	movzbl %al,%edx
80102c89:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c8e:	31 d0                	xor    %edx,%eax
80102c90:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c95:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c9a:	83 e0 03             	and    $0x3,%eax
80102c9d:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ca7:	01 d0                	add    %edx,%eax
80102ca9:	0f b6 00             	movzbl (%eax),%eax
80102cac:	0f b6 c0             	movzbl %al,%eax
80102caf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102cb2:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cb7:	83 e0 08             	and    $0x8,%eax
80102cba:	85 c0                	test   %eax,%eax
80102cbc:	74 22                	je     80102ce0 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102cbe:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102cc2:	76 0c                	jbe    80102cd0 <kbdgetc+0x13e>
80102cc4:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102cc8:	77 06                	ja     80102cd0 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102cca:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102cce:	eb 10                	jmp    80102ce0 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102cd0:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102cd4:	76 0a                	jbe    80102ce0 <kbdgetc+0x14e>
80102cd6:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102cda:	77 04                	ja     80102ce0 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102cdc:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102ce0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102ce3:	c9                   	leave  
80102ce4:	c3                   	ret    

80102ce5 <kbdintr>:

void
kbdintr(void)
{
80102ce5:	55                   	push   %ebp
80102ce6:	89 e5                	mov    %esp,%ebp
80102ce8:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102ceb:	c7 04 24 92 2b 10 80 	movl   $0x80102b92,(%esp)
80102cf2:	e8 b6 da ff ff       	call   801007ad <consoleintr>
}
80102cf7:	c9                   	leave  
80102cf8:	c3                   	ret    

80102cf9 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102cf9:	55                   	push   %ebp
80102cfa:	89 e5                	mov    %esp,%ebp
80102cfc:	83 ec 14             	sub    $0x14,%esp
80102cff:	8b 45 08             	mov    0x8(%ebp),%eax
80102d02:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d06:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d0a:	89 c2                	mov    %eax,%edx
80102d0c:	ec                   	in     (%dx),%al
80102d0d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d10:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d14:	c9                   	leave  
80102d15:	c3                   	ret    

80102d16 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d16:	55                   	push   %ebp
80102d17:	89 e5                	mov    %esp,%ebp
80102d19:	83 ec 08             	sub    $0x8,%esp
80102d1c:	8b 55 08             	mov    0x8(%ebp),%edx
80102d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d22:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d26:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d29:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d2d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102d31:	ee                   	out    %al,(%dx)
}
80102d32:	c9                   	leave  
80102d33:	c3                   	ret    

80102d34 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d34:	55                   	push   %ebp
80102d35:	89 e5                	mov    %esp,%ebp
80102d37:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d3a:	9c                   	pushf  
80102d3b:	58                   	pop    %eax
80102d3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102d3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d42:	c9                   	leave  
80102d43:	c3                   	ret    

80102d44 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d44:	55                   	push   %ebp
80102d45:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d47:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102d4c:	8b 55 08             	mov    0x8(%ebp),%edx
80102d4f:	c1 e2 02             	shl    $0x2,%edx
80102d52:	01 c2                	add    %eax,%edx
80102d54:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d57:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d59:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102d5e:	83 c0 20             	add    $0x20,%eax
80102d61:	8b 00                	mov    (%eax),%eax
}
80102d63:	5d                   	pop    %ebp
80102d64:	c3                   	ret    

80102d65 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d65:	55                   	push   %ebp
80102d66:	89 e5                	mov    %esp,%ebp
80102d68:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d6b:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102d70:	85 c0                	test   %eax,%eax
80102d72:	75 05                	jne    80102d79 <lapicinit+0x14>
    return;
80102d74:	e9 43 01 00 00       	jmp    80102ebc <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d79:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d80:	00 
80102d81:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d88:	e8 b7 ff ff ff       	call   80102d44 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d8d:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d94:	00 
80102d95:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d9c:	e8 a3 ff ff ff       	call   80102d44 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102da1:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102da8:	00 
80102da9:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102db0:	e8 8f ff ff ff       	call   80102d44 <lapicw>
  lapicw(TICR, 10000000); 
80102db5:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102dbc:	00 
80102dbd:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102dc4:	e8 7b ff ff ff       	call   80102d44 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102dc9:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dd0:	00 
80102dd1:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102dd8:	e8 67 ff ff ff       	call   80102d44 <lapicw>
  lapicw(LINT1, MASKED);
80102ddd:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102de4:	00 
80102de5:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102dec:	e8 53 ff ff ff       	call   80102d44 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102df1:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102df6:	83 c0 30             	add    $0x30,%eax
80102df9:	8b 00                	mov    (%eax),%eax
80102dfb:	c1 e8 10             	shr    $0x10,%eax
80102dfe:	0f b6 c0             	movzbl %al,%eax
80102e01:	83 f8 03             	cmp    $0x3,%eax
80102e04:	76 14                	jbe    80102e1a <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102e06:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e0d:	00 
80102e0e:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e15:	e8 2a ff ff ff       	call   80102d44 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e1a:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e21:	00 
80102e22:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e29:	e8 16 ff ff ff       	call   80102d44 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e2e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e35:	00 
80102e36:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e3d:	e8 02 ff ff ff       	call   80102d44 <lapicw>
  lapicw(ESR, 0);
80102e42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e49:	00 
80102e4a:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e51:	e8 ee fe ff ff       	call   80102d44 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e56:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e5d:	00 
80102e5e:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e65:	e8 da fe ff ff       	call   80102d44 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e6a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e71:	00 
80102e72:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e79:	e8 c6 fe ff ff       	call   80102d44 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e7e:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e85:	00 
80102e86:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e8d:	e8 b2 fe ff ff       	call   80102d44 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e92:	90                   	nop
80102e93:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e98:	05 00 03 00 00       	add    $0x300,%eax
80102e9d:	8b 00                	mov    (%eax),%eax
80102e9f:	25 00 10 00 00       	and    $0x1000,%eax
80102ea4:	85 c0                	test   %eax,%eax
80102ea6:	75 eb                	jne    80102e93 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102ea8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eaf:	00 
80102eb0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102eb7:	e8 88 fe ff ff       	call   80102d44 <lapicw>
}
80102ebc:	c9                   	leave  
80102ebd:	c3                   	ret    

80102ebe <cpunum>:

int
cpunum(void)
{
80102ebe:	55                   	push   %ebp
80102ebf:	89 e5                	mov    %esp,%ebp
80102ec1:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102ec4:	e8 6b fe ff ff       	call   80102d34 <readeflags>
80102ec9:	25 00 02 00 00       	and    $0x200,%eax
80102ece:	85 c0                	test   %eax,%eax
80102ed0:	74 25                	je     80102ef7 <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102ed2:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102ed7:	8d 50 01             	lea    0x1(%eax),%edx
80102eda:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102ee0:	85 c0                	test   %eax,%eax
80102ee2:	75 13                	jne    80102ef7 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102ee4:	8b 45 04             	mov    0x4(%ebp),%eax
80102ee7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102eeb:	c7 04 24 78 8c 10 80 	movl   $0x80108c78,(%esp)
80102ef2:	e8 a9 d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102ef7:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102efc:	85 c0                	test   %eax,%eax
80102efe:	74 0f                	je     80102f0f <cpunum+0x51>
    return lapic[ID]>>24;
80102f00:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f05:	83 c0 20             	add    $0x20,%eax
80102f08:	8b 00                	mov    (%eax),%eax
80102f0a:	c1 e8 18             	shr    $0x18,%eax
80102f0d:	eb 05                	jmp    80102f14 <cpunum+0x56>
  return 0;
80102f0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f14:	c9                   	leave  
80102f15:	c3                   	ret    

80102f16 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f16:	55                   	push   %ebp
80102f17:	89 e5                	mov    %esp,%ebp
80102f19:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f1c:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f21:	85 c0                	test   %eax,%eax
80102f23:	74 14                	je     80102f39 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f25:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f2c:	00 
80102f2d:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f34:	e8 0b fe ff ff       	call   80102d44 <lapicw>
}
80102f39:	c9                   	leave  
80102f3a:	c3                   	ret    

80102f3b <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f3b:	55                   	push   %ebp
80102f3c:	89 e5                	mov    %esp,%ebp
}
80102f3e:	5d                   	pop    %ebp
80102f3f:	c3                   	ret    

80102f40 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	83 ec 1c             	sub    $0x1c,%esp
80102f46:	8b 45 08             	mov    0x8(%ebp),%eax
80102f49:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f4c:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f53:	00 
80102f54:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f5b:	e8 b6 fd ff ff       	call   80102d16 <outb>
  outb(CMOS_PORT+1, 0x0A);
80102f60:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f67:	00 
80102f68:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f6f:	e8 a2 fd ff ff       	call   80102d16 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f74:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f7e:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f83:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f86:	8d 50 02             	lea    0x2(%eax),%edx
80102f89:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f8c:	c1 e8 04             	shr    $0x4,%eax
80102f8f:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f92:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f96:	c1 e0 18             	shl    $0x18,%eax
80102f99:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f9d:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fa4:	e8 9b fd ff ff       	call   80102d44 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102fa9:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102fb0:	00 
80102fb1:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fb8:	e8 87 fd ff ff       	call   80102d44 <lapicw>
  microdelay(200);
80102fbd:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fc4:	e8 72 ff ff ff       	call   80102f3b <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102fc9:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102fd0:	00 
80102fd1:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fd8:	e8 67 fd ff ff       	call   80102d44 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fdd:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fe4:	e8 52 ff ff ff       	call   80102f3b <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fe9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102ff0:	eb 40                	jmp    80103032 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102ff2:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102ff6:	c1 e0 18             	shl    $0x18,%eax
80102ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ffd:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103004:	e8 3b fd ff ff       	call   80102d44 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80103009:	8b 45 0c             	mov    0xc(%ebp),%eax
8010300c:	c1 e8 0c             	shr    $0xc,%eax
8010300f:	80 cc 06             	or     $0x6,%ah
80103012:	89 44 24 04          	mov    %eax,0x4(%esp)
80103016:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010301d:	e8 22 fd ff ff       	call   80102d44 <lapicw>
    microdelay(200);
80103022:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103029:	e8 0d ff ff ff       	call   80102f3b <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010302e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103032:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103036:	7e ba                	jle    80102ff2 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103038:	c9                   	leave  
80103039:	c3                   	ret    

8010303a <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010303a:	55                   	push   %ebp
8010303b:	89 e5                	mov    %esp,%ebp
8010303d:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
80103040:	8b 45 08             	mov    0x8(%ebp),%eax
80103043:	0f b6 c0             	movzbl %al,%eax
80103046:	89 44 24 04          	mov    %eax,0x4(%esp)
8010304a:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103051:	e8 c0 fc ff ff       	call   80102d16 <outb>
  microdelay(200);
80103056:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010305d:	e8 d9 fe ff ff       	call   80102f3b <microdelay>

  return inb(CMOS_RETURN);
80103062:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103069:	e8 8b fc ff ff       	call   80102cf9 <inb>
8010306e:	0f b6 c0             	movzbl %al,%eax
}
80103071:	c9                   	leave  
80103072:	c3                   	ret    

80103073 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103073:	55                   	push   %ebp
80103074:	89 e5                	mov    %esp,%ebp
80103076:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103079:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80103080:	e8 b5 ff ff ff       	call   8010303a <cmos_read>
80103085:	8b 55 08             	mov    0x8(%ebp),%edx
80103088:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
8010308a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80103091:	e8 a4 ff ff ff       	call   8010303a <cmos_read>
80103096:	8b 55 08             	mov    0x8(%ebp),%edx
80103099:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
8010309c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801030a3:	e8 92 ff ff ff       	call   8010303a <cmos_read>
801030a8:	8b 55 08             	mov    0x8(%ebp),%edx
801030ab:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801030ae:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
801030b5:	e8 80 ff ff ff       	call   8010303a <cmos_read>
801030ba:	8b 55 08             	mov    0x8(%ebp),%edx
801030bd:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
801030c0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801030c7:	e8 6e ff ff ff       	call   8010303a <cmos_read>
801030cc:	8b 55 08             	mov    0x8(%ebp),%edx
801030cf:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
801030d2:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
801030d9:	e8 5c ff ff ff       	call   8010303a <cmos_read>
801030de:	8b 55 08             	mov    0x8(%ebp),%edx
801030e1:	89 42 14             	mov    %eax,0x14(%edx)
}
801030e4:	c9                   	leave  
801030e5:	c3                   	ret    

801030e6 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801030e6:	55                   	push   %ebp
801030e7:	89 e5                	mov    %esp,%ebp
801030e9:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801030ec:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
801030f3:	e8 42 ff ff ff       	call   8010303a <cmos_read>
801030f8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030fe:	83 e0 04             	and    $0x4,%eax
80103101:	85 c0                	test   %eax,%eax
80103103:	0f 94 c0             	sete   %al
80103106:	0f b6 c0             	movzbl %al,%eax
80103109:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
8010310c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010310f:	89 04 24             	mov    %eax,(%esp)
80103112:	e8 5c ff ff ff       	call   80103073 <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103117:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010311e:	e8 17 ff ff ff       	call   8010303a <cmos_read>
80103123:	25 80 00 00 00       	and    $0x80,%eax
80103128:	85 c0                	test   %eax,%eax
8010312a:	74 02                	je     8010312e <cmostime+0x48>
        continue;
8010312c:	eb 36                	jmp    80103164 <cmostime+0x7e>
    fill_rtcdate(&t2);
8010312e:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103131:	89 04 24             	mov    %eax,(%esp)
80103134:	e8 3a ff ff ff       	call   80103073 <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103139:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80103140:	00 
80103141:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103144:	89 44 24 04          	mov    %eax,0x4(%esp)
80103148:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010314b:	89 04 24             	mov    %eax,(%esp)
8010314e:	e8 3f 24 00 00       	call   80105592 <memcmp>
80103153:	85 c0                	test   %eax,%eax
80103155:	75 0d                	jne    80103164 <cmostime+0x7e>
      break;
80103157:	90                   	nop
  }

  // convert
  if (bcd) {
80103158:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010315c:	0f 84 ac 00 00 00    	je     8010320e <cmostime+0x128>
80103162:	eb 02                	jmp    80103166 <cmostime+0x80>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103164:	eb a6                	jmp    8010310c <cmostime+0x26>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103166:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103169:	c1 e8 04             	shr    $0x4,%eax
8010316c:	89 c2                	mov    %eax,%edx
8010316e:	89 d0                	mov    %edx,%eax
80103170:	c1 e0 02             	shl    $0x2,%eax
80103173:	01 d0                	add    %edx,%eax
80103175:	01 c0                	add    %eax,%eax
80103177:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010317a:	83 e2 0f             	and    $0xf,%edx
8010317d:	01 d0                	add    %edx,%eax
8010317f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103182:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103185:	c1 e8 04             	shr    $0x4,%eax
80103188:	89 c2                	mov    %eax,%edx
8010318a:	89 d0                	mov    %edx,%eax
8010318c:	c1 e0 02             	shl    $0x2,%eax
8010318f:	01 d0                	add    %edx,%eax
80103191:	01 c0                	add    %eax,%eax
80103193:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103196:	83 e2 0f             	and    $0xf,%edx
80103199:	01 d0                	add    %edx,%eax
8010319b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010319e:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031a1:	c1 e8 04             	shr    $0x4,%eax
801031a4:	89 c2                	mov    %eax,%edx
801031a6:	89 d0                	mov    %edx,%eax
801031a8:	c1 e0 02             	shl    $0x2,%eax
801031ab:	01 d0                	add    %edx,%eax
801031ad:	01 c0                	add    %eax,%eax
801031af:	8b 55 e0             	mov    -0x20(%ebp),%edx
801031b2:	83 e2 0f             	and    $0xf,%edx
801031b5:	01 d0                	add    %edx,%eax
801031b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801031ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031bd:	c1 e8 04             	shr    $0x4,%eax
801031c0:	89 c2                	mov    %eax,%edx
801031c2:	89 d0                	mov    %edx,%eax
801031c4:	c1 e0 02             	shl    $0x2,%eax
801031c7:	01 d0                	add    %edx,%eax
801031c9:	01 c0                	add    %eax,%eax
801031cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801031ce:	83 e2 0f             	and    $0xf,%edx
801031d1:	01 d0                	add    %edx,%eax
801031d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801031d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801031d9:	c1 e8 04             	shr    $0x4,%eax
801031dc:	89 c2                	mov    %eax,%edx
801031de:	89 d0                	mov    %edx,%eax
801031e0:	c1 e0 02             	shl    $0x2,%eax
801031e3:	01 d0                	add    %edx,%eax
801031e5:	01 c0                	add    %eax,%eax
801031e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031ea:	83 e2 0f             	and    $0xf,%edx
801031ed:	01 d0                	add    %edx,%eax
801031ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801031f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031f5:	c1 e8 04             	shr    $0x4,%eax
801031f8:	89 c2                	mov    %eax,%edx
801031fa:	89 d0                	mov    %edx,%eax
801031fc:	c1 e0 02             	shl    $0x2,%eax
801031ff:	01 d0                	add    %edx,%eax
80103201:	01 c0                	add    %eax,%eax
80103203:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103206:	83 e2 0f             	and    $0xf,%edx
80103209:	01 d0                	add    %edx,%eax
8010320b:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010320e:	8b 45 08             	mov    0x8(%ebp),%eax
80103211:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103214:	89 10                	mov    %edx,(%eax)
80103216:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103219:	89 50 04             	mov    %edx,0x4(%eax)
8010321c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010321f:	89 50 08             	mov    %edx,0x8(%eax)
80103222:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103225:	89 50 0c             	mov    %edx,0xc(%eax)
80103228:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010322b:	89 50 10             	mov    %edx,0x10(%eax)
8010322e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103231:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103234:	8b 45 08             	mov    0x8(%ebp),%eax
80103237:	8b 40 14             	mov    0x14(%eax),%eax
8010323a:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103240:	8b 45 08             	mov    0x8(%ebp),%eax
80103243:	89 50 14             	mov    %edx,0x14(%eax)
}
80103246:	c9                   	leave  
80103247:	c3                   	ret    

80103248 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
80103248:	55                   	push   %ebp
80103249:	89 e5                	mov    %esp,%ebp
8010324b:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010324e:	c7 44 24 04 a4 8c 10 	movl   $0x80108ca4,0x4(%esp)
80103255:	80 
80103256:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010325d:	e8 44 20 00 00       	call   801052a6 <initlock>
  readsb(ROOTDEV, &sb);
80103262:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103265:	89 44 24 04          	mov    %eax,0x4(%esp)
80103269:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103270:	e8 c2 e0 ff ff       	call   80101337 <readsb>
  log.start = sb.size - sb.nlog;
80103275:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010327b:	29 c2                	sub    %eax,%edx
8010327d:	89 d0                	mov    %edx,%eax
8010327f:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
80103284:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103287:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = ROOTDEV;
8010328c:	c7 05 c4 32 11 80 01 	movl   $0x1,0x801132c4
80103293:	00 00 00 
  recover_from_log();
80103296:	e8 9a 01 00 00       	call   80103435 <recover_from_log>
}
8010329b:	c9                   	leave  
8010329c:	c3                   	ret    

8010329d <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010329d:	55                   	push   %ebp
8010329e:	89 e5                	mov    %esp,%ebp
801032a0:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032aa:	e9 8c 00 00 00       	jmp    8010333b <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032af:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
801032b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032b8:	01 d0                	add    %edx,%eax
801032ba:	83 c0 01             	add    $0x1,%eax
801032bd:	89 c2                	mov    %eax,%edx
801032bf:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801032c4:	89 54 24 04          	mov    %edx,0x4(%esp)
801032c8:	89 04 24             	mov    %eax,(%esp)
801032cb:	e8 d6 ce ff ff       	call   801001a6 <bread>
801032d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801032d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032d6:	83 c0 10             	add    $0x10,%eax
801032d9:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801032e0:	89 c2                	mov    %eax,%edx
801032e2:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801032e7:	89 54 24 04          	mov    %edx,0x4(%esp)
801032eb:	89 04 24             	mov    %eax,(%esp)
801032ee:	e8 b3 ce ff ff       	call   801001a6 <bread>
801032f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032f9:	8d 50 18             	lea    0x18(%eax),%edx
801032fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032ff:	83 c0 18             	add    $0x18,%eax
80103302:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103309:	00 
8010330a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010330e:	89 04 24             	mov    %eax,(%esp)
80103311:	e8 d4 22 00 00       	call   801055ea <memmove>
    bwrite(dbuf);  // write dst to disk
80103316:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103319:	89 04 24             	mov    %eax,(%esp)
8010331c:	e8 bc ce ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
80103321:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103324:	89 04 24             	mov    %eax,(%esp)
80103327:	e8 eb ce ff ff       	call   80100217 <brelse>
    brelse(dbuf);
8010332c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010332f:	89 04 24             	mov    %eax,(%esp)
80103332:	e8 e0 ce ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103337:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010333b:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103340:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103343:	0f 8f 66 ff ff ff    	jg     801032af <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103349:	c9                   	leave  
8010334a:	c3                   	ret    

8010334b <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010334b:	55                   	push   %ebp
8010334c:	89 e5                	mov    %esp,%ebp
8010334e:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103351:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103356:	89 c2                	mov    %eax,%edx
80103358:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010335d:	89 54 24 04          	mov    %edx,0x4(%esp)
80103361:	89 04 24             	mov    %eax,(%esp)
80103364:	e8 3d ce ff ff       	call   801001a6 <bread>
80103369:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010336c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010336f:	83 c0 18             	add    $0x18,%eax
80103372:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103375:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103378:	8b 00                	mov    (%eax),%eax
8010337a:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
8010337f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103386:	eb 1b                	jmp    801033a3 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103388:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010338b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010338e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103392:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103395:	83 c2 10             	add    $0x10,%edx
80103398:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010339f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033a3:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801033a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033ab:	7f db                	jg     80103388 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
801033ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033b0:	89 04 24             	mov    %eax,(%esp)
801033b3:	e8 5f ce ff ff       	call   80100217 <brelse>
}
801033b8:	c9                   	leave  
801033b9:	c3                   	ret    

801033ba <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801033ba:	55                   	push   %ebp
801033bb:	89 e5                	mov    %esp,%ebp
801033bd:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801033c0:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801033c5:	89 c2                	mov    %eax,%edx
801033c7:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801033cc:	89 54 24 04          	mov    %edx,0x4(%esp)
801033d0:	89 04 24             	mov    %eax,(%esp)
801033d3:	e8 ce cd ff ff       	call   801001a6 <bread>
801033d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801033db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033de:	83 c0 18             	add    $0x18,%eax
801033e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801033e4:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
801033ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033ed:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801033ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033f6:	eb 1b                	jmp    80103413 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801033f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033fb:	83 c0 10             	add    $0x10,%eax
801033fe:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
80103405:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103408:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010340b:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010340f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103413:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103418:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010341b:	7f db                	jg     801033f8 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
8010341d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103420:	89 04 24             	mov    %eax,(%esp)
80103423:	e8 b5 cd ff ff       	call   801001dd <bwrite>
  brelse(buf);
80103428:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010342b:	89 04 24             	mov    %eax,(%esp)
8010342e:	e8 e4 cd ff ff       	call   80100217 <brelse>
}
80103433:	c9                   	leave  
80103434:	c3                   	ret    

80103435 <recover_from_log>:

static void
recover_from_log(void)
{
80103435:	55                   	push   %ebp
80103436:	89 e5                	mov    %esp,%ebp
80103438:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010343b:	e8 0b ff ff ff       	call   8010334b <read_head>
  install_trans(); // if committed, copy from log to disk
80103440:	e8 58 fe ff ff       	call   8010329d <install_trans>
  log.lh.n = 0;
80103445:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
8010344c:	00 00 00 
  write_head(); // clear the log
8010344f:	e8 66 ff ff ff       	call   801033ba <write_head>
}
80103454:	c9                   	leave  
80103455:	c3                   	ret    

80103456 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103456:	55                   	push   %ebp
80103457:	89 e5                	mov    %esp,%ebp
80103459:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
8010345c:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103463:	e8 5f 1e 00 00       	call   801052c7 <acquire>
  while(1){
    if(log.committing){
80103468:	a1 c0 32 11 80       	mov    0x801132c0,%eax
8010346d:	85 c0                	test   %eax,%eax
8010346f:	74 16                	je     80103487 <begin_op+0x31>
      sleep(&log, &log.lock);
80103471:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
80103478:	80 
80103479:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103480:	e8 4d 17 00 00       	call   80104bd2 <sleep>
80103485:	eb 4f                	jmp    801034d6 <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103487:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
8010348d:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103492:	8d 50 01             	lea    0x1(%eax),%edx
80103495:	89 d0                	mov    %edx,%eax
80103497:	c1 e0 02             	shl    $0x2,%eax
8010349a:	01 d0                	add    %edx,%eax
8010349c:	01 c0                	add    %eax,%eax
8010349e:	01 c8                	add    %ecx,%eax
801034a0:	83 f8 1e             	cmp    $0x1e,%eax
801034a3:	7e 16                	jle    801034bb <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801034a5:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
801034ac:	80 
801034ad:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801034b4:	e8 19 17 00 00       	call   80104bd2 <sleep>
801034b9:	eb 1b                	jmp    801034d6 <begin_op+0x80>
    } else {
      log.outstanding += 1;
801034bb:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801034c0:	83 c0 01             	add    $0x1,%eax
801034c3:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
801034c8:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801034cf:	e8 55 1e 00 00       	call   80105329 <release>
      break;
801034d4:	eb 02                	jmp    801034d8 <begin_op+0x82>
    }
  }
801034d6:	eb 90                	jmp    80103468 <begin_op+0x12>
}
801034d8:	c9                   	leave  
801034d9:	c3                   	ret    

801034da <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801034da:	55                   	push   %ebp
801034db:	89 e5                	mov    %esp,%ebp
801034dd:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
801034e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801034e7:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801034ee:	e8 d4 1d 00 00       	call   801052c7 <acquire>
  log.outstanding -= 1;
801034f3:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801034f8:	83 e8 01             	sub    $0x1,%eax
801034fb:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
80103500:	a1 c0 32 11 80       	mov    0x801132c0,%eax
80103505:	85 c0                	test   %eax,%eax
80103507:	74 0c                	je     80103515 <end_op+0x3b>
    panic("log.committing");
80103509:	c7 04 24 a8 8c 10 80 	movl   $0x80108ca8,(%esp)
80103510:	e8 25 d0 ff ff       	call   8010053a <panic>
  if(log.outstanding == 0){
80103515:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010351a:	85 c0                	test   %eax,%eax
8010351c:	75 13                	jne    80103531 <end_op+0x57>
    do_commit = 1;
8010351e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103525:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
8010352c:	00 00 00 
8010352f:	eb 0c                	jmp    8010353d <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103531:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103538:	e8 71 17 00 00       	call   80104cae <wakeup>
  }
  release(&log.lock);
8010353d:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103544:	e8 e0 1d 00 00       	call   80105329 <release>

  if(do_commit){
80103549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010354d:	74 33                	je     80103582 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010354f:	e8 de 00 00 00       	call   80103632 <commit>
    acquire(&log.lock);
80103554:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010355b:	e8 67 1d 00 00       	call   801052c7 <acquire>
    log.committing = 0;
80103560:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
80103567:	00 00 00 
    wakeup(&log);
8010356a:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103571:	e8 38 17 00 00       	call   80104cae <wakeup>
    release(&log.lock);
80103576:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010357d:	e8 a7 1d 00 00       	call   80105329 <release>
  }
}
80103582:	c9                   	leave  
80103583:	c3                   	ret    

80103584 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103584:	55                   	push   %ebp
80103585:	89 e5                	mov    %esp,%ebp
80103587:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010358a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103591:	e9 8c 00 00 00       	jmp    80103622 <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103596:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010359c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010359f:	01 d0                	add    %edx,%eax
801035a1:	83 c0 01             	add    $0x1,%eax
801035a4:	89 c2                	mov    %eax,%edx
801035a6:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801035ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801035af:	89 04 24             	mov    %eax,(%esp)
801035b2:	e8 ef cb ff ff       	call   801001a6 <bread>
801035b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
801035ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035bd:	83 c0 10             	add    $0x10,%eax
801035c0:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801035c7:	89 c2                	mov    %eax,%edx
801035c9:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801035ce:	89 54 24 04          	mov    %edx,0x4(%esp)
801035d2:	89 04 24             	mov    %eax,(%esp)
801035d5:	e8 cc cb ff ff       	call   801001a6 <bread>
801035da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801035dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035e0:	8d 50 18             	lea    0x18(%eax),%edx
801035e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035e6:	83 c0 18             	add    $0x18,%eax
801035e9:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801035f0:	00 
801035f1:	89 54 24 04          	mov    %edx,0x4(%esp)
801035f5:	89 04 24             	mov    %eax,(%esp)
801035f8:	e8 ed 1f 00 00       	call   801055ea <memmove>
    bwrite(to);  // write the log
801035fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103600:	89 04 24             	mov    %eax,(%esp)
80103603:	e8 d5 cb ff ff       	call   801001dd <bwrite>
    brelse(from); 
80103608:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010360b:	89 04 24             	mov    %eax,(%esp)
8010360e:	e8 04 cc ff ff       	call   80100217 <brelse>
    brelse(to);
80103613:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103616:	89 04 24             	mov    %eax,(%esp)
80103619:	e8 f9 cb ff ff       	call   80100217 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010361e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103622:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103627:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010362a:	0f 8f 66 ff ff ff    	jg     80103596 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103630:	c9                   	leave  
80103631:	c3                   	ret    

80103632 <commit>:

static void
commit()
{
80103632:	55                   	push   %ebp
80103633:	89 e5                	mov    %esp,%ebp
80103635:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103638:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010363d:	85 c0                	test   %eax,%eax
8010363f:	7e 1e                	jle    8010365f <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103641:	e8 3e ff ff ff       	call   80103584 <write_log>
    write_head();    // Write header to disk -- the real commit
80103646:	e8 6f fd ff ff       	call   801033ba <write_head>
    install_trans(); // Now install writes to home locations
8010364b:	e8 4d fc ff ff       	call   8010329d <install_trans>
    log.lh.n = 0; 
80103650:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
80103657:	00 00 00 
    write_head();    // Erase the transaction from the log
8010365a:	e8 5b fd ff ff       	call   801033ba <write_head>
  }
}
8010365f:	c9                   	leave  
80103660:	c3                   	ret    

80103661 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103661:	55                   	push   %ebp
80103662:	89 e5                	mov    %esp,%ebp
80103664:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103667:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010366c:	83 f8 1d             	cmp    $0x1d,%eax
8010366f:	7f 12                	jg     80103683 <log_write+0x22>
80103671:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103676:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
8010367c:	83 ea 01             	sub    $0x1,%edx
8010367f:	39 d0                	cmp    %edx,%eax
80103681:	7c 0c                	jl     8010368f <log_write+0x2e>
    panic("too big a transaction");
80103683:	c7 04 24 b7 8c 10 80 	movl   $0x80108cb7,(%esp)
8010368a:	e8 ab ce ff ff       	call   8010053a <panic>
  if (log.outstanding < 1)
8010368f:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103694:	85 c0                	test   %eax,%eax
80103696:	7f 0c                	jg     801036a4 <log_write+0x43>
    panic("log_write outside of trans");
80103698:	c7 04 24 cd 8c 10 80 	movl   $0x80108ccd,(%esp)
8010369f:	e8 96 ce ff ff       	call   8010053a <panic>

  acquire(&log.lock);
801036a4:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801036ab:	e8 17 1c 00 00       	call   801052c7 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801036b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036b7:	eb 1f                	jmp    801036d8 <log_write+0x77>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
801036b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036bc:	83 c0 10             	add    $0x10,%eax
801036bf:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801036c6:	89 c2                	mov    %eax,%edx
801036c8:	8b 45 08             	mov    0x8(%ebp),%eax
801036cb:	8b 40 08             	mov    0x8(%eax),%eax
801036ce:	39 c2                	cmp    %eax,%edx
801036d0:	75 02                	jne    801036d4 <log_write+0x73>
      break;
801036d2:	eb 0e                	jmp    801036e2 <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801036d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036d8:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036e0:	7f d7                	jg     801036b9 <log_write+0x58>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
  }
  log.lh.sector[i] = b->sector;
801036e2:	8b 45 08             	mov    0x8(%ebp),%eax
801036e5:	8b 40 08             	mov    0x8(%eax),%eax
801036e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036eb:	83 c2 10             	add    $0x10,%edx
801036ee:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
  if (i == log.lh.n)
801036f5:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036fd:	75 0d                	jne    8010370c <log_write+0xab>
    log.lh.n++;
801036ff:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103704:	83 c0 01             	add    $0x1,%eax
80103707:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
8010370c:	8b 45 08             	mov    0x8(%ebp),%eax
8010370f:	8b 00                	mov    (%eax),%eax
80103711:	83 c8 04             	or     $0x4,%eax
80103714:	89 c2                	mov    %eax,%edx
80103716:	8b 45 08             	mov    0x8(%ebp),%eax
80103719:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010371b:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103722:	e8 02 1c 00 00       	call   80105329 <release>
}
80103727:	c9                   	leave  
80103728:	c3                   	ret    

80103729 <v2p>:
80103729:	55                   	push   %ebp
8010372a:	89 e5                	mov    %esp,%ebp
8010372c:	8b 45 08             	mov    0x8(%ebp),%eax
8010372f:	05 00 00 00 80       	add    $0x80000000,%eax
80103734:	5d                   	pop    %ebp
80103735:	c3                   	ret    

80103736 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103736:	55                   	push   %ebp
80103737:	89 e5                	mov    %esp,%ebp
80103739:	8b 45 08             	mov    0x8(%ebp),%eax
8010373c:	05 00 00 00 80       	add    $0x80000000,%eax
80103741:	5d                   	pop    %ebp
80103742:	c3                   	ret    

80103743 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103743:	55                   	push   %ebp
80103744:	89 e5                	mov    %esp,%ebp
80103746:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103749:	8b 55 08             	mov    0x8(%ebp),%edx
8010374c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010374f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103752:	f0 87 02             	lock xchg %eax,(%edx)
80103755:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103758:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010375b:	c9                   	leave  
8010375c:	c3                   	ret    

8010375d <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010375d:	55                   	push   %ebp
8010375e:	89 e5                	mov    %esp,%ebp
80103760:	83 e4 f0             	and    $0xfffffff0,%esp
80103763:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103766:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
8010376d:	80 
8010376e:	c7 04 24 5c 63 11 80 	movl   $0x8011635c,(%esp)
80103775:	e8 80 f2 ff ff       	call   801029fa <kinit1>
  kvmalloc();      // kernel page table
8010377a:	e8 6c 4b 00 00       	call   801082eb <kvmalloc>
  mpinit();        // collect info about this machine
8010377f:	e8 46 04 00 00       	call   80103bca <mpinit>
  lapicinit();
80103784:	e8 dc f5 ff ff       	call   80102d65 <lapicinit>
  seginit();       // set up segments
80103789:	e8 f0 44 00 00       	call   80107c7e <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010378e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103794:	0f b6 00             	movzbl (%eax),%eax
80103797:	0f b6 c0             	movzbl %al,%eax
8010379a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010379e:	c7 04 24 e8 8c 10 80 	movl   $0x80108ce8,(%esp)
801037a5:	e8 f6 cb ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
801037aa:	e8 79 06 00 00       	call   80103e28 <picinit>
  ioapicinit();    // another interrupt controller
801037af:	e8 3c f1 ff ff       	call   801028f0 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801037b4:	e8 c8 d2 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
801037b9:	e8 0f 38 00 00       	call   80106fcd <uartinit>
  pinit();         // process table
801037be:	e8 6f 0b 00 00       	call   80104332 <pinit>
  tvinit();        // trap vectors
801037c3:	e8 9b 33 00 00       	call   80106b63 <tvinit>
  binit();         // buffer cache
801037c8:	e8 67 c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801037cd:	e8 7e d7 ff ff       	call   80100f50 <fileinit>
  iinit();         // inode cache
801037d2:	e8 13 de ff ff       	call   801015ea <iinit>
  ideinit();       // disk
801037d7:	e8 7d ed ff ff       	call   80102559 <ideinit>
  if(!ismp)
801037dc:	a1 64 33 11 80       	mov    0x80113364,%eax
801037e1:	85 c0                	test   %eax,%eax
801037e3:	75 05                	jne    801037ea <main+0x8d>
    timerinit();   // uniprocessor timer
801037e5:	e8 c4 32 00 00       	call   80106aae <timerinit>
  startothers();   // start other processors
801037ea:	e8 7f 00 00 00       	call   8010386e <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037ef:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801037f6:	8e 
801037f7:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801037fe:	e8 2f f2 ff ff       	call   80102a32 <kinit2>
  userinit();      // first user process
80103803:	e8 48 0c 00 00       	call   80104450 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103808:	e8 1a 00 00 00       	call   80103827 <mpmain>

8010380d <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010380d:	55                   	push   %ebp
8010380e:	89 e5                	mov    %esp,%ebp
80103810:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103813:	e8 ea 4a 00 00       	call   80108302 <switchkvm>
  seginit();
80103818:	e8 61 44 00 00       	call   80107c7e <seginit>
  lapicinit();
8010381d:	e8 43 f5 ff ff       	call   80102d65 <lapicinit>
  mpmain();
80103822:	e8 00 00 00 00       	call   80103827 <mpmain>

80103827 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103827:	55                   	push   %ebp
80103828:	89 e5                	mov    %esp,%ebp
8010382a:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010382d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103833:	0f b6 00             	movzbl (%eax),%eax
80103836:	0f b6 c0             	movzbl %al,%eax
80103839:	89 44 24 04          	mov    %eax,0x4(%esp)
8010383d:	c7 04 24 ff 8c 10 80 	movl   $0x80108cff,(%esp)
80103844:	e8 57 cb ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
80103849:	e8 89 34 00 00       	call   80106cd7 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010384e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103854:	05 a8 00 00 00       	add    $0xa8,%eax
80103859:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103860:	00 
80103861:	89 04 24             	mov    %eax,(%esp)
80103864:	e8 da fe ff ff       	call   80103743 <xchg>
  scheduler();     // start running processes
80103869:	e8 b9 11 00 00       	call   80104a27 <scheduler>

8010386e <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010386e:	55                   	push   %ebp
8010386f:	89 e5                	mov    %esp,%ebp
80103871:	53                   	push   %ebx
80103872:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103875:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
8010387c:	e8 b5 fe ff ff       	call   80103736 <p2v>
80103881:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103884:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103889:	89 44 24 08          	mov    %eax,0x8(%esp)
8010388d:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
80103894:	80 
80103895:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103898:	89 04 24             	mov    %eax,(%esp)
8010389b:	e8 4a 1d 00 00       	call   801055ea <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801038a0:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
801038a7:	e9 85 00 00 00       	jmp    80103931 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
801038ac:	e8 0d f6 ff ff       	call   80102ebe <cpunum>
801038b1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801038b7:	05 80 33 11 80       	add    $0x80113380,%eax
801038bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038bf:	75 02                	jne    801038c3 <startothers+0x55>
      continue;
801038c1:	eb 67                	jmp    8010392a <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801038c3:	e8 60 f2 ff ff       	call   80102b28 <kalloc>
801038c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801038cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ce:	83 e8 04             	sub    $0x4,%eax
801038d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801038d4:	81 c2 00 10 00 00    	add    $0x1000,%edx
801038da:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801038dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038df:	83 e8 08             	sub    $0x8,%eax
801038e2:	c7 00 0d 38 10 80    	movl   $0x8010380d,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801038e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038eb:	8d 58 f4             	lea    -0xc(%eax),%ebx
801038ee:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
801038f5:	e8 2f fe ff ff       	call   80103729 <v2p>
801038fa:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801038fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ff:	89 04 24             	mov    %eax,(%esp)
80103902:	e8 22 fe ff ff       	call   80103729 <v2p>
80103907:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010390a:	0f b6 12             	movzbl (%edx),%edx
8010390d:	0f b6 d2             	movzbl %dl,%edx
80103910:	89 44 24 04          	mov    %eax,0x4(%esp)
80103914:	89 14 24             	mov    %edx,(%esp)
80103917:	e8 24 f6 ff ff       	call   80102f40 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010391c:	90                   	nop
8010391d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103920:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103926:	85 c0                	test   %eax,%eax
80103928:	74 f3                	je     8010391d <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010392a:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103931:	a1 60 39 11 80       	mov    0x80113960,%eax
80103936:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010393c:	05 80 33 11 80       	add    $0x80113380,%eax
80103941:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103944:	0f 87 62 ff ff ff    	ja     801038ac <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
8010394a:	83 c4 24             	add    $0x24,%esp
8010394d:	5b                   	pop    %ebx
8010394e:	5d                   	pop    %ebp
8010394f:	c3                   	ret    

80103950 <p2v>:
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	8b 45 08             	mov    0x8(%ebp),%eax
80103956:	05 00 00 00 80       	add    $0x80000000,%eax
8010395b:	5d                   	pop    %ebp
8010395c:	c3                   	ret    

8010395d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010395d:	55                   	push   %ebp
8010395e:	89 e5                	mov    %esp,%ebp
80103960:	83 ec 14             	sub    $0x14,%esp
80103963:	8b 45 08             	mov    0x8(%ebp),%eax
80103966:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010396a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010396e:	89 c2                	mov    %eax,%edx
80103970:	ec                   	in     (%dx),%al
80103971:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103974:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103978:	c9                   	leave  
80103979:	c3                   	ret    

8010397a <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010397a:	55                   	push   %ebp
8010397b:	89 e5                	mov    %esp,%ebp
8010397d:	83 ec 08             	sub    $0x8,%esp
80103980:	8b 55 08             	mov    0x8(%ebp),%edx
80103983:	8b 45 0c             	mov    0xc(%ebp),%eax
80103986:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010398a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010398d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103991:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103995:	ee                   	out    %al,(%dx)
}
80103996:	c9                   	leave  
80103997:	c3                   	ret    

80103998 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103998:	55                   	push   %ebp
80103999:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
8010399b:	a1 64 c6 10 80       	mov    0x8010c664,%eax
801039a0:	89 c2                	mov    %eax,%edx
801039a2:	b8 80 33 11 80       	mov    $0x80113380,%eax
801039a7:	29 c2                	sub    %eax,%edx
801039a9:	89 d0                	mov    %edx,%eax
801039ab:	c1 f8 02             	sar    $0x2,%eax
801039ae:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
801039b4:	5d                   	pop    %ebp
801039b5:	c3                   	ret    

801039b6 <sum>:

static uchar
sum(uchar *addr, int len)
{
801039b6:	55                   	push   %ebp
801039b7:	89 e5                	mov    %esp,%ebp
801039b9:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
801039bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
801039c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801039ca:	eb 15                	jmp    801039e1 <sum+0x2b>
    sum += addr[i];
801039cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
801039cf:	8b 45 08             	mov    0x8(%ebp),%eax
801039d2:	01 d0                	add    %edx,%eax
801039d4:	0f b6 00             	movzbl (%eax),%eax
801039d7:	0f b6 c0             	movzbl %al,%eax
801039da:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801039dd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801039e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801039e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801039e7:	7c e3                	jl     801039cc <sum+0x16>
    sum += addr[i];
  return sum;
801039e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801039ec:	c9                   	leave  
801039ed:	c3                   	ret    

801039ee <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801039ee:	55                   	push   %ebp
801039ef:	89 e5                	mov    %esp,%ebp
801039f1:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801039f4:	8b 45 08             	mov    0x8(%ebp),%eax
801039f7:	89 04 24             	mov    %eax,(%esp)
801039fa:	e8 51 ff ff ff       	call   80103950 <p2v>
801039ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103a02:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a08:	01 d0                	add    %edx,%eax
80103a0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a13:	eb 3f                	jmp    80103a54 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a15:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103a1c:	00 
80103a1d:	c7 44 24 04 10 8d 10 	movl   $0x80108d10,0x4(%esp)
80103a24:	80 
80103a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a28:	89 04 24             	mov    %eax,(%esp)
80103a2b:	e8 62 1b 00 00       	call   80105592 <memcmp>
80103a30:	85 c0                	test   %eax,%eax
80103a32:	75 1c                	jne    80103a50 <mpsearch1+0x62>
80103a34:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103a3b:	00 
80103a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a3f:	89 04 24             	mov    %eax,(%esp)
80103a42:	e8 6f ff ff ff       	call   801039b6 <sum>
80103a47:	84 c0                	test   %al,%al
80103a49:	75 05                	jne    80103a50 <mpsearch1+0x62>
      return (struct mp*)p;
80103a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a4e:	eb 11                	jmp    80103a61 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a50:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a57:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a5a:	72 b9                	jb     80103a15 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103a5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a61:	c9                   	leave  
80103a62:	c3                   	ret    

80103a63 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103a63:	55                   	push   %ebp
80103a64:	89 e5                	mov    %esp,%ebp
80103a66:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103a69:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a73:	83 c0 0f             	add    $0xf,%eax
80103a76:	0f b6 00             	movzbl (%eax),%eax
80103a79:	0f b6 c0             	movzbl %al,%eax
80103a7c:	c1 e0 08             	shl    $0x8,%eax
80103a7f:	89 c2                	mov    %eax,%edx
80103a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a84:	83 c0 0e             	add    $0xe,%eax
80103a87:	0f b6 00             	movzbl (%eax),%eax
80103a8a:	0f b6 c0             	movzbl %al,%eax
80103a8d:	09 d0                	or     %edx,%eax
80103a8f:	c1 e0 04             	shl    $0x4,%eax
80103a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103a99:	74 21                	je     80103abc <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103a9b:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103aa2:	00 
80103aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aa6:	89 04 24             	mov    %eax,(%esp)
80103aa9:	e8 40 ff ff ff       	call   801039ee <mpsearch1>
80103aae:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ab1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ab5:	74 50                	je     80103b07 <mpsearch+0xa4>
      return mp;
80103ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103aba:	eb 5f                	jmp    80103b1b <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103abf:	83 c0 14             	add    $0x14,%eax
80103ac2:	0f b6 00             	movzbl (%eax),%eax
80103ac5:	0f b6 c0             	movzbl %al,%eax
80103ac8:	c1 e0 08             	shl    $0x8,%eax
80103acb:	89 c2                	mov    %eax,%edx
80103acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ad0:	83 c0 13             	add    $0x13,%eax
80103ad3:	0f b6 00             	movzbl (%eax),%eax
80103ad6:	0f b6 c0             	movzbl %al,%eax
80103ad9:	09 d0                	or     %edx,%eax
80103adb:	c1 e0 0a             	shl    $0xa,%eax
80103ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ae4:	2d 00 04 00 00       	sub    $0x400,%eax
80103ae9:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103af0:	00 
80103af1:	89 04 24             	mov    %eax,(%esp)
80103af4:	e8 f5 fe ff ff       	call   801039ee <mpsearch1>
80103af9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103afc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b00:	74 05                	je     80103b07 <mpsearch+0xa4>
      return mp;
80103b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b05:	eb 14                	jmp    80103b1b <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103b07:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103b0e:	00 
80103b0f:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103b16:	e8 d3 fe ff ff       	call   801039ee <mpsearch1>
}
80103b1b:	c9                   	leave  
80103b1c:	c3                   	ret    

80103b1d <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103b1d:	55                   	push   %ebp
80103b1e:	89 e5                	mov    %esp,%ebp
80103b20:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b23:	e8 3b ff ff ff       	call   80103a63 <mpsearch>
80103b28:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b2f:	74 0a                	je     80103b3b <mpconfig+0x1e>
80103b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b34:	8b 40 04             	mov    0x4(%eax),%eax
80103b37:	85 c0                	test   %eax,%eax
80103b39:	75 0a                	jne    80103b45 <mpconfig+0x28>
    return 0;
80103b3b:	b8 00 00 00 00       	mov    $0x0,%eax
80103b40:	e9 83 00 00 00       	jmp    80103bc8 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b48:	8b 40 04             	mov    0x4(%eax),%eax
80103b4b:	89 04 24             	mov    %eax,(%esp)
80103b4e:	e8 fd fd ff ff       	call   80103950 <p2v>
80103b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b56:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b5d:	00 
80103b5e:	c7 44 24 04 15 8d 10 	movl   $0x80108d15,0x4(%esp)
80103b65:	80 
80103b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b69:	89 04 24             	mov    %eax,(%esp)
80103b6c:	e8 21 1a 00 00       	call   80105592 <memcmp>
80103b71:	85 c0                	test   %eax,%eax
80103b73:	74 07                	je     80103b7c <mpconfig+0x5f>
    return 0;
80103b75:	b8 00 00 00 00       	mov    $0x0,%eax
80103b7a:	eb 4c                	jmp    80103bc8 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b7f:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b83:	3c 01                	cmp    $0x1,%al
80103b85:	74 12                	je     80103b99 <mpconfig+0x7c>
80103b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b8a:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b8e:	3c 04                	cmp    $0x4,%al
80103b90:	74 07                	je     80103b99 <mpconfig+0x7c>
    return 0;
80103b92:	b8 00 00 00 00       	mov    $0x0,%eax
80103b97:	eb 2f                	jmp    80103bc8 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b9c:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103ba0:	0f b7 c0             	movzwl %ax,%eax
80103ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103baa:	89 04 24             	mov    %eax,(%esp)
80103bad:	e8 04 fe ff ff       	call   801039b6 <sum>
80103bb2:	84 c0                	test   %al,%al
80103bb4:	74 07                	je     80103bbd <mpconfig+0xa0>
    return 0;
80103bb6:	b8 00 00 00 00       	mov    $0x0,%eax
80103bbb:	eb 0b                	jmp    80103bc8 <mpconfig+0xab>
  *pmp = mp;
80103bbd:	8b 45 08             	mov    0x8(%ebp),%eax
80103bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103bc3:	89 10                	mov    %edx,(%eax)
  return conf;
80103bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103bc8:	c9                   	leave  
80103bc9:	c3                   	ret    

80103bca <mpinit>:

void
mpinit(void)
{
80103bca:	55                   	push   %ebp
80103bcb:	89 e5                	mov    %esp,%ebp
80103bcd:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103bd0:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103bd7:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103bda:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103bdd:	89 04 24             	mov    %eax,(%esp)
80103be0:	e8 38 ff ff ff       	call   80103b1d <mpconfig>
80103be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103be8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103bec:	75 05                	jne    80103bf3 <mpinit+0x29>
    return;
80103bee:	e9 9c 01 00 00       	jmp    80103d8f <mpinit+0x1c5>
  ismp = 1;
80103bf3:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103bfa:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c00:	8b 40 24             	mov    0x24(%eax),%eax
80103c03:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c0b:	83 c0 2c             	add    $0x2c,%eax
80103c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c14:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c18:	0f b7 d0             	movzwl %ax,%edx
80103c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c1e:	01 d0                	add    %edx,%eax
80103c20:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c23:	e9 f4 00 00 00       	jmp    80103d1c <mpinit+0x152>
    switch(*p){
80103c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2b:	0f b6 00             	movzbl (%eax),%eax
80103c2e:	0f b6 c0             	movzbl %al,%eax
80103c31:	83 f8 04             	cmp    $0x4,%eax
80103c34:	0f 87 bf 00 00 00    	ja     80103cf9 <mpinit+0x12f>
80103c3a:	8b 04 85 58 8d 10 80 	mov    -0x7fef72a8(,%eax,4),%eax
80103c41:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c46:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103c49:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c4c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c50:	0f b6 d0             	movzbl %al,%edx
80103c53:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c58:	39 c2                	cmp    %eax,%edx
80103c5a:	74 2d                	je     80103c89 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103c5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c5f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c63:	0f b6 d0             	movzbl %al,%edx
80103c66:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c6b:	89 54 24 08          	mov    %edx,0x8(%esp)
80103c6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c73:	c7 04 24 1a 8d 10 80 	movl   $0x80108d1a,(%esp)
80103c7a:	e8 21 c7 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103c7f:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103c86:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103c89:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c8c:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103c90:	0f b6 c0             	movzbl %al,%eax
80103c93:	83 e0 02             	and    $0x2,%eax
80103c96:	85 c0                	test   %eax,%eax
80103c98:	74 15                	je     80103caf <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103c9a:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c9f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103ca5:	05 80 33 11 80       	add    $0x80113380,%eax
80103caa:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103caf:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103cb5:	a1 60 39 11 80       	mov    0x80113960,%eax
80103cba:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103cc0:	81 c2 80 33 11 80    	add    $0x80113380,%edx
80103cc6:	88 02                	mov    %al,(%edx)
      ncpu++;
80103cc8:	a1 60 39 11 80       	mov    0x80113960,%eax
80103ccd:	83 c0 01             	add    $0x1,%eax
80103cd0:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103cd5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103cd9:	eb 41                	jmp    80103d1c <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103ce1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ce4:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ce8:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103ced:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cf1:	eb 29                	jmp    80103d1c <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103cf3:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cf7:	eb 23                	jmp    80103d1c <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cfc:	0f b6 00             	movzbl (%eax),%eax
80103cff:	0f b6 c0             	movzbl %al,%eax
80103d02:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d06:	c7 04 24 38 8d 10 80 	movl   $0x80108d38,(%esp)
80103d0d:	e8 8e c6 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103d12:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103d19:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d1f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d22:	0f 82 00 ff ff ff    	jb     80103c28 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103d28:	a1 64 33 11 80       	mov    0x80113364,%eax
80103d2d:	85 c0                	test   %eax,%eax
80103d2f:	75 1d                	jne    80103d4e <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103d31:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103d38:	00 00 00 
    lapic = 0;
80103d3b:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103d42:	00 00 00 
    ioapicid = 0;
80103d45:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
    return;
80103d4c:	eb 41                	jmp    80103d8f <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d51:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103d55:	84 c0                	test   %al,%al
80103d57:	74 36                	je     80103d8f <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103d59:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103d60:	00 
80103d61:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103d68:	e8 0d fc ff ff       	call   8010397a <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103d6d:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d74:	e8 e4 fb ff ff       	call   8010395d <inb>
80103d79:	83 c8 01             	or     $0x1,%eax
80103d7c:	0f b6 c0             	movzbl %al,%eax
80103d7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d83:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d8a:	e8 eb fb ff ff       	call   8010397a <outb>
  }
}
80103d8f:	c9                   	leave  
80103d90:	c3                   	ret    

80103d91 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d91:	55                   	push   %ebp
80103d92:	89 e5                	mov    %esp,%ebp
80103d94:	83 ec 08             	sub    $0x8,%esp
80103d97:	8b 55 08             	mov    0x8(%ebp),%edx
80103d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d9d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103da1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103da4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103da8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103dac:	ee                   	out    %al,(%dx)
}
80103dad:	c9                   	leave  
80103dae:	c3                   	ret    

80103daf <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103daf:	55                   	push   %ebp
80103db0:	89 e5                	mov    %esp,%ebp
80103db2:	83 ec 0c             	sub    $0xc,%esp
80103db5:	8b 45 08             	mov    0x8(%ebp),%eax
80103db8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103dbc:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103dc0:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103dc6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103dca:	0f b6 c0             	movzbl %al,%eax
80103dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
80103dd1:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103dd8:	e8 b4 ff ff ff       	call   80103d91 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103ddd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103de1:	66 c1 e8 08          	shr    $0x8,%ax
80103de5:	0f b6 c0             	movzbl %al,%eax
80103de8:	89 44 24 04          	mov    %eax,0x4(%esp)
80103dec:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103df3:	e8 99 ff ff ff       	call   80103d91 <outb>
}
80103df8:	c9                   	leave  
80103df9:	c3                   	ret    

80103dfa <picenable>:

void
picenable(int irq)
{
80103dfa:	55                   	push   %ebp
80103dfb:	89 e5                	mov    %esp,%ebp
80103dfd:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103e00:	8b 45 08             	mov    0x8(%ebp),%eax
80103e03:	ba 01 00 00 00       	mov    $0x1,%edx
80103e08:	89 c1                	mov    %eax,%ecx
80103e0a:	d3 e2                	shl    %cl,%edx
80103e0c:	89 d0                	mov    %edx,%eax
80103e0e:	f7 d0                	not    %eax
80103e10:	89 c2                	mov    %eax,%edx
80103e12:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103e19:	21 d0                	and    %edx,%eax
80103e1b:	0f b7 c0             	movzwl %ax,%eax
80103e1e:	89 04 24             	mov    %eax,(%esp)
80103e21:	e8 89 ff ff ff       	call   80103daf <picsetmask>
}
80103e26:	c9                   	leave  
80103e27:	c3                   	ret    

80103e28 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103e28:	55                   	push   %ebp
80103e29:	89 e5                	mov    %esp,%ebp
80103e2b:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103e2e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e35:	00 
80103e36:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e3d:	e8 4f ff ff ff       	call   80103d91 <outb>
  outb(IO_PIC2+1, 0xFF);
80103e42:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e49:	00 
80103e4a:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e51:	e8 3b ff ff ff       	call   80103d91 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103e56:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103e5d:	00 
80103e5e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103e65:	e8 27 ff ff ff       	call   80103d91 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103e6a:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103e71:	00 
80103e72:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e79:	e8 13 ff ff ff       	call   80103d91 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103e7e:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103e85:	00 
80103e86:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e8d:	e8 ff fe ff ff       	call   80103d91 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103e92:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103e99:	00 
80103e9a:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ea1:	e8 eb fe ff ff       	call   80103d91 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103ea6:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103ead:	00 
80103eae:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103eb5:	e8 d7 fe ff ff       	call   80103d91 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103eba:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103ec1:	00 
80103ec2:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ec9:	e8 c3 fe ff ff       	call   80103d91 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103ece:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103ed5:	00 
80103ed6:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103edd:	e8 af fe ff ff       	call   80103d91 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103ee2:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103ee9:	00 
80103eea:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ef1:	e8 9b fe ff ff       	call   80103d91 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103ef6:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103efd:	00 
80103efe:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f05:	e8 87 fe ff ff       	call   80103d91 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f0a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f11:	00 
80103f12:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f19:	e8 73 fe ff ff       	call   80103d91 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103f1e:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f25:	00 
80103f26:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f2d:	e8 5f fe ff ff       	call   80103d91 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103f32:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f39:	00 
80103f3a:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f41:	e8 4b fe ff ff       	call   80103d91 <outb>

  if(irqmask != 0xFFFF)
80103f46:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f4d:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f51:	74 12                	je     80103f65 <picinit+0x13d>
    picsetmask(irqmask);
80103f53:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f5a:	0f b7 c0             	movzwl %ax,%eax
80103f5d:	89 04 24             	mov    %eax,(%esp)
80103f60:	e8 4a fe ff ff       	call   80103daf <picsetmask>
}
80103f65:	c9                   	leave  
80103f66:	c3                   	ret    

80103f67 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f67:	55                   	push   %ebp
80103f68:	89 e5                	mov    %esp,%ebp
80103f6a:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103f6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f74:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f80:	8b 10                	mov    (%eax),%edx
80103f82:	8b 45 08             	mov    0x8(%ebp),%eax
80103f85:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103f87:	e8 e0 cf ff ff       	call   80100f6c <filealloc>
80103f8c:	8b 55 08             	mov    0x8(%ebp),%edx
80103f8f:	89 02                	mov    %eax,(%edx)
80103f91:	8b 45 08             	mov    0x8(%ebp),%eax
80103f94:	8b 00                	mov    (%eax),%eax
80103f96:	85 c0                	test   %eax,%eax
80103f98:	0f 84 c8 00 00 00    	je     80104066 <pipealloc+0xff>
80103f9e:	e8 c9 cf ff ff       	call   80100f6c <filealloc>
80103fa3:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fa6:	89 02                	mov    %eax,(%edx)
80103fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fab:	8b 00                	mov    (%eax),%eax
80103fad:	85 c0                	test   %eax,%eax
80103faf:	0f 84 b1 00 00 00    	je     80104066 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103fb5:	e8 6e eb ff ff       	call   80102b28 <kalloc>
80103fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103fc1:	75 05                	jne    80103fc8 <pipealloc+0x61>
    goto bad;
80103fc3:	e9 9e 00 00 00       	jmp    80104066 <pipealloc+0xff>
  p->readopen = 1;
80103fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fcb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103fd2:	00 00 00 
  p->writeopen = 1;
80103fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd8:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103fdf:	00 00 00 
  p->nwrite = 0;
80103fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fe5:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103fec:	00 00 00 
  p->nread = 0;
80103fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ff2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ff9:	00 00 00 
  initlock(&p->lock, "pipe");
80103ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fff:	c7 44 24 04 6c 8d 10 	movl   $0x80108d6c,0x4(%esp)
80104006:	80 
80104007:	89 04 24             	mov    %eax,(%esp)
8010400a:	e8 97 12 00 00       	call   801052a6 <initlock>
  (*f0)->type = FD_PIPE;
8010400f:	8b 45 08             	mov    0x8(%ebp),%eax
80104012:	8b 00                	mov    (%eax),%eax
80104014:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010401a:	8b 45 08             	mov    0x8(%ebp),%eax
8010401d:	8b 00                	mov    (%eax),%eax
8010401f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104023:	8b 45 08             	mov    0x8(%ebp),%eax
80104026:	8b 00                	mov    (%eax),%eax
80104028:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010402c:	8b 45 08             	mov    0x8(%ebp),%eax
8010402f:	8b 00                	mov    (%eax),%eax
80104031:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104034:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104037:	8b 45 0c             	mov    0xc(%ebp),%eax
8010403a:	8b 00                	mov    (%eax),%eax
8010403c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104042:	8b 45 0c             	mov    0xc(%ebp),%eax
80104045:	8b 00                	mov    (%eax),%eax
80104047:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010404b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010404e:	8b 00                	mov    (%eax),%eax
80104050:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104054:	8b 45 0c             	mov    0xc(%ebp),%eax
80104057:	8b 00                	mov    (%eax),%eax
80104059:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010405c:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010405f:	b8 00 00 00 00       	mov    $0x0,%eax
80104064:	eb 42                	jmp    801040a8 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80104066:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010406a:	74 0b                	je     80104077 <pipealloc+0x110>
    kfree((char*)p);
8010406c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406f:	89 04 24             	mov    %eax,(%esp)
80104072:	e8 18 ea ff ff       	call   80102a8f <kfree>
  if(*f0)
80104077:	8b 45 08             	mov    0x8(%ebp),%eax
8010407a:	8b 00                	mov    (%eax),%eax
8010407c:	85 c0                	test   %eax,%eax
8010407e:	74 0d                	je     8010408d <pipealloc+0x126>
    fileclose(*f0);
80104080:	8b 45 08             	mov    0x8(%ebp),%eax
80104083:	8b 00                	mov    (%eax),%eax
80104085:	89 04 24             	mov    %eax,(%esp)
80104088:	e8 87 cf ff ff       	call   80101014 <fileclose>
  if(*f1)
8010408d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104090:	8b 00                	mov    (%eax),%eax
80104092:	85 c0                	test   %eax,%eax
80104094:	74 0d                	je     801040a3 <pipealloc+0x13c>
    fileclose(*f1);
80104096:	8b 45 0c             	mov    0xc(%ebp),%eax
80104099:	8b 00                	mov    (%eax),%eax
8010409b:	89 04 24             	mov    %eax,(%esp)
8010409e:	e8 71 cf ff ff       	call   80101014 <fileclose>
  return -1;
801040a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040a8:	c9                   	leave  
801040a9:	c3                   	ret    

801040aa <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801040aa:	55                   	push   %ebp
801040ab:	89 e5                	mov    %esp,%ebp
801040ad:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
801040b0:	8b 45 08             	mov    0x8(%ebp),%eax
801040b3:	89 04 24             	mov    %eax,(%esp)
801040b6:	e8 0c 12 00 00       	call   801052c7 <acquire>
  if(writable){
801040bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801040bf:	74 1f                	je     801040e0 <pipeclose+0x36>
    p->writeopen = 0;
801040c1:	8b 45 08             	mov    0x8(%ebp),%eax
801040c4:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801040cb:	00 00 00 
    wakeup(&p->nread);
801040ce:	8b 45 08             	mov    0x8(%ebp),%eax
801040d1:	05 34 02 00 00       	add    $0x234,%eax
801040d6:	89 04 24             	mov    %eax,(%esp)
801040d9:	e8 d0 0b 00 00       	call   80104cae <wakeup>
801040de:	eb 1d                	jmp    801040fd <pipeclose+0x53>
  } else {
    p->readopen = 0;
801040e0:	8b 45 08             	mov    0x8(%ebp),%eax
801040e3:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801040ea:	00 00 00 
    wakeup(&p->nwrite);
801040ed:	8b 45 08             	mov    0x8(%ebp),%eax
801040f0:	05 38 02 00 00       	add    $0x238,%eax
801040f5:	89 04 24             	mov    %eax,(%esp)
801040f8:	e8 b1 0b 00 00       	call   80104cae <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
801040fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104100:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104106:	85 c0                	test   %eax,%eax
80104108:	75 25                	jne    8010412f <pipeclose+0x85>
8010410a:	8b 45 08             	mov    0x8(%ebp),%eax
8010410d:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104113:	85 c0                	test   %eax,%eax
80104115:	75 18                	jne    8010412f <pipeclose+0x85>
    release(&p->lock);
80104117:	8b 45 08             	mov    0x8(%ebp),%eax
8010411a:	89 04 24             	mov    %eax,(%esp)
8010411d:	e8 07 12 00 00       	call   80105329 <release>
    kfree((char*)p);
80104122:	8b 45 08             	mov    0x8(%ebp),%eax
80104125:	89 04 24             	mov    %eax,(%esp)
80104128:	e8 62 e9 ff ff       	call   80102a8f <kfree>
8010412d:	eb 0b                	jmp    8010413a <pipeclose+0x90>
  } else
    release(&p->lock);
8010412f:	8b 45 08             	mov    0x8(%ebp),%eax
80104132:	89 04 24             	mov    %eax,(%esp)
80104135:	e8 ef 11 00 00       	call   80105329 <release>
}
8010413a:	c9                   	leave  
8010413b:	c3                   	ret    

8010413c <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010413c:	55                   	push   %ebp
8010413d:	89 e5                	mov    %esp,%ebp
8010413f:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80104142:	8b 45 08             	mov    0x8(%ebp),%eax
80104145:	89 04 24             	mov    %eax,(%esp)
80104148:	e8 7a 11 00 00       	call   801052c7 <acquire>
  for(i = 0; i < n; i++){
8010414d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104154:	e9 a6 00 00 00       	jmp    801041ff <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104159:	eb 57                	jmp    801041b2 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
8010415b:	8b 45 08             	mov    0x8(%ebp),%eax
8010415e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104164:	85 c0                	test   %eax,%eax
80104166:	74 0d                	je     80104175 <pipewrite+0x39>
80104168:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010416e:	8b 40 24             	mov    0x24(%eax),%eax
80104171:	85 c0                	test   %eax,%eax
80104173:	74 15                	je     8010418a <pipewrite+0x4e>
        release(&p->lock);
80104175:	8b 45 08             	mov    0x8(%ebp),%eax
80104178:	89 04 24             	mov    %eax,(%esp)
8010417b:	e8 a9 11 00 00       	call   80105329 <release>
        return -1;
80104180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104185:	e9 9f 00 00 00       	jmp    80104229 <pipewrite+0xed>
      }
      wakeup(&p->nread);
8010418a:	8b 45 08             	mov    0x8(%ebp),%eax
8010418d:	05 34 02 00 00       	add    $0x234,%eax
80104192:	89 04 24             	mov    %eax,(%esp)
80104195:	e8 14 0b 00 00       	call   80104cae <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010419a:	8b 45 08             	mov    0x8(%ebp),%eax
8010419d:	8b 55 08             	mov    0x8(%ebp),%edx
801041a0:	81 c2 38 02 00 00    	add    $0x238,%edx
801041a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801041aa:	89 14 24             	mov    %edx,(%esp)
801041ad:	e8 20 0a 00 00       	call   80104bd2 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801041b2:	8b 45 08             	mov    0x8(%ebp),%eax
801041b5:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801041bb:	8b 45 08             	mov    0x8(%ebp),%eax
801041be:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801041c4:	05 00 02 00 00       	add    $0x200,%eax
801041c9:	39 c2                	cmp    %eax,%edx
801041cb:	74 8e                	je     8010415b <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801041cd:	8b 45 08             	mov    0x8(%ebp),%eax
801041d0:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801041d6:	8d 48 01             	lea    0x1(%eax),%ecx
801041d9:	8b 55 08             	mov    0x8(%ebp),%edx
801041dc:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801041e2:	25 ff 01 00 00       	and    $0x1ff,%eax
801041e7:	89 c1                	mov    %eax,%ecx
801041e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801041ef:	01 d0                	add    %edx,%eax
801041f1:	0f b6 10             	movzbl (%eax),%edx
801041f4:	8b 45 08             	mov    0x8(%ebp),%eax
801041f7:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801041fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801041ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104202:	3b 45 10             	cmp    0x10(%ebp),%eax
80104205:	0f 8c 4e ff ff ff    	jl     80104159 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010420b:	8b 45 08             	mov    0x8(%ebp),%eax
8010420e:	05 34 02 00 00       	add    $0x234,%eax
80104213:	89 04 24             	mov    %eax,(%esp)
80104216:	e8 93 0a 00 00       	call   80104cae <wakeup>
  release(&p->lock);
8010421b:	8b 45 08             	mov    0x8(%ebp),%eax
8010421e:	89 04 24             	mov    %eax,(%esp)
80104221:	e8 03 11 00 00       	call   80105329 <release>
  return n;
80104226:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104229:	c9                   	leave  
8010422a:	c3                   	ret    

8010422b <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010422b:	55                   	push   %ebp
8010422c:	89 e5                	mov    %esp,%ebp
8010422e:	53                   	push   %ebx
8010422f:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104232:	8b 45 08             	mov    0x8(%ebp),%eax
80104235:	89 04 24             	mov    %eax,(%esp)
80104238:	e8 8a 10 00 00       	call   801052c7 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010423d:	eb 3a                	jmp    80104279 <piperead+0x4e>
    if(proc->killed){
8010423f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104245:	8b 40 24             	mov    0x24(%eax),%eax
80104248:	85 c0                	test   %eax,%eax
8010424a:	74 15                	je     80104261 <piperead+0x36>
      release(&p->lock);
8010424c:	8b 45 08             	mov    0x8(%ebp),%eax
8010424f:	89 04 24             	mov    %eax,(%esp)
80104252:	e8 d2 10 00 00       	call   80105329 <release>
      return -1;
80104257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010425c:	e9 b5 00 00 00       	jmp    80104316 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104261:	8b 45 08             	mov    0x8(%ebp),%eax
80104264:	8b 55 08             	mov    0x8(%ebp),%edx
80104267:	81 c2 34 02 00 00    	add    $0x234,%edx
8010426d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104271:	89 14 24             	mov    %edx,(%esp)
80104274:	e8 59 09 00 00       	call   80104bd2 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104279:	8b 45 08             	mov    0x8(%ebp),%eax
8010427c:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104282:	8b 45 08             	mov    0x8(%ebp),%eax
80104285:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010428b:	39 c2                	cmp    %eax,%edx
8010428d:	75 0d                	jne    8010429c <piperead+0x71>
8010428f:	8b 45 08             	mov    0x8(%ebp),%eax
80104292:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104298:	85 c0                	test   %eax,%eax
8010429a:	75 a3                	jne    8010423f <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010429c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042a3:	eb 4b                	jmp    801042f0 <piperead+0xc5>
    if(p->nread == p->nwrite)
801042a5:	8b 45 08             	mov    0x8(%ebp),%eax
801042a8:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042ae:	8b 45 08             	mov    0x8(%ebp),%eax
801042b1:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042b7:	39 c2                	cmp    %eax,%edx
801042b9:	75 02                	jne    801042bd <piperead+0x92>
      break;
801042bb:	eb 3b                	jmp    801042f8 <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801042bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801042c3:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801042c6:	8b 45 08             	mov    0x8(%ebp),%eax
801042c9:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801042cf:	8d 48 01             	lea    0x1(%eax),%ecx
801042d2:	8b 55 08             	mov    0x8(%ebp),%edx
801042d5:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801042db:	25 ff 01 00 00       	and    $0x1ff,%eax
801042e0:	89 c2                	mov    %eax,%edx
801042e2:	8b 45 08             	mov    0x8(%ebp),%eax
801042e5:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801042ea:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f3:	3b 45 10             	cmp    0x10(%ebp),%eax
801042f6:	7c ad                	jl     801042a5 <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801042f8:	8b 45 08             	mov    0x8(%ebp),%eax
801042fb:	05 38 02 00 00       	add    $0x238,%eax
80104300:	89 04 24             	mov    %eax,(%esp)
80104303:	e8 a6 09 00 00       	call   80104cae <wakeup>
  release(&p->lock);
80104308:	8b 45 08             	mov    0x8(%ebp),%eax
8010430b:	89 04 24             	mov    %eax,(%esp)
8010430e:	e8 16 10 00 00       	call   80105329 <release>
  return i;
80104313:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104316:	83 c4 24             	add    $0x24,%esp
80104319:	5b                   	pop    %ebx
8010431a:	5d                   	pop    %ebp
8010431b:	c3                   	ret    

8010431c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010431c:	55                   	push   %ebp
8010431d:	89 e5                	mov    %esp,%ebp
8010431f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104322:	9c                   	pushf  
80104323:	58                   	pop    %eax
80104324:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104327:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010432a:	c9                   	leave  
8010432b:	c3                   	ret    

8010432c <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010432c:	55                   	push   %ebp
8010432d:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010432f:	fb                   	sti    
}
80104330:	5d                   	pop    %ebp
80104331:	c3                   	ret    

80104332 <pinit>:
extern void trapret(void);
static void wakeup1(void *chan);

void
pinit(void)
{
80104332:	55                   	push   %ebp
80104333:	89 e5                	mov    %esp,%ebp
80104335:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104338:	c7 44 24 04 74 8d 10 	movl   $0x80108d74,0x4(%esp)
8010433f:	80 
80104340:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104347:	e8 5a 0f 00 00       	call   801052a6 <initlock>
}
8010434c:	c9                   	leave  
8010434d:	c3                   	ret    

8010434e <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010434e:	55                   	push   %ebp
8010434f:	89 e5                	mov    %esp,%ebp
80104351:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104354:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010435b:	e8 67 0f 00 00       	call   801052c7 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104360:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104367:	eb 53                	jmp    801043bc <allocproc+0x6e>
    if(p->state == UNUSED)
80104369:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010436c:	8b 40 0c             	mov    0xc(%eax),%eax
8010436f:	85 c0                	test   %eax,%eax
80104371:	75 42                	jne    801043b5 <allocproc+0x67>
      goto found;
80104373:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104377:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010437e:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104383:	8d 50 01             	lea    0x1(%eax),%edx
80104386:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010438c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010438f:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104392:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104399:	e8 8b 0f 00 00       	call   80105329 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010439e:	e8 85 e7 ff ff       	call   80102b28 <kalloc>
801043a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043a6:	89 42 08             	mov    %eax,0x8(%edx)
801043a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ac:	8b 40 08             	mov    0x8(%eax),%eax
801043af:	85 c0                	test   %eax,%eax
801043b1:	75 36                	jne    801043e9 <allocproc+0x9b>
801043b3:	eb 23                	jmp    801043d8 <allocproc+0x8a>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043b5:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801043bc:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
801043c3:	72 a4                	jb     80104369 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
801043c5:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801043cc:	e8 58 0f 00 00       	call   80105329 <release>
  return 0;
801043d1:	b8 00 00 00 00       	mov    $0x0,%eax
801043d6:	eb 76                	jmp    8010444e <allocproc+0x100>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801043d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801043e2:	b8 00 00 00 00       	mov    $0x0,%eax
801043e7:	eb 65                	jmp    8010444e <allocproc+0x100>
  }
  sp = p->kstack + KSTACKSIZE;
801043e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ec:	8b 40 08             	mov    0x8(%eax),%eax
801043ef:	05 00 10 00 00       	add    $0x1000,%eax
801043f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801043f7:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801043fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104401:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104404:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104408:	ba 1e 6b 10 80       	mov    $0x80106b1e,%edx
8010440d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104410:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104412:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104419:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010441c:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010441f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104422:	8b 40 1c             	mov    0x1c(%eax),%eax
80104425:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010442c:	00 
8010442d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104434:	00 
80104435:	89 04 24             	mov    %eax,(%esp)
80104438:	e8 de 10 00 00       	call   8010551b <memset>
  p->context->eip = (uint)forkret;
8010443d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104440:	8b 40 1c             	mov    0x1c(%eax),%eax
80104443:	ba a6 4b 10 80       	mov    $0x80104ba6,%edx
80104448:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010444b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010444e:	c9                   	leave  
8010444f:	c3                   	ret    

80104450 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104456:	e8 f3 fe ff ff       	call   8010434e <allocproc>
8010445b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010445e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104461:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
80104466:	e8 c3 3d 00 00       	call   8010822e <setupkvm>
8010446b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010446e:	89 42 04             	mov    %eax,0x4(%edx)
80104471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104474:	8b 40 04             	mov    0x4(%eax),%eax
80104477:	85 c0                	test   %eax,%eax
80104479:	75 0c                	jne    80104487 <userinit+0x37>
    panic("userinit: out of memory?");
8010447b:	c7 04 24 7b 8d 10 80 	movl   $0x80108d7b,(%esp)
80104482:	e8 b3 c0 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104487:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010448c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010448f:	8b 40 04             	mov    0x4(%eax),%eax
80104492:	89 54 24 08          	mov    %edx,0x8(%esp)
80104496:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
8010449d:	80 
8010449e:	89 04 24             	mov    %eax,(%esp)
801044a1:	e8 e0 3f 00 00       	call   80108486 <inituvm>
  p->sz = PGSIZE;
801044a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a9:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801044af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b2:	8b 40 18             	mov    0x18(%eax),%eax
801044b5:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801044bc:	00 
801044bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801044c4:	00 
801044c5:	89 04 24             	mov    %eax,(%esp)
801044c8:	e8 4e 10 00 00       	call   8010551b <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801044cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d0:	8b 40 18             	mov    0x18(%eax),%eax
801044d3:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801044d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044dc:	8b 40 18             	mov    0x18(%eax),%eax
801044df:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801044e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e8:	8b 40 18             	mov    0x18(%eax),%eax
801044eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044ee:	8b 52 18             	mov    0x18(%edx),%edx
801044f1:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801044f5:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801044f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044fc:	8b 40 18             	mov    0x18(%eax),%eax
801044ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104502:	8b 52 18             	mov    0x18(%edx),%edx
80104505:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104509:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010450d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104510:	8b 40 18             	mov    0x18(%eax),%eax
80104513:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010451a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451d:	8b 40 18             	mov    0x18(%eax),%eax
80104520:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452a:	8b 40 18             	mov    0x18(%eax),%eax
8010452d:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104534:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104537:	83 c0 6c             	add    $0x6c,%eax
8010453a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104541:	00 
80104542:	c7 44 24 04 94 8d 10 	movl   $0x80108d94,0x4(%esp)
80104549:	80 
8010454a:	89 04 24             	mov    %eax,(%esp)
8010454d:	e8 e9 11 00 00       	call   8010573b <safestrcpy>
  p->cwd = namei("/");
80104552:	c7 04 24 9d 8d 10 80 	movl   $0x80108d9d,(%esp)
80104559:	e8 ee de ff ff       	call   8010244c <namei>
8010455e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104561:	89 42 68             	mov    %eax,0x68(%edx)

  p->exit_status=0;		//Process exit status init
80104564:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104567:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  
  p->state = RUNNABLE;
8010456e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104571:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104578:	c9                   	leave  
80104579:	c3                   	ret    

8010457a <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010457a:	55                   	push   %ebp
8010457b:	89 e5                	mov    %esp,%ebp
8010457d:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104580:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104586:	8b 00                	mov    (%eax),%eax
80104588:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010458b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010458f:	7e 34                	jle    801045c5 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104591:	8b 55 08             	mov    0x8(%ebp),%edx
80104594:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104597:	01 c2                	add    %eax,%edx
80104599:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010459f:	8b 40 04             	mov    0x4(%eax),%eax
801045a2:	89 54 24 08          	mov    %edx,0x8(%esp)
801045a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801045ad:	89 04 24             	mov    %eax,(%esp)
801045b0:	e8 47 40 00 00       	call   801085fc <allocuvm>
801045b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045bc:	75 41                	jne    801045ff <growproc+0x85>
      return -1;
801045be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045c3:	eb 58                	jmp    8010461d <growproc+0xa3>
  } else if(n < 0){
801045c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045c9:	79 34                	jns    801045ff <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801045cb:	8b 55 08             	mov    0x8(%ebp),%edx
801045ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d1:	01 c2                	add    %eax,%edx
801045d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045d9:	8b 40 04             	mov    0x4(%eax),%eax
801045dc:	89 54 24 08          	mov    %edx,0x8(%esp)
801045e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045e3:	89 54 24 04          	mov    %edx,0x4(%esp)
801045e7:	89 04 24             	mov    %eax,(%esp)
801045ea:	e8 e7 40 00 00       	call   801086d6 <deallocuvm>
801045ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045f6:	75 07                	jne    801045ff <growproc+0x85>
      return -1;
801045f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045fd:	eb 1e                	jmp    8010461d <growproc+0xa3>
  }
  proc->sz = sz;
801045ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104605:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104608:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010460a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104610:	89 04 24             	mov    %eax,(%esp)
80104613:	e8 07 3d 00 00       	call   8010831f <switchuvm>
  return 0;
80104618:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010461d:	c9                   	leave  
8010461e:	c3                   	ret    

8010461f <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010461f:	55                   	push   %ebp
80104620:	89 e5                	mov    %esp,%ebp
80104622:	57                   	push   %edi
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104628:	e8 21 fd ff ff       	call   8010434e <allocproc>
8010462d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104630:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104634:	75 0a                	jne    80104640 <fork+0x21>
    return -1;
80104636:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010463b:	e9 67 01 00 00       	jmp    801047a7 <fork+0x188>


  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104640:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104646:	8b 10                	mov    (%eax),%edx
80104648:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010464e:	8b 40 04             	mov    0x4(%eax),%eax
80104651:	89 54 24 04          	mov    %edx,0x4(%esp)
80104655:	89 04 24             	mov    %eax,(%esp)
80104658:	e8 15 42 00 00       	call   80108872 <copyuvm>
8010465d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104660:	89 42 04             	mov    %eax,0x4(%edx)
80104663:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104666:	8b 40 04             	mov    0x4(%eax),%eax
80104669:	85 c0                	test   %eax,%eax
8010466b:	75 2c                	jne    80104699 <fork+0x7a>
    kfree(np->kstack);
8010466d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104670:	8b 40 08             	mov    0x8(%eax),%eax
80104673:	89 04 24             	mov    %eax,(%esp)
80104676:	e8 14 e4 ff ff       	call   80102a8f <kfree>
    np->kstack = 0;
8010467b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010467e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104685:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104688:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010468f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104694:	e9 0e 01 00 00       	jmp    801047a7 <fork+0x188>
  }
  np->sz = proc->sz;
80104699:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010469f:	8b 10                	mov    (%eax),%edx
801046a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046a4:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801046a6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801046ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046b0:	89 50 14             	mov    %edx,0x14(%eax)
  np->job = proc->job;
801046b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b9:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801046bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046c2:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  *np->tf = *proc->tf;
801046c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046cb:	8b 50 18             	mov    0x18(%eax),%edx
801046ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046d4:	8b 40 18             	mov    0x18(%eax),%eax
801046d7:	89 c3                	mov    %eax,%ebx
801046d9:	b8 13 00 00 00       	mov    $0x13,%eax
801046de:	89 d7                	mov    %edx,%edi
801046e0:	89 de                	mov    %ebx,%esi
801046e2:	89 c1                	mov    %eax,%ecx
801046e4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801046e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046e9:	8b 40 18             	mov    0x18(%eax),%eax
801046ec:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801046f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801046fa:	eb 3d                	jmp    80104739 <fork+0x11a>
    if(proc->ofile[i])
801046fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104702:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104705:	83 c2 08             	add    $0x8,%edx
80104708:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010470c:	85 c0                	test   %eax,%eax
8010470e:	74 25                	je     80104735 <fork+0x116>
      np->ofile[i] = filedup(proc->ofile[i]);
80104710:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104716:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104719:	83 c2 08             	add    $0x8,%edx
8010471c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104720:	89 04 24             	mov    %eax,(%esp)
80104723:	e8 a4 c8 ff ff       	call   80100fcc <filedup>
80104728:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010472b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010472e:	83 c1 08             	add    $0x8,%ecx
80104731:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104735:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104739:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010473d:	7e bd                	jle    801046fc <fork+0xdd>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010473f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104745:	8b 40 68             	mov    0x68(%eax),%eax
80104748:	89 04 24             	mov    %eax,(%esp)
8010474b:	e8 1f d1 ff ff       	call   8010186f <idup>
80104750:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104753:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104756:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010475c:	8d 50 6c             	lea    0x6c(%eax),%edx
8010475f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104762:	83 c0 6c             	add    $0x6c,%eax
80104765:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010476c:	00 
8010476d:	89 54 24 04          	mov    %edx,0x4(%esp)
80104771:	89 04 24             	mov    %eax,(%esp)
80104774:	e8 c2 0f 00 00       	call   8010573b <safestrcpy>
 
  pid = np->pid;
80104779:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010477c:	8b 40 10             	mov    0x10(%eax),%eax
8010477f:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104782:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104789:	e8 39 0b 00 00       	call   801052c7 <acquire>
  np->state = RUNNABLE;
8010478e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104791:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104798:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010479f:	e8 85 0b 00 00       	call   80105329 <release>
  
  return pid;
801047a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801047a7:	83 c4 2c             	add    $0x2c,%esp
801047aa:	5b                   	pop    %ebx
801047ab:	5e                   	pop    %esi
801047ac:	5f                   	pop    %edi
801047ad:	5d                   	pop    %ebp
801047ae:	c3                   	ret    

801047af <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(int status)
{
801047af:	55                   	push   %ebp
801047b0:	89 e5                	mov    %esp,%ebp
801047b2:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;
   proc->exit_status = status;			//save the exit state in the PCB
801047b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047bb:	8b 55 08             	mov    0x8(%ebp),%edx
801047be:	89 50 7c             	mov    %edx,0x7c(%eax)
  if(proc == initproc)
801047c1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047c8:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801047cd:	39 c2                	cmp    %eax,%edx
801047cf:	75 0c                	jne    801047dd <exit+0x2e>
    panic("init exiting");
801047d1:	c7 04 24 9f 8d 10 80 	movl   $0x80108d9f,(%esp)
801047d8:	e8 5d bd ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801047dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801047e4:	eb 44                	jmp    8010482a <exit+0x7b>
    if(proc->ofile[fd]){
801047e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
801047ef:	83 c2 08             	add    $0x8,%edx
801047f2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047f6:	85 c0                	test   %eax,%eax
801047f8:	74 2c                	je     80104826 <exit+0x77>
      fileclose(proc->ofile[fd]);
801047fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104800:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104803:	83 c2 08             	add    $0x8,%edx
80104806:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010480a:	89 04 24             	mov    %eax,(%esp)
8010480d:	e8 02 c8 ff ff       	call   80101014 <fileclose>
      proc->ofile[fd] = 0;
80104812:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104818:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010481b:	83 c2 08             	add    $0x8,%edx
8010481e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104825:	00 
   proc->exit_status = status;			//save the exit state in the PCB
  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104826:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010482a:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
8010482e:	7e b6                	jle    801047e6 <exit+0x37>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104830:	e8 21 ec ff ff       	call   80103456 <begin_op>
  iput(proc->cwd);
80104835:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010483b:	8b 40 68             	mov    0x68(%eax),%eax
8010483e:	89 04 24             	mov    %eax,(%esp)
80104841:	e8 0e d2 ff ff       	call   80101a54 <iput>
  end_op();
80104846:	e8 8f ec ff ff       	call   801034da <end_op>
  proc->cwd = 0;
8010484b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104851:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104858:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010485f:	e8 63 0a 00 00       	call   801052c7 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104864:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010486a:	8b 40 14             	mov    0x14(%eax),%eax
8010486d:	89 04 24             	mov    %eax,(%esp)
80104870:	e8 f8 03 00 00       	call   80104c6d <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104875:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010487c:	eb 3b                	jmp    801048b9 <exit+0x10a>
    if(p->parent == proc){
8010487e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104881:	8b 50 14             	mov    0x14(%eax),%edx
80104884:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010488a:	39 c2                	cmp    %eax,%edx
8010488c:	75 24                	jne    801048b2 <exit+0x103>
      p->parent = initproc;
8010488e:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104897:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010489a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010489d:	8b 40 0c             	mov    0xc(%eax),%eax
801048a0:	83 f8 05             	cmp    $0x5,%eax
801048a3:	75 0d                	jne    801048b2 <exit+0x103>
        wakeup1(initproc);
801048a5:	a1 68 c6 10 80       	mov    0x8010c668,%eax
801048aa:	89 04 24             	mov    %eax,(%esp)
801048ad:	e8 bb 03 00 00       	call   80104c6d <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048b2:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801048b9:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
801048c0:	72 bc                	jb     8010487e <exit+0xcf>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801048c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c8:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801048cf:	e8 ee 01 00 00       	call   80104ac2 <sched>
  panic("zombie exit");
801048d4:	c7 04 24 ac 8d 10 80 	movl   $0x80108dac,(%esp)
801048db:	e8 5a bc ff ff       	call   8010053a <panic>

801048e0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(int *status)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801048e6:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801048ed:	e8 d5 09 00 00       	call   801052c7 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801048f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048f9:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104900:	e9 d2 00 00 00       	jmp    801049d7 <wait+0xf7>
      if(p->parent != proc)
80104905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104908:	8b 50 14             	mov    0x14(%eax),%edx
8010490b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104911:	39 c2                	cmp    %eax,%edx
80104913:	74 05                	je     8010491a <wait+0x3a>
        continue;
80104915:	e9 b6 00 00 00       	jmp    801049d0 <wait+0xf0>
      havekids = 1;
8010491a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104924:	8b 40 0c             	mov    0xc(%eax),%eax
80104927:	83 f8 05             	cmp    $0x5,%eax
8010492a:	0f 85 a0 00 00 00    	jne    801049d0 <wait+0xf0>
        // Found one.
        pid = p->pid;
80104930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104933:	8b 40 10             	mov    0x10(%eax),%eax
80104936:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (status != 0)				//If status address existe otherwise written to NULL
80104939:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010493d:	74 7e                	je     801049bd <wait+0xdd>
	  *status = p->exit_status;			//Return the terminated child exit status through the status argument
8010493f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104942:	8b 50 7c             	mov    0x7c(%eax),%edx
80104945:	8b 45 08             	mov    0x8(%ebp),%eax
80104948:	89 10                	mov    %edx,(%eax)
	else {
	  release(&ptable.lock);			// In this case the child’s exit status must be discarded.
	  return -1;
	}
        kfree(p->kstack);
8010494a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010494d:	8b 40 08             	mov    0x8(%eax),%eax
80104950:	89 04 24             	mov    %eax,(%esp)
80104953:	e8 37 e1 ff ff       	call   80102a8f <kfree>
        p->kstack = 0;
80104958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104965:	8b 40 04             	mov    0x4(%eax),%eax
80104968:	89 04 24             	mov    %eax,(%esp)
8010496b:	e8 22 3e 00 00       	call   80108792 <freevm>
        p->state = UNUSED;
80104970:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104973:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
8010497a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010497d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104987:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010498e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104991:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104998:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
		p->job = 0;
8010499f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801049a9:	00 00 00 
        release(&ptable.lock);
801049ac:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801049b3:	e8 71 09 00 00       	call   80105329 <release>
        return pid;
801049b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049bb:	eb 68                	jmp    80104a25 <wait+0x145>
        // Found one.
        pid = p->pid;
	if (status != 0)				//If status address existe otherwise written to NULL
	  *status = p->exit_status;			//Return the terminated child exit status through the status argument
	else {
	  release(&ptable.lock);			// In this case the child’s exit status must be discarded.
801049bd:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801049c4:	e8 60 09 00 00       	call   80105329 <release>
	  return -1;
801049c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049ce:	eb 55                	jmp    80104a25 <wait+0x145>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049d0:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801049d7:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
801049de:	0f 82 21 ff ff ff    	jb     80104905 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801049e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801049e8:	74 0d                	je     801049f7 <wait+0x117>
801049ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049f0:	8b 40 24             	mov    0x24(%eax),%eax
801049f3:	85 c0                	test   %eax,%eax
801049f5:	74 13                	je     80104a0a <wait+0x12a>
      release(&ptable.lock);
801049f7:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801049fe:	e8 26 09 00 00       	call   80105329 <release>
      return -1;
80104a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a08:	eb 1b                	jmp    80104a25 <wait+0x145>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104a0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a10:	c7 44 24 04 80 39 11 	movl   $0x80113980,0x4(%esp)
80104a17:	80 
80104a18:	89 04 24             	mov    %eax,(%esp)
80104a1b:	e8 b2 01 00 00       	call   80104bd2 <sleep>
  }
80104a20:	e9 cd fe ff ff       	jmp    801048f2 <wait+0x12>
}
80104a25:	c9                   	leave  
80104a26:	c3                   	ret    

80104a27 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104a27:	55                   	push   %ebp
80104a28:	89 e5                	mov    %esp,%ebp
80104a2a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104a2d:	e8 fa f8 ff ff       	call   8010432c <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104a32:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104a39:	e8 89 08 00 00       	call   801052c7 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a3e:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104a45:	eb 61                	jmp    80104aa8 <scheduler+0x81>
      if(p->state != RUNNABLE)
80104a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4a:	8b 40 0c             	mov    0xc(%eax),%eax
80104a4d:	83 f8 03             	cmp    $0x3,%eax
80104a50:	74 02                	je     80104a54 <scheduler+0x2d>
        continue;
80104a52:	eb 4d                	jmp    80104aa1 <scheduler+0x7a>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a57:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a60:	89 04 24             	mov    %eax,(%esp)
80104a63:	e8 b7 38 00 00       	call   8010831f <switchuvm>
      p->state = RUNNING;
80104a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a6b:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104a72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a78:	8b 40 1c             	mov    0x1c(%eax),%eax
80104a7b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104a82:	83 c2 04             	add    $0x4,%edx
80104a85:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a89:	89 14 24             	mov    %edx,(%esp)
80104a8c:	e8 1b 0d 00 00       	call   801057ac <swtch>
      switchkvm();
80104a91:	e8 6c 38 00 00       	call   80108302 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104a96:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104a9d:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104aa1:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104aa8:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
80104aaf:	72 96                	jb     80104a47 <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104ab1:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104ab8:	e8 6c 08 00 00       	call   80105329 <release>

  }
80104abd:	e9 6b ff ff ff       	jmp    80104a2d <scheduler+0x6>

80104ac2 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104ac2:	55                   	push   %ebp
80104ac3:	89 e5                	mov    %esp,%ebp
80104ac5:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104ac8:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104acf:	e8 1d 09 00 00       	call   801053f1 <holding>
80104ad4:	85 c0                	test   %eax,%eax
80104ad6:	75 0c                	jne    80104ae4 <sched+0x22>
    panic("sched ptable.lock");
80104ad8:	c7 04 24 b8 8d 10 80 	movl   $0x80108db8,(%esp)
80104adf:	e8 56 ba ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
80104ae4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104aea:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104af0:	83 f8 01             	cmp    $0x1,%eax
80104af3:	74 0c                	je     80104b01 <sched+0x3f>
    panic("sched locks");
80104af5:	c7 04 24 ca 8d 10 80 	movl   $0x80108dca,(%esp)
80104afc:	e8 39 ba ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
80104b01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b07:	8b 40 0c             	mov    0xc(%eax),%eax
80104b0a:	83 f8 04             	cmp    $0x4,%eax
80104b0d:	75 0c                	jne    80104b1b <sched+0x59>
    panic("sched running");
80104b0f:	c7 04 24 d6 8d 10 80 	movl   $0x80108dd6,(%esp)
80104b16:	e8 1f ba ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
80104b1b:	e8 fc f7 ff ff       	call   8010431c <readeflags>
80104b20:	25 00 02 00 00       	and    $0x200,%eax
80104b25:	85 c0                	test   %eax,%eax
80104b27:	74 0c                	je     80104b35 <sched+0x73>
    panic("sched interruptible");
80104b29:	c7 04 24 e4 8d 10 80 	movl   $0x80108de4,(%esp)
80104b30:	e8 05 ba ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104b35:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b3b:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104b41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104b44:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b4a:	8b 40 04             	mov    0x4(%eax),%eax
80104b4d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b54:	83 c2 1c             	add    $0x1c,%edx
80104b57:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b5b:	89 14 24             	mov    %edx,(%esp)
80104b5e:	e8 49 0c 00 00       	call   801057ac <swtch>
  cpu->intena = intena;
80104b63:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b6c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104b72:	c9                   	leave  
80104b73:	c3                   	ret    

80104b74 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104b74:	55                   	push   %ebp
80104b75:	89 e5                	mov    %esp,%ebp
80104b77:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104b7a:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b81:	e8 41 07 00 00       	call   801052c7 <acquire>
  proc->state = RUNNABLE;
80104b86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b8c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104b93:	e8 2a ff ff ff       	call   80104ac2 <sched>
  release(&ptable.lock);
80104b98:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b9f:	e8 85 07 00 00       	call   80105329 <release>
}
80104ba4:	c9                   	leave  
80104ba5:	c3                   	ret    

80104ba6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104ba6:	55                   	push   %ebp
80104ba7:	89 e5                	mov    %esp,%ebp
80104ba9:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104bac:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104bb3:	e8 71 07 00 00       	call   80105329 <release>

  if (first) {
80104bb8:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104bbd:	85 c0                	test   %eax,%eax
80104bbf:	74 0f                	je     80104bd0 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104bc1:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104bc8:	00 00 00 
    initlog();
80104bcb:	e8 78 e6 ff ff       	call   80103248 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104bd0:	c9                   	leave  
80104bd1:	c3                   	ret    

80104bd2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104bd2:	55                   	push   %ebp
80104bd3:	89 e5                	mov    %esp,%ebp
80104bd5:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104bd8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bde:	85 c0                	test   %eax,%eax
80104be0:	75 0c                	jne    80104bee <sleep+0x1c>
    panic("sleep");
80104be2:	c7 04 24 f8 8d 10 80 	movl   $0x80108df8,(%esp)
80104be9:	e8 4c b9 ff ff       	call   8010053a <panic>

  if(lk == 0)
80104bee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104bf2:	75 0c                	jne    80104c00 <sleep+0x2e>
    panic("sleep without lk");
80104bf4:	c7 04 24 fe 8d 10 80 	movl   $0x80108dfe,(%esp)
80104bfb:	e8 3a b9 ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104c00:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104c07:	74 17                	je     80104c20 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104c09:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104c10:	e8 b2 06 00 00       	call   801052c7 <acquire>
    release(lk);
80104c15:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c18:	89 04 24             	mov    %eax,(%esp)
80104c1b:	e8 09 07 00 00       	call   80105329 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104c20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c26:	8b 55 08             	mov    0x8(%ebp),%edx
80104c29:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104c2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c32:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104c39:	e8 84 fe ff ff       	call   80104ac2 <sched>

  // Tidy up.
  proc->chan = 0;
80104c3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c44:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104c4b:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104c52:	74 17                	je     80104c6b <sleep+0x99>
    release(&ptable.lock);
80104c54:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104c5b:	e8 c9 06 00 00       	call   80105329 <release>
    acquire(lk);
80104c60:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c63:	89 04 24             	mov    %eax,(%esp)
80104c66:	e8 5c 06 00 00       	call   801052c7 <acquire>
  }
}
80104c6b:	c9                   	leave  
80104c6c:	c3                   	ret    

80104c6d <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104c6d:	55                   	push   %ebp
80104c6e:	89 e5                	mov    %esp,%ebp
80104c70:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c73:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104c7a:	eb 27                	jmp    80104ca3 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c7f:	8b 40 0c             	mov    0xc(%eax),%eax
80104c82:	83 f8 02             	cmp    $0x2,%eax
80104c85:	75 15                	jne    80104c9c <wakeup1+0x2f>
80104c87:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c8a:	8b 40 20             	mov    0x20(%eax),%eax
80104c8d:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c90:	75 0a                	jne    80104c9c <wakeup1+0x2f>
      p->state = RUNNABLE;
80104c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c9c:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104ca3:	81 7d fc b4 5a 11 80 	cmpl   $0x80115ab4,-0x4(%ebp)
80104caa:	72 d0                	jb     80104c7c <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104cac:	c9                   	leave  
80104cad:	c3                   	ret    

80104cae <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104cae:	55                   	push   %ebp
80104caf:	89 e5                	mov    %esp,%ebp
80104cb1:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104cb4:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104cbb:	e8 07 06 00 00       	call   801052c7 <acquire>
  wakeup1(chan);
80104cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc3:	89 04 24             	mov    %eax,(%esp)
80104cc6:	e8 a2 ff ff ff       	call   80104c6d <wakeup1>
  release(&ptable.lock);
80104ccb:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104cd2:	e8 52 06 00 00       	call   80105329 <release>
}
80104cd7:	c9                   	leave  
80104cd8:	c3                   	ret    

80104cd9 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104cd9:	55                   	push   %ebp
80104cda:	89 e5                	mov    %esp,%ebp
80104cdc:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104cdf:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104ce6:	e8 dc 05 00 00       	call   801052c7 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ceb:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104cf2:	eb 51                	jmp    80104d45 <kill+0x6c>
    if(p->pid == pid){
80104cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf7:	8b 40 10             	mov    0x10(%eax),%eax
80104cfa:	3b 45 08             	cmp    0x8(%ebp),%eax
80104cfd:	75 3f                	jne    80104d3e <kill+0x65>
      p->killed = 1;
80104cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d02:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      p->job = 0;
80104d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d0c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104d13:	00 00 00 
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d19:	8b 40 0c             	mov    0xc(%eax),%eax
80104d1c:	83 f8 02             	cmp    $0x2,%eax
80104d1f:	75 0a                	jne    80104d2b <kill+0x52>
        p->state = RUNNABLE;
80104d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d24:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104d2b:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d32:	e8 f2 05 00 00       	call   80105329 <release>
      return 0;
80104d37:	b8 00 00 00 00       	mov    $0x0,%eax
80104d3c:	eb 21                	jmp    80104d5f <kill+0x86>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d3e:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104d45:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
80104d4c:	72 a6                	jb     80104cf4 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104d4e:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d55:	e8 cf 05 00 00       	call   80105329 <release>
  return -1;
80104d5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d5f:	c9                   	leave  
80104d60:	c3                   	ret    

80104d61 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104d61:	55                   	push   %ebp
80104d62:	89 e5                	mov    %esp,%ebp
80104d64:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d67:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80104d6e:	e9 d9 00 00 00       	jmp    80104e4c <procdump+0xeb>
    if(p->state == UNUSED)
80104d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d76:	8b 40 0c             	mov    0xc(%eax),%eax
80104d79:	85 c0                	test   %eax,%eax
80104d7b:	75 05                	jne    80104d82 <procdump+0x21>
      continue;
80104d7d:	e9 c3 00 00 00       	jmp    80104e45 <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d85:	8b 40 0c             	mov    0xc(%eax),%eax
80104d88:	83 f8 05             	cmp    $0x5,%eax
80104d8b:	77 23                	ja     80104db0 <procdump+0x4f>
80104d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d90:	8b 40 0c             	mov    0xc(%eax),%eax
80104d93:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104d9a:	85 c0                	test   %eax,%eax
80104d9c:	74 12                	je     80104db0 <procdump+0x4f>
      state = states[p->state];
80104d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104da1:	8b 40 0c             	mov    0xc(%eax),%eax
80104da4:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104dab:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104dae:	eb 07                	jmp    80104db7 <procdump+0x56>
    else
      state = "???";
80104db0:	c7 45 ec 0f 8e 10 80 	movl   $0x80108e0f,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dba:	8d 50 6c             	lea    0x6c(%eax),%edx
80104dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dc0:	8b 40 10             	mov    0x10(%eax),%eax
80104dc3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104dc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104dca:	89 54 24 08          	mov    %edx,0x8(%esp)
80104dce:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dd2:	c7 04 24 13 8e 10 80 	movl   $0x80108e13,(%esp)
80104dd9:	e8 c2 b5 ff ff       	call   801003a0 <cprintf>
    if(p->state == SLEEPING){
80104dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104de1:	8b 40 0c             	mov    0xc(%eax),%eax
80104de4:	83 f8 02             	cmp    $0x2,%eax
80104de7:	75 50                	jne    80104e39 <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104dec:	8b 40 1c             	mov    0x1c(%eax),%eax
80104def:	8b 40 0c             	mov    0xc(%eax),%eax
80104df2:	83 c0 08             	add    $0x8,%eax
80104df5:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104df8:	89 54 24 04          	mov    %edx,0x4(%esp)
80104dfc:	89 04 24             	mov    %eax,(%esp)
80104dff:	e8 74 05 00 00       	call   80105378 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104e04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104e0b:	eb 1b                	jmp    80104e28 <procdump+0xc7>
        cprintf(" %p", pc[i]);
80104e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e10:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e14:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e18:	c7 04 24 1c 8e 10 80 	movl   $0x80108e1c,(%esp)
80104e1f:	e8 7c b5 ff ff       	call   801003a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104e24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104e28:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104e2c:	7f 0b                	jg     80104e39 <procdump+0xd8>
80104e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e31:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104e35:	85 c0                	test   %eax,%eax
80104e37:	75 d4                	jne    80104e0d <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104e39:	c7 04 24 20 8e 10 80 	movl   $0x80108e20,(%esp)
80104e40:	e8 5b b5 ff ff       	call   801003a0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e45:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104e4c:	81 7d f0 b4 5a 11 80 	cmpl   $0x80115ab4,-0x10(%ebp)
80104e53:	0f 82 1a ff ff ff    	jb     80104d73 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104e59:	c9                   	leave  
80104e5a:	c3                   	ret    

80104e5b <pstat>:


/////// 1.5 system call which will return (via variable stat) information regarding the process with a given pid.
int
pstat(int pid, struct procstat *stat)
{
80104e5b:	55                   	push   %ebp
80104e5c:	89 e5                	mov    %esp,%ebp
80104e5e:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;

		acquire(&ptable.lock);
80104e61:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104e68:	e8 5a 04 00 00       	call   801052c7 <acquire>
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e6d:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104e74:	e9 a6 00 00 00       	jmp    80104f1f <pstat+0xc4>
			if(p->pid == pid) {
80104e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e7c:	8b 40 10             	mov    0x10(%eax),%eax
80104e7f:	3b 45 08             	cmp    0x8(%ebp),%eax
80104e82:	0f 85 90 00 00 00    	jne    80104f18 <pstat+0xbd>
				int i;
				for (i=0; i<sizeof(p->name); i++)
80104e88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104e8f:	eb 1d                	jmp    80104eae <pstat+0x53>
					stat->name[i]=p->name[i];
80104e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e97:	01 d0                	add    %edx,%eax
80104e99:	83 c0 60             	add    $0x60,%eax
80104e9c:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80104ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ea3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ea6:	01 ca                	add    %ecx,%edx
80104ea8:	88 02                	mov    %al,(%edx)

		acquire(&ptable.lock);
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
			if(p->pid == pid) {
				int i;
				for (i=0; i<sizeof(p->name); i++)
80104eaa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eb1:	83 f8 0f             	cmp    $0xf,%eax
80104eb4:	76 db                	jbe    80104e91 <pstat+0x36>
					stat->name[i]=p->name[i];

				int numFileOpen=0;
80104eb6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				for(i = 0; i < NOFILE; i++){
80104ebd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104ec4:	eb 19                	jmp    80104edf <pstat+0x84>
					if(p->ofile[i])
80104ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ecc:	83 c2 08             	add    $0x8,%edx
80104ecf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ed3:	85 c0                	test   %eax,%eax
80104ed5:	74 04                	je     80104edb <pstat+0x80>
						 numFileOpen++;
80104ed7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
				int i;
				for (i=0; i<sizeof(p->name); i++)
					stat->name[i]=p->name[i];

				int numFileOpen=0;
				for(i = 0; i < NOFILE; i++){
80104edb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104edf:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104ee3:	7e e1                	jle    80104ec6 <pstat+0x6b>
					if(p->ofile[i])
						 numFileOpen++;
				 }
				stat->nofile=numFileOpen;
80104ee5:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eeb:	89 50 14             	mov    %edx,0x14(%eax)
				stat->state=p->state;
80104eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef1:	8b 50 0c             	mov    0xc(%eax),%edx
80104ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ef7:	89 50 18             	mov    %edx,0x18(%eax)
				stat->sz=p->sz;
80104efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104efd:	8b 10                	mov    (%eax),%edx
80104eff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f02:	89 50 10             	mov    %edx,0x10(%eax)
				release(&ptable.lock);
80104f05:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104f0c:	e8 18 04 00 00       	call   80105329 <release>
				return 0;
80104f11:	b8 00 00 00 00       	mov    $0x0,%eax
80104f16:	eb 25                	jmp    80104f3d <pstat+0xe2>
pstat(int pid, struct procstat *stat)
{
	struct proc *p;

		acquire(&ptable.lock);
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f18:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104f1f:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
80104f26:	0f 82 4d ff ff ff    	jb     80104e79 <pstat+0x1e>
				stat->sz=p->sz;
				release(&ptable.lock);
				return 0;
			}
		}
		release(&ptable.lock);
80104f2c:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104f33:	e8 f1 03 00 00       	call   80105329 <release>
		return -1;
80104f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 }
80104f3d:	c9                   	leave  
80104f3e:	c3                   	ret    

80104f3f <attachjob>:


//////jobs////////


int attachjob(int pid, struct job* job) {
80104f3f:	55                   	push   %ebp
80104f40:	89 e5                	mov    %esp,%ebp
80104f42:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	cprintf("log# *attachjob* pid:%d,jobID:%d \n", pid, job->jid);
80104f45:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f48:	8b 00                	mov    (%eax),%eax
80104f4a:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f4e:	8b 45 08             	mov    0x8(%ebp),%eax
80104f51:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f55:	c7 04 24 24 8e 10 80 	movl   $0x80108e24,(%esp)
80104f5c:	e8 3f b4 ff ff       	call   801003a0 <cprintf>
	acquire(&ptable.lock);
80104f61:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104f68:	e8 5a 03 00 00       	call   801052c7 <acquire>
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f6d:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104f74:	eb 2f                	jmp    80104fa5 <attachjob+0x66>
		if(p->pid == pid) {
80104f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f79:	8b 40 10             	mov    0x10(%eax),%eax
80104f7c:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f7f:	75 1d                	jne    80104f9e <attachjob+0x5f>
			p->job = job;
80104f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f84:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f87:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
			release(&ptable.lock);
80104f8d:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104f94:	e8 90 03 00 00       	call   80105329 <release>
			return pid;
80104f99:	8b 45 08             	mov    0x8(%ebp),%eax
80104f9c:	eb 21                	jmp    80104fbf <attachjob+0x80>

int attachjob(int pid, struct job* job) {
	struct proc *p;
	cprintf("log# *attachjob* pid:%d,jobID:%d \n", pid, job->jid);
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f9e:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104fa5:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
80104fac:	72 c8                	jb     80104f76 <attachjob+0x37>
			p->job = job;
			release(&ptable.lock);
			return pid;
		}
	}
	release(&ptable.lock);
80104fae:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104fb5:	e8 6f 03 00 00       	call   80105329 <release>
	return -1;
80104fba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fbf:	c9                   	leave  
80104fc0:	c3                   	ret    

80104fc1 <getjob>:

int
getjob(int index){
80104fc1:	55                   	push   %ebp
80104fc2:	89 e5                	mov    %esp,%ebp
80104fc4:	83 ec 18             	sub    $0x18,%esp
	cprintf("i'm here\n");
80104fc7:	c7 04 24 47 8e 10 80 	movl   $0x80108e47,(%esp)
80104fce:	e8 cd b3 ff ff       	call   801003a0 <cprintf>
	return index;
80104fd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104fd6:	c9                   	leave  
80104fd7:	c3                   	ret    

80104fd8 <printjob>:

int
printjob(int jid) {
80104fd8:	55                   	push   %ebp
80104fd9:	89 e5                	mov    %esp,%ebp
80104fdb:	83 ec 28             	sub    $0x28,%esp
	//struct procstat *stat = 0; // free mem alcc??????
	struct proc *p;
	int count = 0;
80104fde:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)


	acquire(&ptable.lock);
80104fe5:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104fec:	e8 d6 02 00 00       	call   801052c7 <acquire>
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ff1:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104ff8:	eb 5a                	jmp    80105054 <printjob+0x7c>
		if(p->job->jid == jid) {
80104ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ffd:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105003:	8b 00                	mov    (%eax),%eax
80105005:	3b 45 08             	cmp    0x8(%ebp),%eax
80105008:	75 43                	jne    8010504d <printjob+0x75>
			if (!count)
8010500a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010500e:	75 23                	jne    80105033 <printjob+0x5b>
				cprintf("Job %d: %s\n", jid, p->job->cmd);
80105010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105013:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105019:	83 c0 04             	add    $0x4,%eax
8010501c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105020:	8b 45 08             	mov    0x8(%ebp),%eax
80105023:	89 44 24 04          	mov    %eax,0x4(%esp)
80105027:	c7 04 24 51 8e 10 80 	movl   $0x80108e51,(%esp)
8010502e:	e8 6d b3 ff ff       	call   801003a0 <cprintf>
			//cprintf("%d: \n",pstat(1,stat));
			//if(pstat(p->pid,stat))
				cprintf("%d: \n",p->pid);
80105033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105036:	8b 40 10             	mov    0x10(%eax),%eax
80105039:	89 44 24 04          	mov    %eax,0x4(%esp)
8010503d:	c7 04 24 5d 8e 10 80 	movl   $0x80108e5d,(%esp)
80105044:	e8 57 b3 ff ff       	call   801003a0 <cprintf>
				//cprintf("%d: %s %d %d %d\n",p->pid ,stat->name, stat->sz,stat->nofile,stat->state);
			++count;
80105049:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
	struct proc *p;
	int count = 0;


	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010504d:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80105054:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
8010505b:	72 9d                	jb     80104ffa <printjob+0x22>
				cprintf("%d: \n",p->pid);
				//cprintf("%d: %s %d %d %d\n",p->pid ,stat->name, stat->sz,stat->nofile,stat->state);
			++count;
		}
	}
	release(&ptable.lock);
8010505d:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105064:	e8 c0 02 00 00       	call   80105329 <release>
	return count;
80105069:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010506c:	c9                   	leave  
8010506d:	c3                   	ret    

8010506e <waitpid>:

int
waitpid(int pid, int *status, int options)
{
8010506e:	55                   	push   %ebp
8010506f:	89 e5                	mov    %esp,%ebp
80105071:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	int procexists;

	acquire(&ptable.lock);
80105074:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010507b:	e8 47 02 00 00       	call   801052c7 <acquire>
	for(;;){
		// Scan through table looking for zombie pid.
		procexists = 0;
80105080:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105087:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010508e:	e9 c4 00 00 00       	jmp    80105157 <waitpid+0xe9>
			if(p->pid != pid)
80105093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105096:	8b 40 10             	mov    0x10(%eax),%eax
80105099:	3b 45 08             	cmp    0x8(%ebp),%eax
8010509c:	74 05                	je     801050a3 <waitpid+0x35>
				continue;
8010509e:	e9 ad 00 00 00       	jmp    80105150 <waitpid+0xe2>
			procexists = 1;
801050a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
			if(p->state == ZOMBIE){
801050aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ad:	8b 40 0c             	mov    0xc(%eax),%eax
801050b0:	83 f8 05             	cmp    $0x5,%eax
801050b3:	0f 85 97 00 00 00    	jne    80105150 <waitpid+0xe2>
				// Found one.
				//
				if (status != 0)
801050b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801050bd:	74 7e                	je     8010513d <waitpid+0xcf>
					*status = p->exit_status;
801050bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c2:	8b 50 7c             	mov    0x7c(%eax),%edx
801050c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801050c8:	89 10                	mov    %edx,(%eax)
				else {
					release(&ptable.lock);
					return -1;
				}
				kfree(p->kstack);
801050ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050cd:	8b 40 08             	mov    0x8(%eax),%eax
801050d0:	89 04 24             	mov    %eax,(%esp)
801050d3:	e8 b7 d9 ff ff       	call   80102a8f <kfree>
				p->kstack = 0;
801050d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050db:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				freevm(p->pgdir);
801050e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e5:	8b 40 04             	mov    0x4(%eax),%eax
801050e8:	89 04 24             	mov    %eax,(%esp)
801050eb:	e8 a2 36 00 00       	call   80108792 <freevm>
				p->state = UNUSED;
801050f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
				p->pid = 0;
801050fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050fd:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
				p->parent = 0;
80105104:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105107:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
				p->name[0] = 0;
8010510e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105111:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
				p->killed = 0;
80105115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105118:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
				p->job = 0;
8010511f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105122:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105129:	00 00 00 
				release(&ptable.lock);
8010512c:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105133:	e8 f1 01 00 00       	call   80105329 <release>
				return pid;
80105138:	8b 45 08             	mov    0x8(%ebp),%eax
8010513b:	eb 6e                	jmp    801051ab <waitpid+0x13d>
				// Found one.
				//
				if (status != 0)
					*status = p->exit_status;
				else {
					release(&ptable.lock);
8010513d:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105144:	e8 e0 01 00 00       	call   80105329 <release>
					return -1;
80105149:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010514e:	eb 5b                	jmp    801051ab <waitpid+0x13d>

	acquire(&ptable.lock);
	for(;;){
		// Scan through table looking for zombie pid.
		procexists = 0;
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105150:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80105157:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
8010515e:	0f 82 2f ff ff ff    	jb     80105093 <waitpid+0x25>
				//if (options)
					//goto waitonp;
			//}
		}
// No point waiting if process doesn't exist.
		if(!procexists || proc->killed || !options){
80105164:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105168:	74 13                	je     8010517d <waitpid+0x10f>
8010516a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105170:	8b 40 24             	mov    0x24(%eax),%eax
80105173:	85 c0                	test   %eax,%eax
80105175:	75 06                	jne    8010517d <waitpid+0x10f>
80105177:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010517b:	75 13                	jne    80105190 <waitpid+0x122>
			release(&ptable.lock);
8010517d:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105184:	e8 a0 01 00 00       	call   80105329 <release>
			return -1;
80105189:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010518e:	eb 1b                	jmp    801051ab <waitpid+0x13d>
				//if (!p->waitingonme[i]){
					//p->waitingonme[i] = proc;
				//	break;
			//	}

			sleep(proc, &ptable.lock);  //DOC: wait-sleep
80105190:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105196:	c7 44 24 04 80 39 11 	movl   $0x80113980,0x4(%esp)
8010519d:	80 
8010519e:	89 04 24             	mov    %eax,(%esp)
801051a1:	e8 2c fa ff ff       	call   80104bd2 <sleep>
		}
801051a6:	e9 d5 fe ff ff       	jmp    80105080 <waitpid+0x12>
	}
801051ab:	c9                   	leave  
801051ac:	c3                   	ret    

801051ad <fg>:

int fg(int jid) {
801051ad:	55                   	push   %ebp
801051ae:	89 e5                	mov    %esp,%ebp
801051b0:	83 ec 28             	sub    $0x28,%esp
	struct proc *p;
	int status;
	int found = 0;
801051b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	acquire(&ptable.lock);
801051ba:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801051c1:	e8 01 01 00 00       	call   801052c7 <acquire>
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051c6:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801051cd:	eb 74                	jmp    80105243 <fg+0x96>
		if (p->pid < 3)
801051cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051d2:	8b 40 10             	mov    0x10(%eax),%eax
801051d5:	83 f8 02             	cmp    $0x2,%eax
801051d8:	7f 02                	jg     801051dc <fg+0x2f>
			continue;
801051da:	eb 60                	jmp    8010523c <fg+0x8f>
		if(!jid)
801051dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801051e0:	75 0e                	jne    801051f0 <fg+0x43>
			jid = p->job->jid;
801051e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051e5:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801051eb:	8b 00                	mov    (%eax),%eax
801051ed:	89 45 08             	mov    %eax,0x8(%ebp)
		if(p->job->jid == jid) {
801051f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051f3:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801051f9:	8b 00                	mov    (%eax),%eax
801051fb:	3b 45 08             	cmp    0x8(%ebp),%eax
801051fe:	75 3c                	jne    8010523c <fg+0x8f>
			found = 1;
80105200:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
			release(&ptable.lock);
80105207:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010520e:	e8 16 01 00 00       	call   80105329 <release>
			waitpid(p->pid, &status, 1);
80105213:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105216:	8b 40 10             	mov    0x10(%eax),%eax
80105219:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80105220:	00 
80105221:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105224:	89 54 24 04          	mov    %edx,0x4(%esp)
80105228:	89 04 24             	mov    %eax,(%esp)
8010522b:	e8 3e fe ff ff       	call   8010506e <waitpid>
			acquire(&ptable.lock);
80105230:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105237:	e8 8b 00 00 00       	call   801052c7 <acquire>
int fg(int jid) {
	struct proc *p;
	int status;
	int found = 0;
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010523c:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80105243:	81 7d f4 b4 5a 11 80 	cmpl   $0x80115ab4,-0xc(%ebp)
8010524a:	72 83                	jb     801051cf <fg+0x22>
			release(&ptable.lock);
			waitpid(p->pid, &status, 1);
			acquire(&ptable.lock);
		}
	}
	release(&ptable.lock);
8010524c:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105253:	e8 d1 00 00 00       	call   80105329 <release>
	if (found)
80105258:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010525c:	74 0b                	je     80105269 <fg+0xbc>
		fg(jid);
8010525e:	8b 45 08             	mov    0x8(%ebp),%eax
80105261:	89 04 24             	mov    %eax,(%esp)
80105264:	e8 44 ff ff ff       	call   801051ad <fg>
	return 0;
80105269:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010526e:	c9                   	leave  
8010526f:	c3                   	ret    

80105270 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105276:	9c                   	pushf  
80105277:	58                   	pop    %eax
80105278:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010527b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010527e:	c9                   	leave  
8010527f:	c3                   	ret    

80105280 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105283:	fa                   	cli    
}
80105284:	5d                   	pop    %ebp
80105285:	c3                   	ret    

80105286 <sti>:

static inline void
sti(void)
{
80105286:	55                   	push   %ebp
80105287:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105289:	fb                   	sti    
}
8010528a:	5d                   	pop    %ebp
8010528b:	c3                   	ret    

8010528c <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010528c:	55                   	push   %ebp
8010528d:	89 e5                	mov    %esp,%ebp
8010528f:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105292:	8b 55 08             	mov    0x8(%ebp),%edx
80105295:	8b 45 0c             	mov    0xc(%ebp),%eax
80105298:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010529b:	f0 87 02             	lock xchg %eax,(%edx)
8010529e:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801052a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801052a4:	c9                   	leave  
801052a5:	c3                   	ret    

801052a6 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801052a6:	55                   	push   %ebp
801052a7:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801052a9:	8b 45 08             	mov    0x8(%ebp),%eax
801052ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801052af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801052b2:	8b 45 08             	mov    0x8(%ebp),%eax
801052b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801052bb:	8b 45 08             	mov    0x8(%ebp),%eax
801052be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801052c5:	5d                   	pop    %ebp
801052c6:	c3                   	ret    

801052c7 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801052c7:	55                   	push   %ebp
801052c8:	89 e5                	mov    %esp,%ebp
801052ca:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801052cd:	e8 49 01 00 00       	call   8010541b <pushcli>
  if(holding(lk))
801052d2:	8b 45 08             	mov    0x8(%ebp),%eax
801052d5:	89 04 24             	mov    %eax,(%esp)
801052d8:	e8 14 01 00 00       	call   801053f1 <holding>
801052dd:	85 c0                	test   %eax,%eax
801052df:	74 0c                	je     801052ed <acquire+0x26>
    panic("acquire");
801052e1:	c7 04 24 8d 8e 10 80 	movl   $0x80108e8d,(%esp)
801052e8:	e8 4d b2 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801052ed:	90                   	nop
801052ee:	8b 45 08             	mov    0x8(%ebp),%eax
801052f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801052f8:	00 
801052f9:	89 04 24             	mov    %eax,(%esp)
801052fc:	e8 8b ff ff ff       	call   8010528c <xchg>
80105301:	85 c0                	test   %eax,%eax
80105303:	75 e9                	jne    801052ee <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105305:	8b 45 08             	mov    0x8(%ebp),%eax
80105308:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010530f:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105312:	8b 45 08             	mov    0x8(%ebp),%eax
80105315:	83 c0 0c             	add    $0xc,%eax
80105318:	89 44 24 04          	mov    %eax,0x4(%esp)
8010531c:	8d 45 08             	lea    0x8(%ebp),%eax
8010531f:	89 04 24             	mov    %eax,(%esp)
80105322:	e8 51 00 00 00       	call   80105378 <getcallerpcs>
}
80105327:	c9                   	leave  
80105328:	c3                   	ret    

80105329 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105329:	55                   	push   %ebp
8010532a:	89 e5                	mov    %esp,%ebp
8010532c:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
8010532f:	8b 45 08             	mov    0x8(%ebp),%eax
80105332:	89 04 24             	mov    %eax,(%esp)
80105335:	e8 b7 00 00 00       	call   801053f1 <holding>
8010533a:	85 c0                	test   %eax,%eax
8010533c:	75 0c                	jne    8010534a <release+0x21>
    panic("release");
8010533e:	c7 04 24 95 8e 10 80 	movl   $0x80108e95,(%esp)
80105345:	e8 f0 b1 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
8010534a:	8b 45 08             	mov    0x8(%ebp),%eax
8010534d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105354:	8b 45 08             	mov    0x8(%ebp),%eax
80105357:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010535e:	8b 45 08             	mov    0x8(%ebp),%eax
80105361:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105368:	00 
80105369:	89 04 24             	mov    %eax,(%esp)
8010536c:	e8 1b ff ff ff       	call   8010528c <xchg>

  popcli();
80105371:	e8 e9 00 00 00       	call   8010545f <popcli>
}
80105376:	c9                   	leave  
80105377:	c3                   	ret    

80105378 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105378:	55                   	push   %ebp
80105379:	89 e5                	mov    %esp,%ebp
8010537b:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010537e:	8b 45 08             	mov    0x8(%ebp),%eax
80105381:	83 e8 08             	sub    $0x8,%eax
80105384:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105387:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010538e:	eb 38                	jmp    801053c8 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105390:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105394:	74 38                	je     801053ce <getcallerpcs+0x56>
80105396:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010539d:	76 2f                	jbe    801053ce <getcallerpcs+0x56>
8010539f:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801053a3:	74 29                	je     801053ce <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
801053a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801053af:	8b 45 0c             	mov    0xc(%ebp),%eax
801053b2:	01 c2                	add    %eax,%edx
801053b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053b7:	8b 40 04             	mov    0x4(%eax),%eax
801053ba:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801053bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053bf:	8b 00                	mov    (%eax),%eax
801053c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801053c4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801053c8:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801053cc:	7e c2                	jle    80105390 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801053ce:	eb 19                	jmp    801053e9 <getcallerpcs+0x71>
    pcs[i] = 0;
801053d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801053da:	8b 45 0c             	mov    0xc(%ebp),%eax
801053dd:	01 d0                	add    %edx,%eax
801053df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801053e5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801053e9:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801053ed:	7e e1                	jle    801053d0 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801053ef:	c9                   	leave  
801053f0:	c3                   	ret    

801053f1 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801053f1:	55                   	push   %ebp
801053f2:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801053f4:	8b 45 08             	mov    0x8(%ebp),%eax
801053f7:	8b 00                	mov    (%eax),%eax
801053f9:	85 c0                	test   %eax,%eax
801053fb:	74 17                	je     80105414 <holding+0x23>
801053fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105400:	8b 50 08             	mov    0x8(%eax),%edx
80105403:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105409:	39 c2                	cmp    %eax,%edx
8010540b:	75 07                	jne    80105414 <holding+0x23>
8010540d:	b8 01 00 00 00       	mov    $0x1,%eax
80105412:	eb 05                	jmp    80105419 <holding+0x28>
80105414:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105419:	5d                   	pop    %ebp
8010541a:	c3                   	ret    

8010541b <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010541b:	55                   	push   %ebp
8010541c:	89 e5                	mov    %esp,%ebp
8010541e:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105421:	e8 4a fe ff ff       	call   80105270 <readeflags>
80105426:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105429:	e8 52 fe ff ff       	call   80105280 <cli>
  if(cpu->ncli++ == 0)
8010542e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105435:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
8010543b:	8d 48 01             	lea    0x1(%eax),%ecx
8010543e:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105444:	85 c0                	test   %eax,%eax
80105446:	75 15                	jne    8010545d <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105448:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010544e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105451:	81 e2 00 02 00 00    	and    $0x200,%edx
80105457:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010545d:	c9                   	leave  
8010545e:	c3                   	ret    

8010545f <popcli>:

void
popcli(void)
{
8010545f:	55                   	push   %ebp
80105460:	89 e5                	mov    %esp,%ebp
80105462:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105465:	e8 06 fe ff ff       	call   80105270 <readeflags>
8010546a:	25 00 02 00 00       	and    $0x200,%eax
8010546f:	85 c0                	test   %eax,%eax
80105471:	74 0c                	je     8010547f <popcli+0x20>
    panic("popcli - interruptible");
80105473:	c7 04 24 9d 8e 10 80 	movl   $0x80108e9d,(%esp)
8010547a:	e8 bb b0 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
8010547f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105485:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010548b:	83 ea 01             	sub    $0x1,%edx
8010548e:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105494:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010549a:	85 c0                	test   %eax,%eax
8010549c:	79 0c                	jns    801054aa <popcli+0x4b>
    panic("popcli");
8010549e:	c7 04 24 b4 8e 10 80 	movl   $0x80108eb4,(%esp)
801054a5:	e8 90 b0 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
801054aa:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054b0:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054b6:	85 c0                	test   %eax,%eax
801054b8:	75 15                	jne    801054cf <popcli+0x70>
801054ba:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054c0:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801054c6:	85 c0                	test   %eax,%eax
801054c8:	74 05                	je     801054cf <popcli+0x70>
    sti();
801054ca:	e8 b7 fd ff ff       	call   80105286 <sti>
}
801054cf:	c9                   	leave  
801054d0:	c3                   	ret    

801054d1 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801054d1:	55                   	push   %ebp
801054d2:	89 e5                	mov    %esp,%ebp
801054d4:	57                   	push   %edi
801054d5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801054d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054d9:	8b 55 10             	mov    0x10(%ebp),%edx
801054dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801054df:	89 cb                	mov    %ecx,%ebx
801054e1:	89 df                	mov    %ebx,%edi
801054e3:	89 d1                	mov    %edx,%ecx
801054e5:	fc                   	cld    
801054e6:	f3 aa                	rep stos %al,%es:(%edi)
801054e8:	89 ca                	mov    %ecx,%edx
801054ea:	89 fb                	mov    %edi,%ebx
801054ec:	89 5d 08             	mov    %ebx,0x8(%ebp)
801054ef:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801054f2:	5b                   	pop    %ebx
801054f3:	5f                   	pop    %edi
801054f4:	5d                   	pop    %ebp
801054f5:	c3                   	ret    

801054f6 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801054f6:	55                   	push   %ebp
801054f7:	89 e5                	mov    %esp,%ebp
801054f9:	57                   	push   %edi
801054fa:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801054fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054fe:	8b 55 10             	mov    0x10(%ebp),%edx
80105501:	8b 45 0c             	mov    0xc(%ebp),%eax
80105504:	89 cb                	mov    %ecx,%ebx
80105506:	89 df                	mov    %ebx,%edi
80105508:	89 d1                	mov    %edx,%ecx
8010550a:	fc                   	cld    
8010550b:	f3 ab                	rep stos %eax,%es:(%edi)
8010550d:	89 ca                	mov    %ecx,%edx
8010550f:	89 fb                	mov    %edi,%ebx
80105511:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105514:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105517:	5b                   	pop    %ebx
80105518:	5f                   	pop    %edi
80105519:	5d                   	pop    %ebp
8010551a:	c3                   	ret    

8010551b <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010551b:	55                   	push   %ebp
8010551c:	89 e5                	mov    %esp,%ebp
8010551e:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105521:	8b 45 08             	mov    0x8(%ebp),%eax
80105524:	83 e0 03             	and    $0x3,%eax
80105527:	85 c0                	test   %eax,%eax
80105529:	75 49                	jne    80105574 <memset+0x59>
8010552b:	8b 45 10             	mov    0x10(%ebp),%eax
8010552e:	83 e0 03             	and    $0x3,%eax
80105531:	85 c0                	test   %eax,%eax
80105533:	75 3f                	jne    80105574 <memset+0x59>
    c &= 0xFF;
80105535:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010553c:	8b 45 10             	mov    0x10(%ebp),%eax
8010553f:	c1 e8 02             	shr    $0x2,%eax
80105542:	89 c2                	mov    %eax,%edx
80105544:	8b 45 0c             	mov    0xc(%ebp),%eax
80105547:	c1 e0 18             	shl    $0x18,%eax
8010554a:	89 c1                	mov    %eax,%ecx
8010554c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010554f:	c1 e0 10             	shl    $0x10,%eax
80105552:	09 c1                	or     %eax,%ecx
80105554:	8b 45 0c             	mov    0xc(%ebp),%eax
80105557:	c1 e0 08             	shl    $0x8,%eax
8010555a:	09 c8                	or     %ecx,%eax
8010555c:	0b 45 0c             	or     0xc(%ebp),%eax
8010555f:	89 54 24 08          	mov    %edx,0x8(%esp)
80105563:	89 44 24 04          	mov    %eax,0x4(%esp)
80105567:	8b 45 08             	mov    0x8(%ebp),%eax
8010556a:	89 04 24             	mov    %eax,(%esp)
8010556d:	e8 84 ff ff ff       	call   801054f6 <stosl>
80105572:	eb 19                	jmp    8010558d <memset+0x72>
  } else
    stosb(dst, c, n);
80105574:	8b 45 10             	mov    0x10(%ebp),%eax
80105577:	89 44 24 08          	mov    %eax,0x8(%esp)
8010557b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010557e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105582:	8b 45 08             	mov    0x8(%ebp),%eax
80105585:	89 04 24             	mov    %eax,(%esp)
80105588:	e8 44 ff ff ff       	call   801054d1 <stosb>
  return dst;
8010558d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105590:	c9                   	leave  
80105591:	c3                   	ret    

80105592 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105592:	55                   	push   %ebp
80105593:	89 e5                	mov    %esp,%ebp
80105595:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105598:	8b 45 08             	mov    0x8(%ebp),%eax
8010559b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010559e:	8b 45 0c             	mov    0xc(%ebp),%eax
801055a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801055a4:	eb 30                	jmp    801055d6 <memcmp+0x44>
    if(*s1 != *s2)
801055a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055a9:	0f b6 10             	movzbl (%eax),%edx
801055ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055af:	0f b6 00             	movzbl (%eax),%eax
801055b2:	38 c2                	cmp    %al,%dl
801055b4:	74 18                	je     801055ce <memcmp+0x3c>
      return *s1 - *s2;
801055b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055b9:	0f b6 00             	movzbl (%eax),%eax
801055bc:	0f b6 d0             	movzbl %al,%edx
801055bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055c2:	0f b6 00             	movzbl (%eax),%eax
801055c5:	0f b6 c0             	movzbl %al,%eax
801055c8:	29 c2                	sub    %eax,%edx
801055ca:	89 d0                	mov    %edx,%eax
801055cc:	eb 1a                	jmp    801055e8 <memcmp+0x56>
    s1++, s2++;
801055ce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801055d2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801055d6:	8b 45 10             	mov    0x10(%ebp),%eax
801055d9:	8d 50 ff             	lea    -0x1(%eax),%edx
801055dc:	89 55 10             	mov    %edx,0x10(%ebp)
801055df:	85 c0                	test   %eax,%eax
801055e1:	75 c3                	jne    801055a6 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801055e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055e8:	c9                   	leave  
801055e9:	c3                   	ret    

801055ea <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801055ea:	55                   	push   %ebp
801055eb:	89 e5                	mov    %esp,%ebp
801055ed:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801055f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801055f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801055f6:	8b 45 08             	mov    0x8(%ebp),%eax
801055f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801055fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105602:	73 3d                	jae    80105641 <memmove+0x57>
80105604:	8b 45 10             	mov    0x10(%ebp),%eax
80105607:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010560a:	01 d0                	add    %edx,%eax
8010560c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010560f:	76 30                	jbe    80105641 <memmove+0x57>
    s += n;
80105611:	8b 45 10             	mov    0x10(%ebp),%eax
80105614:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105617:	8b 45 10             	mov    0x10(%ebp),%eax
8010561a:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010561d:	eb 13                	jmp    80105632 <memmove+0x48>
      *--d = *--s;
8010561f:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105623:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105627:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010562a:	0f b6 10             	movzbl (%eax),%edx
8010562d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105630:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105632:	8b 45 10             	mov    0x10(%ebp),%eax
80105635:	8d 50 ff             	lea    -0x1(%eax),%edx
80105638:	89 55 10             	mov    %edx,0x10(%ebp)
8010563b:	85 c0                	test   %eax,%eax
8010563d:	75 e0                	jne    8010561f <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010563f:	eb 26                	jmp    80105667 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105641:	eb 17                	jmp    8010565a <memmove+0x70>
      *d++ = *s++;
80105643:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105646:	8d 50 01             	lea    0x1(%eax),%edx
80105649:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010564c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010564f:	8d 4a 01             	lea    0x1(%edx),%ecx
80105652:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105655:	0f b6 12             	movzbl (%edx),%edx
80105658:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010565a:	8b 45 10             	mov    0x10(%ebp),%eax
8010565d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105660:	89 55 10             	mov    %edx,0x10(%ebp)
80105663:	85 c0                	test   %eax,%eax
80105665:	75 dc                	jne    80105643 <memmove+0x59>
      *d++ = *s++;

  return dst;
80105667:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010566a:	c9                   	leave  
8010566b:	c3                   	ret    

8010566c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010566c:	55                   	push   %ebp
8010566d:	89 e5                	mov    %esp,%ebp
8010566f:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105672:	8b 45 10             	mov    0x10(%ebp),%eax
80105675:	89 44 24 08          	mov    %eax,0x8(%esp)
80105679:	8b 45 0c             	mov    0xc(%ebp),%eax
8010567c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105680:	8b 45 08             	mov    0x8(%ebp),%eax
80105683:	89 04 24             	mov    %eax,(%esp)
80105686:	e8 5f ff ff ff       	call   801055ea <memmove>
}
8010568b:	c9                   	leave  
8010568c:	c3                   	ret    

8010568d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010568d:	55                   	push   %ebp
8010568e:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105690:	eb 0c                	jmp    8010569e <strncmp+0x11>
    n--, p++, q++;
80105692:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105696:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010569a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010569e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056a2:	74 1a                	je     801056be <strncmp+0x31>
801056a4:	8b 45 08             	mov    0x8(%ebp),%eax
801056a7:	0f b6 00             	movzbl (%eax),%eax
801056aa:	84 c0                	test   %al,%al
801056ac:	74 10                	je     801056be <strncmp+0x31>
801056ae:	8b 45 08             	mov    0x8(%ebp),%eax
801056b1:	0f b6 10             	movzbl (%eax),%edx
801056b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801056b7:	0f b6 00             	movzbl (%eax),%eax
801056ba:	38 c2                	cmp    %al,%dl
801056bc:	74 d4                	je     80105692 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801056be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056c2:	75 07                	jne    801056cb <strncmp+0x3e>
    return 0;
801056c4:	b8 00 00 00 00       	mov    $0x0,%eax
801056c9:	eb 16                	jmp    801056e1 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801056cb:	8b 45 08             	mov    0x8(%ebp),%eax
801056ce:	0f b6 00             	movzbl (%eax),%eax
801056d1:	0f b6 d0             	movzbl %al,%edx
801056d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801056d7:	0f b6 00             	movzbl (%eax),%eax
801056da:	0f b6 c0             	movzbl %al,%eax
801056dd:	29 c2                	sub    %eax,%edx
801056df:	89 d0                	mov    %edx,%eax
}
801056e1:	5d                   	pop    %ebp
801056e2:	c3                   	ret    

801056e3 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801056e3:	55                   	push   %ebp
801056e4:	89 e5                	mov    %esp,%ebp
801056e6:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801056e9:	8b 45 08             	mov    0x8(%ebp),%eax
801056ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801056ef:	90                   	nop
801056f0:	8b 45 10             	mov    0x10(%ebp),%eax
801056f3:	8d 50 ff             	lea    -0x1(%eax),%edx
801056f6:	89 55 10             	mov    %edx,0x10(%ebp)
801056f9:	85 c0                	test   %eax,%eax
801056fb:	7e 1e                	jle    8010571b <strncpy+0x38>
801056fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105700:	8d 50 01             	lea    0x1(%eax),%edx
80105703:	89 55 08             	mov    %edx,0x8(%ebp)
80105706:	8b 55 0c             	mov    0xc(%ebp),%edx
80105709:	8d 4a 01             	lea    0x1(%edx),%ecx
8010570c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010570f:	0f b6 12             	movzbl (%edx),%edx
80105712:	88 10                	mov    %dl,(%eax)
80105714:	0f b6 00             	movzbl (%eax),%eax
80105717:	84 c0                	test   %al,%al
80105719:	75 d5                	jne    801056f0 <strncpy+0xd>
    ;
  while(n-- > 0)
8010571b:	eb 0c                	jmp    80105729 <strncpy+0x46>
    *s++ = 0;
8010571d:	8b 45 08             	mov    0x8(%ebp),%eax
80105720:	8d 50 01             	lea    0x1(%eax),%edx
80105723:	89 55 08             	mov    %edx,0x8(%ebp)
80105726:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105729:	8b 45 10             	mov    0x10(%ebp),%eax
8010572c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010572f:	89 55 10             	mov    %edx,0x10(%ebp)
80105732:	85 c0                	test   %eax,%eax
80105734:	7f e7                	jg     8010571d <strncpy+0x3a>
    *s++ = 0;
  return os;
80105736:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105739:	c9                   	leave  
8010573a:	c3                   	ret    

8010573b <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010573b:	55                   	push   %ebp
8010573c:	89 e5                	mov    %esp,%ebp
8010573e:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105741:	8b 45 08             	mov    0x8(%ebp),%eax
80105744:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105747:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010574b:	7f 05                	jg     80105752 <safestrcpy+0x17>
    return os;
8010574d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105750:	eb 31                	jmp    80105783 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105752:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105756:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010575a:	7e 1e                	jle    8010577a <safestrcpy+0x3f>
8010575c:	8b 45 08             	mov    0x8(%ebp),%eax
8010575f:	8d 50 01             	lea    0x1(%eax),%edx
80105762:	89 55 08             	mov    %edx,0x8(%ebp)
80105765:	8b 55 0c             	mov    0xc(%ebp),%edx
80105768:	8d 4a 01             	lea    0x1(%edx),%ecx
8010576b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010576e:	0f b6 12             	movzbl (%edx),%edx
80105771:	88 10                	mov    %dl,(%eax)
80105773:	0f b6 00             	movzbl (%eax),%eax
80105776:	84 c0                	test   %al,%al
80105778:	75 d8                	jne    80105752 <safestrcpy+0x17>
    ;
  *s = 0;
8010577a:	8b 45 08             	mov    0x8(%ebp),%eax
8010577d:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105780:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105783:	c9                   	leave  
80105784:	c3                   	ret    

80105785 <strlen>:

int
strlen(const char *s)
{
80105785:	55                   	push   %ebp
80105786:	89 e5                	mov    %esp,%ebp
80105788:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010578b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105792:	eb 04                	jmp    80105798 <strlen+0x13>
80105794:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105798:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010579b:	8b 45 08             	mov    0x8(%ebp),%eax
8010579e:	01 d0                	add    %edx,%eax
801057a0:	0f b6 00             	movzbl (%eax),%eax
801057a3:	84 c0                	test   %al,%al
801057a5:	75 ed                	jne    80105794 <strlen+0xf>
    ;
  return n;
801057a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801057aa:	c9                   	leave  
801057ab:	c3                   	ret    

801057ac <swtch>:
.globl implicit_exit
.globl end_of_exit

.globl swtch
swtch:
  movl 4(%esp), %eax
801057ac:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801057b0:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801057b4:	55                   	push   %ebp
  pushl %ebx
801057b5:	53                   	push   %ebx
  pushl %esi
801057b6:	56                   	push   %esi
  pushl %edi
801057b7:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801057b8:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801057ba:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801057bc:	5f                   	pop    %edi
  popl %esi
801057bd:	5e                   	pop    %esi
  popl %ebx
801057be:	5b                   	pop    %ebx
  popl %ebp
801057bf:	5d                   	pop    %ebp
  ret
801057c0:	c3                   	ret    

801057c1 <implicit_exit>:

//new func - implicit_exit
implicit_exit:
  //pushl %eax			//?????
  pushl %eax
801057c1:	50                   	push   %eax
  movl $SYS_exit, %eax
801057c2:	b8 02 00 00 00       	mov    $0x2,%eax
  int $T_SYSCALL
801057c7:	cd 40                	int    $0x40

801057c9 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801057c9:	55                   	push   %ebp
801057ca:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801057cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057d2:	8b 00                	mov    (%eax),%eax
801057d4:	3b 45 08             	cmp    0x8(%ebp),%eax
801057d7:	76 12                	jbe    801057eb <fetchint+0x22>
801057d9:	8b 45 08             	mov    0x8(%ebp),%eax
801057dc:	8d 50 04             	lea    0x4(%eax),%edx
801057df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057e5:	8b 00                	mov    (%eax),%eax
801057e7:	39 c2                	cmp    %eax,%edx
801057e9:	76 07                	jbe    801057f2 <fetchint+0x29>
    return -1;
801057eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f0:	eb 0f                	jmp    80105801 <fetchint+0x38>
  *ip = *(int*)(addr);
801057f2:	8b 45 08             	mov    0x8(%ebp),%eax
801057f5:	8b 10                	mov    (%eax),%edx
801057f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801057fa:	89 10                	mov    %edx,(%eax)
  return 0;
801057fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105801:	5d                   	pop    %ebp
80105802:	c3                   	ret    

80105803 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105803:	55                   	push   %ebp
80105804:	89 e5                	mov    %esp,%ebp
80105806:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105809:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010580f:	8b 00                	mov    (%eax),%eax
80105811:	3b 45 08             	cmp    0x8(%ebp),%eax
80105814:	77 07                	ja     8010581d <fetchstr+0x1a>
    return -1;
80105816:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581b:	eb 46                	jmp    80105863 <fetchstr+0x60>
  *pp = (char*)addr;
8010581d:	8b 55 08             	mov    0x8(%ebp),%edx
80105820:	8b 45 0c             	mov    0xc(%ebp),%eax
80105823:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105825:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010582b:	8b 00                	mov    (%eax),%eax
8010582d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105830:	8b 45 0c             	mov    0xc(%ebp),%eax
80105833:	8b 00                	mov    (%eax),%eax
80105835:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105838:	eb 1c                	jmp    80105856 <fetchstr+0x53>
    if(*s == 0)
8010583a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010583d:	0f b6 00             	movzbl (%eax),%eax
80105840:	84 c0                	test   %al,%al
80105842:	75 0e                	jne    80105852 <fetchstr+0x4f>
      return s - *pp;
80105844:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105847:	8b 45 0c             	mov    0xc(%ebp),%eax
8010584a:	8b 00                	mov    (%eax),%eax
8010584c:	29 c2                	sub    %eax,%edx
8010584e:	89 d0                	mov    %edx,%eax
80105850:	eb 11                	jmp    80105863 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105852:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105856:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105859:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010585c:	72 dc                	jb     8010583a <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
8010585e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105863:	c9                   	leave  
80105864:	c3                   	ret    

80105865 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105865:	55                   	push   %ebp
80105866:	89 e5                	mov    %esp,%ebp
80105868:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010586b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105871:	8b 40 18             	mov    0x18(%eax),%eax
80105874:	8b 50 44             	mov    0x44(%eax),%edx
80105877:	8b 45 08             	mov    0x8(%ebp),%eax
8010587a:	c1 e0 02             	shl    $0x2,%eax
8010587d:	01 d0                	add    %edx,%eax
8010587f:	8d 50 04             	lea    0x4(%eax),%edx
80105882:	8b 45 0c             	mov    0xc(%ebp),%eax
80105885:	89 44 24 04          	mov    %eax,0x4(%esp)
80105889:	89 14 24             	mov    %edx,(%esp)
8010588c:	e8 38 ff ff ff       	call   801057c9 <fetchint>
}
80105891:	c9                   	leave  
80105892:	c3                   	ret    

80105893 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105893:	55                   	push   %ebp
80105894:	89 e5                	mov    %esp,%ebp
80105896:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105899:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010589c:	89 44 24 04          	mov    %eax,0x4(%esp)
801058a0:	8b 45 08             	mov    0x8(%ebp),%eax
801058a3:	89 04 24             	mov    %eax,(%esp)
801058a6:	e8 ba ff ff ff       	call   80105865 <argint>
801058ab:	85 c0                	test   %eax,%eax
801058ad:	79 07                	jns    801058b6 <argptr+0x23>
    return -1;
801058af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b4:	eb 3d                	jmp    801058f3 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801058b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058b9:	89 c2                	mov    %eax,%edx
801058bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058c1:	8b 00                	mov    (%eax),%eax
801058c3:	39 c2                	cmp    %eax,%edx
801058c5:	73 16                	jae    801058dd <argptr+0x4a>
801058c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058ca:	89 c2                	mov    %eax,%edx
801058cc:	8b 45 10             	mov    0x10(%ebp),%eax
801058cf:	01 c2                	add    %eax,%edx
801058d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058d7:	8b 00                	mov    (%eax),%eax
801058d9:	39 c2                	cmp    %eax,%edx
801058db:	76 07                	jbe    801058e4 <argptr+0x51>
    return -1;
801058dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e2:	eb 0f                	jmp    801058f3 <argptr+0x60>
  *pp = (char*)i;
801058e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058e7:	89 c2                	mov    %eax,%edx
801058e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ec:	89 10                	mov    %edx,(%eax)
  return 0;
801058ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058f3:	c9                   	leave  
801058f4:	c3                   	ret    

801058f5 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801058f5:	55                   	push   %ebp
801058f6:	89 e5                	mov    %esp,%ebp
801058f8:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
801058fb:	8d 45 fc             	lea    -0x4(%ebp),%eax
801058fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105902:	8b 45 08             	mov    0x8(%ebp),%eax
80105905:	89 04 24             	mov    %eax,(%esp)
80105908:	e8 58 ff ff ff       	call   80105865 <argint>
8010590d:	85 c0                	test   %eax,%eax
8010590f:	79 07                	jns    80105918 <argstr+0x23>
    return -1;
80105911:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105916:	eb 12                	jmp    8010592a <argstr+0x35>
  return fetchstr(addr, pp);
80105918:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010591b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010591e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105922:	89 04 24             	mov    %eax,(%esp)
80105925:	e8 d9 fe ff ff       	call   80105803 <fetchstr>
}
8010592a:	c9                   	leave  
8010592b:	c3                   	ret    

8010592c <syscall>:
[SYS_waitpid] sys_waitpid,
};

void
syscall(void)
{
8010592c:	55                   	push   %ebp
8010592d:	89 e5                	mov    %esp,%ebp
8010592f:	53                   	push   %ebx
80105930:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105933:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105939:	8b 40 18             	mov    0x18(%eax),%eax
8010593c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010593f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105946:	7e 30                	jle    80105978 <syscall+0x4c>
80105948:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010594b:	83 f8 1a             	cmp    $0x1a,%eax
8010594e:	77 28                	ja     80105978 <syscall+0x4c>
80105950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105953:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
8010595a:	85 c0                	test   %eax,%eax
8010595c:	74 1a                	je     80105978 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
8010595e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105964:	8b 58 18             	mov    0x18(%eax),%ebx
80105967:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010596a:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105971:	ff d0                	call   *%eax
80105973:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105976:	eb 3d                	jmp    801059b5 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105978:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010597e:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105981:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105987:	8b 40 10             	mov    0x10(%eax),%eax
8010598a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010598d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105991:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105995:	89 44 24 04          	mov    %eax,0x4(%esp)
80105999:	c7 04 24 bb 8e 10 80 	movl   $0x80108ebb,(%esp)
801059a0:	e8 fb a9 ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801059a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059ab:	8b 40 18             	mov    0x18(%eax),%eax
801059ae:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801059b5:	83 c4 24             	add    $0x24,%esp
801059b8:	5b                   	pop    %ebx
801059b9:	5d                   	pop    %ebp
801059ba:	c3                   	ret    

801059bb <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801059bb:	55                   	push   %ebp
801059bc:	89 e5                	mov    %esp,%ebp
801059be:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801059c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801059c8:	8b 45 08             	mov    0x8(%ebp),%eax
801059cb:	89 04 24             	mov    %eax,(%esp)
801059ce:	e8 92 fe ff ff       	call   80105865 <argint>
801059d3:	85 c0                	test   %eax,%eax
801059d5:	79 07                	jns    801059de <argfd+0x23>
    return -1;
801059d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059dc:	eb 50                	jmp    80105a2e <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801059de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e1:	85 c0                	test   %eax,%eax
801059e3:	78 21                	js     80105a06 <argfd+0x4b>
801059e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059e8:	83 f8 0f             	cmp    $0xf,%eax
801059eb:	7f 19                	jg     80105a06 <argfd+0x4b>
801059ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801059f6:	83 c2 08             	add    $0x8,%edx
801059f9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801059fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a04:	75 07                	jne    80105a0d <argfd+0x52>
    return -1;
80105a06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0b:	eb 21                	jmp    80105a2e <argfd+0x73>
  if(pfd)
80105a0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105a11:	74 08                	je     80105a1b <argfd+0x60>
    *pfd = fd;
80105a13:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a16:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a19:	89 10                	mov    %edx,(%eax)
  if(pf)
80105a1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a1f:	74 08                	je     80105a29 <argfd+0x6e>
    *pf = f;
80105a21:	8b 45 10             	mov    0x10(%ebp),%eax
80105a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a27:	89 10                	mov    %edx,(%eax)
  return 0;
80105a29:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a2e:	c9                   	leave  
80105a2f:	c3                   	ret    

80105a30 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105a36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a3d:	eb 30                	jmp    80105a6f <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105a3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a45:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a48:	83 c2 08             	add    $0x8,%edx
80105a4b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105a4f:	85 c0                	test   %eax,%eax
80105a51:	75 18                	jne    80105a6b <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105a53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a59:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a5c:	8d 4a 08             	lea    0x8(%edx),%ecx
80105a5f:	8b 55 08             	mov    0x8(%ebp),%edx
80105a62:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105a66:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a69:	eb 0f                	jmp    80105a7a <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105a6b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a6f:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105a73:	7e ca                	jle    80105a3f <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105a75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a7a:	c9                   	leave  
80105a7b:	c3                   	ret    

80105a7c <sys_dup>:

int
sys_dup(void)
{
80105a7c:	55                   	push   %ebp
80105a7d:	89 e5                	mov    %esp,%ebp
80105a7f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105a82:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a85:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a89:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a90:	00 
80105a91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a98:	e8 1e ff ff ff       	call   801059bb <argfd>
80105a9d:	85 c0                	test   %eax,%eax
80105a9f:	79 07                	jns    80105aa8 <sys_dup+0x2c>
    return -1;
80105aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa6:	eb 29                	jmp    80105ad1 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aab:	89 04 24             	mov    %eax,(%esp)
80105aae:	e8 7d ff ff ff       	call   80105a30 <fdalloc>
80105ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ab6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aba:	79 07                	jns    80105ac3 <sys_dup+0x47>
    return -1;
80105abc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ac1:	eb 0e                	jmp    80105ad1 <sys_dup+0x55>
  filedup(f);
80105ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ac6:	89 04 24             	mov    %eax,(%esp)
80105ac9:	e8 fe b4 ff ff       	call   80100fcc <filedup>
  return fd;
80105ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105ad1:	c9                   	leave  
80105ad2:	c3                   	ret    

80105ad3 <sys_read>:

int
sys_read(void)
{
80105ad3:	55                   	push   %ebp
80105ad4:	89 e5                	mov    %esp,%ebp
80105ad6:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ad9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105adc:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ae0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105ae7:	00 
80105ae8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105aef:	e8 c7 fe ff ff       	call   801059bb <argfd>
80105af4:	85 c0                	test   %eax,%eax
80105af6:	78 35                	js     80105b2d <sys_read+0x5a>
80105af8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105afb:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aff:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105b06:	e8 5a fd ff ff       	call   80105865 <argint>
80105b0b:	85 c0                	test   %eax,%eax
80105b0d:	78 1e                	js     80105b2d <sys_read+0x5a>
80105b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b12:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b16:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b19:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b24:	e8 6a fd ff ff       	call   80105893 <argptr>
80105b29:	85 c0                	test   %eax,%eax
80105b2b:	79 07                	jns    80105b34 <sys_read+0x61>
    return -1;
80105b2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b32:	eb 19                	jmp    80105b4d <sys_read+0x7a>
  return fileread(f, p, n);
80105b34:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105b37:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105b41:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b45:	89 04 24             	mov    %eax,(%esp)
80105b48:	e8 ec b5 ff ff       	call   80101139 <fileread>
}
80105b4d:	c9                   	leave  
80105b4e:	c3                   	ret    

80105b4f <sys_write>:

int
sys_write(void)
{
80105b4f:	55                   	push   %ebp
80105b50:	89 e5                	mov    %esp,%ebp
80105b52:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105b55:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b58:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b5c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b63:	00 
80105b64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b6b:	e8 4b fe ff ff       	call   801059bb <argfd>
80105b70:	85 c0                	test   %eax,%eax
80105b72:	78 35                	js     80105ba9 <sys_write+0x5a>
80105b74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b77:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b7b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105b82:	e8 de fc ff ff       	call   80105865 <argint>
80105b87:	85 c0                	test   %eax,%eax
80105b89:	78 1e                	js     80105ba9 <sys_write+0x5a>
80105b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b8e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b92:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b95:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ba0:	e8 ee fc ff ff       	call   80105893 <argptr>
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	79 07                	jns    80105bb0 <sys_write+0x61>
    return -1;
80105ba9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bae:	eb 19                	jmp    80105bc9 <sys_write+0x7a>
  return filewrite(f, p, n);
80105bb0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105bb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105bbd:	89 54 24 04          	mov    %edx,0x4(%esp)
80105bc1:	89 04 24             	mov    %eax,(%esp)
80105bc4:	e8 2c b6 ff ff       	call   801011f5 <filewrite>
}
80105bc9:	c9                   	leave  
80105bca:	c3                   	ret    

80105bcb <sys_close>:

int
sys_close(void)
{
80105bcb:	55                   	push   %ebp
80105bcc:	89 e5                	mov    %esp,%ebp
80105bce:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105bd1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bd4:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bdf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105be6:	e8 d0 fd ff ff       	call   801059bb <argfd>
80105beb:	85 c0                	test   %eax,%eax
80105bed:	79 07                	jns    80105bf6 <sys_close+0x2b>
    return -1;
80105bef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bf4:	eb 24                	jmp    80105c1a <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105bf6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bff:	83 c2 08             	add    $0x8,%edx
80105c02:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105c09:	00 
  fileclose(f);
80105c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c0d:	89 04 24             	mov    %eax,(%esp)
80105c10:	e8 ff b3 ff ff       	call   80101014 <fileclose>
  return 0;
80105c15:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c1a:	c9                   	leave  
80105c1b:	c3                   	ret    

80105c1c <sys_fstat>:

int
sys_fstat(void)
{
80105c1c:	55                   	push   %ebp
80105c1d:	89 e5                	mov    %esp,%ebp
80105c1f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105c22:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c25:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c29:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c30:	00 
80105c31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c38:	e8 7e fd ff ff       	call   801059bb <argfd>
80105c3d:	85 c0                	test   %eax,%eax
80105c3f:	78 1f                	js     80105c60 <sys_fstat+0x44>
80105c41:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105c48:	00 
80105c49:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105c57:	e8 37 fc ff ff       	call   80105893 <argptr>
80105c5c:	85 c0                	test   %eax,%eax
80105c5e:	79 07                	jns    80105c67 <sys_fstat+0x4b>
    return -1;
80105c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c65:	eb 12                	jmp    80105c79 <sys_fstat+0x5d>
  return filestat(f, st);
80105c67:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c6d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c71:	89 04 24             	mov    %eax,(%esp)
80105c74:	e8 71 b4 ff ff       	call   801010ea <filestat>
}
80105c79:	c9                   	leave  
80105c7a:	c3                   	ret    

80105c7b <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105c7b:	55                   	push   %ebp
80105c7c:	89 e5                	mov    %esp,%ebp
80105c7e:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105c81:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105c84:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c8f:	e8 61 fc ff ff       	call   801058f5 <argstr>
80105c94:	85 c0                	test   %eax,%eax
80105c96:	78 17                	js     80105caf <sys_link+0x34>
80105c98:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ca6:	e8 4a fc ff ff       	call   801058f5 <argstr>
80105cab:	85 c0                	test   %eax,%eax
80105cad:	79 0a                	jns    80105cb9 <sys_link+0x3e>
    return -1;
80105caf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb4:	e9 42 01 00 00       	jmp    80105dfb <sys_link+0x180>

  begin_op();
80105cb9:	e8 98 d7 ff ff       	call   80103456 <begin_op>
  if((ip = namei(old)) == 0){
80105cbe:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105cc1:	89 04 24             	mov    %eax,(%esp)
80105cc4:	e8 83 c7 ff ff       	call   8010244c <namei>
80105cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ccc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cd0:	75 0f                	jne    80105ce1 <sys_link+0x66>
    end_op();
80105cd2:	e8 03 d8 ff ff       	call   801034da <end_op>
    return -1;
80105cd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cdc:	e9 1a 01 00 00       	jmp    80105dfb <sys_link+0x180>
  }

  ilock(ip);
80105ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce4:	89 04 24             	mov    %eax,(%esp)
80105ce7:	e8 b5 bb ff ff       	call   801018a1 <ilock>
  if(ip->type == T_DIR){
80105cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cef:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105cf3:	66 83 f8 01          	cmp    $0x1,%ax
80105cf7:	75 1a                	jne    80105d13 <sys_link+0x98>
    iunlockput(ip);
80105cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfc:	89 04 24             	mov    %eax,(%esp)
80105cff:	e8 21 be ff ff       	call   80101b25 <iunlockput>
    end_op();
80105d04:	e8 d1 d7 ff ff       	call   801034da <end_op>
    return -1;
80105d09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0e:	e9 e8 00 00 00       	jmp    80105dfb <sys_link+0x180>
  }

  ip->nlink++;
80105d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d16:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d1a:	8d 50 01             	lea    0x1(%eax),%edx
80105d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d20:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d27:	89 04 24             	mov    %eax,(%esp)
80105d2a:	e8 b6 b9 ff ff       	call   801016e5 <iupdate>
  iunlock(ip);
80105d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d32:	89 04 24             	mov    %eax,(%esp)
80105d35:	e8 b5 bc ff ff       	call   801019ef <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105d3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d3d:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105d40:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d44:	89 04 24             	mov    %eax,(%esp)
80105d47:	e8 22 c7 ff ff       	call   8010246e <nameiparent>
80105d4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d53:	75 02                	jne    80105d57 <sys_link+0xdc>
    goto bad;
80105d55:	eb 68                	jmp    80105dbf <sys_link+0x144>
  ilock(dp);
80105d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d5a:	89 04 24             	mov    %eax,(%esp)
80105d5d:	e8 3f bb ff ff       	call   801018a1 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d65:	8b 10                	mov    (%eax),%edx
80105d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d6a:	8b 00                	mov    (%eax),%eax
80105d6c:	39 c2                	cmp    %eax,%edx
80105d6e:	75 20                	jne    80105d90 <sys_link+0x115>
80105d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d73:	8b 40 04             	mov    0x4(%eax),%eax
80105d76:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d7a:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105d7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d84:	89 04 24             	mov    %eax,(%esp)
80105d87:	e8 00 c4 ff ff       	call   8010218c <dirlink>
80105d8c:	85 c0                	test   %eax,%eax
80105d8e:	79 0d                	jns    80105d9d <sys_link+0x122>
    iunlockput(dp);
80105d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d93:	89 04 24             	mov    %eax,(%esp)
80105d96:	e8 8a bd ff ff       	call   80101b25 <iunlockput>
    goto bad;
80105d9b:	eb 22                	jmp    80105dbf <sys_link+0x144>
  }
  iunlockput(dp);
80105d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da0:	89 04 24             	mov    %eax,(%esp)
80105da3:	e8 7d bd ff ff       	call   80101b25 <iunlockput>
  iput(ip);
80105da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dab:	89 04 24             	mov    %eax,(%esp)
80105dae:	e8 a1 bc ff ff       	call   80101a54 <iput>

  end_op();
80105db3:	e8 22 d7 ff ff       	call   801034da <end_op>

  return 0;
80105db8:	b8 00 00 00 00       	mov    $0x0,%eax
80105dbd:	eb 3c                	jmp    80105dfb <sys_link+0x180>

bad:
  ilock(ip);
80105dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc2:	89 04 24             	mov    %eax,(%esp)
80105dc5:	e8 d7 ba ff ff       	call   801018a1 <ilock>
  ip->nlink--;
80105dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dcd:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105dd1:	8d 50 ff             	lea    -0x1(%eax),%edx
80105dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd7:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dde:	89 04 24             	mov    %eax,(%esp)
80105de1:	e8 ff b8 ff ff       	call   801016e5 <iupdate>
  iunlockput(ip);
80105de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de9:	89 04 24             	mov    %eax,(%esp)
80105dec:	e8 34 bd ff ff       	call   80101b25 <iunlockput>
  end_op();
80105df1:	e8 e4 d6 ff ff       	call   801034da <end_op>
  return -1;
80105df6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dfb:	c9                   	leave  
80105dfc:	c3                   	ret    

80105dfd <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105dfd:	55                   	push   %ebp
80105dfe:	89 e5                	mov    %esp,%ebp
80105e00:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e03:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105e0a:	eb 4b                	jmp    80105e57 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e0f:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105e16:	00 
80105e17:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e1b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e22:	8b 45 08             	mov    0x8(%ebp),%eax
80105e25:	89 04 24             	mov    %eax,(%esp)
80105e28:	e8 81 bf ff ff       	call   80101dae <readi>
80105e2d:	83 f8 10             	cmp    $0x10,%eax
80105e30:	74 0c                	je     80105e3e <isdirempty+0x41>
      panic("isdirempty: readi");
80105e32:	c7 04 24 d7 8e 10 80 	movl   $0x80108ed7,(%esp)
80105e39:	e8 fc a6 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105e3e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105e42:	66 85 c0             	test   %ax,%ax
80105e45:	74 07                	je     80105e4e <isdirempty+0x51>
      return 0;
80105e47:	b8 00 00 00 00       	mov    $0x0,%eax
80105e4c:	eb 1b                	jmp    80105e69 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e51:	83 c0 10             	add    $0x10,%eax
80105e54:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e57:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e5a:	8b 45 08             	mov    0x8(%ebp),%eax
80105e5d:	8b 40 18             	mov    0x18(%eax),%eax
80105e60:	39 c2                	cmp    %eax,%edx
80105e62:	72 a8                	jb     80105e0c <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105e64:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105e69:	c9                   	leave  
80105e6a:	c3                   	ret    

80105e6b <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105e6b:	55                   	push   %ebp
80105e6c:	89 e5                	mov    %esp,%ebp
80105e6e:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105e71:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105e74:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e7f:	e8 71 fa ff ff       	call   801058f5 <argstr>
80105e84:	85 c0                	test   %eax,%eax
80105e86:	79 0a                	jns    80105e92 <sys_unlink+0x27>
    return -1;
80105e88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e8d:	e9 af 01 00 00       	jmp    80106041 <sys_unlink+0x1d6>

  begin_op();
80105e92:	e8 bf d5 ff ff       	call   80103456 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105e97:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105e9a:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105e9d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ea1:	89 04 24             	mov    %eax,(%esp)
80105ea4:	e8 c5 c5 ff ff       	call   8010246e <nameiparent>
80105ea9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105eac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105eb0:	75 0f                	jne    80105ec1 <sys_unlink+0x56>
    end_op();
80105eb2:	e8 23 d6 ff ff       	call   801034da <end_op>
    return -1;
80105eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebc:	e9 80 01 00 00       	jmp    80106041 <sys_unlink+0x1d6>
  }

  ilock(dp);
80105ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec4:	89 04 24             	mov    %eax,(%esp)
80105ec7:	e8 d5 b9 ff ff       	call   801018a1 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105ecc:	c7 44 24 04 e9 8e 10 	movl   $0x80108ee9,0x4(%esp)
80105ed3:	80 
80105ed4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ed7:	89 04 24             	mov    %eax,(%esp)
80105eda:	e8 c2 c1 ff ff       	call   801020a1 <namecmp>
80105edf:	85 c0                	test   %eax,%eax
80105ee1:	0f 84 45 01 00 00    	je     8010602c <sys_unlink+0x1c1>
80105ee7:	c7 44 24 04 eb 8e 10 	movl   $0x80108eeb,0x4(%esp)
80105eee:	80 
80105eef:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ef2:	89 04 24             	mov    %eax,(%esp)
80105ef5:	e8 a7 c1 ff ff       	call   801020a1 <namecmp>
80105efa:	85 c0                	test   %eax,%eax
80105efc:	0f 84 2a 01 00 00    	je     8010602c <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105f02:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105f05:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f09:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105f0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f13:	89 04 24             	mov    %eax,(%esp)
80105f16:	e8 a8 c1 ff ff       	call   801020c3 <dirlookup>
80105f1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f22:	75 05                	jne    80105f29 <sys_unlink+0xbe>
    goto bad;
80105f24:	e9 03 01 00 00       	jmp    8010602c <sys_unlink+0x1c1>
  ilock(ip);
80105f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f2c:	89 04 24             	mov    %eax,(%esp)
80105f2f:	e8 6d b9 ff ff       	call   801018a1 <ilock>

  if(ip->nlink < 1)
80105f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f37:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f3b:	66 85 c0             	test   %ax,%ax
80105f3e:	7f 0c                	jg     80105f4c <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105f40:	c7 04 24 ee 8e 10 80 	movl   $0x80108eee,(%esp)
80105f47:	e8 ee a5 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f4f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f53:	66 83 f8 01          	cmp    $0x1,%ax
80105f57:	75 1f                	jne    80105f78 <sys_unlink+0x10d>
80105f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f5c:	89 04 24             	mov    %eax,(%esp)
80105f5f:	e8 99 fe ff ff       	call   80105dfd <isdirempty>
80105f64:	85 c0                	test   %eax,%eax
80105f66:	75 10                	jne    80105f78 <sys_unlink+0x10d>
    iunlockput(ip);
80105f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f6b:	89 04 24             	mov    %eax,(%esp)
80105f6e:	e8 b2 bb ff ff       	call   80101b25 <iunlockput>
    goto bad;
80105f73:	e9 b4 00 00 00       	jmp    8010602c <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105f78:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105f7f:	00 
80105f80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105f87:	00 
80105f88:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f8b:	89 04 24             	mov    %eax,(%esp)
80105f8e:	e8 88 f5 ff ff       	call   8010551b <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f93:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105f96:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105f9d:	00 
80105f9e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fa2:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fa5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fac:	89 04 24             	mov    %eax,(%esp)
80105faf:	e8 5e bf ff ff       	call   80101f12 <writei>
80105fb4:	83 f8 10             	cmp    $0x10,%eax
80105fb7:	74 0c                	je     80105fc5 <sys_unlink+0x15a>
    panic("unlink: writei");
80105fb9:	c7 04 24 00 8f 10 80 	movl   $0x80108f00,(%esp)
80105fc0:	e8 75 a5 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80105fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105fcc:	66 83 f8 01          	cmp    $0x1,%ax
80105fd0:	75 1c                	jne    80105fee <sys_unlink+0x183>
    dp->nlink--;
80105fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fd5:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105fd9:	8d 50 ff             	lea    -0x1(%eax),%edx
80105fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fdf:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe6:	89 04 24             	mov    %eax,(%esp)
80105fe9:	e8 f7 b6 ff ff       	call   801016e5 <iupdate>
  }
  iunlockput(dp);
80105fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ff1:	89 04 24             	mov    %eax,(%esp)
80105ff4:	e8 2c bb ff ff       	call   80101b25 <iunlockput>

  ip->nlink--;
80105ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ffc:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106000:	8d 50 ff             	lea    -0x1(%eax),%edx
80106003:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106006:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010600a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010600d:	89 04 24             	mov    %eax,(%esp)
80106010:	e8 d0 b6 ff ff       	call   801016e5 <iupdate>
  iunlockput(ip);
80106015:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106018:	89 04 24             	mov    %eax,(%esp)
8010601b:	e8 05 bb ff ff       	call   80101b25 <iunlockput>

  end_op();
80106020:	e8 b5 d4 ff ff       	call   801034da <end_op>

  return 0;
80106025:	b8 00 00 00 00       	mov    $0x0,%eax
8010602a:	eb 15                	jmp    80106041 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
8010602c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010602f:	89 04 24             	mov    %eax,(%esp)
80106032:	e8 ee ba ff ff       	call   80101b25 <iunlockput>
  end_op();
80106037:	e8 9e d4 ff ff       	call   801034da <end_op>
  return -1;
8010603c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106041:	c9                   	leave  
80106042:	c3                   	ret    

80106043 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106043:	55                   	push   %ebp
80106044:	89 e5                	mov    %esp,%ebp
80106046:	83 ec 48             	sub    $0x48,%esp
80106049:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010604c:	8b 55 10             	mov    0x10(%ebp),%edx
8010604f:	8b 45 14             	mov    0x14(%ebp),%eax
80106052:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106056:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010605a:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010605e:	8d 45 de             	lea    -0x22(%ebp),%eax
80106061:	89 44 24 04          	mov    %eax,0x4(%esp)
80106065:	8b 45 08             	mov    0x8(%ebp),%eax
80106068:	89 04 24             	mov    %eax,(%esp)
8010606b:	e8 fe c3 ff ff       	call   8010246e <nameiparent>
80106070:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106073:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106077:	75 0a                	jne    80106083 <create+0x40>
    return 0;
80106079:	b8 00 00 00 00       	mov    $0x0,%eax
8010607e:	e9 7e 01 00 00       	jmp    80106201 <create+0x1be>
  ilock(dp);
80106083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106086:	89 04 24             	mov    %eax,(%esp)
80106089:	e8 13 b8 ff ff       	call   801018a1 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010608e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106091:	89 44 24 08          	mov    %eax,0x8(%esp)
80106095:	8d 45 de             	lea    -0x22(%ebp),%eax
80106098:	89 44 24 04          	mov    %eax,0x4(%esp)
8010609c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010609f:	89 04 24             	mov    %eax,(%esp)
801060a2:	e8 1c c0 ff ff       	call   801020c3 <dirlookup>
801060a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060ae:	74 47                	je     801060f7 <create+0xb4>
    iunlockput(dp);
801060b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b3:	89 04 24             	mov    %eax,(%esp)
801060b6:	e8 6a ba ff ff       	call   80101b25 <iunlockput>
    ilock(ip);
801060bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060be:	89 04 24             	mov    %eax,(%esp)
801060c1:	e8 db b7 ff ff       	call   801018a1 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801060c6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801060cb:	75 15                	jne    801060e2 <create+0x9f>
801060cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060d0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801060d4:	66 83 f8 02          	cmp    $0x2,%ax
801060d8:	75 08                	jne    801060e2 <create+0x9f>
      return ip;
801060da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060dd:	e9 1f 01 00 00       	jmp    80106201 <create+0x1be>
    iunlockput(ip);
801060e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060e5:	89 04 24             	mov    %eax,(%esp)
801060e8:	e8 38 ba ff ff       	call   80101b25 <iunlockput>
    return 0;
801060ed:	b8 00 00 00 00       	mov    $0x0,%eax
801060f2:	e9 0a 01 00 00       	jmp    80106201 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801060f7:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801060fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060fe:	8b 00                	mov    (%eax),%eax
80106100:	89 54 24 04          	mov    %edx,0x4(%esp)
80106104:	89 04 24             	mov    %eax,(%esp)
80106107:	e8 fa b4 ff ff       	call   80101606 <ialloc>
8010610c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010610f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106113:	75 0c                	jne    80106121 <create+0xde>
    panic("create: ialloc");
80106115:	c7 04 24 0f 8f 10 80 	movl   $0x80108f0f,(%esp)
8010611c:	e8 19 a4 ff ff       	call   8010053a <panic>

  ilock(ip);
80106121:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106124:	89 04 24             	mov    %eax,(%esp)
80106127:	e8 75 b7 ff ff       	call   801018a1 <ilock>
  ip->major = major;
8010612c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010612f:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106133:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106137:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010613a:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
8010613e:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106142:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106145:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010614b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010614e:	89 04 24             	mov    %eax,(%esp)
80106151:	e8 8f b5 ff ff       	call   801016e5 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80106156:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010615b:	75 6a                	jne    801061c7 <create+0x184>
    dp->nlink++;  // for ".."
8010615d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106160:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106164:	8d 50 01             	lea    0x1(%eax),%edx
80106167:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010616a:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010616e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106171:	89 04 24             	mov    %eax,(%esp)
80106174:	e8 6c b5 ff ff       	call   801016e5 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106179:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010617c:	8b 40 04             	mov    0x4(%eax),%eax
8010617f:	89 44 24 08          	mov    %eax,0x8(%esp)
80106183:	c7 44 24 04 e9 8e 10 	movl   $0x80108ee9,0x4(%esp)
8010618a:	80 
8010618b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010618e:	89 04 24             	mov    %eax,(%esp)
80106191:	e8 f6 bf ff ff       	call   8010218c <dirlink>
80106196:	85 c0                	test   %eax,%eax
80106198:	78 21                	js     801061bb <create+0x178>
8010619a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010619d:	8b 40 04             	mov    0x4(%eax),%eax
801061a0:	89 44 24 08          	mov    %eax,0x8(%esp)
801061a4:	c7 44 24 04 eb 8e 10 	movl   $0x80108eeb,0x4(%esp)
801061ab:	80 
801061ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061af:	89 04 24             	mov    %eax,(%esp)
801061b2:	e8 d5 bf ff ff       	call   8010218c <dirlink>
801061b7:	85 c0                	test   %eax,%eax
801061b9:	79 0c                	jns    801061c7 <create+0x184>
      panic("create dots");
801061bb:	c7 04 24 1e 8f 10 80 	movl   $0x80108f1e,(%esp)
801061c2:	e8 73 a3 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801061c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ca:	8b 40 04             	mov    0x4(%eax),%eax
801061cd:	89 44 24 08          	mov    %eax,0x8(%esp)
801061d1:	8d 45 de             	lea    -0x22(%ebp),%eax
801061d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801061d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061db:	89 04 24             	mov    %eax,(%esp)
801061de:	e8 a9 bf ff ff       	call   8010218c <dirlink>
801061e3:	85 c0                	test   %eax,%eax
801061e5:	79 0c                	jns    801061f3 <create+0x1b0>
    panic("create: dirlink");
801061e7:	c7 04 24 2a 8f 10 80 	movl   $0x80108f2a,(%esp)
801061ee:	e8 47 a3 ff ff       	call   8010053a <panic>

  iunlockput(dp);
801061f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f6:	89 04 24             	mov    %eax,(%esp)
801061f9:	e8 27 b9 ff ff       	call   80101b25 <iunlockput>

  return ip;
801061fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106201:	c9                   	leave  
80106202:	c3                   	ret    

80106203 <sys_open>:

int
sys_open(void)
{
80106203:	55                   	push   %ebp
80106204:	89 e5                	mov    %esp,%ebp
80106206:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106209:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010620c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106210:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106217:	e8 d9 f6 ff ff       	call   801058f5 <argstr>
8010621c:	85 c0                	test   %eax,%eax
8010621e:	78 17                	js     80106237 <sys_open+0x34>
80106220:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106223:	89 44 24 04          	mov    %eax,0x4(%esp)
80106227:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010622e:	e8 32 f6 ff ff       	call   80105865 <argint>
80106233:	85 c0                	test   %eax,%eax
80106235:	79 0a                	jns    80106241 <sys_open+0x3e>
    return -1;
80106237:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623c:	e9 5c 01 00 00       	jmp    8010639d <sys_open+0x19a>

  begin_op();
80106241:	e8 10 d2 ff ff       	call   80103456 <begin_op>

  if(omode & O_CREATE){
80106246:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106249:	25 00 02 00 00       	and    $0x200,%eax
8010624e:	85 c0                	test   %eax,%eax
80106250:	74 3b                	je     8010628d <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80106252:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106255:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010625c:	00 
8010625d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106264:	00 
80106265:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010626c:	00 
8010626d:	89 04 24             	mov    %eax,(%esp)
80106270:	e8 ce fd ff ff       	call   80106043 <create>
80106275:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010627c:	75 6b                	jne    801062e9 <sys_open+0xe6>
      end_op();
8010627e:	e8 57 d2 ff ff       	call   801034da <end_op>
      return -1;
80106283:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106288:	e9 10 01 00 00       	jmp    8010639d <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
8010628d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106290:	89 04 24             	mov    %eax,(%esp)
80106293:	e8 b4 c1 ff ff       	call   8010244c <namei>
80106298:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010629b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010629f:	75 0f                	jne    801062b0 <sys_open+0xad>
      end_op();
801062a1:	e8 34 d2 ff ff       	call   801034da <end_op>
      return -1;
801062a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ab:	e9 ed 00 00 00       	jmp    8010639d <sys_open+0x19a>
    }
    ilock(ip);
801062b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b3:	89 04 24             	mov    %eax,(%esp)
801062b6:	e8 e6 b5 ff ff       	call   801018a1 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801062bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062be:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062c2:	66 83 f8 01          	cmp    $0x1,%ax
801062c6:	75 21                	jne    801062e9 <sys_open+0xe6>
801062c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062cb:	85 c0                	test   %eax,%eax
801062cd:	74 1a                	je     801062e9 <sys_open+0xe6>
      iunlockput(ip);
801062cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d2:	89 04 24             	mov    %eax,(%esp)
801062d5:	e8 4b b8 ff ff       	call   80101b25 <iunlockput>
      end_op();
801062da:	e8 fb d1 ff ff       	call   801034da <end_op>
      return -1;
801062df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e4:	e9 b4 00 00 00       	jmp    8010639d <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801062e9:	e8 7e ac ff ff       	call   80100f6c <filealloc>
801062ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062f5:	74 14                	je     8010630b <sys_open+0x108>
801062f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062fa:	89 04 24             	mov    %eax,(%esp)
801062fd:	e8 2e f7 ff ff       	call   80105a30 <fdalloc>
80106302:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106305:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106309:	79 28                	jns    80106333 <sys_open+0x130>
    if(f)
8010630b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010630f:	74 0b                	je     8010631c <sys_open+0x119>
      fileclose(f);
80106311:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106314:	89 04 24             	mov    %eax,(%esp)
80106317:	e8 f8 ac ff ff       	call   80101014 <fileclose>
    iunlockput(ip);
8010631c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010631f:	89 04 24             	mov    %eax,(%esp)
80106322:	e8 fe b7 ff ff       	call   80101b25 <iunlockput>
    end_op();
80106327:	e8 ae d1 ff ff       	call   801034da <end_op>
    return -1;
8010632c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106331:	eb 6a                	jmp    8010639d <sys_open+0x19a>
  }
  iunlock(ip);
80106333:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106336:	89 04 24             	mov    %eax,(%esp)
80106339:	e8 b1 b6 ff ff       	call   801019ef <iunlock>
  end_op();
8010633e:	e8 97 d1 ff ff       	call   801034da <end_op>

  f->type = FD_INODE;
80106343:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106346:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010634c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010634f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106352:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106355:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106358:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010635f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106362:	83 e0 01             	and    $0x1,%eax
80106365:	85 c0                	test   %eax,%eax
80106367:	0f 94 c0             	sete   %al
8010636a:	89 c2                	mov    %eax,%edx
8010636c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010636f:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106375:	83 e0 01             	and    $0x1,%eax
80106378:	85 c0                	test   %eax,%eax
8010637a:	75 0a                	jne    80106386 <sys_open+0x183>
8010637c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010637f:	83 e0 02             	and    $0x2,%eax
80106382:	85 c0                	test   %eax,%eax
80106384:	74 07                	je     8010638d <sys_open+0x18a>
80106386:	b8 01 00 00 00       	mov    $0x1,%eax
8010638b:	eb 05                	jmp    80106392 <sys_open+0x18f>
8010638d:	b8 00 00 00 00       	mov    $0x0,%eax
80106392:	89 c2                	mov    %eax,%edx
80106394:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106397:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010639a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010639d:	c9                   	leave  
8010639e:	c3                   	ret    

8010639f <sys_mkdir>:

int
sys_mkdir(void)
{
8010639f:	55                   	push   %ebp
801063a0:	89 e5                	mov    %esp,%ebp
801063a2:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801063a5:	e8 ac d0 ff ff       	call   80103456 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801063aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801063b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063b8:	e8 38 f5 ff ff       	call   801058f5 <argstr>
801063bd:	85 c0                	test   %eax,%eax
801063bf:	78 2c                	js     801063ed <sys_mkdir+0x4e>
801063c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063c4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801063cb:	00 
801063cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801063d3:	00 
801063d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801063db:	00 
801063dc:	89 04 24             	mov    %eax,(%esp)
801063df:	e8 5f fc ff ff       	call   80106043 <create>
801063e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063eb:	75 0c                	jne    801063f9 <sys_mkdir+0x5a>
    end_op();
801063ed:	e8 e8 d0 ff ff       	call   801034da <end_op>
    return -1;
801063f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063f7:	eb 15                	jmp    8010640e <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801063f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063fc:	89 04 24             	mov    %eax,(%esp)
801063ff:	e8 21 b7 ff ff       	call   80101b25 <iunlockput>
  end_op();
80106404:	e8 d1 d0 ff ff       	call   801034da <end_op>
  return 0;
80106409:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010640e:	c9                   	leave  
8010640f:	c3                   	ret    

80106410 <sys_mknod>:

int
sys_mknod(void)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106416:	e8 3b d0 ff ff       	call   80103456 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010641b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010641e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106422:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106429:	e8 c7 f4 ff ff       	call   801058f5 <argstr>
8010642e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106435:	78 5e                	js     80106495 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106437:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010643a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010643e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106445:	e8 1b f4 ff ff       	call   80105865 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010644a:	85 c0                	test   %eax,%eax
8010644c:	78 47                	js     80106495 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010644e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106451:	89 44 24 04          	mov    %eax,0x4(%esp)
80106455:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010645c:	e8 04 f4 ff ff       	call   80105865 <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106461:	85 c0                	test   %eax,%eax
80106463:	78 30                	js     80106495 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106468:	0f bf c8             	movswl %ax,%ecx
8010646b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010646e:	0f bf d0             	movswl %ax,%edx
80106471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106474:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106478:	89 54 24 08          	mov    %edx,0x8(%esp)
8010647c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106483:	00 
80106484:	89 04 24             	mov    %eax,(%esp)
80106487:	e8 b7 fb ff ff       	call   80106043 <create>
8010648c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010648f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106493:	75 0c                	jne    801064a1 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106495:	e8 40 d0 ff ff       	call   801034da <end_op>
    return -1;
8010649a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010649f:	eb 15                	jmp    801064b6 <sys_mknod+0xa6>
  }
  iunlockput(ip);
801064a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064a4:	89 04 24             	mov    %eax,(%esp)
801064a7:	e8 79 b6 ff ff       	call   80101b25 <iunlockput>
  end_op();
801064ac:	e8 29 d0 ff ff       	call   801034da <end_op>
  return 0;
801064b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064b6:	c9                   	leave  
801064b7:	c3                   	ret    

801064b8 <sys_chdir>:

int
sys_chdir(void)
{
801064b8:	55                   	push   %ebp
801064b9:	89 e5                	mov    %esp,%ebp
801064bb:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801064be:	e8 93 cf ff ff       	call   80103456 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801064c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801064ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064d1:	e8 1f f4 ff ff       	call   801058f5 <argstr>
801064d6:	85 c0                	test   %eax,%eax
801064d8:	78 14                	js     801064ee <sys_chdir+0x36>
801064da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064dd:	89 04 24             	mov    %eax,(%esp)
801064e0:	e8 67 bf ff ff       	call   8010244c <namei>
801064e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064ec:	75 0c                	jne    801064fa <sys_chdir+0x42>
    end_op();
801064ee:	e8 e7 cf ff ff       	call   801034da <end_op>
    return -1;
801064f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064f8:	eb 61                	jmp    8010655b <sys_chdir+0xa3>
  }
  ilock(ip);
801064fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064fd:	89 04 24             	mov    %eax,(%esp)
80106500:	e8 9c b3 ff ff       	call   801018a1 <ilock>
  if(ip->type != T_DIR){
80106505:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106508:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010650c:	66 83 f8 01          	cmp    $0x1,%ax
80106510:	74 17                	je     80106529 <sys_chdir+0x71>
    iunlockput(ip);
80106512:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106515:	89 04 24             	mov    %eax,(%esp)
80106518:	e8 08 b6 ff ff       	call   80101b25 <iunlockput>
    end_op();
8010651d:	e8 b8 cf ff ff       	call   801034da <end_op>
    return -1;
80106522:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106527:	eb 32                	jmp    8010655b <sys_chdir+0xa3>
  }
  iunlock(ip);
80106529:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010652c:	89 04 24             	mov    %eax,(%esp)
8010652f:	e8 bb b4 ff ff       	call   801019ef <iunlock>
  iput(proc->cwd);
80106534:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010653a:	8b 40 68             	mov    0x68(%eax),%eax
8010653d:	89 04 24             	mov    %eax,(%esp)
80106540:	e8 0f b5 ff ff       	call   80101a54 <iput>
  end_op();
80106545:	e8 90 cf ff ff       	call   801034da <end_op>
  proc->cwd = ip;
8010654a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106550:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106553:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106556:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010655b:	c9                   	leave  
8010655c:	c3                   	ret    

8010655d <sys_exec>:

int
sys_exec(void)
{
8010655d:	55                   	push   %ebp
8010655e:	89 e5                	mov    %esp,%ebp
80106560:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106566:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106569:	89 44 24 04          	mov    %eax,0x4(%esp)
8010656d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106574:	e8 7c f3 ff ff       	call   801058f5 <argstr>
80106579:	85 c0                	test   %eax,%eax
8010657b:	78 1a                	js     80106597 <sys_exec+0x3a>
8010657d:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106583:	89 44 24 04          	mov    %eax,0x4(%esp)
80106587:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010658e:	e8 d2 f2 ff ff       	call   80105865 <argint>
80106593:	85 c0                	test   %eax,%eax
80106595:	79 0a                	jns    801065a1 <sys_exec+0x44>
    return -1;
80106597:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010659c:	e9 c8 00 00 00       	jmp    80106669 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
801065a1:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801065a8:	00 
801065a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801065b0:	00 
801065b1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801065b7:	89 04 24             	mov    %eax,(%esp)
801065ba:	e8 5c ef ff ff       	call   8010551b <memset>
  for(i=0;; i++){
801065bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801065c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c9:	83 f8 1f             	cmp    $0x1f,%eax
801065cc:	76 0a                	jbe    801065d8 <sys_exec+0x7b>
      return -1;
801065ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065d3:	e9 91 00 00 00       	jmp    80106669 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801065d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065db:	c1 e0 02             	shl    $0x2,%eax
801065de:	89 c2                	mov    %eax,%edx
801065e0:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801065e6:	01 c2                	add    %eax,%edx
801065e8:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801065ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801065f2:	89 14 24             	mov    %edx,(%esp)
801065f5:	e8 cf f1 ff ff       	call   801057c9 <fetchint>
801065fa:	85 c0                	test   %eax,%eax
801065fc:	79 07                	jns    80106605 <sys_exec+0xa8>
      return -1;
801065fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106603:	eb 64                	jmp    80106669 <sys_exec+0x10c>
    if(uarg == 0){
80106605:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010660b:	85 c0                	test   %eax,%eax
8010660d:	75 26                	jne    80106635 <sys_exec+0xd8>
      argv[i] = 0;
8010660f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106612:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106619:	00 00 00 00 
      break;
8010661d:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010661e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106621:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106627:	89 54 24 04          	mov    %edx,0x4(%esp)
8010662b:	89 04 24             	mov    %eax,(%esp)
8010662e:	e8 bc a4 ff ff       	call   80100aef <exec>
80106633:	eb 34                	jmp    80106669 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106635:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010663b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010663e:	c1 e2 02             	shl    $0x2,%edx
80106641:	01 c2                	add    %eax,%edx
80106643:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106649:	89 54 24 04          	mov    %edx,0x4(%esp)
8010664d:	89 04 24             	mov    %eax,(%esp)
80106650:	e8 ae f1 ff ff       	call   80105803 <fetchstr>
80106655:	85 c0                	test   %eax,%eax
80106657:	79 07                	jns    80106660 <sys_exec+0x103>
      return -1;
80106659:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010665e:	eb 09                	jmp    80106669 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106660:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106664:	e9 5d ff ff ff       	jmp    801065c6 <sys_exec+0x69>
  return exec(path, argv);
}
80106669:	c9                   	leave  
8010666a:	c3                   	ret    

8010666b <sys_pipe>:

int
sys_pipe(void)
{
8010666b:	55                   	push   %ebp
8010666c:	89 e5                	mov    %esp,%ebp
8010666e:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106671:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106678:	00 
80106679:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010667c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106680:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106687:	e8 07 f2 ff ff       	call   80105893 <argptr>
8010668c:	85 c0                	test   %eax,%eax
8010668e:	79 0a                	jns    8010669a <sys_pipe+0x2f>
    return -1;
80106690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106695:	e9 9b 00 00 00       	jmp    80106735 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
8010669a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010669d:	89 44 24 04          	mov    %eax,0x4(%esp)
801066a1:	8d 45 e8             	lea    -0x18(%ebp),%eax
801066a4:	89 04 24             	mov    %eax,(%esp)
801066a7:	e8 bb d8 ff ff       	call   80103f67 <pipealloc>
801066ac:	85 c0                	test   %eax,%eax
801066ae:	79 07                	jns    801066b7 <sys_pipe+0x4c>
    return -1;
801066b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066b5:	eb 7e                	jmp    80106735 <sys_pipe+0xca>
  fd0 = -1;
801066b7:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801066be:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066c1:	89 04 24             	mov    %eax,(%esp)
801066c4:	e8 67 f3 ff ff       	call   80105a30 <fdalloc>
801066c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066d0:	78 14                	js     801066e6 <sys_pipe+0x7b>
801066d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066d5:	89 04 24             	mov    %eax,(%esp)
801066d8:	e8 53 f3 ff ff       	call   80105a30 <fdalloc>
801066dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066e4:	79 37                	jns    8010671d <sys_pipe+0xb2>
    if(fd0 >= 0)
801066e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066ea:	78 14                	js     80106700 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801066ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066f5:	83 c2 08             	add    $0x8,%edx
801066f8:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801066ff:	00 
    fileclose(rf);
80106700:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106703:	89 04 24             	mov    %eax,(%esp)
80106706:	e8 09 a9 ff ff       	call   80101014 <fileclose>
    fileclose(wf);
8010670b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010670e:	89 04 24             	mov    %eax,(%esp)
80106711:	e8 fe a8 ff ff       	call   80101014 <fileclose>
    return -1;
80106716:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671b:	eb 18                	jmp    80106735 <sys_pipe+0xca>
  }
  fd[0] = fd0;
8010671d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106720:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106723:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106725:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106728:	8d 50 04             	lea    0x4(%eax),%edx
8010672b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010672e:	89 02                	mov    %eax,(%edx)
  return 0;
80106730:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106735:	c9                   	leave  
80106736:	c3                   	ret    

80106737 <sys_fork>:
#include "proc.h"
#include "jobs.h"

int
sys_fork(void)
{
80106737:	55                   	push   %ebp
80106738:	89 e5                	mov    %esp,%ebp
8010673a:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010673d:	e8 dd de ff ff       	call   8010461f <fork>
}
80106742:	c9                   	leave  
80106743:	c3                   	ret    

80106744 <sys_exit>:

int
sys_exit(void)
{
80106744:	55                   	push   %ebp
80106745:	89 e5                	mov    %esp,%ebp
80106747:	83 ec 28             	sub    $0x28,%esp
  int status;
	if (argint(0, &status) < 0)
8010674a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010674d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106751:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106758:	e8 08 f1 ff ff       	call   80105865 <argint>
8010675d:	85 c0                	test   %eax,%eax
8010675f:	79 07                	jns    80106768 <sys_exit+0x24>
		return -1;			//Mybe need to add exit(-1)???
80106761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106766:	eb 10                	jmp    80106778 <sys_exit+0x34>
	exit(status);
80106768:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010676b:	89 04 24             	mov    %eax,(%esp)
8010676e:	e8 3c e0 ff ff       	call   801047af <exit>
  return 0;  // not reached
80106773:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106778:	c9                   	leave  
80106779:	c3                   	ret    

8010677a <sys_wait>:

int
sys_wait(void)
{
8010677a:	55                   	push   %ebp
8010677b:	89 e5                	mov    %esp,%ebp
8010677d:	83 ec 28             	sub    $0x28,%esp
  int status;
  if (argint(0, &status) < 0)		//If there is no process
80106780:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106783:	89 44 24 04          	mov    %eax,0x4(%esp)
80106787:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010678e:	e8 d2 f0 ff ff       	call   80105865 <argint>
80106793:	85 c0                	test   %eax,%eax
80106795:	79 07                	jns    8010679e <sys_wait+0x24>
    return -1;
80106797:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010679c:	eb 0b                	jmp    801067a9 <sys_wait+0x2f>
  return wait((int*)status);		
8010679e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a1:	89 04 24             	mov    %eax,(%esp)
801067a4:	e8 37 e1 ff ff       	call   801048e0 <wait>
}
801067a9:	c9                   	leave  
801067aa:	c3                   	ret    

801067ab <sys_kill>:

int
sys_kill(void)
{
801067ab:	55                   	push   %ebp
801067ac:	89 e5                	mov    %esp,%ebp
801067ae:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801067b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801067b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067bf:	e8 a1 f0 ff ff       	call   80105865 <argint>
801067c4:	85 c0                	test   %eax,%eax
801067c6:	79 07                	jns    801067cf <sys_kill+0x24>
    return -1;
801067c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067cd:	eb 0b                	jmp    801067da <sys_kill+0x2f>
  return kill(pid);
801067cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067d2:	89 04 24             	mov    %eax,(%esp)
801067d5:	e8 ff e4 ff ff       	call   80104cd9 <kill>
}
801067da:	c9                   	leave  
801067db:	c3                   	ret    

801067dc <sys_getpid>:

int
sys_getpid(void)
{
801067dc:	55                   	push   %ebp
801067dd:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801067df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067e5:	8b 40 10             	mov    0x10(%eax),%eax
}
801067e8:	5d                   	pop    %ebp
801067e9:	c3                   	ret    

801067ea <sys_sbrk>:

int
sys_sbrk(void)
{
801067ea:	55                   	push   %ebp
801067eb:	89 e5                	mov    %esp,%ebp
801067ed:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801067f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801067f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067fe:	e8 62 f0 ff ff       	call   80105865 <argint>
80106803:	85 c0                	test   %eax,%eax
80106805:	79 07                	jns    8010680e <sys_sbrk+0x24>
    return -1;
80106807:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010680c:	eb 24                	jmp    80106832 <sys_sbrk+0x48>
  addr = proc->sz;
8010680e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106814:	8b 00                	mov    (%eax),%eax
80106816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106819:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010681c:	89 04 24             	mov    %eax,(%esp)
8010681f:	e8 56 dd ff ff       	call   8010457a <growproc>
80106824:	85 c0                	test   %eax,%eax
80106826:	79 07                	jns    8010682f <sys_sbrk+0x45>
    return -1;
80106828:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010682d:	eb 03                	jmp    80106832 <sys_sbrk+0x48>
  return addr;
8010682f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106832:	c9                   	leave  
80106833:	c3                   	ret    

80106834 <sys_sleep>:

int
sys_sleep(void)
{
80106834:	55                   	push   %ebp
80106835:	89 e5                	mov    %esp,%ebp
80106837:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010683a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010683d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106841:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106848:	e8 18 f0 ff ff       	call   80105865 <argint>
8010684d:	85 c0                	test   %eax,%eax
8010684f:	79 07                	jns    80106858 <sys_sleep+0x24>
    return -1;
80106851:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106856:	eb 6c                	jmp    801068c4 <sys_sleep+0x90>
  acquire(&tickslock);
80106858:	c7 04 24 c0 5a 11 80 	movl   $0x80115ac0,(%esp)
8010685f:	e8 63 ea ff ff       	call   801052c7 <acquire>
  ticks0 = ticks;
80106864:	a1 00 63 11 80       	mov    0x80116300,%eax
80106869:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010686c:	eb 34                	jmp    801068a2 <sys_sleep+0x6e>
    if(proc->killed){
8010686e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106874:	8b 40 24             	mov    0x24(%eax),%eax
80106877:	85 c0                	test   %eax,%eax
80106879:	74 13                	je     8010688e <sys_sleep+0x5a>
      release(&tickslock);
8010687b:	c7 04 24 c0 5a 11 80 	movl   $0x80115ac0,(%esp)
80106882:	e8 a2 ea ff ff       	call   80105329 <release>
      return -1;
80106887:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010688c:	eb 36                	jmp    801068c4 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
8010688e:	c7 44 24 04 c0 5a 11 	movl   $0x80115ac0,0x4(%esp)
80106895:	80 
80106896:	c7 04 24 00 63 11 80 	movl   $0x80116300,(%esp)
8010689d:	e8 30 e3 ff ff       	call   80104bd2 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801068a2:	a1 00 63 11 80       	mov    0x80116300,%eax
801068a7:	2b 45 f4             	sub    -0xc(%ebp),%eax
801068aa:	89 c2                	mov    %eax,%edx
801068ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068af:	39 c2                	cmp    %eax,%edx
801068b1:	72 bb                	jb     8010686e <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801068b3:	c7 04 24 c0 5a 11 80 	movl   $0x80115ac0,(%esp)
801068ba:	e8 6a ea ff ff       	call   80105329 <release>
  return 0;
801068bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068c4:	c9                   	leave  
801068c5:	c3                   	ret    

801068c6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801068c6:	55                   	push   %ebp
801068c7:	89 e5                	mov    %esp,%ebp
801068c9:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
801068cc:	c7 04 24 c0 5a 11 80 	movl   $0x80115ac0,(%esp)
801068d3:	e8 ef e9 ff ff       	call   801052c7 <acquire>
  xticks = ticks;
801068d8:	a1 00 63 11 80       	mov    0x80116300,%eax
801068dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801068e0:	c7 04 24 c0 5a 11 80 	movl   $0x80115ac0,(%esp)
801068e7:	e8 3d ea ff ff       	call   80105329 <release>
  return xticks;
801068ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801068ef:	c9                   	leave  
801068f0:	c3                   	ret    

801068f1 <sys_pstat>:

int
sys_pstat(void) {
801068f1:	55                   	push   %ebp
801068f2:	89 e5                	mov    %esp,%ebp
801068f4:	83 ec 28             	sub    $0x28,%esp
	struct procstat *stat=0;
801068f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int pid;
	  if (argint(0, &pid) < 0)
801068fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106901:	89 44 24 04          	mov    %eax,0x4(%esp)
80106905:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010690c:	e8 54 ef ff ff       	call   80105865 <argint>
80106911:	85 c0                	test   %eax,%eax
80106913:	79 07                	jns    8010691c <sys_pstat+0x2b>
		  return -1;
80106915:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010691a:	eb 3e                	jmp    8010695a <sys_pstat+0x69>
	  if(argptr(1, (char**)&stat, 4) < 0)
8010691c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106923:	00 
80106924:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106927:	89 44 24 04          	mov    %eax,0x4(%esp)
8010692b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106932:	e8 5c ef ff ff       	call   80105893 <argptr>
80106937:	85 c0                	test   %eax,%eax
80106939:	79 07                	jns    80106942 <sys_pstat+0x51>
		  return -1;
8010693b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106940:	eb 18                	jmp    8010695a <sys_pstat+0x69>

	int ret = pstat(pid, (struct procstat *)stat);
80106942:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106945:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106948:	89 54 24 04          	mov    %edx,0x4(%esp)
8010694c:	89 04 24             	mov    %eax,(%esp)
8010694f:	e8 07 e5 ff ff       	call   80104e5b <pstat>
80106954:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ret;
80106957:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010695a:	c9                   	leave  
8010695b:	c3                   	ret    

8010695c <sys_attachjob>:

int
sys_attachjob(void) {
8010695c:	55                   	push   %ebp
8010695d:	89 e5                	mov    %esp,%ebp
8010695f:	83 ec 28             	sub    $0x28,%esp
	int pid;
	int job;
	if (argint(0, &pid) < 0 || argint(1, &job) < 0)
80106962:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106965:	89 44 24 04          	mov    %eax,0x4(%esp)
80106969:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106970:	e8 f0 ee ff ff       	call   80105865 <argint>
80106975:	85 c0                	test   %eax,%eax
80106977:	78 17                	js     80106990 <sys_attachjob+0x34>
80106979:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010697c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106980:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106987:	e8 d9 ee ff ff       	call   80105865 <argint>
8010698c:	85 c0                	test   %eax,%eax
8010698e:	79 07                	jns    80106997 <sys_attachjob+0x3b>
		return -1;
80106990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106995:	eb 14                	jmp    801069ab <sys_attachjob+0x4f>
	return attachjob(pid, (struct job*) job);
80106997:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010699a:	89 c2                	mov    %eax,%edx
8010699c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010699f:	89 54 24 04          	mov    %edx,0x4(%esp)
801069a3:	89 04 24             	mov    %eax,(%esp)
801069a6:	e8 94 e5 ff ff       	call   80104f3f <attachjob>
}
801069ab:	c9                   	leave  
801069ac:	c3                   	ret    

801069ad <sys_printjob>:

int
sys_printjob(void) {
801069ad:	55                   	push   %ebp
801069ae:	89 e5                	mov    %esp,%ebp
801069b0:	83 ec 28             	sub    $0x28,%esp
	int jid;
	if (argint(0, &jid) < 0)
801069b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069b6:	89 44 24 04          	mov    %eax,0x4(%esp)
801069ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069c1:	e8 9f ee ff ff       	call   80105865 <argint>
801069c6:	85 c0                	test   %eax,%eax
801069c8:	79 07                	jns    801069d1 <sys_printjob+0x24>
		return -1;
801069ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069cf:	eb 0b                	jmp    801069dc <sys_printjob+0x2f>
	return printjob(jid);
801069d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069d4:	89 04 24             	mov    %eax,(%esp)
801069d7:	e8 fc e5 ff ff       	call   80104fd8 <printjob>
}
801069dc:	c9                   	leave  
801069dd:	c3                   	ret    

801069de <sys_fg>:

int
sys_fg(void) {
801069de:	55                   	push   %ebp
801069df:	89 e5                	mov    %esp,%ebp
801069e1:	83 ec 28             	sub    $0x28,%esp
	int jid;
	if (argint(0, &jid) < 0)
801069e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801069eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069f2:	e8 6e ee ff ff       	call   80105865 <argint>
801069f7:	85 c0                	test   %eax,%eax
801069f9:	79 07                	jns    80106a02 <sys_fg+0x24>
		return -1;
801069fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a00:	eb 0b                	jmp    80106a0d <sys_fg+0x2f>
	return fg(jid);
80106a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a05:	89 04 24             	mov    %eax,(%esp)
80106a08:	e8 a0 e7 ff ff       	call   801051ad <fg>
}
80106a0d:	c9                   	leave  
80106a0e:	c3                   	ret    

80106a0f <sys_waitpid>:


int
sys_waitpid(void)
{
80106a0f:	55                   	push   %ebp
80106a10:	89 e5                	mov    %esp,%ebp
80106a12:	53                   	push   %ebx
80106a13:	83 ec 24             	sub    $0x24,%esp
	int pid;
	int status;
	int options;

	if ( (argint(0, &pid) < 0) | (argint(1, &status) < 0) | (argint(2, &options) < 0) )
80106a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a19:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a24:	e8 3c ee ff ff       	call   80105865 <argint>
80106a29:	c1 e8 1f             	shr    $0x1f,%eax
80106a2c:	89 c3                	mov    %eax,%ebx
80106a2e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a31:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a3c:	e8 24 ee ff ff       	call   80105865 <argint>
80106a41:	c1 e8 1f             	shr    $0x1f,%eax
80106a44:	09 d8                	or     %ebx,%eax
80106a46:	0f b6 d8             	movzbl %al,%ebx
80106a49:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a50:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106a57:	e8 09 ee ff ff       	call   80105865 <argint>
80106a5c:	c1 e8 1f             	shr    $0x1f,%eax
80106a5f:	0f b6 c0             	movzbl %al,%eax
80106a62:	09 d8                	or     %ebx,%eax
80106a64:	85 c0                	test   %eax,%eax
80106a66:	74 07                	je     80106a6f <sys_waitpid+0x60>
		return -1;
80106a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a6d:	eb 1b                	jmp    80106a8a <sys_waitpid+0x7b>
	return waitpid(pid, (int*)status, options);
80106a6f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a75:	89 c2                	mov    %eax,%edx
80106a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a7a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106a7e:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a82:	89 04 24             	mov    %eax,(%esp)
80106a85:	e8 e4 e5 ff ff       	call   8010506e <waitpid>
}
80106a8a:	83 c4 24             	add    $0x24,%esp
80106a8d:	5b                   	pop    %ebx
80106a8e:	5d                   	pop    %ebp
80106a8f:	c3                   	ret    

80106a90 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	83 ec 08             	sub    $0x8,%esp
80106a96:	8b 55 08             	mov    0x8(%ebp),%edx
80106a99:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a9c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106aa0:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106aa3:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106aa7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106aab:	ee                   	out    %al,(%dx)
}
80106aac:	c9                   	leave  
80106aad:	c3                   	ret    

80106aae <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106aae:	55                   	push   %ebp
80106aaf:	89 e5                	mov    %esp,%ebp
80106ab1:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106ab4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106abb:	00 
80106abc:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106ac3:	e8 c8 ff ff ff       	call   80106a90 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106ac8:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106acf:	00 
80106ad0:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106ad7:	e8 b4 ff ff ff       	call   80106a90 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106adc:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106ae3:	00 
80106ae4:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106aeb:	e8 a0 ff ff ff       	call   80106a90 <outb>
  picenable(IRQ_TIMER);
80106af0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106af7:	e8 fe d2 ff ff       	call   80103dfa <picenable>
}
80106afc:	c9                   	leave  
80106afd:	c3                   	ret    

80106afe <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106afe:	1e                   	push   %ds
  pushl %es
80106aff:	06                   	push   %es
  pushl %fs
80106b00:	0f a0                	push   %fs
  pushl %gs
80106b02:	0f a8                	push   %gs
  pushal
80106b04:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106b05:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106b09:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106b0b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106b0d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106b11:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106b13:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106b15:	54                   	push   %esp
  call trap
80106b16:	e8 d8 01 00 00       	call   80106cf3 <trap>
  addl $4, %esp
80106b1b:	83 c4 04             	add    $0x4,%esp

80106b1e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106b1e:	61                   	popa   
  popl %gs
80106b1f:	0f a9                	pop    %gs
  popl %fs
80106b21:	0f a1                	pop    %fs
  popl %es
80106b23:	07                   	pop    %es
  popl %ds
80106b24:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106b25:	83 c4 08             	add    $0x8,%esp
  iret
80106b28:	cf                   	iret   

80106b29 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106b29:	55                   	push   %ebp
80106b2a:	89 e5                	mov    %esp,%ebp
80106b2c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b32:	83 e8 01             	sub    $0x1,%eax
80106b35:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106b39:	8b 45 08             	mov    0x8(%ebp),%eax
80106b3c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106b40:	8b 45 08             	mov    0x8(%ebp),%eax
80106b43:	c1 e8 10             	shr    $0x10,%eax
80106b46:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106b4a:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106b4d:	0f 01 18             	lidtl  (%eax)
}
80106b50:	c9                   	leave  
80106b51:	c3                   	ret    

80106b52 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106b52:	55                   	push   %ebp
80106b53:	89 e5                	mov    %esp,%ebp
80106b55:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106b58:	0f 20 d0             	mov    %cr2,%eax
80106b5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106b5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106b61:	c9                   	leave  
80106b62:	c3                   	ret    

80106b63 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106b63:	55                   	push   %ebp
80106b64:	89 e5                	mov    %esp,%ebp
80106b66:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106b69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106b70:	e9 c3 00 00 00       	jmp    80106c38 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b78:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106b7f:	89 c2                	mov    %eax,%edx
80106b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b84:	66 89 14 c5 00 5b 11 	mov    %dx,-0x7feea500(,%eax,8)
80106b8b:	80 
80106b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b8f:	66 c7 04 c5 02 5b 11 	movw   $0x8,-0x7feea4fe(,%eax,8)
80106b96:	80 08 00 
80106b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b9c:	0f b6 14 c5 04 5b 11 	movzbl -0x7feea4fc(,%eax,8),%edx
80106ba3:	80 
80106ba4:	83 e2 e0             	and    $0xffffffe0,%edx
80106ba7:	88 14 c5 04 5b 11 80 	mov    %dl,-0x7feea4fc(,%eax,8)
80106bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb1:	0f b6 14 c5 04 5b 11 	movzbl -0x7feea4fc(,%eax,8),%edx
80106bb8:	80 
80106bb9:	83 e2 1f             	and    $0x1f,%edx
80106bbc:	88 14 c5 04 5b 11 80 	mov    %dl,-0x7feea4fc(,%eax,8)
80106bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bc6:	0f b6 14 c5 05 5b 11 	movzbl -0x7feea4fb(,%eax,8),%edx
80106bcd:	80 
80106bce:	83 e2 f0             	and    $0xfffffff0,%edx
80106bd1:	83 ca 0e             	or     $0xe,%edx
80106bd4:	88 14 c5 05 5b 11 80 	mov    %dl,-0x7feea4fb(,%eax,8)
80106bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bde:	0f b6 14 c5 05 5b 11 	movzbl -0x7feea4fb(,%eax,8),%edx
80106be5:	80 
80106be6:	83 e2 ef             	and    $0xffffffef,%edx
80106be9:	88 14 c5 05 5b 11 80 	mov    %dl,-0x7feea4fb(,%eax,8)
80106bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bf3:	0f b6 14 c5 05 5b 11 	movzbl -0x7feea4fb(,%eax,8),%edx
80106bfa:	80 
80106bfb:	83 e2 9f             	and    $0xffffff9f,%edx
80106bfe:	88 14 c5 05 5b 11 80 	mov    %dl,-0x7feea4fb(,%eax,8)
80106c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c08:	0f b6 14 c5 05 5b 11 	movzbl -0x7feea4fb(,%eax,8),%edx
80106c0f:	80 
80106c10:	83 ca 80             	or     $0xffffff80,%edx
80106c13:	88 14 c5 05 5b 11 80 	mov    %dl,-0x7feea4fb(,%eax,8)
80106c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c1d:	8b 04 85 ac c0 10 80 	mov    -0x7fef3f54(,%eax,4),%eax
80106c24:	c1 e8 10             	shr    $0x10,%eax
80106c27:	89 c2                	mov    %eax,%edx
80106c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c2c:	66 89 14 c5 06 5b 11 	mov    %dx,-0x7feea4fa(,%eax,8)
80106c33:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106c34:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c38:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106c3f:	0f 8e 30 ff ff ff    	jle    80106b75 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106c45:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106c4a:	66 a3 00 5d 11 80    	mov    %ax,0x80115d00
80106c50:	66 c7 05 02 5d 11 80 	movw   $0x8,0x80115d02
80106c57:	08 00 
80106c59:	0f b6 05 04 5d 11 80 	movzbl 0x80115d04,%eax
80106c60:	83 e0 e0             	and    $0xffffffe0,%eax
80106c63:	a2 04 5d 11 80       	mov    %al,0x80115d04
80106c68:	0f b6 05 04 5d 11 80 	movzbl 0x80115d04,%eax
80106c6f:	83 e0 1f             	and    $0x1f,%eax
80106c72:	a2 04 5d 11 80       	mov    %al,0x80115d04
80106c77:	0f b6 05 05 5d 11 80 	movzbl 0x80115d05,%eax
80106c7e:	83 c8 0f             	or     $0xf,%eax
80106c81:	a2 05 5d 11 80       	mov    %al,0x80115d05
80106c86:	0f b6 05 05 5d 11 80 	movzbl 0x80115d05,%eax
80106c8d:	83 e0 ef             	and    $0xffffffef,%eax
80106c90:	a2 05 5d 11 80       	mov    %al,0x80115d05
80106c95:	0f b6 05 05 5d 11 80 	movzbl 0x80115d05,%eax
80106c9c:	83 c8 60             	or     $0x60,%eax
80106c9f:	a2 05 5d 11 80       	mov    %al,0x80115d05
80106ca4:	0f b6 05 05 5d 11 80 	movzbl 0x80115d05,%eax
80106cab:	83 c8 80             	or     $0xffffff80,%eax
80106cae:	a2 05 5d 11 80       	mov    %al,0x80115d05
80106cb3:	a1 ac c1 10 80       	mov    0x8010c1ac,%eax
80106cb8:	c1 e8 10             	shr    $0x10,%eax
80106cbb:	66 a3 06 5d 11 80    	mov    %ax,0x80115d06
  
  initlock(&tickslock, "time");
80106cc1:	c7 44 24 04 3c 8f 10 	movl   $0x80108f3c,0x4(%esp)
80106cc8:	80 
80106cc9:	c7 04 24 c0 5a 11 80 	movl   $0x80115ac0,(%esp)
80106cd0:	e8 d1 e5 ff ff       	call   801052a6 <initlock>
}
80106cd5:	c9                   	leave  
80106cd6:	c3                   	ret    

80106cd7 <idtinit>:

void
idtinit(void)
{
80106cd7:	55                   	push   %ebp
80106cd8:	89 e5                	mov    %esp,%ebp
80106cda:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106cdd:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106ce4:	00 
80106ce5:	c7 04 24 00 5b 11 80 	movl   $0x80115b00,(%esp)
80106cec:	e8 38 fe ff ff       	call   80106b29 <lidt>
}
80106cf1:	c9                   	leave  
80106cf2:	c3                   	ret    

80106cf3 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106cf3:	55                   	push   %ebp
80106cf4:	89 e5                	mov    %esp,%ebp
80106cf6:	57                   	push   %edi
80106cf7:	56                   	push   %esi
80106cf8:	53                   	push   %ebx
80106cf9:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80106cff:	8b 40 30             	mov    0x30(%eax),%eax
80106d02:	83 f8 40             	cmp    $0x40,%eax
80106d05:	75 4d                	jne    80106d54 <trap+0x61>
    if(proc->killed)
80106d07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d0d:	8b 40 24             	mov    0x24(%eax),%eax
80106d10:	85 c0                	test   %eax,%eax
80106d12:	74 0c                	je     80106d20 <trap+0x2d>
      exit(0);
80106d14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d1b:	e8 8f da ff ff       	call   801047af <exit>
    proc->tf = tf;
80106d20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d26:	8b 55 08             	mov    0x8(%ebp),%edx
80106d29:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106d2c:	e8 fb eb ff ff       	call   8010592c <syscall>
    if(proc->killed)
80106d31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d37:	8b 40 24             	mov    0x24(%eax),%eax
80106d3a:	85 c0                	test   %eax,%eax
80106d3c:	74 11                	je     80106d4f <trap+0x5c>
      exit(0);
80106d3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d45:	e8 65 da ff ff       	call   801047af <exit>
    return;
80106d4a:	e9 3b 02 00 00       	jmp    80106f8a <trap+0x297>
80106d4f:	e9 36 02 00 00       	jmp    80106f8a <trap+0x297>
  }

  switch(tf->trapno){
80106d54:	8b 45 08             	mov    0x8(%ebp),%eax
80106d57:	8b 40 30             	mov    0x30(%eax),%eax
80106d5a:	83 e8 20             	sub    $0x20,%eax
80106d5d:	83 f8 1f             	cmp    $0x1f,%eax
80106d60:	0f 87 bc 00 00 00    	ja     80106e22 <trap+0x12f>
80106d66:	8b 04 85 e4 8f 10 80 	mov    -0x7fef701c(,%eax,4),%eax
80106d6d:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106d6f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106d75:	0f b6 00             	movzbl (%eax),%eax
80106d78:	84 c0                	test   %al,%al
80106d7a:	75 31                	jne    80106dad <trap+0xba>
      acquire(&tickslock);
80106d7c:	c7 04 24 c0 5a 11 80 	movl   $0x80115ac0,(%esp)
80106d83:	e8 3f e5 ff ff       	call   801052c7 <acquire>
      ticks++;
80106d88:	a1 00 63 11 80       	mov    0x80116300,%eax
80106d8d:	83 c0 01             	add    $0x1,%eax
80106d90:	a3 00 63 11 80       	mov    %eax,0x80116300
      wakeup(&ticks);
80106d95:	c7 04 24 00 63 11 80 	movl   $0x80116300,(%esp)
80106d9c:	e8 0d df ff ff       	call   80104cae <wakeup>
      release(&tickslock);
80106da1:	c7 04 24 c0 5a 11 80 	movl   $0x80115ac0,(%esp)
80106da8:	e8 7c e5 ff ff       	call   80105329 <release>
    }
    lapiceoi();
80106dad:	e8 64 c1 ff ff       	call   80102f16 <lapiceoi>
    break;
80106db2:	e9 41 01 00 00       	jmp    80106ef8 <trap+0x205>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106db7:	e8 68 b9 ff ff       	call   80102724 <ideintr>
    lapiceoi();
80106dbc:	e8 55 c1 ff ff       	call   80102f16 <lapiceoi>
    break;
80106dc1:	e9 32 01 00 00       	jmp    80106ef8 <trap+0x205>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106dc6:	e8 1a bf ff ff       	call   80102ce5 <kbdintr>
    lapiceoi();
80106dcb:	e8 46 c1 ff ff       	call   80102f16 <lapiceoi>
    break;
80106dd0:	e9 23 01 00 00       	jmp    80106ef8 <trap+0x205>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106dd5:	e8 a5 03 00 00       	call   8010717f <uartintr>
    lapiceoi();
80106dda:	e8 37 c1 ff ff       	call   80102f16 <lapiceoi>
    break;
80106ddf:	e9 14 01 00 00       	jmp    80106ef8 <trap+0x205>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106de4:	8b 45 08             	mov    0x8(%ebp),%eax
80106de7:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106dea:	8b 45 08             	mov    0x8(%ebp),%eax
80106ded:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106df1:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106df4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106dfa:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106dfd:	0f b6 c0             	movzbl %al,%eax
80106e00:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106e04:	89 54 24 08          	mov    %edx,0x8(%esp)
80106e08:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e0c:	c7 04 24 44 8f 10 80 	movl   $0x80108f44,(%esp)
80106e13:	e8 88 95 ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106e18:	e8 f9 c0 ff ff       	call   80102f16 <lapiceoi>
    break;
80106e1d:	e9 d6 00 00 00       	jmp    80106ef8 <trap+0x205>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106e22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e28:	85 c0                	test   %eax,%eax
80106e2a:	74 11                	je     80106e3d <trap+0x14a>
80106e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106e33:	0f b7 c0             	movzwl %ax,%eax
80106e36:	83 e0 03             	and    $0x3,%eax
80106e39:	85 c0                	test   %eax,%eax
80106e3b:	75 46                	jne    80106e83 <trap+0x190>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e3d:	e8 10 fd ff ff       	call   80106b52 <rcr2>
80106e42:	8b 55 08             	mov    0x8(%ebp),%edx
80106e45:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106e48:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106e4f:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e52:	0f b6 ca             	movzbl %dl,%ecx
80106e55:	8b 55 08             	mov    0x8(%ebp),%edx
80106e58:	8b 52 30             	mov    0x30(%edx),%edx
80106e5b:	89 44 24 10          	mov    %eax,0x10(%esp)
80106e5f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106e63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106e67:	89 54 24 04          	mov    %edx,0x4(%esp)
80106e6b:	c7 04 24 68 8f 10 80 	movl   $0x80108f68,(%esp)
80106e72:	e8 29 95 ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106e77:	c7 04 24 9a 8f 10 80 	movl   $0x80108f9a,(%esp)
80106e7e:	e8 b7 96 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e83:	e8 ca fc ff ff       	call   80106b52 <rcr2>
80106e88:	89 c2                	mov    %eax,%edx
80106e8a:	8b 45 08             	mov    0x8(%ebp),%eax
80106e8d:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106e90:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e96:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106e99:	0f b6 f0             	movzbl %al,%esi
80106e9c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e9f:	8b 58 34             	mov    0x34(%eax),%ebx
80106ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ea5:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106ea8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106eae:	83 c0 6c             	add    $0x6c,%eax
80106eb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106eb4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106eba:	8b 40 10             	mov    0x10(%eax),%eax
80106ebd:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106ec1:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106ec5:	89 74 24 14          	mov    %esi,0x14(%esp)
80106ec9:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106ecd:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106ed1:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80106ed4:	89 74 24 08          	mov    %esi,0x8(%esp)
80106ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
80106edc:	c7 04 24 a0 8f 10 80 	movl   $0x80108fa0,(%esp)
80106ee3:	e8 b8 94 ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106ee8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106eee:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106ef5:	eb 01                	jmp    80106ef8 <trap+0x205>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106ef7:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106ef8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106efe:	85 c0                	test   %eax,%eax
80106f00:	74 2b                	je     80106f2d <trap+0x23a>
80106f02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f08:	8b 40 24             	mov    0x24(%eax),%eax
80106f0b:	85 c0                	test   %eax,%eax
80106f0d:	74 1e                	je     80106f2d <trap+0x23a>
80106f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f12:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f16:	0f b7 c0             	movzwl %ax,%eax
80106f19:	83 e0 03             	and    $0x3,%eax
80106f1c:	83 f8 03             	cmp    $0x3,%eax
80106f1f:	75 0c                	jne    80106f2d <trap+0x23a>
    exit(0);
80106f21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106f28:	e8 82 d8 ff ff       	call   801047af <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106f2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f33:	85 c0                	test   %eax,%eax
80106f35:	74 1e                	je     80106f55 <trap+0x262>
80106f37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f3d:	8b 40 0c             	mov    0xc(%eax),%eax
80106f40:	83 f8 04             	cmp    $0x4,%eax
80106f43:	75 10                	jne    80106f55 <trap+0x262>
80106f45:	8b 45 08             	mov    0x8(%ebp),%eax
80106f48:	8b 40 30             	mov    0x30(%eax),%eax
80106f4b:	83 f8 20             	cmp    $0x20,%eax
80106f4e:	75 05                	jne    80106f55 <trap+0x262>
    yield();
80106f50:	e8 1f dc ff ff       	call   80104b74 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106f55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f5b:	85 c0                	test   %eax,%eax
80106f5d:	74 2b                	je     80106f8a <trap+0x297>
80106f5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f65:	8b 40 24             	mov    0x24(%eax),%eax
80106f68:	85 c0                	test   %eax,%eax
80106f6a:	74 1e                	je     80106f8a <trap+0x297>
80106f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f6f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106f73:	0f b7 c0             	movzwl %ax,%eax
80106f76:	83 e0 03             	and    $0x3,%eax
80106f79:	83 f8 03             	cmp    $0x3,%eax
80106f7c:	75 0c                	jne    80106f8a <trap+0x297>
    exit(0);
80106f7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106f85:	e8 25 d8 ff ff       	call   801047af <exit>
}
80106f8a:	83 c4 3c             	add    $0x3c,%esp
80106f8d:	5b                   	pop    %ebx
80106f8e:	5e                   	pop    %esi
80106f8f:	5f                   	pop    %edi
80106f90:	5d                   	pop    %ebp
80106f91:	c3                   	ret    

80106f92 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106f92:	55                   	push   %ebp
80106f93:	89 e5                	mov    %esp,%ebp
80106f95:	83 ec 14             	sub    $0x14,%esp
80106f98:	8b 45 08             	mov    0x8(%ebp),%eax
80106f9b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f9f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106fa3:	89 c2                	mov    %eax,%edx
80106fa5:	ec                   	in     (%dx),%al
80106fa6:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106fa9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106fad:	c9                   	leave  
80106fae:	c3                   	ret    

80106faf <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106faf:	55                   	push   %ebp
80106fb0:	89 e5                	mov    %esp,%ebp
80106fb2:	83 ec 08             	sub    $0x8,%esp
80106fb5:	8b 55 08             	mov    0x8(%ebp),%edx
80106fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fbb:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106fbf:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106fc2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106fc6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106fca:	ee                   	out    %al,(%dx)
}
80106fcb:	c9                   	leave  
80106fcc:	c3                   	ret    

80106fcd <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106fcd:	55                   	push   %ebp
80106fce:	89 e5                	mov    %esp,%ebp
80106fd0:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106fd3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106fda:	00 
80106fdb:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106fe2:	e8 c8 ff ff ff       	call   80106faf <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106fe7:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106fee:	00 
80106fef:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106ff6:	e8 b4 ff ff ff       	call   80106faf <outb>
  outb(COM1+0, 115200/9600);
80106ffb:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80107002:	00 
80107003:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010700a:	e8 a0 ff ff ff       	call   80106faf <outb>
  outb(COM1+1, 0);
8010700f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107016:	00 
80107017:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010701e:	e8 8c ff ff ff       	call   80106faf <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107023:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010702a:	00 
8010702b:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107032:	e8 78 ff ff ff       	call   80106faf <outb>
  outb(COM1+4, 0);
80107037:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010703e:	00 
8010703f:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107046:	e8 64 ff ff ff       	call   80106faf <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010704b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80107052:	00 
80107053:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010705a:	e8 50 ff ff ff       	call   80106faf <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010705f:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107066:	e8 27 ff ff ff       	call   80106f92 <inb>
8010706b:	3c ff                	cmp    $0xff,%al
8010706d:	75 02                	jne    80107071 <uartinit+0xa4>
    return;
8010706f:	eb 6a                	jmp    801070db <uartinit+0x10e>
  uart = 1;
80107071:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80107078:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010707b:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107082:	e8 0b ff ff ff       	call   80106f92 <inb>
  inb(COM1+0);
80107087:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010708e:	e8 ff fe ff ff       	call   80106f92 <inb>
  picenable(IRQ_COM1);
80107093:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010709a:	e8 5b cd ff ff       	call   80103dfa <picenable>
  ioapicenable(IRQ_COM1, 0);
8010709f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801070a6:	00 
801070a7:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801070ae:	e8 f0 b8 ff ff       	call   801029a3 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801070b3:	c7 45 f4 64 90 10 80 	movl   $0x80109064,-0xc(%ebp)
801070ba:	eb 15                	jmp    801070d1 <uartinit+0x104>
    uartputc(*p);
801070bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070bf:	0f b6 00             	movzbl (%eax),%eax
801070c2:	0f be c0             	movsbl %al,%eax
801070c5:	89 04 24             	mov    %eax,(%esp)
801070c8:	e8 10 00 00 00       	call   801070dd <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801070cd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801070d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070d4:	0f b6 00             	movzbl (%eax),%eax
801070d7:	84 c0                	test   %al,%al
801070d9:	75 e1                	jne    801070bc <uartinit+0xef>
    uartputc(*p);
}
801070db:	c9                   	leave  
801070dc:	c3                   	ret    

801070dd <uartputc>:

void
uartputc(int c)
{
801070dd:	55                   	push   %ebp
801070de:	89 e5                	mov    %esp,%ebp
801070e0:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801070e3:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801070e8:	85 c0                	test   %eax,%eax
801070ea:	75 02                	jne    801070ee <uartputc+0x11>
    return;
801070ec:	eb 4b                	jmp    80107139 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801070ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801070f5:	eb 10                	jmp    80107107 <uartputc+0x2a>
    microdelay(10);
801070f7:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801070fe:	e8 38 be ff ff       	call   80102f3b <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107103:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107107:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010710b:	7f 16                	jg     80107123 <uartputc+0x46>
8010710d:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107114:	e8 79 fe ff ff       	call   80106f92 <inb>
80107119:	0f b6 c0             	movzbl %al,%eax
8010711c:	83 e0 20             	and    $0x20,%eax
8010711f:	85 c0                	test   %eax,%eax
80107121:	74 d4                	je     801070f7 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80107123:	8b 45 08             	mov    0x8(%ebp),%eax
80107126:	0f b6 c0             	movzbl %al,%eax
80107129:	89 44 24 04          	mov    %eax,0x4(%esp)
8010712d:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107134:	e8 76 fe ff ff       	call   80106faf <outb>
}
80107139:	c9                   	leave  
8010713a:	c3                   	ret    

8010713b <uartgetc>:

static int
uartgetc(void)
{
8010713b:	55                   	push   %ebp
8010713c:	89 e5                	mov    %esp,%ebp
8010713e:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80107141:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107146:	85 c0                	test   %eax,%eax
80107148:	75 07                	jne    80107151 <uartgetc+0x16>
    return -1;
8010714a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010714f:	eb 2c                	jmp    8010717d <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80107151:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107158:	e8 35 fe ff ff       	call   80106f92 <inb>
8010715d:	0f b6 c0             	movzbl %al,%eax
80107160:	83 e0 01             	and    $0x1,%eax
80107163:	85 c0                	test   %eax,%eax
80107165:	75 07                	jne    8010716e <uartgetc+0x33>
    return -1;
80107167:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010716c:	eb 0f                	jmp    8010717d <uartgetc+0x42>
  return inb(COM1+0);
8010716e:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107175:	e8 18 fe ff ff       	call   80106f92 <inb>
8010717a:	0f b6 c0             	movzbl %al,%eax
}
8010717d:	c9                   	leave  
8010717e:	c3                   	ret    

8010717f <uartintr>:

void
uartintr(void)
{
8010717f:	55                   	push   %ebp
80107180:	89 e5                	mov    %esp,%ebp
80107182:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80107185:	c7 04 24 3b 71 10 80 	movl   $0x8010713b,(%esp)
8010718c:	e8 1c 96 ff ff       	call   801007ad <consoleintr>
}
80107191:	c9                   	leave  
80107192:	c3                   	ret    

80107193 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $0
80107195:	6a 00                	push   $0x0
  jmp alltraps
80107197:	e9 62 f9 ff ff       	jmp    80106afe <alltraps>

8010719c <vector1>:
.globl vector1
vector1:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $1
8010719e:	6a 01                	push   $0x1
  jmp alltraps
801071a0:	e9 59 f9 ff ff       	jmp    80106afe <alltraps>

801071a5 <vector2>:
.globl vector2
vector2:
  pushl $0
801071a5:	6a 00                	push   $0x0
  pushl $2
801071a7:	6a 02                	push   $0x2
  jmp alltraps
801071a9:	e9 50 f9 ff ff       	jmp    80106afe <alltraps>

801071ae <vector3>:
.globl vector3
vector3:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $3
801071b0:	6a 03                	push   $0x3
  jmp alltraps
801071b2:	e9 47 f9 ff ff       	jmp    80106afe <alltraps>

801071b7 <vector4>:
.globl vector4
vector4:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $4
801071b9:	6a 04                	push   $0x4
  jmp alltraps
801071bb:	e9 3e f9 ff ff       	jmp    80106afe <alltraps>

801071c0 <vector5>:
.globl vector5
vector5:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $5
801071c2:	6a 05                	push   $0x5
  jmp alltraps
801071c4:	e9 35 f9 ff ff       	jmp    80106afe <alltraps>

801071c9 <vector6>:
.globl vector6
vector6:
  pushl $0
801071c9:	6a 00                	push   $0x0
  pushl $6
801071cb:	6a 06                	push   $0x6
  jmp alltraps
801071cd:	e9 2c f9 ff ff       	jmp    80106afe <alltraps>

801071d2 <vector7>:
.globl vector7
vector7:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $7
801071d4:	6a 07                	push   $0x7
  jmp alltraps
801071d6:	e9 23 f9 ff ff       	jmp    80106afe <alltraps>

801071db <vector8>:
.globl vector8
vector8:
  pushl $8
801071db:	6a 08                	push   $0x8
  jmp alltraps
801071dd:	e9 1c f9 ff ff       	jmp    80106afe <alltraps>

801071e2 <vector9>:
.globl vector9
vector9:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $9
801071e4:	6a 09                	push   $0x9
  jmp alltraps
801071e6:	e9 13 f9 ff ff       	jmp    80106afe <alltraps>

801071eb <vector10>:
.globl vector10
vector10:
  pushl $10
801071eb:	6a 0a                	push   $0xa
  jmp alltraps
801071ed:	e9 0c f9 ff ff       	jmp    80106afe <alltraps>

801071f2 <vector11>:
.globl vector11
vector11:
  pushl $11
801071f2:	6a 0b                	push   $0xb
  jmp alltraps
801071f4:	e9 05 f9 ff ff       	jmp    80106afe <alltraps>

801071f9 <vector12>:
.globl vector12
vector12:
  pushl $12
801071f9:	6a 0c                	push   $0xc
  jmp alltraps
801071fb:	e9 fe f8 ff ff       	jmp    80106afe <alltraps>

80107200 <vector13>:
.globl vector13
vector13:
  pushl $13
80107200:	6a 0d                	push   $0xd
  jmp alltraps
80107202:	e9 f7 f8 ff ff       	jmp    80106afe <alltraps>

80107207 <vector14>:
.globl vector14
vector14:
  pushl $14
80107207:	6a 0e                	push   $0xe
  jmp alltraps
80107209:	e9 f0 f8 ff ff       	jmp    80106afe <alltraps>

8010720e <vector15>:
.globl vector15
vector15:
  pushl $0
8010720e:	6a 00                	push   $0x0
  pushl $15
80107210:	6a 0f                	push   $0xf
  jmp alltraps
80107212:	e9 e7 f8 ff ff       	jmp    80106afe <alltraps>

80107217 <vector16>:
.globl vector16
vector16:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $16
80107219:	6a 10                	push   $0x10
  jmp alltraps
8010721b:	e9 de f8 ff ff       	jmp    80106afe <alltraps>

80107220 <vector17>:
.globl vector17
vector17:
  pushl $17
80107220:	6a 11                	push   $0x11
  jmp alltraps
80107222:	e9 d7 f8 ff ff       	jmp    80106afe <alltraps>

80107227 <vector18>:
.globl vector18
vector18:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $18
80107229:	6a 12                	push   $0x12
  jmp alltraps
8010722b:	e9 ce f8 ff ff       	jmp    80106afe <alltraps>

80107230 <vector19>:
.globl vector19
vector19:
  pushl $0
80107230:	6a 00                	push   $0x0
  pushl $19
80107232:	6a 13                	push   $0x13
  jmp alltraps
80107234:	e9 c5 f8 ff ff       	jmp    80106afe <alltraps>

80107239 <vector20>:
.globl vector20
vector20:
  pushl $0
80107239:	6a 00                	push   $0x0
  pushl $20
8010723b:	6a 14                	push   $0x14
  jmp alltraps
8010723d:	e9 bc f8 ff ff       	jmp    80106afe <alltraps>

80107242 <vector21>:
.globl vector21
vector21:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $21
80107244:	6a 15                	push   $0x15
  jmp alltraps
80107246:	e9 b3 f8 ff ff       	jmp    80106afe <alltraps>

8010724b <vector22>:
.globl vector22
vector22:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $22
8010724d:	6a 16                	push   $0x16
  jmp alltraps
8010724f:	e9 aa f8 ff ff       	jmp    80106afe <alltraps>

80107254 <vector23>:
.globl vector23
vector23:
  pushl $0
80107254:	6a 00                	push   $0x0
  pushl $23
80107256:	6a 17                	push   $0x17
  jmp alltraps
80107258:	e9 a1 f8 ff ff       	jmp    80106afe <alltraps>

8010725d <vector24>:
.globl vector24
vector24:
  pushl $0
8010725d:	6a 00                	push   $0x0
  pushl $24
8010725f:	6a 18                	push   $0x18
  jmp alltraps
80107261:	e9 98 f8 ff ff       	jmp    80106afe <alltraps>

80107266 <vector25>:
.globl vector25
vector25:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $25
80107268:	6a 19                	push   $0x19
  jmp alltraps
8010726a:	e9 8f f8 ff ff       	jmp    80106afe <alltraps>

8010726f <vector26>:
.globl vector26
vector26:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $26
80107271:	6a 1a                	push   $0x1a
  jmp alltraps
80107273:	e9 86 f8 ff ff       	jmp    80106afe <alltraps>

80107278 <vector27>:
.globl vector27
vector27:
  pushl $0
80107278:	6a 00                	push   $0x0
  pushl $27
8010727a:	6a 1b                	push   $0x1b
  jmp alltraps
8010727c:	e9 7d f8 ff ff       	jmp    80106afe <alltraps>

80107281 <vector28>:
.globl vector28
vector28:
  pushl $0
80107281:	6a 00                	push   $0x0
  pushl $28
80107283:	6a 1c                	push   $0x1c
  jmp alltraps
80107285:	e9 74 f8 ff ff       	jmp    80106afe <alltraps>

8010728a <vector29>:
.globl vector29
vector29:
  pushl $0
8010728a:	6a 00                	push   $0x0
  pushl $29
8010728c:	6a 1d                	push   $0x1d
  jmp alltraps
8010728e:	e9 6b f8 ff ff       	jmp    80106afe <alltraps>

80107293 <vector30>:
.globl vector30
vector30:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $30
80107295:	6a 1e                	push   $0x1e
  jmp alltraps
80107297:	e9 62 f8 ff ff       	jmp    80106afe <alltraps>

8010729c <vector31>:
.globl vector31
vector31:
  pushl $0
8010729c:	6a 00                	push   $0x0
  pushl $31
8010729e:	6a 1f                	push   $0x1f
  jmp alltraps
801072a0:	e9 59 f8 ff ff       	jmp    80106afe <alltraps>

801072a5 <vector32>:
.globl vector32
vector32:
  pushl $0
801072a5:	6a 00                	push   $0x0
  pushl $32
801072a7:	6a 20                	push   $0x20
  jmp alltraps
801072a9:	e9 50 f8 ff ff       	jmp    80106afe <alltraps>

801072ae <vector33>:
.globl vector33
vector33:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $33
801072b0:	6a 21                	push   $0x21
  jmp alltraps
801072b2:	e9 47 f8 ff ff       	jmp    80106afe <alltraps>

801072b7 <vector34>:
.globl vector34
vector34:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $34
801072b9:	6a 22                	push   $0x22
  jmp alltraps
801072bb:	e9 3e f8 ff ff       	jmp    80106afe <alltraps>

801072c0 <vector35>:
.globl vector35
vector35:
  pushl $0
801072c0:	6a 00                	push   $0x0
  pushl $35
801072c2:	6a 23                	push   $0x23
  jmp alltraps
801072c4:	e9 35 f8 ff ff       	jmp    80106afe <alltraps>

801072c9 <vector36>:
.globl vector36
vector36:
  pushl $0
801072c9:	6a 00                	push   $0x0
  pushl $36
801072cb:	6a 24                	push   $0x24
  jmp alltraps
801072cd:	e9 2c f8 ff ff       	jmp    80106afe <alltraps>

801072d2 <vector37>:
.globl vector37
vector37:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $37
801072d4:	6a 25                	push   $0x25
  jmp alltraps
801072d6:	e9 23 f8 ff ff       	jmp    80106afe <alltraps>

801072db <vector38>:
.globl vector38
vector38:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $38
801072dd:	6a 26                	push   $0x26
  jmp alltraps
801072df:	e9 1a f8 ff ff       	jmp    80106afe <alltraps>

801072e4 <vector39>:
.globl vector39
vector39:
  pushl $0
801072e4:	6a 00                	push   $0x0
  pushl $39
801072e6:	6a 27                	push   $0x27
  jmp alltraps
801072e8:	e9 11 f8 ff ff       	jmp    80106afe <alltraps>

801072ed <vector40>:
.globl vector40
vector40:
  pushl $0
801072ed:	6a 00                	push   $0x0
  pushl $40
801072ef:	6a 28                	push   $0x28
  jmp alltraps
801072f1:	e9 08 f8 ff ff       	jmp    80106afe <alltraps>

801072f6 <vector41>:
.globl vector41
vector41:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $41
801072f8:	6a 29                	push   $0x29
  jmp alltraps
801072fa:	e9 ff f7 ff ff       	jmp    80106afe <alltraps>

801072ff <vector42>:
.globl vector42
vector42:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $42
80107301:	6a 2a                	push   $0x2a
  jmp alltraps
80107303:	e9 f6 f7 ff ff       	jmp    80106afe <alltraps>

80107308 <vector43>:
.globl vector43
vector43:
  pushl $0
80107308:	6a 00                	push   $0x0
  pushl $43
8010730a:	6a 2b                	push   $0x2b
  jmp alltraps
8010730c:	e9 ed f7 ff ff       	jmp    80106afe <alltraps>

80107311 <vector44>:
.globl vector44
vector44:
  pushl $0
80107311:	6a 00                	push   $0x0
  pushl $44
80107313:	6a 2c                	push   $0x2c
  jmp alltraps
80107315:	e9 e4 f7 ff ff       	jmp    80106afe <alltraps>

8010731a <vector45>:
.globl vector45
vector45:
  pushl $0
8010731a:	6a 00                	push   $0x0
  pushl $45
8010731c:	6a 2d                	push   $0x2d
  jmp alltraps
8010731e:	e9 db f7 ff ff       	jmp    80106afe <alltraps>

80107323 <vector46>:
.globl vector46
vector46:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $46
80107325:	6a 2e                	push   $0x2e
  jmp alltraps
80107327:	e9 d2 f7 ff ff       	jmp    80106afe <alltraps>

8010732c <vector47>:
.globl vector47
vector47:
  pushl $0
8010732c:	6a 00                	push   $0x0
  pushl $47
8010732e:	6a 2f                	push   $0x2f
  jmp alltraps
80107330:	e9 c9 f7 ff ff       	jmp    80106afe <alltraps>

80107335 <vector48>:
.globl vector48
vector48:
  pushl $0
80107335:	6a 00                	push   $0x0
  pushl $48
80107337:	6a 30                	push   $0x30
  jmp alltraps
80107339:	e9 c0 f7 ff ff       	jmp    80106afe <alltraps>

8010733e <vector49>:
.globl vector49
vector49:
  pushl $0
8010733e:	6a 00                	push   $0x0
  pushl $49
80107340:	6a 31                	push   $0x31
  jmp alltraps
80107342:	e9 b7 f7 ff ff       	jmp    80106afe <alltraps>

80107347 <vector50>:
.globl vector50
vector50:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $50
80107349:	6a 32                	push   $0x32
  jmp alltraps
8010734b:	e9 ae f7 ff ff       	jmp    80106afe <alltraps>

80107350 <vector51>:
.globl vector51
vector51:
  pushl $0
80107350:	6a 00                	push   $0x0
  pushl $51
80107352:	6a 33                	push   $0x33
  jmp alltraps
80107354:	e9 a5 f7 ff ff       	jmp    80106afe <alltraps>

80107359 <vector52>:
.globl vector52
vector52:
  pushl $0
80107359:	6a 00                	push   $0x0
  pushl $52
8010735b:	6a 34                	push   $0x34
  jmp alltraps
8010735d:	e9 9c f7 ff ff       	jmp    80106afe <alltraps>

80107362 <vector53>:
.globl vector53
vector53:
  pushl $0
80107362:	6a 00                	push   $0x0
  pushl $53
80107364:	6a 35                	push   $0x35
  jmp alltraps
80107366:	e9 93 f7 ff ff       	jmp    80106afe <alltraps>

8010736b <vector54>:
.globl vector54
vector54:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $54
8010736d:	6a 36                	push   $0x36
  jmp alltraps
8010736f:	e9 8a f7 ff ff       	jmp    80106afe <alltraps>

80107374 <vector55>:
.globl vector55
vector55:
  pushl $0
80107374:	6a 00                	push   $0x0
  pushl $55
80107376:	6a 37                	push   $0x37
  jmp alltraps
80107378:	e9 81 f7 ff ff       	jmp    80106afe <alltraps>

8010737d <vector56>:
.globl vector56
vector56:
  pushl $0
8010737d:	6a 00                	push   $0x0
  pushl $56
8010737f:	6a 38                	push   $0x38
  jmp alltraps
80107381:	e9 78 f7 ff ff       	jmp    80106afe <alltraps>

80107386 <vector57>:
.globl vector57
vector57:
  pushl $0
80107386:	6a 00                	push   $0x0
  pushl $57
80107388:	6a 39                	push   $0x39
  jmp alltraps
8010738a:	e9 6f f7 ff ff       	jmp    80106afe <alltraps>

8010738f <vector58>:
.globl vector58
vector58:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $58
80107391:	6a 3a                	push   $0x3a
  jmp alltraps
80107393:	e9 66 f7 ff ff       	jmp    80106afe <alltraps>

80107398 <vector59>:
.globl vector59
vector59:
  pushl $0
80107398:	6a 00                	push   $0x0
  pushl $59
8010739a:	6a 3b                	push   $0x3b
  jmp alltraps
8010739c:	e9 5d f7 ff ff       	jmp    80106afe <alltraps>

801073a1 <vector60>:
.globl vector60
vector60:
  pushl $0
801073a1:	6a 00                	push   $0x0
  pushl $60
801073a3:	6a 3c                	push   $0x3c
  jmp alltraps
801073a5:	e9 54 f7 ff ff       	jmp    80106afe <alltraps>

801073aa <vector61>:
.globl vector61
vector61:
  pushl $0
801073aa:	6a 00                	push   $0x0
  pushl $61
801073ac:	6a 3d                	push   $0x3d
  jmp alltraps
801073ae:	e9 4b f7 ff ff       	jmp    80106afe <alltraps>

801073b3 <vector62>:
.globl vector62
vector62:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $62
801073b5:	6a 3e                	push   $0x3e
  jmp alltraps
801073b7:	e9 42 f7 ff ff       	jmp    80106afe <alltraps>

801073bc <vector63>:
.globl vector63
vector63:
  pushl $0
801073bc:	6a 00                	push   $0x0
  pushl $63
801073be:	6a 3f                	push   $0x3f
  jmp alltraps
801073c0:	e9 39 f7 ff ff       	jmp    80106afe <alltraps>

801073c5 <vector64>:
.globl vector64
vector64:
  pushl $0
801073c5:	6a 00                	push   $0x0
  pushl $64
801073c7:	6a 40                	push   $0x40
  jmp alltraps
801073c9:	e9 30 f7 ff ff       	jmp    80106afe <alltraps>

801073ce <vector65>:
.globl vector65
vector65:
  pushl $0
801073ce:	6a 00                	push   $0x0
  pushl $65
801073d0:	6a 41                	push   $0x41
  jmp alltraps
801073d2:	e9 27 f7 ff ff       	jmp    80106afe <alltraps>

801073d7 <vector66>:
.globl vector66
vector66:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $66
801073d9:	6a 42                	push   $0x42
  jmp alltraps
801073db:	e9 1e f7 ff ff       	jmp    80106afe <alltraps>

801073e0 <vector67>:
.globl vector67
vector67:
  pushl $0
801073e0:	6a 00                	push   $0x0
  pushl $67
801073e2:	6a 43                	push   $0x43
  jmp alltraps
801073e4:	e9 15 f7 ff ff       	jmp    80106afe <alltraps>

801073e9 <vector68>:
.globl vector68
vector68:
  pushl $0
801073e9:	6a 00                	push   $0x0
  pushl $68
801073eb:	6a 44                	push   $0x44
  jmp alltraps
801073ed:	e9 0c f7 ff ff       	jmp    80106afe <alltraps>

801073f2 <vector69>:
.globl vector69
vector69:
  pushl $0
801073f2:	6a 00                	push   $0x0
  pushl $69
801073f4:	6a 45                	push   $0x45
  jmp alltraps
801073f6:	e9 03 f7 ff ff       	jmp    80106afe <alltraps>

801073fb <vector70>:
.globl vector70
vector70:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $70
801073fd:	6a 46                	push   $0x46
  jmp alltraps
801073ff:	e9 fa f6 ff ff       	jmp    80106afe <alltraps>

80107404 <vector71>:
.globl vector71
vector71:
  pushl $0
80107404:	6a 00                	push   $0x0
  pushl $71
80107406:	6a 47                	push   $0x47
  jmp alltraps
80107408:	e9 f1 f6 ff ff       	jmp    80106afe <alltraps>

8010740d <vector72>:
.globl vector72
vector72:
  pushl $0
8010740d:	6a 00                	push   $0x0
  pushl $72
8010740f:	6a 48                	push   $0x48
  jmp alltraps
80107411:	e9 e8 f6 ff ff       	jmp    80106afe <alltraps>

80107416 <vector73>:
.globl vector73
vector73:
  pushl $0
80107416:	6a 00                	push   $0x0
  pushl $73
80107418:	6a 49                	push   $0x49
  jmp alltraps
8010741a:	e9 df f6 ff ff       	jmp    80106afe <alltraps>

8010741f <vector74>:
.globl vector74
vector74:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $74
80107421:	6a 4a                	push   $0x4a
  jmp alltraps
80107423:	e9 d6 f6 ff ff       	jmp    80106afe <alltraps>

80107428 <vector75>:
.globl vector75
vector75:
  pushl $0
80107428:	6a 00                	push   $0x0
  pushl $75
8010742a:	6a 4b                	push   $0x4b
  jmp alltraps
8010742c:	e9 cd f6 ff ff       	jmp    80106afe <alltraps>

80107431 <vector76>:
.globl vector76
vector76:
  pushl $0
80107431:	6a 00                	push   $0x0
  pushl $76
80107433:	6a 4c                	push   $0x4c
  jmp alltraps
80107435:	e9 c4 f6 ff ff       	jmp    80106afe <alltraps>

8010743a <vector77>:
.globl vector77
vector77:
  pushl $0
8010743a:	6a 00                	push   $0x0
  pushl $77
8010743c:	6a 4d                	push   $0x4d
  jmp alltraps
8010743e:	e9 bb f6 ff ff       	jmp    80106afe <alltraps>

80107443 <vector78>:
.globl vector78
vector78:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $78
80107445:	6a 4e                	push   $0x4e
  jmp alltraps
80107447:	e9 b2 f6 ff ff       	jmp    80106afe <alltraps>

8010744c <vector79>:
.globl vector79
vector79:
  pushl $0
8010744c:	6a 00                	push   $0x0
  pushl $79
8010744e:	6a 4f                	push   $0x4f
  jmp alltraps
80107450:	e9 a9 f6 ff ff       	jmp    80106afe <alltraps>

80107455 <vector80>:
.globl vector80
vector80:
  pushl $0
80107455:	6a 00                	push   $0x0
  pushl $80
80107457:	6a 50                	push   $0x50
  jmp alltraps
80107459:	e9 a0 f6 ff ff       	jmp    80106afe <alltraps>

8010745e <vector81>:
.globl vector81
vector81:
  pushl $0
8010745e:	6a 00                	push   $0x0
  pushl $81
80107460:	6a 51                	push   $0x51
  jmp alltraps
80107462:	e9 97 f6 ff ff       	jmp    80106afe <alltraps>

80107467 <vector82>:
.globl vector82
vector82:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $82
80107469:	6a 52                	push   $0x52
  jmp alltraps
8010746b:	e9 8e f6 ff ff       	jmp    80106afe <alltraps>

80107470 <vector83>:
.globl vector83
vector83:
  pushl $0
80107470:	6a 00                	push   $0x0
  pushl $83
80107472:	6a 53                	push   $0x53
  jmp alltraps
80107474:	e9 85 f6 ff ff       	jmp    80106afe <alltraps>

80107479 <vector84>:
.globl vector84
vector84:
  pushl $0
80107479:	6a 00                	push   $0x0
  pushl $84
8010747b:	6a 54                	push   $0x54
  jmp alltraps
8010747d:	e9 7c f6 ff ff       	jmp    80106afe <alltraps>

80107482 <vector85>:
.globl vector85
vector85:
  pushl $0
80107482:	6a 00                	push   $0x0
  pushl $85
80107484:	6a 55                	push   $0x55
  jmp alltraps
80107486:	e9 73 f6 ff ff       	jmp    80106afe <alltraps>

8010748b <vector86>:
.globl vector86
vector86:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $86
8010748d:	6a 56                	push   $0x56
  jmp alltraps
8010748f:	e9 6a f6 ff ff       	jmp    80106afe <alltraps>

80107494 <vector87>:
.globl vector87
vector87:
  pushl $0
80107494:	6a 00                	push   $0x0
  pushl $87
80107496:	6a 57                	push   $0x57
  jmp alltraps
80107498:	e9 61 f6 ff ff       	jmp    80106afe <alltraps>

8010749d <vector88>:
.globl vector88
vector88:
  pushl $0
8010749d:	6a 00                	push   $0x0
  pushl $88
8010749f:	6a 58                	push   $0x58
  jmp alltraps
801074a1:	e9 58 f6 ff ff       	jmp    80106afe <alltraps>

801074a6 <vector89>:
.globl vector89
vector89:
  pushl $0
801074a6:	6a 00                	push   $0x0
  pushl $89
801074a8:	6a 59                	push   $0x59
  jmp alltraps
801074aa:	e9 4f f6 ff ff       	jmp    80106afe <alltraps>

801074af <vector90>:
.globl vector90
vector90:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $90
801074b1:	6a 5a                	push   $0x5a
  jmp alltraps
801074b3:	e9 46 f6 ff ff       	jmp    80106afe <alltraps>

801074b8 <vector91>:
.globl vector91
vector91:
  pushl $0
801074b8:	6a 00                	push   $0x0
  pushl $91
801074ba:	6a 5b                	push   $0x5b
  jmp alltraps
801074bc:	e9 3d f6 ff ff       	jmp    80106afe <alltraps>

801074c1 <vector92>:
.globl vector92
vector92:
  pushl $0
801074c1:	6a 00                	push   $0x0
  pushl $92
801074c3:	6a 5c                	push   $0x5c
  jmp alltraps
801074c5:	e9 34 f6 ff ff       	jmp    80106afe <alltraps>

801074ca <vector93>:
.globl vector93
vector93:
  pushl $0
801074ca:	6a 00                	push   $0x0
  pushl $93
801074cc:	6a 5d                	push   $0x5d
  jmp alltraps
801074ce:	e9 2b f6 ff ff       	jmp    80106afe <alltraps>

801074d3 <vector94>:
.globl vector94
vector94:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $94
801074d5:	6a 5e                	push   $0x5e
  jmp alltraps
801074d7:	e9 22 f6 ff ff       	jmp    80106afe <alltraps>

801074dc <vector95>:
.globl vector95
vector95:
  pushl $0
801074dc:	6a 00                	push   $0x0
  pushl $95
801074de:	6a 5f                	push   $0x5f
  jmp alltraps
801074e0:	e9 19 f6 ff ff       	jmp    80106afe <alltraps>

801074e5 <vector96>:
.globl vector96
vector96:
  pushl $0
801074e5:	6a 00                	push   $0x0
  pushl $96
801074e7:	6a 60                	push   $0x60
  jmp alltraps
801074e9:	e9 10 f6 ff ff       	jmp    80106afe <alltraps>

801074ee <vector97>:
.globl vector97
vector97:
  pushl $0
801074ee:	6a 00                	push   $0x0
  pushl $97
801074f0:	6a 61                	push   $0x61
  jmp alltraps
801074f2:	e9 07 f6 ff ff       	jmp    80106afe <alltraps>

801074f7 <vector98>:
.globl vector98
vector98:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $98
801074f9:	6a 62                	push   $0x62
  jmp alltraps
801074fb:	e9 fe f5 ff ff       	jmp    80106afe <alltraps>

80107500 <vector99>:
.globl vector99
vector99:
  pushl $0
80107500:	6a 00                	push   $0x0
  pushl $99
80107502:	6a 63                	push   $0x63
  jmp alltraps
80107504:	e9 f5 f5 ff ff       	jmp    80106afe <alltraps>

80107509 <vector100>:
.globl vector100
vector100:
  pushl $0
80107509:	6a 00                	push   $0x0
  pushl $100
8010750b:	6a 64                	push   $0x64
  jmp alltraps
8010750d:	e9 ec f5 ff ff       	jmp    80106afe <alltraps>

80107512 <vector101>:
.globl vector101
vector101:
  pushl $0
80107512:	6a 00                	push   $0x0
  pushl $101
80107514:	6a 65                	push   $0x65
  jmp alltraps
80107516:	e9 e3 f5 ff ff       	jmp    80106afe <alltraps>

8010751b <vector102>:
.globl vector102
vector102:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $102
8010751d:	6a 66                	push   $0x66
  jmp alltraps
8010751f:	e9 da f5 ff ff       	jmp    80106afe <alltraps>

80107524 <vector103>:
.globl vector103
vector103:
  pushl $0
80107524:	6a 00                	push   $0x0
  pushl $103
80107526:	6a 67                	push   $0x67
  jmp alltraps
80107528:	e9 d1 f5 ff ff       	jmp    80106afe <alltraps>

8010752d <vector104>:
.globl vector104
vector104:
  pushl $0
8010752d:	6a 00                	push   $0x0
  pushl $104
8010752f:	6a 68                	push   $0x68
  jmp alltraps
80107531:	e9 c8 f5 ff ff       	jmp    80106afe <alltraps>

80107536 <vector105>:
.globl vector105
vector105:
  pushl $0
80107536:	6a 00                	push   $0x0
  pushl $105
80107538:	6a 69                	push   $0x69
  jmp alltraps
8010753a:	e9 bf f5 ff ff       	jmp    80106afe <alltraps>

8010753f <vector106>:
.globl vector106
vector106:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $106
80107541:	6a 6a                	push   $0x6a
  jmp alltraps
80107543:	e9 b6 f5 ff ff       	jmp    80106afe <alltraps>

80107548 <vector107>:
.globl vector107
vector107:
  pushl $0
80107548:	6a 00                	push   $0x0
  pushl $107
8010754a:	6a 6b                	push   $0x6b
  jmp alltraps
8010754c:	e9 ad f5 ff ff       	jmp    80106afe <alltraps>

80107551 <vector108>:
.globl vector108
vector108:
  pushl $0
80107551:	6a 00                	push   $0x0
  pushl $108
80107553:	6a 6c                	push   $0x6c
  jmp alltraps
80107555:	e9 a4 f5 ff ff       	jmp    80106afe <alltraps>

8010755a <vector109>:
.globl vector109
vector109:
  pushl $0
8010755a:	6a 00                	push   $0x0
  pushl $109
8010755c:	6a 6d                	push   $0x6d
  jmp alltraps
8010755e:	e9 9b f5 ff ff       	jmp    80106afe <alltraps>

80107563 <vector110>:
.globl vector110
vector110:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $110
80107565:	6a 6e                	push   $0x6e
  jmp alltraps
80107567:	e9 92 f5 ff ff       	jmp    80106afe <alltraps>

8010756c <vector111>:
.globl vector111
vector111:
  pushl $0
8010756c:	6a 00                	push   $0x0
  pushl $111
8010756e:	6a 6f                	push   $0x6f
  jmp alltraps
80107570:	e9 89 f5 ff ff       	jmp    80106afe <alltraps>

80107575 <vector112>:
.globl vector112
vector112:
  pushl $0
80107575:	6a 00                	push   $0x0
  pushl $112
80107577:	6a 70                	push   $0x70
  jmp alltraps
80107579:	e9 80 f5 ff ff       	jmp    80106afe <alltraps>

8010757e <vector113>:
.globl vector113
vector113:
  pushl $0
8010757e:	6a 00                	push   $0x0
  pushl $113
80107580:	6a 71                	push   $0x71
  jmp alltraps
80107582:	e9 77 f5 ff ff       	jmp    80106afe <alltraps>

80107587 <vector114>:
.globl vector114
vector114:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $114
80107589:	6a 72                	push   $0x72
  jmp alltraps
8010758b:	e9 6e f5 ff ff       	jmp    80106afe <alltraps>

80107590 <vector115>:
.globl vector115
vector115:
  pushl $0
80107590:	6a 00                	push   $0x0
  pushl $115
80107592:	6a 73                	push   $0x73
  jmp alltraps
80107594:	e9 65 f5 ff ff       	jmp    80106afe <alltraps>

80107599 <vector116>:
.globl vector116
vector116:
  pushl $0
80107599:	6a 00                	push   $0x0
  pushl $116
8010759b:	6a 74                	push   $0x74
  jmp alltraps
8010759d:	e9 5c f5 ff ff       	jmp    80106afe <alltraps>

801075a2 <vector117>:
.globl vector117
vector117:
  pushl $0
801075a2:	6a 00                	push   $0x0
  pushl $117
801075a4:	6a 75                	push   $0x75
  jmp alltraps
801075a6:	e9 53 f5 ff ff       	jmp    80106afe <alltraps>

801075ab <vector118>:
.globl vector118
vector118:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $118
801075ad:	6a 76                	push   $0x76
  jmp alltraps
801075af:	e9 4a f5 ff ff       	jmp    80106afe <alltraps>

801075b4 <vector119>:
.globl vector119
vector119:
  pushl $0
801075b4:	6a 00                	push   $0x0
  pushl $119
801075b6:	6a 77                	push   $0x77
  jmp alltraps
801075b8:	e9 41 f5 ff ff       	jmp    80106afe <alltraps>

801075bd <vector120>:
.globl vector120
vector120:
  pushl $0
801075bd:	6a 00                	push   $0x0
  pushl $120
801075bf:	6a 78                	push   $0x78
  jmp alltraps
801075c1:	e9 38 f5 ff ff       	jmp    80106afe <alltraps>

801075c6 <vector121>:
.globl vector121
vector121:
  pushl $0
801075c6:	6a 00                	push   $0x0
  pushl $121
801075c8:	6a 79                	push   $0x79
  jmp alltraps
801075ca:	e9 2f f5 ff ff       	jmp    80106afe <alltraps>

801075cf <vector122>:
.globl vector122
vector122:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $122
801075d1:	6a 7a                	push   $0x7a
  jmp alltraps
801075d3:	e9 26 f5 ff ff       	jmp    80106afe <alltraps>

801075d8 <vector123>:
.globl vector123
vector123:
  pushl $0
801075d8:	6a 00                	push   $0x0
  pushl $123
801075da:	6a 7b                	push   $0x7b
  jmp alltraps
801075dc:	e9 1d f5 ff ff       	jmp    80106afe <alltraps>

801075e1 <vector124>:
.globl vector124
vector124:
  pushl $0
801075e1:	6a 00                	push   $0x0
  pushl $124
801075e3:	6a 7c                	push   $0x7c
  jmp alltraps
801075e5:	e9 14 f5 ff ff       	jmp    80106afe <alltraps>

801075ea <vector125>:
.globl vector125
vector125:
  pushl $0
801075ea:	6a 00                	push   $0x0
  pushl $125
801075ec:	6a 7d                	push   $0x7d
  jmp alltraps
801075ee:	e9 0b f5 ff ff       	jmp    80106afe <alltraps>

801075f3 <vector126>:
.globl vector126
vector126:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $126
801075f5:	6a 7e                	push   $0x7e
  jmp alltraps
801075f7:	e9 02 f5 ff ff       	jmp    80106afe <alltraps>

801075fc <vector127>:
.globl vector127
vector127:
  pushl $0
801075fc:	6a 00                	push   $0x0
  pushl $127
801075fe:	6a 7f                	push   $0x7f
  jmp alltraps
80107600:	e9 f9 f4 ff ff       	jmp    80106afe <alltraps>

80107605 <vector128>:
.globl vector128
vector128:
  pushl $0
80107605:	6a 00                	push   $0x0
  pushl $128
80107607:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010760c:	e9 ed f4 ff ff       	jmp    80106afe <alltraps>

80107611 <vector129>:
.globl vector129
vector129:
  pushl $0
80107611:	6a 00                	push   $0x0
  pushl $129
80107613:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107618:	e9 e1 f4 ff ff       	jmp    80106afe <alltraps>

8010761d <vector130>:
.globl vector130
vector130:
  pushl $0
8010761d:	6a 00                	push   $0x0
  pushl $130
8010761f:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107624:	e9 d5 f4 ff ff       	jmp    80106afe <alltraps>

80107629 <vector131>:
.globl vector131
vector131:
  pushl $0
80107629:	6a 00                	push   $0x0
  pushl $131
8010762b:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107630:	e9 c9 f4 ff ff       	jmp    80106afe <alltraps>

80107635 <vector132>:
.globl vector132
vector132:
  pushl $0
80107635:	6a 00                	push   $0x0
  pushl $132
80107637:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010763c:	e9 bd f4 ff ff       	jmp    80106afe <alltraps>

80107641 <vector133>:
.globl vector133
vector133:
  pushl $0
80107641:	6a 00                	push   $0x0
  pushl $133
80107643:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107648:	e9 b1 f4 ff ff       	jmp    80106afe <alltraps>

8010764d <vector134>:
.globl vector134
vector134:
  pushl $0
8010764d:	6a 00                	push   $0x0
  pushl $134
8010764f:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107654:	e9 a5 f4 ff ff       	jmp    80106afe <alltraps>

80107659 <vector135>:
.globl vector135
vector135:
  pushl $0
80107659:	6a 00                	push   $0x0
  pushl $135
8010765b:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107660:	e9 99 f4 ff ff       	jmp    80106afe <alltraps>

80107665 <vector136>:
.globl vector136
vector136:
  pushl $0
80107665:	6a 00                	push   $0x0
  pushl $136
80107667:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010766c:	e9 8d f4 ff ff       	jmp    80106afe <alltraps>

80107671 <vector137>:
.globl vector137
vector137:
  pushl $0
80107671:	6a 00                	push   $0x0
  pushl $137
80107673:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107678:	e9 81 f4 ff ff       	jmp    80106afe <alltraps>

8010767d <vector138>:
.globl vector138
vector138:
  pushl $0
8010767d:	6a 00                	push   $0x0
  pushl $138
8010767f:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107684:	e9 75 f4 ff ff       	jmp    80106afe <alltraps>

80107689 <vector139>:
.globl vector139
vector139:
  pushl $0
80107689:	6a 00                	push   $0x0
  pushl $139
8010768b:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107690:	e9 69 f4 ff ff       	jmp    80106afe <alltraps>

80107695 <vector140>:
.globl vector140
vector140:
  pushl $0
80107695:	6a 00                	push   $0x0
  pushl $140
80107697:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010769c:	e9 5d f4 ff ff       	jmp    80106afe <alltraps>

801076a1 <vector141>:
.globl vector141
vector141:
  pushl $0
801076a1:	6a 00                	push   $0x0
  pushl $141
801076a3:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801076a8:	e9 51 f4 ff ff       	jmp    80106afe <alltraps>

801076ad <vector142>:
.globl vector142
vector142:
  pushl $0
801076ad:	6a 00                	push   $0x0
  pushl $142
801076af:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801076b4:	e9 45 f4 ff ff       	jmp    80106afe <alltraps>

801076b9 <vector143>:
.globl vector143
vector143:
  pushl $0
801076b9:	6a 00                	push   $0x0
  pushl $143
801076bb:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801076c0:	e9 39 f4 ff ff       	jmp    80106afe <alltraps>

801076c5 <vector144>:
.globl vector144
vector144:
  pushl $0
801076c5:	6a 00                	push   $0x0
  pushl $144
801076c7:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801076cc:	e9 2d f4 ff ff       	jmp    80106afe <alltraps>

801076d1 <vector145>:
.globl vector145
vector145:
  pushl $0
801076d1:	6a 00                	push   $0x0
  pushl $145
801076d3:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801076d8:	e9 21 f4 ff ff       	jmp    80106afe <alltraps>

801076dd <vector146>:
.globl vector146
vector146:
  pushl $0
801076dd:	6a 00                	push   $0x0
  pushl $146
801076df:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801076e4:	e9 15 f4 ff ff       	jmp    80106afe <alltraps>

801076e9 <vector147>:
.globl vector147
vector147:
  pushl $0
801076e9:	6a 00                	push   $0x0
  pushl $147
801076eb:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801076f0:	e9 09 f4 ff ff       	jmp    80106afe <alltraps>

801076f5 <vector148>:
.globl vector148
vector148:
  pushl $0
801076f5:	6a 00                	push   $0x0
  pushl $148
801076f7:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801076fc:	e9 fd f3 ff ff       	jmp    80106afe <alltraps>

80107701 <vector149>:
.globl vector149
vector149:
  pushl $0
80107701:	6a 00                	push   $0x0
  pushl $149
80107703:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107708:	e9 f1 f3 ff ff       	jmp    80106afe <alltraps>

8010770d <vector150>:
.globl vector150
vector150:
  pushl $0
8010770d:	6a 00                	push   $0x0
  pushl $150
8010770f:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107714:	e9 e5 f3 ff ff       	jmp    80106afe <alltraps>

80107719 <vector151>:
.globl vector151
vector151:
  pushl $0
80107719:	6a 00                	push   $0x0
  pushl $151
8010771b:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107720:	e9 d9 f3 ff ff       	jmp    80106afe <alltraps>

80107725 <vector152>:
.globl vector152
vector152:
  pushl $0
80107725:	6a 00                	push   $0x0
  pushl $152
80107727:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010772c:	e9 cd f3 ff ff       	jmp    80106afe <alltraps>

80107731 <vector153>:
.globl vector153
vector153:
  pushl $0
80107731:	6a 00                	push   $0x0
  pushl $153
80107733:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107738:	e9 c1 f3 ff ff       	jmp    80106afe <alltraps>

8010773d <vector154>:
.globl vector154
vector154:
  pushl $0
8010773d:	6a 00                	push   $0x0
  pushl $154
8010773f:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107744:	e9 b5 f3 ff ff       	jmp    80106afe <alltraps>

80107749 <vector155>:
.globl vector155
vector155:
  pushl $0
80107749:	6a 00                	push   $0x0
  pushl $155
8010774b:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107750:	e9 a9 f3 ff ff       	jmp    80106afe <alltraps>

80107755 <vector156>:
.globl vector156
vector156:
  pushl $0
80107755:	6a 00                	push   $0x0
  pushl $156
80107757:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010775c:	e9 9d f3 ff ff       	jmp    80106afe <alltraps>

80107761 <vector157>:
.globl vector157
vector157:
  pushl $0
80107761:	6a 00                	push   $0x0
  pushl $157
80107763:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107768:	e9 91 f3 ff ff       	jmp    80106afe <alltraps>

8010776d <vector158>:
.globl vector158
vector158:
  pushl $0
8010776d:	6a 00                	push   $0x0
  pushl $158
8010776f:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107774:	e9 85 f3 ff ff       	jmp    80106afe <alltraps>

80107779 <vector159>:
.globl vector159
vector159:
  pushl $0
80107779:	6a 00                	push   $0x0
  pushl $159
8010777b:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107780:	e9 79 f3 ff ff       	jmp    80106afe <alltraps>

80107785 <vector160>:
.globl vector160
vector160:
  pushl $0
80107785:	6a 00                	push   $0x0
  pushl $160
80107787:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010778c:	e9 6d f3 ff ff       	jmp    80106afe <alltraps>

80107791 <vector161>:
.globl vector161
vector161:
  pushl $0
80107791:	6a 00                	push   $0x0
  pushl $161
80107793:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107798:	e9 61 f3 ff ff       	jmp    80106afe <alltraps>

8010779d <vector162>:
.globl vector162
vector162:
  pushl $0
8010779d:	6a 00                	push   $0x0
  pushl $162
8010779f:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801077a4:	e9 55 f3 ff ff       	jmp    80106afe <alltraps>

801077a9 <vector163>:
.globl vector163
vector163:
  pushl $0
801077a9:	6a 00                	push   $0x0
  pushl $163
801077ab:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801077b0:	e9 49 f3 ff ff       	jmp    80106afe <alltraps>

801077b5 <vector164>:
.globl vector164
vector164:
  pushl $0
801077b5:	6a 00                	push   $0x0
  pushl $164
801077b7:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801077bc:	e9 3d f3 ff ff       	jmp    80106afe <alltraps>

801077c1 <vector165>:
.globl vector165
vector165:
  pushl $0
801077c1:	6a 00                	push   $0x0
  pushl $165
801077c3:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801077c8:	e9 31 f3 ff ff       	jmp    80106afe <alltraps>

801077cd <vector166>:
.globl vector166
vector166:
  pushl $0
801077cd:	6a 00                	push   $0x0
  pushl $166
801077cf:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801077d4:	e9 25 f3 ff ff       	jmp    80106afe <alltraps>

801077d9 <vector167>:
.globl vector167
vector167:
  pushl $0
801077d9:	6a 00                	push   $0x0
  pushl $167
801077db:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801077e0:	e9 19 f3 ff ff       	jmp    80106afe <alltraps>

801077e5 <vector168>:
.globl vector168
vector168:
  pushl $0
801077e5:	6a 00                	push   $0x0
  pushl $168
801077e7:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801077ec:	e9 0d f3 ff ff       	jmp    80106afe <alltraps>

801077f1 <vector169>:
.globl vector169
vector169:
  pushl $0
801077f1:	6a 00                	push   $0x0
  pushl $169
801077f3:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801077f8:	e9 01 f3 ff ff       	jmp    80106afe <alltraps>

801077fd <vector170>:
.globl vector170
vector170:
  pushl $0
801077fd:	6a 00                	push   $0x0
  pushl $170
801077ff:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107804:	e9 f5 f2 ff ff       	jmp    80106afe <alltraps>

80107809 <vector171>:
.globl vector171
vector171:
  pushl $0
80107809:	6a 00                	push   $0x0
  pushl $171
8010780b:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107810:	e9 e9 f2 ff ff       	jmp    80106afe <alltraps>

80107815 <vector172>:
.globl vector172
vector172:
  pushl $0
80107815:	6a 00                	push   $0x0
  pushl $172
80107817:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010781c:	e9 dd f2 ff ff       	jmp    80106afe <alltraps>

80107821 <vector173>:
.globl vector173
vector173:
  pushl $0
80107821:	6a 00                	push   $0x0
  pushl $173
80107823:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107828:	e9 d1 f2 ff ff       	jmp    80106afe <alltraps>

8010782d <vector174>:
.globl vector174
vector174:
  pushl $0
8010782d:	6a 00                	push   $0x0
  pushl $174
8010782f:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107834:	e9 c5 f2 ff ff       	jmp    80106afe <alltraps>

80107839 <vector175>:
.globl vector175
vector175:
  pushl $0
80107839:	6a 00                	push   $0x0
  pushl $175
8010783b:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107840:	e9 b9 f2 ff ff       	jmp    80106afe <alltraps>

80107845 <vector176>:
.globl vector176
vector176:
  pushl $0
80107845:	6a 00                	push   $0x0
  pushl $176
80107847:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010784c:	e9 ad f2 ff ff       	jmp    80106afe <alltraps>

80107851 <vector177>:
.globl vector177
vector177:
  pushl $0
80107851:	6a 00                	push   $0x0
  pushl $177
80107853:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107858:	e9 a1 f2 ff ff       	jmp    80106afe <alltraps>

8010785d <vector178>:
.globl vector178
vector178:
  pushl $0
8010785d:	6a 00                	push   $0x0
  pushl $178
8010785f:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107864:	e9 95 f2 ff ff       	jmp    80106afe <alltraps>

80107869 <vector179>:
.globl vector179
vector179:
  pushl $0
80107869:	6a 00                	push   $0x0
  pushl $179
8010786b:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107870:	e9 89 f2 ff ff       	jmp    80106afe <alltraps>

80107875 <vector180>:
.globl vector180
vector180:
  pushl $0
80107875:	6a 00                	push   $0x0
  pushl $180
80107877:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010787c:	e9 7d f2 ff ff       	jmp    80106afe <alltraps>

80107881 <vector181>:
.globl vector181
vector181:
  pushl $0
80107881:	6a 00                	push   $0x0
  pushl $181
80107883:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107888:	e9 71 f2 ff ff       	jmp    80106afe <alltraps>

8010788d <vector182>:
.globl vector182
vector182:
  pushl $0
8010788d:	6a 00                	push   $0x0
  pushl $182
8010788f:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107894:	e9 65 f2 ff ff       	jmp    80106afe <alltraps>

80107899 <vector183>:
.globl vector183
vector183:
  pushl $0
80107899:	6a 00                	push   $0x0
  pushl $183
8010789b:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801078a0:	e9 59 f2 ff ff       	jmp    80106afe <alltraps>

801078a5 <vector184>:
.globl vector184
vector184:
  pushl $0
801078a5:	6a 00                	push   $0x0
  pushl $184
801078a7:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801078ac:	e9 4d f2 ff ff       	jmp    80106afe <alltraps>

801078b1 <vector185>:
.globl vector185
vector185:
  pushl $0
801078b1:	6a 00                	push   $0x0
  pushl $185
801078b3:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801078b8:	e9 41 f2 ff ff       	jmp    80106afe <alltraps>

801078bd <vector186>:
.globl vector186
vector186:
  pushl $0
801078bd:	6a 00                	push   $0x0
  pushl $186
801078bf:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801078c4:	e9 35 f2 ff ff       	jmp    80106afe <alltraps>

801078c9 <vector187>:
.globl vector187
vector187:
  pushl $0
801078c9:	6a 00                	push   $0x0
  pushl $187
801078cb:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801078d0:	e9 29 f2 ff ff       	jmp    80106afe <alltraps>

801078d5 <vector188>:
.globl vector188
vector188:
  pushl $0
801078d5:	6a 00                	push   $0x0
  pushl $188
801078d7:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801078dc:	e9 1d f2 ff ff       	jmp    80106afe <alltraps>

801078e1 <vector189>:
.globl vector189
vector189:
  pushl $0
801078e1:	6a 00                	push   $0x0
  pushl $189
801078e3:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801078e8:	e9 11 f2 ff ff       	jmp    80106afe <alltraps>

801078ed <vector190>:
.globl vector190
vector190:
  pushl $0
801078ed:	6a 00                	push   $0x0
  pushl $190
801078ef:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801078f4:	e9 05 f2 ff ff       	jmp    80106afe <alltraps>

801078f9 <vector191>:
.globl vector191
vector191:
  pushl $0
801078f9:	6a 00                	push   $0x0
  pushl $191
801078fb:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107900:	e9 f9 f1 ff ff       	jmp    80106afe <alltraps>

80107905 <vector192>:
.globl vector192
vector192:
  pushl $0
80107905:	6a 00                	push   $0x0
  pushl $192
80107907:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010790c:	e9 ed f1 ff ff       	jmp    80106afe <alltraps>

80107911 <vector193>:
.globl vector193
vector193:
  pushl $0
80107911:	6a 00                	push   $0x0
  pushl $193
80107913:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107918:	e9 e1 f1 ff ff       	jmp    80106afe <alltraps>

8010791d <vector194>:
.globl vector194
vector194:
  pushl $0
8010791d:	6a 00                	push   $0x0
  pushl $194
8010791f:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107924:	e9 d5 f1 ff ff       	jmp    80106afe <alltraps>

80107929 <vector195>:
.globl vector195
vector195:
  pushl $0
80107929:	6a 00                	push   $0x0
  pushl $195
8010792b:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107930:	e9 c9 f1 ff ff       	jmp    80106afe <alltraps>

80107935 <vector196>:
.globl vector196
vector196:
  pushl $0
80107935:	6a 00                	push   $0x0
  pushl $196
80107937:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010793c:	e9 bd f1 ff ff       	jmp    80106afe <alltraps>

80107941 <vector197>:
.globl vector197
vector197:
  pushl $0
80107941:	6a 00                	push   $0x0
  pushl $197
80107943:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107948:	e9 b1 f1 ff ff       	jmp    80106afe <alltraps>

8010794d <vector198>:
.globl vector198
vector198:
  pushl $0
8010794d:	6a 00                	push   $0x0
  pushl $198
8010794f:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107954:	e9 a5 f1 ff ff       	jmp    80106afe <alltraps>

80107959 <vector199>:
.globl vector199
vector199:
  pushl $0
80107959:	6a 00                	push   $0x0
  pushl $199
8010795b:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107960:	e9 99 f1 ff ff       	jmp    80106afe <alltraps>

80107965 <vector200>:
.globl vector200
vector200:
  pushl $0
80107965:	6a 00                	push   $0x0
  pushl $200
80107967:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010796c:	e9 8d f1 ff ff       	jmp    80106afe <alltraps>

80107971 <vector201>:
.globl vector201
vector201:
  pushl $0
80107971:	6a 00                	push   $0x0
  pushl $201
80107973:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107978:	e9 81 f1 ff ff       	jmp    80106afe <alltraps>

8010797d <vector202>:
.globl vector202
vector202:
  pushl $0
8010797d:	6a 00                	push   $0x0
  pushl $202
8010797f:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107984:	e9 75 f1 ff ff       	jmp    80106afe <alltraps>

80107989 <vector203>:
.globl vector203
vector203:
  pushl $0
80107989:	6a 00                	push   $0x0
  pushl $203
8010798b:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107990:	e9 69 f1 ff ff       	jmp    80106afe <alltraps>

80107995 <vector204>:
.globl vector204
vector204:
  pushl $0
80107995:	6a 00                	push   $0x0
  pushl $204
80107997:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010799c:	e9 5d f1 ff ff       	jmp    80106afe <alltraps>

801079a1 <vector205>:
.globl vector205
vector205:
  pushl $0
801079a1:	6a 00                	push   $0x0
  pushl $205
801079a3:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801079a8:	e9 51 f1 ff ff       	jmp    80106afe <alltraps>

801079ad <vector206>:
.globl vector206
vector206:
  pushl $0
801079ad:	6a 00                	push   $0x0
  pushl $206
801079af:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801079b4:	e9 45 f1 ff ff       	jmp    80106afe <alltraps>

801079b9 <vector207>:
.globl vector207
vector207:
  pushl $0
801079b9:	6a 00                	push   $0x0
  pushl $207
801079bb:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801079c0:	e9 39 f1 ff ff       	jmp    80106afe <alltraps>

801079c5 <vector208>:
.globl vector208
vector208:
  pushl $0
801079c5:	6a 00                	push   $0x0
  pushl $208
801079c7:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801079cc:	e9 2d f1 ff ff       	jmp    80106afe <alltraps>

801079d1 <vector209>:
.globl vector209
vector209:
  pushl $0
801079d1:	6a 00                	push   $0x0
  pushl $209
801079d3:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801079d8:	e9 21 f1 ff ff       	jmp    80106afe <alltraps>

801079dd <vector210>:
.globl vector210
vector210:
  pushl $0
801079dd:	6a 00                	push   $0x0
  pushl $210
801079df:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801079e4:	e9 15 f1 ff ff       	jmp    80106afe <alltraps>

801079e9 <vector211>:
.globl vector211
vector211:
  pushl $0
801079e9:	6a 00                	push   $0x0
  pushl $211
801079eb:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801079f0:	e9 09 f1 ff ff       	jmp    80106afe <alltraps>

801079f5 <vector212>:
.globl vector212
vector212:
  pushl $0
801079f5:	6a 00                	push   $0x0
  pushl $212
801079f7:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801079fc:	e9 fd f0 ff ff       	jmp    80106afe <alltraps>

80107a01 <vector213>:
.globl vector213
vector213:
  pushl $0
80107a01:	6a 00                	push   $0x0
  pushl $213
80107a03:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107a08:	e9 f1 f0 ff ff       	jmp    80106afe <alltraps>

80107a0d <vector214>:
.globl vector214
vector214:
  pushl $0
80107a0d:	6a 00                	push   $0x0
  pushl $214
80107a0f:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107a14:	e9 e5 f0 ff ff       	jmp    80106afe <alltraps>

80107a19 <vector215>:
.globl vector215
vector215:
  pushl $0
80107a19:	6a 00                	push   $0x0
  pushl $215
80107a1b:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107a20:	e9 d9 f0 ff ff       	jmp    80106afe <alltraps>

80107a25 <vector216>:
.globl vector216
vector216:
  pushl $0
80107a25:	6a 00                	push   $0x0
  pushl $216
80107a27:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107a2c:	e9 cd f0 ff ff       	jmp    80106afe <alltraps>

80107a31 <vector217>:
.globl vector217
vector217:
  pushl $0
80107a31:	6a 00                	push   $0x0
  pushl $217
80107a33:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107a38:	e9 c1 f0 ff ff       	jmp    80106afe <alltraps>

80107a3d <vector218>:
.globl vector218
vector218:
  pushl $0
80107a3d:	6a 00                	push   $0x0
  pushl $218
80107a3f:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107a44:	e9 b5 f0 ff ff       	jmp    80106afe <alltraps>

80107a49 <vector219>:
.globl vector219
vector219:
  pushl $0
80107a49:	6a 00                	push   $0x0
  pushl $219
80107a4b:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107a50:	e9 a9 f0 ff ff       	jmp    80106afe <alltraps>

80107a55 <vector220>:
.globl vector220
vector220:
  pushl $0
80107a55:	6a 00                	push   $0x0
  pushl $220
80107a57:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107a5c:	e9 9d f0 ff ff       	jmp    80106afe <alltraps>

80107a61 <vector221>:
.globl vector221
vector221:
  pushl $0
80107a61:	6a 00                	push   $0x0
  pushl $221
80107a63:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107a68:	e9 91 f0 ff ff       	jmp    80106afe <alltraps>

80107a6d <vector222>:
.globl vector222
vector222:
  pushl $0
80107a6d:	6a 00                	push   $0x0
  pushl $222
80107a6f:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107a74:	e9 85 f0 ff ff       	jmp    80106afe <alltraps>

80107a79 <vector223>:
.globl vector223
vector223:
  pushl $0
80107a79:	6a 00                	push   $0x0
  pushl $223
80107a7b:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107a80:	e9 79 f0 ff ff       	jmp    80106afe <alltraps>

80107a85 <vector224>:
.globl vector224
vector224:
  pushl $0
80107a85:	6a 00                	push   $0x0
  pushl $224
80107a87:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107a8c:	e9 6d f0 ff ff       	jmp    80106afe <alltraps>

80107a91 <vector225>:
.globl vector225
vector225:
  pushl $0
80107a91:	6a 00                	push   $0x0
  pushl $225
80107a93:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107a98:	e9 61 f0 ff ff       	jmp    80106afe <alltraps>

80107a9d <vector226>:
.globl vector226
vector226:
  pushl $0
80107a9d:	6a 00                	push   $0x0
  pushl $226
80107a9f:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107aa4:	e9 55 f0 ff ff       	jmp    80106afe <alltraps>

80107aa9 <vector227>:
.globl vector227
vector227:
  pushl $0
80107aa9:	6a 00                	push   $0x0
  pushl $227
80107aab:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107ab0:	e9 49 f0 ff ff       	jmp    80106afe <alltraps>

80107ab5 <vector228>:
.globl vector228
vector228:
  pushl $0
80107ab5:	6a 00                	push   $0x0
  pushl $228
80107ab7:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107abc:	e9 3d f0 ff ff       	jmp    80106afe <alltraps>

80107ac1 <vector229>:
.globl vector229
vector229:
  pushl $0
80107ac1:	6a 00                	push   $0x0
  pushl $229
80107ac3:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107ac8:	e9 31 f0 ff ff       	jmp    80106afe <alltraps>

80107acd <vector230>:
.globl vector230
vector230:
  pushl $0
80107acd:	6a 00                	push   $0x0
  pushl $230
80107acf:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107ad4:	e9 25 f0 ff ff       	jmp    80106afe <alltraps>

80107ad9 <vector231>:
.globl vector231
vector231:
  pushl $0
80107ad9:	6a 00                	push   $0x0
  pushl $231
80107adb:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107ae0:	e9 19 f0 ff ff       	jmp    80106afe <alltraps>

80107ae5 <vector232>:
.globl vector232
vector232:
  pushl $0
80107ae5:	6a 00                	push   $0x0
  pushl $232
80107ae7:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107aec:	e9 0d f0 ff ff       	jmp    80106afe <alltraps>

80107af1 <vector233>:
.globl vector233
vector233:
  pushl $0
80107af1:	6a 00                	push   $0x0
  pushl $233
80107af3:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107af8:	e9 01 f0 ff ff       	jmp    80106afe <alltraps>

80107afd <vector234>:
.globl vector234
vector234:
  pushl $0
80107afd:	6a 00                	push   $0x0
  pushl $234
80107aff:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107b04:	e9 f5 ef ff ff       	jmp    80106afe <alltraps>

80107b09 <vector235>:
.globl vector235
vector235:
  pushl $0
80107b09:	6a 00                	push   $0x0
  pushl $235
80107b0b:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107b10:	e9 e9 ef ff ff       	jmp    80106afe <alltraps>

80107b15 <vector236>:
.globl vector236
vector236:
  pushl $0
80107b15:	6a 00                	push   $0x0
  pushl $236
80107b17:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107b1c:	e9 dd ef ff ff       	jmp    80106afe <alltraps>

80107b21 <vector237>:
.globl vector237
vector237:
  pushl $0
80107b21:	6a 00                	push   $0x0
  pushl $237
80107b23:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107b28:	e9 d1 ef ff ff       	jmp    80106afe <alltraps>

80107b2d <vector238>:
.globl vector238
vector238:
  pushl $0
80107b2d:	6a 00                	push   $0x0
  pushl $238
80107b2f:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107b34:	e9 c5 ef ff ff       	jmp    80106afe <alltraps>

80107b39 <vector239>:
.globl vector239
vector239:
  pushl $0
80107b39:	6a 00                	push   $0x0
  pushl $239
80107b3b:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107b40:	e9 b9 ef ff ff       	jmp    80106afe <alltraps>

80107b45 <vector240>:
.globl vector240
vector240:
  pushl $0
80107b45:	6a 00                	push   $0x0
  pushl $240
80107b47:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107b4c:	e9 ad ef ff ff       	jmp    80106afe <alltraps>

80107b51 <vector241>:
.globl vector241
vector241:
  pushl $0
80107b51:	6a 00                	push   $0x0
  pushl $241
80107b53:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107b58:	e9 a1 ef ff ff       	jmp    80106afe <alltraps>

80107b5d <vector242>:
.globl vector242
vector242:
  pushl $0
80107b5d:	6a 00                	push   $0x0
  pushl $242
80107b5f:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107b64:	e9 95 ef ff ff       	jmp    80106afe <alltraps>

80107b69 <vector243>:
.globl vector243
vector243:
  pushl $0
80107b69:	6a 00                	push   $0x0
  pushl $243
80107b6b:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107b70:	e9 89 ef ff ff       	jmp    80106afe <alltraps>

80107b75 <vector244>:
.globl vector244
vector244:
  pushl $0
80107b75:	6a 00                	push   $0x0
  pushl $244
80107b77:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107b7c:	e9 7d ef ff ff       	jmp    80106afe <alltraps>

80107b81 <vector245>:
.globl vector245
vector245:
  pushl $0
80107b81:	6a 00                	push   $0x0
  pushl $245
80107b83:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107b88:	e9 71 ef ff ff       	jmp    80106afe <alltraps>

80107b8d <vector246>:
.globl vector246
vector246:
  pushl $0
80107b8d:	6a 00                	push   $0x0
  pushl $246
80107b8f:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107b94:	e9 65 ef ff ff       	jmp    80106afe <alltraps>

80107b99 <vector247>:
.globl vector247
vector247:
  pushl $0
80107b99:	6a 00                	push   $0x0
  pushl $247
80107b9b:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107ba0:	e9 59 ef ff ff       	jmp    80106afe <alltraps>

80107ba5 <vector248>:
.globl vector248
vector248:
  pushl $0
80107ba5:	6a 00                	push   $0x0
  pushl $248
80107ba7:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107bac:	e9 4d ef ff ff       	jmp    80106afe <alltraps>

80107bb1 <vector249>:
.globl vector249
vector249:
  pushl $0
80107bb1:	6a 00                	push   $0x0
  pushl $249
80107bb3:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107bb8:	e9 41 ef ff ff       	jmp    80106afe <alltraps>

80107bbd <vector250>:
.globl vector250
vector250:
  pushl $0
80107bbd:	6a 00                	push   $0x0
  pushl $250
80107bbf:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107bc4:	e9 35 ef ff ff       	jmp    80106afe <alltraps>

80107bc9 <vector251>:
.globl vector251
vector251:
  pushl $0
80107bc9:	6a 00                	push   $0x0
  pushl $251
80107bcb:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107bd0:	e9 29 ef ff ff       	jmp    80106afe <alltraps>

80107bd5 <vector252>:
.globl vector252
vector252:
  pushl $0
80107bd5:	6a 00                	push   $0x0
  pushl $252
80107bd7:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107bdc:	e9 1d ef ff ff       	jmp    80106afe <alltraps>

80107be1 <vector253>:
.globl vector253
vector253:
  pushl $0
80107be1:	6a 00                	push   $0x0
  pushl $253
80107be3:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107be8:	e9 11 ef ff ff       	jmp    80106afe <alltraps>

80107bed <vector254>:
.globl vector254
vector254:
  pushl $0
80107bed:	6a 00                	push   $0x0
  pushl $254
80107bef:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107bf4:	e9 05 ef ff ff       	jmp    80106afe <alltraps>

80107bf9 <vector255>:
.globl vector255
vector255:
  pushl $0
80107bf9:	6a 00                	push   $0x0
  pushl $255
80107bfb:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107c00:	e9 f9 ee ff ff       	jmp    80106afe <alltraps>

80107c05 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107c05:	55                   	push   %ebp
80107c06:	89 e5                	mov    %esp,%ebp
80107c08:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c0e:	83 e8 01             	sub    $0x1,%eax
80107c11:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107c15:	8b 45 08             	mov    0x8(%ebp),%eax
80107c18:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80107c1f:	c1 e8 10             	shr    $0x10,%eax
80107c22:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107c26:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107c29:	0f 01 10             	lgdtl  (%eax)
}
80107c2c:	c9                   	leave  
80107c2d:	c3                   	ret    

80107c2e <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107c2e:	55                   	push   %ebp
80107c2f:	89 e5                	mov    %esp,%ebp
80107c31:	83 ec 04             	sub    $0x4,%esp
80107c34:	8b 45 08             	mov    0x8(%ebp),%eax
80107c37:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107c3b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107c3f:	0f 00 d8             	ltr    %ax
}
80107c42:	c9                   	leave  
80107c43:	c3                   	ret    

80107c44 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107c44:	55                   	push   %ebp
80107c45:	89 e5                	mov    %esp,%ebp
80107c47:	83 ec 04             	sub    $0x4,%esp
80107c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80107c4d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107c51:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107c55:	8e e8                	mov    %eax,%gs
}
80107c57:	c9                   	leave  
80107c58:	c3                   	ret    

80107c59 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107c59:	55                   	push   %ebp
80107c5a:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80107c5f:	0f 22 d8             	mov    %eax,%cr3
}
80107c62:	5d                   	pop    %ebp
80107c63:	c3                   	ret    

80107c64 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107c64:	55                   	push   %ebp
80107c65:	89 e5                	mov    %esp,%ebp
80107c67:	8b 45 08             	mov    0x8(%ebp),%eax
80107c6a:	05 00 00 00 80       	add    $0x80000000,%eax
80107c6f:	5d                   	pop    %ebp
80107c70:	c3                   	ret    

80107c71 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107c71:	55                   	push   %ebp
80107c72:	89 e5                	mov    %esp,%ebp
80107c74:	8b 45 08             	mov    0x8(%ebp),%eax
80107c77:	05 00 00 00 80       	add    $0x80000000,%eax
80107c7c:	5d                   	pop    %ebp
80107c7d:	c3                   	ret    

80107c7e <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107c7e:	55                   	push   %ebp
80107c7f:	89 e5                	mov    %esp,%ebp
80107c81:	53                   	push   %ebx
80107c82:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107c85:	e8 34 b2 ff ff       	call   80102ebe <cpunum>
80107c8a:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107c90:	05 80 33 11 80       	add    $0x80113380,%eax
80107c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9b:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca4:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cad:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb4:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107cb8:	83 e2 f0             	and    $0xfffffff0,%edx
80107cbb:	83 ca 0a             	or     $0xa,%edx
80107cbe:	88 50 7d             	mov    %dl,0x7d(%eax)
80107cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc4:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107cc8:	83 ca 10             	or     $0x10,%edx
80107ccb:	88 50 7d             	mov    %dl,0x7d(%eax)
80107cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd1:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107cd5:	83 e2 9f             	and    $0xffffff9f,%edx
80107cd8:	88 50 7d             	mov    %dl,0x7d(%eax)
80107cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cde:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107ce2:	83 ca 80             	or     $0xffffff80,%edx
80107ce5:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ceb:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cef:	83 ca 0f             	or     $0xf,%edx
80107cf2:	88 50 7e             	mov    %dl,0x7e(%eax)
80107cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107cfc:	83 e2 ef             	and    $0xffffffef,%edx
80107cff:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d05:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d09:	83 e2 df             	and    $0xffffffdf,%edx
80107d0c:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d12:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d16:	83 ca 40             	or     $0x40,%edx
80107d19:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d1f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107d23:	83 ca 80             	or     $0xffffff80,%edx
80107d26:	88 50 7e             	mov    %dl,0x7e(%eax)
80107d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d33:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107d3a:	ff ff 
80107d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d3f:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107d46:	00 00 
80107d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4b:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d55:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d5c:	83 e2 f0             	and    $0xfffffff0,%edx
80107d5f:	83 ca 02             	or     $0x2,%edx
80107d62:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d72:	83 ca 10             	or     $0x10,%edx
80107d75:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d85:	83 e2 9f             	and    $0xffffff9f,%edx
80107d88:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d91:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107d98:	83 ca 80             	or     $0xffffff80,%edx
80107d9b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107dab:	83 ca 0f             	or     $0xf,%edx
80107dae:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107dbe:	83 e2 ef             	and    $0xffffffef,%edx
80107dc1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dca:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107dd1:	83 e2 df             	and    $0xffffffdf,%edx
80107dd4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ddd:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107de4:	83 ca 40             	or     $0x40,%edx
80107de7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107df7:	83 ca 80             	or     $0xffffff80,%edx
80107dfa:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e03:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0d:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107e14:	ff ff 
80107e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e19:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107e20:	00 00 
80107e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e25:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e2f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e36:	83 e2 f0             	and    $0xfffffff0,%edx
80107e39:	83 ca 0a             	or     $0xa,%edx
80107e3c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e45:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e4c:	83 ca 10             	or     $0x10,%edx
80107e4f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e58:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e5f:	83 ca 60             	or     $0x60,%edx
80107e62:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107e72:	83 ca 80             	or     $0xffffff80,%edx
80107e75:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e85:	83 ca 0f             	or     $0xf,%edx
80107e88:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e91:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107e98:	83 e2 ef             	and    $0xffffffef,%edx
80107e9b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107eab:	83 e2 df             	and    $0xffffffdf,%edx
80107eae:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb7:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ebe:	83 ca 40             	or     $0x40,%edx
80107ec1:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eca:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ed1:	83 ca 80             	or     $0xffffff80,%edx
80107ed4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107edd:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee7:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107eee:	ff ff 
80107ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef3:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107efa:	00 00 
80107efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eff:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f09:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f10:	83 e2 f0             	and    $0xfffffff0,%edx
80107f13:	83 ca 02             	or     $0x2,%edx
80107f16:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f26:	83 ca 10             	or     $0x10,%edx
80107f29:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f32:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f39:	83 ca 60             	or     $0x60,%edx
80107f3c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f45:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107f4c:	83 ca 80             	or     $0xffffff80,%edx
80107f4f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f58:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f5f:	83 ca 0f             	or     $0xf,%edx
80107f62:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f72:	83 e2 ef             	and    $0xffffffef,%edx
80107f75:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f85:	83 e2 df             	and    $0xffffffdf,%edx
80107f88:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f91:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107f98:	83 ca 40             	or     $0x40,%edx
80107f9b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa4:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107fab:	83 ca 80             	or     $0xffffff80,%edx
80107fae:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb7:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc1:	05 b4 00 00 00       	add    $0xb4,%eax
80107fc6:	89 c3                	mov    %eax,%ebx
80107fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcb:	05 b4 00 00 00       	add    $0xb4,%eax
80107fd0:	c1 e8 10             	shr    $0x10,%eax
80107fd3:	89 c1                	mov    %eax,%ecx
80107fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd8:	05 b4 00 00 00       	add    $0xb4,%eax
80107fdd:	c1 e8 18             	shr    $0x18,%eax
80107fe0:	89 c2                	mov    %eax,%edx
80107fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe5:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107fec:	00 00 
80107fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff1:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffb:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80108001:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108004:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010800b:	83 e1 f0             	and    $0xfffffff0,%ecx
8010800e:	83 c9 02             	or     $0x2,%ecx
80108011:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108017:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801a:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108021:	83 c9 10             	or     $0x10,%ecx
80108024:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010802a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802d:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108034:	83 e1 9f             	and    $0xffffff9f,%ecx
80108037:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010803d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108040:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108047:	83 c9 80             	or     $0xffffff80,%ecx
8010804a:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108053:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010805a:	83 e1 f0             	and    $0xfffffff0,%ecx
8010805d:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108063:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108066:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010806d:	83 e1 ef             	and    $0xffffffef,%ecx
80108070:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108079:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108080:	83 e1 df             	and    $0xffffffdf,%ecx
80108083:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108089:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808c:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108093:	83 c9 40             	or     $0x40,%ecx
80108096:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010809c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809f:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801080a6:	83 c9 80             	or     $0xffffff80,%ecx
801080a9:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801080af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b2:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801080b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080bb:	83 c0 70             	add    $0x70,%eax
801080be:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
801080c5:	00 
801080c6:	89 04 24             	mov    %eax,(%esp)
801080c9:	e8 37 fb ff ff       	call   80107c05 <lgdt>
  loadgs(SEG_KCPU << 3);
801080ce:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
801080d5:	e8 6a fb ff ff       	call   80107c44 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
801080da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080dd:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801080e3:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801080ea:	00 00 00 00 
}
801080ee:	83 c4 24             	add    $0x24,%esp
801080f1:	5b                   	pop    %ebx
801080f2:	5d                   	pop    %ebp
801080f3:	c3                   	ret    

801080f4 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801080f4:	55                   	push   %ebp
801080f5:	89 e5                	mov    %esp,%ebp
801080f7:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801080fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801080fd:	c1 e8 16             	shr    $0x16,%eax
80108100:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108107:	8b 45 08             	mov    0x8(%ebp),%eax
8010810a:	01 d0                	add    %edx,%eax
8010810c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010810f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108112:	8b 00                	mov    (%eax),%eax
80108114:	83 e0 01             	and    $0x1,%eax
80108117:	85 c0                	test   %eax,%eax
80108119:	74 17                	je     80108132 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
8010811b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010811e:	8b 00                	mov    (%eax),%eax
80108120:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108125:	89 04 24             	mov    %eax,(%esp)
80108128:	e8 44 fb ff ff       	call   80107c71 <p2v>
8010812d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108130:	eb 4b                	jmp    8010817d <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108132:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108136:	74 0e                	je     80108146 <walkpgdir+0x52>
80108138:	e8 eb a9 ff ff       	call   80102b28 <kalloc>
8010813d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108140:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108144:	75 07                	jne    8010814d <walkpgdir+0x59>
      return 0;
80108146:	b8 00 00 00 00       	mov    $0x0,%eax
8010814b:	eb 47                	jmp    80108194 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010814d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108154:	00 
80108155:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010815c:	00 
8010815d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108160:	89 04 24             	mov    %eax,(%esp)
80108163:	e8 b3 d3 ff ff       	call   8010551b <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108168:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816b:	89 04 24             	mov    %eax,(%esp)
8010816e:	e8 f1 fa ff ff       	call   80107c64 <v2p>
80108173:	83 c8 07             	or     $0x7,%eax
80108176:	89 c2                	mov    %eax,%edx
80108178:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010817b:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010817d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108180:	c1 e8 0c             	shr    $0xc,%eax
80108183:	25 ff 03 00 00       	and    $0x3ff,%eax
80108188:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010818f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108192:	01 d0                	add    %edx,%eax
}
80108194:	c9                   	leave  
80108195:	c3                   	ret    

80108196 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108196:	55                   	push   %ebp
80108197:	89 e5                	mov    %esp,%ebp
80108199:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010819c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010819f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801081a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801081aa:	8b 45 10             	mov    0x10(%ebp),%eax
801081ad:	01 d0                	add    %edx,%eax
801081af:	83 e8 01             	sub    $0x1,%eax
801081b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801081ba:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801081c1:	00 
801081c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801081c9:	8b 45 08             	mov    0x8(%ebp),%eax
801081cc:	89 04 24             	mov    %eax,(%esp)
801081cf:	e8 20 ff ff ff       	call   801080f4 <walkpgdir>
801081d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801081d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801081db:	75 07                	jne    801081e4 <mappages+0x4e>
      return -1;
801081dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081e2:	eb 48                	jmp    8010822c <mappages+0x96>
    if(*pte & PTE_P)
801081e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081e7:	8b 00                	mov    (%eax),%eax
801081e9:	83 e0 01             	and    $0x1,%eax
801081ec:	85 c0                	test   %eax,%eax
801081ee:	74 0c                	je     801081fc <mappages+0x66>
      panic("remap");
801081f0:	c7 04 24 6c 90 10 80 	movl   $0x8010906c,(%esp)
801081f7:	e8 3e 83 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
801081fc:	8b 45 18             	mov    0x18(%ebp),%eax
801081ff:	0b 45 14             	or     0x14(%ebp),%eax
80108202:	83 c8 01             	or     $0x1,%eax
80108205:	89 c2                	mov    %eax,%edx
80108207:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010820a:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010820c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108212:	75 08                	jne    8010821c <mappages+0x86>
      break;
80108214:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108215:	b8 00 00 00 00       	mov    $0x0,%eax
8010821a:	eb 10                	jmp    8010822c <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
8010821c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108223:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010822a:	eb 8e                	jmp    801081ba <mappages+0x24>
  return 0;
}
8010822c:	c9                   	leave  
8010822d:	c3                   	ret    

8010822e <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010822e:	55                   	push   %ebp
8010822f:	89 e5                	mov    %esp,%ebp
80108231:	53                   	push   %ebx
80108232:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108235:	e8 ee a8 ff ff       	call   80102b28 <kalloc>
8010823a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010823d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108241:	75 0a                	jne    8010824d <setupkvm+0x1f>
    return 0;
80108243:	b8 00 00 00 00       	mov    $0x0,%eax
80108248:	e9 98 00 00 00       	jmp    801082e5 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
8010824d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108254:	00 
80108255:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010825c:	00 
8010825d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108260:	89 04 24             	mov    %eax,(%esp)
80108263:	e8 b3 d2 ff ff       	call   8010551b <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108268:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
8010826f:	e8 fd f9 ff ff       	call   80107c71 <p2v>
80108274:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108279:	76 0c                	jbe    80108287 <setupkvm+0x59>
    panic("PHYSTOP too high");
8010827b:	c7 04 24 72 90 10 80 	movl   $0x80109072,(%esp)
80108282:	e8 b3 82 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108287:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
8010828e:	eb 49                	jmp    801082d9 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108290:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108293:	8b 48 0c             	mov    0xc(%eax),%ecx
80108296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108299:	8b 50 04             	mov    0x4(%eax),%edx
8010829c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010829f:	8b 58 08             	mov    0x8(%eax),%ebx
801082a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a5:	8b 40 04             	mov    0x4(%eax),%eax
801082a8:	29 c3                	sub    %eax,%ebx
801082aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ad:	8b 00                	mov    (%eax),%eax
801082af:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801082b3:	89 54 24 0c          	mov    %edx,0xc(%esp)
801082b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801082bb:	89 44 24 04          	mov    %eax,0x4(%esp)
801082bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082c2:	89 04 24             	mov    %eax,(%esp)
801082c5:	e8 cc fe ff ff       	call   80108196 <mappages>
801082ca:	85 c0                	test   %eax,%eax
801082cc:	79 07                	jns    801082d5 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801082ce:	b8 00 00 00 00       	mov    $0x0,%eax
801082d3:	eb 10                	jmp    801082e5 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801082d5:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801082d9:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
801082e0:	72 ae                	jb     80108290 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801082e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801082e5:	83 c4 34             	add    $0x34,%esp
801082e8:	5b                   	pop    %ebx
801082e9:	5d                   	pop    %ebp
801082ea:	c3                   	ret    

801082eb <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801082eb:	55                   	push   %ebp
801082ec:	89 e5                	mov    %esp,%ebp
801082ee:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801082f1:	e8 38 ff ff ff       	call   8010822e <setupkvm>
801082f6:	a3 58 63 11 80       	mov    %eax,0x80116358
  switchkvm();
801082fb:	e8 02 00 00 00       	call   80108302 <switchkvm>
}
80108300:	c9                   	leave  
80108301:	c3                   	ret    

80108302 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108302:	55                   	push   %ebp
80108303:	89 e5                	mov    %esp,%ebp
80108305:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108308:	a1 58 63 11 80       	mov    0x80116358,%eax
8010830d:	89 04 24             	mov    %eax,(%esp)
80108310:	e8 4f f9 ff ff       	call   80107c64 <v2p>
80108315:	89 04 24             	mov    %eax,(%esp)
80108318:	e8 3c f9 ff ff       	call   80107c59 <lcr3>
}
8010831d:	c9                   	leave  
8010831e:	c3                   	ret    

8010831f <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010831f:	55                   	push   %ebp
80108320:	89 e5                	mov    %esp,%ebp
80108322:	53                   	push   %ebx
80108323:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80108326:	e8 f0 d0 ff ff       	call   8010541b <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010832b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108331:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108338:	83 c2 08             	add    $0x8,%edx
8010833b:	89 d3                	mov    %edx,%ebx
8010833d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108344:	83 c2 08             	add    $0x8,%edx
80108347:	c1 ea 10             	shr    $0x10,%edx
8010834a:	89 d1                	mov    %edx,%ecx
8010834c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108353:	83 c2 08             	add    $0x8,%edx
80108356:	c1 ea 18             	shr    $0x18,%edx
80108359:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108360:	67 00 
80108362:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80108369:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
8010836f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108376:	83 e1 f0             	and    $0xfffffff0,%ecx
80108379:	83 c9 09             	or     $0x9,%ecx
8010837c:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108382:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108389:	83 c9 10             	or     $0x10,%ecx
8010838c:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108392:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108399:	83 e1 9f             	and    $0xffffff9f,%ecx
8010839c:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801083a2:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801083a9:	83 c9 80             	or     $0xffffff80,%ecx
801083ac:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801083b2:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801083b9:	83 e1 f0             	and    $0xfffffff0,%ecx
801083bc:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801083c2:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801083c9:	83 e1 ef             	and    $0xffffffef,%ecx
801083cc:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801083d2:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801083d9:	83 e1 df             	and    $0xffffffdf,%ecx
801083dc:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801083e2:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801083e9:	83 c9 40             	or     $0x40,%ecx
801083ec:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801083f2:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801083f9:	83 e1 7f             	and    $0x7f,%ecx
801083fc:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108402:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108408:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010840e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108415:	83 e2 ef             	and    $0xffffffef,%edx
80108418:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010841e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108424:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010842a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108430:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108437:	8b 52 08             	mov    0x8(%edx),%edx
8010843a:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108440:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108443:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
8010844a:	e8 df f7 ff ff       	call   80107c2e <ltr>
  if(p->pgdir == 0)
8010844f:	8b 45 08             	mov    0x8(%ebp),%eax
80108452:	8b 40 04             	mov    0x4(%eax),%eax
80108455:	85 c0                	test   %eax,%eax
80108457:	75 0c                	jne    80108465 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80108459:	c7 04 24 83 90 10 80 	movl   $0x80109083,(%esp)
80108460:	e8 d5 80 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108465:	8b 45 08             	mov    0x8(%ebp),%eax
80108468:	8b 40 04             	mov    0x4(%eax),%eax
8010846b:	89 04 24             	mov    %eax,(%esp)
8010846e:	e8 f1 f7 ff ff       	call   80107c64 <v2p>
80108473:	89 04 24             	mov    %eax,(%esp)
80108476:	e8 de f7 ff ff       	call   80107c59 <lcr3>
  popcli();
8010847b:	e8 df cf ff ff       	call   8010545f <popcli>
}
80108480:	83 c4 14             	add    $0x14,%esp
80108483:	5b                   	pop    %ebx
80108484:	5d                   	pop    %ebp
80108485:	c3                   	ret    

80108486 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108486:	55                   	push   %ebp
80108487:	89 e5                	mov    %esp,%ebp
80108489:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010848c:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108493:	76 0c                	jbe    801084a1 <inituvm+0x1b>
    panic("inituvm: more than a page");
80108495:	c7 04 24 97 90 10 80 	movl   $0x80109097,(%esp)
8010849c:	e8 99 80 ff ff       	call   8010053a <panic>
  mem = kalloc();
801084a1:	e8 82 a6 ff ff       	call   80102b28 <kalloc>
801084a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801084a9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801084b0:	00 
801084b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801084b8:	00 
801084b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084bc:	89 04 24             	mov    %eax,(%esp)
801084bf:	e8 57 d0 ff ff       	call   8010551b <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801084c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c7:	89 04 24             	mov    %eax,(%esp)
801084ca:	e8 95 f7 ff ff       	call   80107c64 <v2p>
801084cf:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801084d6:	00 
801084d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
801084db:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801084e2:	00 
801084e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801084ea:	00 
801084eb:	8b 45 08             	mov    0x8(%ebp),%eax
801084ee:	89 04 24             	mov    %eax,(%esp)
801084f1:	e8 a0 fc ff ff       	call   80108196 <mappages>
  memmove(mem, init, sz);
801084f6:	8b 45 10             	mov    0x10(%ebp),%eax
801084f9:	89 44 24 08          	mov    %eax,0x8(%esp)
801084fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80108500:	89 44 24 04          	mov    %eax,0x4(%esp)
80108504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108507:	89 04 24             	mov    %eax,(%esp)
8010850a:	e8 db d0 ff ff       	call   801055ea <memmove>
}
8010850f:	c9                   	leave  
80108510:	c3                   	ret    

80108511 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108511:	55                   	push   %ebp
80108512:	89 e5                	mov    %esp,%ebp
80108514:	53                   	push   %ebx
80108515:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108518:	8b 45 0c             	mov    0xc(%ebp),%eax
8010851b:	25 ff 0f 00 00       	and    $0xfff,%eax
80108520:	85 c0                	test   %eax,%eax
80108522:	74 0c                	je     80108530 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108524:	c7 04 24 b4 90 10 80 	movl   $0x801090b4,(%esp)
8010852b:	e8 0a 80 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108530:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108537:	e9 a9 00 00 00       	jmp    801085e5 <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010853c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010853f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108542:	01 d0                	add    %edx,%eax
80108544:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010854b:	00 
8010854c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108550:	8b 45 08             	mov    0x8(%ebp),%eax
80108553:	89 04 24             	mov    %eax,(%esp)
80108556:	e8 99 fb ff ff       	call   801080f4 <walkpgdir>
8010855b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010855e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108562:	75 0c                	jne    80108570 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80108564:	c7 04 24 d7 90 10 80 	movl   $0x801090d7,(%esp)
8010856b:	e8 ca 7f ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108570:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108573:	8b 00                	mov    (%eax),%eax
80108575:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010857a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010857d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108580:	8b 55 18             	mov    0x18(%ebp),%edx
80108583:	29 c2                	sub    %eax,%edx
80108585:	89 d0                	mov    %edx,%eax
80108587:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010858c:	77 0f                	ja     8010859d <loaduvm+0x8c>
      n = sz - i;
8010858e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108591:	8b 55 18             	mov    0x18(%ebp),%edx
80108594:	29 c2                	sub    %eax,%edx
80108596:	89 d0                	mov    %edx,%eax
80108598:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010859b:	eb 07                	jmp    801085a4 <loaduvm+0x93>
    else
      n = PGSIZE;
8010859d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801085a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a7:	8b 55 14             	mov    0x14(%ebp),%edx
801085aa:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801085ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
801085b0:	89 04 24             	mov    %eax,(%esp)
801085b3:	e8 b9 f6 ff ff       	call   80107c71 <p2v>
801085b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801085bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
801085bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801085c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801085c7:	8b 45 10             	mov    0x10(%ebp),%eax
801085ca:	89 04 24             	mov    %eax,(%esp)
801085cd:	e8 dc 97 ff ff       	call   80101dae <readi>
801085d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801085d5:	74 07                	je     801085de <loaduvm+0xcd>
      return -1;
801085d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801085dc:	eb 18                	jmp    801085f6 <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801085de:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801085e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e8:	3b 45 18             	cmp    0x18(%ebp),%eax
801085eb:	0f 82 4b ff ff ff    	jb     8010853c <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801085f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801085f6:	83 c4 24             	add    $0x24,%esp
801085f9:	5b                   	pop    %ebx
801085fa:	5d                   	pop    %ebp
801085fb:	c3                   	ret    

801085fc <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801085fc:	55                   	push   %ebp
801085fd:	89 e5                	mov    %esp,%ebp
801085ff:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108602:	8b 45 10             	mov    0x10(%ebp),%eax
80108605:	85 c0                	test   %eax,%eax
80108607:	79 0a                	jns    80108613 <allocuvm+0x17>
    return 0;
80108609:	b8 00 00 00 00       	mov    $0x0,%eax
8010860e:	e9 c1 00 00 00       	jmp    801086d4 <allocuvm+0xd8>
  if(newsz < oldsz)
80108613:	8b 45 10             	mov    0x10(%ebp),%eax
80108616:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108619:	73 08                	jae    80108623 <allocuvm+0x27>
    return oldsz;
8010861b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010861e:	e9 b1 00 00 00       	jmp    801086d4 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108623:	8b 45 0c             	mov    0xc(%ebp),%eax
80108626:	05 ff 0f 00 00       	add    $0xfff,%eax
8010862b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108630:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108633:	e9 8d 00 00 00       	jmp    801086c5 <allocuvm+0xc9>
    mem = kalloc();
80108638:	e8 eb a4 ff ff       	call   80102b28 <kalloc>
8010863d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108640:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108644:	75 2c                	jne    80108672 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108646:	c7 04 24 f5 90 10 80 	movl   $0x801090f5,(%esp)
8010864d:	e8 4e 7d ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108652:	8b 45 0c             	mov    0xc(%ebp),%eax
80108655:	89 44 24 08          	mov    %eax,0x8(%esp)
80108659:	8b 45 10             	mov    0x10(%ebp),%eax
8010865c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108660:	8b 45 08             	mov    0x8(%ebp),%eax
80108663:	89 04 24             	mov    %eax,(%esp)
80108666:	e8 6b 00 00 00       	call   801086d6 <deallocuvm>
      return 0;
8010866b:	b8 00 00 00 00       	mov    $0x0,%eax
80108670:	eb 62                	jmp    801086d4 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108672:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108679:	00 
8010867a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108681:	00 
80108682:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108685:	89 04 24             	mov    %eax,(%esp)
80108688:	e8 8e ce ff ff       	call   8010551b <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010868d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108690:	89 04 24             	mov    %eax,(%esp)
80108693:	e8 cc f5 ff ff       	call   80107c64 <v2p>
80108698:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010869b:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801086a2:	00 
801086a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
801086a7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801086ae:	00 
801086af:	89 54 24 04          	mov    %edx,0x4(%esp)
801086b3:	8b 45 08             	mov    0x8(%ebp),%eax
801086b6:	89 04 24             	mov    %eax,(%esp)
801086b9:	e8 d8 fa ff ff       	call   80108196 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801086be:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801086c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086c8:	3b 45 10             	cmp    0x10(%ebp),%eax
801086cb:	0f 82 67 ff ff ff    	jb     80108638 <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801086d1:	8b 45 10             	mov    0x10(%ebp),%eax
}
801086d4:	c9                   	leave  
801086d5:	c3                   	ret    

801086d6 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801086d6:	55                   	push   %ebp
801086d7:	89 e5                	mov    %esp,%ebp
801086d9:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801086dc:	8b 45 10             	mov    0x10(%ebp),%eax
801086df:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086e2:	72 08                	jb     801086ec <deallocuvm+0x16>
    return oldsz;
801086e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801086e7:	e9 a4 00 00 00       	jmp    80108790 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
801086ec:	8b 45 10             	mov    0x10(%ebp),%eax
801086ef:	05 ff 0f 00 00       	add    $0xfff,%eax
801086f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801086fc:	e9 80 00 00 00       	jmp    80108781 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108704:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010870b:	00 
8010870c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108710:	8b 45 08             	mov    0x8(%ebp),%eax
80108713:	89 04 24             	mov    %eax,(%esp)
80108716:	e8 d9 f9 ff ff       	call   801080f4 <walkpgdir>
8010871b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010871e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108722:	75 09                	jne    8010872d <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80108724:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010872b:	eb 4d                	jmp    8010877a <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
8010872d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108730:	8b 00                	mov    (%eax),%eax
80108732:	83 e0 01             	and    $0x1,%eax
80108735:	85 c0                	test   %eax,%eax
80108737:	74 41                	je     8010877a <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80108739:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010873c:	8b 00                	mov    (%eax),%eax
8010873e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108743:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108746:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010874a:	75 0c                	jne    80108758 <deallocuvm+0x82>
        panic("kfree");
8010874c:	c7 04 24 0d 91 10 80 	movl   $0x8010910d,(%esp)
80108753:	e8 e2 7d ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80108758:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010875b:	89 04 24             	mov    %eax,(%esp)
8010875e:	e8 0e f5 ff ff       	call   80107c71 <p2v>
80108763:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108766:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108769:	89 04 24             	mov    %eax,(%esp)
8010876c:	e8 1e a3 ff ff       	call   80102a8f <kfree>
      *pte = 0;
80108771:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108774:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010877a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108784:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108787:	0f 82 74 ff ff ff    	jb     80108701 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010878d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108790:	c9                   	leave  
80108791:	c3                   	ret    

80108792 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108792:	55                   	push   %ebp
80108793:	89 e5                	mov    %esp,%ebp
80108795:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108798:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010879c:	75 0c                	jne    801087aa <freevm+0x18>
    panic("freevm: no pgdir");
8010879e:	c7 04 24 13 91 10 80 	movl   $0x80109113,(%esp)
801087a5:	e8 90 7d ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801087aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801087b1:	00 
801087b2:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
801087b9:	80 
801087ba:	8b 45 08             	mov    0x8(%ebp),%eax
801087bd:	89 04 24             	mov    %eax,(%esp)
801087c0:	e8 11 ff ff ff       	call   801086d6 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801087c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801087cc:	eb 48                	jmp    80108816 <freevm+0x84>
    if(pgdir[i] & PTE_P){
801087ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801087d8:	8b 45 08             	mov    0x8(%ebp),%eax
801087db:	01 d0                	add    %edx,%eax
801087dd:	8b 00                	mov    (%eax),%eax
801087df:	83 e0 01             	and    $0x1,%eax
801087e2:	85 c0                	test   %eax,%eax
801087e4:	74 2c                	je     80108812 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801087e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801087f0:	8b 45 08             	mov    0x8(%ebp),%eax
801087f3:	01 d0                	add    %edx,%eax
801087f5:	8b 00                	mov    (%eax),%eax
801087f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087fc:	89 04 24             	mov    %eax,(%esp)
801087ff:	e8 6d f4 ff ff       	call   80107c71 <p2v>
80108804:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108807:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010880a:	89 04 24             	mov    %eax,(%esp)
8010880d:	e8 7d a2 ff ff       	call   80102a8f <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108812:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108816:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010881d:	76 af                	jbe    801087ce <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010881f:	8b 45 08             	mov    0x8(%ebp),%eax
80108822:	89 04 24             	mov    %eax,(%esp)
80108825:	e8 65 a2 ff ff       	call   80102a8f <kfree>
}
8010882a:	c9                   	leave  
8010882b:	c3                   	ret    

8010882c <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010882c:	55                   	push   %ebp
8010882d:	89 e5                	mov    %esp,%ebp
8010882f:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108832:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108839:	00 
8010883a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010883d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108841:	8b 45 08             	mov    0x8(%ebp),%eax
80108844:	89 04 24             	mov    %eax,(%esp)
80108847:	e8 a8 f8 ff ff       	call   801080f4 <walkpgdir>
8010884c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010884f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108853:	75 0c                	jne    80108861 <clearpteu+0x35>
    panic("clearpteu");
80108855:	c7 04 24 24 91 10 80 	movl   $0x80109124,(%esp)
8010885c:	e8 d9 7c ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80108861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108864:	8b 00                	mov    (%eax),%eax
80108866:	83 e0 fb             	and    $0xfffffffb,%eax
80108869:	89 c2                	mov    %eax,%edx
8010886b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010886e:	89 10                	mov    %edx,(%eax)
}
80108870:	c9                   	leave  
80108871:	c3                   	ret    

80108872 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108872:	55                   	push   %ebp
80108873:	89 e5                	mov    %esp,%ebp
80108875:	53                   	push   %ebx
80108876:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108879:	e8 b0 f9 ff ff       	call   8010822e <setupkvm>
8010887e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108881:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108885:	75 0a                	jne    80108891 <copyuvm+0x1f>
    return 0;
80108887:	b8 00 00 00 00       	mov    $0x0,%eax
8010888c:	e9 fd 00 00 00       	jmp    8010898e <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108891:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108898:	e9 d0 00 00 00       	jmp    8010896d <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010889d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801088a7:	00 
801088a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801088ac:	8b 45 08             	mov    0x8(%ebp),%eax
801088af:	89 04 24             	mov    %eax,(%esp)
801088b2:	e8 3d f8 ff ff       	call   801080f4 <walkpgdir>
801088b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801088ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801088be:	75 0c                	jne    801088cc <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
801088c0:	c7 04 24 2e 91 10 80 	movl   $0x8010912e,(%esp)
801088c7:	e8 6e 7c ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
801088cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088cf:	8b 00                	mov    (%eax),%eax
801088d1:	83 e0 01             	and    $0x1,%eax
801088d4:	85 c0                	test   %eax,%eax
801088d6:	75 0c                	jne    801088e4 <copyuvm+0x72>
      panic("copyuvm: page not present");
801088d8:	c7 04 24 48 91 10 80 	movl   $0x80109148,(%esp)
801088df:	e8 56 7c ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
801088e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088e7:	8b 00                	mov    (%eax),%eax
801088e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801088f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088f4:	8b 00                	mov    (%eax),%eax
801088f6:	25 ff 0f 00 00       	and    $0xfff,%eax
801088fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801088fe:	e8 25 a2 ff ff       	call   80102b28 <kalloc>
80108903:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108906:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010890a:	75 02                	jne    8010890e <copyuvm+0x9c>
      goto bad;
8010890c:	eb 70                	jmp    8010897e <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010890e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108911:	89 04 24             	mov    %eax,(%esp)
80108914:	e8 58 f3 ff ff       	call   80107c71 <p2v>
80108919:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108920:	00 
80108921:	89 44 24 04          	mov    %eax,0x4(%esp)
80108925:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108928:	89 04 24             	mov    %eax,(%esp)
8010892b:	e8 ba cc ff ff       	call   801055ea <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108930:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108933:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108936:	89 04 24             	mov    %eax,(%esp)
80108939:	e8 26 f3 ff ff       	call   80107c64 <v2p>
8010893e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108941:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108945:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108949:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108950:	00 
80108951:	89 54 24 04          	mov    %edx,0x4(%esp)
80108955:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108958:	89 04 24             	mov    %eax,(%esp)
8010895b:	e8 36 f8 ff ff       	call   80108196 <mappages>
80108960:	85 c0                	test   %eax,%eax
80108962:	79 02                	jns    80108966 <copyuvm+0xf4>
      goto bad;
80108964:	eb 18                	jmp    8010897e <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108966:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010896d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108970:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108973:	0f 82 24 ff ff ff    	jb     8010889d <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108979:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010897c:	eb 10                	jmp    8010898e <copyuvm+0x11c>

bad:
  freevm(d);
8010897e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108981:	89 04 24             	mov    %eax,(%esp)
80108984:	e8 09 fe ff ff       	call   80108792 <freevm>
  return 0;
80108989:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010898e:	83 c4 44             	add    $0x44,%esp
80108991:	5b                   	pop    %ebx
80108992:	5d                   	pop    %ebp
80108993:	c3                   	ret    

80108994 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108994:	55                   	push   %ebp
80108995:	89 e5                	mov    %esp,%ebp
80108997:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010899a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801089a1:	00 
801089a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801089a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801089a9:	8b 45 08             	mov    0x8(%ebp),%eax
801089ac:	89 04 24             	mov    %eax,(%esp)
801089af:	e8 40 f7 ff ff       	call   801080f4 <walkpgdir>
801089b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801089b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ba:	8b 00                	mov    (%eax),%eax
801089bc:	83 e0 01             	and    $0x1,%eax
801089bf:	85 c0                	test   %eax,%eax
801089c1:	75 07                	jne    801089ca <uva2ka+0x36>
    return 0;
801089c3:	b8 00 00 00 00       	mov    $0x0,%eax
801089c8:	eb 25                	jmp    801089ef <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
801089ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089cd:	8b 00                	mov    (%eax),%eax
801089cf:	83 e0 04             	and    $0x4,%eax
801089d2:	85 c0                	test   %eax,%eax
801089d4:	75 07                	jne    801089dd <uva2ka+0x49>
    return 0;
801089d6:	b8 00 00 00 00       	mov    $0x0,%eax
801089db:	eb 12                	jmp    801089ef <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
801089dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089e0:	8b 00                	mov    (%eax),%eax
801089e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089e7:	89 04 24             	mov    %eax,(%esp)
801089ea:	e8 82 f2 ff ff       	call   80107c71 <p2v>
}
801089ef:	c9                   	leave  
801089f0:	c3                   	ret    

801089f1 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801089f1:	55                   	push   %ebp
801089f2:	89 e5                	mov    %esp,%ebp
801089f4:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801089f7:	8b 45 10             	mov    0x10(%ebp),%eax
801089fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801089fd:	e9 87 00 00 00       	jmp    80108a89 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108a02:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a05:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a10:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a14:	8b 45 08             	mov    0x8(%ebp),%eax
80108a17:	89 04 24             	mov    %eax,(%esp)
80108a1a:	e8 75 ff ff ff       	call   80108994 <uva2ka>
80108a1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108a22:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108a26:	75 07                	jne    80108a2f <copyout+0x3e>
      return -1;
80108a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108a2d:	eb 69                	jmp    80108a98 <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a32:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108a35:	29 c2                	sub    %eax,%edx
80108a37:	89 d0                	mov    %edx,%eax
80108a39:	05 00 10 00 00       	add    $0x1000,%eax
80108a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a44:	3b 45 14             	cmp    0x14(%ebp),%eax
80108a47:	76 06                	jbe    80108a4f <copyout+0x5e>
      n = len;
80108a49:	8b 45 14             	mov    0x14(%ebp),%eax
80108a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a52:	8b 55 0c             	mov    0xc(%ebp),%edx
80108a55:	29 c2                	sub    %eax,%edx
80108a57:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a5a:	01 c2                	add    %eax,%edx
80108a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a5f:	89 44 24 08          	mov    %eax,0x8(%esp)
80108a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a66:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a6a:	89 14 24             	mov    %edx,(%esp)
80108a6d:	e8 78 cb ff ff       	call   801055ea <memmove>
    len -= n;
80108a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a75:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a7b:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a81:	05 00 10 00 00       	add    $0x1000,%eax
80108a86:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108a89:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108a8d:	0f 85 6f ff ff ff    	jne    80108a02 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a98:	c9                   	leave  
80108a99:	c3                   	ret    
