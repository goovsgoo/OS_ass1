
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;
  int	status = 0;			//for wait func
   9:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  10:	00 

  if(open("console", O_RDWR) < 0){
  11:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  18:	00 
  19:	c7 04 24 fb 08 00 00 	movl   $0x8fb,(%esp)
  20:	e8 af 03 00 00       	call   3d4 <open>
  25:	85 c0                	test   %eax,%eax
  27:	79 30                	jns    59 <main+0x59>
    mknod("console", 1, 1);
  29:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  30:	00 
  31:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  38:	00 
  39:	c7 04 24 fb 08 00 00 	movl   $0x8fb,(%esp)
  40:	e8 97 03 00 00       	call   3dc <mknod>
    open("console", O_RDWR);
  45:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 fb 08 00 00 	movl   $0x8fb,(%esp)
  54:	e8 7b 03 00 00       	call   3d4 <open>
  }
  dup(0);  // stdout
  59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  60:	e8 a7 03 00 00       	call   40c <dup>
  dup(0);  // stderr
  65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  6c:	e8 9b 03 00 00       	call   40c <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  71:	c7 44 24 04 03 09 00 	movl   $0x903,0x4(%esp)
  78:	00 
  79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80:	e8 a7 04 00 00       	call   52c <printf>
    pid = fork();
  85:	e8 02 03 00 00       	call   38c <fork>
  8a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  8e:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  93:	79 20                	jns    b5 <main+0xb5>
      printf(1, "init: fork failed\n");
  95:	c7 44 24 04 16 09 00 	movl   $0x916,0x4(%esp)
  9c:	00 
  9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a4:	e8 83 04 00 00       	call   52c <printf>
      exit(-1);
  a9:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  b0:	e8 df 02 00 00       	call   394 <exit>
    }
    if(pid == 0){
  b5:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ba:	75 34                	jne    f0 <main+0xf0>
      exec("sh", argv);
  bc:	c7 44 24 04 94 0b 00 	movl   $0xb94,0x4(%esp)
  c3:	00 
  c4:	c7 04 24 f8 08 00 00 	movl   $0x8f8,(%esp)
  cb:	e8 fc 02 00 00       	call   3cc <exec>
      printf(1, "init: exec sh failed\n");
  d0:	c7 44 24 04 29 09 00 	movl   $0x929,0x4(%esp)
  d7:	00 
  d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  df:	e8 48 04 00 00       	call   52c <printf>
      exit(-1);
  e4:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  eb:	e8 a4 02 00 00       	call   394 <exit>
    }
    while((wpid=wait(&status)) >= 0 && wpid != pid)
  f0:	eb 14                	jmp    106 <main+0x106>
      printf(1, "zombie!\n");
  f2:	c7 44 24 04 3f 09 00 	movl   $0x93f,0x4(%esp)
  f9:	00 
  fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 101:	e8 26 04 00 00       	call   52c <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit(-1);
    }
    while((wpid=wait(&status)) >= 0 && wpid != pid)
 106:	8d 44 24 14          	lea    0x14(%esp),%eax
 10a:	89 04 24             	mov    %eax,(%esp)
 10d:	e8 8a 02 00 00       	call   39c <wait>
 112:	89 44 24 18          	mov    %eax,0x18(%esp)
 116:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 11b:	78 0a                	js     127 <main+0x127>
 11d:	8b 44 24 18          	mov    0x18(%esp),%eax
 121:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 125:	75 cb                	jne    f2 <main+0xf2>
      printf(1, "zombie!\n");
  }
 127:	e9 45 ff ff ff       	jmp    71 <main+0x71>

0000012c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	57                   	push   %edi
 130:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 131:	8b 4d 08             	mov    0x8(%ebp),%ecx
 134:	8b 55 10             	mov    0x10(%ebp),%edx
 137:	8b 45 0c             	mov    0xc(%ebp),%eax
 13a:	89 cb                	mov    %ecx,%ebx
 13c:	89 df                	mov    %ebx,%edi
 13e:	89 d1                	mov    %edx,%ecx
 140:	fc                   	cld    
 141:	f3 aa                	rep stos %al,%es:(%edi)
 143:	89 ca                	mov    %ecx,%edx
 145:	89 fb                	mov    %edi,%ebx
 147:	89 5d 08             	mov    %ebx,0x8(%ebp)
 14a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 14d:	5b                   	pop    %ebx
 14e:	5f                   	pop    %edi
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret    

00000151 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 15d:	90                   	nop
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	8d 50 01             	lea    0x1(%eax),%edx
 164:	89 55 08             	mov    %edx,0x8(%ebp)
 167:	8b 55 0c             	mov    0xc(%ebp),%edx
 16a:	8d 4a 01             	lea    0x1(%edx),%ecx
 16d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 170:	0f b6 12             	movzbl (%edx),%edx
 173:	88 10                	mov    %dl,(%eax)
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	75 e2                	jne    15e <strcpy+0xd>
    ;
  return os;
 17c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17f:	c9                   	leave  
 180:	c3                   	ret    

00000181 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 184:	eb 08                	jmp    18e <strcmp+0xd>
    p++, q++;
 186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	84 c0                	test   %al,%al
 196:	74 10                	je     1a8 <strcmp+0x27>
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	0f b6 10             	movzbl (%eax),%edx
 19e:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	38 c2                	cmp    %al,%dl
 1a6:	74 de                	je     186 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 00             	movzbl (%eax),%eax
 1ae:	0f b6 d0             	movzbl %al,%edx
 1b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b4:	0f b6 00             	movzbl (%eax),%eax
 1b7:	0f b6 c0             	movzbl %al,%eax
 1ba:	29 c2                	sub    %eax,%edx
 1bc:	89 d0                	mov    %edx,%eax
}
 1be:	5d                   	pop    %ebp
 1bf:	c3                   	ret    

000001c0 <strlen>:

uint
strlen(char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1cd:	eb 04                	jmp    1d3 <strlen+0x13>
 1cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	01 d0                	add    %edx,%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	84 c0                	test   %al,%al
 1e0:	75 ed                	jne    1cf <strlen+0xf>
    ;
  return n;
 1e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e5:	c9                   	leave  
 1e6:	c3                   	ret    

000001e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1ed:	8b 45 10             	mov    0x10(%ebp),%eax
 1f0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	89 04 24             	mov    %eax,(%esp)
 201:	e8 26 ff ff ff       	call   12c <stosb>
  return dst;
 206:	8b 45 08             	mov    0x8(%ebp),%eax
}
 209:	c9                   	leave  
 20a:	c3                   	ret    

0000020b <strchr>:

char*
strchr(const char *s, char c)
{
 20b:	55                   	push   %ebp
 20c:	89 e5                	mov    %esp,%ebp
 20e:	83 ec 04             	sub    $0x4,%esp
 211:	8b 45 0c             	mov    0xc(%ebp),%eax
 214:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 217:	eb 14                	jmp    22d <strchr+0x22>
    if(*s == c)
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 222:	75 05                	jne    229 <strchr+0x1e>
      return (char*)s;
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	eb 13                	jmp    23c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 229:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	84 c0                	test   %al,%al
 235:	75 e2                	jne    219 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 237:	b8 00 00 00 00       	mov    $0x0,%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <gets>:

char*
gets(char *buf, int max)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 24b:	eb 4c                	jmp    299 <gets+0x5b>
    cc = read(0, &c, 1);
 24d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 254:	00 
 255:	8d 45 ef             	lea    -0x11(%ebp),%eax
 258:	89 44 24 04          	mov    %eax,0x4(%esp)
 25c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 263:	e8 44 01 00 00       	call   3ac <read>
 268:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 26b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 26f:	7f 02                	jg     273 <gets+0x35>
      break;
 271:	eb 31                	jmp    2a4 <gets+0x66>
    buf[i++] = c;
 273:	8b 45 f4             	mov    -0xc(%ebp),%eax
 276:	8d 50 01             	lea    0x1(%eax),%edx
 279:	89 55 f4             	mov    %edx,-0xc(%ebp)
 27c:	89 c2                	mov    %eax,%edx
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	01 c2                	add    %eax,%edx
 283:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 287:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 289:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 28d:	3c 0a                	cmp    $0xa,%al
 28f:	74 13                	je     2a4 <gets+0x66>
 291:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 295:	3c 0d                	cmp    $0xd,%al
 297:	74 0b                	je     2a4 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 299:	8b 45 f4             	mov    -0xc(%ebp),%eax
 29c:	83 c0 01             	add    $0x1,%eax
 29f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2a2:	7c a9                	jl     24d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	01 d0                	add    %edx,%eax
 2ac:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <stat>:

int
stat(char *n, struct stat *st)
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2c1:	00 
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	89 04 24             	mov    %eax,(%esp)
 2c8:	e8 07 01 00 00       	call   3d4 <open>
 2cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2d4:	79 07                	jns    2dd <stat+0x29>
    return -1;
 2d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2db:	eb 23                	jmp    300 <stat+0x4c>
  r = fstat(fd, st);
 2dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e7:	89 04 24             	mov    %eax,(%esp)
 2ea:	e8 fd 00 00 00       	call   3ec <fstat>
 2ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f5:	89 04 24             	mov    %eax,(%esp)
 2f8:	e8 bf 00 00 00       	call   3bc <close>
  return r;
 2fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 300:	c9                   	leave  
 301:	c3                   	ret    

00000302 <atoi>:

int
atoi(const char *s)
{
 302:	55                   	push   %ebp
 303:	89 e5                	mov    %esp,%ebp
 305:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 308:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 30f:	eb 25                	jmp    336 <atoi+0x34>
    n = n*10 + *s++ - '0';
 311:	8b 55 fc             	mov    -0x4(%ebp),%edx
 314:	89 d0                	mov    %edx,%eax
 316:	c1 e0 02             	shl    $0x2,%eax
 319:	01 d0                	add    %edx,%eax
 31b:	01 c0                	add    %eax,%eax
 31d:	89 c1                	mov    %eax,%ecx
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	8d 50 01             	lea    0x1(%eax),%edx
 325:	89 55 08             	mov    %edx,0x8(%ebp)
 328:	0f b6 00             	movzbl (%eax),%eax
 32b:	0f be c0             	movsbl %al,%eax
 32e:	01 c8                	add    %ecx,%eax
 330:	83 e8 30             	sub    $0x30,%eax
 333:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	0f b6 00             	movzbl (%eax),%eax
 33c:	3c 2f                	cmp    $0x2f,%al
 33e:	7e 0a                	jle    34a <atoi+0x48>
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	0f b6 00             	movzbl (%eax),%eax
 346:	3c 39                	cmp    $0x39,%al
 348:	7e c7                	jle    311 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 34a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 34d:	c9                   	leave  
 34e:	c3                   	ret    

0000034f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 34f:	55                   	push   %ebp
 350:	89 e5                	mov    %esp,%ebp
 352:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 35b:	8b 45 0c             	mov    0xc(%ebp),%eax
 35e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 361:	eb 17                	jmp    37a <memmove+0x2b>
    *dst++ = *src++;
 363:	8b 45 fc             	mov    -0x4(%ebp),%eax
 366:	8d 50 01             	lea    0x1(%eax),%edx
 369:	89 55 fc             	mov    %edx,-0x4(%ebp)
 36c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 36f:	8d 4a 01             	lea    0x1(%edx),%ecx
 372:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 375:	0f b6 12             	movzbl (%edx),%edx
 378:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 37a:	8b 45 10             	mov    0x10(%ebp),%eax
 37d:	8d 50 ff             	lea    -0x1(%eax),%edx
 380:	89 55 10             	mov    %edx,0x10(%ebp)
 383:	85 c0                	test   %eax,%eax
 385:	7f dc                	jg     363 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 387:	8b 45 08             	mov    0x8(%ebp),%eax
}
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 38c:	b8 01 00 00 00       	mov    $0x1,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <exit>:
SYSCALL(exit)
 394:	b8 02 00 00 00       	mov    $0x2,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <wait>:
SYSCALL(wait)
 39c:	b8 03 00 00 00       	mov    $0x3,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <pipe>:
SYSCALL(pipe)
 3a4:	b8 04 00 00 00       	mov    $0x4,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <read>:
SYSCALL(read)
 3ac:	b8 05 00 00 00       	mov    $0x5,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <write>:
SYSCALL(write)
 3b4:	b8 10 00 00 00       	mov    $0x10,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <close>:
SYSCALL(close)
 3bc:	b8 15 00 00 00       	mov    $0x15,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <kill>:
SYSCALL(kill)
 3c4:	b8 06 00 00 00       	mov    $0x6,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <exec>:
SYSCALL(exec)
 3cc:	b8 07 00 00 00       	mov    $0x7,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <open>:
SYSCALL(open)
 3d4:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <mknod>:
SYSCALL(mknod)
 3dc:	b8 11 00 00 00       	mov    $0x11,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <unlink>:
SYSCALL(unlink)
 3e4:	b8 12 00 00 00       	mov    $0x12,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <fstat>:
SYSCALL(fstat)
 3ec:	b8 08 00 00 00       	mov    $0x8,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <link>:
SYSCALL(link)
 3f4:	b8 13 00 00 00       	mov    $0x13,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <mkdir>:
SYSCALL(mkdir)
 3fc:	b8 14 00 00 00       	mov    $0x14,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <chdir>:
SYSCALL(chdir)
 404:	b8 09 00 00 00       	mov    $0x9,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <dup>:
SYSCALL(dup)
 40c:	b8 0a 00 00 00       	mov    $0xa,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <getpid>:
SYSCALL(getpid)
 414:	b8 0b 00 00 00       	mov    $0xb,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <sbrk>:
SYSCALL(sbrk)
 41c:	b8 0c 00 00 00       	mov    $0xc,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <sleep>:
SYSCALL(sleep)
 424:	b8 0d 00 00 00       	mov    $0xd,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <uptime>:
SYSCALL(uptime)
 42c:	b8 0e 00 00 00       	mov    $0xe,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <pstat>:
SYSCALL(pstat)
 434:	b8 16 00 00 00       	mov    $0x16,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <printjob>:
SYSCALL(printjob)
 43c:	b8 17 00 00 00       	mov    $0x17,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <attachjob>:
SYSCALL(attachjob)
 444:	b8 18 00 00 00       	mov    $0x18,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	83 ec 18             	sub    $0x18,%esp
 452:	8b 45 0c             	mov    0xc(%ebp),%eax
 455:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 458:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 45f:	00 
 460:	8d 45 f4             	lea    -0xc(%ebp),%eax
 463:	89 44 24 04          	mov    %eax,0x4(%esp)
 467:	8b 45 08             	mov    0x8(%ebp),%eax
 46a:	89 04 24             	mov    %eax,(%esp)
 46d:	e8 42 ff ff ff       	call   3b4 <write>
}
 472:	c9                   	leave  
 473:	c3                   	ret    

00000474 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	56                   	push   %esi
 478:	53                   	push   %ebx
 479:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 47c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 483:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 487:	74 17                	je     4a0 <printint+0x2c>
 489:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 48d:	79 11                	jns    4a0 <printint+0x2c>
    neg = 1;
 48f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 496:	8b 45 0c             	mov    0xc(%ebp),%eax
 499:	f7 d8                	neg    %eax
 49b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49e:	eb 06                	jmp    4a6 <printint+0x32>
  } else {
    x = xx;
 4a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ad:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4b0:	8d 41 01             	lea    0x1(%ecx),%eax
 4b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4bc:	ba 00 00 00 00       	mov    $0x0,%edx
 4c1:	f7 f3                	div    %ebx
 4c3:	89 d0                	mov    %edx,%eax
 4c5:	0f b6 80 9c 0b 00 00 	movzbl 0xb9c(%eax),%eax
 4cc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4d0:	8b 75 10             	mov    0x10(%ebp),%esi
 4d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d6:	ba 00 00 00 00       	mov    $0x0,%edx
 4db:	f7 f6                	div    %esi
 4dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e4:	75 c7                	jne    4ad <printint+0x39>
  if(neg)
 4e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ea:	74 10                	je     4fc <printint+0x88>
    buf[i++] = '-';
 4ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ef:	8d 50 01             	lea    0x1(%eax),%edx
 4f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4f5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4fa:	eb 1f                	jmp    51b <printint+0xa7>
 4fc:	eb 1d                	jmp    51b <printint+0xa7>
    putc(fd, buf[i]);
 4fe:	8d 55 dc             	lea    -0x24(%ebp),%edx
 501:	8b 45 f4             	mov    -0xc(%ebp),%eax
 504:	01 d0                	add    %edx,%eax
 506:	0f b6 00             	movzbl (%eax),%eax
 509:	0f be c0             	movsbl %al,%eax
 50c:	89 44 24 04          	mov    %eax,0x4(%esp)
 510:	8b 45 08             	mov    0x8(%ebp),%eax
 513:	89 04 24             	mov    %eax,(%esp)
 516:	e8 31 ff ff ff       	call   44c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 51b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 51f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 523:	79 d9                	jns    4fe <printint+0x8a>
    putc(fd, buf[i]);
}
 525:	83 c4 30             	add    $0x30,%esp
 528:	5b                   	pop    %ebx
 529:	5e                   	pop    %esi
 52a:	5d                   	pop    %ebp
 52b:	c3                   	ret    

0000052c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 52c:	55                   	push   %ebp
 52d:	89 e5                	mov    %esp,%ebp
 52f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 532:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 539:	8d 45 0c             	lea    0xc(%ebp),%eax
 53c:	83 c0 04             	add    $0x4,%eax
 53f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 542:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 549:	e9 7c 01 00 00       	jmp    6ca <printf+0x19e>
    c = fmt[i] & 0xff;
 54e:	8b 55 0c             	mov    0xc(%ebp),%edx
 551:	8b 45 f0             	mov    -0x10(%ebp),%eax
 554:	01 d0                	add    %edx,%eax
 556:	0f b6 00             	movzbl (%eax),%eax
 559:	0f be c0             	movsbl %al,%eax
 55c:	25 ff 00 00 00       	and    $0xff,%eax
 561:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 564:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 568:	75 2c                	jne    596 <printf+0x6a>
      if(c == '%'){
 56a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56e:	75 0c                	jne    57c <printf+0x50>
        state = '%';
 570:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 577:	e9 4a 01 00 00       	jmp    6c6 <printf+0x19a>
      } else {
        putc(fd, c);
 57c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57f:	0f be c0             	movsbl %al,%eax
 582:	89 44 24 04          	mov    %eax,0x4(%esp)
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	89 04 24             	mov    %eax,(%esp)
 58c:	e8 bb fe ff ff       	call   44c <putc>
 591:	e9 30 01 00 00       	jmp    6c6 <printf+0x19a>
      }
    } else if(state == '%'){
 596:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 59a:	0f 85 26 01 00 00    	jne    6c6 <printf+0x19a>
      if(c == 'd'){
 5a0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5a4:	75 2d                	jne    5d3 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a9:	8b 00                	mov    (%eax),%eax
 5ab:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5b2:	00 
 5b3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5ba:	00 
 5bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bf:	8b 45 08             	mov    0x8(%ebp),%eax
 5c2:	89 04 24             	mov    %eax,(%esp)
 5c5:	e8 aa fe ff ff       	call   474 <printint>
        ap++;
 5ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ce:	e9 ec 00 00 00       	jmp    6bf <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5d3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5d7:	74 06                	je     5df <printf+0xb3>
 5d9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5dd:	75 2d                	jne    60c <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e2:	8b 00                	mov    (%eax),%eax
 5e4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5eb:	00 
 5ec:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5f3:	00 
 5f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f8:	8b 45 08             	mov    0x8(%ebp),%eax
 5fb:	89 04 24             	mov    %eax,(%esp)
 5fe:	e8 71 fe ff ff       	call   474 <printint>
        ap++;
 603:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 607:	e9 b3 00 00 00       	jmp    6bf <printf+0x193>
      } else if(c == 's'){
 60c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 610:	75 45                	jne    657 <printf+0x12b>
        s = (char*)*ap;
 612:	8b 45 e8             	mov    -0x18(%ebp),%eax
 615:	8b 00                	mov    (%eax),%eax
 617:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 61a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 61e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 622:	75 09                	jne    62d <printf+0x101>
          s = "(null)";
 624:	c7 45 f4 48 09 00 00 	movl   $0x948,-0xc(%ebp)
        while(*s != 0){
 62b:	eb 1e                	jmp    64b <printf+0x11f>
 62d:	eb 1c                	jmp    64b <printf+0x11f>
          putc(fd, *s);
 62f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 632:	0f b6 00             	movzbl (%eax),%eax
 635:	0f be c0             	movsbl %al,%eax
 638:	89 44 24 04          	mov    %eax,0x4(%esp)
 63c:	8b 45 08             	mov    0x8(%ebp),%eax
 63f:	89 04 24             	mov    %eax,(%esp)
 642:	e8 05 fe ff ff       	call   44c <putc>
          s++;
 647:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 64b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64e:	0f b6 00             	movzbl (%eax),%eax
 651:	84 c0                	test   %al,%al
 653:	75 da                	jne    62f <printf+0x103>
 655:	eb 68                	jmp    6bf <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 657:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 65b:	75 1d                	jne    67a <printf+0x14e>
        putc(fd, *ap);
 65d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 660:	8b 00                	mov    (%eax),%eax
 662:	0f be c0             	movsbl %al,%eax
 665:	89 44 24 04          	mov    %eax,0x4(%esp)
 669:	8b 45 08             	mov    0x8(%ebp),%eax
 66c:	89 04 24             	mov    %eax,(%esp)
 66f:	e8 d8 fd ff ff       	call   44c <putc>
        ap++;
 674:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 678:	eb 45                	jmp    6bf <printf+0x193>
      } else if(c == '%'){
 67a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 67e:	75 17                	jne    697 <printf+0x16b>
        putc(fd, c);
 680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 683:	0f be c0             	movsbl %al,%eax
 686:	89 44 24 04          	mov    %eax,0x4(%esp)
 68a:	8b 45 08             	mov    0x8(%ebp),%eax
 68d:	89 04 24             	mov    %eax,(%esp)
 690:	e8 b7 fd ff ff       	call   44c <putc>
 695:	eb 28                	jmp    6bf <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 697:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 69e:	00 
 69f:	8b 45 08             	mov    0x8(%ebp),%eax
 6a2:	89 04 24             	mov    %eax,(%esp)
 6a5:	e8 a2 fd ff ff       	call   44c <putc>
        putc(fd, c);
 6aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ad:	0f be c0             	movsbl %al,%eax
 6b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b4:	8b 45 08             	mov    0x8(%ebp),%eax
 6b7:	89 04 24             	mov    %eax,(%esp)
 6ba:	e8 8d fd ff ff       	call   44c <putc>
      }
      state = 0;
 6bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ca:	8b 55 0c             	mov    0xc(%ebp),%edx
 6cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d0:	01 d0                	add    %edx,%eax
 6d2:	0f b6 00             	movzbl (%eax),%eax
 6d5:	84 c0                	test   %al,%al
 6d7:	0f 85 71 fe ff ff    	jne    54e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6dd:	c9                   	leave  
 6de:	c3                   	ret    

000006df <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6df:	55                   	push   %ebp
 6e0:	89 e5                	mov    %esp,%ebp
 6e2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	83 e8 08             	sub    $0x8,%eax
 6eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ee:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 6f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f6:	eb 24                	jmp    71c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	8b 00                	mov    (%eax),%eax
 6fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 700:	77 12                	ja     714 <free+0x35>
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 708:	77 24                	ja     72e <free+0x4f>
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	8b 00                	mov    (%eax),%eax
 70f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 712:	77 1a                	ja     72e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	8b 00                	mov    (%eax),%eax
 719:	89 45 fc             	mov    %eax,-0x4(%ebp)
 71c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 722:	76 d4                	jbe    6f8 <free+0x19>
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 00                	mov    (%eax),%eax
 729:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72c:	76 ca                	jbe    6f8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	8b 40 04             	mov    0x4(%eax),%eax
 734:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	01 c2                	add    %eax,%edx
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 00                	mov    (%eax),%eax
 745:	39 c2                	cmp    %eax,%edx
 747:	75 24                	jne    76d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 749:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74c:	8b 50 04             	mov    0x4(%eax),%edx
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	8b 00                	mov    (%eax),%eax
 754:	8b 40 04             	mov    0x4(%eax),%eax
 757:	01 c2                	add    %eax,%edx
 759:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	8b 10                	mov    (%eax),%edx
 766:	8b 45 f8             	mov    -0x8(%ebp),%eax
 769:	89 10                	mov    %edx,(%eax)
 76b:	eb 0a                	jmp    777 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 10                	mov    (%eax),%edx
 772:	8b 45 f8             	mov    -0x8(%ebp),%eax
 775:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	01 d0                	add    %edx,%eax
 789:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78c:	75 20                	jne    7ae <free+0xcf>
    p->s.size += bp->s.size;
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	8b 50 04             	mov    0x4(%eax),%edx
 794:	8b 45 f8             	mov    -0x8(%ebp),%eax
 797:	8b 40 04             	mov    0x4(%eax),%eax
 79a:	01 c2                	add    %eax,%edx
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a5:	8b 10                	mov    (%eax),%edx
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	89 10                	mov    %edx,(%eax)
 7ac:	eb 08                	jmp    7b6 <free+0xd7>
  } else
    p->s.ptr = bp;
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b4:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b9:	a3 b8 0b 00 00       	mov    %eax,0xbb8
}
 7be:	c9                   	leave  
 7bf:	c3                   	ret    

000007c0 <morecore>:

static Header*
morecore(uint nu)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7cd:	77 07                	ja     7d6 <morecore+0x16>
    nu = 4096;
 7cf:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d6:	8b 45 08             	mov    0x8(%ebp),%eax
 7d9:	c1 e0 03             	shl    $0x3,%eax
 7dc:	89 04 24             	mov    %eax,(%esp)
 7df:	e8 38 fc ff ff       	call   41c <sbrk>
 7e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7eb:	75 07                	jne    7f4 <morecore+0x34>
    return 0;
 7ed:	b8 00 00 00 00       	mov    $0x0,%eax
 7f2:	eb 22                	jmp    816 <morecore+0x56>
  hp = (Header*)p;
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fd:	8b 55 08             	mov    0x8(%ebp),%edx
 800:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 803:	8b 45 f0             	mov    -0x10(%ebp),%eax
 806:	83 c0 08             	add    $0x8,%eax
 809:	89 04 24             	mov    %eax,(%esp)
 80c:	e8 ce fe ff ff       	call   6df <free>
  return freep;
 811:	a1 b8 0b 00 00       	mov    0xbb8,%eax
}
 816:	c9                   	leave  
 817:	c3                   	ret    

00000818 <malloc>:

void*
malloc(uint nbytes)
{
 818:	55                   	push   %ebp
 819:	89 e5                	mov    %esp,%ebp
 81b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81e:	8b 45 08             	mov    0x8(%ebp),%eax
 821:	83 c0 07             	add    $0x7,%eax
 824:	c1 e8 03             	shr    $0x3,%eax
 827:	83 c0 01             	add    $0x1,%eax
 82a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 82d:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 832:	89 45 f0             	mov    %eax,-0x10(%ebp)
 835:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 839:	75 23                	jne    85e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 83b:	c7 45 f0 b0 0b 00 00 	movl   $0xbb0,-0x10(%ebp)
 842:	8b 45 f0             	mov    -0x10(%ebp),%eax
 845:	a3 b8 0b 00 00       	mov    %eax,0xbb8
 84a:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 84f:	a3 b0 0b 00 00       	mov    %eax,0xbb0
    base.s.size = 0;
 854:	c7 05 b4 0b 00 00 00 	movl   $0x0,0xbb4
 85b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 861:	8b 00                	mov    (%eax),%eax
 863:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	8b 40 04             	mov    0x4(%eax),%eax
 86c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86f:	72 4d                	jb     8be <malloc+0xa6>
      if(p->s.size == nunits)
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	8b 40 04             	mov    0x4(%eax),%eax
 877:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87a:	75 0c                	jne    888 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	8b 10                	mov    (%eax),%edx
 881:	8b 45 f0             	mov    -0x10(%ebp),%eax
 884:	89 10                	mov    %edx,(%eax)
 886:	eb 26                	jmp    8ae <malloc+0x96>
      else {
        p->s.size -= nunits;
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	8b 40 04             	mov    0x4(%eax),%eax
 88e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 891:	89 c2                	mov    %eax,%edx
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	8b 40 04             	mov    0x4(%eax),%eax
 89f:	c1 e0 03             	shl    $0x3,%eax
 8a2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ab:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b1:	a3 b8 0b 00 00       	mov    %eax,0xbb8
      return (void*)(p + 1);
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	83 c0 08             	add    $0x8,%eax
 8bc:	eb 38                	jmp    8f6 <malloc+0xde>
    }
    if(p == freep)
 8be:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 8c3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c6:	75 1b                	jne    8e3 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8cb:	89 04 24             	mov    %eax,(%esp)
 8ce:	e8 ed fe ff ff       	call   7c0 <morecore>
 8d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8da:	75 07                	jne    8e3 <malloc+0xcb>
        return 0;
 8dc:	b8 00 00 00 00       	mov    $0x0,%eax
 8e1:	eb 13                	jmp    8f6 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	8b 00                	mov    (%eax),%eax
 8ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8f1:	e9 70 ff ff ff       	jmp    866 <malloc+0x4e>
}
 8f6:	c9                   	leave  
 8f7:	c3                   	ret    
