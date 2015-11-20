
_mkdir:     file format elf32-i386


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
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 20                	jg     2f <main+0x2f>
    printf(2, "Usage: mkdir files...\n");
   f:	c7 44 24 04 83 08 00 	movl   $0x883,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 94 04 00 00       	call   4b7 <printf>
    exit(0);
  23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2a:	e8 e0 02 00 00       	call   30f <exit>
  }

  for(i = 1; i < argc; i++){
  2f:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  36:	00 
  37:	eb 59                	jmp    92 <main+0x92>
    if(mkdir(argv[i]) < 0){
  39:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  44:	8b 45 0c             	mov    0xc(%ebp),%eax
  47:	01 d0                	add    %edx,%eax
  49:	8b 00                	mov    (%eax),%eax
  4b:	89 04 24             	mov    %eax,(%esp)
  4e:	e8 24 03 00 00       	call   377 <mkdir>
  53:	85 c0                	test   %eax,%eax
  55:	79 36                	jns    8d <main+0x8d>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  57:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  62:	8b 45 0c             	mov    0xc(%ebp),%eax
  65:	01 d0                	add    %edx,%eax
  67:	8b 00                	mov    (%eax),%eax
  69:	89 44 24 08          	mov    %eax,0x8(%esp)
  6d:	c7 44 24 04 9a 08 00 	movl   $0x89a,0x4(%esp)
  74:	00 
  75:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  7c:	e8 36 04 00 00       	call   4b7 <printf>
      exit(-1);
  81:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  88:	e8 82 02 00 00       	call   30f <exit>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit(0);
  }

  for(i = 1; i < argc; i++){
  8d:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	3b 45 08             	cmp    0x8(%ebp),%eax
  99:	7c 9e                	jl     39 <main+0x39>
      exit(-1);
      break;
    }
  }

  exit(0);
  9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a2:	e8 68 02 00 00       	call   30f <exit>

000000a7 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  a7:	55                   	push   %ebp
  a8:	89 e5                	mov    %esp,%ebp
  aa:	57                   	push   %edi
  ab:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  af:	8b 55 10             	mov    0x10(%ebp),%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	89 cb                	mov    %ecx,%ebx
  b7:	89 df                	mov    %ebx,%edi
  b9:	89 d1                	mov    %edx,%ecx
  bb:	fc                   	cld    
  bc:	f3 aa                	rep stos %al,%es:(%edi)
  be:	89 ca                	mov    %ecx,%edx
  c0:	89 fb                	mov    %edi,%ebx
  c2:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c5:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  c8:	5b                   	pop    %ebx
  c9:	5f                   	pop    %edi
  ca:	5d                   	pop    %ebp
  cb:	c3                   	ret    

000000cc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  cc:	55                   	push   %ebp
  cd:	89 e5                	mov    %esp,%ebp
  cf:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  d8:	90                   	nop
  d9:	8b 45 08             	mov    0x8(%ebp),%eax
  dc:	8d 50 01             	lea    0x1(%eax),%edx
  df:	89 55 08             	mov    %edx,0x8(%ebp)
  e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  e8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  eb:	0f b6 12             	movzbl (%edx),%edx
  ee:	88 10                	mov    %dl,(%eax)
  f0:	0f b6 00             	movzbl (%eax),%eax
  f3:	84 c0                	test   %al,%al
  f5:	75 e2                	jne    d9 <strcpy+0xd>
    ;
  return os;
  f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fa:	c9                   	leave  
  fb:	c3                   	ret    

000000fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ff:	eb 08                	jmp    109 <strcmp+0xd>
    p++, q++;
 101:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 105:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	0f b6 00             	movzbl (%eax),%eax
 10f:	84 c0                	test   %al,%al
 111:	74 10                	je     123 <strcmp+0x27>
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	0f b6 10             	movzbl (%eax),%edx
 119:	8b 45 0c             	mov    0xc(%ebp),%eax
 11c:	0f b6 00             	movzbl (%eax),%eax
 11f:	38 c2                	cmp    %al,%dl
 121:	74 de                	je     101 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	0f b6 00             	movzbl (%eax),%eax
 129:	0f b6 d0             	movzbl %al,%edx
 12c:	8b 45 0c             	mov    0xc(%ebp),%eax
 12f:	0f b6 00             	movzbl (%eax),%eax
 132:	0f b6 c0             	movzbl %al,%eax
 135:	29 c2                	sub    %eax,%edx
 137:	89 d0                	mov    %edx,%eax
}
 139:	5d                   	pop    %ebp
 13a:	c3                   	ret    

0000013b <strlen>:

uint
strlen(char *s)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 141:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 148:	eb 04                	jmp    14e <strlen+0x13>
 14a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 14e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	01 d0                	add    %edx,%eax
 156:	0f b6 00             	movzbl (%eax),%eax
 159:	84 c0                	test   %al,%al
 15b:	75 ed                	jne    14a <strlen+0xf>
    ;
  return n;
 15d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 160:	c9                   	leave  
 161:	c3                   	ret    

00000162 <memset>:

void*
memset(void *dst, int c, uint n)
{
 162:	55                   	push   %ebp
 163:	89 e5                	mov    %esp,%ebp
 165:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 168:	8b 45 10             	mov    0x10(%ebp),%eax
 16b:	89 44 24 08          	mov    %eax,0x8(%esp)
 16f:	8b 45 0c             	mov    0xc(%ebp),%eax
 172:	89 44 24 04          	mov    %eax,0x4(%esp)
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	89 04 24             	mov    %eax,(%esp)
 17c:	e8 26 ff ff ff       	call   a7 <stosb>
  return dst;
 181:	8b 45 08             	mov    0x8(%ebp),%eax
}
 184:	c9                   	leave  
 185:	c3                   	ret    

00000186 <strchr>:

char*
strchr(const char *s, char c)
{
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	83 ec 04             	sub    $0x4,%esp
 18c:	8b 45 0c             	mov    0xc(%ebp),%eax
 18f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 192:	eb 14                	jmp    1a8 <strchr+0x22>
    if(*s == c)
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	0f b6 00             	movzbl (%eax),%eax
 19a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 19d:	75 05                	jne    1a4 <strchr+0x1e>
      return (char*)s;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	eb 13                	jmp    1b7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 00             	movzbl (%eax),%eax
 1ae:	84 c0                	test   %al,%al
 1b0:	75 e2                	jne    194 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b7:	c9                   	leave  
 1b8:	c3                   	ret    

000001b9 <gets>:

char*
gets(char *buf, int max)
{
 1b9:	55                   	push   %ebp
 1ba:	89 e5                	mov    %esp,%ebp
 1bc:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c6:	eb 4c                	jmp    214 <gets+0x5b>
    cc = read(0, &c, 1);
 1c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1cf:	00 
 1d0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1de:	e8 44 01 00 00       	call   327 <read>
 1e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ea:	7f 02                	jg     1ee <gets+0x35>
      break;
 1ec:	eb 31                	jmp    21f <gets+0x66>
    buf[i++] = c;
 1ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f1:	8d 50 01             	lea    0x1(%eax),%edx
 1f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1f7:	89 c2                	mov    %eax,%edx
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	01 c2                	add    %eax,%edx
 1fe:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 202:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 204:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 208:	3c 0a                	cmp    $0xa,%al
 20a:	74 13                	je     21f <gets+0x66>
 20c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 210:	3c 0d                	cmp    $0xd,%al
 212:	74 0b                	je     21f <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 214:	8b 45 f4             	mov    -0xc(%ebp),%eax
 217:	83 c0 01             	add    $0x1,%eax
 21a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 21d:	7c a9                	jl     1c8 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 21f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 222:	8b 45 08             	mov    0x8(%ebp),%eax
 225:	01 d0                	add    %edx,%eax
 227:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <stat>:

int
stat(char *n, struct stat *st)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 235:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 23c:	00 
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	89 04 24             	mov    %eax,(%esp)
 243:	e8 07 01 00 00       	call   34f <open>
 248:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 24b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 24f:	79 07                	jns    258 <stat+0x29>
    return -1;
 251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 256:	eb 23                	jmp    27b <stat+0x4c>
  r = fstat(fd, st);
 258:	8b 45 0c             	mov    0xc(%ebp),%eax
 25b:	89 44 24 04          	mov    %eax,0x4(%esp)
 25f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 262:	89 04 24             	mov    %eax,(%esp)
 265:	e8 fd 00 00 00       	call   367 <fstat>
 26a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 26d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 270:	89 04 24             	mov    %eax,(%esp)
 273:	e8 bf 00 00 00       	call   337 <close>
  return r;
 278:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 27b:	c9                   	leave  
 27c:	c3                   	ret    

0000027d <atoi>:

int
atoi(const char *s)
{
 27d:	55                   	push   %ebp
 27e:	89 e5                	mov    %esp,%ebp
 280:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 283:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 28a:	eb 25                	jmp    2b1 <atoi+0x34>
    n = n*10 + *s++ - '0';
 28c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28f:	89 d0                	mov    %edx,%eax
 291:	c1 e0 02             	shl    $0x2,%eax
 294:	01 d0                	add    %edx,%eax
 296:	01 c0                	add    %eax,%eax
 298:	89 c1                	mov    %eax,%ecx
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	8d 50 01             	lea    0x1(%eax),%edx
 2a0:	89 55 08             	mov    %edx,0x8(%ebp)
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	0f be c0             	movsbl %al,%eax
 2a9:	01 c8                	add    %ecx,%eax
 2ab:	83 e8 30             	sub    $0x30,%eax
 2ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	3c 2f                	cmp    $0x2f,%al
 2b9:	7e 0a                	jle    2c5 <atoi+0x48>
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	3c 39                	cmp    $0x39,%al
 2c3:	7e c7                	jle    28c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2dc:	eb 17                	jmp    2f5 <memmove+0x2b>
    *dst++ = *src++;
 2de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e1:	8d 50 01             	lea    0x1(%eax),%edx
 2e4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2e7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2ea:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ed:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2f0:	0f b6 12             	movzbl (%edx),%edx
 2f3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f5:	8b 45 10             	mov    0x10(%ebp),%eax
 2f8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2fb:	89 55 10             	mov    %edx,0x10(%ebp)
 2fe:	85 c0                	test   %eax,%eax
 300:	7f dc                	jg     2de <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 302:	8b 45 08             	mov    0x8(%ebp),%eax
}
 305:	c9                   	leave  
 306:	c3                   	ret    

00000307 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 307:	b8 01 00 00 00       	mov    $0x1,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <exit>:
SYSCALL(exit)
 30f:	b8 02 00 00 00       	mov    $0x2,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <wait>:
SYSCALL(wait)
 317:	b8 03 00 00 00       	mov    $0x3,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <pipe>:
SYSCALL(pipe)
 31f:	b8 04 00 00 00       	mov    $0x4,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <read>:
SYSCALL(read)
 327:	b8 05 00 00 00       	mov    $0x5,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <write>:
SYSCALL(write)
 32f:	b8 10 00 00 00       	mov    $0x10,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <close>:
SYSCALL(close)
 337:	b8 15 00 00 00       	mov    $0x15,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <kill>:
SYSCALL(kill)
 33f:	b8 06 00 00 00       	mov    $0x6,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <exec>:
SYSCALL(exec)
 347:	b8 07 00 00 00       	mov    $0x7,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <open>:
SYSCALL(open)
 34f:	b8 0f 00 00 00       	mov    $0xf,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <mknod>:
SYSCALL(mknod)
 357:	b8 11 00 00 00       	mov    $0x11,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <unlink>:
SYSCALL(unlink)
 35f:	b8 12 00 00 00       	mov    $0x12,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <fstat>:
SYSCALL(fstat)
 367:	b8 08 00 00 00       	mov    $0x8,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <link>:
SYSCALL(link)
 36f:	b8 13 00 00 00       	mov    $0x13,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <mkdir>:
SYSCALL(mkdir)
 377:	b8 14 00 00 00       	mov    $0x14,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <chdir>:
SYSCALL(chdir)
 37f:	b8 09 00 00 00       	mov    $0x9,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <dup>:
SYSCALL(dup)
 387:	b8 0a 00 00 00       	mov    $0xa,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <getpid>:
SYSCALL(getpid)
 38f:	b8 0b 00 00 00       	mov    $0xb,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <sbrk>:
SYSCALL(sbrk)
 397:	b8 0c 00 00 00       	mov    $0xc,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <sleep>:
SYSCALL(sleep)
 39f:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <uptime>:
SYSCALL(uptime)
 3a7:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <pstat>:
SYSCALL(pstat)
 3af:	b8 16 00 00 00       	mov    $0x16,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <printjob>:
SYSCALL(printjob)
 3b7:	b8 17 00 00 00       	mov    $0x17,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <attachjob>:
SYSCALL(attachjob)
 3bf:	b8 18 00 00 00       	mov    $0x18,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <fg>:
SYSCALL (fg)
 3c7:	b8 19 00 00 00       	mov    $0x19,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <waitpid>:
SYSCALL(waitpid)
 3cf:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp
 3da:	83 ec 18             	sub    $0x18,%esp
 3dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3e3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ea:	00 
 3eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f2:	8b 45 08             	mov    0x8(%ebp),%eax
 3f5:	89 04 24             	mov    %eax,(%esp)
 3f8:	e8 32 ff ff ff       	call   32f <write>
}
 3fd:	c9                   	leave  
 3fe:	c3                   	ret    

000003ff <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ff:	55                   	push   %ebp
 400:	89 e5                	mov    %esp,%ebp
 402:	56                   	push   %esi
 403:	53                   	push   %ebx
 404:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 407:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 40e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 412:	74 17                	je     42b <printint+0x2c>
 414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 418:	79 11                	jns    42b <printint+0x2c>
    neg = 1;
 41a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 421:	8b 45 0c             	mov    0xc(%ebp),%eax
 424:	f7 d8                	neg    %eax
 426:	89 45 ec             	mov    %eax,-0x14(%ebp)
 429:	eb 06                	jmp    431 <printint+0x32>
  } else {
    x = xx;
 42b:	8b 45 0c             	mov    0xc(%ebp),%eax
 42e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 431:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 438:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 43b:	8d 41 01             	lea    0x1(%ecx),%eax
 43e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 441:	8b 5d 10             	mov    0x10(%ebp),%ebx
 444:	8b 45 ec             	mov    -0x14(%ebp),%eax
 447:	ba 00 00 00 00       	mov    $0x0,%edx
 44c:	f7 f3                	div    %ebx
 44e:	89 d0                	mov    %edx,%eax
 450:	0f b6 80 04 0b 00 00 	movzbl 0xb04(%eax),%eax
 457:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 45b:	8b 75 10             	mov    0x10(%ebp),%esi
 45e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 461:	ba 00 00 00 00       	mov    $0x0,%edx
 466:	f7 f6                	div    %esi
 468:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46f:	75 c7                	jne    438 <printint+0x39>
  if(neg)
 471:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 475:	74 10                	je     487 <printint+0x88>
    buf[i++] = '-';
 477:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47a:	8d 50 01             	lea    0x1(%eax),%edx
 47d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 480:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 485:	eb 1f                	jmp    4a6 <printint+0xa7>
 487:	eb 1d                	jmp    4a6 <printint+0xa7>
    putc(fd, buf[i]);
 489:	8d 55 dc             	lea    -0x24(%ebp),%edx
 48c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48f:	01 d0                	add    %edx,%eax
 491:	0f b6 00             	movzbl (%eax),%eax
 494:	0f be c0             	movsbl %al,%eax
 497:	89 44 24 04          	mov    %eax,0x4(%esp)
 49b:	8b 45 08             	mov    0x8(%ebp),%eax
 49e:	89 04 24             	mov    %eax,(%esp)
 4a1:	e8 31 ff ff ff       	call   3d7 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4a6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ae:	79 d9                	jns    489 <printint+0x8a>
    putc(fd, buf[i]);
}
 4b0:	83 c4 30             	add    $0x30,%esp
 4b3:	5b                   	pop    %ebx
 4b4:	5e                   	pop    %esi
 4b5:	5d                   	pop    %ebp
 4b6:	c3                   	ret    

000004b7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4b7:	55                   	push   %ebp
 4b8:	89 e5                	mov    %esp,%ebp
 4ba:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c4:	8d 45 0c             	lea    0xc(%ebp),%eax
 4c7:	83 c0 04             	add    $0x4,%eax
 4ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d4:	e9 7c 01 00 00       	jmp    655 <printf+0x19e>
    c = fmt[i] & 0xff;
 4d9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4df:	01 d0                	add    %edx,%eax
 4e1:	0f b6 00             	movzbl (%eax),%eax
 4e4:	0f be c0             	movsbl %al,%eax
 4e7:	25 ff 00 00 00       	and    $0xff,%eax
 4ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f3:	75 2c                	jne    521 <printf+0x6a>
      if(c == '%'){
 4f5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4f9:	75 0c                	jne    507 <printf+0x50>
        state = '%';
 4fb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 502:	e9 4a 01 00 00       	jmp    651 <printf+0x19a>
      } else {
        putc(fd, c);
 507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 50a:	0f be c0             	movsbl %al,%eax
 50d:	89 44 24 04          	mov    %eax,0x4(%esp)
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	89 04 24             	mov    %eax,(%esp)
 517:	e8 bb fe ff ff       	call   3d7 <putc>
 51c:	e9 30 01 00 00       	jmp    651 <printf+0x19a>
      }
    } else if(state == '%'){
 521:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 525:	0f 85 26 01 00 00    	jne    651 <printf+0x19a>
      if(c == 'd'){
 52b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 52f:	75 2d                	jne    55e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 531:	8b 45 e8             	mov    -0x18(%ebp),%eax
 534:	8b 00                	mov    (%eax),%eax
 536:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 53d:	00 
 53e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 545:	00 
 546:	89 44 24 04          	mov    %eax,0x4(%esp)
 54a:	8b 45 08             	mov    0x8(%ebp),%eax
 54d:	89 04 24             	mov    %eax,(%esp)
 550:	e8 aa fe ff ff       	call   3ff <printint>
        ap++;
 555:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 559:	e9 ec 00 00 00       	jmp    64a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 55e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 562:	74 06                	je     56a <printf+0xb3>
 564:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 568:	75 2d                	jne    597 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 56a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56d:	8b 00                	mov    (%eax),%eax
 56f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 576:	00 
 577:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 57e:	00 
 57f:	89 44 24 04          	mov    %eax,0x4(%esp)
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	89 04 24             	mov    %eax,(%esp)
 589:	e8 71 fe ff ff       	call   3ff <printint>
        ap++;
 58e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 592:	e9 b3 00 00 00       	jmp    64a <printf+0x193>
      } else if(c == 's'){
 597:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 59b:	75 45                	jne    5e2 <printf+0x12b>
        s = (char*)*ap;
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ad:	75 09                	jne    5b8 <printf+0x101>
          s = "(null)";
 5af:	c7 45 f4 b6 08 00 00 	movl   $0x8b6,-0xc(%ebp)
        while(*s != 0){
 5b6:	eb 1e                	jmp    5d6 <printf+0x11f>
 5b8:	eb 1c                	jmp    5d6 <printf+0x11f>
          putc(fd, *s);
 5ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bd:	0f b6 00             	movzbl (%eax),%eax
 5c0:	0f be c0             	movsbl %al,%eax
 5c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	89 04 24             	mov    %eax,(%esp)
 5cd:	e8 05 fe ff ff       	call   3d7 <putc>
          s++;
 5d2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d9:	0f b6 00             	movzbl (%eax),%eax
 5dc:	84 c0                	test   %al,%al
 5de:	75 da                	jne    5ba <printf+0x103>
 5e0:	eb 68                	jmp    64a <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e6:	75 1d                	jne    605 <printf+0x14e>
        putc(fd, *ap);
 5e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5eb:	8b 00                	mov    (%eax),%eax
 5ed:	0f be c0             	movsbl %al,%eax
 5f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f4:	8b 45 08             	mov    0x8(%ebp),%eax
 5f7:	89 04 24             	mov    %eax,(%esp)
 5fa:	e8 d8 fd ff ff       	call   3d7 <putc>
        ap++;
 5ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 603:	eb 45                	jmp    64a <printf+0x193>
      } else if(c == '%'){
 605:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 609:	75 17                	jne    622 <printf+0x16b>
        putc(fd, c);
 60b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60e:	0f be c0             	movsbl %al,%eax
 611:	89 44 24 04          	mov    %eax,0x4(%esp)
 615:	8b 45 08             	mov    0x8(%ebp),%eax
 618:	89 04 24             	mov    %eax,(%esp)
 61b:	e8 b7 fd ff ff       	call   3d7 <putc>
 620:	eb 28                	jmp    64a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 622:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 629:	00 
 62a:	8b 45 08             	mov    0x8(%ebp),%eax
 62d:	89 04 24             	mov    %eax,(%esp)
 630:	e8 a2 fd ff ff       	call   3d7 <putc>
        putc(fd, c);
 635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 638:	0f be c0             	movsbl %al,%eax
 63b:	89 44 24 04          	mov    %eax,0x4(%esp)
 63f:	8b 45 08             	mov    0x8(%ebp),%eax
 642:	89 04 24             	mov    %eax,(%esp)
 645:	e8 8d fd ff ff       	call   3d7 <putc>
      }
      state = 0;
 64a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 651:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 655:	8b 55 0c             	mov    0xc(%ebp),%edx
 658:	8b 45 f0             	mov    -0x10(%ebp),%eax
 65b:	01 d0                	add    %edx,%eax
 65d:	0f b6 00             	movzbl (%eax),%eax
 660:	84 c0                	test   %al,%al
 662:	0f 85 71 fe ff ff    	jne    4d9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 668:	c9                   	leave  
 669:	c3                   	ret    

0000066a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 66a:	55                   	push   %ebp
 66b:	89 e5                	mov    %esp,%ebp
 66d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 670:	8b 45 08             	mov    0x8(%ebp),%eax
 673:	83 e8 08             	sub    $0x8,%eax
 676:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 679:	a1 20 0b 00 00       	mov    0xb20,%eax
 67e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 681:	eb 24                	jmp    6a7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	8b 00                	mov    (%eax),%eax
 688:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68b:	77 12                	ja     69f <free+0x35>
 68d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 690:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 693:	77 24                	ja     6b9 <free+0x4f>
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69d:	77 1a                	ja     6b9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ad:	76 d4                	jbe    683 <free+0x19>
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b7:	76 ca                	jbe    683 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	8b 40 04             	mov    0x4(%eax),%eax
 6bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	01 c2                	add    %eax,%edx
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	39 c2                	cmp    %eax,%edx
 6d2:	75 24                	jne    6f8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	8b 50 04             	mov    0x4(%eax),%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	8b 00                	mov    (%eax),%eax
 6df:	8b 40 04             	mov    0x4(%eax),%eax
 6e2:	01 c2                	add    %eax,%edx
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ed:	8b 00                	mov    (%eax),%eax
 6ef:	8b 10                	mov    (%eax),%edx
 6f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f4:	89 10                	mov    %edx,(%eax)
 6f6:	eb 0a                	jmp    702 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	8b 10                	mov    (%eax),%edx
 6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 700:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 40 04             	mov    0x4(%eax),%eax
 708:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	01 d0                	add    %edx,%eax
 714:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 717:	75 20                	jne    739 <free+0xcf>
    p->s.size += bp->s.size;
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	8b 50 04             	mov    0x4(%eax),%edx
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	8b 40 04             	mov    0x4(%eax),%eax
 725:	01 c2                	add    %eax,%edx
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 72d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 730:	8b 10                	mov    (%eax),%edx
 732:	8b 45 fc             	mov    -0x4(%ebp),%eax
 735:	89 10                	mov    %edx,(%eax)
 737:	eb 08                	jmp    741 <free+0xd7>
  } else
    p->s.ptr = bp;
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 73f:	89 10                	mov    %edx,(%eax)
  freep = p;
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	a3 20 0b 00 00       	mov    %eax,0xb20
}
 749:	c9                   	leave  
 74a:	c3                   	ret    

0000074b <morecore>:

static Header*
morecore(uint nu)
{
 74b:	55                   	push   %ebp
 74c:	89 e5                	mov    %esp,%ebp
 74e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 751:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 758:	77 07                	ja     761 <morecore+0x16>
    nu = 4096;
 75a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 761:	8b 45 08             	mov    0x8(%ebp),%eax
 764:	c1 e0 03             	shl    $0x3,%eax
 767:	89 04 24             	mov    %eax,(%esp)
 76a:	e8 28 fc ff ff       	call   397 <sbrk>
 76f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 772:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 776:	75 07                	jne    77f <morecore+0x34>
    return 0;
 778:	b8 00 00 00 00       	mov    $0x0,%eax
 77d:	eb 22                	jmp    7a1 <morecore+0x56>
  hp = (Header*)p;
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	8b 55 08             	mov    0x8(%ebp),%edx
 78b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 78e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 791:	83 c0 08             	add    $0x8,%eax
 794:	89 04 24             	mov    %eax,(%esp)
 797:	e8 ce fe ff ff       	call   66a <free>
  return freep;
 79c:	a1 20 0b 00 00       	mov    0xb20,%eax
}
 7a1:	c9                   	leave  
 7a2:	c3                   	ret    

000007a3 <malloc>:

void*
malloc(uint nbytes)
{
 7a3:	55                   	push   %ebp
 7a4:	89 e5                	mov    %esp,%ebp
 7a6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ac:	83 c0 07             	add    $0x7,%eax
 7af:	c1 e8 03             	shr    $0x3,%eax
 7b2:	83 c0 01             	add    $0x1,%eax
 7b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b8:	a1 20 0b 00 00       	mov    0xb20,%eax
 7bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c4:	75 23                	jne    7e9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7c6:	c7 45 f0 18 0b 00 00 	movl   $0xb18,-0x10(%ebp)
 7cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d0:	a3 20 0b 00 00       	mov    %eax,0xb20
 7d5:	a1 20 0b 00 00       	mov    0xb20,%eax
 7da:	a3 18 0b 00 00       	mov    %eax,0xb18
    base.s.size = 0;
 7df:	c7 05 1c 0b 00 00 00 	movl   $0x0,0xb1c
 7e6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	8b 40 04             	mov    0x4(%eax),%eax
 7f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7fa:	72 4d                	jb     849 <malloc+0xa6>
      if(p->s.size == nunits)
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	8b 40 04             	mov    0x4(%eax),%eax
 802:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 805:	75 0c                	jne    813 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 807:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80a:	8b 10                	mov    (%eax),%edx
 80c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80f:	89 10                	mov    %edx,(%eax)
 811:	eb 26                	jmp    839 <malloc+0x96>
      else {
        p->s.size -= nunits;
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	8b 40 04             	mov    0x4(%eax),%eax
 819:	2b 45 ec             	sub    -0x14(%ebp),%eax
 81c:	89 c2                	mov    %eax,%edx
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	8b 40 04             	mov    0x4(%eax),%eax
 82a:	c1 e0 03             	shl    $0x3,%eax
 82d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	8b 55 ec             	mov    -0x14(%ebp),%edx
 836:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 839:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83c:	a3 20 0b 00 00       	mov    %eax,0xb20
      return (void*)(p + 1);
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	83 c0 08             	add    $0x8,%eax
 847:	eb 38                	jmp    881 <malloc+0xde>
    }
    if(p == freep)
 849:	a1 20 0b 00 00       	mov    0xb20,%eax
 84e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 851:	75 1b                	jne    86e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 853:	8b 45 ec             	mov    -0x14(%ebp),%eax
 856:	89 04 24             	mov    %eax,(%esp)
 859:	e8 ed fe ff ff       	call   74b <morecore>
 85e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 865:	75 07                	jne    86e <malloc+0xcb>
        return 0;
 867:	b8 00 00 00 00       	mov    $0x0,%eax
 86c:	eb 13                	jmp    881 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	89 45 f0             	mov    %eax,-0x10(%ebp)
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 00                	mov    (%eax),%eax
 879:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 87c:	e9 70 ff ff ff       	jmp    7f1 <malloc+0x4e>
}
 881:	c9                   	leave  
 882:	c3                   	ret    
