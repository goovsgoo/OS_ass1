
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
  19:	c7 04 24 0b 09 00 00 	movl   $0x90b,(%esp)
  20:	e8 af 03 00 00       	call   3d4 <open>
  25:	85 c0                	test   %eax,%eax
  27:	79 30                	jns    59 <main+0x59>
    mknod("console", 1, 1);
  29:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  30:	00 
  31:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  38:	00 
  39:	c7 04 24 0b 09 00 00 	movl   $0x90b,(%esp)
  40:	e8 97 03 00 00       	call   3dc <mknod>
    open("console", O_RDWR);
  45:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 0b 09 00 00 	movl   $0x90b,(%esp)
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
  71:	c7 44 24 04 13 09 00 	movl   $0x913,0x4(%esp)
  78:	00 
  79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80:	e8 b7 04 00 00       	call   53c <printf>
    pid = fork();
  85:	e8 02 03 00 00       	call   38c <fork>
  8a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  8e:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  93:	79 20                	jns    b5 <main+0xb5>
      printf(1, "init: fork failed\n");
  95:	c7 44 24 04 26 09 00 	movl   $0x926,0x4(%esp)
  9c:	00 
  9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a4:	e8 93 04 00 00       	call   53c <printf>
      exit(-1);
  a9:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  b0:	e8 df 02 00 00       	call   394 <exit>
    }
    if(pid == 0){
  b5:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ba:	75 34                	jne    f0 <main+0xf0>
      exec("sh", argv);
  bc:	c7 44 24 04 a4 0b 00 	movl   $0xba4,0x4(%esp)
  c3:	00 
  c4:	c7 04 24 08 09 00 00 	movl   $0x908,(%esp)
  cb:	e8 fc 02 00 00       	call   3cc <exec>
      printf(1, "init: exec sh failed\n");
  d0:	c7 44 24 04 39 09 00 	movl   $0x939,0x4(%esp)
  d7:	00 
  d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  df:	e8 58 04 00 00       	call   53c <printf>
      exit(-1);
  e4:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  eb:	e8 a4 02 00 00       	call   394 <exit>
    }
    while((wpid=wait(&status)) >= 0 && wpid != pid)
  f0:	eb 14                	jmp    106 <main+0x106>
      printf(1, "zombie!\n");
  f2:	c7 44 24 04 4f 09 00 	movl   $0x94f,0x4(%esp)
  f9:	00 
  fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 101:	e8 36 04 00 00       	call   53c <printf>
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

0000044c <fg>:
SYSCALL (fg)
 44c:	b8 19 00 00 00       	mov    $0x19,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <waitpid>:
SYSCALL(waitpid)
 454:	b8 1a 00 00 00       	mov    $0x1a,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 45c:	55                   	push   %ebp
 45d:	89 e5                	mov    %esp,%ebp
 45f:	83 ec 18             	sub    $0x18,%esp
 462:	8b 45 0c             	mov    0xc(%ebp),%eax
 465:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 468:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 46f:	00 
 470:	8d 45 f4             	lea    -0xc(%ebp),%eax
 473:	89 44 24 04          	mov    %eax,0x4(%esp)
 477:	8b 45 08             	mov    0x8(%ebp),%eax
 47a:	89 04 24             	mov    %eax,(%esp)
 47d:	e8 32 ff ff ff       	call   3b4 <write>
}
 482:	c9                   	leave  
 483:	c3                   	ret    

00000484 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 484:	55                   	push   %ebp
 485:	89 e5                	mov    %esp,%ebp
 487:	56                   	push   %esi
 488:	53                   	push   %ebx
 489:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 48c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 493:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 497:	74 17                	je     4b0 <printint+0x2c>
 499:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 49d:	79 11                	jns    4b0 <printint+0x2c>
    neg = 1;
 49f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a9:	f7 d8                	neg    %eax
 4ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ae:	eb 06                	jmp    4b6 <printint+0x32>
  } else {
    x = xx;
 4b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4bd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4c0:	8d 41 01             	lea    0x1(%ecx),%eax
 4c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4cc:	ba 00 00 00 00       	mov    $0x0,%edx
 4d1:	f7 f3                	div    %ebx
 4d3:	89 d0                	mov    %edx,%eax
 4d5:	0f b6 80 ac 0b 00 00 	movzbl 0xbac(%eax),%eax
 4dc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4e0:	8b 75 10             	mov    0x10(%ebp),%esi
 4e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e6:	ba 00 00 00 00       	mov    $0x0,%edx
 4eb:	f7 f6                	div    %esi
 4ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f4:	75 c7                	jne    4bd <printint+0x39>
  if(neg)
 4f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fa:	74 10                	je     50c <printint+0x88>
    buf[i++] = '-';
 4fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ff:	8d 50 01             	lea    0x1(%eax),%edx
 502:	89 55 f4             	mov    %edx,-0xc(%ebp)
 505:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 50a:	eb 1f                	jmp    52b <printint+0xa7>
 50c:	eb 1d                	jmp    52b <printint+0xa7>
    putc(fd, buf[i]);
 50e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 511:	8b 45 f4             	mov    -0xc(%ebp),%eax
 514:	01 d0                	add    %edx,%eax
 516:	0f b6 00             	movzbl (%eax),%eax
 519:	0f be c0             	movsbl %al,%eax
 51c:	89 44 24 04          	mov    %eax,0x4(%esp)
 520:	8b 45 08             	mov    0x8(%ebp),%eax
 523:	89 04 24             	mov    %eax,(%esp)
 526:	e8 31 ff ff ff       	call   45c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 52b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 52f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 533:	79 d9                	jns    50e <printint+0x8a>
    putc(fd, buf[i]);
}
 535:	83 c4 30             	add    $0x30,%esp
 538:	5b                   	pop    %ebx
 539:	5e                   	pop    %esi
 53a:	5d                   	pop    %ebp
 53b:	c3                   	ret    

0000053c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 53c:	55                   	push   %ebp
 53d:	89 e5                	mov    %esp,%ebp
 53f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 542:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 549:	8d 45 0c             	lea    0xc(%ebp),%eax
 54c:	83 c0 04             	add    $0x4,%eax
 54f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 552:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 559:	e9 7c 01 00 00       	jmp    6da <printf+0x19e>
    c = fmt[i] & 0xff;
 55e:	8b 55 0c             	mov    0xc(%ebp),%edx
 561:	8b 45 f0             	mov    -0x10(%ebp),%eax
 564:	01 d0                	add    %edx,%eax
 566:	0f b6 00             	movzbl (%eax),%eax
 569:	0f be c0             	movsbl %al,%eax
 56c:	25 ff 00 00 00       	and    $0xff,%eax
 571:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 574:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 578:	75 2c                	jne    5a6 <printf+0x6a>
      if(c == '%'){
 57a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57e:	75 0c                	jne    58c <printf+0x50>
        state = '%';
 580:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 587:	e9 4a 01 00 00       	jmp    6d6 <printf+0x19a>
      } else {
        putc(fd, c);
 58c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58f:	0f be c0             	movsbl %al,%eax
 592:	89 44 24 04          	mov    %eax,0x4(%esp)
 596:	8b 45 08             	mov    0x8(%ebp),%eax
 599:	89 04 24             	mov    %eax,(%esp)
 59c:	e8 bb fe ff ff       	call   45c <putc>
 5a1:	e9 30 01 00 00       	jmp    6d6 <printf+0x19a>
      }
    } else if(state == '%'){
 5a6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5aa:	0f 85 26 01 00 00    	jne    6d6 <printf+0x19a>
      if(c == 'd'){
 5b0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b4:	75 2d                	jne    5e3 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b9:	8b 00                	mov    (%eax),%eax
 5bb:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5c2:	00 
 5c3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5ca:	00 
 5cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	89 04 24             	mov    %eax,(%esp)
 5d5:	e8 aa fe ff ff       	call   484 <printint>
        ap++;
 5da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5de:	e9 ec 00 00 00       	jmp    6cf <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5e3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5e7:	74 06                	je     5ef <printf+0xb3>
 5e9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ed:	75 2d                	jne    61c <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f2:	8b 00                	mov    (%eax),%eax
 5f4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5fb:	00 
 5fc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 603:	00 
 604:	89 44 24 04          	mov    %eax,0x4(%esp)
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	89 04 24             	mov    %eax,(%esp)
 60e:	e8 71 fe ff ff       	call   484 <printint>
        ap++;
 613:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 617:	e9 b3 00 00 00       	jmp    6cf <printf+0x193>
      } else if(c == 's'){
 61c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 620:	75 45                	jne    667 <printf+0x12b>
        s = (char*)*ap;
 622:	8b 45 e8             	mov    -0x18(%ebp),%eax
 625:	8b 00                	mov    (%eax),%eax
 627:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 62a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 62e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 632:	75 09                	jne    63d <printf+0x101>
          s = "(null)";
 634:	c7 45 f4 58 09 00 00 	movl   $0x958,-0xc(%ebp)
        while(*s != 0){
 63b:	eb 1e                	jmp    65b <printf+0x11f>
 63d:	eb 1c                	jmp    65b <printf+0x11f>
          putc(fd, *s);
 63f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 642:	0f b6 00             	movzbl (%eax),%eax
 645:	0f be c0             	movsbl %al,%eax
 648:	89 44 24 04          	mov    %eax,0x4(%esp)
 64c:	8b 45 08             	mov    0x8(%ebp),%eax
 64f:	89 04 24             	mov    %eax,(%esp)
 652:	e8 05 fe ff ff       	call   45c <putc>
          s++;
 657:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 65b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65e:	0f b6 00             	movzbl (%eax),%eax
 661:	84 c0                	test   %al,%al
 663:	75 da                	jne    63f <printf+0x103>
 665:	eb 68                	jmp    6cf <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 667:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 66b:	75 1d                	jne    68a <printf+0x14e>
        putc(fd, *ap);
 66d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	0f be c0             	movsbl %al,%eax
 675:	89 44 24 04          	mov    %eax,0x4(%esp)
 679:	8b 45 08             	mov    0x8(%ebp),%eax
 67c:	89 04 24             	mov    %eax,(%esp)
 67f:	e8 d8 fd ff ff       	call   45c <putc>
        ap++;
 684:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 688:	eb 45                	jmp    6cf <printf+0x193>
      } else if(c == '%'){
 68a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 68e:	75 17                	jne    6a7 <printf+0x16b>
        putc(fd, c);
 690:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 693:	0f be c0             	movsbl %al,%eax
 696:	89 44 24 04          	mov    %eax,0x4(%esp)
 69a:	8b 45 08             	mov    0x8(%ebp),%eax
 69d:	89 04 24             	mov    %eax,(%esp)
 6a0:	e8 b7 fd ff ff       	call   45c <putc>
 6a5:	eb 28                	jmp    6cf <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6ae:	00 
 6af:	8b 45 08             	mov    0x8(%ebp),%eax
 6b2:	89 04 24             	mov    %eax,(%esp)
 6b5:	e8 a2 fd ff ff       	call   45c <putc>
        putc(fd, c);
 6ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6bd:	0f be c0             	movsbl %al,%eax
 6c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	89 04 24             	mov    %eax,(%esp)
 6ca:	e8 8d fd ff ff       	call   45c <putc>
      }
      state = 0;
 6cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6d6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6da:	8b 55 0c             	mov    0xc(%ebp),%edx
 6dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e0:	01 d0                	add    %edx,%eax
 6e2:	0f b6 00             	movzbl (%eax),%eax
 6e5:	84 c0                	test   %al,%al
 6e7:	0f 85 71 fe ff ff    	jne    55e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6ed:	c9                   	leave  
 6ee:	c3                   	ret    

000006ef <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ef:	55                   	push   %ebp
 6f0:	89 e5                	mov    %esp,%ebp
 6f2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f5:	8b 45 08             	mov    0x8(%ebp),%eax
 6f8:	83 e8 08             	sub    $0x8,%eax
 6fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fe:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 703:	89 45 fc             	mov    %eax,-0x4(%ebp)
 706:	eb 24                	jmp    72c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 710:	77 12                	ja     724 <free+0x35>
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 718:	77 24                	ja     73e <free+0x4f>
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	8b 00                	mov    (%eax),%eax
 71f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 722:	77 1a                	ja     73e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 00                	mov    (%eax),%eax
 729:	89 45 fc             	mov    %eax,-0x4(%ebp)
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 732:	76 d4                	jbe    708 <free+0x19>
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73c:	76 ca                	jbe    708 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	8b 40 04             	mov    0x4(%eax),%eax
 744:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	01 c2                	add    %eax,%edx
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	8b 00                	mov    (%eax),%eax
 755:	39 c2                	cmp    %eax,%edx
 757:	75 24                	jne    77d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 759:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75c:	8b 50 04             	mov    0x4(%eax),%edx
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	8b 40 04             	mov    0x4(%eax),%eax
 767:	01 c2                	add    %eax,%edx
 769:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	8b 00                	mov    (%eax),%eax
 774:	8b 10                	mov    (%eax),%edx
 776:	8b 45 f8             	mov    -0x8(%ebp),%eax
 779:	89 10                	mov    %edx,(%eax)
 77b:	eb 0a                	jmp    787 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	8b 10                	mov    (%eax),%edx
 782:	8b 45 f8             	mov    -0x8(%ebp),%eax
 785:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	8b 40 04             	mov    0x4(%eax),%eax
 78d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	01 d0                	add    %edx,%eax
 799:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79c:	75 20                	jne    7be <free+0xcf>
    p->s.size += bp->s.size;
 79e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a1:	8b 50 04             	mov    0x4(%eax),%edx
 7a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a7:	8b 40 04             	mov    0x4(%eax),%eax
 7aa:	01 c2                	add    %eax,%edx
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b5:	8b 10                	mov    (%eax),%edx
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	89 10                	mov    %edx,(%eax)
 7bc:	eb 08                	jmp    7c6 <free+0xd7>
  } else
    p->s.ptr = bp;
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c4:	89 10                	mov    %edx,(%eax)
  freep = p;
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	a3 c8 0b 00 00       	mov    %eax,0xbc8
}
 7ce:	c9                   	leave  
 7cf:	c3                   	ret    

000007d0 <morecore>:

static Header*
morecore(uint nu)
{
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7d6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7dd:	77 07                	ja     7e6 <morecore+0x16>
    nu = 4096;
 7df:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7e6:	8b 45 08             	mov    0x8(%ebp),%eax
 7e9:	c1 e0 03             	shl    $0x3,%eax
 7ec:	89 04 24             	mov    %eax,(%esp)
 7ef:	e8 28 fc ff ff       	call   41c <sbrk>
 7f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7f7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7fb:	75 07                	jne    804 <morecore+0x34>
    return 0;
 7fd:	b8 00 00 00 00       	mov    $0x0,%eax
 802:	eb 22                	jmp    826 <morecore+0x56>
  hp = (Header*)p;
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 80a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80d:	8b 55 08             	mov    0x8(%ebp),%edx
 810:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 813:	8b 45 f0             	mov    -0x10(%ebp),%eax
 816:	83 c0 08             	add    $0x8,%eax
 819:	89 04 24             	mov    %eax,(%esp)
 81c:	e8 ce fe ff ff       	call   6ef <free>
  return freep;
 821:	a1 c8 0b 00 00       	mov    0xbc8,%eax
}
 826:	c9                   	leave  
 827:	c3                   	ret    

00000828 <malloc>:

void*
malloc(uint nbytes)
{
 828:	55                   	push   %ebp
 829:	89 e5                	mov    %esp,%ebp
 82b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82e:	8b 45 08             	mov    0x8(%ebp),%eax
 831:	83 c0 07             	add    $0x7,%eax
 834:	c1 e8 03             	shr    $0x3,%eax
 837:	83 c0 01             	add    $0x1,%eax
 83a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 83d:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 842:	89 45 f0             	mov    %eax,-0x10(%ebp)
 845:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 849:	75 23                	jne    86e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 84b:	c7 45 f0 c0 0b 00 00 	movl   $0xbc0,-0x10(%ebp)
 852:	8b 45 f0             	mov    -0x10(%ebp),%eax
 855:	a3 c8 0b 00 00       	mov    %eax,0xbc8
 85a:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 85f:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    base.s.size = 0;
 864:	c7 05 c4 0b 00 00 00 	movl   $0x0,0xbc4
 86b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 871:	8b 00                	mov    (%eax),%eax
 873:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	8b 40 04             	mov    0x4(%eax),%eax
 87c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87f:	72 4d                	jb     8ce <malloc+0xa6>
      if(p->s.size == nunits)
 881:	8b 45 f4             	mov    -0xc(%ebp),%eax
 884:	8b 40 04             	mov    0x4(%eax),%eax
 887:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 88a:	75 0c                	jne    898 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	8b 10                	mov    (%eax),%edx
 891:	8b 45 f0             	mov    -0x10(%ebp),%eax
 894:	89 10                	mov    %edx,(%eax)
 896:	eb 26                	jmp    8be <malloc+0x96>
      else {
        p->s.size -= nunits;
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	8b 40 04             	mov    0x4(%eax),%eax
 89e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8a1:	89 c2                	mov    %eax,%edx
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ac:	8b 40 04             	mov    0x4(%eax),%eax
 8af:	c1 e0 03             	shl    $0x3,%eax
 8b2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8bb:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c1:	a3 c8 0b 00 00       	mov    %eax,0xbc8
      return (void*)(p + 1);
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	83 c0 08             	add    $0x8,%eax
 8cc:	eb 38                	jmp    906 <malloc+0xde>
    }
    if(p == freep)
 8ce:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 8d3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8d6:	75 1b                	jne    8f3 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8db:	89 04 24             	mov    %eax,(%esp)
 8de:	e8 ed fe ff ff       	call   7d0 <morecore>
 8e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ea:	75 07                	jne    8f3 <malloc+0xcb>
        return 0;
 8ec:	b8 00 00 00 00       	mov    $0x0,%eax
 8f1:	eb 13                	jmp    906 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fc:	8b 00                	mov    (%eax),%eax
 8fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 901:	e9 70 ff ff ff       	jmp    876 <malloc+0x4e>
}
 906:	c9                   	leave  
 907:	c3                   	ret    
