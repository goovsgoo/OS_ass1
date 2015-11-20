
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 20                	je     2f <main+0x2f>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 63 08 00 	movl   $0x863,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 74 04 00 00       	call   497 <printf>
    exit(0);
  23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2a:	e8 c0 02 00 00       	call   2ef <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	83 c0 08             	add    $0x8,%eax
  35:	8b 10                	mov    (%eax),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	83 c0 04             	add    $0x4,%eax
  3d:	8b 00                	mov    (%eax),%eax
  3f:	89 54 24 04          	mov    %edx,0x4(%esp)
  43:	89 04 24             	mov    %eax,(%esp)
  46:	e8 04 03 00 00       	call   34f <link>
  4b:	85 c0                	test   %eax,%eax
  4d:	79 2c                	jns    7b <main+0x7b>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  52:	83 c0 08             	add    $0x8,%eax
  55:	8b 10                	mov    (%eax),%edx
  57:	8b 45 0c             	mov    0xc(%ebp),%eax
  5a:	83 c0 04             	add    $0x4,%eax
  5d:	8b 00                	mov    (%eax),%eax
  5f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  63:	89 44 24 08          	mov    %eax,0x8(%esp)
  67:	c7 44 24 04 76 08 00 	movl   $0x876,0x4(%esp)
  6e:	00 
  6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  76:	e8 1c 04 00 00       	call   497 <printf>
  exit(-1);
  7b:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  82:	e8 68 02 00 00       	call   2ef <exit>

00000087 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  87:	55                   	push   %ebp
  88:	89 e5                	mov    %esp,%ebp
  8a:	57                   	push   %edi
  8b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8f:	8b 55 10             	mov    0x10(%ebp),%edx
  92:	8b 45 0c             	mov    0xc(%ebp),%eax
  95:	89 cb                	mov    %ecx,%ebx
  97:	89 df                	mov    %ebx,%edi
  99:	89 d1                	mov    %edx,%ecx
  9b:	fc                   	cld    
  9c:	f3 aa                	rep stos %al,%es:(%edi)
  9e:	89 ca                	mov    %ecx,%edx
  a0:	89 fb                	mov    %edi,%ebx
  a2:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a5:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a8:	5b                   	pop    %ebx
  a9:	5f                   	pop    %edi
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    

000000ac <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  b2:	8b 45 08             	mov    0x8(%ebp),%eax
  b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b8:	90                   	nop
  b9:	8b 45 08             	mov    0x8(%ebp),%eax
  bc:	8d 50 01             	lea    0x1(%eax),%edx
  bf:	89 55 08             	mov    %edx,0x8(%ebp)
  c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  cb:	0f b6 12             	movzbl (%edx),%edx
  ce:	88 10                	mov    %dl,(%eax)
  d0:	0f b6 00             	movzbl (%eax),%eax
  d3:	84 c0                	test   %al,%al
  d5:	75 e2                	jne    b9 <strcpy+0xd>
    ;
  return os;
  d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  da:	c9                   	leave  
  db:	c3                   	ret    

000000dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  dc:	55                   	push   %ebp
  dd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  df:	eb 08                	jmp    e9 <strcmp+0xd>
    p++, q++;
  e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e9:	8b 45 08             	mov    0x8(%ebp),%eax
  ec:	0f b6 00             	movzbl (%eax),%eax
  ef:	84 c0                	test   %al,%al
  f1:	74 10                	je     103 <strcmp+0x27>
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 10             	movzbl (%eax),%edx
  f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  fc:	0f b6 00             	movzbl (%eax),%eax
  ff:	38 c2                	cmp    %al,%dl
 101:	74 de                	je     e1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	0f b6 d0             	movzbl %al,%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	0f b6 c0             	movzbl %al,%eax
 115:	29 c2                	sub    %eax,%edx
 117:	89 d0                	mov    %edx,%eax
}
 119:	5d                   	pop    %ebp
 11a:	c3                   	ret    

0000011b <strlen>:

uint
strlen(char *s)
{
 11b:	55                   	push   %ebp
 11c:	89 e5                	mov    %esp,%ebp
 11e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 121:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 128:	eb 04                	jmp    12e <strlen+0x13>
 12a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 12e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	01 d0                	add    %edx,%eax
 136:	0f b6 00             	movzbl (%eax),%eax
 139:	84 c0                	test   %al,%al
 13b:	75 ed                	jne    12a <strlen+0xf>
    ;
  return n;
 13d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 140:	c9                   	leave  
 141:	c3                   	ret    

00000142 <memset>:

void*
memset(void *dst, int c, uint n)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 148:	8b 45 10             	mov    0x10(%ebp),%eax
 14b:	89 44 24 08          	mov    %eax,0x8(%esp)
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	89 44 24 04          	mov    %eax,0x4(%esp)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	89 04 24             	mov    %eax,(%esp)
 15c:	e8 26 ff ff ff       	call   87 <stosb>
  return dst;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 04             	sub    $0x4,%esp
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 172:	eb 14                	jmp    188 <strchr+0x22>
    if(*s == c)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17d:	75 05                	jne    184 <strchr+0x1e>
      return (char*)s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	eb 13                	jmp    197 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	84 c0                	test   %al,%al
 190:	75 e2                	jne    174 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 192:	b8 00 00 00 00       	mov    $0x0,%eax
}
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <gets>:

char*
gets(char *buf, int max)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a6:	eb 4c                	jmp    1f4 <gets+0x5b>
    cc = read(0, &c, 1);
 1a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1af:	00 
 1b0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1be:	e8 44 01 00 00       	call   307 <read>
 1c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ca:	7f 02                	jg     1ce <gets+0x35>
      break;
 1cc:	eb 31                	jmp    1ff <gets+0x66>
    buf[i++] = c;
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	8d 50 01             	lea    0x1(%eax),%edx
 1d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1d7:	89 c2                	mov    %eax,%edx
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
 1dc:	01 c2                	add    %eax,%edx
 1de:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1e4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e8:	3c 0a                	cmp    $0xa,%al
 1ea:	74 13                	je     1ff <gets+0x66>
 1ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f0:	3c 0d                	cmp    $0xd,%al
 1f2:	74 0b                	je     1ff <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f7:	83 c0 01             	add    $0x1,%eax
 1fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1fd:	7c a9                	jl     1a8 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	01 d0                	add    %edx,%eax
 207:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 20d:	c9                   	leave  
 20e:	c3                   	ret    

0000020f <stat>:

int
stat(char *n, struct stat *st)
{
 20f:	55                   	push   %ebp
 210:	89 e5                	mov    %esp,%ebp
 212:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 215:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 21c:	00 
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	89 04 24             	mov    %eax,(%esp)
 223:	e8 07 01 00 00       	call   32f <open>
 228:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 22b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 22f:	79 07                	jns    238 <stat+0x29>
    return -1;
 231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 236:	eb 23                	jmp    25b <stat+0x4c>
  r = fstat(fd, st);
 238:	8b 45 0c             	mov    0xc(%ebp),%eax
 23b:	89 44 24 04          	mov    %eax,0x4(%esp)
 23f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 242:	89 04 24             	mov    %eax,(%esp)
 245:	e8 fd 00 00 00       	call   347 <fstat>
 24a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 24d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 250:	89 04 24             	mov    %eax,(%esp)
 253:	e8 bf 00 00 00       	call   317 <close>
  return r;
 258:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 25b:	c9                   	leave  
 25c:	c3                   	ret    

0000025d <atoi>:

int
atoi(const char *s)
{
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 263:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26a:	eb 25                	jmp    291 <atoi+0x34>
    n = n*10 + *s++ - '0';
 26c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26f:	89 d0                	mov    %edx,%eax
 271:	c1 e0 02             	shl    $0x2,%eax
 274:	01 d0                	add    %edx,%eax
 276:	01 c0                	add    %eax,%eax
 278:	89 c1                	mov    %eax,%ecx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	8d 50 01             	lea    0x1(%eax),%edx
 280:	89 55 08             	mov    %edx,0x8(%ebp)
 283:	0f b6 00             	movzbl (%eax),%eax
 286:	0f be c0             	movsbl %al,%eax
 289:	01 c8                	add    %ecx,%eax
 28b:	83 e8 30             	sub    $0x30,%eax
 28e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	0f b6 00             	movzbl (%eax),%eax
 297:	3c 2f                	cmp    $0x2f,%al
 299:	7e 0a                	jle    2a5 <atoi+0x48>
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	0f b6 00             	movzbl (%eax),%eax
 2a1:	3c 39                	cmp    $0x39,%al
 2a3:	7e c7                	jle    26c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a8:	c9                   	leave  
 2a9:	c3                   	ret    

000002aa <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2aa:	55                   	push   %ebp
 2ab:	89 e5                	mov    %esp,%ebp
 2ad:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2bc:	eb 17                	jmp    2d5 <memmove+0x2b>
    *dst++ = *src++;
 2be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c1:	8d 50 01             	lea    0x1(%eax),%edx
 2c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2c7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2ca:	8d 4a 01             	lea    0x1(%edx),%ecx
 2cd:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2d0:	0f b6 12             	movzbl (%edx),%edx
 2d3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d5:	8b 45 10             	mov    0x10(%ebp),%eax
 2d8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2db:	89 55 10             	mov    %edx,0x10(%ebp)
 2de:	85 c0                	test   %eax,%eax
 2e0:	7f dc                	jg     2be <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e5:	c9                   	leave  
 2e6:	c3                   	ret    

000002e7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e7:	b8 01 00 00 00       	mov    $0x1,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <exit>:
SYSCALL(exit)
 2ef:	b8 02 00 00 00       	mov    $0x2,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <wait>:
SYSCALL(wait)
 2f7:	b8 03 00 00 00       	mov    $0x3,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <pipe>:
SYSCALL(pipe)
 2ff:	b8 04 00 00 00       	mov    $0x4,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <read>:
SYSCALL(read)
 307:	b8 05 00 00 00       	mov    $0x5,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <write>:
SYSCALL(write)
 30f:	b8 10 00 00 00       	mov    $0x10,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <close>:
SYSCALL(close)
 317:	b8 15 00 00 00       	mov    $0x15,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <kill>:
SYSCALL(kill)
 31f:	b8 06 00 00 00       	mov    $0x6,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <exec>:
SYSCALL(exec)
 327:	b8 07 00 00 00       	mov    $0x7,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <open>:
SYSCALL(open)
 32f:	b8 0f 00 00 00       	mov    $0xf,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <mknod>:
SYSCALL(mknod)
 337:	b8 11 00 00 00       	mov    $0x11,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <unlink>:
SYSCALL(unlink)
 33f:	b8 12 00 00 00       	mov    $0x12,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <fstat>:
SYSCALL(fstat)
 347:	b8 08 00 00 00       	mov    $0x8,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <link>:
SYSCALL(link)
 34f:	b8 13 00 00 00       	mov    $0x13,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <mkdir>:
SYSCALL(mkdir)
 357:	b8 14 00 00 00       	mov    $0x14,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <chdir>:
SYSCALL(chdir)
 35f:	b8 09 00 00 00       	mov    $0x9,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <dup>:
SYSCALL(dup)
 367:	b8 0a 00 00 00       	mov    $0xa,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <getpid>:
SYSCALL(getpid)
 36f:	b8 0b 00 00 00       	mov    $0xb,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <sbrk>:
SYSCALL(sbrk)
 377:	b8 0c 00 00 00       	mov    $0xc,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <sleep>:
SYSCALL(sleep)
 37f:	b8 0d 00 00 00       	mov    $0xd,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <uptime>:
SYSCALL(uptime)
 387:	b8 0e 00 00 00       	mov    $0xe,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <pstat>:
SYSCALL(pstat)
 38f:	b8 16 00 00 00       	mov    $0x16,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <printjob>:
SYSCALL(printjob)
 397:	b8 17 00 00 00       	mov    $0x17,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <attachjob>:
SYSCALL(attachjob)
 39f:	b8 18 00 00 00       	mov    $0x18,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <fg>:
SYSCALL (fg)
 3a7:	b8 19 00 00 00       	mov    $0x19,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <waitpid>:
SYSCALL(waitpid)
 3af:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 18             	sub    $0x18,%esp
 3bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ca:	00 
 3cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	89 04 24             	mov    %eax,(%esp)
 3d8:	e8 32 ff ff ff       	call   30f <write>
}
 3dd:	c9                   	leave  
 3de:	c3                   	ret    

000003df <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3df:	55                   	push   %ebp
 3e0:	89 e5                	mov    %esp,%ebp
 3e2:	56                   	push   %esi
 3e3:	53                   	push   %ebx
 3e4:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ee:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f2:	74 17                	je     40b <printint+0x2c>
 3f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f8:	79 11                	jns    40b <printint+0x2c>
    neg = 1;
 3fa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 401:	8b 45 0c             	mov    0xc(%ebp),%eax
 404:	f7 d8                	neg    %eax
 406:	89 45 ec             	mov    %eax,-0x14(%ebp)
 409:	eb 06                	jmp    411 <printint+0x32>
  } else {
    x = xx;
 40b:	8b 45 0c             	mov    0xc(%ebp),%eax
 40e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 411:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 418:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 41b:	8d 41 01             	lea    0x1(%ecx),%eax
 41e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 421:	8b 5d 10             	mov    0x10(%ebp),%ebx
 424:	8b 45 ec             	mov    -0x14(%ebp),%eax
 427:	ba 00 00 00 00       	mov    $0x0,%edx
 42c:	f7 f3                	div    %ebx
 42e:	89 d0                	mov    %edx,%eax
 430:	0f b6 80 d8 0a 00 00 	movzbl 0xad8(%eax),%eax
 437:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 43b:	8b 75 10             	mov    0x10(%ebp),%esi
 43e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 441:	ba 00 00 00 00       	mov    $0x0,%edx
 446:	f7 f6                	div    %esi
 448:	89 45 ec             	mov    %eax,-0x14(%ebp)
 44b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 44f:	75 c7                	jne    418 <printint+0x39>
  if(neg)
 451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 455:	74 10                	je     467 <printint+0x88>
    buf[i++] = '-';
 457:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45a:	8d 50 01             	lea    0x1(%eax),%edx
 45d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 460:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 465:	eb 1f                	jmp    486 <printint+0xa7>
 467:	eb 1d                	jmp    486 <printint+0xa7>
    putc(fd, buf[i]);
 469:	8d 55 dc             	lea    -0x24(%ebp),%edx
 46c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46f:	01 d0                	add    %edx,%eax
 471:	0f b6 00             	movzbl (%eax),%eax
 474:	0f be c0             	movsbl %al,%eax
 477:	89 44 24 04          	mov    %eax,0x4(%esp)
 47b:	8b 45 08             	mov    0x8(%ebp),%eax
 47e:	89 04 24             	mov    %eax,(%esp)
 481:	e8 31 ff ff ff       	call   3b7 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 486:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 48a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 48e:	79 d9                	jns    469 <printint+0x8a>
    putc(fd, buf[i]);
}
 490:	83 c4 30             	add    $0x30,%esp
 493:	5b                   	pop    %ebx
 494:	5e                   	pop    %esi
 495:	5d                   	pop    %ebp
 496:	c3                   	ret    

00000497 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 497:	55                   	push   %ebp
 498:	89 e5                	mov    %esp,%ebp
 49a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 49d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4a4:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a7:	83 c0 04             	add    $0x4,%eax
 4aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4b4:	e9 7c 01 00 00       	jmp    635 <printf+0x19e>
    c = fmt[i] & 0xff;
 4b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4bf:	01 d0                	add    %edx,%eax
 4c1:	0f b6 00             	movzbl (%eax),%eax
 4c4:	0f be c0             	movsbl %al,%eax
 4c7:	25 ff 00 00 00       	and    $0xff,%eax
 4cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d3:	75 2c                	jne    501 <printf+0x6a>
      if(c == '%'){
 4d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d9:	75 0c                	jne    4e7 <printf+0x50>
        state = '%';
 4db:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4e2:	e9 4a 01 00 00       	jmp    631 <printf+0x19a>
      } else {
        putc(fd, c);
 4e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ea:	0f be c0             	movsbl %al,%eax
 4ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	89 04 24             	mov    %eax,(%esp)
 4f7:	e8 bb fe ff ff       	call   3b7 <putc>
 4fc:	e9 30 01 00 00       	jmp    631 <printf+0x19a>
      }
    } else if(state == '%'){
 501:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 505:	0f 85 26 01 00 00    	jne    631 <printf+0x19a>
      if(c == 'd'){
 50b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 50f:	75 2d                	jne    53e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 511:	8b 45 e8             	mov    -0x18(%ebp),%eax
 514:	8b 00                	mov    (%eax),%eax
 516:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 51d:	00 
 51e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 525:	00 
 526:	89 44 24 04          	mov    %eax,0x4(%esp)
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
 52d:	89 04 24             	mov    %eax,(%esp)
 530:	e8 aa fe ff ff       	call   3df <printint>
        ap++;
 535:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 539:	e9 ec 00 00 00       	jmp    62a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 53e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 542:	74 06                	je     54a <printf+0xb3>
 544:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 548:	75 2d                	jne    577 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 54a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54d:	8b 00                	mov    (%eax),%eax
 54f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 556:	00 
 557:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 55e:	00 
 55f:	89 44 24 04          	mov    %eax,0x4(%esp)
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	89 04 24             	mov    %eax,(%esp)
 569:	e8 71 fe ff ff       	call   3df <printint>
        ap++;
 56e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 572:	e9 b3 00 00 00       	jmp    62a <printf+0x193>
      } else if(c == 's'){
 577:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 57b:	75 45                	jne    5c2 <printf+0x12b>
        s = (char*)*ap;
 57d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 580:	8b 00                	mov    (%eax),%eax
 582:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 585:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 589:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 58d:	75 09                	jne    598 <printf+0x101>
          s = "(null)";
 58f:	c7 45 f4 8a 08 00 00 	movl   $0x88a,-0xc(%ebp)
        while(*s != 0){
 596:	eb 1e                	jmp    5b6 <printf+0x11f>
 598:	eb 1c                	jmp    5b6 <printf+0x11f>
          putc(fd, *s);
 59a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59d:	0f b6 00             	movzbl (%eax),%eax
 5a0:	0f be c0             	movsbl %al,%eax
 5a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
 5aa:	89 04 24             	mov    %eax,(%esp)
 5ad:	e8 05 fe ff ff       	call   3b7 <putc>
          s++;
 5b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b9:	0f b6 00             	movzbl (%eax),%eax
 5bc:	84 c0                	test   %al,%al
 5be:	75 da                	jne    59a <printf+0x103>
 5c0:	eb 68                	jmp    62a <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5c2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5c6:	75 1d                	jne    5e5 <printf+0x14e>
        putc(fd, *ap);
 5c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cb:	8b 00                	mov    (%eax),%eax
 5cd:	0f be c0             	movsbl %al,%eax
 5d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d4:	8b 45 08             	mov    0x8(%ebp),%eax
 5d7:	89 04 24             	mov    %eax,(%esp)
 5da:	e8 d8 fd ff ff       	call   3b7 <putc>
        ap++;
 5df:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e3:	eb 45                	jmp    62a <printf+0x193>
      } else if(c == '%'){
 5e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e9:	75 17                	jne    602 <printf+0x16b>
        putc(fd, c);
 5eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ee:	0f be c0             	movsbl %al,%eax
 5f1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f5:	8b 45 08             	mov    0x8(%ebp),%eax
 5f8:	89 04 24             	mov    %eax,(%esp)
 5fb:	e8 b7 fd ff ff       	call   3b7 <putc>
 600:	eb 28                	jmp    62a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 602:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 609:	00 
 60a:	8b 45 08             	mov    0x8(%ebp),%eax
 60d:	89 04 24             	mov    %eax,(%esp)
 610:	e8 a2 fd ff ff       	call   3b7 <putc>
        putc(fd, c);
 615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 618:	0f be c0             	movsbl %al,%eax
 61b:	89 44 24 04          	mov    %eax,0x4(%esp)
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	89 04 24             	mov    %eax,(%esp)
 625:	e8 8d fd ff ff       	call   3b7 <putc>
      }
      state = 0;
 62a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 631:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 635:	8b 55 0c             	mov    0xc(%ebp),%edx
 638:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63b:	01 d0                	add    %edx,%eax
 63d:	0f b6 00             	movzbl (%eax),%eax
 640:	84 c0                	test   %al,%al
 642:	0f 85 71 fe ff ff    	jne    4b9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 648:	c9                   	leave  
 649:	c3                   	ret    

0000064a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64a:	55                   	push   %ebp
 64b:	89 e5                	mov    %esp,%ebp
 64d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 650:	8b 45 08             	mov    0x8(%ebp),%eax
 653:	83 e8 08             	sub    $0x8,%eax
 656:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 659:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 65e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 661:	eb 24                	jmp    687 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66b:	77 12                	ja     67f <free+0x35>
 66d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 670:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 673:	77 24                	ja     699 <free+0x4f>
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67d:	77 1a                	ja     699 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	89 45 fc             	mov    %eax,-0x4(%ebp)
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68d:	76 d4                	jbe    663 <free+0x19>
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 697:	76 ca                	jbe    663 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	8b 40 04             	mov    0x4(%eax),%eax
 69f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	01 c2                	add    %eax,%edx
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	39 c2                	cmp    %eax,%edx
 6b2:	75 24                	jne    6d8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b7:	8b 50 04             	mov    0x4(%eax),%edx
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	8b 40 04             	mov    0x4(%eax),%eax
 6c2:	01 c2                	add    %eax,%edx
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	8b 00                	mov    (%eax),%eax
 6cf:	8b 10                	mov    (%eax),%edx
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	89 10                	mov    %edx,(%eax)
 6d6:	eb 0a                	jmp    6e2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	8b 10                	mov    (%eax),%edx
 6dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	8b 40 04             	mov    0x4(%eax),%eax
 6e8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	01 d0                	add    %edx,%eax
 6f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f7:	75 20                	jne    719 <free+0xcf>
    p->s.size += bp->s.size;
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 50 04             	mov    0x4(%eax),%edx
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	8b 40 04             	mov    0x4(%eax),%eax
 705:	01 c2                	add    %eax,%edx
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 70d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 710:	8b 10                	mov    (%eax),%edx
 712:	8b 45 fc             	mov    -0x4(%ebp),%eax
 715:	89 10                	mov    %edx,(%eax)
 717:	eb 08                	jmp    721 <free+0xd7>
  } else
    p->s.ptr = bp;
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 71f:	89 10                	mov    %edx,(%eax)
  freep = p;
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	a3 f4 0a 00 00       	mov    %eax,0xaf4
}
 729:	c9                   	leave  
 72a:	c3                   	ret    

0000072b <morecore>:

static Header*
morecore(uint nu)
{
 72b:	55                   	push   %ebp
 72c:	89 e5                	mov    %esp,%ebp
 72e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 731:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 738:	77 07                	ja     741 <morecore+0x16>
    nu = 4096;
 73a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 741:	8b 45 08             	mov    0x8(%ebp),%eax
 744:	c1 e0 03             	shl    $0x3,%eax
 747:	89 04 24             	mov    %eax,(%esp)
 74a:	e8 28 fc ff ff       	call   377 <sbrk>
 74f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 752:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 756:	75 07                	jne    75f <morecore+0x34>
    return 0;
 758:	b8 00 00 00 00       	mov    $0x0,%eax
 75d:	eb 22                	jmp    781 <morecore+0x56>
  hp = (Header*)p;
 75f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 762:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	8b 55 08             	mov    0x8(%ebp),%edx
 76b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 76e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 771:	83 c0 08             	add    $0x8,%eax
 774:	89 04 24             	mov    %eax,(%esp)
 777:	e8 ce fe ff ff       	call   64a <free>
  return freep;
 77c:	a1 f4 0a 00 00       	mov    0xaf4,%eax
}
 781:	c9                   	leave  
 782:	c3                   	ret    

00000783 <malloc>:

void*
malloc(uint nbytes)
{
 783:	55                   	push   %ebp
 784:	89 e5                	mov    %esp,%ebp
 786:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 789:	8b 45 08             	mov    0x8(%ebp),%eax
 78c:	83 c0 07             	add    $0x7,%eax
 78f:	c1 e8 03             	shr    $0x3,%eax
 792:	83 c0 01             	add    $0x1,%eax
 795:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 798:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 79d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a4:	75 23                	jne    7c9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7a6:	c7 45 f0 ec 0a 00 00 	movl   $0xaec,-0x10(%ebp)
 7ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b0:	a3 f4 0a 00 00       	mov    %eax,0xaf4
 7b5:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 7ba:	a3 ec 0a 00 00       	mov    %eax,0xaec
    base.s.size = 0;
 7bf:	c7 05 f0 0a 00 00 00 	movl   $0x0,0xaf0
 7c6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 40 04             	mov    0x4(%eax),%eax
 7d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7da:	72 4d                	jb     829 <malloc+0xa6>
      if(p->s.size == nunits)
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 40 04             	mov    0x4(%eax),%eax
 7e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e5:	75 0c                	jne    7f3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 10                	mov    (%eax),%edx
 7ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ef:	89 10                	mov    %edx,(%eax)
 7f1:	eb 26                	jmp    819 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	8b 40 04             	mov    0x4(%eax),%eax
 7f9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7fc:	89 c2                	mov    %eax,%edx
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	8b 40 04             	mov    0x4(%eax),%eax
 80a:	c1 e0 03             	shl    $0x3,%eax
 80d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	8b 55 ec             	mov    -0x14(%ebp),%edx
 816:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 819:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81c:	a3 f4 0a 00 00       	mov    %eax,0xaf4
      return (void*)(p + 1);
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	83 c0 08             	add    $0x8,%eax
 827:	eb 38                	jmp    861 <malloc+0xde>
    }
    if(p == freep)
 829:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 82e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 831:	75 1b                	jne    84e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 833:	8b 45 ec             	mov    -0x14(%ebp),%eax
 836:	89 04 24             	mov    %eax,(%esp)
 839:	e8 ed fe ff ff       	call   72b <morecore>
 83e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 845:	75 07                	jne    84e <malloc+0xcb>
        return 0;
 847:	b8 00 00 00 00       	mov    $0x0,%eax
 84c:	eb 13                	jmp    861 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	89 45 f0             	mov    %eax,-0x10(%ebp)
 854:	8b 45 f4             	mov    -0xc(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 85c:	e9 70 ff ff ff       	jmp    7d1 <malloc+0x4e>
}
 861:	c9                   	leave  
 862:	c3                   	ret    
