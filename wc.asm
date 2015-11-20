
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 68                	jmp    8a <wc+0x8a>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 57                	jmp    82 <wc+0x82>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 c0 0c 00 00       	add    $0xcc0,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 c0 0c 00 00       	add    $0xcc0,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	89 44 24 04          	mov    %eax,0x4(%esp)
  54:	c7 04 24 d1 09 00 00 	movl   $0x9d1,(%esp)
  5b:	e8 74 02 00 00       	call   2d4 <strchr>
  60:	85 c0                	test   %eax,%eax
  62:	74 09                	je     6d <wc+0x6d>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6b:	eb 11                	jmp    7e <wc+0x7e>
      else if(!inword){
  6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  71:	75 0b                	jne    7e <wc+0x7e>
        w++;
  73:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  77:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  88:	7c a1                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  91:	00 
  92:	c7 44 24 04 c0 0c 00 	movl   $0xcc0,0x4(%esp)
  99:	00 
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 d0 03 00 00       	call   475 <read>
  a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ac:	0f 8f 70 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b6:	79 20                	jns    d8 <wc+0xd8>
    printf(1, "wc: read error\n");
  b8:	c7 44 24 04 d7 09 00 	movl   $0x9d7,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 39 05 00 00       	call   605 <printf>
    exit(-1);
  cc:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  d3:	e8 85 03 00 00       	call   45d <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	89 44 24 14          	mov    %eax,0x14(%esp)
  df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  f4:	c7 44 24 04 e7 09 00 	movl   $0x9e7,0x4(%esp)
  fb:	00 
  fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 103:	e8 fd 04 00 00       	call   605 <printf>
}
 108:	c9                   	leave  
 109:	c3                   	ret    

0000010a <main>:

int
main(int argc, char *argv[])
{
 10a:	55                   	push   %ebp
 10b:	89 e5                	mov    %esp,%ebp
 10d:	83 e4 f0             	and    $0xfffffff0,%esp
 110:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 113:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 117:	7f 20                	jg     139 <main+0x2f>
    wc(0, "");
 119:	c7 44 24 04 f4 09 00 	movl   $0x9f4,0x4(%esp)
 120:	00 
 121:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 128:	e8 d3 fe ff ff       	call   0 <wc>
    exit(0);
 12d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 134:	e8 24 03 00 00       	call   45d <exit>
  }

  for(i = 1; i < argc; i++){
 139:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 140:	00 
 141:	e9 96 00 00 00       	jmp    1dc <main+0xd2>
    if((fd = open(argv[i], 0)) < 0){
 146:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 14a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 151:	8b 45 0c             	mov    0xc(%ebp),%eax
 154:	01 d0                	add    %edx,%eax
 156:	8b 00                	mov    (%eax),%eax
 158:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 15f:	00 
 160:	89 04 24             	mov    %eax,(%esp)
 163:	e8 35 03 00 00       	call   49d <open>
 168:	89 44 24 18          	mov    %eax,0x18(%esp)
 16c:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 171:	79 36                	jns    1a9 <main+0x9f>
      printf(1, "wc: cannot open %s\n", argv[i]);
 173:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 177:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 17e:	8b 45 0c             	mov    0xc(%ebp),%eax
 181:	01 d0                	add    %edx,%eax
 183:	8b 00                	mov    (%eax),%eax
 185:	89 44 24 08          	mov    %eax,0x8(%esp)
 189:	c7 44 24 04 f5 09 00 	movl   $0x9f5,0x4(%esp)
 190:	00 
 191:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 198:	e8 68 04 00 00       	call   605 <printf>
      exit(-1);
 19d:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 1a4:	e8 b4 02 00 00       	call   45d <exit>
    }
    wc(fd, argv[i]);
 1a9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b7:	01 d0                	add    %edx,%eax
 1b9:	8b 00                	mov    (%eax),%eax
 1bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 1bf:	8b 44 24 18          	mov    0x18(%esp),%eax
 1c3:	89 04 24             	mov    %eax,(%esp)
 1c6:	e8 35 fe ff ff       	call   0 <wc>
    close(fd);
 1cb:	8b 44 24 18          	mov    0x18(%esp),%eax
 1cf:	89 04 24             	mov    %eax,(%esp)
 1d2:	e8 ae 02 00 00       	call   485 <close>
  if(argc <= 1){
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
 1d7:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1dc:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1e0:	3b 45 08             	cmp    0x8(%ebp),%eax
 1e3:	0f 8c 5d ff ff ff    	jl     146 <main+0x3c>
      exit(-1);
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit(0);
 1e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1f0:	e8 68 02 00 00       	call   45d <exit>

000001f5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1f5:	55                   	push   %ebp
 1f6:	89 e5                	mov    %esp,%ebp
 1f8:	57                   	push   %edi
 1f9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1fd:	8b 55 10             	mov    0x10(%ebp),%edx
 200:	8b 45 0c             	mov    0xc(%ebp),%eax
 203:	89 cb                	mov    %ecx,%ebx
 205:	89 df                	mov    %ebx,%edi
 207:	89 d1                	mov    %edx,%ecx
 209:	fc                   	cld    
 20a:	f3 aa                	rep stos %al,%es:(%edi)
 20c:	89 ca                	mov    %ecx,%edx
 20e:	89 fb                	mov    %edi,%ebx
 210:	89 5d 08             	mov    %ebx,0x8(%ebp)
 213:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 216:	5b                   	pop    %ebx
 217:	5f                   	pop    %edi
 218:	5d                   	pop    %ebp
 219:	c3                   	ret    

0000021a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 226:	90                   	nop
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	8d 50 01             	lea    0x1(%eax),%edx
 22d:	89 55 08             	mov    %edx,0x8(%ebp)
 230:	8b 55 0c             	mov    0xc(%ebp),%edx
 233:	8d 4a 01             	lea    0x1(%edx),%ecx
 236:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 239:	0f b6 12             	movzbl (%edx),%edx
 23c:	88 10                	mov    %dl,(%eax)
 23e:	0f b6 00             	movzbl (%eax),%eax
 241:	84 c0                	test   %al,%al
 243:	75 e2                	jne    227 <strcpy+0xd>
    ;
  return os;
 245:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 248:	c9                   	leave  
 249:	c3                   	ret    

0000024a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 24a:	55                   	push   %ebp
 24b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 24d:	eb 08                	jmp    257 <strcmp+0xd>
    p++, q++;
 24f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 253:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	0f b6 00             	movzbl (%eax),%eax
 25d:	84 c0                	test   %al,%al
 25f:	74 10                	je     271 <strcmp+0x27>
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 10             	movzbl (%eax),%edx
 267:	8b 45 0c             	mov    0xc(%ebp),%eax
 26a:	0f b6 00             	movzbl (%eax),%eax
 26d:	38 c2                	cmp    %al,%dl
 26f:	74 de                	je     24f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	0f b6 d0             	movzbl %al,%edx
 27a:	8b 45 0c             	mov    0xc(%ebp),%eax
 27d:	0f b6 00             	movzbl (%eax),%eax
 280:	0f b6 c0             	movzbl %al,%eax
 283:	29 c2                	sub    %eax,%edx
 285:	89 d0                	mov    %edx,%eax
}
 287:	5d                   	pop    %ebp
 288:	c3                   	ret    

00000289 <strlen>:

uint
strlen(char *s)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 28f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 296:	eb 04                	jmp    29c <strlen+0x13>
 298:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 29c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	01 d0                	add    %edx,%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	84 c0                	test   %al,%al
 2a9:	75 ed                	jne    298 <strlen+0xf>
    ;
  return n;
 2ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ae:	c9                   	leave  
 2af:	c3                   	ret    

000002b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2b6:	8b 45 10             	mov    0x10(%ebp),%eax
 2b9:	89 44 24 08          	mov    %eax,0x8(%esp)
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	89 04 24             	mov    %eax,(%esp)
 2ca:	e8 26 ff ff ff       	call   1f5 <stosb>
  return dst;
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <strchr>:

char*
strchr(const char *s, char c)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 04             	sub    $0x4,%esp
 2da:	8b 45 0c             	mov    0xc(%ebp),%eax
 2dd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2e0:	eb 14                	jmp    2f6 <strchr+0x22>
    if(*s == c)
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	0f b6 00             	movzbl (%eax),%eax
 2e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2eb:	75 05                	jne    2f2 <strchr+0x1e>
      return (char*)s;
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
 2f0:	eb 13                	jmp    305 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f6:	8b 45 08             	mov    0x8(%ebp),%eax
 2f9:	0f b6 00             	movzbl (%eax),%eax
 2fc:	84 c0                	test   %al,%al
 2fe:	75 e2                	jne    2e2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 300:	b8 00 00 00 00       	mov    $0x0,%eax
}
 305:	c9                   	leave  
 306:	c3                   	ret    

00000307 <gets>:

char*
gets(char *buf, int max)
{
 307:	55                   	push   %ebp
 308:	89 e5                	mov    %esp,%ebp
 30a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 30d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 314:	eb 4c                	jmp    362 <gets+0x5b>
    cc = read(0, &c, 1);
 316:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 31d:	00 
 31e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 321:	89 44 24 04          	mov    %eax,0x4(%esp)
 325:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 32c:	e8 44 01 00 00       	call   475 <read>
 331:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 334:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 338:	7f 02                	jg     33c <gets+0x35>
      break;
 33a:	eb 31                	jmp    36d <gets+0x66>
    buf[i++] = c;
 33c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33f:	8d 50 01             	lea    0x1(%eax),%edx
 342:	89 55 f4             	mov    %edx,-0xc(%ebp)
 345:	89 c2                	mov    %eax,%edx
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	01 c2                	add    %eax,%edx
 34c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 350:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 352:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 356:	3c 0a                	cmp    $0xa,%al
 358:	74 13                	je     36d <gets+0x66>
 35a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 35e:	3c 0d                	cmp    $0xd,%al
 360:	74 0b                	je     36d <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 362:	8b 45 f4             	mov    -0xc(%ebp),%eax
 365:	83 c0 01             	add    $0x1,%eax
 368:	3b 45 0c             	cmp    0xc(%ebp),%eax
 36b:	7c a9                	jl     316 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 36d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 370:	8b 45 08             	mov    0x8(%ebp),%eax
 373:	01 d0                	add    %edx,%eax
 375:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 378:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37b:	c9                   	leave  
 37c:	c3                   	ret    

0000037d <stat>:

int
stat(char *n, struct stat *st)
{
 37d:	55                   	push   %ebp
 37e:	89 e5                	mov    %esp,%ebp
 380:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 383:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 38a:	00 
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	89 04 24             	mov    %eax,(%esp)
 391:	e8 07 01 00 00       	call   49d <open>
 396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 39d:	79 07                	jns    3a6 <stat+0x29>
    return -1;
 39f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3a4:	eb 23                	jmp    3c9 <stat+0x4c>
  r = fstat(fd, st);
 3a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b0:	89 04 24             	mov    %eax,(%esp)
 3b3:	e8 fd 00 00 00       	call   4b5 <fstat>
 3b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3be:	89 04 24             	mov    %eax,(%esp)
 3c1:	e8 bf 00 00 00       	call   485 <close>
  return r;
 3c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3c9:	c9                   	leave  
 3ca:	c3                   	ret    

000003cb <atoi>:

int
atoi(const char *s)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3d8:	eb 25                	jmp    3ff <atoi+0x34>
    n = n*10 + *s++ - '0';
 3da:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3dd:	89 d0                	mov    %edx,%eax
 3df:	c1 e0 02             	shl    $0x2,%eax
 3e2:	01 d0                	add    %edx,%eax
 3e4:	01 c0                	add    %eax,%eax
 3e6:	89 c1                	mov    %eax,%ecx
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	8d 50 01             	lea    0x1(%eax),%edx
 3ee:	89 55 08             	mov    %edx,0x8(%ebp)
 3f1:	0f b6 00             	movzbl (%eax),%eax
 3f4:	0f be c0             	movsbl %al,%eax
 3f7:	01 c8                	add    %ecx,%eax
 3f9:	83 e8 30             	sub    $0x30,%eax
 3fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ff:	8b 45 08             	mov    0x8(%ebp),%eax
 402:	0f b6 00             	movzbl (%eax),%eax
 405:	3c 2f                	cmp    $0x2f,%al
 407:	7e 0a                	jle    413 <atoi+0x48>
 409:	8b 45 08             	mov    0x8(%ebp),%eax
 40c:	0f b6 00             	movzbl (%eax),%eax
 40f:	3c 39                	cmp    $0x39,%al
 411:	7e c7                	jle    3da <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 413:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 416:	c9                   	leave  
 417:	c3                   	ret    

00000418 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 41e:	8b 45 08             	mov    0x8(%ebp),%eax
 421:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 424:	8b 45 0c             	mov    0xc(%ebp),%eax
 427:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 42a:	eb 17                	jmp    443 <memmove+0x2b>
    *dst++ = *src++;
 42c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 42f:	8d 50 01             	lea    0x1(%eax),%edx
 432:	89 55 fc             	mov    %edx,-0x4(%ebp)
 435:	8b 55 f8             	mov    -0x8(%ebp),%edx
 438:	8d 4a 01             	lea    0x1(%edx),%ecx
 43b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 43e:	0f b6 12             	movzbl (%edx),%edx
 441:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 443:	8b 45 10             	mov    0x10(%ebp),%eax
 446:	8d 50 ff             	lea    -0x1(%eax),%edx
 449:	89 55 10             	mov    %edx,0x10(%ebp)
 44c:	85 c0                	test   %eax,%eax
 44e:	7f dc                	jg     42c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 450:	8b 45 08             	mov    0x8(%ebp),%eax
}
 453:	c9                   	leave  
 454:	c3                   	ret    

00000455 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 455:	b8 01 00 00 00       	mov    $0x1,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <exit>:
SYSCALL(exit)
 45d:	b8 02 00 00 00       	mov    $0x2,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <wait>:
SYSCALL(wait)
 465:	b8 03 00 00 00       	mov    $0x3,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <pipe>:
SYSCALL(pipe)
 46d:	b8 04 00 00 00       	mov    $0x4,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <read>:
SYSCALL(read)
 475:	b8 05 00 00 00       	mov    $0x5,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <write>:
SYSCALL(write)
 47d:	b8 10 00 00 00       	mov    $0x10,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <close>:
SYSCALL(close)
 485:	b8 15 00 00 00       	mov    $0x15,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <kill>:
SYSCALL(kill)
 48d:	b8 06 00 00 00       	mov    $0x6,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <exec>:
SYSCALL(exec)
 495:	b8 07 00 00 00       	mov    $0x7,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <open>:
SYSCALL(open)
 49d:	b8 0f 00 00 00       	mov    $0xf,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <mknod>:
SYSCALL(mknod)
 4a5:	b8 11 00 00 00       	mov    $0x11,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <unlink>:
SYSCALL(unlink)
 4ad:	b8 12 00 00 00       	mov    $0x12,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <fstat>:
SYSCALL(fstat)
 4b5:	b8 08 00 00 00       	mov    $0x8,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <link>:
SYSCALL(link)
 4bd:	b8 13 00 00 00       	mov    $0x13,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <mkdir>:
SYSCALL(mkdir)
 4c5:	b8 14 00 00 00       	mov    $0x14,%eax
 4ca:	cd 40                	int    $0x40
 4cc:	c3                   	ret    

000004cd <chdir>:
SYSCALL(chdir)
 4cd:	b8 09 00 00 00       	mov    $0x9,%eax
 4d2:	cd 40                	int    $0x40
 4d4:	c3                   	ret    

000004d5 <dup>:
SYSCALL(dup)
 4d5:	b8 0a 00 00 00       	mov    $0xa,%eax
 4da:	cd 40                	int    $0x40
 4dc:	c3                   	ret    

000004dd <getpid>:
SYSCALL(getpid)
 4dd:	b8 0b 00 00 00       	mov    $0xb,%eax
 4e2:	cd 40                	int    $0x40
 4e4:	c3                   	ret    

000004e5 <sbrk>:
SYSCALL(sbrk)
 4e5:	b8 0c 00 00 00       	mov    $0xc,%eax
 4ea:	cd 40                	int    $0x40
 4ec:	c3                   	ret    

000004ed <sleep>:
SYSCALL(sleep)
 4ed:	b8 0d 00 00 00       	mov    $0xd,%eax
 4f2:	cd 40                	int    $0x40
 4f4:	c3                   	ret    

000004f5 <uptime>:
SYSCALL(uptime)
 4f5:	b8 0e 00 00 00       	mov    $0xe,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <pstat>:
SYSCALL(pstat)
 4fd:	b8 16 00 00 00       	mov    $0x16,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <printjob>:
SYSCALL(printjob)
 505:	b8 17 00 00 00       	mov    $0x17,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <attachjob>:
SYSCALL(attachjob)
 50d:	b8 18 00 00 00       	mov    $0x18,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <fg>:
SYSCALL (fg)
 515:	b8 19 00 00 00       	mov    $0x19,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <waitpid>:
SYSCALL(waitpid)
 51d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 525:	55                   	push   %ebp
 526:	89 e5                	mov    %esp,%ebp
 528:	83 ec 18             	sub    $0x18,%esp
 52b:	8b 45 0c             	mov    0xc(%ebp),%eax
 52e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 531:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 538:	00 
 539:	8d 45 f4             	lea    -0xc(%ebp),%eax
 53c:	89 44 24 04          	mov    %eax,0x4(%esp)
 540:	8b 45 08             	mov    0x8(%ebp),%eax
 543:	89 04 24             	mov    %eax,(%esp)
 546:	e8 32 ff ff ff       	call   47d <write>
}
 54b:	c9                   	leave  
 54c:	c3                   	ret    

0000054d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 54d:	55                   	push   %ebp
 54e:	89 e5                	mov    %esp,%ebp
 550:	56                   	push   %esi
 551:	53                   	push   %ebx
 552:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 555:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 55c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 560:	74 17                	je     579 <printint+0x2c>
 562:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 566:	79 11                	jns    579 <printint+0x2c>
    neg = 1;
 568:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 56f:	8b 45 0c             	mov    0xc(%ebp),%eax
 572:	f7 d8                	neg    %eax
 574:	89 45 ec             	mov    %eax,-0x14(%ebp)
 577:	eb 06                	jmp    57f <printint+0x32>
  } else {
    x = xx;
 579:	8b 45 0c             	mov    0xc(%ebp),%eax
 57c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 57f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 586:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 589:	8d 41 01             	lea    0x1(%ecx),%eax
 58c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 58f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 592:	8b 45 ec             	mov    -0x14(%ebp),%eax
 595:	ba 00 00 00 00       	mov    $0x0,%edx
 59a:	f7 f3                	div    %ebx
 59c:	89 d0                	mov    %edx,%eax
 59e:	0f b6 80 74 0c 00 00 	movzbl 0xc74(%eax),%eax
 5a5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5a9:	8b 75 10             	mov    0x10(%ebp),%esi
 5ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5af:	ba 00 00 00 00       	mov    $0x0,%edx
 5b4:	f7 f6                	div    %esi
 5b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5bd:	75 c7                	jne    586 <printint+0x39>
  if(neg)
 5bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5c3:	74 10                	je     5d5 <printint+0x88>
    buf[i++] = '-';
 5c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c8:	8d 50 01             	lea    0x1(%eax),%edx
 5cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5ce:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5d3:	eb 1f                	jmp    5f4 <printint+0xa7>
 5d5:	eb 1d                	jmp    5f4 <printint+0xa7>
    putc(fd, buf[i]);
 5d7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5dd:	01 d0                	add    %edx,%eax
 5df:	0f b6 00             	movzbl (%eax),%eax
 5e2:	0f be c0             	movsbl %al,%eax
 5e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ec:	89 04 24             	mov    %eax,(%esp)
 5ef:	e8 31 ff ff ff       	call   525 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5f4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5fc:	79 d9                	jns    5d7 <printint+0x8a>
    putc(fd, buf[i]);
}
 5fe:	83 c4 30             	add    $0x30,%esp
 601:	5b                   	pop    %ebx
 602:	5e                   	pop    %esi
 603:	5d                   	pop    %ebp
 604:	c3                   	ret    

00000605 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 605:	55                   	push   %ebp
 606:	89 e5                	mov    %esp,%ebp
 608:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 60b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 612:	8d 45 0c             	lea    0xc(%ebp),%eax
 615:	83 c0 04             	add    $0x4,%eax
 618:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 61b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 622:	e9 7c 01 00 00       	jmp    7a3 <printf+0x19e>
    c = fmt[i] & 0xff;
 627:	8b 55 0c             	mov    0xc(%ebp),%edx
 62a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62d:	01 d0                	add    %edx,%eax
 62f:	0f b6 00             	movzbl (%eax),%eax
 632:	0f be c0             	movsbl %al,%eax
 635:	25 ff 00 00 00       	and    $0xff,%eax
 63a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 63d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 641:	75 2c                	jne    66f <printf+0x6a>
      if(c == '%'){
 643:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 647:	75 0c                	jne    655 <printf+0x50>
        state = '%';
 649:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 650:	e9 4a 01 00 00       	jmp    79f <printf+0x19a>
      } else {
        putc(fd, c);
 655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 658:	0f be c0             	movsbl %al,%eax
 65b:	89 44 24 04          	mov    %eax,0x4(%esp)
 65f:	8b 45 08             	mov    0x8(%ebp),%eax
 662:	89 04 24             	mov    %eax,(%esp)
 665:	e8 bb fe ff ff       	call   525 <putc>
 66a:	e9 30 01 00 00       	jmp    79f <printf+0x19a>
      }
    } else if(state == '%'){
 66f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 673:	0f 85 26 01 00 00    	jne    79f <printf+0x19a>
      if(c == 'd'){
 679:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 67d:	75 2d                	jne    6ac <printf+0xa7>
        printint(fd, *ap, 10, 1);
 67f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 68b:	00 
 68c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 693:	00 
 694:	89 44 24 04          	mov    %eax,0x4(%esp)
 698:	8b 45 08             	mov    0x8(%ebp),%eax
 69b:	89 04 24             	mov    %eax,(%esp)
 69e:	e8 aa fe ff ff       	call   54d <printint>
        ap++;
 6a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a7:	e9 ec 00 00 00       	jmp    798 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 6ac:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6b0:	74 06                	je     6b8 <printf+0xb3>
 6b2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6b6:	75 2d                	jne    6e5 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6bb:	8b 00                	mov    (%eax),%eax
 6bd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6c4:	00 
 6c5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6cc:	00 
 6cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d1:	8b 45 08             	mov    0x8(%ebp),%eax
 6d4:	89 04 24             	mov    %eax,(%esp)
 6d7:	e8 71 fe ff ff       	call   54d <printint>
        ap++;
 6dc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e0:	e9 b3 00 00 00       	jmp    798 <printf+0x193>
      } else if(c == 's'){
 6e5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6e9:	75 45                	jne    730 <printf+0x12b>
        s = (char*)*ap;
 6eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ee:	8b 00                	mov    (%eax),%eax
 6f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6fb:	75 09                	jne    706 <printf+0x101>
          s = "(null)";
 6fd:	c7 45 f4 09 0a 00 00 	movl   $0xa09,-0xc(%ebp)
        while(*s != 0){
 704:	eb 1e                	jmp    724 <printf+0x11f>
 706:	eb 1c                	jmp    724 <printf+0x11f>
          putc(fd, *s);
 708:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70b:	0f b6 00             	movzbl (%eax),%eax
 70e:	0f be c0             	movsbl %al,%eax
 711:	89 44 24 04          	mov    %eax,0x4(%esp)
 715:	8b 45 08             	mov    0x8(%ebp),%eax
 718:	89 04 24             	mov    %eax,(%esp)
 71b:	e8 05 fe ff ff       	call   525 <putc>
          s++;
 720:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 724:	8b 45 f4             	mov    -0xc(%ebp),%eax
 727:	0f b6 00             	movzbl (%eax),%eax
 72a:	84 c0                	test   %al,%al
 72c:	75 da                	jne    708 <printf+0x103>
 72e:	eb 68                	jmp    798 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 730:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 734:	75 1d                	jne    753 <printf+0x14e>
        putc(fd, *ap);
 736:	8b 45 e8             	mov    -0x18(%ebp),%eax
 739:	8b 00                	mov    (%eax),%eax
 73b:	0f be c0             	movsbl %al,%eax
 73e:	89 44 24 04          	mov    %eax,0x4(%esp)
 742:	8b 45 08             	mov    0x8(%ebp),%eax
 745:	89 04 24             	mov    %eax,(%esp)
 748:	e8 d8 fd ff ff       	call   525 <putc>
        ap++;
 74d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 751:	eb 45                	jmp    798 <printf+0x193>
      } else if(c == '%'){
 753:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 757:	75 17                	jne    770 <printf+0x16b>
        putc(fd, c);
 759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 75c:	0f be c0             	movsbl %al,%eax
 75f:	89 44 24 04          	mov    %eax,0x4(%esp)
 763:	8b 45 08             	mov    0x8(%ebp),%eax
 766:	89 04 24             	mov    %eax,(%esp)
 769:	e8 b7 fd ff ff       	call   525 <putc>
 76e:	eb 28                	jmp    798 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 770:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 777:	00 
 778:	8b 45 08             	mov    0x8(%ebp),%eax
 77b:	89 04 24             	mov    %eax,(%esp)
 77e:	e8 a2 fd ff ff       	call   525 <putc>
        putc(fd, c);
 783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 786:	0f be c0             	movsbl %al,%eax
 789:	89 44 24 04          	mov    %eax,0x4(%esp)
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	89 04 24             	mov    %eax,(%esp)
 793:	e8 8d fd ff ff       	call   525 <putc>
      }
      state = 0;
 798:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 79f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a9:	01 d0                	add    %edx,%eax
 7ab:	0f b6 00             	movzbl (%eax),%eax
 7ae:	84 c0                	test   %al,%al
 7b0:	0f 85 71 fe ff ff    	jne    627 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7b6:	c9                   	leave  
 7b7:	c3                   	ret    

000007b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b8:	55                   	push   %ebp
 7b9:	89 e5                	mov    %esp,%ebp
 7bb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7be:	8b 45 08             	mov    0x8(%ebp),%eax
 7c1:	83 e8 08             	sub    $0x8,%eax
 7c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c7:	a1 a8 0c 00 00       	mov    0xca8,%eax
 7cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7cf:	eb 24                	jmp    7f5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d9:	77 12                	ja     7ed <free+0x35>
 7db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e1:	77 24                	ja     807 <free+0x4f>
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7eb:	77 1a                	ja     807 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7fb:	76 d4                	jbe    7d1 <free+0x19>
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 805:	76 ca                	jbe    7d1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 807:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80a:	8b 40 04             	mov    0x4(%eax),%eax
 80d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 814:	8b 45 f8             	mov    -0x8(%ebp),%eax
 817:	01 c2                	add    %eax,%edx
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	39 c2                	cmp    %eax,%edx
 820:	75 24                	jne    846 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 822:	8b 45 f8             	mov    -0x8(%ebp),%eax
 825:	8b 50 04             	mov    0x4(%eax),%edx
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	8b 00                	mov    (%eax),%eax
 82d:	8b 40 04             	mov    0x4(%eax),%eax
 830:	01 c2                	add    %eax,%edx
 832:	8b 45 f8             	mov    -0x8(%ebp),%eax
 835:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 838:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	8b 10                	mov    (%eax),%edx
 83f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 842:	89 10                	mov    %edx,(%eax)
 844:	eb 0a                	jmp    850 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	8b 10                	mov    (%eax),%edx
 84b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	8b 40 04             	mov    0x4(%eax),%eax
 856:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 85d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 860:	01 d0                	add    %edx,%eax
 862:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 865:	75 20                	jne    887 <free+0xcf>
    p->s.size += bp->s.size;
 867:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86a:	8b 50 04             	mov    0x4(%eax),%edx
 86d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 870:	8b 40 04             	mov    0x4(%eax),%eax
 873:	01 c2                	add    %eax,%edx
 875:	8b 45 fc             	mov    -0x4(%ebp),%eax
 878:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 87b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87e:	8b 10                	mov    (%eax),%edx
 880:	8b 45 fc             	mov    -0x4(%ebp),%eax
 883:	89 10                	mov    %edx,(%eax)
 885:	eb 08                	jmp    88f <free+0xd7>
  } else
    p->s.ptr = bp;
 887:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 88d:	89 10                	mov    %edx,(%eax)
  freep = p;
 88f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 892:	a3 a8 0c 00 00       	mov    %eax,0xca8
}
 897:	c9                   	leave  
 898:	c3                   	ret    

00000899 <morecore>:

static Header*
morecore(uint nu)
{
 899:	55                   	push   %ebp
 89a:	89 e5                	mov    %esp,%ebp
 89c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 89f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8a6:	77 07                	ja     8af <morecore+0x16>
    nu = 4096;
 8a8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8af:	8b 45 08             	mov    0x8(%ebp),%eax
 8b2:	c1 e0 03             	shl    $0x3,%eax
 8b5:	89 04 24             	mov    %eax,(%esp)
 8b8:	e8 28 fc ff ff       	call   4e5 <sbrk>
 8bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8c0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8c4:	75 07                	jne    8cd <morecore+0x34>
    return 0;
 8c6:	b8 00 00 00 00       	mov    $0x0,%eax
 8cb:	eb 22                	jmp    8ef <morecore+0x56>
  hp = (Header*)p;
 8cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d6:	8b 55 08             	mov    0x8(%ebp),%edx
 8d9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8df:	83 c0 08             	add    $0x8,%eax
 8e2:	89 04 24             	mov    %eax,(%esp)
 8e5:	e8 ce fe ff ff       	call   7b8 <free>
  return freep;
 8ea:	a1 a8 0c 00 00       	mov    0xca8,%eax
}
 8ef:	c9                   	leave  
 8f0:	c3                   	ret    

000008f1 <malloc>:

void*
malloc(uint nbytes)
{
 8f1:	55                   	push   %ebp
 8f2:	89 e5                	mov    %esp,%ebp
 8f4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f7:	8b 45 08             	mov    0x8(%ebp),%eax
 8fa:	83 c0 07             	add    $0x7,%eax
 8fd:	c1 e8 03             	shr    $0x3,%eax
 900:	83 c0 01             	add    $0x1,%eax
 903:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 906:	a1 a8 0c 00 00       	mov    0xca8,%eax
 90b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 912:	75 23                	jne    937 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 914:	c7 45 f0 a0 0c 00 00 	movl   $0xca0,-0x10(%ebp)
 91b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91e:	a3 a8 0c 00 00       	mov    %eax,0xca8
 923:	a1 a8 0c 00 00       	mov    0xca8,%eax
 928:	a3 a0 0c 00 00       	mov    %eax,0xca0
    base.s.size = 0;
 92d:	c7 05 a4 0c 00 00 00 	movl   $0x0,0xca4
 934:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 937:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93a:	8b 00                	mov    (%eax),%eax
 93c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 93f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 942:	8b 40 04             	mov    0x4(%eax),%eax
 945:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 948:	72 4d                	jb     997 <malloc+0xa6>
      if(p->s.size == nunits)
 94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94d:	8b 40 04             	mov    0x4(%eax),%eax
 950:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 953:	75 0c                	jne    961 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	8b 10                	mov    (%eax),%edx
 95a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95d:	89 10                	mov    %edx,(%eax)
 95f:	eb 26                	jmp    987 <malloc+0x96>
      else {
        p->s.size -= nunits;
 961:	8b 45 f4             	mov    -0xc(%ebp),%eax
 964:	8b 40 04             	mov    0x4(%eax),%eax
 967:	2b 45 ec             	sub    -0x14(%ebp),%eax
 96a:	89 c2                	mov    %eax,%edx
 96c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 972:	8b 45 f4             	mov    -0xc(%ebp),%eax
 975:	8b 40 04             	mov    0x4(%eax),%eax
 978:	c1 e0 03             	shl    $0x3,%eax
 97b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 97e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 981:	8b 55 ec             	mov    -0x14(%ebp),%edx
 984:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 987:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98a:	a3 a8 0c 00 00       	mov    %eax,0xca8
      return (void*)(p + 1);
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	83 c0 08             	add    $0x8,%eax
 995:	eb 38                	jmp    9cf <malloc+0xde>
    }
    if(p == freep)
 997:	a1 a8 0c 00 00       	mov    0xca8,%eax
 99c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 99f:	75 1b                	jne    9bc <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9a4:	89 04 24             	mov    %eax,(%esp)
 9a7:	e8 ed fe ff ff       	call   899 <morecore>
 9ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9b3:	75 07                	jne    9bc <malloc+0xcb>
        return 0;
 9b5:	b8 00 00 00 00       	mov    $0x0,%eax
 9ba:	eb 13                	jmp    9cf <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c5:	8b 00                	mov    (%eax),%eax
 9c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9ca:	e9 70 ff ff ff       	jmp    93f <malloc+0x4e>
}
 9cf:	c9                   	leave  
 9d0:	c3                   	ret    
