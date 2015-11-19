
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 eb 03 00 00       	call   3fd <strlen>
  12:	8b 55 08             	mov    0x8(%ebp),%edx
  15:	01 d0                	add    %edx,%eax
  17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1a:	eb 04                	jmp    20 <fmtname+0x20>
  1c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  23:	3b 45 08             	cmp    0x8(%ebp),%eax
  26:	72 0a                	jb     32 <fmtname+0x32>
  28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2b:	0f b6 00             	movzbl (%eax),%eax
  2e:	3c 2f                	cmp    $0x2f,%al
  30:	75 ea                	jne    1c <fmtname+0x1c>
    ;
  p++;
  32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  39:	89 04 24             	mov    %eax,(%esp)
  3c:	e8 bc 03 00 00       	call   3fd <strlen>
  41:	83 f8 0d             	cmp    $0xd,%eax
  44:	76 05                	jbe    4b <fmtname+0x4b>
    return p;
  46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  49:	eb 5f                	jmp    aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
  4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4e:	89 04 24             	mov    %eax,(%esp)
  51:	e8 a7 03 00 00       	call   3fd <strlen>
  56:	89 44 24 08          	mov    %eax,0x8(%esp)
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  61:	c7 04 24 34 0e 00 00 	movl   $0xe34,(%esp)
  68:	e8 1f 05 00 00       	call   58c <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  70:	89 04 24             	mov    %eax,(%esp)
  73:	e8 85 03 00 00       	call   3fd <strlen>
  78:	ba 0e 00 00 00       	mov    $0xe,%edx
  7d:	89 d3                	mov    %edx,%ebx
  7f:	29 c3                	sub    %eax,%ebx
  81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  84:	89 04 24             	mov    %eax,(%esp)
  87:	e8 71 03 00 00       	call   3fd <strlen>
  8c:	05 34 0e 00 00       	add    $0xe34,%eax
  91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  95:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  9c:	00 
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 7f 03 00 00       	call   424 <memset>
  return buf;
  a5:	b8 34 0e 00 00       	mov    $0xe34,%eax
}
  aa:	83 c4 24             	add    $0x24,%esp
  ad:	5b                   	pop    %ebx
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <ls>:

void
ls(char *path)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	57                   	push   %edi
  b4:	56                   	push   %esi
  b5:	53                   	push   %ebx
  b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c3:	00 
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 04 24             	mov    %eax,(%esp)
  ca:	e8 42 05 00 00       	call   611 <open>
  cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d6:	79 20                	jns    f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	89 44 24 08          	mov    %eax,0x8(%esp)
  df:	c7 44 24 04 35 0b 00 	movl   $0xb35,0x4(%esp)
  e6:	00 
  e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ee:	e8 76 06 00 00       	call   769 <printf>
    return;
  f3:	e9 01 02 00 00       	jmp    2f9 <ls+0x249>
  }
  
  if(fstat(fd, &st) < 0){
  f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 105:	89 04 24             	mov    %eax,(%esp)
 108:	e8 1c 05 00 00       	call   629 <fstat>
 10d:	85 c0                	test   %eax,%eax
 10f:	79 2b                	jns    13c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	89 44 24 08          	mov    %eax,0x8(%esp)
 118:	c7 44 24 04 49 0b 00 	movl   $0xb49,0x4(%esp)
 11f:	00 
 120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 127:	e8 3d 06 00 00       	call   769 <printf>
    close(fd);
 12c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12f:	89 04 24             	mov    %eax,(%esp)
 132:	e8 c2 04 00 00       	call   5f9 <close>
    return;
 137:	e9 bd 01 00 00       	jmp    2f9 <ls+0x249>
  }
  
  switch(st.type){
 13c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 143:	98                   	cwtl   
 144:	83 f8 01             	cmp    $0x1,%eax
 147:	74 53                	je     19c <ls+0xec>
 149:	83 f8 02             	cmp    $0x2,%eax
 14c:	0f 85 9c 01 00 00    	jne    2ee <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 152:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 158:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 165:	0f bf d8             	movswl %ax,%ebx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	89 04 24             	mov    %eax,(%esp)
 16e:	e8 8d fe ff ff       	call   0 <fmtname>
 173:	89 7c 24 14          	mov    %edi,0x14(%esp)
 177:	89 74 24 10          	mov    %esi,0x10(%esp)
 17b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 17f:	89 44 24 08          	mov    %eax,0x8(%esp)
 183:	c7 44 24 04 5d 0b 00 	movl   $0xb5d,0x4(%esp)
 18a:	00 
 18b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 192:	e8 d2 05 00 00       	call   769 <printf>
    break;
 197:	e9 52 01 00 00       	jmp    2ee <ls+0x23e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	89 04 24             	mov    %eax,(%esp)
 1a2:	e8 56 02 00 00       	call   3fd <strlen>
 1a7:	83 c0 10             	add    $0x10,%eax
 1aa:	3d 00 02 00 00       	cmp    $0x200,%eax
 1af:	76 19                	jbe    1ca <ls+0x11a>
      printf(1, "ls: path too long\n");
 1b1:	c7 44 24 04 6a 0b 00 	movl   $0xb6a,0x4(%esp)
 1b8:	00 
 1b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c0:	e8 a4 05 00 00       	call   769 <printf>
      break;
 1c5:	e9 24 01 00 00       	jmp    2ee <ls+0x23e>
    }
    strcpy(buf, path);
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d7:	89 04 24             	mov    %eax,(%esp)
 1da:	e8 af 01 00 00       	call   38e <strcpy>
    p = buf+strlen(buf);
 1df:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e5:	89 04 24             	mov    %eax,(%esp)
 1e8:	e8 10 02 00 00       	call   3fd <strlen>
 1ed:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1f3:	01 d0                	add    %edx,%eax
 1f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1fb:	8d 50 01             	lea    0x1(%eax),%edx
 1fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
 201:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 204:	e9 be 00 00 00       	jmp    2c7 <ls+0x217>
      if(de.inum == 0)
 209:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 210:	66 85 c0             	test   %ax,%ax
 213:	75 05                	jne    21a <ls+0x16a>
        continue;
 215:	e9 ad 00 00 00       	jmp    2c7 <ls+0x217>
      memmove(p, de.name, DIRSIZ);
 21a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 221:	00 
 222:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 228:	83 c0 02             	add    $0x2,%eax
 22b:	89 44 24 04          	mov    %eax,0x4(%esp)
 22f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 232:	89 04 24             	mov    %eax,(%esp)
 235:	e8 52 03 00 00       	call   58c <memmove>
      p[DIRSIZ] = 0;
 23a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 23d:	83 c0 0e             	add    $0xe,%eax
 240:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 243:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 249:	89 44 24 04          	mov    %eax,0x4(%esp)
 24d:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 253:	89 04 24             	mov    %eax,(%esp)
 256:	e8 96 02 00 00       	call   4f1 <stat>
 25b:	85 c0                	test   %eax,%eax
 25d:	79 20                	jns    27f <ls+0x1cf>
        printf(1, "ls: cannot stat %s\n", buf);
 25f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 265:	89 44 24 08          	mov    %eax,0x8(%esp)
 269:	c7 44 24 04 49 0b 00 	movl   $0xb49,0x4(%esp)
 270:	00 
 271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 278:	e8 ec 04 00 00       	call   769 <printf>
        continue;
 27d:	eb 48                	jmp    2c7 <ls+0x217>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 27f:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 285:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 28b:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 292:	0f bf d8             	movswl %ax,%ebx
 295:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 29b:	89 04 24             	mov    %eax,(%esp)
 29e:	e8 5d fd ff ff       	call   0 <fmtname>
 2a3:	89 7c 24 14          	mov    %edi,0x14(%esp)
 2a7:	89 74 24 10          	mov    %esi,0x10(%esp)
 2ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2af:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b3:	c7 44 24 04 5d 0b 00 	movl   $0xb5d,0x4(%esp)
 2ba:	00 
 2bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2c2:	e8 a2 04 00 00       	call   769 <printf>
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2ce:	00 
 2cf:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2dc:	89 04 24             	mov    %eax,(%esp)
 2df:	e8 05 03 00 00       	call   5e9 <read>
 2e4:	83 f8 10             	cmp    $0x10,%eax
 2e7:	0f 84 1c ff ff ff    	je     209 <ls+0x159>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2ed:	90                   	nop
  }
  close(fd);
 2ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2f1:	89 04 24             	mov    %eax,(%esp)
 2f4:	e8 00 03 00 00       	call   5f9 <close>
}
 2f9:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2ff:	5b                   	pop    %ebx
 300:	5e                   	pop    %esi
 301:	5f                   	pop    %edi
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    

00000304 <main>:

int
main(int argc, char *argv[])
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	83 e4 f0             	and    $0xfffffff0,%esp
 30a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
 30d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 311:	7f 18                	jg     32b <main+0x27>
    ls(".");
 313:	c7 04 24 7d 0b 00 00 	movl   $0xb7d,(%esp)
 31a:	e8 91 fd ff ff       	call   b0 <ls>
    exit(0);
 31f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 326:	e8 a6 02 00 00       	call   5d1 <exit>
  }
  for(i=1; i<argc; i++)
 32b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 332:	00 
 333:	eb 1f                	jmp    354 <main+0x50>
    ls(argv[i]);
 335:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 340:	8b 45 0c             	mov    0xc(%ebp),%eax
 343:	01 d0                	add    %edx,%eax
 345:	8b 00                	mov    (%eax),%eax
 347:	89 04 24             	mov    %eax,(%esp)
 34a:	e8 61 fd ff ff       	call   b0 <ls>

  if(argc < 2){
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
 34f:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 354:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 358:	3b 45 08             	cmp    0x8(%ebp),%eax
 35b:	7c d8                	jl     335 <main+0x31>
  //struct procstat *stat=0;
  //int ret = pstat(1, stat);
  //printf(1,"/d",ret);		//for debug
  ///////////////////////////////////

  exit(0);
 35d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 364:	e8 68 02 00 00       	call   5d1 <exit>

00000369 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	57                   	push   %edi
 36d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 36e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 371:	8b 55 10             	mov    0x10(%ebp),%edx
 374:	8b 45 0c             	mov    0xc(%ebp),%eax
 377:	89 cb                	mov    %ecx,%ebx
 379:	89 df                	mov    %ebx,%edi
 37b:	89 d1                	mov    %edx,%ecx
 37d:	fc                   	cld    
 37e:	f3 aa                	rep stos %al,%es:(%edi)
 380:	89 ca                	mov    %ecx,%edx
 382:	89 fb                	mov    %edi,%ebx
 384:	89 5d 08             	mov    %ebx,0x8(%ebp)
 387:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 38a:	5b                   	pop    %ebx
 38b:	5f                   	pop    %edi
 38c:	5d                   	pop    %ebp
 38d:	c3                   	ret    

0000038e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 38e:	55                   	push   %ebp
 38f:	89 e5                	mov    %esp,%ebp
 391:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 39a:	90                   	nop
 39b:	8b 45 08             	mov    0x8(%ebp),%eax
 39e:	8d 50 01             	lea    0x1(%eax),%edx
 3a1:	89 55 08             	mov    %edx,0x8(%ebp)
 3a4:	8b 55 0c             	mov    0xc(%ebp),%edx
 3a7:	8d 4a 01             	lea    0x1(%edx),%ecx
 3aa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3ad:	0f b6 12             	movzbl (%edx),%edx
 3b0:	88 10                	mov    %dl,(%eax)
 3b2:	0f b6 00             	movzbl (%eax),%eax
 3b5:	84 c0                	test   %al,%al
 3b7:	75 e2                	jne    39b <strcpy+0xd>
    ;
  return os;
 3b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3bc:	c9                   	leave  
 3bd:	c3                   	ret    

000003be <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3be:	55                   	push   %ebp
 3bf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3c1:	eb 08                	jmp    3cb <strcmp+0xd>
    p++, q++;
 3c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3c7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	0f b6 00             	movzbl (%eax),%eax
 3d1:	84 c0                	test   %al,%al
 3d3:	74 10                	je     3e5 <strcmp+0x27>
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	0f b6 10             	movzbl (%eax),%edx
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	0f b6 00             	movzbl (%eax),%eax
 3e1:	38 c2                	cmp    %al,%dl
 3e3:	74 de                	je     3c3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
 3e8:	0f b6 00             	movzbl (%eax),%eax
 3eb:	0f b6 d0             	movzbl %al,%edx
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	0f b6 00             	movzbl (%eax),%eax
 3f4:	0f b6 c0             	movzbl %al,%eax
 3f7:	29 c2                	sub    %eax,%edx
 3f9:	89 d0                	mov    %edx,%eax
}
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    

000003fd <strlen>:

uint
strlen(char *s)
{
 3fd:	55                   	push   %ebp
 3fe:	89 e5                	mov    %esp,%ebp
 400:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 403:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 40a:	eb 04                	jmp    410 <strlen+0x13>
 40c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 410:	8b 55 fc             	mov    -0x4(%ebp),%edx
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	01 d0                	add    %edx,%eax
 418:	0f b6 00             	movzbl (%eax),%eax
 41b:	84 c0                	test   %al,%al
 41d:	75 ed                	jne    40c <strlen+0xf>
    ;
  return n;
 41f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 422:	c9                   	leave  
 423:	c3                   	ret    

00000424 <memset>:

void*
memset(void *dst, int c, uint n)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 42a:	8b 45 10             	mov    0x10(%ebp),%eax
 42d:	89 44 24 08          	mov    %eax,0x8(%esp)
 431:	8b 45 0c             	mov    0xc(%ebp),%eax
 434:	89 44 24 04          	mov    %eax,0x4(%esp)
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	89 04 24             	mov    %eax,(%esp)
 43e:	e8 26 ff ff ff       	call   369 <stosb>
  return dst;
 443:	8b 45 08             	mov    0x8(%ebp),%eax
}
 446:	c9                   	leave  
 447:	c3                   	ret    

00000448 <strchr>:

char*
strchr(const char *s, char c)
{
 448:	55                   	push   %ebp
 449:	89 e5                	mov    %esp,%ebp
 44b:	83 ec 04             	sub    $0x4,%esp
 44e:	8b 45 0c             	mov    0xc(%ebp),%eax
 451:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 454:	eb 14                	jmp    46a <strchr+0x22>
    if(*s == c)
 456:	8b 45 08             	mov    0x8(%ebp),%eax
 459:	0f b6 00             	movzbl (%eax),%eax
 45c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 45f:	75 05                	jne    466 <strchr+0x1e>
      return (char*)s;
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	eb 13                	jmp    479 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 466:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	0f b6 00             	movzbl (%eax),%eax
 470:	84 c0                	test   %al,%al
 472:	75 e2                	jne    456 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 474:	b8 00 00 00 00       	mov    $0x0,%eax
}
 479:	c9                   	leave  
 47a:	c3                   	ret    

0000047b <gets>:

char*
gets(char *buf, int max)
{
 47b:	55                   	push   %ebp
 47c:	89 e5                	mov    %esp,%ebp
 47e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 481:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 488:	eb 4c                	jmp    4d6 <gets+0x5b>
    cc = read(0, &c, 1);
 48a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 491:	00 
 492:	8d 45 ef             	lea    -0x11(%ebp),%eax
 495:	89 44 24 04          	mov    %eax,0x4(%esp)
 499:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4a0:	e8 44 01 00 00       	call   5e9 <read>
 4a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ac:	7f 02                	jg     4b0 <gets+0x35>
      break;
 4ae:	eb 31                	jmp    4e1 <gets+0x66>
    buf[i++] = c;
 4b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b3:	8d 50 01             	lea    0x1(%eax),%edx
 4b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b9:	89 c2                	mov    %eax,%edx
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	01 c2                	add    %eax,%edx
 4c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4ca:	3c 0a                	cmp    $0xa,%al
 4cc:	74 13                	je     4e1 <gets+0x66>
 4ce:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4d2:	3c 0d                	cmp    $0xd,%al
 4d4:	74 0b                	je     4e1 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d9:	83 c0 01             	add    $0x1,%eax
 4dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4df:	7c a9                	jl     48a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	01 d0                	add    %edx,%eax
 4e9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ef:	c9                   	leave  
 4f0:	c3                   	ret    

000004f1 <stat>:

int
stat(char *n, struct stat *st)
{
 4f1:	55                   	push   %ebp
 4f2:	89 e5                	mov    %esp,%ebp
 4f4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4fe:	00 
 4ff:	8b 45 08             	mov    0x8(%ebp),%eax
 502:	89 04 24             	mov    %eax,(%esp)
 505:	e8 07 01 00 00       	call   611 <open>
 50a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 50d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 511:	79 07                	jns    51a <stat+0x29>
    return -1;
 513:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 518:	eb 23                	jmp    53d <stat+0x4c>
  r = fstat(fd, st);
 51a:	8b 45 0c             	mov    0xc(%ebp),%eax
 51d:	89 44 24 04          	mov    %eax,0x4(%esp)
 521:	8b 45 f4             	mov    -0xc(%ebp),%eax
 524:	89 04 24             	mov    %eax,(%esp)
 527:	e8 fd 00 00 00       	call   629 <fstat>
 52c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 52f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 532:	89 04 24             	mov    %eax,(%esp)
 535:	e8 bf 00 00 00       	call   5f9 <close>
  return r;
 53a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 53d:	c9                   	leave  
 53e:	c3                   	ret    

0000053f <atoi>:

int
atoi(const char *s)
{
 53f:	55                   	push   %ebp
 540:	89 e5                	mov    %esp,%ebp
 542:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 545:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 54c:	eb 25                	jmp    573 <atoi+0x34>
    n = n*10 + *s++ - '0';
 54e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 551:	89 d0                	mov    %edx,%eax
 553:	c1 e0 02             	shl    $0x2,%eax
 556:	01 d0                	add    %edx,%eax
 558:	01 c0                	add    %eax,%eax
 55a:	89 c1                	mov    %eax,%ecx
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	8d 50 01             	lea    0x1(%eax),%edx
 562:	89 55 08             	mov    %edx,0x8(%ebp)
 565:	0f b6 00             	movzbl (%eax),%eax
 568:	0f be c0             	movsbl %al,%eax
 56b:	01 c8                	add    %ecx,%eax
 56d:	83 e8 30             	sub    $0x30,%eax
 570:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	0f b6 00             	movzbl (%eax),%eax
 579:	3c 2f                	cmp    $0x2f,%al
 57b:	7e 0a                	jle    587 <atoi+0x48>
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	0f b6 00             	movzbl (%eax),%eax
 583:	3c 39                	cmp    $0x39,%al
 585:	7e c7                	jle    54e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 587:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 58a:	c9                   	leave  
 58b:	c3                   	ret    

0000058c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 58c:	55                   	push   %ebp
 58d:	89 e5                	mov    %esp,%ebp
 58f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 598:	8b 45 0c             	mov    0xc(%ebp),%eax
 59b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 59e:	eb 17                	jmp    5b7 <memmove+0x2b>
    *dst++ = *src++;
 5a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a3:	8d 50 01             	lea    0x1(%eax),%edx
 5a6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5a9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5ac:	8d 4a 01             	lea    0x1(%edx),%ecx
 5af:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5b2:	0f b6 12             	movzbl (%edx),%edx
 5b5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5b7:	8b 45 10             	mov    0x10(%ebp),%eax
 5ba:	8d 50 ff             	lea    -0x1(%eax),%edx
 5bd:	89 55 10             	mov    %edx,0x10(%ebp)
 5c0:	85 c0                	test   %eax,%eax
 5c2:	7f dc                	jg     5a0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5c7:	c9                   	leave  
 5c8:	c3                   	ret    

000005c9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5c9:	b8 01 00 00 00       	mov    $0x1,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <exit>:
SYSCALL(exit)
 5d1:	b8 02 00 00 00       	mov    $0x2,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <wait>:
SYSCALL(wait)
 5d9:	b8 03 00 00 00       	mov    $0x3,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <pipe>:
SYSCALL(pipe)
 5e1:	b8 04 00 00 00       	mov    $0x4,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <read>:
SYSCALL(read)
 5e9:	b8 05 00 00 00       	mov    $0x5,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <write>:
SYSCALL(write)
 5f1:	b8 10 00 00 00       	mov    $0x10,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <close>:
SYSCALL(close)
 5f9:	b8 15 00 00 00       	mov    $0x15,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <kill>:
SYSCALL(kill)
 601:	b8 06 00 00 00       	mov    $0x6,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <exec>:
SYSCALL(exec)
 609:	b8 07 00 00 00       	mov    $0x7,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <open>:
SYSCALL(open)
 611:	b8 0f 00 00 00       	mov    $0xf,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <mknod>:
SYSCALL(mknod)
 619:	b8 11 00 00 00       	mov    $0x11,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <unlink>:
SYSCALL(unlink)
 621:	b8 12 00 00 00       	mov    $0x12,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <fstat>:
SYSCALL(fstat)
 629:	b8 08 00 00 00       	mov    $0x8,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <link>:
SYSCALL(link)
 631:	b8 13 00 00 00       	mov    $0x13,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <mkdir>:
SYSCALL(mkdir)
 639:	b8 14 00 00 00       	mov    $0x14,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <chdir>:
SYSCALL(chdir)
 641:	b8 09 00 00 00       	mov    $0x9,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <dup>:
SYSCALL(dup)
 649:	b8 0a 00 00 00       	mov    $0xa,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <getpid>:
SYSCALL(getpid)
 651:	b8 0b 00 00 00       	mov    $0xb,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <sbrk>:
SYSCALL(sbrk)
 659:	b8 0c 00 00 00       	mov    $0xc,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <sleep>:
SYSCALL(sleep)
 661:	b8 0d 00 00 00       	mov    $0xd,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <uptime>:
SYSCALL(uptime)
 669:	b8 0e 00 00 00       	mov    $0xe,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <pstat>:
SYSCALL(pstat)
 671:	b8 16 00 00 00       	mov    $0x16,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <printjob>:
SYSCALL(printjob)
 679:	b8 17 00 00 00       	mov    $0x17,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <attachjob>:
SYSCALL(attachjob)
 681:	b8 18 00 00 00       	mov    $0x18,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 689:	55                   	push   %ebp
 68a:	89 e5                	mov    %esp,%ebp
 68c:	83 ec 18             	sub    $0x18,%esp
 68f:	8b 45 0c             	mov    0xc(%ebp),%eax
 692:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 695:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 69c:	00 
 69d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a4:	8b 45 08             	mov    0x8(%ebp),%eax
 6a7:	89 04 24             	mov    %eax,(%esp)
 6aa:	e8 42 ff ff ff       	call   5f1 <write>
}
 6af:	c9                   	leave  
 6b0:	c3                   	ret    

000006b1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6b1:	55                   	push   %ebp
 6b2:	89 e5                	mov    %esp,%ebp
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6c0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6c4:	74 17                	je     6dd <printint+0x2c>
 6c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6ca:	79 11                	jns    6dd <printint+0x2c>
    neg = 1;
 6cc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d6:	f7 d8                	neg    %eax
 6d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6db:	eb 06                	jmp    6e3 <printint+0x32>
  } else {
    x = xx;
 6dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6ea:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6ed:	8d 41 01             	lea    0x1(%ecx),%eax
 6f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6f9:	ba 00 00 00 00       	mov    $0x0,%edx
 6fe:	f7 f3                	div    %ebx
 700:	89 d0                	mov    %edx,%eax
 702:	0f b6 80 20 0e 00 00 	movzbl 0xe20(%eax),%eax
 709:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 70d:	8b 75 10             	mov    0x10(%ebp),%esi
 710:	8b 45 ec             	mov    -0x14(%ebp),%eax
 713:	ba 00 00 00 00       	mov    $0x0,%edx
 718:	f7 f6                	div    %esi
 71a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 71d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 721:	75 c7                	jne    6ea <printint+0x39>
  if(neg)
 723:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 727:	74 10                	je     739 <printint+0x88>
    buf[i++] = '-';
 729:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72c:	8d 50 01             	lea    0x1(%eax),%edx
 72f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 732:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 737:	eb 1f                	jmp    758 <printint+0xa7>
 739:	eb 1d                	jmp    758 <printint+0xa7>
    putc(fd, buf[i]);
 73b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 73e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 741:	01 d0                	add    %edx,%eax
 743:	0f b6 00             	movzbl (%eax),%eax
 746:	0f be c0             	movsbl %al,%eax
 749:	89 44 24 04          	mov    %eax,0x4(%esp)
 74d:	8b 45 08             	mov    0x8(%ebp),%eax
 750:	89 04 24             	mov    %eax,(%esp)
 753:	e8 31 ff ff ff       	call   689 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 758:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 75c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 760:	79 d9                	jns    73b <printint+0x8a>
    putc(fd, buf[i]);
}
 762:	83 c4 30             	add    $0x30,%esp
 765:	5b                   	pop    %ebx
 766:	5e                   	pop    %esi
 767:	5d                   	pop    %ebp
 768:	c3                   	ret    

00000769 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 769:	55                   	push   %ebp
 76a:	89 e5                	mov    %esp,%ebp
 76c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 76f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 776:	8d 45 0c             	lea    0xc(%ebp),%eax
 779:	83 c0 04             	add    $0x4,%eax
 77c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 77f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 786:	e9 7c 01 00 00       	jmp    907 <printf+0x19e>
    c = fmt[i] & 0xff;
 78b:	8b 55 0c             	mov    0xc(%ebp),%edx
 78e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 791:	01 d0                	add    %edx,%eax
 793:	0f b6 00             	movzbl (%eax),%eax
 796:	0f be c0             	movsbl %al,%eax
 799:	25 ff 00 00 00       	and    $0xff,%eax
 79e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7a5:	75 2c                	jne    7d3 <printf+0x6a>
      if(c == '%'){
 7a7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ab:	75 0c                	jne    7b9 <printf+0x50>
        state = '%';
 7ad:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7b4:	e9 4a 01 00 00       	jmp    903 <printf+0x19a>
      } else {
        putc(fd, c);
 7b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7bc:	0f be c0             	movsbl %al,%eax
 7bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c3:	8b 45 08             	mov    0x8(%ebp),%eax
 7c6:	89 04 24             	mov    %eax,(%esp)
 7c9:	e8 bb fe ff ff       	call   689 <putc>
 7ce:	e9 30 01 00 00       	jmp    903 <printf+0x19a>
      }
    } else if(state == '%'){
 7d3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7d7:	0f 85 26 01 00 00    	jne    903 <printf+0x19a>
      if(c == 'd'){
 7dd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7e1:	75 2d                	jne    810 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 7e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7ef:	00 
 7f0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7f7:	00 
 7f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fc:	8b 45 08             	mov    0x8(%ebp),%eax
 7ff:	89 04 24             	mov    %eax,(%esp)
 802:	e8 aa fe ff ff       	call   6b1 <printint>
        ap++;
 807:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 80b:	e9 ec 00 00 00       	jmp    8fc <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 810:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 814:	74 06                	je     81c <printf+0xb3>
 816:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 81a:	75 2d                	jne    849 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 81c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 81f:	8b 00                	mov    (%eax),%eax
 821:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 828:	00 
 829:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 830:	00 
 831:	89 44 24 04          	mov    %eax,0x4(%esp)
 835:	8b 45 08             	mov    0x8(%ebp),%eax
 838:	89 04 24             	mov    %eax,(%esp)
 83b:	e8 71 fe ff ff       	call   6b1 <printint>
        ap++;
 840:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 844:	e9 b3 00 00 00       	jmp    8fc <printf+0x193>
      } else if(c == 's'){
 849:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 84d:	75 45                	jne    894 <printf+0x12b>
        s = (char*)*ap;
 84f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 852:	8b 00                	mov    (%eax),%eax
 854:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 857:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 85b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85f:	75 09                	jne    86a <printf+0x101>
          s = "(null)";
 861:	c7 45 f4 7f 0b 00 00 	movl   $0xb7f,-0xc(%ebp)
        while(*s != 0){
 868:	eb 1e                	jmp    888 <printf+0x11f>
 86a:	eb 1c                	jmp    888 <printf+0x11f>
          putc(fd, *s);
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	0f b6 00             	movzbl (%eax),%eax
 872:	0f be c0             	movsbl %al,%eax
 875:	89 44 24 04          	mov    %eax,0x4(%esp)
 879:	8b 45 08             	mov    0x8(%ebp),%eax
 87c:	89 04 24             	mov    %eax,(%esp)
 87f:	e8 05 fe ff ff       	call   689 <putc>
          s++;
 884:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	0f b6 00             	movzbl (%eax),%eax
 88e:	84 c0                	test   %al,%al
 890:	75 da                	jne    86c <printf+0x103>
 892:	eb 68                	jmp    8fc <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 894:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 898:	75 1d                	jne    8b7 <printf+0x14e>
        putc(fd, *ap);
 89a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 89d:	8b 00                	mov    (%eax),%eax
 89f:	0f be c0             	movsbl %al,%eax
 8a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a6:	8b 45 08             	mov    0x8(%ebp),%eax
 8a9:	89 04 24             	mov    %eax,(%esp)
 8ac:	e8 d8 fd ff ff       	call   689 <putc>
        ap++;
 8b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8b5:	eb 45                	jmp    8fc <printf+0x193>
      } else if(c == '%'){
 8b7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8bb:	75 17                	jne    8d4 <printf+0x16b>
        putc(fd, c);
 8bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c0:	0f be c0             	movsbl %al,%eax
 8c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ca:	89 04 24             	mov    %eax,(%esp)
 8cd:	e8 b7 fd ff ff       	call   689 <putc>
 8d2:	eb 28                	jmp    8fc <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8d4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8db:	00 
 8dc:	8b 45 08             	mov    0x8(%ebp),%eax
 8df:	89 04 24             	mov    %eax,(%esp)
 8e2:	e8 a2 fd ff ff       	call   689 <putc>
        putc(fd, c);
 8e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8ea:	0f be c0             	movsbl %al,%eax
 8ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 8f1:	8b 45 08             	mov    0x8(%ebp),%eax
 8f4:	89 04 24             	mov    %eax,(%esp)
 8f7:	e8 8d fd ff ff       	call   689 <putc>
      }
      state = 0;
 8fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 903:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 907:	8b 55 0c             	mov    0xc(%ebp),%edx
 90a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90d:	01 d0                	add    %edx,%eax
 90f:	0f b6 00             	movzbl (%eax),%eax
 912:	84 c0                	test   %al,%al
 914:	0f 85 71 fe ff ff    	jne    78b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 91a:	c9                   	leave  
 91b:	c3                   	ret    

0000091c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 91c:	55                   	push   %ebp
 91d:	89 e5                	mov    %esp,%ebp
 91f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 922:	8b 45 08             	mov    0x8(%ebp),%eax
 925:	83 e8 08             	sub    $0x8,%eax
 928:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92b:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 930:	89 45 fc             	mov    %eax,-0x4(%ebp)
 933:	eb 24                	jmp    959 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 935:	8b 45 fc             	mov    -0x4(%ebp),%eax
 938:	8b 00                	mov    (%eax),%eax
 93a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 93d:	77 12                	ja     951 <free+0x35>
 93f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 942:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 945:	77 24                	ja     96b <free+0x4f>
 947:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94a:	8b 00                	mov    (%eax),%eax
 94c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 94f:	77 1a                	ja     96b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 951:	8b 45 fc             	mov    -0x4(%ebp),%eax
 954:	8b 00                	mov    (%eax),%eax
 956:	89 45 fc             	mov    %eax,-0x4(%ebp)
 959:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95f:	76 d4                	jbe    935 <free+0x19>
 961:	8b 45 fc             	mov    -0x4(%ebp),%eax
 964:	8b 00                	mov    (%eax),%eax
 966:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 969:	76 ca                	jbe    935 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 96b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96e:	8b 40 04             	mov    0x4(%eax),%eax
 971:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 978:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97b:	01 c2                	add    %eax,%edx
 97d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 980:	8b 00                	mov    (%eax),%eax
 982:	39 c2                	cmp    %eax,%edx
 984:	75 24                	jne    9aa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 986:	8b 45 f8             	mov    -0x8(%ebp),%eax
 989:	8b 50 04             	mov    0x4(%eax),%edx
 98c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98f:	8b 00                	mov    (%eax),%eax
 991:	8b 40 04             	mov    0x4(%eax),%eax
 994:	01 c2                	add    %eax,%edx
 996:	8b 45 f8             	mov    -0x8(%ebp),%eax
 999:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99f:	8b 00                	mov    (%eax),%eax
 9a1:	8b 10                	mov    (%eax),%edx
 9a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a6:	89 10                	mov    %edx,(%eax)
 9a8:	eb 0a                	jmp    9b4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ad:	8b 10                	mov    (%eax),%edx
 9af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b7:	8b 40 04             	mov    0x4(%eax),%eax
 9ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c4:	01 d0                	add    %edx,%eax
 9c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9c9:	75 20                	jne    9eb <free+0xcf>
    p->s.size += bp->s.size;
 9cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ce:	8b 50 04             	mov    0x4(%eax),%edx
 9d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d4:	8b 40 04             	mov    0x4(%eax),%eax
 9d7:	01 c2                	add    %eax,%edx
 9d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9dc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e2:	8b 10                	mov    (%eax),%edx
 9e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e7:	89 10                	mov    %edx,(%eax)
 9e9:	eb 08                	jmp    9f3 <free+0xd7>
  } else
    p->s.ptr = bp;
 9eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9f1:	89 10                	mov    %edx,(%eax)
  freep = p;
 9f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f6:	a3 4c 0e 00 00       	mov    %eax,0xe4c
}
 9fb:	c9                   	leave  
 9fc:	c3                   	ret    

000009fd <morecore>:

static Header*
morecore(uint nu)
{
 9fd:	55                   	push   %ebp
 9fe:	89 e5                	mov    %esp,%ebp
 a00:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a03:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a0a:	77 07                	ja     a13 <morecore+0x16>
    nu = 4096;
 a0c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a13:	8b 45 08             	mov    0x8(%ebp),%eax
 a16:	c1 e0 03             	shl    $0x3,%eax
 a19:	89 04 24             	mov    %eax,(%esp)
 a1c:	e8 38 fc ff ff       	call   659 <sbrk>
 a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a24:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a28:	75 07                	jne    a31 <morecore+0x34>
    return 0;
 a2a:	b8 00 00 00 00       	mov    $0x0,%eax
 a2f:	eb 22                	jmp    a53 <morecore+0x56>
  hp = (Header*)p;
 a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3a:	8b 55 08             	mov    0x8(%ebp),%edx
 a3d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a43:	83 c0 08             	add    $0x8,%eax
 a46:	89 04 24             	mov    %eax,(%esp)
 a49:	e8 ce fe ff ff       	call   91c <free>
  return freep;
 a4e:	a1 4c 0e 00 00       	mov    0xe4c,%eax
}
 a53:	c9                   	leave  
 a54:	c3                   	ret    

00000a55 <malloc>:

void*
malloc(uint nbytes)
{
 a55:	55                   	push   %ebp
 a56:	89 e5                	mov    %esp,%ebp
 a58:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a5b:	8b 45 08             	mov    0x8(%ebp),%eax
 a5e:	83 c0 07             	add    $0x7,%eax
 a61:	c1 e8 03             	shr    $0x3,%eax
 a64:	83 c0 01             	add    $0x1,%eax
 a67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a6a:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a76:	75 23                	jne    a9b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a78:	c7 45 f0 44 0e 00 00 	movl   $0xe44,-0x10(%ebp)
 a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a82:	a3 4c 0e 00 00       	mov    %eax,0xe4c
 a87:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 a8c:	a3 44 0e 00 00       	mov    %eax,0xe44
    base.s.size = 0;
 a91:	c7 05 48 0e 00 00 00 	movl   $0x0,0xe48
 a98:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a9e:	8b 00                	mov    (%eax),%eax
 aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa6:	8b 40 04             	mov    0x4(%eax),%eax
 aa9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aac:	72 4d                	jb     afb <malloc+0xa6>
      if(p->s.size == nunits)
 aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab1:	8b 40 04             	mov    0x4(%eax),%eax
 ab4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ab7:	75 0c                	jne    ac5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abc:	8b 10                	mov    (%eax),%edx
 abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac1:	89 10                	mov    %edx,(%eax)
 ac3:	eb 26                	jmp    aeb <malloc+0x96>
      else {
        p->s.size -= nunits;
 ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac8:	8b 40 04             	mov    0x4(%eax),%eax
 acb:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ace:	89 c2                	mov    %eax,%edx
 ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad9:	8b 40 04             	mov    0x4(%eax),%eax
 adc:	c1 e0 03             	shl    $0x3,%eax
 adf:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ae8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aee:	a3 4c 0e 00 00       	mov    %eax,0xe4c
      return (void*)(p + 1);
 af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af6:	83 c0 08             	add    $0x8,%eax
 af9:	eb 38                	jmp    b33 <malloc+0xde>
    }
    if(p == freep)
 afb:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 b00:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b03:	75 1b                	jne    b20 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b08:	89 04 24             	mov    %eax,(%esp)
 b0b:	e8 ed fe ff ff       	call   9fd <morecore>
 b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b17:	75 07                	jne    b20 <malloc+0xcb>
        return 0;
 b19:	b8 00 00 00 00       	mov    $0x0,%eax
 b1e:	eb 13                	jmp    b33 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b29:	8b 00                	mov    (%eax),%eax
 b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b2e:	e9 70 ff ff ff       	jmp    aa3 <malloc+0x4e>
}
 b33:	c9                   	leave  
 b34:	c3                   	ret    
