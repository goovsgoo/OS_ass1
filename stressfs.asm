
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int status;
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1a 02 00 00 	movl   $0x65727473,0x21a(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 1e 02 00 00 	movl   $0x73667373,0x21e(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 22 02 00 	movw   $0x30,0x222(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 90 09 00 	movl   $0x990,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 84 05 00 00       	call   5c4 <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1a          	lea    0x1a(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 23 02 00 00       	call   27f <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 13                	jmp    7c <main+0x7c>
    if(fork() > 0)
  69:	e8 b6 03 00 00       	call   424 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7e 02                	jle    74 <main+0x74>
      break;
  72:	eb 12                	jmp    86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  74:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  7b:	01 
  7c:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  83:	03 
  84:	7e e3                	jle    69 <main+0x69>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  86:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  91:	c7 44 24 04 a3 09 00 	movl   $0x9a3,0x4(%esp)
  98:	00 
  99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a0:	e8 1f 05 00 00       	call   5c4 <printf>

  path[8] += i;
  a5:	0f b6 84 24 22 02 00 	movzbl 0x222(%esp),%eax
  ac:	00 
  ad:	89 c2                	mov    %eax,%edx
  af:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b6:	01 d0                	add    %edx,%eax
  b8:	88 84 24 22 02 00 00 	mov    %al,0x222(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  bf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c6:	00 
  c7:	8d 84 24 1a 02 00 00 	lea    0x21a(%esp),%eax
  ce:	89 04 24             	mov    %eax,(%esp)
  d1:	e8 96 03 00 00       	call   46c <open>
  d6:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  dd:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e4:	00 00 00 00 
  e8:	eb 27                	jmp    111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ea:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f1:	00 
  f2:	8d 44 24 1a          	lea    0x1a(%esp),%eax
  f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  fa:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 101:	89 04 24             	mov    %eax,(%esp)
 104:	e8 43 03 00 00       	call   44c <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 109:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 110:	01 
 111:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 118:	13 
 119:	7e cf                	jle    ea <main+0xea>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 11b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 122:	89 04 24             	mov    %eax,(%esp)
 125:	e8 2a 03 00 00       	call   454 <close>

  printf(1, "read\n");
 12a:	c7 44 24 04 ad 09 00 	movl   $0x9ad,0x4(%esp)
 131:	00 
 132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 139:	e8 86 04 00 00       	call   5c4 <printf>

  fd = open(path, O_RDONLY);
 13e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 145:	00 
 146:	8d 84 24 1a 02 00 00 	lea    0x21a(%esp),%eax
 14d:	89 04 24             	mov    %eax,(%esp)
 150:	e8 17 03 00 00       	call   46c <open>
 155:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 163:	00 00 00 00 
 167:	eb 27                	jmp    190 <main+0x190>
    read(fd, data, sizeof(data));
 169:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 170:	00 
 171:	8d 44 24 1a          	lea    0x1a(%esp),%eax
 175:	89 44 24 04          	mov    %eax,0x4(%esp)
 179:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 180:	89 04 24             	mov    %eax,(%esp)
 183:	e8 bc 02 00 00       	call   444 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 188:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 18f:	01 
 190:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 197:	13 
 198:	7e cf                	jle    169 <main+0x169>
    read(fd, data, sizeof(data));
  close(fd);
 19a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a1:	89 04 24             	mov    %eax,(%esp)
 1a4:	e8 ab 02 00 00       	call   454 <close>

  wait(&status);
 1a9:	8d 84 24 24 02 00 00 	lea    0x224(%esp),%eax
 1b0:	89 04 24             	mov    %eax,(%esp)
 1b3:	e8 7c 02 00 00       	call   434 <wait>
  
  exit(0);
 1b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1bf:	e8 68 02 00 00       	call   42c <exit>

000001c4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
 1c8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1cc:	8b 55 10             	mov    0x10(%ebp),%edx
 1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d2:	89 cb                	mov    %ecx,%ebx
 1d4:	89 df                	mov    %ebx,%edi
 1d6:	89 d1                	mov    %edx,%ecx
 1d8:	fc                   	cld    
 1d9:	f3 aa                	rep stos %al,%es:(%edi)
 1db:	89 ca                	mov    %ecx,%edx
 1dd:	89 fb                	mov    %edi,%ebx
 1df:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1e2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e5:	5b                   	pop    %ebx
 1e6:	5f                   	pop    %edi
 1e7:	5d                   	pop    %ebp
 1e8:	c3                   	ret    

000001e9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
 1f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1f5:	90                   	nop
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	8d 50 01             	lea    0x1(%eax),%edx
 1fc:	89 55 08             	mov    %edx,0x8(%ebp)
 1ff:	8b 55 0c             	mov    0xc(%ebp),%edx
 202:	8d 4a 01             	lea    0x1(%edx),%ecx
 205:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 208:	0f b6 12             	movzbl (%edx),%edx
 20b:	88 10                	mov    %dl,(%eax)
 20d:	0f b6 00             	movzbl (%eax),%eax
 210:	84 c0                	test   %al,%al
 212:	75 e2                	jne    1f6 <strcpy+0xd>
    ;
  return os;
 214:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 217:	c9                   	leave  
 218:	c3                   	ret    

00000219 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 219:	55                   	push   %ebp
 21a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 21c:	eb 08                	jmp    226 <strcmp+0xd>
    p++, q++;
 21e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 222:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 226:	8b 45 08             	mov    0x8(%ebp),%eax
 229:	0f b6 00             	movzbl (%eax),%eax
 22c:	84 c0                	test   %al,%al
 22e:	74 10                	je     240 <strcmp+0x27>
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	0f b6 10             	movzbl (%eax),%edx
 236:	8b 45 0c             	mov    0xc(%ebp),%eax
 239:	0f b6 00             	movzbl (%eax),%eax
 23c:	38 c2                	cmp    %al,%dl
 23e:	74 de                	je     21e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	0f b6 d0             	movzbl %al,%edx
 249:	8b 45 0c             	mov    0xc(%ebp),%eax
 24c:	0f b6 00             	movzbl (%eax),%eax
 24f:	0f b6 c0             	movzbl %al,%eax
 252:	29 c2                	sub    %eax,%edx
 254:	89 d0                	mov    %edx,%eax
}
 256:	5d                   	pop    %ebp
 257:	c3                   	ret    

00000258 <strlen>:

uint
strlen(char *s)
{
 258:	55                   	push   %ebp
 259:	89 e5                	mov    %esp,%ebp
 25b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 25e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 265:	eb 04                	jmp    26b <strlen+0x13>
 267:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 26b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	01 d0                	add    %edx,%eax
 273:	0f b6 00             	movzbl (%eax),%eax
 276:	84 c0                	test   %al,%al
 278:	75 ed                	jne    267 <strlen+0xf>
    ;
  return n;
 27a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27d:	c9                   	leave  
 27e:	c3                   	ret    

0000027f <memset>:

void*
memset(void *dst, int c, uint n)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 285:	8b 45 10             	mov    0x10(%ebp),%eax
 288:	89 44 24 08          	mov    %eax,0x8(%esp)
 28c:	8b 45 0c             	mov    0xc(%ebp),%eax
 28f:	89 44 24 04          	mov    %eax,0x4(%esp)
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	89 04 24             	mov    %eax,(%esp)
 299:	e8 26 ff ff ff       	call   1c4 <stosb>
  return dst;
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a1:	c9                   	leave  
 2a2:	c3                   	ret    

000002a3 <strchr>:

char*
strchr(const char *s, char c)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 04             	sub    $0x4,%esp
 2a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ac:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2af:	eb 14                	jmp    2c5 <strchr+0x22>
    if(*s == c)
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2ba:	75 05                	jne    2c1 <strchr+0x1e>
      return (char*)s;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	eb 13                	jmp    2d4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	0f b6 00             	movzbl (%eax),%eax
 2cb:	84 c0                	test   %al,%al
 2cd:	75 e2                	jne    2b1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d4:	c9                   	leave  
 2d5:	c3                   	ret    

000002d6 <gets>:

char*
gets(char *buf, int max)
{
 2d6:	55                   	push   %ebp
 2d7:	89 e5                	mov    %esp,%ebp
 2d9:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2e3:	eb 4c                	jmp    331 <gets+0x5b>
    cc = read(0, &c, 1);
 2e5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2ec:	00 
 2ed:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2fb:	e8 44 01 00 00       	call   444 <read>
 300:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 303:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 307:	7f 02                	jg     30b <gets+0x35>
      break;
 309:	eb 31                	jmp    33c <gets+0x66>
    buf[i++] = c;
 30b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30e:	8d 50 01             	lea    0x1(%eax),%edx
 311:	89 55 f4             	mov    %edx,-0xc(%ebp)
 314:	89 c2                	mov    %eax,%edx
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	01 c2                	add    %eax,%edx
 31b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 321:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 325:	3c 0a                	cmp    $0xa,%al
 327:	74 13                	je     33c <gets+0x66>
 329:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32d:	3c 0d                	cmp    $0xd,%al
 32f:	74 0b                	je     33c <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 331:	8b 45 f4             	mov    -0xc(%ebp),%eax
 334:	83 c0 01             	add    $0x1,%eax
 337:	3b 45 0c             	cmp    0xc(%ebp),%eax
 33a:	7c a9                	jl     2e5 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 33c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	01 d0                	add    %edx,%eax
 344:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 347:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34a:	c9                   	leave  
 34b:	c3                   	ret    

0000034c <stat>:

int
stat(char *n, struct stat *st)
{
 34c:	55                   	push   %ebp
 34d:	89 e5                	mov    %esp,%ebp
 34f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 352:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 359:	00 
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	89 04 24             	mov    %eax,(%esp)
 360:	e8 07 01 00 00       	call   46c <open>
 365:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 36c:	79 07                	jns    375 <stat+0x29>
    return -1;
 36e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 373:	eb 23                	jmp    398 <stat+0x4c>
  r = fstat(fd, st);
 375:	8b 45 0c             	mov    0xc(%ebp),%eax
 378:	89 44 24 04          	mov    %eax,0x4(%esp)
 37c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37f:	89 04 24             	mov    %eax,(%esp)
 382:	e8 fd 00 00 00       	call   484 <fstat>
 387:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 38a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38d:	89 04 24             	mov    %eax,(%esp)
 390:	e8 bf 00 00 00       	call   454 <close>
  return r;
 395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 398:	c9                   	leave  
 399:	c3                   	ret    

0000039a <atoi>:

int
atoi(const char *s)
{
 39a:	55                   	push   %ebp
 39b:	89 e5                	mov    %esp,%ebp
 39d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3a7:	eb 25                	jmp    3ce <atoi+0x34>
    n = n*10 + *s++ - '0';
 3a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ac:	89 d0                	mov    %edx,%eax
 3ae:	c1 e0 02             	shl    $0x2,%eax
 3b1:	01 d0                	add    %edx,%eax
 3b3:	01 c0                	add    %eax,%eax
 3b5:	89 c1                	mov    %eax,%ecx
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	8d 50 01             	lea    0x1(%eax),%edx
 3bd:	89 55 08             	mov    %edx,0x8(%ebp)
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	0f be c0             	movsbl %al,%eax
 3c6:	01 c8                	add    %ecx,%eax
 3c8:	83 e8 30             	sub    $0x30,%eax
 3cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ce:	8b 45 08             	mov    0x8(%ebp),%eax
 3d1:	0f b6 00             	movzbl (%eax),%eax
 3d4:	3c 2f                	cmp    $0x2f,%al
 3d6:	7e 0a                	jle    3e2 <atoi+0x48>
 3d8:	8b 45 08             	mov    0x8(%ebp),%eax
 3db:	0f b6 00             	movzbl (%eax),%eax
 3de:	3c 39                	cmp    $0x39,%al
 3e0:	7e c7                	jle    3a9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e5:	c9                   	leave  
 3e6:	c3                   	ret    

000003e7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3e7:	55                   	push   %ebp
 3e8:	89 e5                	mov    %esp,%ebp
 3ea:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
 3f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3f9:	eb 17                	jmp    412 <memmove+0x2b>
    *dst++ = *src++;
 3fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fe:	8d 50 01             	lea    0x1(%eax),%edx
 401:	89 55 fc             	mov    %edx,-0x4(%ebp)
 404:	8b 55 f8             	mov    -0x8(%ebp),%edx
 407:	8d 4a 01             	lea    0x1(%edx),%ecx
 40a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 40d:	0f b6 12             	movzbl (%edx),%edx
 410:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 412:	8b 45 10             	mov    0x10(%ebp),%eax
 415:	8d 50 ff             	lea    -0x1(%eax),%edx
 418:	89 55 10             	mov    %edx,0x10(%ebp)
 41b:	85 c0                	test   %eax,%eax
 41d:	7f dc                	jg     3fb <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 422:	c9                   	leave  
 423:	c3                   	ret    

00000424 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 424:	b8 01 00 00 00       	mov    $0x1,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <exit>:
SYSCALL(exit)
 42c:	b8 02 00 00 00       	mov    $0x2,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <wait>:
SYSCALL(wait)
 434:	b8 03 00 00 00       	mov    $0x3,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <pipe>:
SYSCALL(pipe)
 43c:	b8 04 00 00 00       	mov    $0x4,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <read>:
SYSCALL(read)
 444:	b8 05 00 00 00       	mov    $0x5,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <write>:
SYSCALL(write)
 44c:	b8 10 00 00 00       	mov    $0x10,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <close>:
SYSCALL(close)
 454:	b8 15 00 00 00       	mov    $0x15,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <kill>:
SYSCALL(kill)
 45c:	b8 06 00 00 00       	mov    $0x6,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <exec>:
SYSCALL(exec)
 464:	b8 07 00 00 00       	mov    $0x7,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <open>:
SYSCALL(open)
 46c:	b8 0f 00 00 00       	mov    $0xf,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <mknod>:
SYSCALL(mknod)
 474:	b8 11 00 00 00       	mov    $0x11,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <unlink>:
SYSCALL(unlink)
 47c:	b8 12 00 00 00       	mov    $0x12,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <fstat>:
SYSCALL(fstat)
 484:	b8 08 00 00 00       	mov    $0x8,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <link>:
SYSCALL(link)
 48c:	b8 13 00 00 00       	mov    $0x13,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <mkdir>:
SYSCALL(mkdir)
 494:	b8 14 00 00 00       	mov    $0x14,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <chdir>:
SYSCALL(chdir)
 49c:	b8 09 00 00 00       	mov    $0x9,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <dup>:
SYSCALL(dup)
 4a4:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <getpid>:
SYSCALL(getpid)
 4ac:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <sbrk>:
SYSCALL(sbrk)
 4b4:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <sleep>:
SYSCALL(sleep)
 4bc:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <uptime>:
SYSCALL(uptime)
 4c4:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <pstat>:
SYSCALL(pstat)
 4cc:	b8 16 00 00 00       	mov    $0x16,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <printjob>:
SYSCALL(printjob)
 4d4:	b8 17 00 00 00       	mov    $0x17,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <attachjob>:
SYSCALL(attachjob)
 4dc:	b8 18 00 00 00       	mov    $0x18,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	83 ec 18             	sub    $0x18,%esp
 4ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ed:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f7:	00 
 4f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ff:	8b 45 08             	mov    0x8(%ebp),%eax
 502:	89 04 24             	mov    %eax,(%esp)
 505:	e8 42 ff ff ff       	call   44c <write>
}
 50a:	c9                   	leave  
 50b:	c3                   	ret    

0000050c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 50c:	55                   	push   %ebp
 50d:	89 e5                	mov    %esp,%ebp
 50f:	56                   	push   %esi
 510:	53                   	push   %ebx
 511:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 514:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 51b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 51f:	74 17                	je     538 <printint+0x2c>
 521:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 525:	79 11                	jns    538 <printint+0x2c>
    neg = 1;
 527:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 52e:	8b 45 0c             	mov    0xc(%ebp),%eax
 531:	f7 d8                	neg    %eax
 533:	89 45 ec             	mov    %eax,-0x14(%ebp)
 536:	eb 06                	jmp    53e <printint+0x32>
  } else {
    x = xx;
 538:	8b 45 0c             	mov    0xc(%ebp),%eax
 53b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 53e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 545:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 548:	8d 41 01             	lea    0x1(%ecx),%eax
 54b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 54e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 551:	8b 45 ec             	mov    -0x14(%ebp),%eax
 554:	ba 00 00 00 00       	mov    $0x0,%edx
 559:	f7 f3                	div    %ebx
 55b:	89 d0                	mov    %edx,%eax
 55d:	0f b6 80 00 0c 00 00 	movzbl 0xc00(%eax),%eax
 564:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 568:	8b 75 10             	mov    0x10(%ebp),%esi
 56b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56e:	ba 00 00 00 00       	mov    $0x0,%edx
 573:	f7 f6                	div    %esi
 575:	89 45 ec             	mov    %eax,-0x14(%ebp)
 578:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 57c:	75 c7                	jne    545 <printint+0x39>
  if(neg)
 57e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 582:	74 10                	je     594 <printint+0x88>
    buf[i++] = '-';
 584:	8b 45 f4             	mov    -0xc(%ebp),%eax
 587:	8d 50 01             	lea    0x1(%eax),%edx
 58a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 58d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 592:	eb 1f                	jmp    5b3 <printint+0xa7>
 594:	eb 1d                	jmp    5b3 <printint+0xa7>
    putc(fd, buf[i]);
 596:	8d 55 dc             	lea    -0x24(%ebp),%edx
 599:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59c:	01 d0                	add    %edx,%eax
 59e:	0f b6 00             	movzbl (%eax),%eax
 5a1:	0f be c0             	movsbl %al,%eax
 5a4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	89 04 24             	mov    %eax,(%esp)
 5ae:	e8 31 ff ff ff       	call   4e4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5bb:	79 d9                	jns    596 <printint+0x8a>
    putc(fd, buf[i]);
}
 5bd:	83 c4 30             	add    $0x30,%esp
 5c0:	5b                   	pop    %ebx
 5c1:	5e                   	pop    %esi
 5c2:	5d                   	pop    %ebp
 5c3:	c3                   	ret    

000005c4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5c4:	55                   	push   %ebp
 5c5:	89 e5                	mov    %esp,%ebp
 5c7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5d1:	8d 45 0c             	lea    0xc(%ebp),%eax
 5d4:	83 c0 04             	add    $0x4,%eax
 5d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5e1:	e9 7c 01 00 00       	jmp    762 <printf+0x19e>
    c = fmt[i] & 0xff;
 5e6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ec:	01 d0                	add    %edx,%eax
 5ee:	0f b6 00             	movzbl (%eax),%eax
 5f1:	0f be c0             	movsbl %al,%eax
 5f4:	25 ff 00 00 00       	and    $0xff,%eax
 5f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 600:	75 2c                	jne    62e <printf+0x6a>
      if(c == '%'){
 602:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 606:	75 0c                	jne    614 <printf+0x50>
        state = '%';
 608:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 60f:	e9 4a 01 00 00       	jmp    75e <printf+0x19a>
      } else {
        putc(fd, c);
 614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 617:	0f be c0             	movsbl %al,%eax
 61a:	89 44 24 04          	mov    %eax,0x4(%esp)
 61e:	8b 45 08             	mov    0x8(%ebp),%eax
 621:	89 04 24             	mov    %eax,(%esp)
 624:	e8 bb fe ff ff       	call   4e4 <putc>
 629:	e9 30 01 00 00       	jmp    75e <printf+0x19a>
      }
    } else if(state == '%'){
 62e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 632:	0f 85 26 01 00 00    	jne    75e <printf+0x19a>
      if(c == 'd'){
 638:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 63c:	75 2d                	jne    66b <printf+0xa7>
        printint(fd, *ap, 10, 1);
 63e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 641:	8b 00                	mov    (%eax),%eax
 643:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 64a:	00 
 64b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 652:	00 
 653:	89 44 24 04          	mov    %eax,0x4(%esp)
 657:	8b 45 08             	mov    0x8(%ebp),%eax
 65a:	89 04 24             	mov    %eax,(%esp)
 65d:	e8 aa fe ff ff       	call   50c <printint>
        ap++;
 662:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 666:	e9 ec 00 00 00       	jmp    757 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 66b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 66f:	74 06                	je     677 <printf+0xb3>
 671:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 675:	75 2d                	jne    6a4 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 677:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 683:	00 
 684:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 68b:	00 
 68c:	89 44 24 04          	mov    %eax,0x4(%esp)
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	89 04 24             	mov    %eax,(%esp)
 696:	e8 71 fe ff ff       	call   50c <printint>
        ap++;
 69b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69f:	e9 b3 00 00 00       	jmp    757 <printf+0x193>
      } else if(c == 's'){
 6a4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6a8:	75 45                	jne    6ef <printf+0x12b>
        s = (char*)*ap;
 6aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ad:	8b 00                	mov    (%eax),%eax
 6af:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ba:	75 09                	jne    6c5 <printf+0x101>
          s = "(null)";
 6bc:	c7 45 f4 b3 09 00 00 	movl   $0x9b3,-0xc(%ebp)
        while(*s != 0){
 6c3:	eb 1e                	jmp    6e3 <printf+0x11f>
 6c5:	eb 1c                	jmp    6e3 <printf+0x11f>
          putc(fd, *s);
 6c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ca:	0f b6 00             	movzbl (%eax),%eax
 6cd:	0f be c0             	movsbl %al,%eax
 6d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d4:	8b 45 08             	mov    0x8(%ebp),%eax
 6d7:	89 04 24             	mov    %eax,(%esp)
 6da:	e8 05 fe ff ff       	call   4e4 <putc>
          s++;
 6df:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e6:	0f b6 00             	movzbl (%eax),%eax
 6e9:	84 c0                	test   %al,%al
 6eb:	75 da                	jne    6c7 <printf+0x103>
 6ed:	eb 68                	jmp    757 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ef:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6f3:	75 1d                	jne    712 <printf+0x14e>
        putc(fd, *ap);
 6f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	0f be c0             	movsbl %al,%eax
 6fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 701:	8b 45 08             	mov    0x8(%ebp),%eax
 704:	89 04 24             	mov    %eax,(%esp)
 707:	e8 d8 fd ff ff       	call   4e4 <putc>
        ap++;
 70c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 710:	eb 45                	jmp    757 <printf+0x193>
      } else if(c == '%'){
 712:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 716:	75 17                	jne    72f <printf+0x16b>
        putc(fd, c);
 718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71b:	0f be c0             	movsbl %al,%eax
 71e:	89 44 24 04          	mov    %eax,0x4(%esp)
 722:	8b 45 08             	mov    0x8(%ebp),%eax
 725:	89 04 24             	mov    %eax,(%esp)
 728:	e8 b7 fd ff ff       	call   4e4 <putc>
 72d:	eb 28                	jmp    757 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 72f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 736:	00 
 737:	8b 45 08             	mov    0x8(%ebp),%eax
 73a:	89 04 24             	mov    %eax,(%esp)
 73d:	e8 a2 fd ff ff       	call   4e4 <putc>
        putc(fd, c);
 742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 745:	0f be c0             	movsbl %al,%eax
 748:	89 44 24 04          	mov    %eax,0x4(%esp)
 74c:	8b 45 08             	mov    0x8(%ebp),%eax
 74f:	89 04 24             	mov    %eax,(%esp)
 752:	e8 8d fd ff ff       	call   4e4 <putc>
      }
      state = 0;
 757:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 75e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 762:	8b 55 0c             	mov    0xc(%ebp),%edx
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	01 d0                	add    %edx,%eax
 76a:	0f b6 00             	movzbl (%eax),%eax
 76d:	84 c0                	test   %al,%al
 76f:	0f 85 71 fe ff ff    	jne    5e6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 775:	c9                   	leave  
 776:	c3                   	ret    

00000777 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 777:	55                   	push   %ebp
 778:	89 e5                	mov    %esp,%ebp
 77a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77d:	8b 45 08             	mov    0x8(%ebp),%eax
 780:	83 e8 08             	sub    $0x8,%eax
 783:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 786:	a1 1c 0c 00 00       	mov    0xc1c,%eax
 78b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78e:	eb 24                	jmp    7b4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	8b 45 fc             	mov    -0x4(%ebp),%eax
 793:	8b 00                	mov    (%eax),%eax
 795:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 798:	77 12                	ja     7ac <free+0x35>
 79a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a0:	77 24                	ja     7c6 <free+0x4f>
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	8b 00                	mov    (%eax),%eax
 7a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7aa:	77 1a                	ja     7c6 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	8b 00                	mov    (%eax),%eax
 7b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ba:	76 d4                	jbe    790 <free+0x19>
 7bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bf:	8b 00                	mov    (%eax),%eax
 7c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c4:	76 ca                	jbe    790 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d6:	01 c2                	add    %eax,%edx
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	39 c2                	cmp    %eax,%edx
 7df:	75 24                	jne    805 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e4:	8b 50 04             	mov    0x4(%eax),%edx
 7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ea:	8b 00                	mov    (%eax),%eax
 7ec:	8b 40 04             	mov    0x4(%eax),%eax
 7ef:	01 c2                	add    %eax,%edx
 7f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fa:	8b 00                	mov    (%eax),%eax
 7fc:	8b 10                	mov    (%eax),%edx
 7fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 801:	89 10                	mov    %edx,(%eax)
 803:	eb 0a                	jmp    80f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 805:	8b 45 fc             	mov    -0x4(%ebp),%eax
 808:	8b 10                	mov    (%eax),%edx
 80a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	8b 40 04             	mov    0x4(%eax),%eax
 815:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 81c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81f:	01 d0                	add    %edx,%eax
 821:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 824:	75 20                	jne    846 <free+0xcf>
    p->s.size += bp->s.size;
 826:	8b 45 fc             	mov    -0x4(%ebp),%eax
 829:	8b 50 04             	mov    0x4(%eax),%edx
 82c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82f:	8b 40 04             	mov    0x4(%eax),%eax
 832:	01 c2                	add    %eax,%edx
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
 837:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 83a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83d:	8b 10                	mov    (%eax),%edx
 83f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 842:	89 10                	mov    %edx,(%eax)
 844:	eb 08                	jmp    84e <free+0xd7>
  } else
    p->s.ptr = bp;
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	8b 55 f8             	mov    -0x8(%ebp),%edx
 84c:	89 10                	mov    %edx,(%eax)
  freep = p;
 84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 851:	a3 1c 0c 00 00       	mov    %eax,0xc1c
}
 856:	c9                   	leave  
 857:	c3                   	ret    

00000858 <morecore>:

static Header*
morecore(uint nu)
{
 858:	55                   	push   %ebp
 859:	89 e5                	mov    %esp,%ebp
 85b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 85e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 865:	77 07                	ja     86e <morecore+0x16>
    nu = 4096;
 867:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 86e:	8b 45 08             	mov    0x8(%ebp),%eax
 871:	c1 e0 03             	shl    $0x3,%eax
 874:	89 04 24             	mov    %eax,(%esp)
 877:	e8 38 fc ff ff       	call   4b4 <sbrk>
 87c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 87f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 883:	75 07                	jne    88c <morecore+0x34>
    return 0;
 885:	b8 00 00 00 00       	mov    $0x0,%eax
 88a:	eb 22                	jmp    8ae <morecore+0x56>
  hp = (Header*)p;
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 892:	8b 45 f0             	mov    -0x10(%ebp),%eax
 895:	8b 55 08             	mov    0x8(%ebp),%edx
 898:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 89b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89e:	83 c0 08             	add    $0x8,%eax
 8a1:	89 04 24             	mov    %eax,(%esp)
 8a4:	e8 ce fe ff ff       	call   777 <free>
  return freep;
 8a9:	a1 1c 0c 00 00       	mov    0xc1c,%eax
}
 8ae:	c9                   	leave  
 8af:	c3                   	ret    

000008b0 <malloc>:

void*
malloc(uint nbytes)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b6:	8b 45 08             	mov    0x8(%ebp),%eax
 8b9:	83 c0 07             	add    $0x7,%eax
 8bc:	c1 e8 03             	shr    $0x3,%eax
 8bf:	83 c0 01             	add    $0x1,%eax
 8c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8c5:	a1 1c 0c 00 00       	mov    0xc1c,%eax
 8ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8d1:	75 23                	jne    8f6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8d3:	c7 45 f0 14 0c 00 00 	movl   $0xc14,-0x10(%ebp)
 8da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8dd:	a3 1c 0c 00 00       	mov    %eax,0xc1c
 8e2:	a1 1c 0c 00 00       	mov    0xc1c,%eax
 8e7:	a3 14 0c 00 00       	mov    %eax,0xc14
    base.s.size = 0;
 8ec:	c7 05 18 0c 00 00 00 	movl   $0x0,0xc18
 8f3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f9:	8b 00                	mov    (%eax),%eax
 8fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 901:	8b 40 04             	mov    0x4(%eax),%eax
 904:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 907:	72 4d                	jb     956 <malloc+0xa6>
      if(p->s.size == nunits)
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	8b 40 04             	mov    0x4(%eax),%eax
 90f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 912:	75 0c                	jne    920 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	8b 10                	mov    (%eax),%edx
 919:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91c:	89 10                	mov    %edx,(%eax)
 91e:	eb 26                	jmp    946 <malloc+0x96>
      else {
        p->s.size -= nunits;
 920:	8b 45 f4             	mov    -0xc(%ebp),%eax
 923:	8b 40 04             	mov    0x4(%eax),%eax
 926:	2b 45 ec             	sub    -0x14(%ebp),%eax
 929:	89 c2                	mov    %eax,%edx
 92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 931:	8b 45 f4             	mov    -0xc(%ebp),%eax
 934:	8b 40 04             	mov    0x4(%eax),%eax
 937:	c1 e0 03             	shl    $0x3,%eax
 93a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 93d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 940:	8b 55 ec             	mov    -0x14(%ebp),%edx
 943:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 946:	8b 45 f0             	mov    -0x10(%ebp),%eax
 949:	a3 1c 0c 00 00       	mov    %eax,0xc1c
      return (void*)(p + 1);
 94e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 951:	83 c0 08             	add    $0x8,%eax
 954:	eb 38                	jmp    98e <malloc+0xde>
    }
    if(p == freep)
 956:	a1 1c 0c 00 00       	mov    0xc1c,%eax
 95b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 95e:	75 1b                	jne    97b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 960:	8b 45 ec             	mov    -0x14(%ebp),%eax
 963:	89 04 24             	mov    %eax,(%esp)
 966:	e8 ed fe ff ff       	call   858 <morecore>
 96b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 96e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 972:	75 07                	jne    97b <malloc+0xcb>
        return 0;
 974:	b8 00 00 00 00       	mov    $0x0,%eax
 979:	eb 13                	jmp    98e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 981:	8b 45 f4             	mov    -0xc(%ebp),%eax
 984:	8b 00                	mov    (%eax),%eax
 986:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 989:	e9 70 ff ff ff       	jmp    8fe <malloc+0x4e>
}
 98e:	c9                   	leave  
 98f:	c3                   	ret    
