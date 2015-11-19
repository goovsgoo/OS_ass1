
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 7c 02 00 00       	call   28a <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 04 03 00 00       	call   322 <sleep>
  exit(0);
  1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  25:	e8 68 02 00 00       	call   292 <exit>

0000002a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2a:	55                   	push   %ebp
  2b:	89 e5                	mov    %esp,%ebp
  2d:	57                   	push   %edi
  2e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  32:	8b 55 10             	mov    0x10(%ebp),%edx
  35:	8b 45 0c             	mov    0xc(%ebp),%eax
  38:	89 cb                	mov    %ecx,%ebx
  3a:	89 df                	mov    %ebx,%edi
  3c:	89 d1                	mov    %edx,%ecx
  3e:	fc                   	cld    
  3f:	f3 aa                	rep stos %al,%es:(%edi)
  41:	89 ca                	mov    %ecx,%edx
  43:	89 fb                	mov    %edi,%ebx
  45:	89 5d 08             	mov    %ebx,0x8(%ebp)
  48:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4b:	5b                   	pop    %ebx
  4c:	5f                   	pop    %edi
  4d:	5d                   	pop    %ebp
  4e:	c3                   	ret    

0000004f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4f:	55                   	push   %ebp
  50:	89 e5                	mov    %esp,%ebp
  52:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  55:	8b 45 08             	mov    0x8(%ebp),%eax
  58:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5b:	90                   	nop
  5c:	8b 45 08             	mov    0x8(%ebp),%eax
  5f:	8d 50 01             	lea    0x1(%eax),%edx
  62:	89 55 08             	mov    %edx,0x8(%ebp)
  65:	8b 55 0c             	mov    0xc(%ebp),%edx
  68:	8d 4a 01             	lea    0x1(%edx),%ecx
  6b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  6e:	0f b6 12             	movzbl (%edx),%edx
  71:	88 10                	mov    %dl,(%eax)
  73:	0f b6 00             	movzbl (%eax),%eax
  76:	84 c0                	test   %al,%al
  78:	75 e2                	jne    5c <strcpy+0xd>
    ;
  return os;
  7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7d:	c9                   	leave  
  7e:	c3                   	ret    

0000007f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7f:	55                   	push   %ebp
  80:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  82:	eb 08                	jmp    8c <strcmp+0xd>
    p++, q++;
  84:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  88:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8c:	8b 45 08             	mov    0x8(%ebp),%eax
  8f:	0f b6 00             	movzbl (%eax),%eax
  92:	84 c0                	test   %al,%al
  94:	74 10                	je     a6 <strcmp+0x27>
  96:	8b 45 08             	mov    0x8(%ebp),%eax
  99:	0f b6 10             	movzbl (%eax),%edx
  9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  9f:	0f b6 00             	movzbl (%eax),%eax
  a2:	38 c2                	cmp    %al,%dl
  a4:	74 de                	je     84 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	0f b6 00             	movzbl (%eax),%eax
  ac:	0f b6 d0             	movzbl %al,%edx
  af:	8b 45 0c             	mov    0xc(%ebp),%eax
  b2:	0f b6 00             	movzbl (%eax),%eax
  b5:	0f b6 c0             	movzbl %al,%eax
  b8:	29 c2                	sub    %eax,%edx
  ba:	89 d0                	mov    %edx,%eax
}
  bc:	5d                   	pop    %ebp
  bd:	c3                   	ret    

000000be <strlen>:

uint
strlen(char *s)
{
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  cb:	eb 04                	jmp    d1 <strlen+0x13>
  cd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	01 d0                	add    %edx,%eax
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	84 c0                	test   %al,%al
  de:	75 ed                	jne    cd <strlen+0xf>
    ;
  return n;
  e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e3:	c9                   	leave  
  e4:	c3                   	ret    

000000e5 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  e8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
  fc:	89 04 24             	mov    %eax,(%esp)
  ff:	e8 26 ff ff ff       	call   2a <stosb>
  return dst;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
}
 107:	c9                   	leave  
 108:	c3                   	ret    

00000109 <strchr>:

char*
strchr(const char *s, char c)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 04             	sub    $0x4,%esp
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 115:	eb 14                	jmp    12b <strchr+0x22>
    if(*s == c)
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 120:	75 05                	jne    127 <strchr+0x1e>
      return (char*)s;
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	eb 13                	jmp    13a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 127:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	84 c0                	test   %al,%al
 133:	75 e2                	jne    117 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 135:	b8 00 00 00 00       	mov    $0x0,%eax
}
 13a:	c9                   	leave  
 13b:	c3                   	ret    

0000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 142:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 149:	eb 4c                	jmp    197 <gets+0x5b>
    cc = read(0, &c, 1);
 14b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 152:	00 
 153:	8d 45 ef             	lea    -0x11(%ebp),%eax
 156:	89 44 24 04          	mov    %eax,0x4(%esp)
 15a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 161:	e8 44 01 00 00       	call   2aa <read>
 166:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 169:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 16d:	7f 02                	jg     171 <gets+0x35>
      break;
 16f:	eb 31                	jmp    1a2 <gets+0x66>
    buf[i++] = c;
 171:	8b 45 f4             	mov    -0xc(%ebp),%eax
 174:	8d 50 01             	lea    0x1(%eax),%edx
 177:	89 55 f4             	mov    %edx,-0xc(%ebp)
 17a:	89 c2                	mov    %eax,%edx
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	01 c2                	add    %eax,%edx
 181:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 185:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 187:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18b:	3c 0a                	cmp    $0xa,%al
 18d:	74 13                	je     1a2 <gets+0x66>
 18f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 193:	3c 0d                	cmp    $0xd,%al
 195:	74 0b                	je     1a2 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 197:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19a:	83 c0 01             	add    $0x1,%eax
 19d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1a0:	7c a9                	jl     14b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a5:	8b 45 08             	mov    0x8(%ebp),%eax
 1a8:	01 d0                	add    %edx,%eax
 1aa:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b0:	c9                   	leave  
 1b1:	c3                   	ret    

000001b2 <stat>:

int
stat(char *n, struct stat *st)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1bf:	00 
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	89 04 24             	mov    %eax,(%esp)
 1c6:	e8 07 01 00 00       	call   2d2 <open>
 1cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1d2:	79 07                	jns    1db <stat+0x29>
    return -1;
 1d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d9:	eb 23                	jmp    1fe <stat+0x4c>
  r = fstat(fd, st);
 1db:	8b 45 0c             	mov    0xc(%ebp),%eax
 1de:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e5:	89 04 24             	mov    %eax,(%esp)
 1e8:	e8 fd 00 00 00       	call   2ea <fstat>
 1ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f3:	89 04 24             	mov    %eax,(%esp)
 1f6:	e8 bf 00 00 00       	call   2ba <close>
  return r;
 1fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1fe:	c9                   	leave  
 1ff:	c3                   	ret    

00000200 <atoi>:

int
atoi(const char *s)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 206:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 20d:	eb 25                	jmp    234 <atoi+0x34>
    n = n*10 + *s++ - '0';
 20f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 212:	89 d0                	mov    %edx,%eax
 214:	c1 e0 02             	shl    $0x2,%eax
 217:	01 d0                	add    %edx,%eax
 219:	01 c0                	add    %eax,%eax
 21b:	89 c1                	mov    %eax,%ecx
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	8d 50 01             	lea    0x1(%eax),%edx
 223:	89 55 08             	mov    %edx,0x8(%ebp)
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	0f be c0             	movsbl %al,%eax
 22c:	01 c8                	add    %ecx,%eax
 22e:	83 e8 30             	sub    $0x30,%eax
 231:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	0f b6 00             	movzbl (%eax),%eax
 23a:	3c 2f                	cmp    $0x2f,%al
 23c:	7e 0a                	jle    248 <atoi+0x48>
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	0f b6 00             	movzbl (%eax),%eax
 244:	3c 39                	cmp    $0x39,%al
 246:	7e c7                	jle    20f <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 248:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 24b:	c9                   	leave  
 24c:	c3                   	ret    

0000024d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 24d:	55                   	push   %ebp
 24e:	89 e5                	mov    %esp,%ebp
 250:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 259:	8b 45 0c             	mov    0xc(%ebp),%eax
 25c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 25f:	eb 17                	jmp    278 <memmove+0x2b>
    *dst++ = *src++;
 261:	8b 45 fc             	mov    -0x4(%ebp),%eax
 264:	8d 50 01             	lea    0x1(%eax),%edx
 267:	89 55 fc             	mov    %edx,-0x4(%ebp)
 26a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 26d:	8d 4a 01             	lea    0x1(%edx),%ecx
 270:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 273:	0f b6 12             	movzbl (%edx),%edx
 276:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 278:	8b 45 10             	mov    0x10(%ebp),%eax
 27b:	8d 50 ff             	lea    -0x1(%eax),%edx
 27e:	89 55 10             	mov    %edx,0x10(%ebp)
 281:	85 c0                	test   %eax,%eax
 283:	7f dc                	jg     261 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 285:	8b 45 08             	mov    0x8(%ebp),%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 28a:	b8 01 00 00 00       	mov    $0x1,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <exit>:
SYSCALL(exit)
 292:	b8 02 00 00 00       	mov    $0x2,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <wait>:
SYSCALL(wait)
 29a:	b8 03 00 00 00       	mov    $0x3,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <pipe>:
SYSCALL(pipe)
 2a2:	b8 04 00 00 00       	mov    $0x4,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <read>:
SYSCALL(read)
 2aa:	b8 05 00 00 00       	mov    $0x5,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <write>:
SYSCALL(write)
 2b2:	b8 10 00 00 00       	mov    $0x10,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <close>:
SYSCALL(close)
 2ba:	b8 15 00 00 00       	mov    $0x15,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <kill>:
SYSCALL(kill)
 2c2:	b8 06 00 00 00       	mov    $0x6,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <exec>:
SYSCALL(exec)
 2ca:	b8 07 00 00 00       	mov    $0x7,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <open>:
SYSCALL(open)
 2d2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <mknod>:
SYSCALL(mknod)
 2da:	b8 11 00 00 00       	mov    $0x11,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <unlink>:
SYSCALL(unlink)
 2e2:	b8 12 00 00 00       	mov    $0x12,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <fstat>:
SYSCALL(fstat)
 2ea:	b8 08 00 00 00       	mov    $0x8,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <link>:
SYSCALL(link)
 2f2:	b8 13 00 00 00       	mov    $0x13,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <mkdir>:
SYSCALL(mkdir)
 2fa:	b8 14 00 00 00       	mov    $0x14,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <chdir>:
SYSCALL(chdir)
 302:	b8 09 00 00 00       	mov    $0x9,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <dup>:
SYSCALL(dup)
 30a:	b8 0a 00 00 00       	mov    $0xa,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <getpid>:
SYSCALL(getpid)
 312:	b8 0b 00 00 00       	mov    $0xb,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <sbrk>:
SYSCALL(sbrk)
 31a:	b8 0c 00 00 00       	mov    $0xc,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <sleep>:
SYSCALL(sleep)
 322:	b8 0d 00 00 00       	mov    $0xd,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <uptime>:
SYSCALL(uptime)
 32a:	b8 0e 00 00 00       	mov    $0xe,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <pstat>:
SYSCALL(pstat)
 332:	b8 16 00 00 00       	mov    $0x16,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <printjob>:
SYSCALL(printjob)
 33a:	b8 17 00 00 00       	mov    $0x17,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <attachjob>:
SYSCALL(attachjob)
 342:	b8 18 00 00 00       	mov    $0x18,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 34a:	55                   	push   %ebp
 34b:	89 e5                	mov    %esp,%ebp
 34d:	83 ec 18             	sub    $0x18,%esp
 350:	8b 45 0c             	mov    0xc(%ebp),%eax
 353:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 356:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 35d:	00 
 35e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 361:	89 44 24 04          	mov    %eax,0x4(%esp)
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	89 04 24             	mov    %eax,(%esp)
 36b:	e8 42 ff ff ff       	call   2b2 <write>
}
 370:	c9                   	leave  
 371:	c3                   	ret    

00000372 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	56                   	push   %esi
 376:	53                   	push   %ebx
 377:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 37a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 381:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 385:	74 17                	je     39e <printint+0x2c>
 387:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 38b:	79 11                	jns    39e <printint+0x2c>
    neg = 1;
 38d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 394:	8b 45 0c             	mov    0xc(%ebp),%eax
 397:	f7 d8                	neg    %eax
 399:	89 45 ec             	mov    %eax,-0x14(%ebp)
 39c:	eb 06                	jmp    3a4 <printint+0x32>
  } else {
    x = xx;
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ab:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3ae:	8d 41 01             	lea    0x1(%ecx),%eax
 3b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ba:	ba 00 00 00 00       	mov    $0x0,%edx
 3bf:	f7 f3                	div    %ebx
 3c1:	89 d0                	mov    %edx,%eax
 3c3:	0f b6 80 44 0a 00 00 	movzbl 0xa44(%eax),%eax
 3ca:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3ce:	8b 75 10             	mov    0x10(%ebp),%esi
 3d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d4:	ba 00 00 00 00       	mov    $0x0,%edx
 3d9:	f7 f6                	div    %esi
 3db:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3e2:	75 c7                	jne    3ab <printint+0x39>
  if(neg)
 3e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3e8:	74 10                	je     3fa <printint+0x88>
    buf[i++] = '-';
 3ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ed:	8d 50 01             	lea    0x1(%eax),%edx
 3f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3f8:	eb 1f                	jmp    419 <printint+0xa7>
 3fa:	eb 1d                	jmp    419 <printint+0xa7>
    putc(fd, buf[i]);
 3fc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 402:	01 d0                	add    %edx,%eax
 404:	0f b6 00             	movzbl (%eax),%eax
 407:	0f be c0             	movsbl %al,%eax
 40a:	89 44 24 04          	mov    %eax,0x4(%esp)
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
 411:	89 04 24             	mov    %eax,(%esp)
 414:	e8 31 ff ff ff       	call   34a <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 419:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 41d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 421:	79 d9                	jns    3fc <printint+0x8a>
    putc(fd, buf[i]);
}
 423:	83 c4 30             	add    $0x30,%esp
 426:	5b                   	pop    %ebx
 427:	5e                   	pop    %esi
 428:	5d                   	pop    %ebp
 429:	c3                   	ret    

0000042a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 42a:	55                   	push   %ebp
 42b:	89 e5                	mov    %esp,%ebp
 42d:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 430:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 437:	8d 45 0c             	lea    0xc(%ebp),%eax
 43a:	83 c0 04             	add    $0x4,%eax
 43d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 447:	e9 7c 01 00 00       	jmp    5c8 <printf+0x19e>
    c = fmt[i] & 0xff;
 44c:	8b 55 0c             	mov    0xc(%ebp),%edx
 44f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 452:	01 d0                	add    %edx,%eax
 454:	0f b6 00             	movzbl (%eax),%eax
 457:	0f be c0             	movsbl %al,%eax
 45a:	25 ff 00 00 00       	and    $0xff,%eax
 45f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 462:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 466:	75 2c                	jne    494 <printf+0x6a>
      if(c == '%'){
 468:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 46c:	75 0c                	jne    47a <printf+0x50>
        state = '%';
 46e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 475:	e9 4a 01 00 00       	jmp    5c4 <printf+0x19a>
      } else {
        putc(fd, c);
 47a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 47d:	0f be c0             	movsbl %al,%eax
 480:	89 44 24 04          	mov    %eax,0x4(%esp)
 484:	8b 45 08             	mov    0x8(%ebp),%eax
 487:	89 04 24             	mov    %eax,(%esp)
 48a:	e8 bb fe ff ff       	call   34a <putc>
 48f:	e9 30 01 00 00       	jmp    5c4 <printf+0x19a>
      }
    } else if(state == '%'){
 494:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 498:	0f 85 26 01 00 00    	jne    5c4 <printf+0x19a>
      if(c == 'd'){
 49e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a2:	75 2d                	jne    4d1 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a7:	8b 00                	mov    (%eax),%eax
 4a9:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4b0:	00 
 4b1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4b8:	00 
 4b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
 4c0:	89 04 24             	mov    %eax,(%esp)
 4c3:	e8 aa fe ff ff       	call   372 <printint>
        ap++;
 4c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4cc:	e9 ec 00 00 00       	jmp    5bd <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4d1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4d5:	74 06                	je     4dd <printf+0xb3>
 4d7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4db:	75 2d                	jne    50a <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e0:	8b 00                	mov    (%eax),%eax
 4e2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4e9:	00 
 4ea:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4f1:	00 
 4f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f6:	8b 45 08             	mov    0x8(%ebp),%eax
 4f9:	89 04 24             	mov    %eax,(%esp)
 4fc:	e8 71 fe ff ff       	call   372 <printint>
        ap++;
 501:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 505:	e9 b3 00 00 00       	jmp    5bd <printf+0x193>
      } else if(c == 's'){
 50a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 50e:	75 45                	jne    555 <printf+0x12b>
        s = (char*)*ap;
 510:	8b 45 e8             	mov    -0x18(%ebp),%eax
 513:	8b 00                	mov    (%eax),%eax
 515:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 518:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 51c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 520:	75 09                	jne    52b <printf+0x101>
          s = "(null)";
 522:	c7 45 f4 f6 07 00 00 	movl   $0x7f6,-0xc(%ebp)
        while(*s != 0){
 529:	eb 1e                	jmp    549 <printf+0x11f>
 52b:	eb 1c                	jmp    549 <printf+0x11f>
          putc(fd, *s);
 52d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 530:	0f b6 00             	movzbl (%eax),%eax
 533:	0f be c0             	movsbl %al,%eax
 536:	89 44 24 04          	mov    %eax,0x4(%esp)
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	89 04 24             	mov    %eax,(%esp)
 540:	e8 05 fe ff ff       	call   34a <putc>
          s++;
 545:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 549:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54c:	0f b6 00             	movzbl (%eax),%eax
 54f:	84 c0                	test   %al,%al
 551:	75 da                	jne    52d <printf+0x103>
 553:	eb 68                	jmp    5bd <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 555:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 559:	75 1d                	jne    578 <printf+0x14e>
        putc(fd, *ap);
 55b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55e:	8b 00                	mov    (%eax),%eax
 560:	0f be c0             	movsbl %al,%eax
 563:	89 44 24 04          	mov    %eax,0x4(%esp)
 567:	8b 45 08             	mov    0x8(%ebp),%eax
 56a:	89 04 24             	mov    %eax,(%esp)
 56d:	e8 d8 fd ff ff       	call   34a <putc>
        ap++;
 572:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 576:	eb 45                	jmp    5bd <printf+0x193>
      } else if(c == '%'){
 578:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57c:	75 17                	jne    595 <printf+0x16b>
        putc(fd, c);
 57e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 581:	0f be c0             	movsbl %al,%eax
 584:	89 44 24 04          	mov    %eax,0x4(%esp)
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	89 04 24             	mov    %eax,(%esp)
 58e:	e8 b7 fd ff ff       	call   34a <putc>
 593:	eb 28                	jmp    5bd <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 595:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 59c:	00 
 59d:	8b 45 08             	mov    0x8(%ebp),%eax
 5a0:	89 04 24             	mov    %eax,(%esp)
 5a3:	e8 a2 fd ff ff       	call   34a <putc>
        putc(fd, c);
 5a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ab:	0f be c0             	movsbl %al,%eax
 5ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b2:	8b 45 08             	mov    0x8(%ebp),%eax
 5b5:	89 04 24             	mov    %eax,(%esp)
 5b8:	e8 8d fd ff ff       	call   34a <putc>
      }
      state = 0;
 5bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5c8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ce:	01 d0                	add    %edx,%eax
 5d0:	0f b6 00             	movzbl (%eax),%eax
 5d3:	84 c0                	test   %al,%al
 5d5:	0f 85 71 fe ff ff    	jne    44c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5db:	c9                   	leave  
 5dc:	c3                   	ret    

000005dd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5dd:	55                   	push   %ebp
 5de:	89 e5                	mov    %esp,%ebp
 5e0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	83 e8 08             	sub    $0x8,%eax
 5e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ec:	a1 60 0a 00 00       	mov    0xa60,%eax
 5f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f4:	eb 24                	jmp    61a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f9:	8b 00                	mov    (%eax),%eax
 5fb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5fe:	77 12                	ja     612 <free+0x35>
 600:	8b 45 f8             	mov    -0x8(%ebp),%eax
 603:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 606:	77 24                	ja     62c <free+0x4f>
 608:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 610:	77 1a                	ja     62c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 612:	8b 45 fc             	mov    -0x4(%ebp),%eax
 615:	8b 00                	mov    (%eax),%eax
 617:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 620:	76 d4                	jbe    5f6 <free+0x19>
 622:	8b 45 fc             	mov    -0x4(%ebp),%eax
 625:	8b 00                	mov    (%eax),%eax
 627:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62a:	76 ca                	jbe    5f6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 62c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62f:	8b 40 04             	mov    0x4(%eax),%eax
 632:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	01 c2                	add    %eax,%edx
 63e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 641:	8b 00                	mov    (%eax),%eax
 643:	39 c2                	cmp    %eax,%edx
 645:	75 24                	jne    66b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	8b 50 04             	mov    0x4(%eax),%edx
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	8b 40 04             	mov    0x4(%eax),%eax
 655:	01 c2                	add    %eax,%edx
 657:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	8b 10                	mov    (%eax),%edx
 664:	8b 45 f8             	mov    -0x8(%ebp),%eax
 667:	89 10                	mov    %edx,(%eax)
 669:	eb 0a                	jmp    675 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 66b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66e:	8b 10                	mov    (%eax),%edx
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 40 04             	mov    0x4(%eax),%eax
 67b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	01 d0                	add    %edx,%eax
 687:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68a:	75 20                	jne    6ac <free+0xcf>
    p->s.size += bp->s.size;
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 50 04             	mov    0x4(%eax),%edx
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	8b 40 04             	mov    0x4(%eax),%eax
 698:	01 c2                	add    %eax,%edx
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a3:	8b 10                	mov    (%eax),%edx
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	89 10                	mov    %edx,(%eax)
 6aa:	eb 08                	jmp    6b4 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b2:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 6bc:	c9                   	leave  
 6bd:	c3                   	ret    

000006be <morecore>:

static Header*
morecore(uint nu)
{
 6be:	55                   	push   %ebp
 6bf:	89 e5                	mov    %esp,%ebp
 6c1:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6c4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6cb:	77 07                	ja     6d4 <morecore+0x16>
    nu = 4096;
 6cd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6d4:	8b 45 08             	mov    0x8(%ebp),%eax
 6d7:	c1 e0 03             	shl    $0x3,%eax
 6da:	89 04 24             	mov    %eax,(%esp)
 6dd:	e8 38 fc ff ff       	call   31a <sbrk>
 6e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6e5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6e9:	75 07                	jne    6f2 <morecore+0x34>
    return 0;
 6eb:	b8 00 00 00 00       	mov    $0x0,%eax
 6f0:	eb 22                	jmp    714 <morecore+0x56>
  hp = (Header*)p;
 6f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fb:	8b 55 08             	mov    0x8(%ebp),%edx
 6fe:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 701:	8b 45 f0             	mov    -0x10(%ebp),%eax
 704:	83 c0 08             	add    $0x8,%eax
 707:	89 04 24             	mov    %eax,(%esp)
 70a:	e8 ce fe ff ff       	call   5dd <free>
  return freep;
 70f:	a1 60 0a 00 00       	mov    0xa60,%eax
}
 714:	c9                   	leave  
 715:	c3                   	ret    

00000716 <malloc>:

void*
malloc(uint nbytes)
{
 716:	55                   	push   %ebp
 717:	89 e5                	mov    %esp,%ebp
 719:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71c:	8b 45 08             	mov    0x8(%ebp),%eax
 71f:	83 c0 07             	add    $0x7,%eax
 722:	c1 e8 03             	shr    $0x3,%eax
 725:	83 c0 01             	add    $0x1,%eax
 728:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 72b:	a1 60 0a 00 00       	mov    0xa60,%eax
 730:	89 45 f0             	mov    %eax,-0x10(%ebp)
 733:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 737:	75 23                	jne    75c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 739:	c7 45 f0 58 0a 00 00 	movl   $0xa58,-0x10(%ebp)
 740:	8b 45 f0             	mov    -0x10(%ebp),%eax
 743:	a3 60 0a 00 00       	mov    %eax,0xa60
 748:	a1 60 0a 00 00       	mov    0xa60,%eax
 74d:	a3 58 0a 00 00       	mov    %eax,0xa58
    base.s.size = 0;
 752:	c7 05 5c 0a 00 00 00 	movl   $0x0,0xa5c
 759:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75f:	8b 00                	mov    (%eax),%eax
 761:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	8b 40 04             	mov    0x4(%eax),%eax
 76a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76d:	72 4d                	jb     7bc <malloc+0xa6>
      if(p->s.size == nunits)
 76f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 772:	8b 40 04             	mov    0x4(%eax),%eax
 775:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 778:	75 0c                	jne    786 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 77a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77d:	8b 10                	mov    (%eax),%edx
 77f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 782:	89 10                	mov    %edx,(%eax)
 784:	eb 26                	jmp    7ac <malloc+0x96>
      else {
        p->s.size -= nunits;
 786:	8b 45 f4             	mov    -0xc(%ebp),%eax
 789:	8b 40 04             	mov    0x4(%eax),%eax
 78c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 78f:	89 c2                	mov    %eax,%edx
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	8b 40 04             	mov    0x4(%eax),%eax
 79d:	c1 e0 03             	shl    $0x3,%eax
 7a0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7af:	a3 60 0a 00 00       	mov    %eax,0xa60
      return (void*)(p + 1);
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	83 c0 08             	add    $0x8,%eax
 7ba:	eb 38                	jmp    7f4 <malloc+0xde>
    }
    if(p == freep)
 7bc:	a1 60 0a 00 00       	mov    0xa60,%eax
 7c1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c4:	75 1b                	jne    7e1 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c9:	89 04 24             	mov    %eax,(%esp)
 7cc:	e8 ed fe ff ff       	call   6be <morecore>
 7d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d8:	75 07                	jne    7e1 <malloc+0xcb>
        return 0;
 7da:	b8 00 00 00 00       	mov    $0x0,%eax
 7df:	eb 13                	jmp    7f4 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 00                	mov    (%eax),%eax
 7ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7ef:	e9 70 ff ff ff       	jmp    764 <malloc+0x4e>
}
 7f4:	c9                   	leave  
 7f5:	c3                   	ret    
