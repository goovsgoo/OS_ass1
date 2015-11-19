
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  write(fd, s, strlen(s));
   6:	8b 45 0c             	mov    0xc(%ebp),%eax
   9:	89 04 24             	mov    %eax,(%esp)
   c:	e8 ca 01 00 00       	call   1db <strlen>
  11:	89 44 24 08          	mov    %eax,0x8(%esp)
  15:	8b 45 0c             	mov    0xc(%ebp),%eax
  18:	89 44 24 04          	mov    %eax,0x4(%esp)
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 a8 03 00 00       	call   3cf <write>
}
  27:	c9                   	leave  
  28:	c3                   	ret    

00000029 <forktest>:

void
forktest(void)
{
  29:	55                   	push   %ebp
  2a:	89 e5                	mov    %esp,%ebp
  2c:	83 ec 28             	sub    $0x28,%esp
  int n, pid;
  int status;			//for wait func

  printf(1, "fork test\n");
  2f:	c7 44 24 04 68 04 00 	movl   $0x468,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 bd ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  4a:	eb 26                	jmp    72 <forktest+0x49>
    pid = fork();
  4c:	e8 56 03 00 00       	call   3a7 <fork>
  51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  58:	79 02                	jns    5c <forktest+0x33>
      break;
  5a:	eb 1f                	jmp    7b <forktest+0x52>
    if(pid == 0)
  5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  60:	75 0c                	jne    6e <forktest+0x45>
      exit(0);
  62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  69:	e8 41 03 00 00       	call   3af <exit>
  int n, pid;
  int status;			//for wait func

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  72:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  79:	7e d1                	jle    4c <forktest+0x23>
      break;
    if(pid == 0)
      exit(0);
  }
  
  if(n == N){
  7b:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  82:	75 28                	jne    ac <forktest+0x83>
    printf(1, "fork claimed to work N times!\n", N);
  84:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
  8b:	00 
  8c:	c7 44 24 04 74 04 00 	movl   $0x474,0x4(%esp)
  93:	00 
  94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9b:	e8 60 ff ff ff       	call   0 <printf>
    exit(0);
  a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a7:	e8 03 03 00 00       	call   3af <exit>
  }
  
  for(; n > 0; n--){
  ac:	eb 33                	jmp    e1 <forktest+0xb8>
    if(wait(&status) < 0){
  ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
  b1:	89 04 24             	mov    %eax,(%esp)
  b4:	e8 fe 02 00 00       	call   3b7 <wait>
  b9:	85 c0                	test   %eax,%eax
  bb:	79 20                	jns    dd <forktest+0xb4>
      printf(1, "wait stopped early\n");
  bd:	c7 44 24 04 93 04 00 	movl   $0x493,0x4(%esp)
  c4:	00 
  c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  cc:	e8 2f ff ff ff       	call   0 <printf>
      exit(-1);
  d1:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  d8:	e8 d2 02 00 00       	call   3af <exit>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit(0);
  }
  
  for(; n > 0; n--){
  dd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  e5:	7f c7                	jg     ae <forktest+0x85>
      printf(1, "wait stopped early\n");
      exit(-1);
    }
  }
  
  if(wait(&status) != -1){
  e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  ea:	89 04 24             	mov    %eax,(%esp)
  ed:	e8 c5 02 00 00       	call   3b7 <wait>
  f2:	83 f8 ff             	cmp    $0xffffffff,%eax
  f5:	74 20                	je     117 <forktest+0xee>
    printf(1, "wait got too many\n");
  f7:	c7 44 24 04 a7 04 00 	movl   $0x4a7,0x4(%esp)
  fe:	00 
  ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 106:	e8 f5 fe ff ff       	call   0 <printf>
    exit(-1);
 10b:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 112:	e8 98 02 00 00       	call   3af <exit>
  }
  
  printf(1, "fork test OK\n");
 117:	c7 44 24 04 ba 04 00 	movl   $0x4ba,0x4(%esp)
 11e:	00 
 11f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 126:	e8 d5 fe ff ff       	call   0 <printf>
}
 12b:	c9                   	leave  
 12c:	c3                   	ret    

0000012d <main>:

int
main(void)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 e4 f0             	and    $0xfffffff0,%esp
 133:	83 ec 10             	sub    $0x10,%esp
  forktest();
 136:	e8 ee fe ff ff       	call   29 <forktest>
  exit(0);
 13b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 142:	e8 68 02 00 00       	call   3af <exit>

00000147 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
 14a:	57                   	push   %edi
 14b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 14c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 14f:	8b 55 10             	mov    0x10(%ebp),%edx
 152:	8b 45 0c             	mov    0xc(%ebp),%eax
 155:	89 cb                	mov    %ecx,%ebx
 157:	89 df                	mov    %ebx,%edi
 159:	89 d1                	mov    %edx,%ecx
 15b:	fc                   	cld    
 15c:	f3 aa                	rep stos %al,%es:(%edi)
 15e:	89 ca                	mov    %ecx,%edx
 160:	89 fb                	mov    %edi,%ebx
 162:	89 5d 08             	mov    %ebx,0x8(%ebp)
 165:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 168:	5b                   	pop    %ebx
 169:	5f                   	pop    %edi
 16a:	5d                   	pop    %ebp
 16b:	c3                   	ret    

0000016c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
 16f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 178:	90                   	nop
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	8d 50 01             	lea    0x1(%eax),%edx
 17f:	89 55 08             	mov    %edx,0x8(%ebp)
 182:	8b 55 0c             	mov    0xc(%ebp),%edx
 185:	8d 4a 01             	lea    0x1(%edx),%ecx
 188:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 18b:	0f b6 12             	movzbl (%edx),%edx
 18e:	88 10                	mov    %dl,(%eax)
 190:	0f b6 00             	movzbl (%eax),%eax
 193:	84 c0                	test   %al,%al
 195:	75 e2                	jne    179 <strcpy+0xd>
    ;
  return os;
 197:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 19a:	c9                   	leave  
 19b:	c3                   	ret    

0000019c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 19f:	eb 08                	jmp    1a9 <strcmp+0xd>
    p++, q++;
 1a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	0f b6 00             	movzbl (%eax),%eax
 1af:	84 c0                	test   %al,%al
 1b1:	74 10                	je     1c3 <strcmp+0x27>
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	0f b6 10             	movzbl (%eax),%edx
 1b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bc:	0f b6 00             	movzbl (%eax),%eax
 1bf:	38 c2                	cmp    %al,%dl
 1c1:	74 de                	je     1a1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	0f b6 00             	movzbl (%eax),%eax
 1c9:	0f b6 d0             	movzbl %al,%edx
 1cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cf:	0f b6 00             	movzbl (%eax),%eax
 1d2:	0f b6 c0             	movzbl %al,%eax
 1d5:	29 c2                	sub    %eax,%edx
 1d7:	89 d0                	mov    %edx,%eax
}
 1d9:	5d                   	pop    %ebp
 1da:	c3                   	ret    

000001db <strlen>:

uint
strlen(char *s)
{
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e8:	eb 04                	jmp    1ee <strlen+0x13>
 1ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	01 d0                	add    %edx,%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	84 c0                	test   %al,%al
 1fb:	75 ed                	jne    1ea <strlen+0xf>
    ;
  return n;
 1fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 200:	c9                   	leave  
 201:	c3                   	ret    

00000202 <memset>:

void*
memset(void *dst, int c, uint n)
{
 202:	55                   	push   %ebp
 203:	89 e5                	mov    %esp,%ebp
 205:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 208:	8b 45 10             	mov    0x10(%ebp),%eax
 20b:	89 44 24 08          	mov    %eax,0x8(%esp)
 20f:	8b 45 0c             	mov    0xc(%ebp),%eax
 212:	89 44 24 04          	mov    %eax,0x4(%esp)
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	89 04 24             	mov    %eax,(%esp)
 21c:	e8 26 ff ff ff       	call   147 <stosb>
  return dst;
 221:	8b 45 08             	mov    0x8(%ebp),%eax
}
 224:	c9                   	leave  
 225:	c3                   	ret    

00000226 <strchr>:

char*
strchr(const char *s, char c)
{
 226:	55                   	push   %ebp
 227:	89 e5                	mov    %esp,%ebp
 229:	83 ec 04             	sub    $0x4,%esp
 22c:	8b 45 0c             	mov    0xc(%ebp),%eax
 22f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 232:	eb 14                	jmp    248 <strchr+0x22>
    if(*s == c)
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	0f b6 00             	movzbl (%eax),%eax
 23a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 23d:	75 05                	jne    244 <strchr+0x1e>
      return (char*)s;
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	eb 13                	jmp    257 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 244:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	0f b6 00             	movzbl (%eax),%eax
 24e:	84 c0                	test   %al,%al
 250:	75 e2                	jne    234 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 252:	b8 00 00 00 00       	mov    $0x0,%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <gets>:

char*
gets(char *buf, int max)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
 25c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 266:	eb 4c                	jmp    2b4 <gets+0x5b>
    cc = read(0, &c, 1);
 268:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 26f:	00 
 270:	8d 45 ef             	lea    -0x11(%ebp),%eax
 273:	89 44 24 04          	mov    %eax,0x4(%esp)
 277:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 27e:	e8 44 01 00 00       	call   3c7 <read>
 283:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 286:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 28a:	7f 02                	jg     28e <gets+0x35>
      break;
 28c:	eb 31                	jmp    2bf <gets+0x66>
    buf[i++] = c;
 28e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 291:	8d 50 01             	lea    0x1(%eax),%edx
 294:	89 55 f4             	mov    %edx,-0xc(%ebp)
 297:	89 c2                	mov    %eax,%edx
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	01 c2                	add    %eax,%edx
 29e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	3c 0a                	cmp    $0xa,%al
 2aa:	74 13                	je     2bf <gets+0x66>
 2ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b0:	3c 0d                	cmp    $0xd,%al
 2b2:	74 0b                	je     2bf <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b7:	83 c0 01             	add    $0x1,%eax
 2ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2bd:	7c a9                	jl     268 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	01 d0                	add    %edx,%eax
 2c7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2cd:	c9                   	leave  
 2ce:	c3                   	ret    

000002cf <stat>:

int
stat(char *n, struct stat *st)
{
 2cf:	55                   	push   %ebp
 2d0:	89 e5                	mov    %esp,%ebp
 2d2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2dc:	00 
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	89 04 24             	mov    %eax,(%esp)
 2e3:	e8 07 01 00 00       	call   3ef <open>
 2e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2ef:	79 07                	jns    2f8 <stat+0x29>
    return -1;
 2f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f6:	eb 23                	jmp    31b <stat+0x4c>
  r = fstat(fd, st);
 2f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 302:	89 04 24             	mov    %eax,(%esp)
 305:	e8 fd 00 00 00       	call   407 <fstat>
 30a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 30d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 310:	89 04 24             	mov    %eax,(%esp)
 313:	e8 bf 00 00 00       	call   3d7 <close>
  return r;
 318:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 31b:	c9                   	leave  
 31c:	c3                   	ret    

0000031d <atoi>:

int
atoi(const char *s)
{
 31d:	55                   	push   %ebp
 31e:	89 e5                	mov    %esp,%ebp
 320:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 323:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 32a:	eb 25                	jmp    351 <atoi+0x34>
    n = n*10 + *s++ - '0';
 32c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 32f:	89 d0                	mov    %edx,%eax
 331:	c1 e0 02             	shl    $0x2,%eax
 334:	01 d0                	add    %edx,%eax
 336:	01 c0                	add    %eax,%eax
 338:	89 c1                	mov    %eax,%ecx
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	8d 50 01             	lea    0x1(%eax),%edx
 340:	89 55 08             	mov    %edx,0x8(%ebp)
 343:	0f b6 00             	movzbl (%eax),%eax
 346:	0f be c0             	movsbl %al,%eax
 349:	01 c8                	add    %ecx,%eax
 34b:	83 e8 30             	sub    $0x30,%eax
 34e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 351:	8b 45 08             	mov    0x8(%ebp),%eax
 354:	0f b6 00             	movzbl (%eax),%eax
 357:	3c 2f                	cmp    $0x2f,%al
 359:	7e 0a                	jle    365 <atoi+0x48>
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	0f b6 00             	movzbl (%eax),%eax
 361:	3c 39                	cmp    $0x39,%al
 363:	7e c7                	jle    32c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 365:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 368:	c9                   	leave  
 369:	c3                   	ret    

0000036a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 36a:	55                   	push   %ebp
 36b:	89 e5                	mov    %esp,%ebp
 36d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 370:	8b 45 08             	mov    0x8(%ebp),%eax
 373:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 376:	8b 45 0c             	mov    0xc(%ebp),%eax
 379:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 37c:	eb 17                	jmp    395 <memmove+0x2b>
    *dst++ = *src++;
 37e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 381:	8d 50 01             	lea    0x1(%eax),%edx
 384:	89 55 fc             	mov    %edx,-0x4(%ebp)
 387:	8b 55 f8             	mov    -0x8(%ebp),%edx
 38a:	8d 4a 01             	lea    0x1(%edx),%ecx
 38d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 390:	0f b6 12             	movzbl (%edx),%edx
 393:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 395:	8b 45 10             	mov    0x10(%ebp),%eax
 398:	8d 50 ff             	lea    -0x1(%eax),%edx
 39b:	89 55 10             	mov    %edx,0x10(%ebp)
 39e:	85 c0                	test   %eax,%eax
 3a0:	7f dc                	jg     37e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a5:	c9                   	leave  
 3a6:	c3                   	ret    

000003a7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a7:	b8 01 00 00 00       	mov    $0x1,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <exit>:
SYSCALL(exit)
 3af:	b8 02 00 00 00       	mov    $0x2,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <wait>:
SYSCALL(wait)
 3b7:	b8 03 00 00 00       	mov    $0x3,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <pipe>:
SYSCALL(pipe)
 3bf:	b8 04 00 00 00       	mov    $0x4,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <read>:
SYSCALL(read)
 3c7:	b8 05 00 00 00       	mov    $0x5,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <write>:
SYSCALL(write)
 3cf:	b8 10 00 00 00       	mov    $0x10,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <close>:
SYSCALL(close)
 3d7:	b8 15 00 00 00       	mov    $0x15,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <kill>:
SYSCALL(kill)
 3df:	b8 06 00 00 00       	mov    $0x6,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <exec>:
SYSCALL(exec)
 3e7:	b8 07 00 00 00       	mov    $0x7,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <open>:
SYSCALL(open)
 3ef:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <mknod>:
SYSCALL(mknod)
 3f7:	b8 11 00 00 00       	mov    $0x11,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <unlink>:
SYSCALL(unlink)
 3ff:	b8 12 00 00 00       	mov    $0x12,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <fstat>:
SYSCALL(fstat)
 407:	b8 08 00 00 00       	mov    $0x8,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <link>:
SYSCALL(link)
 40f:	b8 13 00 00 00       	mov    $0x13,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <mkdir>:
SYSCALL(mkdir)
 417:	b8 14 00 00 00       	mov    $0x14,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <chdir>:
SYSCALL(chdir)
 41f:	b8 09 00 00 00       	mov    $0x9,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <dup>:
SYSCALL(dup)
 427:	b8 0a 00 00 00       	mov    $0xa,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <getpid>:
SYSCALL(getpid)
 42f:	b8 0b 00 00 00       	mov    $0xb,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <sbrk>:
SYSCALL(sbrk)
 437:	b8 0c 00 00 00       	mov    $0xc,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <sleep>:
SYSCALL(sleep)
 43f:	b8 0d 00 00 00       	mov    $0xd,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <uptime>:
SYSCALL(uptime)
 447:	b8 0e 00 00 00       	mov    $0xe,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <pstat>:
SYSCALL(pstat)
 44f:	b8 16 00 00 00       	mov    $0x16,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <printjob>:
SYSCALL(printjob)
 457:	b8 17 00 00 00       	mov    $0x17,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <attachjob>:
SYSCALL(attachjob)
 45f:	b8 18 00 00 00       	mov    $0x18,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    
