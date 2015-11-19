
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
   f:	c7 44 24 04 53 08 00 	movl   $0x853,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 64 04 00 00       	call   487 <printf>
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
  67:	c7 44 24 04 66 08 00 	movl   $0x866,0x4(%esp)
  6e:	00 
  6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  76:	e8 0c 04 00 00       	call   487 <printf>
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

000003a7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a7:	55                   	push   %ebp
 3a8:	89 e5                	mov    %esp,%ebp
 3aa:	83 ec 18             	sub    $0x18,%esp
 3ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ba:	00 
 3bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3be:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	89 04 24             	mov    %eax,(%esp)
 3c8:	e8 42 ff ff ff       	call   30f <write>
}
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	56                   	push   %esi
 3d3:	53                   	push   %ebx
 3d4:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3de:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e2:	74 17                	je     3fb <printint+0x2c>
 3e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e8:	79 11                	jns    3fb <printint+0x2c>
    neg = 1;
 3ea:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f4:	f7 d8                	neg    %eax
 3f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f9:	eb 06                	jmp    401 <printint+0x32>
  } else {
    x = xx;
 3fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 408:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 40b:	8d 41 01             	lea    0x1(%ecx),%eax
 40e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 411:	8b 5d 10             	mov    0x10(%ebp),%ebx
 414:	8b 45 ec             	mov    -0x14(%ebp),%eax
 417:	ba 00 00 00 00       	mov    $0x0,%edx
 41c:	f7 f3                	div    %ebx
 41e:	89 d0                	mov    %edx,%eax
 420:	0f b6 80 c8 0a 00 00 	movzbl 0xac8(%eax),%eax
 427:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 42b:	8b 75 10             	mov    0x10(%ebp),%esi
 42e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 431:	ba 00 00 00 00       	mov    $0x0,%edx
 436:	f7 f6                	div    %esi
 438:	89 45 ec             	mov    %eax,-0x14(%ebp)
 43b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43f:	75 c7                	jne    408 <printint+0x39>
  if(neg)
 441:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 445:	74 10                	je     457 <printint+0x88>
    buf[i++] = '-';
 447:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44a:	8d 50 01             	lea    0x1(%eax),%edx
 44d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 450:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 455:	eb 1f                	jmp    476 <printint+0xa7>
 457:	eb 1d                	jmp    476 <printint+0xa7>
    putc(fd, buf[i]);
 459:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45f:	01 d0                	add    %edx,%eax
 461:	0f b6 00             	movzbl (%eax),%eax
 464:	0f be c0             	movsbl %al,%eax
 467:	89 44 24 04          	mov    %eax,0x4(%esp)
 46b:	8b 45 08             	mov    0x8(%ebp),%eax
 46e:	89 04 24             	mov    %eax,(%esp)
 471:	e8 31 ff ff ff       	call   3a7 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 476:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 47a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 47e:	79 d9                	jns    459 <printint+0x8a>
    putc(fd, buf[i]);
}
 480:	83 c4 30             	add    $0x30,%esp
 483:	5b                   	pop    %ebx
 484:	5e                   	pop    %esi
 485:	5d                   	pop    %ebp
 486:	c3                   	ret    

00000487 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 487:	55                   	push   %ebp
 488:	89 e5                	mov    %esp,%ebp
 48a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 48d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 494:	8d 45 0c             	lea    0xc(%ebp),%eax
 497:	83 c0 04             	add    $0x4,%eax
 49a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 49d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a4:	e9 7c 01 00 00       	jmp    625 <printf+0x19e>
    c = fmt[i] & 0xff;
 4a9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4af:	01 d0                	add    %edx,%eax
 4b1:	0f b6 00             	movzbl (%eax),%eax
 4b4:	0f be c0             	movsbl %al,%eax
 4b7:	25 ff 00 00 00       	and    $0xff,%eax
 4bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c3:	75 2c                	jne    4f1 <printf+0x6a>
      if(c == '%'){
 4c5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c9:	75 0c                	jne    4d7 <printf+0x50>
        state = '%';
 4cb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d2:	e9 4a 01 00 00       	jmp    621 <printf+0x19a>
      } else {
        putc(fd, c);
 4d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4da:	0f be c0             	movsbl %al,%eax
 4dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
 4e4:	89 04 24             	mov    %eax,(%esp)
 4e7:	e8 bb fe ff ff       	call   3a7 <putc>
 4ec:	e9 30 01 00 00       	jmp    621 <printf+0x19a>
      }
    } else if(state == '%'){
 4f1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f5:	0f 85 26 01 00 00    	jne    621 <printf+0x19a>
      if(c == 'd'){
 4fb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ff:	75 2d                	jne    52e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 501:	8b 45 e8             	mov    -0x18(%ebp),%eax
 504:	8b 00                	mov    (%eax),%eax
 506:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 50d:	00 
 50e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 515:	00 
 516:	89 44 24 04          	mov    %eax,0x4(%esp)
 51a:	8b 45 08             	mov    0x8(%ebp),%eax
 51d:	89 04 24             	mov    %eax,(%esp)
 520:	e8 aa fe ff ff       	call   3cf <printint>
        ap++;
 525:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 529:	e9 ec 00 00 00       	jmp    61a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 52e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 532:	74 06                	je     53a <printf+0xb3>
 534:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 538:	75 2d                	jne    567 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 53a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53d:	8b 00                	mov    (%eax),%eax
 53f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 546:	00 
 547:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 54e:	00 
 54f:	89 44 24 04          	mov    %eax,0x4(%esp)
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	89 04 24             	mov    %eax,(%esp)
 559:	e8 71 fe ff ff       	call   3cf <printint>
        ap++;
 55e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 562:	e9 b3 00 00 00       	jmp    61a <printf+0x193>
      } else if(c == 's'){
 567:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 56b:	75 45                	jne    5b2 <printf+0x12b>
        s = (char*)*ap;
 56d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 570:	8b 00                	mov    (%eax),%eax
 572:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 575:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57d:	75 09                	jne    588 <printf+0x101>
          s = "(null)";
 57f:	c7 45 f4 7a 08 00 00 	movl   $0x87a,-0xc(%ebp)
        while(*s != 0){
 586:	eb 1e                	jmp    5a6 <printf+0x11f>
 588:	eb 1c                	jmp    5a6 <printf+0x11f>
          putc(fd, *s);
 58a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58d:	0f b6 00             	movzbl (%eax),%eax
 590:	0f be c0             	movsbl %al,%eax
 593:	89 44 24 04          	mov    %eax,0x4(%esp)
 597:	8b 45 08             	mov    0x8(%ebp),%eax
 59a:	89 04 24             	mov    %eax,(%esp)
 59d:	e8 05 fe ff ff       	call   3a7 <putc>
          s++;
 5a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a9:	0f b6 00             	movzbl (%eax),%eax
 5ac:	84 c0                	test   %al,%al
 5ae:	75 da                	jne    58a <printf+0x103>
 5b0:	eb 68                	jmp    61a <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b6:	75 1d                	jne    5d5 <printf+0x14e>
        putc(fd, *ap);
 5b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bb:	8b 00                	mov    (%eax),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	89 04 24             	mov    %eax,(%esp)
 5ca:	e8 d8 fd ff ff       	call   3a7 <putc>
        ap++;
 5cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d3:	eb 45                	jmp    61a <printf+0x193>
      } else if(c == '%'){
 5d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d9:	75 17                	jne    5f2 <printf+0x16b>
        putc(fd, c);
 5db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5de:	0f be c0             	movsbl %al,%eax
 5e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	89 04 24             	mov    %eax,(%esp)
 5eb:	e8 b7 fd ff ff       	call   3a7 <putc>
 5f0:	eb 28                	jmp    61a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5f9:	00 
 5fa:	8b 45 08             	mov    0x8(%ebp),%eax
 5fd:	89 04 24             	mov    %eax,(%esp)
 600:	e8 a2 fd ff ff       	call   3a7 <putc>
        putc(fd, c);
 605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	89 44 24 04          	mov    %eax,0x4(%esp)
 60f:	8b 45 08             	mov    0x8(%ebp),%eax
 612:	89 04 24             	mov    %eax,(%esp)
 615:	e8 8d fd ff ff       	call   3a7 <putc>
      }
      state = 0;
 61a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 621:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 625:	8b 55 0c             	mov    0xc(%ebp),%edx
 628:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62b:	01 d0                	add    %edx,%eax
 62d:	0f b6 00             	movzbl (%eax),%eax
 630:	84 c0                	test   %al,%al
 632:	0f 85 71 fe ff ff    	jne    4a9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 638:	c9                   	leave  
 639:	c3                   	ret    

0000063a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 63a:	55                   	push   %ebp
 63b:	89 e5                	mov    %esp,%ebp
 63d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	83 e8 08             	sub    $0x8,%eax
 646:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 649:	a1 e4 0a 00 00       	mov    0xae4,%eax
 64e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 651:	eb 24                	jmp    677 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 653:	8b 45 fc             	mov    -0x4(%ebp),%eax
 656:	8b 00                	mov    (%eax),%eax
 658:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65b:	77 12                	ja     66f <free+0x35>
 65d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 660:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 663:	77 24                	ja     689 <free+0x4f>
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66d:	77 1a                	ja     689 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8b 00                	mov    (%eax),%eax
 674:	89 45 fc             	mov    %eax,-0x4(%ebp)
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67d:	76 d4                	jbe    653 <free+0x19>
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 687:	76 ca                	jbe    653 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	8b 40 04             	mov    0x4(%eax),%eax
 68f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	01 c2                	add    %eax,%edx
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 00                	mov    (%eax),%eax
 6a0:	39 c2                	cmp    %eax,%edx
 6a2:	75 24                	jne    6c8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	8b 50 04             	mov    0x4(%eax),%edx
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	8b 00                	mov    (%eax),%eax
 6af:	8b 40 04             	mov    0x4(%eax),%eax
 6b2:	01 c2                	add    %eax,%edx
 6b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	8b 10                	mov    (%eax),%edx
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	89 10                	mov    %edx,(%eax)
 6c6:	eb 0a                	jmp    6d2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	8b 10                	mov    (%eax),%edx
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d5:	8b 40 04             	mov    0x4(%eax),%eax
 6d8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	01 d0                	add    %edx,%eax
 6e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e7:	75 20                	jne    709 <free+0xcf>
    p->s.size += bp->s.size;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8b 50 04             	mov    0x4(%eax),%edx
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	8b 40 04             	mov    0x4(%eax),%eax
 6f5:	01 c2                	add    %eax,%edx
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 700:	8b 10                	mov    (%eax),%edx
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	89 10                	mov    %edx,(%eax)
 707:	eb 08                	jmp    711 <free+0xd7>
  } else
    p->s.ptr = bp;
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 70f:	89 10                	mov    %edx,(%eax)
  freep = p;
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	a3 e4 0a 00 00       	mov    %eax,0xae4
}
 719:	c9                   	leave  
 71a:	c3                   	ret    

0000071b <morecore>:

static Header*
morecore(uint nu)
{
 71b:	55                   	push   %ebp
 71c:	89 e5                	mov    %esp,%ebp
 71e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 721:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 728:	77 07                	ja     731 <morecore+0x16>
    nu = 4096;
 72a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	c1 e0 03             	shl    $0x3,%eax
 737:	89 04 24             	mov    %eax,(%esp)
 73a:	e8 38 fc ff ff       	call   377 <sbrk>
 73f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 742:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 746:	75 07                	jne    74f <morecore+0x34>
    return 0;
 748:	b8 00 00 00 00       	mov    $0x0,%eax
 74d:	eb 22                	jmp    771 <morecore+0x56>
  hp = (Header*)p;
 74f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 752:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	8b 55 08             	mov    0x8(%ebp),%edx
 75b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 75e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 761:	83 c0 08             	add    $0x8,%eax
 764:	89 04 24             	mov    %eax,(%esp)
 767:	e8 ce fe ff ff       	call   63a <free>
  return freep;
 76c:	a1 e4 0a 00 00       	mov    0xae4,%eax
}
 771:	c9                   	leave  
 772:	c3                   	ret    

00000773 <malloc>:

void*
malloc(uint nbytes)
{
 773:	55                   	push   %ebp
 774:	89 e5                	mov    %esp,%ebp
 776:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 779:	8b 45 08             	mov    0x8(%ebp),%eax
 77c:	83 c0 07             	add    $0x7,%eax
 77f:	c1 e8 03             	shr    $0x3,%eax
 782:	83 c0 01             	add    $0x1,%eax
 785:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 788:	a1 e4 0a 00 00       	mov    0xae4,%eax
 78d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 790:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 794:	75 23                	jne    7b9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 796:	c7 45 f0 dc 0a 00 00 	movl   $0xadc,-0x10(%ebp)
 79d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a0:	a3 e4 0a 00 00       	mov    %eax,0xae4
 7a5:	a1 e4 0a 00 00       	mov    0xae4,%eax
 7aa:	a3 dc 0a 00 00       	mov    %eax,0xadc
    base.s.size = 0;
 7af:	c7 05 e0 0a 00 00 00 	movl   $0x0,0xae0
 7b6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bc:	8b 00                	mov    (%eax),%eax
 7be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	8b 40 04             	mov    0x4(%eax),%eax
 7c7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ca:	72 4d                	jb     819 <malloc+0xa6>
      if(p->s.size == nunits)
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	8b 40 04             	mov    0x4(%eax),%eax
 7d2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d5:	75 0c                	jne    7e3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7da:	8b 10                	mov    (%eax),%edx
 7dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7df:	89 10                	mov    %edx,(%eax)
 7e1:	eb 26                	jmp    809 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	8b 40 04             	mov    0x4(%eax),%eax
 7e9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7ec:	89 c2                	mov    %eax,%edx
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	8b 40 04             	mov    0x4(%eax),%eax
 7fa:	c1 e0 03             	shl    $0x3,%eax
 7fd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 55 ec             	mov    -0x14(%ebp),%edx
 806:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80c:	a3 e4 0a 00 00       	mov    %eax,0xae4
      return (void*)(p + 1);
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	83 c0 08             	add    $0x8,%eax
 817:	eb 38                	jmp    851 <malloc+0xde>
    }
    if(p == freep)
 819:	a1 e4 0a 00 00       	mov    0xae4,%eax
 81e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 821:	75 1b                	jne    83e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 823:	8b 45 ec             	mov    -0x14(%ebp),%eax
 826:	89 04 24             	mov    %eax,(%esp)
 829:	e8 ed fe ff ff       	call   71b <morecore>
 82e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 835:	75 07                	jne    83e <malloc+0xcb>
        return 0;
 837:	b8 00 00 00 00       	mov    $0x0,%eax
 83c:	eb 13                	jmp    851 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	89 45 f0             	mov    %eax,-0x10(%ebp)
 844:	8b 45 f4             	mov    -0xc(%ebp),%eax
 847:	8b 00                	mov    (%eax),%eax
 849:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 84c:	e9 70 ff ff ff       	jmp    7c1 <malloc+0x4e>
}
 851:	c9                   	leave  
 852:	c3                   	ret    
