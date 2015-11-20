
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
   f:	c7 44 24 04 40 0d 00 	movl   $0xd40,0x4(%esp)
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
  2b:	c7 44 24 04 40 0d 00 	movl   $0xd40,0x4(%esp)
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
  4d:	c7 44 24 04 25 0a 00 	movl   $0xa25,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 f8 05 00 00       	call   659 <printf>
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
  e6:	c7 44 24 04 36 0a 00 	movl   $0xa36,0x4(%esp)
  ed:	00 
  ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f5:	e8 5f 05 00 00       	call   659 <printf>
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
 137:	e8 09 08 00 00       	call   945 <malloc>
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
 160:	c7 44 24 04 4b 0a 00 	movl   $0xa4b,0x4(%esp)
 167:	00 
 168:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 16f:	e8 e5 04 00 00       	call   659 <printf>
  printf(1,"name: ");  printf(1,"%s ",stat->name);
 174:	c7 44 24 04 66 0a 00 	movl   $0xa66,0x4(%esp)
 17b:	00 
 17c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 183:	e8 d1 04 00 00       	call   659 <printf>
 188:	8b 44 24 14          	mov    0x14(%esp),%eax
 18c:	89 44 24 08          	mov    %eax,0x8(%esp)
 190:	c7 44 24 04 6d 0a 00 	movl   $0xa6d,0x4(%esp)
 197:	00 
 198:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 19f:	e8 b5 04 00 00       	call   659 <printf>
  printf(1,"state: "); printf(1,"%d ",stat->state);
 1a4:	c7 44 24 04 71 0a 00 	movl   $0xa71,0x4(%esp)
 1ab:	00 
 1ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b3:	e8 a1 04 00 00       	call   659 <printf>
 1b8:	8b 44 24 14          	mov    0x14(%esp),%eax
 1bc:	8b 40 18             	mov    0x18(%eax),%eax
 1bf:	89 44 24 08          	mov    %eax,0x8(%esp)
 1c3:	c7 44 24 04 79 0a 00 	movl   $0xa79,0x4(%esp)
 1ca:	00 
 1cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d2:	e8 82 04 00 00       	call   659 <printf>
  printf(1,"sz: "); printf(1,"%d ",stat->sz);
 1d7:	c7 44 24 04 7d 0a 00 	movl   $0xa7d,0x4(%esp)
 1de:	00 
 1df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1e6:	e8 6e 04 00 00       	call   659 <printf>
 1eb:	8b 44 24 14          	mov    0x14(%esp),%eax
 1ef:	8b 40 10             	mov    0x10(%eax),%eax
 1f2:	89 44 24 08          	mov    %eax,0x8(%esp)
 1f6:	c7 44 24 04 79 0a 00 	movl   $0xa79,0x4(%esp)
 1fd:	00 
 1fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 205:	e8 4f 04 00 00       	call   659 <printf>
  printf(1,"nofile: "); printf(1," %d\n ",stat->nofile);
 20a:	c7 44 24 04 82 0a 00 	movl   $0xa82,0x4(%esp)
 211:	00 
 212:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 219:	e8 3b 04 00 00       	call   659 <printf>
 21e:	8b 44 24 14          	mov    0x14(%esp),%eax
 222:	8b 40 14             	mov    0x14(%eax),%eax
 225:	89 44 24 08          	mov    %eax,0x8(%esp)
 229:	c7 44 24 04 8b 0a 00 	movl   $0xa8b,0x4(%esp)
 230:	00 
 231:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 238:	e8 1c 04 00 00       	call   659 <printf>

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

00000569 <fg>:
SYSCALL (fg)
 569:	b8 19 00 00 00       	mov    $0x19,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <waitpid>:
SYSCALL(waitpid)
 571:	b8 1a 00 00 00       	mov    $0x1a,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 579:	55                   	push   %ebp
 57a:	89 e5                	mov    %esp,%ebp
 57c:	83 ec 18             	sub    $0x18,%esp
 57f:	8b 45 0c             	mov    0xc(%ebp),%eax
 582:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 585:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 58c:	00 
 58d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 590:	89 44 24 04          	mov    %eax,0x4(%esp)
 594:	8b 45 08             	mov    0x8(%ebp),%eax
 597:	89 04 24             	mov    %eax,(%esp)
 59a:	e8 32 ff ff ff       	call   4d1 <write>
}
 59f:	c9                   	leave  
 5a0:	c3                   	ret    

000005a1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a1:	55                   	push   %ebp
 5a2:	89 e5                	mov    %esp,%ebp
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
 5a6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5b0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5b4:	74 17                	je     5cd <printint+0x2c>
 5b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5ba:	79 11                	jns    5cd <printint+0x2c>
    neg = 1;
 5bc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c6:	f7 d8                	neg    %eax
 5c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5cb:	eb 06                	jmp    5d3 <printint+0x32>
  } else {
    x = xx;
 5cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5da:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5dd:	8d 41 01             	lea    0x1(%ecx),%eax
 5e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5e9:	ba 00 00 00 00       	mov    $0x0,%edx
 5ee:	f7 f3                	div    %ebx
 5f0:	89 d0                	mov    %edx,%eax
 5f2:	0f b6 80 fc 0c 00 00 	movzbl 0xcfc(%eax),%eax
 5f9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5fd:	8b 75 10             	mov    0x10(%ebp),%esi
 600:	8b 45 ec             	mov    -0x14(%ebp),%eax
 603:	ba 00 00 00 00       	mov    $0x0,%edx
 608:	f7 f6                	div    %esi
 60a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 60d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 611:	75 c7                	jne    5da <printint+0x39>
  if(neg)
 613:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 617:	74 10                	je     629 <printint+0x88>
    buf[i++] = '-';
 619:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61c:	8d 50 01             	lea    0x1(%eax),%edx
 61f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 622:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 627:	eb 1f                	jmp    648 <printint+0xa7>
 629:	eb 1d                	jmp    648 <printint+0xa7>
    putc(fd, buf[i]);
 62b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 62e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 631:	01 d0                	add    %edx,%eax
 633:	0f b6 00             	movzbl (%eax),%eax
 636:	0f be c0             	movsbl %al,%eax
 639:	89 44 24 04          	mov    %eax,0x4(%esp)
 63d:	8b 45 08             	mov    0x8(%ebp),%eax
 640:	89 04 24             	mov    %eax,(%esp)
 643:	e8 31 ff ff ff       	call   579 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 648:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 64c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 650:	79 d9                	jns    62b <printint+0x8a>
    putc(fd, buf[i]);
}
 652:	83 c4 30             	add    $0x30,%esp
 655:	5b                   	pop    %ebx
 656:	5e                   	pop    %esi
 657:	5d                   	pop    %ebp
 658:	c3                   	ret    

00000659 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 659:	55                   	push   %ebp
 65a:	89 e5                	mov    %esp,%ebp
 65c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 65f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 666:	8d 45 0c             	lea    0xc(%ebp),%eax
 669:	83 c0 04             	add    $0x4,%eax
 66c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 66f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 676:	e9 7c 01 00 00       	jmp    7f7 <printf+0x19e>
    c = fmt[i] & 0xff;
 67b:	8b 55 0c             	mov    0xc(%ebp),%edx
 67e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 681:	01 d0                	add    %edx,%eax
 683:	0f b6 00             	movzbl (%eax),%eax
 686:	0f be c0             	movsbl %al,%eax
 689:	25 ff 00 00 00       	and    $0xff,%eax
 68e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 691:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 695:	75 2c                	jne    6c3 <printf+0x6a>
      if(c == '%'){
 697:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 69b:	75 0c                	jne    6a9 <printf+0x50>
        state = '%';
 69d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6a4:	e9 4a 01 00 00       	jmp    7f3 <printf+0x19a>
      } else {
        putc(fd, c);
 6a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ac:	0f be c0             	movsbl %al,%eax
 6af:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b3:	8b 45 08             	mov    0x8(%ebp),%eax
 6b6:	89 04 24             	mov    %eax,(%esp)
 6b9:	e8 bb fe ff ff       	call   579 <putc>
 6be:	e9 30 01 00 00       	jmp    7f3 <printf+0x19a>
      }
    } else if(state == '%'){
 6c3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6c7:	0f 85 26 01 00 00    	jne    7f3 <printf+0x19a>
      if(c == 'd'){
 6cd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6d1:	75 2d                	jne    700 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 6d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d6:	8b 00                	mov    (%eax),%eax
 6d8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6df:	00 
 6e0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6e7:	00 
 6e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ec:	8b 45 08             	mov    0x8(%ebp),%eax
 6ef:	89 04 24             	mov    %eax,(%esp)
 6f2:	e8 aa fe ff ff       	call   5a1 <printint>
        ap++;
 6f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6fb:	e9 ec 00 00 00       	jmp    7ec <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 700:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 704:	74 06                	je     70c <printf+0xb3>
 706:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 70a:	75 2d                	jne    739 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 70c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70f:	8b 00                	mov    (%eax),%eax
 711:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 718:	00 
 719:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 720:	00 
 721:	89 44 24 04          	mov    %eax,0x4(%esp)
 725:	8b 45 08             	mov    0x8(%ebp),%eax
 728:	89 04 24             	mov    %eax,(%esp)
 72b:	e8 71 fe ff ff       	call   5a1 <printint>
        ap++;
 730:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 734:	e9 b3 00 00 00       	jmp    7ec <printf+0x193>
      } else if(c == 's'){
 739:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 73d:	75 45                	jne    784 <printf+0x12b>
        s = (char*)*ap;
 73f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 742:	8b 00                	mov    (%eax),%eax
 744:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 747:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 74b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 74f:	75 09                	jne    75a <printf+0x101>
          s = "(null)";
 751:	c7 45 f4 91 0a 00 00 	movl   $0xa91,-0xc(%ebp)
        while(*s != 0){
 758:	eb 1e                	jmp    778 <printf+0x11f>
 75a:	eb 1c                	jmp    778 <printf+0x11f>
          putc(fd, *s);
 75c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75f:	0f b6 00             	movzbl (%eax),%eax
 762:	0f be c0             	movsbl %al,%eax
 765:	89 44 24 04          	mov    %eax,0x4(%esp)
 769:	8b 45 08             	mov    0x8(%ebp),%eax
 76c:	89 04 24             	mov    %eax,(%esp)
 76f:	e8 05 fe ff ff       	call   579 <putc>
          s++;
 774:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	0f b6 00             	movzbl (%eax),%eax
 77e:	84 c0                	test   %al,%al
 780:	75 da                	jne    75c <printf+0x103>
 782:	eb 68                	jmp    7ec <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 784:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 788:	75 1d                	jne    7a7 <printf+0x14e>
        putc(fd, *ap);
 78a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 78d:	8b 00                	mov    (%eax),%eax
 78f:	0f be c0             	movsbl %al,%eax
 792:	89 44 24 04          	mov    %eax,0x4(%esp)
 796:	8b 45 08             	mov    0x8(%ebp),%eax
 799:	89 04 24             	mov    %eax,(%esp)
 79c:	e8 d8 fd ff ff       	call   579 <putc>
        ap++;
 7a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a5:	eb 45                	jmp    7ec <printf+0x193>
      } else if(c == '%'){
 7a7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ab:	75 17                	jne    7c4 <printf+0x16b>
        putc(fd, c);
 7ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b0:	0f be c0             	movsbl %al,%eax
 7b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ba:	89 04 24             	mov    %eax,(%esp)
 7bd:	e8 b7 fd ff ff       	call   579 <putc>
 7c2:	eb 28                	jmp    7ec <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7c4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7cb:	00 
 7cc:	8b 45 08             	mov    0x8(%ebp),%eax
 7cf:	89 04 24             	mov    %eax,(%esp)
 7d2:	e8 a2 fd ff ff       	call   579 <putc>
        putc(fd, c);
 7d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7da:	0f be c0             	movsbl %al,%eax
 7dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e1:	8b 45 08             	mov    0x8(%ebp),%eax
 7e4:	89 04 24             	mov    %eax,(%esp)
 7e7:	e8 8d fd ff ff       	call   579 <putc>
      }
      state = 0;
 7ec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7f3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7f7:	8b 55 0c             	mov    0xc(%ebp),%edx
 7fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fd:	01 d0                	add    %edx,%eax
 7ff:	0f b6 00             	movzbl (%eax),%eax
 802:	84 c0                	test   %al,%al
 804:	0f 85 71 fe ff ff    	jne    67b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 80a:	c9                   	leave  
 80b:	c3                   	ret    

0000080c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80c:	55                   	push   %ebp
 80d:	89 e5                	mov    %esp,%ebp
 80f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 812:	8b 45 08             	mov    0x8(%ebp),%eax
 815:	83 e8 08             	sub    $0x8,%eax
 818:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81b:	a1 28 0d 00 00       	mov    0xd28,%eax
 820:	89 45 fc             	mov    %eax,-0x4(%ebp)
 823:	eb 24                	jmp    849 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 825:	8b 45 fc             	mov    -0x4(%ebp),%eax
 828:	8b 00                	mov    (%eax),%eax
 82a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 82d:	77 12                	ja     841 <free+0x35>
 82f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 832:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 835:	77 24                	ja     85b <free+0x4f>
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	8b 00                	mov    (%eax),%eax
 83c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 83f:	77 1a                	ja     85b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	8b 00                	mov    (%eax),%eax
 846:	89 45 fc             	mov    %eax,-0x4(%ebp)
 849:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 84f:	76 d4                	jbe    825 <free+0x19>
 851:	8b 45 fc             	mov    -0x4(%ebp),%eax
 854:	8b 00                	mov    (%eax),%eax
 856:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 859:	76 ca                	jbe    825 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 85b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85e:	8b 40 04             	mov    0x4(%eax),%eax
 861:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 868:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86b:	01 c2                	add    %eax,%edx
 86d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 870:	8b 00                	mov    (%eax),%eax
 872:	39 c2                	cmp    %eax,%edx
 874:	75 24                	jne    89a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 876:	8b 45 f8             	mov    -0x8(%ebp),%eax
 879:	8b 50 04             	mov    0x4(%eax),%edx
 87c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87f:	8b 00                	mov    (%eax),%eax
 881:	8b 40 04             	mov    0x4(%eax),%eax
 884:	01 c2                	add    %eax,%edx
 886:	8b 45 f8             	mov    -0x8(%ebp),%eax
 889:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 88c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88f:	8b 00                	mov    (%eax),%eax
 891:	8b 10                	mov    (%eax),%edx
 893:	8b 45 f8             	mov    -0x8(%ebp),%eax
 896:	89 10                	mov    %edx,(%eax)
 898:	eb 0a                	jmp    8a4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 89a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89d:	8b 10                	mov    (%eax),%edx
 89f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a7:	8b 40 04             	mov    0x4(%eax),%eax
 8aa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b4:	01 d0                	add    %edx,%eax
 8b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8b9:	75 20                	jne    8db <free+0xcf>
    p->s.size += bp->s.size;
 8bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8be:	8b 50 04             	mov    0x4(%eax),%edx
 8c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c4:	8b 40 04             	mov    0x4(%eax),%eax
 8c7:	01 c2                	add    %eax,%edx
 8c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d2:	8b 10                	mov    (%eax),%edx
 8d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d7:	89 10                	mov    %edx,(%eax)
 8d9:	eb 08                	jmp    8e3 <free+0xd7>
  } else
    p->s.ptr = bp;
 8db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8de:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8e1:	89 10                	mov    %edx,(%eax)
  freep = p;
 8e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e6:	a3 28 0d 00 00       	mov    %eax,0xd28
}
 8eb:	c9                   	leave  
 8ec:	c3                   	ret    

000008ed <morecore>:

static Header*
morecore(uint nu)
{
 8ed:	55                   	push   %ebp
 8ee:	89 e5                	mov    %esp,%ebp
 8f0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8f3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8fa:	77 07                	ja     903 <morecore+0x16>
    nu = 4096;
 8fc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 903:	8b 45 08             	mov    0x8(%ebp),%eax
 906:	c1 e0 03             	shl    $0x3,%eax
 909:	89 04 24             	mov    %eax,(%esp)
 90c:	e8 28 fc ff ff       	call   539 <sbrk>
 911:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 914:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 918:	75 07                	jne    921 <morecore+0x34>
    return 0;
 91a:	b8 00 00 00 00       	mov    $0x0,%eax
 91f:	eb 22                	jmp    943 <morecore+0x56>
  hp = (Header*)p;
 921:	8b 45 f4             	mov    -0xc(%ebp),%eax
 924:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 927:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92a:	8b 55 08             	mov    0x8(%ebp),%edx
 92d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 930:	8b 45 f0             	mov    -0x10(%ebp),%eax
 933:	83 c0 08             	add    $0x8,%eax
 936:	89 04 24             	mov    %eax,(%esp)
 939:	e8 ce fe ff ff       	call   80c <free>
  return freep;
 93e:	a1 28 0d 00 00       	mov    0xd28,%eax
}
 943:	c9                   	leave  
 944:	c3                   	ret    

00000945 <malloc>:

void*
malloc(uint nbytes)
{
 945:	55                   	push   %ebp
 946:	89 e5                	mov    %esp,%ebp
 948:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 94b:	8b 45 08             	mov    0x8(%ebp),%eax
 94e:	83 c0 07             	add    $0x7,%eax
 951:	c1 e8 03             	shr    $0x3,%eax
 954:	83 c0 01             	add    $0x1,%eax
 957:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 95a:	a1 28 0d 00 00       	mov    0xd28,%eax
 95f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 962:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 966:	75 23                	jne    98b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 968:	c7 45 f0 20 0d 00 00 	movl   $0xd20,-0x10(%ebp)
 96f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 972:	a3 28 0d 00 00       	mov    %eax,0xd28
 977:	a1 28 0d 00 00       	mov    0xd28,%eax
 97c:	a3 20 0d 00 00       	mov    %eax,0xd20
    base.s.size = 0;
 981:	c7 05 24 0d 00 00 00 	movl   $0x0,0xd24
 988:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98e:	8b 00                	mov    (%eax),%eax
 990:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 993:	8b 45 f4             	mov    -0xc(%ebp),%eax
 996:	8b 40 04             	mov    0x4(%eax),%eax
 999:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 99c:	72 4d                	jb     9eb <malloc+0xa6>
      if(p->s.size == nunits)
 99e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a1:	8b 40 04             	mov    0x4(%eax),%eax
 9a4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9a7:	75 0c                	jne    9b5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ac:	8b 10                	mov    (%eax),%edx
 9ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b1:	89 10                	mov    %edx,(%eax)
 9b3:	eb 26                	jmp    9db <malloc+0x96>
      else {
        p->s.size -= nunits;
 9b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b8:	8b 40 04             	mov    0x4(%eax),%eax
 9bb:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9be:	89 c2                	mov    %eax,%edx
 9c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c9:	8b 40 04             	mov    0x4(%eax),%eax
 9cc:	c1 e0 03             	shl    $0x3,%eax
 9cf:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9d8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9de:	a3 28 0d 00 00       	mov    %eax,0xd28
      return (void*)(p + 1);
 9e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e6:	83 c0 08             	add    $0x8,%eax
 9e9:	eb 38                	jmp    a23 <malloc+0xde>
    }
    if(p == freep)
 9eb:	a1 28 0d 00 00       	mov    0xd28,%eax
 9f0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9f3:	75 1b                	jne    a10 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9f8:	89 04 24             	mov    %eax,(%esp)
 9fb:	e8 ed fe ff ff       	call   8ed <morecore>
 a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a07:	75 07                	jne    a10 <malloc+0xcb>
        return 0;
 a09:	b8 00 00 00 00       	mov    $0x0,%eax
 a0e:	eb 13                	jmp    a23 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a19:	8b 00                	mov    (%eax),%eax
 a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a1e:	e9 70 ff ff ff       	jmp    993 <malloc+0x4e>
}
 a23:	c9                   	leave  
 a24:	c3                   	ret    
