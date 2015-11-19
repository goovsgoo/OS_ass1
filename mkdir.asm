
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
   f:	c7 44 24 04 73 08 00 	movl   $0x873,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 84 04 00 00       	call   4a7 <printf>
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
  6d:	c7 44 24 04 8a 08 00 	movl   $0x88a,0x4(%esp)
  74:	00 
  75:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  7c:	e8 26 04 00 00       	call   4a7 <printf>
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

000003c7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c7:	55                   	push   %ebp
 3c8:	89 e5                	mov    %esp,%ebp
 3ca:	83 ec 18             	sub    $0x18,%esp
 3cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3d3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3da:	00 
 3db:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3de:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	89 04 24             	mov    %eax,(%esp)
 3e8:	e8 42 ff ff ff       	call   32f <write>
}
 3ed:	c9                   	leave  
 3ee:	c3                   	ret    

000003ef <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ef:	55                   	push   %ebp
 3f0:	89 e5                	mov    %esp,%ebp
 3f2:	56                   	push   %esi
 3f3:	53                   	push   %ebx
 3f4:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3fe:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 402:	74 17                	je     41b <printint+0x2c>
 404:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 408:	79 11                	jns    41b <printint+0x2c>
    neg = 1;
 40a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 411:	8b 45 0c             	mov    0xc(%ebp),%eax
 414:	f7 d8                	neg    %eax
 416:	89 45 ec             	mov    %eax,-0x14(%ebp)
 419:	eb 06                	jmp    421 <printint+0x32>
  } else {
    x = xx;
 41b:	8b 45 0c             	mov    0xc(%ebp),%eax
 41e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 421:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 428:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 42b:	8d 41 01             	lea    0x1(%ecx),%eax
 42e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 431:	8b 5d 10             	mov    0x10(%ebp),%ebx
 434:	8b 45 ec             	mov    -0x14(%ebp),%eax
 437:	ba 00 00 00 00       	mov    $0x0,%edx
 43c:	f7 f3                	div    %ebx
 43e:	89 d0                	mov    %edx,%eax
 440:	0f b6 80 f4 0a 00 00 	movzbl 0xaf4(%eax),%eax
 447:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 44b:	8b 75 10             	mov    0x10(%ebp),%esi
 44e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 451:	ba 00 00 00 00       	mov    $0x0,%edx
 456:	f7 f6                	div    %esi
 458:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 45f:	75 c7                	jne    428 <printint+0x39>
  if(neg)
 461:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 465:	74 10                	je     477 <printint+0x88>
    buf[i++] = '-';
 467:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46a:	8d 50 01             	lea    0x1(%eax),%edx
 46d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 470:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 475:	eb 1f                	jmp    496 <printint+0xa7>
 477:	eb 1d                	jmp    496 <printint+0xa7>
    putc(fd, buf[i]);
 479:	8d 55 dc             	lea    -0x24(%ebp),%edx
 47c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47f:	01 d0                	add    %edx,%eax
 481:	0f b6 00             	movzbl (%eax),%eax
 484:	0f be c0             	movsbl %al,%eax
 487:	89 44 24 04          	mov    %eax,0x4(%esp)
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	89 04 24             	mov    %eax,(%esp)
 491:	e8 31 ff ff ff       	call   3c7 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 496:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 49a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49e:	79 d9                	jns    479 <printint+0x8a>
    putc(fd, buf[i]);
}
 4a0:	83 c4 30             	add    $0x30,%esp
 4a3:	5b                   	pop    %ebx
 4a4:	5e                   	pop    %esi
 4a5:	5d                   	pop    %ebp
 4a6:	c3                   	ret    

000004a7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a7:	55                   	push   %ebp
 4a8:	89 e5                	mov    %esp,%ebp
 4aa:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b4:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b7:	83 c0 04             	add    $0x4,%eax
 4ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c4:	e9 7c 01 00 00       	jmp    645 <printf+0x19e>
    c = fmt[i] & 0xff;
 4c9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4cf:	01 d0                	add    %edx,%eax
 4d1:	0f b6 00             	movzbl (%eax),%eax
 4d4:	0f be c0             	movsbl %al,%eax
 4d7:	25 ff 00 00 00       	and    $0xff,%eax
 4dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e3:	75 2c                	jne    511 <printf+0x6a>
      if(c == '%'){
 4e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e9:	75 0c                	jne    4f7 <printf+0x50>
        state = '%';
 4eb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4f2:	e9 4a 01 00 00       	jmp    641 <printf+0x19a>
      } else {
        putc(fd, c);
 4f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4fa:	0f be c0             	movsbl %al,%eax
 4fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 501:	8b 45 08             	mov    0x8(%ebp),%eax
 504:	89 04 24             	mov    %eax,(%esp)
 507:	e8 bb fe ff ff       	call   3c7 <putc>
 50c:	e9 30 01 00 00       	jmp    641 <printf+0x19a>
      }
    } else if(state == '%'){
 511:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 515:	0f 85 26 01 00 00    	jne    641 <printf+0x19a>
      if(c == 'd'){
 51b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 51f:	75 2d                	jne    54e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 521:	8b 45 e8             	mov    -0x18(%ebp),%eax
 524:	8b 00                	mov    (%eax),%eax
 526:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 52d:	00 
 52e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 535:	00 
 536:	89 44 24 04          	mov    %eax,0x4(%esp)
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	89 04 24             	mov    %eax,(%esp)
 540:	e8 aa fe ff ff       	call   3ef <printint>
        ap++;
 545:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 549:	e9 ec 00 00 00       	jmp    63a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 54e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 552:	74 06                	je     55a <printf+0xb3>
 554:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 558:	75 2d                	jne    587 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 55a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55d:	8b 00                	mov    (%eax),%eax
 55f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 566:	00 
 567:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 56e:	00 
 56f:	89 44 24 04          	mov    %eax,0x4(%esp)
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	89 04 24             	mov    %eax,(%esp)
 579:	e8 71 fe ff ff       	call   3ef <printint>
        ap++;
 57e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 582:	e9 b3 00 00 00       	jmp    63a <printf+0x193>
      } else if(c == 's'){
 587:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 58b:	75 45                	jne    5d2 <printf+0x12b>
        s = (char*)*ap;
 58d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 590:	8b 00                	mov    (%eax),%eax
 592:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 595:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59d:	75 09                	jne    5a8 <printf+0x101>
          s = "(null)";
 59f:	c7 45 f4 a6 08 00 00 	movl   $0x8a6,-0xc(%ebp)
        while(*s != 0){
 5a6:	eb 1e                	jmp    5c6 <printf+0x11f>
 5a8:	eb 1c                	jmp    5c6 <printf+0x11f>
          putc(fd, *s);
 5aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ad:	0f b6 00             	movzbl (%eax),%eax
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	89 04 24             	mov    %eax,(%esp)
 5bd:	e8 05 fe ff ff       	call   3c7 <putc>
          s++;
 5c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c9:	0f b6 00             	movzbl (%eax),%eax
 5cc:	84 c0                	test   %al,%al
 5ce:	75 da                	jne    5aa <printf+0x103>
 5d0:	eb 68                	jmp    63a <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d6:	75 1d                	jne    5f5 <printf+0x14e>
        putc(fd, *ap);
 5d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5db:	8b 00                	mov    (%eax),%eax
 5dd:	0f be c0             	movsbl %al,%eax
 5e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
 5e7:	89 04 24             	mov    %eax,(%esp)
 5ea:	e8 d8 fd ff ff       	call   3c7 <putc>
        ap++;
 5ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f3:	eb 45                	jmp    63a <printf+0x193>
      } else if(c == '%'){
 5f5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f9:	75 17                	jne    612 <printf+0x16b>
        putc(fd, c);
 5fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fe:	0f be c0             	movsbl %al,%eax
 601:	89 44 24 04          	mov    %eax,0x4(%esp)
 605:	8b 45 08             	mov    0x8(%ebp),%eax
 608:	89 04 24             	mov    %eax,(%esp)
 60b:	e8 b7 fd ff ff       	call   3c7 <putc>
 610:	eb 28                	jmp    63a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 612:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 619:	00 
 61a:	8b 45 08             	mov    0x8(%ebp),%eax
 61d:	89 04 24             	mov    %eax,(%esp)
 620:	e8 a2 fd ff ff       	call   3c7 <putc>
        putc(fd, c);
 625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 628:	0f be c0             	movsbl %al,%eax
 62b:	89 44 24 04          	mov    %eax,0x4(%esp)
 62f:	8b 45 08             	mov    0x8(%ebp),%eax
 632:	89 04 24             	mov    %eax,(%esp)
 635:	e8 8d fd ff ff       	call   3c7 <putc>
      }
      state = 0;
 63a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 641:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 645:	8b 55 0c             	mov    0xc(%ebp),%edx
 648:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64b:	01 d0                	add    %edx,%eax
 64d:	0f b6 00             	movzbl (%eax),%eax
 650:	84 c0                	test   %al,%al
 652:	0f 85 71 fe ff ff    	jne    4c9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 658:	c9                   	leave  
 659:	c3                   	ret    

0000065a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65a:	55                   	push   %ebp
 65b:	89 e5                	mov    %esp,%ebp
 65d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 660:	8b 45 08             	mov    0x8(%ebp),%eax
 663:	83 e8 08             	sub    $0x8,%eax
 666:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 669:	a1 10 0b 00 00       	mov    0xb10,%eax
 66e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 671:	eb 24                	jmp    697 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	8b 00                	mov    (%eax),%eax
 678:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67b:	77 12                	ja     68f <free+0x35>
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 683:	77 24                	ja     6a9 <free+0x4f>
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68d:	77 1a                	ja     6a9 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	89 45 fc             	mov    %eax,-0x4(%ebp)
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69d:	76 d4                	jbe    673 <free+0x19>
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a7:	76 ca                	jbe    673 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	8b 40 04             	mov    0x4(%eax),%eax
 6af:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	01 c2                	add    %eax,%edx
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 00                	mov    (%eax),%eax
 6c0:	39 c2                	cmp    %eax,%edx
 6c2:	75 24                	jne    6e8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	8b 50 04             	mov    0x4(%eax),%edx
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	8b 00                	mov    (%eax),%eax
 6cf:	8b 40 04             	mov    0x4(%eax),%eax
 6d2:	01 c2                	add    %eax,%edx
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	8b 00                	mov    (%eax),%eax
 6df:	8b 10                	mov    (%eax),%edx
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	89 10                	mov    %edx,(%eax)
 6e6:	eb 0a                	jmp    6f2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 10                	mov    (%eax),%edx
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 40 04             	mov    0x4(%eax),%eax
 6f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	01 d0                	add    %edx,%eax
 704:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 707:	75 20                	jne    729 <free+0xcf>
    p->s.size += bp->s.size;
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 50 04             	mov    0x4(%eax),%edx
 70f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 712:	8b 40 04             	mov    0x4(%eax),%eax
 715:	01 c2                	add    %eax,%edx
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 71d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 720:	8b 10                	mov    (%eax),%edx
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	89 10                	mov    %edx,(%eax)
 727:	eb 08                	jmp    731 <free+0xd7>
  } else
    p->s.ptr = bp;
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 72f:	89 10                	mov    %edx,(%eax)
  freep = p;
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	a3 10 0b 00 00       	mov    %eax,0xb10
}
 739:	c9                   	leave  
 73a:	c3                   	ret    

0000073b <morecore>:

static Header*
morecore(uint nu)
{
 73b:	55                   	push   %ebp
 73c:	89 e5                	mov    %esp,%ebp
 73e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 741:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 748:	77 07                	ja     751 <morecore+0x16>
    nu = 4096;
 74a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 751:	8b 45 08             	mov    0x8(%ebp),%eax
 754:	c1 e0 03             	shl    $0x3,%eax
 757:	89 04 24             	mov    %eax,(%esp)
 75a:	e8 38 fc ff ff       	call   397 <sbrk>
 75f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 762:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 766:	75 07                	jne    76f <morecore+0x34>
    return 0;
 768:	b8 00 00 00 00       	mov    $0x0,%eax
 76d:	eb 22                	jmp    791 <morecore+0x56>
  hp = (Header*)p;
 76f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 772:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	8b 55 08             	mov    0x8(%ebp),%edx
 77b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 77e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 781:	83 c0 08             	add    $0x8,%eax
 784:	89 04 24             	mov    %eax,(%esp)
 787:	e8 ce fe ff ff       	call   65a <free>
  return freep;
 78c:	a1 10 0b 00 00       	mov    0xb10,%eax
}
 791:	c9                   	leave  
 792:	c3                   	ret    

00000793 <malloc>:

void*
malloc(uint nbytes)
{
 793:	55                   	push   %ebp
 794:	89 e5                	mov    %esp,%ebp
 796:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 799:	8b 45 08             	mov    0x8(%ebp),%eax
 79c:	83 c0 07             	add    $0x7,%eax
 79f:	c1 e8 03             	shr    $0x3,%eax
 7a2:	83 c0 01             	add    $0x1,%eax
 7a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7a8:	a1 10 0b 00 00       	mov    0xb10,%eax
 7ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b4:	75 23                	jne    7d9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7b6:	c7 45 f0 08 0b 00 00 	movl   $0xb08,-0x10(%ebp)
 7bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c0:	a3 10 0b 00 00       	mov    %eax,0xb10
 7c5:	a1 10 0b 00 00       	mov    0xb10,%eax
 7ca:	a3 08 0b 00 00       	mov    %eax,0xb08
    base.s.size = 0;
 7cf:	c7 05 0c 0b 00 00 00 	movl   $0x0,0xb0c
 7d6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	8b 40 04             	mov    0x4(%eax),%eax
 7e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ea:	72 4d                	jb     839 <malloc+0xa6>
      if(p->s.size == nunits)
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	8b 40 04             	mov    0x4(%eax),%eax
 7f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f5:	75 0c                	jne    803 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	8b 10                	mov    (%eax),%edx
 7fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ff:	89 10                	mov    %edx,(%eax)
 801:	eb 26                	jmp    829 <malloc+0x96>
      else {
        p->s.size -= nunits;
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	8b 40 04             	mov    0x4(%eax),%eax
 809:	2b 45 ec             	sub    -0x14(%ebp),%eax
 80c:	89 c2                	mov    %eax,%edx
 80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 811:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	8b 40 04             	mov    0x4(%eax),%eax
 81a:	c1 e0 03             	shl    $0x3,%eax
 81d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	8b 55 ec             	mov    -0x14(%ebp),%edx
 826:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 829:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82c:	a3 10 0b 00 00       	mov    %eax,0xb10
      return (void*)(p + 1);
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	83 c0 08             	add    $0x8,%eax
 837:	eb 38                	jmp    871 <malloc+0xde>
    }
    if(p == freep)
 839:	a1 10 0b 00 00       	mov    0xb10,%eax
 83e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 841:	75 1b                	jne    85e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 843:	8b 45 ec             	mov    -0x14(%ebp),%eax
 846:	89 04 24             	mov    %eax,(%esp)
 849:	e8 ed fe ff ff       	call   73b <morecore>
 84e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 855:	75 07                	jne    85e <malloc+0xcb>
        return 0;
 857:	b8 00 00 00 00       	mov    $0x0,%eax
 85c:	eb 13                	jmp    871 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	89 45 f0             	mov    %eax,-0x10(%ebp)
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 86c:	e9 70 ff ff ff       	jmp    7e1 <malloc+0x4e>
}
 871:	c9                   	leave  
 872:	c3                   	ret    
