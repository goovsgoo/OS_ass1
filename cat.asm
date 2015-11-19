
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:
};
////////

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 20 0d 00 	movl   $0xd20,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 ae 04 00 00       	call   4d1 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 20 0d 00 	movl   $0xd20,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 8b 04 00 00       	call   4c9 <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 20                	jns    6d <cat+0x6d>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 15 0a 00 	movl   $0xa15,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 e8 05 00 00       	call   649 <printf>
    exit(-1);
  61:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  68:	e8 44 04 00 00       	call   4b1 <exit>
  }
}
  6d:	c9                   	leave  
  6e:	c3                   	ret    

0000006f <main>:

int
main(int argc, char *argv[])
{
  6f:	55                   	push   %ebp
  70:	89 e5                	mov    %esp,%ebp
  72:	83 e4 f0             	and    $0xfffffff0,%esp
  75:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  78:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  7c:	7f 18                	jg     96 <main+0x27>
    cat(0);
  7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  85:	e8 76 ff ff ff       	call   0 <cat>
    exit(0);
  8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  91:	e8 1b 04 00 00       	call   4b1 <exit>
  }

  for(i = 1; i < argc; i++){
  96:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  9d:	00 
  9e:	e9 80 00 00 00       	jmp    123 <main+0xb4>
    if((fd = open(argv[i], 0)) < 0){
  a3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	01 d0                	add    %edx,%eax
  b3:	8b 00                	mov    (%eax),%eax
  b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  bc:	00 
  bd:	89 04 24             	mov    %eax,(%esp)
  c0:	e8 2c 04 00 00       	call   4f1 <open>
  c5:	89 44 24 18          	mov    %eax,0x18(%esp)
  c9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ce:	79 36                	jns    106 <main+0x97>
      printf(1, "cat: cannot open %s\n", argv[i]);
  d0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  db:	8b 45 0c             	mov    0xc(%ebp),%eax
  de:	01 d0                	add    %edx,%eax
  e0:	8b 00                	mov    (%eax),%eax
  e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  e6:	c7 44 24 04 26 0a 00 	movl   $0xa26,0x4(%esp)
  ed:	00 
  ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f5:	e8 4f 05 00 00       	call   649 <printf>
      exit(-1);
  fa:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 101:	e8 ab 03 00 00       	call   4b1 <exit>
    }
    cat(fd);
 106:	8b 44 24 18          	mov    0x18(%esp),%eax
 10a:	89 04 24             	mov    %eax,(%esp)
 10d:	e8 ee fe ff ff       	call   0 <cat>
    close(fd);
 112:	8b 44 24 18          	mov    0x18(%esp),%eax
 116:	89 04 24             	mov    %eax,(%esp)
 119:	e8 bb 03 00 00       	call   4d9 <close>
  if(argc <= 1){
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
 11e:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 123:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 127:	3b 45 08             	cmp    0x8(%ebp),%eax
 12a:	0f 8c 73 ff ff ff    	jl     a3 <main+0x34>
    }
    cat(fd);
    close(fd);
  }
  ////////////debag
  struct procstat *stat = malloc(sizeof(struct procstat));
 130:	c7 04 24 1c 00 00 00 	movl   $0x1c,(%esp)
 137:	e8 f9 07 00 00       	call   935 <malloc>
 13c:	89 44 24 14          	mov    %eax,0x14(%esp)
  int ret =  pstat(3, stat);
 140:	8b 44 24 14          	mov    0x14(%esp),%eax
 144:	89 44 24 04          	mov    %eax,0x4(%esp)
 148:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
 14f:	e8 fd 03 00 00       	call   551 <pstat>
 154:	89 44 24 10          	mov    %eax,0x10(%esp)
  printf(1,"log:: pstat- isWork-> %d; ",ret);
 158:	8b 44 24 10          	mov    0x10(%esp),%eax
 15c:	89 44 24 08          	mov    %eax,0x8(%esp)
 160:	c7 44 24 04 3b 0a 00 	movl   $0xa3b,0x4(%esp)
 167:	00 
 168:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 16f:	e8 d5 04 00 00       	call   649 <printf>
  printf(1,"name: ");  printf(1,"%s ",stat->name);
 174:	c7 44 24 04 56 0a 00 	movl   $0xa56,0x4(%esp)
 17b:	00 
 17c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 183:	e8 c1 04 00 00       	call   649 <printf>
 188:	8b 44 24 14          	mov    0x14(%esp),%eax
 18c:	89 44 24 08          	mov    %eax,0x8(%esp)
 190:	c7 44 24 04 5d 0a 00 	movl   $0xa5d,0x4(%esp)
 197:	00 
 198:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 19f:	e8 a5 04 00 00       	call   649 <printf>
  printf(1,"state: "); printf(1,"%d ",stat->state);
 1a4:	c7 44 24 04 61 0a 00 	movl   $0xa61,0x4(%esp)
 1ab:	00 
 1ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b3:	e8 91 04 00 00       	call   649 <printf>
 1b8:	8b 44 24 14          	mov    0x14(%esp),%eax
 1bc:	8b 40 18             	mov    0x18(%eax),%eax
 1bf:	89 44 24 08          	mov    %eax,0x8(%esp)
 1c3:	c7 44 24 04 69 0a 00 	movl   $0xa69,0x4(%esp)
 1ca:	00 
 1cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d2:	e8 72 04 00 00       	call   649 <printf>
  printf(1,"sz: "); printf(1,"%d ",stat->sz);
 1d7:	c7 44 24 04 6d 0a 00 	movl   $0xa6d,0x4(%esp)
 1de:	00 
 1df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1e6:	e8 5e 04 00 00       	call   649 <printf>
 1eb:	8b 44 24 14          	mov    0x14(%esp),%eax
 1ef:	8b 40 10             	mov    0x10(%eax),%eax
 1f2:	89 44 24 08          	mov    %eax,0x8(%esp)
 1f6:	c7 44 24 04 69 0a 00 	movl   $0xa69,0x4(%esp)
 1fd:	00 
 1fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 205:	e8 3f 04 00 00       	call   649 <printf>
  printf(1,"nofile: "); printf(1," %d\n ",stat->nofile);
 20a:	c7 44 24 04 72 0a 00 	movl   $0xa72,0x4(%esp)
 211:	00 
 212:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 219:	e8 2b 04 00 00       	call   649 <printf>
 21e:	8b 44 24 14          	mov    0x14(%esp),%eax
 222:	8b 40 14             	mov    0x14(%eax),%eax
 225:	89 44 24 08          	mov    %eax,0x8(%esp)
 229:	c7 44 24 04 7b 0a 00 	movl   $0xa7b,0x4(%esp)
 230:	00 
 231:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 238:	e8 0c 04 00 00       	call   649 <printf>

  //////////////
  exit(0);
 23d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 244:	e8 68 02 00 00       	call   4b1 <exit>

00000249 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 249:	55                   	push   %ebp
 24a:	89 e5                	mov    %esp,%ebp
 24c:	57                   	push   %edi
 24d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 24e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 251:	8b 55 10             	mov    0x10(%ebp),%edx
 254:	8b 45 0c             	mov    0xc(%ebp),%eax
 257:	89 cb                	mov    %ecx,%ebx
 259:	89 df                	mov    %ebx,%edi
 25b:	89 d1                	mov    %edx,%ecx
 25d:	fc                   	cld    
 25e:	f3 aa                	rep stos %al,%es:(%edi)
 260:	89 ca                	mov    %ecx,%edx
 262:	89 fb                	mov    %edi,%ebx
 264:	89 5d 08             	mov    %ebx,0x8(%ebp)
 267:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 26a:	5b                   	pop    %ebx
 26b:	5f                   	pop    %edi
 26c:	5d                   	pop    %ebp
 26d:	c3                   	ret    

0000026e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 26e:	55                   	push   %ebp
 26f:	89 e5                	mov    %esp,%ebp
 271:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 27a:	90                   	nop
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	8d 50 01             	lea    0x1(%eax),%edx
 281:	89 55 08             	mov    %edx,0x8(%ebp)
 284:	8b 55 0c             	mov    0xc(%ebp),%edx
 287:	8d 4a 01             	lea    0x1(%edx),%ecx
 28a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 28d:	0f b6 12             	movzbl (%edx),%edx
 290:	88 10                	mov    %dl,(%eax)
 292:	0f b6 00             	movzbl (%eax),%eax
 295:	84 c0                	test   %al,%al
 297:	75 e2                	jne    27b <strcpy+0xd>
    ;
  return os;
 299:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29c:	c9                   	leave  
 29d:	c3                   	ret    

0000029e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 29e:	55                   	push   %ebp
 29f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2a1:	eb 08                	jmp    2ab <strcmp+0xd>
    p++, q++;
 2a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2a7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	0f b6 00             	movzbl (%eax),%eax
 2b1:	84 c0                	test   %al,%al
 2b3:	74 10                	je     2c5 <strcmp+0x27>
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 10             	movzbl (%eax),%edx
 2bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	38 c2                	cmp    %al,%dl
 2c3:	74 de                	je     2a3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	0f b6 00             	movzbl (%eax),%eax
 2cb:	0f b6 d0             	movzbl %al,%edx
 2ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d1:	0f b6 00             	movzbl (%eax),%eax
 2d4:	0f b6 c0             	movzbl %al,%eax
 2d7:	29 c2                	sub    %eax,%edx
 2d9:	89 d0                	mov    %edx,%eax
}
 2db:	5d                   	pop    %ebp
 2dc:	c3                   	ret    

000002dd <strlen>:

uint
strlen(char *s)
{
 2dd:	55                   	push   %ebp
 2de:	89 e5                	mov    %esp,%ebp
 2e0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2ea:	eb 04                	jmp    2f0 <strlen+0x13>
 2ec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	01 d0                	add    %edx,%eax
 2f8:	0f b6 00             	movzbl (%eax),%eax
 2fb:	84 c0                	test   %al,%al
 2fd:	75 ed                	jne    2ec <strlen+0xf>
    ;
  return n;
 2ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 302:	c9                   	leave  
 303:	c3                   	ret    

00000304 <memset>:

void*
memset(void *dst, int c, uint n)
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 30a:	8b 45 10             	mov    0x10(%ebp),%eax
 30d:	89 44 24 08          	mov    %eax,0x8(%esp)
 311:	8b 45 0c             	mov    0xc(%ebp),%eax
 314:	89 44 24 04          	mov    %eax,0x4(%esp)
 318:	8b 45 08             	mov    0x8(%ebp),%eax
 31b:	89 04 24             	mov    %eax,(%esp)
 31e:	e8 26 ff ff ff       	call   249 <stosb>
  return dst;
 323:	8b 45 08             	mov    0x8(%ebp),%eax
}
 326:	c9                   	leave  
 327:	c3                   	ret    

00000328 <strchr>:

char*
strchr(const char *s, char c)
{
 328:	55                   	push   %ebp
 329:	89 e5                	mov    %esp,%ebp
 32b:	83 ec 04             	sub    $0x4,%esp
 32e:	8b 45 0c             	mov    0xc(%ebp),%eax
 331:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 334:	eb 14                	jmp    34a <strchr+0x22>
    if(*s == c)
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	0f b6 00             	movzbl (%eax),%eax
 33c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 33f:	75 05                	jne    346 <strchr+0x1e>
      return (char*)s;
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	eb 13                	jmp    359 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 346:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	0f b6 00             	movzbl (%eax),%eax
 350:	84 c0                	test   %al,%al
 352:	75 e2                	jne    336 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 354:	b8 00 00 00 00       	mov    $0x0,%eax
}
 359:	c9                   	leave  
 35a:	c3                   	ret    

0000035b <gets>:

char*
gets(char *buf, int max)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 361:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 368:	eb 4c                	jmp    3b6 <gets+0x5b>
    cc = read(0, &c, 1);
 36a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 371:	00 
 372:	8d 45 ef             	lea    -0x11(%ebp),%eax
 375:	89 44 24 04          	mov    %eax,0x4(%esp)
 379:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 380:	e8 44 01 00 00       	call   4c9 <read>
 385:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 388:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 38c:	7f 02                	jg     390 <gets+0x35>
      break;
 38e:	eb 31                	jmp    3c1 <gets+0x66>
    buf[i++] = c;
 390:	8b 45 f4             	mov    -0xc(%ebp),%eax
 393:	8d 50 01             	lea    0x1(%eax),%edx
 396:	89 55 f4             	mov    %edx,-0xc(%ebp)
 399:	89 c2                	mov    %eax,%edx
 39b:	8b 45 08             	mov    0x8(%ebp),%eax
 39e:	01 c2                	add    %eax,%edx
 3a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3a4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3a6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3aa:	3c 0a                	cmp    $0xa,%al
 3ac:	74 13                	je     3c1 <gets+0x66>
 3ae:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3b2:	3c 0d                	cmp    $0xd,%al
 3b4:	74 0b                	je     3c1 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b9:	83 c0 01             	add    $0x1,%eax
 3bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3bf:	7c a9                	jl     36a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3c4:	8b 45 08             	mov    0x8(%ebp),%eax
 3c7:	01 d0                	add    %edx,%eax
 3c9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3cf:	c9                   	leave  
 3d0:	c3                   	ret    

000003d1 <stat>:

int
stat(char *n, struct stat *st)
{
 3d1:	55                   	push   %ebp
 3d2:	89 e5                	mov    %esp,%ebp
 3d4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3de:	00 
 3df:	8b 45 08             	mov    0x8(%ebp),%eax
 3e2:	89 04 24             	mov    %eax,(%esp)
 3e5:	e8 07 01 00 00       	call   4f1 <open>
 3ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3f1:	79 07                	jns    3fa <stat+0x29>
    return -1;
 3f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3f8:	eb 23                	jmp    41d <stat+0x4c>
  r = fstat(fd, st);
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 401:	8b 45 f4             	mov    -0xc(%ebp),%eax
 404:	89 04 24             	mov    %eax,(%esp)
 407:	e8 fd 00 00 00       	call   509 <fstat>
 40c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 40f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 412:	89 04 24             	mov    %eax,(%esp)
 415:	e8 bf 00 00 00       	call   4d9 <close>
  return r;
 41a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 41d:	c9                   	leave  
 41e:	c3                   	ret    

0000041f <atoi>:

int
atoi(const char *s)
{
 41f:	55                   	push   %ebp
 420:	89 e5                	mov    %esp,%ebp
 422:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 425:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 42c:	eb 25                	jmp    453 <atoi+0x34>
    n = n*10 + *s++ - '0';
 42e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 431:	89 d0                	mov    %edx,%eax
 433:	c1 e0 02             	shl    $0x2,%eax
 436:	01 d0                	add    %edx,%eax
 438:	01 c0                	add    %eax,%eax
 43a:	89 c1                	mov    %eax,%ecx
 43c:	8b 45 08             	mov    0x8(%ebp),%eax
 43f:	8d 50 01             	lea    0x1(%eax),%edx
 442:	89 55 08             	mov    %edx,0x8(%ebp)
 445:	0f b6 00             	movzbl (%eax),%eax
 448:	0f be c0             	movsbl %al,%eax
 44b:	01 c8                	add    %ecx,%eax
 44d:	83 e8 30             	sub    $0x30,%eax
 450:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 453:	8b 45 08             	mov    0x8(%ebp),%eax
 456:	0f b6 00             	movzbl (%eax),%eax
 459:	3c 2f                	cmp    $0x2f,%al
 45b:	7e 0a                	jle    467 <atoi+0x48>
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
 460:	0f b6 00             	movzbl (%eax),%eax
 463:	3c 39                	cmp    $0x39,%al
 465:	7e c7                	jle    42e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 467:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 46a:	c9                   	leave  
 46b:	c3                   	ret    

0000046c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 46c:	55                   	push   %ebp
 46d:	89 e5                	mov    %esp,%ebp
 46f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 472:	8b 45 08             	mov    0x8(%ebp),%eax
 475:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 478:	8b 45 0c             	mov    0xc(%ebp),%eax
 47b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 47e:	eb 17                	jmp    497 <memmove+0x2b>
    *dst++ = *src++;
 480:	8b 45 fc             	mov    -0x4(%ebp),%eax
 483:	8d 50 01             	lea    0x1(%eax),%edx
 486:	89 55 fc             	mov    %edx,-0x4(%ebp)
 489:	8b 55 f8             	mov    -0x8(%ebp),%edx
 48c:	8d 4a 01             	lea    0x1(%edx),%ecx
 48f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 492:	0f b6 12             	movzbl (%edx),%edx
 495:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 497:	8b 45 10             	mov    0x10(%ebp),%eax
 49a:	8d 50 ff             	lea    -0x1(%eax),%edx
 49d:	89 55 10             	mov    %edx,0x10(%ebp)
 4a0:	85 c0                	test   %eax,%eax
 4a2:	7f dc                	jg     480 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a7:	c9                   	leave  
 4a8:	c3                   	ret    

000004a9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4a9:	b8 01 00 00 00       	mov    $0x1,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <exit>:
SYSCALL(exit)
 4b1:	b8 02 00 00 00       	mov    $0x2,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <wait>:
SYSCALL(wait)
 4b9:	b8 03 00 00 00       	mov    $0x3,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <pipe>:
SYSCALL(pipe)
 4c1:	b8 04 00 00 00       	mov    $0x4,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <read>:
SYSCALL(read)
 4c9:	b8 05 00 00 00       	mov    $0x5,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <write>:
SYSCALL(write)
 4d1:	b8 10 00 00 00       	mov    $0x10,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <close>:
SYSCALL(close)
 4d9:	b8 15 00 00 00       	mov    $0x15,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <kill>:
SYSCALL(kill)
 4e1:	b8 06 00 00 00       	mov    $0x6,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <exec>:
SYSCALL(exec)
 4e9:	b8 07 00 00 00       	mov    $0x7,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <open>:
SYSCALL(open)
 4f1:	b8 0f 00 00 00       	mov    $0xf,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <mknod>:
SYSCALL(mknod)
 4f9:	b8 11 00 00 00       	mov    $0x11,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <unlink>:
SYSCALL(unlink)
 501:	b8 12 00 00 00       	mov    $0x12,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <fstat>:
SYSCALL(fstat)
 509:	b8 08 00 00 00       	mov    $0x8,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <link>:
SYSCALL(link)
 511:	b8 13 00 00 00       	mov    $0x13,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <mkdir>:
SYSCALL(mkdir)
 519:	b8 14 00 00 00       	mov    $0x14,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <chdir>:
SYSCALL(chdir)
 521:	b8 09 00 00 00       	mov    $0x9,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <dup>:
SYSCALL(dup)
 529:	b8 0a 00 00 00       	mov    $0xa,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <getpid>:
SYSCALL(getpid)
 531:	b8 0b 00 00 00       	mov    $0xb,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <sbrk>:
SYSCALL(sbrk)
 539:	b8 0c 00 00 00       	mov    $0xc,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <sleep>:
SYSCALL(sleep)
 541:	b8 0d 00 00 00       	mov    $0xd,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <uptime>:
SYSCALL(uptime)
 549:	b8 0e 00 00 00       	mov    $0xe,%eax
 54e:	cd 40                	int    $0x40
 550:	c3                   	ret    

00000551 <pstat>:
SYSCALL(pstat)
 551:	b8 16 00 00 00       	mov    $0x16,%eax
 556:	cd 40                	int    $0x40
 558:	c3                   	ret    

00000559 <printjob>:
SYSCALL(printjob)
 559:	b8 17 00 00 00       	mov    $0x17,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <attachjob>:
SYSCALL(attachjob)
 561:	b8 18 00 00 00       	mov    $0x18,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 569:	55                   	push   %ebp
 56a:	89 e5                	mov    %esp,%ebp
 56c:	83 ec 18             	sub    $0x18,%esp
 56f:	8b 45 0c             	mov    0xc(%ebp),%eax
 572:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 575:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 57c:	00 
 57d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 580:	89 44 24 04          	mov    %eax,0x4(%esp)
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	89 04 24             	mov    %eax,(%esp)
 58a:	e8 42 ff ff ff       	call   4d1 <write>
}
 58f:	c9                   	leave  
 590:	c3                   	ret    

00000591 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 591:	55                   	push   %ebp
 592:	89 e5                	mov    %esp,%ebp
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
 596:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 599:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5a0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5a4:	74 17                	je     5bd <printint+0x2c>
 5a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5aa:	79 11                	jns    5bd <printint+0x2c>
    neg = 1;
 5ac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b6:	f7 d8                	neg    %eax
 5b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5bb:	eb 06                	jmp    5c3 <printint+0x32>
  } else {
    x = xx;
 5bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5ca:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5cd:	8d 41 01             	lea    0x1(%ecx),%eax
 5d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5d9:	ba 00 00 00 00       	mov    $0x0,%edx
 5de:	f7 f3                	div    %ebx
 5e0:	89 d0                	mov    %edx,%eax
 5e2:	0f b6 80 ec 0c 00 00 	movzbl 0xcec(%eax),%eax
 5e9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5ed:	8b 75 10             	mov    0x10(%ebp),%esi
 5f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5f3:	ba 00 00 00 00       	mov    $0x0,%edx
 5f8:	f7 f6                	div    %esi
 5fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 601:	75 c7                	jne    5ca <printint+0x39>
  if(neg)
 603:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 607:	74 10                	je     619 <printint+0x88>
    buf[i++] = '-';
 609:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60c:	8d 50 01             	lea    0x1(%eax),%edx
 60f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 612:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 617:	eb 1f                	jmp    638 <printint+0xa7>
 619:	eb 1d                	jmp    638 <printint+0xa7>
    putc(fd, buf[i]);
 61b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 61e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 621:	01 d0                	add    %edx,%eax
 623:	0f b6 00             	movzbl (%eax),%eax
 626:	0f be c0             	movsbl %al,%eax
 629:	89 44 24 04          	mov    %eax,0x4(%esp)
 62d:	8b 45 08             	mov    0x8(%ebp),%eax
 630:	89 04 24             	mov    %eax,(%esp)
 633:	e8 31 ff ff ff       	call   569 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 638:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 63c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 640:	79 d9                	jns    61b <printint+0x8a>
    putc(fd, buf[i]);
}
 642:	83 c4 30             	add    $0x30,%esp
 645:	5b                   	pop    %ebx
 646:	5e                   	pop    %esi
 647:	5d                   	pop    %ebp
 648:	c3                   	ret    

00000649 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 649:	55                   	push   %ebp
 64a:	89 e5                	mov    %esp,%ebp
 64c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 64f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 656:	8d 45 0c             	lea    0xc(%ebp),%eax
 659:	83 c0 04             	add    $0x4,%eax
 65c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 65f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 666:	e9 7c 01 00 00       	jmp    7e7 <printf+0x19e>
    c = fmt[i] & 0xff;
 66b:	8b 55 0c             	mov    0xc(%ebp),%edx
 66e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 671:	01 d0                	add    %edx,%eax
 673:	0f b6 00             	movzbl (%eax),%eax
 676:	0f be c0             	movsbl %al,%eax
 679:	25 ff 00 00 00       	and    $0xff,%eax
 67e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 681:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 685:	75 2c                	jne    6b3 <printf+0x6a>
      if(c == '%'){
 687:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 68b:	75 0c                	jne    699 <printf+0x50>
        state = '%';
 68d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 694:	e9 4a 01 00 00       	jmp    7e3 <printf+0x19a>
      } else {
        putc(fd, c);
 699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69c:	0f be c0             	movsbl %al,%eax
 69f:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a3:	8b 45 08             	mov    0x8(%ebp),%eax
 6a6:	89 04 24             	mov    %eax,(%esp)
 6a9:	e8 bb fe ff ff       	call   569 <putc>
 6ae:	e9 30 01 00 00       	jmp    7e3 <printf+0x19a>
      }
    } else if(state == '%'){
 6b3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6b7:	0f 85 26 01 00 00    	jne    7e3 <printf+0x19a>
      if(c == 'd'){
 6bd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6c1:	75 2d                	jne    6f0 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 6c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c6:	8b 00                	mov    (%eax),%eax
 6c8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6cf:	00 
 6d0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6d7:	00 
 6d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	89 04 24             	mov    %eax,(%esp)
 6e2:	e8 aa fe ff ff       	call   591 <printint>
        ap++;
 6e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6eb:	e9 ec 00 00 00       	jmp    7dc <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 6f0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6f4:	74 06                	je     6fc <printf+0xb3>
 6f6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6fa:	75 2d                	jne    729 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ff:	8b 00                	mov    (%eax),%eax
 701:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 708:	00 
 709:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 710:	00 
 711:	89 44 24 04          	mov    %eax,0x4(%esp)
 715:	8b 45 08             	mov    0x8(%ebp),%eax
 718:	89 04 24             	mov    %eax,(%esp)
 71b:	e8 71 fe ff ff       	call   591 <printint>
        ap++;
 720:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 724:	e9 b3 00 00 00       	jmp    7dc <printf+0x193>
      } else if(c == 's'){
 729:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 72d:	75 45                	jne    774 <printf+0x12b>
        s = (char*)*ap;
 72f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 732:	8b 00                	mov    (%eax),%eax
 734:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 737:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 73b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 73f:	75 09                	jne    74a <printf+0x101>
          s = "(null)";
 741:	c7 45 f4 81 0a 00 00 	movl   $0xa81,-0xc(%ebp)
        while(*s != 0){
 748:	eb 1e                	jmp    768 <printf+0x11f>
 74a:	eb 1c                	jmp    768 <printf+0x11f>
          putc(fd, *s);
 74c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74f:	0f b6 00             	movzbl (%eax),%eax
 752:	0f be c0             	movsbl %al,%eax
 755:	89 44 24 04          	mov    %eax,0x4(%esp)
 759:	8b 45 08             	mov    0x8(%ebp),%eax
 75c:	89 04 24             	mov    %eax,(%esp)
 75f:	e8 05 fe ff ff       	call   569 <putc>
          s++;
 764:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	0f b6 00             	movzbl (%eax),%eax
 76e:	84 c0                	test   %al,%al
 770:	75 da                	jne    74c <printf+0x103>
 772:	eb 68                	jmp    7dc <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 774:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 778:	75 1d                	jne    797 <printf+0x14e>
        putc(fd, *ap);
 77a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 77d:	8b 00                	mov    (%eax),%eax
 77f:	0f be c0             	movsbl %al,%eax
 782:	89 44 24 04          	mov    %eax,0x4(%esp)
 786:	8b 45 08             	mov    0x8(%ebp),%eax
 789:	89 04 24             	mov    %eax,(%esp)
 78c:	e8 d8 fd ff ff       	call   569 <putc>
        ap++;
 791:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 795:	eb 45                	jmp    7dc <printf+0x193>
      } else if(c == '%'){
 797:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 79b:	75 17                	jne    7b4 <printf+0x16b>
        putc(fd, c);
 79d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a0:	0f be c0             	movsbl %al,%eax
 7a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a7:	8b 45 08             	mov    0x8(%ebp),%eax
 7aa:	89 04 24             	mov    %eax,(%esp)
 7ad:	e8 b7 fd ff ff       	call   569 <putc>
 7b2:	eb 28                	jmp    7dc <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7b4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7bb:	00 
 7bc:	8b 45 08             	mov    0x8(%ebp),%eax
 7bf:	89 04 24             	mov    %eax,(%esp)
 7c2:	e8 a2 fd ff ff       	call   569 <putc>
        putc(fd, c);
 7c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ca:	0f be c0             	movsbl %al,%eax
 7cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d1:	8b 45 08             	mov    0x8(%ebp),%eax
 7d4:	89 04 24             	mov    %eax,(%esp)
 7d7:	e8 8d fd ff ff       	call   569 <putc>
      }
      state = 0;
 7dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7e3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7e7:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ed:	01 d0                	add    %edx,%eax
 7ef:	0f b6 00             	movzbl (%eax),%eax
 7f2:	84 c0                	test   %al,%al
 7f4:	0f 85 71 fe ff ff    	jne    66b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7fa:	c9                   	leave  
 7fb:	c3                   	ret    

000007fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fc:	55                   	push   %ebp
 7fd:	89 e5                	mov    %esp,%ebp
 7ff:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 802:	8b 45 08             	mov    0x8(%ebp),%eax
 805:	83 e8 08             	sub    $0x8,%eax
 808:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80b:	a1 08 0d 00 00       	mov    0xd08,%eax
 810:	89 45 fc             	mov    %eax,-0x4(%ebp)
 813:	eb 24                	jmp    839 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 815:	8b 45 fc             	mov    -0x4(%ebp),%eax
 818:	8b 00                	mov    (%eax),%eax
 81a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 81d:	77 12                	ja     831 <free+0x35>
 81f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 822:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 825:	77 24                	ja     84b <free+0x4f>
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82a:	8b 00                	mov    (%eax),%eax
 82c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 82f:	77 1a                	ja     84b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	8b 00                	mov    (%eax),%eax
 836:	89 45 fc             	mov    %eax,-0x4(%ebp)
 839:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 83f:	76 d4                	jbe    815 <free+0x19>
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	8b 00                	mov    (%eax),%eax
 846:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 849:	76 ca                	jbe    815 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 84b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84e:	8b 40 04             	mov    0x4(%eax),%eax
 851:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 858:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85b:	01 c2                	add    %eax,%edx
 85d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 860:	8b 00                	mov    (%eax),%eax
 862:	39 c2                	cmp    %eax,%edx
 864:	75 24                	jne    88a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 866:	8b 45 f8             	mov    -0x8(%ebp),%eax
 869:	8b 50 04             	mov    0x4(%eax),%edx
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	8b 40 04             	mov    0x4(%eax),%eax
 874:	01 c2                	add    %eax,%edx
 876:	8b 45 f8             	mov    -0x8(%ebp),%eax
 879:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 87c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87f:	8b 00                	mov    (%eax),%eax
 881:	8b 10                	mov    (%eax),%edx
 883:	8b 45 f8             	mov    -0x8(%ebp),%eax
 886:	89 10                	mov    %edx,(%eax)
 888:	eb 0a                	jmp    894 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 88a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88d:	8b 10                	mov    (%eax),%edx
 88f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 892:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 894:	8b 45 fc             	mov    -0x4(%ebp),%eax
 897:	8b 40 04             	mov    0x4(%eax),%eax
 89a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a4:	01 d0                	add    %edx,%eax
 8a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8a9:	75 20                	jne    8cb <free+0xcf>
    p->s.size += bp->s.size;
 8ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ae:	8b 50 04             	mov    0x4(%eax),%edx
 8b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b4:	8b 40 04             	mov    0x4(%eax),%eax
 8b7:	01 c2                	add    %eax,%edx
 8b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c2:	8b 10                	mov    (%eax),%edx
 8c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c7:	89 10                	mov    %edx,(%eax)
 8c9:	eb 08                	jmp    8d3 <free+0xd7>
  } else
    p->s.ptr = bp;
 8cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ce:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8d1:	89 10                	mov    %edx,(%eax)
  freep = p;
 8d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d6:	a3 08 0d 00 00       	mov    %eax,0xd08
}
 8db:	c9                   	leave  
 8dc:	c3                   	ret    

000008dd <morecore>:

static Header*
morecore(uint nu)
{
 8dd:	55                   	push   %ebp
 8de:	89 e5                	mov    %esp,%ebp
 8e0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8e3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8ea:	77 07                	ja     8f3 <morecore+0x16>
    nu = 4096;
 8ec:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8f3:	8b 45 08             	mov    0x8(%ebp),%eax
 8f6:	c1 e0 03             	shl    $0x3,%eax
 8f9:	89 04 24             	mov    %eax,(%esp)
 8fc:	e8 38 fc ff ff       	call   539 <sbrk>
 901:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 904:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 908:	75 07                	jne    911 <morecore+0x34>
    return 0;
 90a:	b8 00 00 00 00       	mov    $0x0,%eax
 90f:	eb 22                	jmp    933 <morecore+0x56>
  hp = (Header*)p;
 911:	8b 45 f4             	mov    -0xc(%ebp),%eax
 914:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 917:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91a:	8b 55 08             	mov    0x8(%ebp),%edx
 91d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 920:	8b 45 f0             	mov    -0x10(%ebp),%eax
 923:	83 c0 08             	add    $0x8,%eax
 926:	89 04 24             	mov    %eax,(%esp)
 929:	e8 ce fe ff ff       	call   7fc <free>
  return freep;
 92e:	a1 08 0d 00 00       	mov    0xd08,%eax
}
 933:	c9                   	leave  
 934:	c3                   	ret    

00000935 <malloc>:

void*
malloc(uint nbytes)
{
 935:	55                   	push   %ebp
 936:	89 e5                	mov    %esp,%ebp
 938:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 93b:	8b 45 08             	mov    0x8(%ebp),%eax
 93e:	83 c0 07             	add    $0x7,%eax
 941:	c1 e8 03             	shr    $0x3,%eax
 944:	83 c0 01             	add    $0x1,%eax
 947:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 94a:	a1 08 0d 00 00       	mov    0xd08,%eax
 94f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 952:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 956:	75 23                	jne    97b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 958:	c7 45 f0 00 0d 00 00 	movl   $0xd00,-0x10(%ebp)
 95f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 962:	a3 08 0d 00 00       	mov    %eax,0xd08
 967:	a1 08 0d 00 00       	mov    0xd08,%eax
 96c:	a3 00 0d 00 00       	mov    %eax,0xd00
    base.s.size = 0;
 971:	c7 05 04 0d 00 00 00 	movl   $0x0,0xd04
 978:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97e:	8b 00                	mov    (%eax),%eax
 980:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 983:	8b 45 f4             	mov    -0xc(%ebp),%eax
 986:	8b 40 04             	mov    0x4(%eax),%eax
 989:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 98c:	72 4d                	jb     9db <malloc+0xa6>
      if(p->s.size == nunits)
 98e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 991:	8b 40 04             	mov    0x4(%eax),%eax
 994:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 997:	75 0c                	jne    9a5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 999:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99c:	8b 10                	mov    (%eax),%edx
 99e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a1:	89 10                	mov    %edx,(%eax)
 9a3:	eb 26                	jmp    9cb <malloc+0x96>
      else {
        p->s.size -= nunits;
 9a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a8:	8b 40 04             	mov    0x4(%eax),%eax
 9ab:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9ae:	89 c2                	mov    %eax,%edx
 9b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b9:	8b 40 04             	mov    0x4(%eax),%eax
 9bc:	c1 e0 03             	shl    $0x3,%eax
 9bf:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9c8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ce:	a3 08 0d 00 00       	mov    %eax,0xd08
      return (void*)(p + 1);
 9d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d6:	83 c0 08             	add    $0x8,%eax
 9d9:	eb 38                	jmp    a13 <malloc+0xde>
    }
    if(p == freep)
 9db:	a1 08 0d 00 00       	mov    0xd08,%eax
 9e0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9e3:	75 1b                	jne    a00 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9e8:	89 04 24             	mov    %eax,(%esp)
 9eb:	e8 ed fe ff ff       	call   8dd <morecore>
 9f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9f7:	75 07                	jne    a00 <malloc+0xcb>
        return 0;
 9f9:	b8 00 00 00 00       	mov    $0x0,%eax
 9fe:	eb 13                	jmp    a13 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a09:	8b 00                	mov    (%eax),%eax
 a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a0e:	e9 70 ff ff ff       	jmp    983 <malloc+0x4e>
}
 a13:	c9                   	leave  
 a14:	c3                   	ret    
