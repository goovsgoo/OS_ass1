
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 20                	jg     2f <main+0x2f>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 51 08 00 	movl   $0x851,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 62 04 00 00       	call   485 <printf>
    exit(0);
  23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2a:	e8 ae 02 00 00       	call   2dd <exit>
  }
  for(i=1; i<argc; i++)
  2f:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  36:	00 
  37:	eb 27                	jmp    60 <main+0x60>
    kill(atoi(argv[i]));
  39:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  44:	8b 45 0c             	mov    0xc(%ebp),%eax
  47:	01 d0                	add    %edx,%eax
  49:	8b 00                	mov    (%eax),%eax
  4b:	89 04 24             	mov    %eax,(%esp)
  4e:	e8 f8 01 00 00       	call   24b <atoi>
  53:	89 04 24             	mov    %eax,(%esp)
  56:	e8 b2 02 00 00       	call   30d <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit(0);
  }
  for(i=1; i<argc; i++)
  5b:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  60:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  64:	3b 45 08             	cmp    0x8(%ebp),%eax
  67:	7c d0                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit(0);
  69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  70:	e8 68 02 00 00       	call   2dd <exit>

00000075 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  75:	55                   	push   %ebp
  76:	89 e5                	mov    %esp,%ebp
  78:	57                   	push   %edi
  79:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7d:	8b 55 10             	mov    0x10(%ebp),%edx
  80:	8b 45 0c             	mov    0xc(%ebp),%eax
  83:	89 cb                	mov    %ecx,%ebx
  85:	89 df                	mov    %ebx,%edi
  87:	89 d1                	mov    %edx,%ecx
  89:	fc                   	cld    
  8a:	f3 aa                	rep stos %al,%es:(%edi)
  8c:	89 ca                	mov    %ecx,%edx
  8e:	89 fb                	mov    %edi,%ebx
  90:	89 5d 08             	mov    %ebx,0x8(%ebp)
  93:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	8d 50 01             	lea    0x1(%eax),%edx
  ad:	89 55 08             	mov    %edx,0x8(%ebp)
  b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 136:	8b 45 10             	mov    0x10(%ebp),%eax
 139:	89 44 24 08          	mov    %eax,0x8(%esp)
 13d:	8b 45 0c             	mov    0xc(%ebp),%eax
 140:	89 44 24 04          	mov    %eax,0x4(%esp)
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	89 04 24             	mov    %eax,(%esp)
 14a:	e8 26 ff ff ff       	call   75 <stosb>
  return dst;
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <strchr>:

char*
strchr(const char *s, char c)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	83 ec 04             	sub    $0x4,%esp
 15a:	8b 45 0c             	mov    0xc(%ebp),%eax
 15d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 160:	eb 14                	jmp    176 <strchr+0x22>
    if(*s == c)
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	0f b6 00             	movzbl (%eax),%eax
 168:	3a 45 fc             	cmp    -0x4(%ebp),%al
 16b:	75 05                	jne    172 <strchr+0x1e>
      return (char*)s;
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	eb 13                	jmp    185 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 172:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	0f b6 00             	movzbl (%eax),%eax
 17c:	84 c0                	test   %al,%al
 17e:	75 e2                	jne    162 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 180:	b8 00 00 00 00       	mov    $0x0,%eax
}
 185:	c9                   	leave  
 186:	c3                   	ret    

00000187 <gets>:

char*
gets(char *buf, int max)
{
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
 18a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 194:	eb 4c                	jmp    1e2 <gets+0x5b>
    cc = read(0, &c, 1);
 196:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 19d:	00 
 19e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1ac:	e8 44 01 00 00       	call   2f5 <read>
 1b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b8:	7f 02                	jg     1bc <gets+0x35>
      break;
 1ba:	eb 31                	jmp    1ed <gets+0x66>
    buf[i++] = c;
 1bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1bf:	8d 50 01             	lea    0x1(%eax),%edx
 1c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c5:	89 c2                	mov    %eax,%edx
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	01 c2                	add    %eax,%edx
 1cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d6:	3c 0a                	cmp    $0xa,%al
 1d8:	74 13                	je     1ed <gets+0x66>
 1da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1de:	3c 0d                	cmp    $0xd,%al
 1e0:	74 0b                	je     1ed <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e5:	83 c0 01             	add    $0x1,%eax
 1e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1eb:	7c a9                	jl     196 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	01 d0                	add    %edx,%eax
 1f5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fb:	c9                   	leave  
 1fc:	c3                   	ret    

000001fd <stat>:

int
stat(char *n, struct stat *st)
{
 1fd:	55                   	push   %ebp
 1fe:	89 e5                	mov    %esp,%ebp
 200:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 203:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20a:	00 
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	89 04 24             	mov    %eax,(%esp)
 211:	e8 07 01 00 00       	call   31d <open>
 216:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 21d:	79 07                	jns    226 <stat+0x29>
    return -1;
 21f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 224:	eb 23                	jmp    249 <stat+0x4c>
  r = fstat(fd, st);
 226:	8b 45 0c             	mov    0xc(%ebp),%eax
 229:	89 44 24 04          	mov    %eax,0x4(%esp)
 22d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 230:	89 04 24             	mov    %eax,(%esp)
 233:	e8 fd 00 00 00       	call   335 <fstat>
 238:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 23b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23e:	89 04 24             	mov    %eax,(%esp)
 241:	e8 bf 00 00 00       	call   305 <close>
  return r;
 246:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 249:	c9                   	leave  
 24a:	c3                   	ret    

0000024b <atoi>:

int
atoi(const char *s)
{
 24b:	55                   	push   %ebp
 24c:	89 e5                	mov    %esp,%ebp
 24e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 251:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 258:	eb 25                	jmp    27f <atoi+0x34>
    n = n*10 + *s++ - '0';
 25a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 25d:	89 d0                	mov    %edx,%eax
 25f:	c1 e0 02             	shl    $0x2,%eax
 262:	01 d0                	add    %edx,%eax
 264:	01 c0                	add    %eax,%eax
 266:	89 c1                	mov    %eax,%ecx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	8d 50 01             	lea    0x1(%eax),%edx
 26e:	89 55 08             	mov    %edx,0x8(%ebp)
 271:	0f b6 00             	movzbl (%eax),%eax
 274:	0f be c0             	movsbl %al,%eax
 277:	01 c8                	add    %ecx,%eax
 279:	83 e8 30             	sub    $0x30,%eax
 27c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	0f b6 00             	movzbl (%eax),%eax
 285:	3c 2f                	cmp    $0x2f,%al
 287:	7e 0a                	jle    293 <atoi+0x48>
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 39                	cmp    $0x39,%al
 291:	7e c7                	jle    25a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 293:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 296:	c9                   	leave  
 297:	c3                   	ret    

00000298 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2aa:	eb 17                	jmp    2c3 <memmove+0x2b>
    *dst++ = *src++;
 2ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2af:	8d 50 01             	lea    0x1(%eax),%edx
 2b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2b5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2b8:	8d 4a 01             	lea    0x1(%edx),%ecx
 2bb:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2be:	0f b6 12             	movzbl (%edx),%edx
 2c1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c3:	8b 45 10             	mov    0x10(%ebp),%eax
 2c6:	8d 50 ff             	lea    -0x1(%eax),%edx
 2c9:	89 55 10             	mov    %edx,0x10(%ebp)
 2cc:	85 c0                	test   %eax,%eax
 2ce:	7f dc                	jg     2ac <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d5:	b8 01 00 00 00       	mov    $0x1,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <exit>:
SYSCALL(exit)
 2dd:	b8 02 00 00 00       	mov    $0x2,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <wait>:
SYSCALL(wait)
 2e5:	b8 03 00 00 00       	mov    $0x3,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <pipe>:
SYSCALL(pipe)
 2ed:	b8 04 00 00 00       	mov    $0x4,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <read>:
SYSCALL(read)
 2f5:	b8 05 00 00 00       	mov    $0x5,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <write>:
SYSCALL(write)
 2fd:	b8 10 00 00 00       	mov    $0x10,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <close>:
SYSCALL(close)
 305:	b8 15 00 00 00       	mov    $0x15,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <kill>:
SYSCALL(kill)
 30d:	b8 06 00 00 00       	mov    $0x6,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <exec>:
SYSCALL(exec)
 315:	b8 07 00 00 00       	mov    $0x7,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <open>:
SYSCALL(open)
 31d:	b8 0f 00 00 00       	mov    $0xf,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <mknod>:
SYSCALL(mknod)
 325:	b8 11 00 00 00       	mov    $0x11,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <unlink>:
SYSCALL(unlink)
 32d:	b8 12 00 00 00       	mov    $0x12,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <fstat>:
SYSCALL(fstat)
 335:	b8 08 00 00 00       	mov    $0x8,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <link>:
SYSCALL(link)
 33d:	b8 13 00 00 00       	mov    $0x13,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <mkdir>:
SYSCALL(mkdir)
 345:	b8 14 00 00 00       	mov    $0x14,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <chdir>:
SYSCALL(chdir)
 34d:	b8 09 00 00 00       	mov    $0x9,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <dup>:
SYSCALL(dup)
 355:	b8 0a 00 00 00       	mov    $0xa,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <getpid>:
SYSCALL(getpid)
 35d:	b8 0b 00 00 00       	mov    $0xb,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <sbrk>:
SYSCALL(sbrk)
 365:	b8 0c 00 00 00       	mov    $0xc,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <sleep>:
SYSCALL(sleep)
 36d:	b8 0d 00 00 00       	mov    $0xd,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <uptime>:
SYSCALL(uptime)
 375:	b8 0e 00 00 00       	mov    $0xe,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <pstat>:
SYSCALL(pstat)
 37d:	b8 16 00 00 00       	mov    $0x16,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <printjob>:
SYSCALL(printjob)
 385:	b8 17 00 00 00       	mov    $0x17,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <attachjob>:
SYSCALL(attachjob)
 38d:	b8 18 00 00 00       	mov    $0x18,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <fg>:
SYSCALL (fg)
 395:	b8 19 00 00 00       	mov    $0x19,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <waitpid>:
SYSCALL(waitpid)
 39d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a5:	55                   	push   %ebp
 3a6:	89 e5                	mov    %esp,%ebp
 3a8:	83 ec 18             	sub    $0x18,%esp
 3ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ae:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3b8:	00 
 3b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	89 04 24             	mov    %eax,(%esp)
 3c6:	e8 32 ff ff ff       	call   2fd <write>
}
 3cb:	c9                   	leave  
 3cc:	c3                   	ret    

000003cd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3cd:	55                   	push   %ebp
 3ce:	89 e5                	mov    %esp,%ebp
 3d0:	56                   	push   %esi
 3d1:	53                   	push   %ebx
 3d2:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3dc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e0:	74 17                	je     3f9 <printint+0x2c>
 3e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e6:	79 11                	jns    3f9 <printint+0x2c>
    neg = 1;
 3e8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f2:	f7 d8                	neg    %eax
 3f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f7:	eb 06                	jmp    3ff <printint+0x32>
  } else {
    x = xx;
 3f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 406:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 409:	8d 41 01             	lea    0x1(%ecx),%eax
 40c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 40f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 412:	8b 45 ec             	mov    -0x14(%ebp),%eax
 415:	ba 00 00 00 00       	mov    $0x0,%edx
 41a:	f7 f3                	div    %ebx
 41c:	89 d0                	mov    %edx,%eax
 41e:	0f b6 80 b0 0a 00 00 	movzbl 0xab0(%eax),%eax
 425:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 429:	8b 75 10             	mov    0x10(%ebp),%esi
 42c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42f:	ba 00 00 00 00       	mov    $0x0,%edx
 434:	f7 f6                	div    %esi
 436:	89 45 ec             	mov    %eax,-0x14(%ebp)
 439:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43d:	75 c7                	jne    406 <printint+0x39>
  if(neg)
 43f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 443:	74 10                	je     455 <printint+0x88>
    buf[i++] = '-';
 445:	8b 45 f4             	mov    -0xc(%ebp),%eax
 448:	8d 50 01             	lea    0x1(%eax),%edx
 44b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 44e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 453:	eb 1f                	jmp    474 <printint+0xa7>
 455:	eb 1d                	jmp    474 <printint+0xa7>
    putc(fd, buf[i]);
 457:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45d:	01 d0                	add    %edx,%eax
 45f:	0f b6 00             	movzbl (%eax),%eax
 462:	0f be c0             	movsbl %al,%eax
 465:	89 44 24 04          	mov    %eax,0x4(%esp)
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	89 04 24             	mov    %eax,(%esp)
 46f:	e8 31 ff ff ff       	call   3a5 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 474:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 478:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 47c:	79 d9                	jns    457 <printint+0x8a>
    putc(fd, buf[i]);
}
 47e:	83 c4 30             	add    $0x30,%esp
 481:	5b                   	pop    %ebx
 482:	5e                   	pop    %esi
 483:	5d                   	pop    %ebp
 484:	c3                   	ret    

00000485 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 485:	55                   	push   %ebp
 486:	89 e5                	mov    %esp,%ebp
 488:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 48b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 492:	8d 45 0c             	lea    0xc(%ebp),%eax
 495:	83 c0 04             	add    $0x4,%eax
 498:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 49b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a2:	e9 7c 01 00 00       	jmp    623 <printf+0x19e>
    c = fmt[i] & 0xff;
 4a7:	8b 55 0c             	mov    0xc(%ebp),%edx
 4aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ad:	01 d0                	add    %edx,%eax
 4af:	0f b6 00             	movzbl (%eax),%eax
 4b2:	0f be c0             	movsbl %al,%eax
 4b5:	25 ff 00 00 00       	and    $0xff,%eax
 4ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c1:	75 2c                	jne    4ef <printf+0x6a>
      if(c == '%'){
 4c3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c7:	75 0c                	jne    4d5 <printf+0x50>
        state = '%';
 4c9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d0:	e9 4a 01 00 00       	jmp    61f <printf+0x19a>
      } else {
        putc(fd, c);
 4d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d8:	0f be c0             	movsbl %al,%eax
 4db:	89 44 24 04          	mov    %eax,0x4(%esp)
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	89 04 24             	mov    %eax,(%esp)
 4e5:	e8 bb fe ff ff       	call   3a5 <putc>
 4ea:	e9 30 01 00 00       	jmp    61f <printf+0x19a>
      }
    } else if(state == '%'){
 4ef:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f3:	0f 85 26 01 00 00    	jne    61f <printf+0x19a>
      if(c == 'd'){
 4f9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4fd:	75 2d                	jne    52c <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
 502:	8b 00                	mov    (%eax),%eax
 504:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 50b:	00 
 50c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 513:	00 
 514:	89 44 24 04          	mov    %eax,0x4(%esp)
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	89 04 24             	mov    %eax,(%esp)
 51e:	e8 aa fe ff ff       	call   3cd <printint>
        ap++;
 523:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 527:	e9 ec 00 00 00       	jmp    618 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 52c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 530:	74 06                	je     538 <printf+0xb3>
 532:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 536:	75 2d                	jne    565 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 538:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53b:	8b 00                	mov    (%eax),%eax
 53d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 544:	00 
 545:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 54c:	00 
 54d:	89 44 24 04          	mov    %eax,0x4(%esp)
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	89 04 24             	mov    %eax,(%esp)
 557:	e8 71 fe ff ff       	call   3cd <printint>
        ap++;
 55c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 560:	e9 b3 00 00 00       	jmp    618 <printf+0x193>
      } else if(c == 's'){
 565:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 569:	75 45                	jne    5b0 <printf+0x12b>
        s = (char*)*ap;
 56b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56e:	8b 00                	mov    (%eax),%eax
 570:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 573:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57b:	75 09                	jne    586 <printf+0x101>
          s = "(null)";
 57d:	c7 45 f4 65 08 00 00 	movl   $0x865,-0xc(%ebp)
        while(*s != 0){
 584:	eb 1e                	jmp    5a4 <printf+0x11f>
 586:	eb 1c                	jmp    5a4 <printf+0x11f>
          putc(fd, *s);
 588:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58b:	0f b6 00             	movzbl (%eax),%eax
 58e:	0f be c0             	movsbl %al,%eax
 591:	89 44 24 04          	mov    %eax,0x4(%esp)
 595:	8b 45 08             	mov    0x8(%ebp),%eax
 598:	89 04 24             	mov    %eax,(%esp)
 59b:	e8 05 fe ff ff       	call   3a5 <putc>
          s++;
 5a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a7:	0f b6 00             	movzbl (%eax),%eax
 5aa:	84 c0                	test   %al,%al
 5ac:	75 da                	jne    588 <printf+0x103>
 5ae:	eb 68                	jmp    618 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b4:	75 1d                	jne    5d3 <printf+0x14e>
        putc(fd, *ap);
 5b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b9:	8b 00                	mov    (%eax),%eax
 5bb:	0f be c0             	movsbl %al,%eax
 5be:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c2:	8b 45 08             	mov    0x8(%ebp),%eax
 5c5:	89 04 24             	mov    %eax,(%esp)
 5c8:	e8 d8 fd ff ff       	call   3a5 <putc>
        ap++;
 5cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d1:	eb 45                	jmp    618 <printf+0x193>
      } else if(c == '%'){
 5d3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d7:	75 17                	jne    5f0 <printf+0x16b>
        putc(fd, c);
 5d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5dc:	0f be c0             	movsbl %al,%eax
 5df:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	89 04 24             	mov    %eax,(%esp)
 5e9:	e8 b7 fd ff ff       	call   3a5 <putc>
 5ee:	eb 28                	jmp    618 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5f7:	00 
 5f8:	8b 45 08             	mov    0x8(%ebp),%eax
 5fb:	89 04 24             	mov    %eax,(%esp)
 5fe:	e8 a2 fd ff ff       	call   3a5 <putc>
        putc(fd, c);
 603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 606:	0f be c0             	movsbl %al,%eax
 609:	89 44 24 04          	mov    %eax,0x4(%esp)
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	89 04 24             	mov    %eax,(%esp)
 613:	e8 8d fd ff ff       	call   3a5 <putc>
      }
      state = 0;
 618:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 61f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 623:	8b 55 0c             	mov    0xc(%ebp),%edx
 626:	8b 45 f0             	mov    -0x10(%ebp),%eax
 629:	01 d0                	add    %edx,%eax
 62b:	0f b6 00             	movzbl (%eax),%eax
 62e:	84 c0                	test   %al,%al
 630:	0f 85 71 fe ff ff    	jne    4a7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 636:	c9                   	leave  
 637:	c3                   	ret    

00000638 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 638:	55                   	push   %ebp
 639:	89 e5                	mov    %esp,%ebp
 63b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
 641:	83 e8 08             	sub    $0x8,%eax
 644:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 647:	a1 cc 0a 00 00       	mov    0xacc,%eax
 64c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64f:	eb 24                	jmp    675 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 659:	77 12                	ja     66d <free+0x35>
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 661:	77 24                	ja     687 <free+0x4f>
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66b:	77 1a                	ja     687 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	89 45 fc             	mov    %eax,-0x4(%ebp)
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67b:	76 d4                	jbe    651 <free+0x19>
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 00                	mov    (%eax),%eax
 682:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 685:	76 ca                	jbe    651 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	8b 40 04             	mov    0x4(%eax),%eax
 68d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	01 c2                	add    %eax,%edx
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	39 c2                	cmp    %eax,%edx
 6a0:	75 24                	jne    6c6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	8b 50 04             	mov    0x4(%eax),%edx
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 00                	mov    (%eax),%eax
 6ad:	8b 40 04             	mov    0x4(%eax),%eax
 6b0:	01 c2                	add    %eax,%edx
 6b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 00                	mov    (%eax),%eax
 6bd:	8b 10                	mov    (%eax),%edx
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	89 10                	mov    %edx,(%eax)
 6c4:	eb 0a                	jmp    6d0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 10                	mov    (%eax),%edx
 6cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ce:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 40 04             	mov    0x4(%eax),%eax
 6d6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	01 d0                	add    %edx,%eax
 6e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e5:	75 20                	jne    707 <free+0xcf>
    p->s.size += bp->s.size;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 50 04             	mov    0x4(%eax),%edx
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	8b 40 04             	mov    0x4(%eax),%eax
 6f3:	01 c2                	add    %eax,%edx
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	8b 10                	mov    (%eax),%edx
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	89 10                	mov    %edx,(%eax)
 705:	eb 08                	jmp    70f <free+0xd7>
  } else
    p->s.ptr = bp;
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 70d:	89 10                	mov    %edx,(%eax)
  freep = p;
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	a3 cc 0a 00 00       	mov    %eax,0xacc
}
 717:	c9                   	leave  
 718:	c3                   	ret    

00000719 <morecore>:

static Header*
morecore(uint nu)
{
 719:	55                   	push   %ebp
 71a:	89 e5                	mov    %esp,%ebp
 71c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 71f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 726:	77 07                	ja     72f <morecore+0x16>
    nu = 4096;
 728:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 72f:	8b 45 08             	mov    0x8(%ebp),%eax
 732:	c1 e0 03             	shl    $0x3,%eax
 735:	89 04 24             	mov    %eax,(%esp)
 738:	e8 28 fc ff ff       	call   365 <sbrk>
 73d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 740:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 744:	75 07                	jne    74d <morecore+0x34>
    return 0;
 746:	b8 00 00 00 00       	mov    $0x0,%eax
 74b:	eb 22                	jmp    76f <morecore+0x56>
  hp = (Header*)p;
 74d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 750:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 753:	8b 45 f0             	mov    -0x10(%ebp),%eax
 756:	8b 55 08             	mov    0x8(%ebp),%edx
 759:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 75c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75f:	83 c0 08             	add    $0x8,%eax
 762:	89 04 24             	mov    %eax,(%esp)
 765:	e8 ce fe ff ff       	call   638 <free>
  return freep;
 76a:	a1 cc 0a 00 00       	mov    0xacc,%eax
}
 76f:	c9                   	leave  
 770:	c3                   	ret    

00000771 <malloc>:

void*
malloc(uint nbytes)
{
 771:	55                   	push   %ebp
 772:	89 e5                	mov    %esp,%ebp
 774:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 777:	8b 45 08             	mov    0x8(%ebp),%eax
 77a:	83 c0 07             	add    $0x7,%eax
 77d:	c1 e8 03             	shr    $0x3,%eax
 780:	83 c0 01             	add    $0x1,%eax
 783:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 786:	a1 cc 0a 00 00       	mov    0xacc,%eax
 78b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 78e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 792:	75 23                	jne    7b7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 794:	c7 45 f0 c4 0a 00 00 	movl   $0xac4,-0x10(%ebp)
 79b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79e:	a3 cc 0a 00 00       	mov    %eax,0xacc
 7a3:	a1 cc 0a 00 00       	mov    0xacc,%eax
 7a8:	a3 c4 0a 00 00       	mov    %eax,0xac4
    base.s.size = 0;
 7ad:	c7 05 c8 0a 00 00 00 	movl   $0x0,0xac8
 7b4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ba:	8b 00                	mov    (%eax),%eax
 7bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	8b 40 04             	mov    0x4(%eax),%eax
 7c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c8:	72 4d                	jb     817 <malloc+0xa6>
      if(p->s.size == nunits)
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	8b 40 04             	mov    0x4(%eax),%eax
 7d0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d3:	75 0c                	jne    7e1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 10                	mov    (%eax),%edx
 7da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dd:	89 10                	mov    %edx,(%eax)
 7df:	eb 26                	jmp    807 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	8b 40 04             	mov    0x4(%eax),%eax
 7e7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7ea:	89 c2                	mov    %eax,%edx
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 40 04             	mov    0x4(%eax),%eax
 7f8:	c1 e0 03             	shl    $0x3,%eax
 7fb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 807:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80a:	a3 cc 0a 00 00       	mov    %eax,0xacc
      return (void*)(p + 1);
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	83 c0 08             	add    $0x8,%eax
 815:	eb 38                	jmp    84f <malloc+0xde>
    }
    if(p == freep)
 817:	a1 cc 0a 00 00       	mov    0xacc,%eax
 81c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 81f:	75 1b                	jne    83c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 821:	8b 45 ec             	mov    -0x14(%ebp),%eax
 824:	89 04 24             	mov    %eax,(%esp)
 827:	e8 ed fe ff ff       	call   719 <morecore>
 82c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 82f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 833:	75 07                	jne    83c <malloc+0xcb>
        return 0;
 835:	b8 00 00 00 00       	mov    $0x0,%eax
 83a:	eb 13                	jmp    84f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	8b 00                	mov    (%eax),%eax
 847:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 84a:	e9 70 ff ff ff       	jmp    7bf <malloc+0x4e>
}
 84f:	c9                   	leave  
 850:	c3                   	ret    
