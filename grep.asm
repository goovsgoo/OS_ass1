
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 bb 00 00 00       	jmp    cd <grep+0xcd>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 a0 0e 00 00 	movl   $0xea0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 51                	jmp    72 <grep+0x72>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  2e:	8b 45 08             	mov    0x8(%ebp),%eax
  31:	89 04 24             	mov    %eax,(%esp)
  34:	e8 d8 01 00 00       	call   211 <match>
  39:	85 c0                	test   %eax,%eax
  3b:	74 2c                	je     69 <grep+0x69>
        *q = '\n';
  3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  46:	83 c0 01             	add    $0x1,%eax
  49:	89 c2                	mov    %eax,%edx
  4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4e:	29 c2                	sub    %eax,%edx
  50:	89 d0                	mov    %edx,%eax
  52:	89 44 24 08          	mov    %eax,0x8(%esp)
  56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  59:	89 44 24 04          	mov    %eax,0x4(%esp)
  5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  64:	e8 90 05 00 00       	call   5f9 <write>
      }
      p = q+1;
  69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6c:	83 c0 01             	add    $0x1,%eax
  6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  72:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  79:	00 
  7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7d:	89 04 24             	mov    %eax,(%esp)
  80:	e8 cb 03 00 00       	call   450 <strchr>
  85:	89 45 e8             	mov    %eax,-0x18(%ebp)
  88:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8c:	75 93                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8e:	81 7d f0 a0 0e 00 00 	cmpl   $0xea0,-0x10(%ebp)
  95:	75 07                	jne    9e <grep+0x9e>
      m = 0;
  97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	7e 29                	jle    cd <grep+0xcd>
      m -= p - buf;
  a4:	ba a0 0e 00 00       	mov    $0xea0,%edx
  a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ac:	29 c2                	sub    %eax,%edx
  ae:	89 d0                	mov    %edx,%eax
  b0:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  c1:	c7 04 24 a0 0e 00 00 	movl   $0xea0,(%esp)
  c8:	e8 c7 04 00 00       	call   594 <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d0:	ba 00 04 00 00       	mov    $0x400,%edx
  d5:	29 c2                	sub    %eax,%edx
  d7:	89 d0                	mov    %edx,%eax
  d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  dc:	81 c2 a0 0e 00 00    	add    $0xea0,%edx
  e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	89 04 24             	mov    %eax,(%esp)
  f0:	e8 fc 04 00 00       	call   5f1 <read>
  f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  fc:	0f 8f 10 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 102:	c9                   	leave  
 103:	c3                   	ret    

00000104 <main>:

int
main(int argc, char *argv[])
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	83 e4 f0             	and    $0xfffffff0,%esp
 10a:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 10d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 111:	7f 20                	jg     133 <main+0x2f>
    printf(2, "usage: grep pattern [file ...]\n");
 113:	c7 44 24 04 50 0b 00 	movl   $0xb50,0x4(%esp)
 11a:	00 
 11b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 122:	e8 5a 06 00 00       	call   781 <printf>
    exit(0);
 127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 12e:	e8 a6 04 00 00       	call   5d9 <exit>
  }
  pattern = argv[1];
 133:	8b 45 0c             	mov    0xc(%ebp),%eax
 136:	8b 40 04             	mov    0x4(%eax),%eax
 139:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 13d:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 141:	7f 20                	jg     163 <main+0x5f>
    grep(pattern, 0);
 143:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 14a:	00 
 14b:	8b 44 24 18          	mov    0x18(%esp),%eax
 14f:	89 04 24             	mov    %eax,(%esp)
 152:	e8 a9 fe ff ff       	call   0 <grep>
    exit(0);
 157:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15e:	e8 76 04 00 00       	call   5d9 <exit>
  }

  for(i = 2; i < argc; i++){
 163:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 16a:	00 
 16b:	e9 88 00 00 00       	jmp    1f8 <main+0xf4>
    if((fd = open(argv[i], 0)) < 0){
 170:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 17b:	8b 45 0c             	mov    0xc(%ebp),%eax
 17e:	01 d0                	add    %edx,%eax
 180:	8b 00                	mov    (%eax),%eax
 182:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 189:	00 
 18a:	89 04 24             	mov    %eax,(%esp)
 18d:	e8 87 04 00 00       	call   619 <open>
 192:	89 44 24 14          	mov    %eax,0x14(%esp)
 196:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 19b:	79 36                	jns    1d3 <main+0xcf>
      printf(1, "grep: cannot open %s\n", argv[i]);
 19d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ab:	01 d0                	add    %edx,%eax
 1ad:	8b 00                	mov    (%eax),%eax
 1af:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b3:	c7 44 24 04 70 0b 00 	movl   $0xb70,0x4(%esp)
 1ba:	00 
 1bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c2:	e8 ba 05 00 00       	call   781 <printf>
      exit(-1);
 1c7:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 1ce:	e8 06 04 00 00       	call   5d9 <exit>
    }
    grep(pattern, fd);
 1d3:	8b 44 24 14          	mov    0x14(%esp),%eax
 1d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1db:	8b 44 24 18          	mov    0x18(%esp),%eax
 1df:	89 04 24             	mov    %eax,(%esp)
 1e2:	e8 19 fe ff ff       	call   0 <grep>
    close(fd);
 1e7:	8b 44 24 14          	mov    0x14(%esp),%eax
 1eb:	89 04 24             	mov    %eax,(%esp)
 1ee:	e8 0e 04 00 00       	call   601 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit(0);
  }

  for(i = 2; i < argc; i++){
 1f3:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1f8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1fc:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ff:	0f 8c 6b ff ff ff    	jl     170 <main+0x6c>
      exit(-1);
    }
    grep(pattern, fd);
    close(fd);
  }
  exit(0);
 205:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 20c:	e8 c8 03 00 00       	call   5d9 <exit>

00000211 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 211:	55                   	push   %ebp
 212:	89 e5                	mov    %esp,%ebp
 214:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	0f b6 00             	movzbl (%eax),%eax
 21d:	3c 5e                	cmp    $0x5e,%al
 21f:	75 17                	jne    238 <match+0x27>
    return matchhere(re+1, text);
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	8d 50 01             	lea    0x1(%eax),%edx
 227:	8b 45 0c             	mov    0xc(%ebp),%eax
 22a:	89 44 24 04          	mov    %eax,0x4(%esp)
 22e:	89 14 24             	mov    %edx,(%esp)
 231:	e8 36 00 00 00       	call   26c <matchhere>
 236:	eb 32                	jmp    26a <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
 238:	8b 45 0c             	mov    0xc(%ebp),%eax
 23b:	89 44 24 04          	mov    %eax,0x4(%esp)
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	89 04 24             	mov    %eax,(%esp)
 245:	e8 22 00 00 00       	call   26c <matchhere>
 24a:	85 c0                	test   %eax,%eax
 24c:	74 07                	je     255 <match+0x44>
      return 1;
 24e:	b8 01 00 00 00       	mov    $0x1,%eax
 253:	eb 15                	jmp    26a <match+0x59>
  }while(*text++ != '\0');
 255:	8b 45 0c             	mov    0xc(%ebp),%eax
 258:	8d 50 01             	lea    0x1(%eax),%edx
 25b:	89 55 0c             	mov    %edx,0xc(%ebp)
 25e:	0f b6 00             	movzbl (%eax),%eax
 261:	84 c0                	test   %al,%al
 263:	75 d3                	jne    238 <match+0x27>
  return 0;
 265:	b8 00 00 00 00       	mov    $0x0,%eax
}
 26a:	c9                   	leave  
 26b:	c3                   	ret    

0000026c <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 26c:	55                   	push   %ebp
 26d:	89 e5                	mov    %esp,%ebp
 26f:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	84 c0                	test   %al,%al
 27a:	75 0a                	jne    286 <matchhere+0x1a>
    return 1;
 27c:	b8 01 00 00 00       	mov    $0x1,%eax
 281:	e9 9b 00 00 00       	jmp    321 <matchhere+0xb5>
  if(re[1] == '*')
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 2a                	cmp    $0x2a,%al
 291:	75 24                	jne    2b7 <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	8d 48 02             	lea    0x2(%eax),%ecx
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	0f b6 00             	movzbl (%eax),%eax
 29f:	0f be c0             	movsbl %al,%eax
 2a2:	8b 55 0c             	mov    0xc(%ebp),%edx
 2a5:	89 54 24 08          	mov    %edx,0x8(%esp)
 2a9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 2ad:	89 04 24             	mov    %eax,(%esp)
 2b0:	e8 6e 00 00 00       	call   323 <matchstar>
 2b5:	eb 6a                	jmp    321 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 00             	movzbl (%eax),%eax
 2bd:	3c 24                	cmp    $0x24,%al
 2bf:	75 1d                	jne    2de <matchhere+0x72>
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
 2c4:	83 c0 01             	add    $0x1,%eax
 2c7:	0f b6 00             	movzbl (%eax),%eax
 2ca:	84 c0                	test   %al,%al
 2cc:	75 10                	jne    2de <matchhere+0x72>
    return *text == '\0';
 2ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d1:	0f b6 00             	movzbl (%eax),%eax
 2d4:	84 c0                	test   %al,%al
 2d6:	0f 94 c0             	sete   %al
 2d9:	0f b6 c0             	movzbl %al,%eax
 2dc:	eb 43                	jmp    321 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2de:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e1:	0f b6 00             	movzbl (%eax),%eax
 2e4:	84 c0                	test   %al,%al
 2e6:	74 34                	je     31c <matchhere+0xb0>
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	0f b6 00             	movzbl (%eax),%eax
 2ee:	3c 2e                	cmp    $0x2e,%al
 2f0:	74 10                	je     302 <matchhere+0x96>
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	0f b6 10             	movzbl (%eax),%edx
 2f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fb:	0f b6 00             	movzbl (%eax),%eax
 2fe:	38 c2                	cmp    %al,%dl
 300:	75 1a                	jne    31c <matchhere+0xb0>
    return matchhere(re+1, text+1);
 302:	8b 45 0c             	mov    0xc(%ebp),%eax
 305:	8d 50 01             	lea    0x1(%eax),%edx
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	83 c0 01             	add    $0x1,%eax
 30e:	89 54 24 04          	mov    %edx,0x4(%esp)
 312:	89 04 24             	mov    %eax,(%esp)
 315:	e8 52 ff ff ff       	call   26c <matchhere>
 31a:	eb 05                	jmp    321 <matchhere+0xb5>
  return 0;
 31c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 321:	c9                   	leave  
 322:	c3                   	ret    

00000323 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 323:	55                   	push   %ebp
 324:	89 e5                	mov    %esp,%ebp
 326:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 329:	8b 45 10             	mov    0x10(%ebp),%eax
 32c:	89 44 24 04          	mov    %eax,0x4(%esp)
 330:	8b 45 0c             	mov    0xc(%ebp),%eax
 333:	89 04 24             	mov    %eax,(%esp)
 336:	e8 31 ff ff ff       	call   26c <matchhere>
 33b:	85 c0                	test   %eax,%eax
 33d:	74 07                	je     346 <matchstar+0x23>
      return 1;
 33f:	b8 01 00 00 00       	mov    $0x1,%eax
 344:	eb 29                	jmp    36f <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
 346:	8b 45 10             	mov    0x10(%ebp),%eax
 349:	0f b6 00             	movzbl (%eax),%eax
 34c:	84 c0                	test   %al,%al
 34e:	74 1a                	je     36a <matchstar+0x47>
 350:	8b 45 10             	mov    0x10(%ebp),%eax
 353:	8d 50 01             	lea    0x1(%eax),%edx
 356:	89 55 10             	mov    %edx,0x10(%ebp)
 359:	0f b6 00             	movzbl (%eax),%eax
 35c:	0f be c0             	movsbl %al,%eax
 35f:	3b 45 08             	cmp    0x8(%ebp),%eax
 362:	74 c5                	je     329 <matchstar+0x6>
 364:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 368:	74 bf                	je     329 <matchstar+0x6>
  return 0;
 36a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 36f:	c9                   	leave  
 370:	c3                   	ret    

00000371 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 371:	55                   	push   %ebp
 372:	89 e5                	mov    %esp,%ebp
 374:	57                   	push   %edi
 375:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 376:	8b 4d 08             	mov    0x8(%ebp),%ecx
 379:	8b 55 10             	mov    0x10(%ebp),%edx
 37c:	8b 45 0c             	mov    0xc(%ebp),%eax
 37f:	89 cb                	mov    %ecx,%ebx
 381:	89 df                	mov    %ebx,%edi
 383:	89 d1                	mov    %edx,%ecx
 385:	fc                   	cld    
 386:	f3 aa                	rep stos %al,%es:(%edi)
 388:	89 ca                	mov    %ecx,%edx
 38a:	89 fb                	mov    %edi,%ebx
 38c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 38f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 392:	5b                   	pop    %ebx
 393:	5f                   	pop    %edi
 394:	5d                   	pop    %ebp
 395:	c3                   	ret    

00000396 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 396:	55                   	push   %ebp
 397:	89 e5                	mov    %esp,%ebp
 399:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3a2:	90                   	nop
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	8d 50 01             	lea    0x1(%eax),%edx
 3a9:	89 55 08             	mov    %edx,0x8(%ebp)
 3ac:	8b 55 0c             	mov    0xc(%ebp),%edx
 3af:	8d 4a 01             	lea    0x1(%edx),%ecx
 3b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3b5:	0f b6 12             	movzbl (%edx),%edx
 3b8:	88 10                	mov    %dl,(%eax)
 3ba:	0f b6 00             	movzbl (%eax),%eax
 3bd:	84 c0                	test   %al,%al
 3bf:	75 e2                	jne    3a3 <strcpy+0xd>
    ;
  return os;
 3c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3c4:	c9                   	leave  
 3c5:	c3                   	ret    

000003c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c6:	55                   	push   %ebp
 3c7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3c9:	eb 08                	jmp    3d3 <strcmp+0xd>
    p++, q++;
 3cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3cf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	84 c0                	test   %al,%al
 3db:	74 10                	je     3ed <strcmp+0x27>
 3dd:	8b 45 08             	mov    0x8(%ebp),%eax
 3e0:	0f b6 10             	movzbl (%eax),%edx
 3e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	38 c2                	cmp    %al,%dl
 3eb:	74 de                	je     3cb <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
 3f0:	0f b6 00             	movzbl (%eax),%eax
 3f3:	0f b6 d0             	movzbl %al,%edx
 3f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f9:	0f b6 00             	movzbl (%eax),%eax
 3fc:	0f b6 c0             	movzbl %al,%eax
 3ff:	29 c2                	sub    %eax,%edx
 401:	89 d0                	mov    %edx,%eax
}
 403:	5d                   	pop    %ebp
 404:	c3                   	ret    

00000405 <strlen>:

uint
strlen(char *s)
{
 405:	55                   	push   %ebp
 406:	89 e5                	mov    %esp,%ebp
 408:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 40b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 412:	eb 04                	jmp    418 <strlen+0x13>
 414:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 418:	8b 55 fc             	mov    -0x4(%ebp),%edx
 41b:	8b 45 08             	mov    0x8(%ebp),%eax
 41e:	01 d0                	add    %edx,%eax
 420:	0f b6 00             	movzbl (%eax),%eax
 423:	84 c0                	test   %al,%al
 425:	75 ed                	jne    414 <strlen+0xf>
    ;
  return n;
 427:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 42a:	c9                   	leave  
 42b:	c3                   	ret    

0000042c <memset>:

void*
memset(void *dst, int c, uint n)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 432:	8b 45 10             	mov    0x10(%ebp),%eax
 435:	89 44 24 08          	mov    %eax,0x8(%esp)
 439:	8b 45 0c             	mov    0xc(%ebp),%eax
 43c:	89 44 24 04          	mov    %eax,0x4(%esp)
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	89 04 24             	mov    %eax,(%esp)
 446:	e8 26 ff ff ff       	call   371 <stosb>
  return dst;
 44b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 44e:	c9                   	leave  
 44f:	c3                   	ret    

00000450 <strchr>:

char*
strchr(const char *s, char c)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	83 ec 04             	sub    $0x4,%esp
 456:	8b 45 0c             	mov    0xc(%ebp),%eax
 459:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 45c:	eb 14                	jmp    472 <strchr+0x22>
    if(*s == c)
 45e:	8b 45 08             	mov    0x8(%ebp),%eax
 461:	0f b6 00             	movzbl (%eax),%eax
 464:	3a 45 fc             	cmp    -0x4(%ebp),%al
 467:	75 05                	jne    46e <strchr+0x1e>
      return (char*)s;
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	eb 13                	jmp    481 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 46e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 472:	8b 45 08             	mov    0x8(%ebp),%eax
 475:	0f b6 00             	movzbl (%eax),%eax
 478:	84 c0                	test   %al,%al
 47a:	75 e2                	jne    45e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 47c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 481:	c9                   	leave  
 482:	c3                   	ret    

00000483 <gets>:

char*
gets(char *buf, int max)
{
 483:	55                   	push   %ebp
 484:	89 e5                	mov    %esp,%ebp
 486:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 489:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 490:	eb 4c                	jmp    4de <gets+0x5b>
    cc = read(0, &c, 1);
 492:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 499:	00 
 49a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 49d:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4a8:	e8 44 01 00 00       	call   5f1 <read>
 4ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b4:	7f 02                	jg     4b8 <gets+0x35>
      break;
 4b6:	eb 31                	jmp    4e9 <gets+0x66>
    buf[i++] = c;
 4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bb:	8d 50 01             	lea    0x1(%eax),%edx
 4be:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c1:	89 c2                	mov    %eax,%edx
 4c3:	8b 45 08             	mov    0x8(%ebp),%eax
 4c6:	01 c2                	add    %eax,%edx
 4c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4cc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4ce:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4d2:	3c 0a                	cmp    $0xa,%al
 4d4:	74 13                	je     4e9 <gets+0x66>
 4d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4da:	3c 0d                	cmp    $0xd,%al
 4dc:	74 0b                	je     4e9 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e1:	83 c0 01             	add    $0x1,%eax
 4e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4e7:	7c a9                	jl     492 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4ec:	8b 45 08             	mov    0x8(%ebp),%eax
 4ef:	01 d0                	add    %edx,%eax
 4f1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4f7:	c9                   	leave  
 4f8:	c3                   	ret    

000004f9 <stat>:

int
stat(char *n, struct stat *st)
{
 4f9:	55                   	push   %ebp
 4fa:	89 e5                	mov    %esp,%ebp
 4fc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 506:	00 
 507:	8b 45 08             	mov    0x8(%ebp),%eax
 50a:	89 04 24             	mov    %eax,(%esp)
 50d:	e8 07 01 00 00       	call   619 <open>
 512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 519:	79 07                	jns    522 <stat+0x29>
    return -1;
 51b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 520:	eb 23                	jmp    545 <stat+0x4c>
  r = fstat(fd, st);
 522:	8b 45 0c             	mov    0xc(%ebp),%eax
 525:	89 44 24 04          	mov    %eax,0x4(%esp)
 529:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52c:	89 04 24             	mov    %eax,(%esp)
 52f:	e8 fd 00 00 00       	call   631 <fstat>
 534:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 537:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53a:	89 04 24             	mov    %eax,(%esp)
 53d:	e8 bf 00 00 00       	call   601 <close>
  return r;
 542:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 545:	c9                   	leave  
 546:	c3                   	ret    

00000547 <atoi>:

int
atoi(const char *s)
{
 547:	55                   	push   %ebp
 548:	89 e5                	mov    %esp,%ebp
 54a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 54d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 554:	eb 25                	jmp    57b <atoi+0x34>
    n = n*10 + *s++ - '0';
 556:	8b 55 fc             	mov    -0x4(%ebp),%edx
 559:	89 d0                	mov    %edx,%eax
 55b:	c1 e0 02             	shl    $0x2,%eax
 55e:	01 d0                	add    %edx,%eax
 560:	01 c0                	add    %eax,%eax
 562:	89 c1                	mov    %eax,%ecx
 564:	8b 45 08             	mov    0x8(%ebp),%eax
 567:	8d 50 01             	lea    0x1(%eax),%edx
 56a:	89 55 08             	mov    %edx,0x8(%ebp)
 56d:	0f b6 00             	movzbl (%eax),%eax
 570:	0f be c0             	movsbl %al,%eax
 573:	01 c8                	add    %ecx,%eax
 575:	83 e8 30             	sub    $0x30,%eax
 578:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 57b:	8b 45 08             	mov    0x8(%ebp),%eax
 57e:	0f b6 00             	movzbl (%eax),%eax
 581:	3c 2f                	cmp    $0x2f,%al
 583:	7e 0a                	jle    58f <atoi+0x48>
 585:	8b 45 08             	mov    0x8(%ebp),%eax
 588:	0f b6 00             	movzbl (%eax),%eax
 58b:	3c 39                	cmp    $0x39,%al
 58d:	7e c7                	jle    556 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 58f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 592:	c9                   	leave  
 593:	c3                   	ret    

00000594 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 594:	55                   	push   %ebp
 595:	89 e5                	mov    %esp,%ebp
 597:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 59a:	8b 45 08             	mov    0x8(%ebp),%eax
 59d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5a6:	eb 17                	jmp    5bf <memmove+0x2b>
    *dst++ = *src++;
 5a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ab:	8d 50 01             	lea    0x1(%eax),%edx
 5ae:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5b1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5b4:	8d 4a 01             	lea    0x1(%edx),%ecx
 5b7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5ba:	0f b6 12             	movzbl (%edx),%edx
 5bd:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5bf:	8b 45 10             	mov    0x10(%ebp),%eax
 5c2:	8d 50 ff             	lea    -0x1(%eax),%edx
 5c5:	89 55 10             	mov    %edx,0x10(%ebp)
 5c8:	85 c0                	test   %eax,%eax
 5ca:	7f dc                	jg     5a8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5cf:	c9                   	leave  
 5d0:	c3                   	ret    

000005d1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5d1:	b8 01 00 00 00       	mov    $0x1,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <exit>:
SYSCALL(exit)
 5d9:	b8 02 00 00 00       	mov    $0x2,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <wait>:
SYSCALL(wait)
 5e1:	b8 03 00 00 00       	mov    $0x3,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <pipe>:
SYSCALL(pipe)
 5e9:	b8 04 00 00 00       	mov    $0x4,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <read>:
SYSCALL(read)
 5f1:	b8 05 00 00 00       	mov    $0x5,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <write>:
SYSCALL(write)
 5f9:	b8 10 00 00 00       	mov    $0x10,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <close>:
SYSCALL(close)
 601:	b8 15 00 00 00       	mov    $0x15,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <kill>:
SYSCALL(kill)
 609:	b8 06 00 00 00       	mov    $0x6,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <exec>:
SYSCALL(exec)
 611:	b8 07 00 00 00       	mov    $0x7,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <open>:
SYSCALL(open)
 619:	b8 0f 00 00 00       	mov    $0xf,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <mknod>:
SYSCALL(mknod)
 621:	b8 11 00 00 00       	mov    $0x11,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <unlink>:
SYSCALL(unlink)
 629:	b8 12 00 00 00       	mov    $0x12,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <fstat>:
SYSCALL(fstat)
 631:	b8 08 00 00 00       	mov    $0x8,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <link>:
SYSCALL(link)
 639:	b8 13 00 00 00       	mov    $0x13,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <mkdir>:
SYSCALL(mkdir)
 641:	b8 14 00 00 00       	mov    $0x14,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <chdir>:
SYSCALL(chdir)
 649:	b8 09 00 00 00       	mov    $0x9,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <dup>:
SYSCALL(dup)
 651:	b8 0a 00 00 00       	mov    $0xa,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <getpid>:
SYSCALL(getpid)
 659:	b8 0b 00 00 00       	mov    $0xb,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <sbrk>:
SYSCALL(sbrk)
 661:	b8 0c 00 00 00       	mov    $0xc,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <sleep>:
SYSCALL(sleep)
 669:	b8 0d 00 00 00       	mov    $0xd,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <uptime>:
SYSCALL(uptime)
 671:	b8 0e 00 00 00       	mov    $0xe,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <pstat>:
SYSCALL(pstat)
 679:	b8 16 00 00 00       	mov    $0x16,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <printjob>:
SYSCALL(printjob)
 681:	b8 17 00 00 00       	mov    $0x17,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <attachjob>:
SYSCALL(attachjob)
 689:	b8 18 00 00 00       	mov    $0x18,%eax
 68e:	cd 40                	int    $0x40
 690:	c3                   	ret    

00000691 <fg>:
SYSCALL (fg)
 691:	b8 19 00 00 00       	mov    $0x19,%eax
 696:	cd 40                	int    $0x40
 698:	c3                   	ret    

00000699 <waitpid>:
SYSCALL(waitpid)
 699:	b8 1a 00 00 00       	mov    $0x1a,%eax
 69e:	cd 40                	int    $0x40
 6a0:	c3                   	ret    

000006a1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6a1:	55                   	push   %ebp
 6a2:	89 e5                	mov    %esp,%ebp
 6a4:	83 ec 18             	sub    $0x18,%esp
 6a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 6aa:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6ad:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6b4:	00 
 6b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bc:	8b 45 08             	mov    0x8(%ebp),%eax
 6bf:	89 04 24             	mov    %eax,(%esp)
 6c2:	e8 32 ff ff ff       	call   5f9 <write>
}
 6c7:	c9                   	leave  
 6c8:	c3                   	ret    

000006c9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6c9:	55                   	push   %ebp
 6ca:	89 e5                	mov    %esp,%ebp
 6cc:	56                   	push   %esi
 6cd:	53                   	push   %ebx
 6ce:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6d8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6dc:	74 17                	je     6f5 <printint+0x2c>
 6de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6e2:	79 11                	jns    6f5 <printint+0x2c>
    neg = 1;
 6e4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ee:	f7 d8                	neg    %eax
 6f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6f3:	eb 06                	jmp    6fb <printint+0x32>
  } else {
    x = xx;
 6f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 702:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 705:	8d 41 01             	lea    0x1(%ecx),%eax
 708:	89 45 f4             	mov    %eax,-0xc(%ebp)
 70b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 70e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 711:	ba 00 00 00 00       	mov    $0x0,%edx
 716:	f7 f3                	div    %ebx
 718:	89 d0                	mov    %edx,%eax
 71a:	0f b6 80 54 0e 00 00 	movzbl 0xe54(%eax),%eax
 721:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 725:	8b 75 10             	mov    0x10(%ebp),%esi
 728:	8b 45 ec             	mov    -0x14(%ebp),%eax
 72b:	ba 00 00 00 00       	mov    $0x0,%edx
 730:	f7 f6                	div    %esi
 732:	89 45 ec             	mov    %eax,-0x14(%ebp)
 735:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 739:	75 c7                	jne    702 <printint+0x39>
  if(neg)
 73b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 73f:	74 10                	je     751 <printint+0x88>
    buf[i++] = '-';
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	8d 50 01             	lea    0x1(%eax),%edx
 747:	89 55 f4             	mov    %edx,-0xc(%ebp)
 74a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 74f:	eb 1f                	jmp    770 <printint+0xa7>
 751:	eb 1d                	jmp    770 <printint+0xa7>
    putc(fd, buf[i]);
 753:	8d 55 dc             	lea    -0x24(%ebp),%edx
 756:	8b 45 f4             	mov    -0xc(%ebp),%eax
 759:	01 d0                	add    %edx,%eax
 75b:	0f b6 00             	movzbl (%eax),%eax
 75e:	0f be c0             	movsbl %al,%eax
 761:	89 44 24 04          	mov    %eax,0x4(%esp)
 765:	8b 45 08             	mov    0x8(%ebp),%eax
 768:	89 04 24             	mov    %eax,(%esp)
 76b:	e8 31 ff ff ff       	call   6a1 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 770:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 774:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 778:	79 d9                	jns    753 <printint+0x8a>
    putc(fd, buf[i]);
}
 77a:	83 c4 30             	add    $0x30,%esp
 77d:	5b                   	pop    %ebx
 77e:	5e                   	pop    %esi
 77f:	5d                   	pop    %ebp
 780:	c3                   	ret    

00000781 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 781:	55                   	push   %ebp
 782:	89 e5                	mov    %esp,%ebp
 784:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 787:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 78e:	8d 45 0c             	lea    0xc(%ebp),%eax
 791:	83 c0 04             	add    $0x4,%eax
 794:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 797:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 79e:	e9 7c 01 00 00       	jmp    91f <printf+0x19e>
    c = fmt[i] & 0xff;
 7a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a9:	01 d0                	add    %edx,%eax
 7ab:	0f b6 00             	movzbl (%eax),%eax
 7ae:	0f be c0             	movsbl %al,%eax
 7b1:	25 ff 00 00 00       	and    $0xff,%eax
 7b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7bd:	75 2c                	jne    7eb <printf+0x6a>
      if(c == '%'){
 7bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7c3:	75 0c                	jne    7d1 <printf+0x50>
        state = '%';
 7c5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7cc:	e9 4a 01 00 00       	jmp    91b <printf+0x19a>
      } else {
        putc(fd, c);
 7d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d4:	0f be c0             	movsbl %al,%eax
 7d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7db:	8b 45 08             	mov    0x8(%ebp),%eax
 7de:	89 04 24             	mov    %eax,(%esp)
 7e1:	e8 bb fe ff ff       	call   6a1 <putc>
 7e6:	e9 30 01 00 00       	jmp    91b <printf+0x19a>
      }
    } else if(state == '%'){
 7eb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7ef:	0f 85 26 01 00 00    	jne    91b <printf+0x19a>
      if(c == 'd'){
 7f5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7f9:	75 2d                	jne    828 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7fe:	8b 00                	mov    (%eax),%eax
 800:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 807:	00 
 808:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 80f:	00 
 810:	89 44 24 04          	mov    %eax,0x4(%esp)
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	89 04 24             	mov    %eax,(%esp)
 81a:	e8 aa fe ff ff       	call   6c9 <printint>
        ap++;
 81f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 823:	e9 ec 00 00 00       	jmp    914 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 828:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 82c:	74 06                	je     834 <printf+0xb3>
 82e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 832:	75 2d                	jne    861 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 834:	8b 45 e8             	mov    -0x18(%ebp),%eax
 837:	8b 00                	mov    (%eax),%eax
 839:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 840:	00 
 841:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 848:	00 
 849:	89 44 24 04          	mov    %eax,0x4(%esp)
 84d:	8b 45 08             	mov    0x8(%ebp),%eax
 850:	89 04 24             	mov    %eax,(%esp)
 853:	e8 71 fe ff ff       	call   6c9 <printint>
        ap++;
 858:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 85c:	e9 b3 00 00 00       	jmp    914 <printf+0x193>
      } else if(c == 's'){
 861:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 865:	75 45                	jne    8ac <printf+0x12b>
        s = (char*)*ap;
 867:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86a:	8b 00                	mov    (%eax),%eax
 86c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 86f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 873:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 877:	75 09                	jne    882 <printf+0x101>
          s = "(null)";
 879:	c7 45 f4 86 0b 00 00 	movl   $0xb86,-0xc(%ebp)
        while(*s != 0){
 880:	eb 1e                	jmp    8a0 <printf+0x11f>
 882:	eb 1c                	jmp    8a0 <printf+0x11f>
          putc(fd, *s);
 884:	8b 45 f4             	mov    -0xc(%ebp),%eax
 887:	0f b6 00             	movzbl (%eax),%eax
 88a:	0f be c0             	movsbl %al,%eax
 88d:	89 44 24 04          	mov    %eax,0x4(%esp)
 891:	8b 45 08             	mov    0x8(%ebp),%eax
 894:	89 04 24             	mov    %eax,(%esp)
 897:	e8 05 fe ff ff       	call   6a1 <putc>
          s++;
 89c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	0f b6 00             	movzbl (%eax),%eax
 8a6:	84 c0                	test   %al,%al
 8a8:	75 da                	jne    884 <printf+0x103>
 8aa:	eb 68                	jmp    914 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8ac:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8b0:	75 1d                	jne    8cf <printf+0x14e>
        putc(fd, *ap);
 8b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b5:	8b 00                	mov    (%eax),%eax
 8b7:	0f be c0             	movsbl %al,%eax
 8ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 8be:	8b 45 08             	mov    0x8(%ebp),%eax
 8c1:	89 04 24             	mov    %eax,(%esp)
 8c4:	e8 d8 fd ff ff       	call   6a1 <putc>
        ap++;
 8c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8cd:	eb 45                	jmp    914 <printf+0x193>
      } else if(c == '%'){
 8cf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8d3:	75 17                	jne    8ec <printf+0x16b>
        putc(fd, c);
 8d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8d8:	0f be c0             	movsbl %al,%eax
 8db:	89 44 24 04          	mov    %eax,0x4(%esp)
 8df:	8b 45 08             	mov    0x8(%ebp),%eax
 8e2:	89 04 24             	mov    %eax,(%esp)
 8e5:	e8 b7 fd ff ff       	call   6a1 <putc>
 8ea:	eb 28                	jmp    914 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8ec:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8f3:	00 
 8f4:	8b 45 08             	mov    0x8(%ebp),%eax
 8f7:	89 04 24             	mov    %eax,(%esp)
 8fa:	e8 a2 fd ff ff       	call   6a1 <putc>
        putc(fd, c);
 8ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 902:	0f be c0             	movsbl %al,%eax
 905:	89 44 24 04          	mov    %eax,0x4(%esp)
 909:	8b 45 08             	mov    0x8(%ebp),%eax
 90c:	89 04 24             	mov    %eax,(%esp)
 90f:	e8 8d fd ff ff       	call   6a1 <putc>
      }
      state = 0;
 914:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 91b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 91f:	8b 55 0c             	mov    0xc(%ebp),%edx
 922:	8b 45 f0             	mov    -0x10(%ebp),%eax
 925:	01 d0                	add    %edx,%eax
 927:	0f b6 00             	movzbl (%eax),%eax
 92a:	84 c0                	test   %al,%al
 92c:	0f 85 71 fe ff ff    	jne    7a3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 932:	c9                   	leave  
 933:	c3                   	ret    

00000934 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 934:	55                   	push   %ebp
 935:	89 e5                	mov    %esp,%ebp
 937:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 93a:	8b 45 08             	mov    0x8(%ebp),%eax
 93d:	83 e8 08             	sub    $0x8,%eax
 940:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 943:	a1 88 0e 00 00       	mov    0xe88,%eax
 948:	89 45 fc             	mov    %eax,-0x4(%ebp)
 94b:	eb 24                	jmp    971 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	8b 00                	mov    (%eax),%eax
 952:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 955:	77 12                	ja     969 <free+0x35>
 957:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95d:	77 24                	ja     983 <free+0x4f>
 95f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 962:	8b 00                	mov    (%eax),%eax
 964:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 967:	77 1a                	ja     983 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 969:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96c:	8b 00                	mov    (%eax),%eax
 96e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 971:	8b 45 f8             	mov    -0x8(%ebp),%eax
 974:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 977:	76 d4                	jbe    94d <free+0x19>
 979:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97c:	8b 00                	mov    (%eax),%eax
 97e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 981:	76 ca                	jbe    94d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 983:	8b 45 f8             	mov    -0x8(%ebp),%eax
 986:	8b 40 04             	mov    0x4(%eax),%eax
 989:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 990:	8b 45 f8             	mov    -0x8(%ebp),%eax
 993:	01 c2                	add    %eax,%edx
 995:	8b 45 fc             	mov    -0x4(%ebp),%eax
 998:	8b 00                	mov    (%eax),%eax
 99a:	39 c2                	cmp    %eax,%edx
 99c:	75 24                	jne    9c2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 99e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a1:	8b 50 04             	mov    0x4(%eax),%edx
 9a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a7:	8b 00                	mov    (%eax),%eax
 9a9:	8b 40 04             	mov    0x4(%eax),%eax
 9ac:	01 c2                	add    %eax,%edx
 9ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b7:	8b 00                	mov    (%eax),%eax
 9b9:	8b 10                	mov    (%eax),%edx
 9bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9be:	89 10                	mov    %edx,(%eax)
 9c0:	eb 0a                	jmp    9cc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c5:	8b 10                	mov    (%eax),%edx
 9c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cf:	8b 40 04             	mov    0x4(%eax),%eax
 9d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9dc:	01 d0                	add    %edx,%eax
 9de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9e1:	75 20                	jne    a03 <free+0xcf>
    p->s.size += bp->s.size;
 9e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e6:	8b 50 04             	mov    0x4(%eax),%edx
 9e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ec:	8b 40 04             	mov    0x4(%eax),%eax
 9ef:	01 c2                	add    %eax,%edx
 9f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9fa:	8b 10                	mov    (%eax),%edx
 9fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ff:	89 10                	mov    %edx,(%eax)
 a01:	eb 08                	jmp    a0b <free+0xd7>
  } else
    p->s.ptr = bp;
 a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a06:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a09:	89 10                	mov    %edx,(%eax)
  freep = p;
 a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0e:	a3 88 0e 00 00       	mov    %eax,0xe88
}
 a13:	c9                   	leave  
 a14:	c3                   	ret    

00000a15 <morecore>:

static Header*
morecore(uint nu)
{
 a15:	55                   	push   %ebp
 a16:	89 e5                	mov    %esp,%ebp
 a18:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a1b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a22:	77 07                	ja     a2b <morecore+0x16>
    nu = 4096;
 a24:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a2b:	8b 45 08             	mov    0x8(%ebp),%eax
 a2e:	c1 e0 03             	shl    $0x3,%eax
 a31:	89 04 24             	mov    %eax,(%esp)
 a34:	e8 28 fc ff ff       	call   661 <sbrk>
 a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a3c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a40:	75 07                	jne    a49 <morecore+0x34>
    return 0;
 a42:	b8 00 00 00 00       	mov    $0x0,%eax
 a47:	eb 22                	jmp    a6b <morecore+0x56>
  hp = (Header*)p;
 a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a52:	8b 55 08             	mov    0x8(%ebp),%edx
 a55:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5b:	83 c0 08             	add    $0x8,%eax
 a5e:	89 04 24             	mov    %eax,(%esp)
 a61:	e8 ce fe ff ff       	call   934 <free>
  return freep;
 a66:	a1 88 0e 00 00       	mov    0xe88,%eax
}
 a6b:	c9                   	leave  
 a6c:	c3                   	ret    

00000a6d <malloc>:

void*
malloc(uint nbytes)
{
 a6d:	55                   	push   %ebp
 a6e:	89 e5                	mov    %esp,%ebp
 a70:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a73:	8b 45 08             	mov    0x8(%ebp),%eax
 a76:	83 c0 07             	add    $0x7,%eax
 a79:	c1 e8 03             	shr    $0x3,%eax
 a7c:	83 c0 01             	add    $0x1,%eax
 a7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a82:	a1 88 0e 00 00       	mov    0xe88,%eax
 a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a8e:	75 23                	jne    ab3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a90:	c7 45 f0 80 0e 00 00 	movl   $0xe80,-0x10(%ebp)
 a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a9a:	a3 88 0e 00 00       	mov    %eax,0xe88
 a9f:	a1 88 0e 00 00       	mov    0xe88,%eax
 aa4:	a3 80 0e 00 00       	mov    %eax,0xe80
    base.s.size = 0;
 aa9:	c7 05 84 0e 00 00 00 	movl   $0x0,0xe84
 ab0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab6:	8b 00                	mov    (%eax),%eax
 ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abe:	8b 40 04             	mov    0x4(%eax),%eax
 ac1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ac4:	72 4d                	jb     b13 <malloc+0xa6>
      if(p->s.size == nunits)
 ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac9:	8b 40 04             	mov    0x4(%eax),%eax
 acc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 acf:	75 0c                	jne    add <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad4:	8b 10                	mov    (%eax),%edx
 ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad9:	89 10                	mov    %edx,(%eax)
 adb:	eb 26                	jmp    b03 <malloc+0x96>
      else {
        p->s.size -= nunits;
 add:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae0:	8b 40 04             	mov    0x4(%eax),%eax
 ae3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ae6:	89 c2                	mov    %eax,%edx
 ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aeb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af1:	8b 40 04             	mov    0x4(%eax),%eax
 af4:	c1 e0 03             	shl    $0x3,%eax
 af7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b00:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b06:	a3 88 0e 00 00       	mov    %eax,0xe88
      return (void*)(p + 1);
 b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0e:	83 c0 08             	add    $0x8,%eax
 b11:	eb 38                	jmp    b4b <malloc+0xde>
    }
    if(p == freep)
 b13:	a1 88 0e 00 00       	mov    0xe88,%eax
 b18:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b1b:	75 1b                	jne    b38 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b20:	89 04 24             	mov    %eax,(%esp)
 b23:	e8 ed fe ff ff       	call   a15 <morecore>
 b28:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b2f:	75 07                	jne    b38 <malloc+0xcb>
        return 0;
 b31:	b8 00 00 00 00       	mov    $0x0,%eax
 b36:	eb 13                	jmp    b4b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b41:	8b 00                	mov    (%eax),%eax
 b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b46:	e9 70 ff ff ff       	jmp    abb <malloc+0x4e>
}
 b4b:	c9                   	leave  
 b4c:	c3                   	ret    
