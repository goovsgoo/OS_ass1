
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;
  int status;			//For wait func

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 0c                	jne    18 <runcmd+0x18>
    exit(0);
       c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      13:	e8 a7 12 00 00       	call   12bf <exit>
  
  switch(cmd->type){
      18:	8b 45 08             	mov    0x8(%ebp),%eax
      1b:	8b 00                	mov    (%eax),%eax
      1d:	83 f8 05             	cmp    $0x5,%eax
      20:	77 09                	ja     2b <runcmd+0x2b>
      22:	8b 04 85 60 18 00 00 	mov    0x1860(,%eax,4),%eax
      29:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      2b:	c7 04 24 34 18 00 00 	movl   $0x1834,(%esp)
      32:	e8 77 06 00 00       	call   6ae <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      37:	8b 45 08             	mov    0x8(%ebp),%eax
      3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      40:	8b 40 04             	mov    0x4(%eax),%eax
      43:	85 c0                	test   %eax,%eax
      45:	75 0c                	jne    53 <runcmd+0x53>
      exit(0);
      47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      4e:	e8 6c 12 00 00       	call   12bf <exit>
    exec(ecmd->argv[0], ecmd->argv);
      53:	8b 45 f4             	mov    -0xc(%ebp),%eax
      56:	8d 50 04             	lea    0x4(%eax),%edx
      59:	8b 45 f4             	mov    -0xc(%ebp),%eax
      5c:	8b 40 04             	mov    0x4(%eax),%eax
      5f:	89 54 24 04          	mov    %edx,0x4(%esp)
      63:	89 04 24             	mov    %eax,(%esp)
      66:	e8 8c 12 00 00       	call   12f7 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      6e:	8b 40 04             	mov    0x4(%eax),%eax
      71:	89 44 24 08          	mov    %eax,0x8(%esp)
      75:	c7 44 24 04 3b 18 00 	movl   $0x183b,0x4(%esp)
      7c:	00 
      7d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      84:	e8 de 13 00 00       	call   1467 <printf>
    exit(-1);
      89:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
      90:	e8 2a 12 00 00       	call   12bf <exit>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      95:	8b 45 08             	mov    0x8(%ebp),%eax
      98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9e:	8b 40 14             	mov    0x14(%eax),%eax
      a1:	89 04 24             	mov    %eax,(%esp)
      a4:	e8 3e 12 00 00       	call   12e7 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
      ac:	8b 50 10             	mov    0x10(%eax),%edx
      af:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b2:	8b 40 08             	mov    0x8(%eax),%eax
      b5:	89 54 24 04          	mov    %edx,0x4(%esp)
      b9:	89 04 24             	mov    %eax,(%esp)
      bc:	e8 3e 12 00 00       	call   12ff <open>
      c1:	85 c0                	test   %eax,%eax
      c3:	79 2a                	jns    ef <runcmd+0xef>
      printf(2, "open %s failed\n", rcmd->file);
      c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
      c8:	8b 40 08             	mov    0x8(%eax),%eax
      cb:	89 44 24 08          	mov    %eax,0x8(%esp)
      cf:	c7 44 24 04 4b 18 00 	movl   $0x184b,0x4(%esp)
      d6:	00 
      d7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      de:	e8 84 13 00 00       	call   1467 <printf>
      exit(-1);
      e3:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
      ea:	e8 d0 11 00 00       	call   12bf <exit>
    }
    runcmd(rcmd->cmd);
      ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
      f2:	8b 40 04             	mov    0x4(%eax),%eax
      f5:	89 04 24             	mov    %eax,(%esp)
      f8:	e8 03 ff ff ff       	call   0 <runcmd>
    break;
      fd:	e9 32 01 00 00       	jmp    234 <runcmd+0x234>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     102:	8b 45 08             	mov    0x8(%ebp),%eax
     105:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
     108:	e8 ce 05 00 00       	call   6db <fork1>
     10d:	85 c0                	test   %eax,%eax
     10f:	75 0e                	jne    11f <runcmd+0x11f>
      runcmd(lcmd->left);
     111:	8b 45 ec             	mov    -0x14(%ebp),%eax
     114:	8b 40 04             	mov    0x4(%eax),%eax
     117:	89 04 24             	mov    %eax,(%esp)
     11a:	e8 e1 fe ff ff       	call   0 <runcmd>
    wait(&status);
     11f:	8d 45 d8             	lea    -0x28(%ebp),%eax
     122:	89 04 24             	mov    %eax,(%esp)
     125:	e8 9d 11 00 00       	call   12c7 <wait>
    runcmd(lcmd->right);
     12a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     12d:	8b 40 08             	mov    0x8(%eax),%eax
     130:	89 04 24             	mov    %eax,(%esp)
     133:	e8 c8 fe ff ff       	call   0 <runcmd>
    break;
     138:	e9 f7 00 00 00       	jmp    234 <runcmd+0x234>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     13d:	8b 45 08             	mov    0x8(%ebp),%eax
     140:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     143:	8d 45 dc             	lea    -0x24(%ebp),%eax
     146:	89 04 24             	mov    %eax,(%esp)
     149:	e8 81 11 00 00       	call   12cf <pipe>
     14e:	85 c0                	test   %eax,%eax
     150:	79 0c                	jns    15e <runcmd+0x15e>
      panic("pipe");
     152:	c7 04 24 5b 18 00 00 	movl   $0x185b,(%esp)
     159:	e8 50 05 00 00       	call   6ae <panic>
    if(fork1() == 0){
     15e:	e8 78 05 00 00       	call   6db <fork1>
     163:	85 c0                	test   %eax,%eax
     165:	75 3b                	jne    1a2 <runcmd+0x1a2>
      close(1);
     167:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     16e:	e8 74 11 00 00       	call   12e7 <close>
      dup(p[1]);
     173:	8b 45 e0             	mov    -0x20(%ebp),%eax
     176:	89 04 24             	mov    %eax,(%esp)
     179:	e8 b9 11 00 00       	call   1337 <dup>
      close(p[0]);
     17e:	8b 45 dc             	mov    -0x24(%ebp),%eax
     181:	89 04 24             	mov    %eax,(%esp)
     184:	e8 5e 11 00 00       	call   12e7 <close>
      close(p[1]);
     189:	8b 45 e0             	mov    -0x20(%ebp),%eax
     18c:	89 04 24             	mov    %eax,(%esp)
     18f:	e8 53 11 00 00       	call   12e7 <close>
      runcmd(pcmd->left);
     194:	8b 45 e8             	mov    -0x18(%ebp),%eax
     197:	8b 40 04             	mov    0x4(%eax),%eax
     19a:	89 04 24             	mov    %eax,(%esp)
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     1a2:	e8 34 05 00 00       	call   6db <fork1>
     1a7:	85 c0                	test   %eax,%eax
     1a9:	75 3b                	jne    1e6 <runcmd+0x1e6>
      close(0);
     1ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1b2:	e8 30 11 00 00       	call   12e7 <close>
      dup(p[0]);
     1b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1ba:	89 04 24             	mov    %eax,(%esp)
     1bd:	e8 75 11 00 00       	call   1337 <dup>
      close(p[0]);
     1c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c5:	89 04 24             	mov    %eax,(%esp)
     1c8:	e8 1a 11 00 00       	call   12e7 <close>
      close(p[1]);
     1cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d0:	89 04 24             	mov    %eax,(%esp)
     1d3:	e8 0f 11 00 00       	call   12e7 <close>
      runcmd(pcmd->right);
     1d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1db:	8b 40 08             	mov    0x8(%eax),%eax
     1de:	89 04 24             	mov    %eax,(%esp)
     1e1:	e8 1a fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1e9:	89 04 24             	mov    %eax,(%esp)
     1ec:	e8 f6 10 00 00       	call   12e7 <close>
    close(p[1]);
     1f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1f4:	89 04 24             	mov    %eax,(%esp)
     1f7:	e8 eb 10 00 00       	call   12e7 <close>
    wait(&status);
     1fc:	8d 45 d8             	lea    -0x28(%ebp),%eax
     1ff:	89 04 24             	mov    %eax,(%esp)
     202:	e8 c0 10 00 00       	call   12c7 <wait>
    wait(&status);
     207:	8d 45 d8             	lea    -0x28(%ebp),%eax
     20a:	89 04 24             	mov    %eax,(%esp)
     20d:	e8 b5 10 00 00       	call   12c7 <wait>
    break;
     212:	eb 20                	jmp    234 <runcmd+0x234>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     214:	8b 45 08             	mov    0x8(%ebp),%eax
     217:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     21a:	e8 bc 04 00 00       	call   6db <fork1>
     21f:	85 c0                	test   %eax,%eax
     221:	75 10                	jne    233 <runcmd+0x233>
      runcmd(bcmd->cmd);
     223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     226:	8b 40 04             	mov    0x4(%eax),%eax
     229:	89 04 24             	mov    %eax,(%esp)
     22c:	e8 cf fd ff ff       	call   0 <runcmd>
    break;
     231:	eb 00                	jmp    233 <runcmd+0x233>
     233:	90                   	nop
  }
  exit(0);
     234:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     23b:	e8 7f 10 00 00       	call   12bf <exit>

00000240 <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     240:	55                   	push   %ebp
     241:	89 e5                	mov    %esp,%ebp
     243:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     246:	c7 44 24 04 78 18 00 	movl   $0x1878,0x4(%esp)
     24d:	00 
     24e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     255:	e8 0d 12 00 00       	call   1467 <printf>
  memset(buf, 0, nbuf);
     25a:	8b 45 0c             	mov    0xc(%ebp),%eax
     25d:	89 44 24 08          	mov    %eax,0x8(%esp)
     261:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     268:	00 
     269:	8b 45 08             	mov    0x8(%ebp),%eax
     26c:	89 04 24             	mov    %eax,(%esp)
     26f:	e8 9e 0e 00 00       	call   1112 <memset>
  gets(buf, nbuf);
     274:	8b 45 0c             	mov    0xc(%ebp),%eax
     277:	89 44 24 04          	mov    %eax,0x4(%esp)
     27b:	8b 45 08             	mov    0x8(%ebp),%eax
     27e:	89 04 24             	mov    %eax,(%esp)
     281:	e8 e3 0e 00 00       	call   1169 <gets>
  if(buf[0] == 0) // EOF
     286:	8b 45 08             	mov    0x8(%ebp),%eax
     289:	0f b6 00             	movzbl (%eax),%eax
     28c:	84 c0                	test   %al,%al
     28e:	75 07                	jne    297 <getcmd+0x57>
    return -1;
     290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     295:	eb 05                	jmp    29c <getcmd+0x5c>
  return 0;
     297:	b8 00 00 00 00       	mov    $0x0,%eax
}
     29c:	c9                   	leave  
     29d:	c3                   	ret    

0000029e <main>:

int
main(void)
{
     29e:	55                   	push   %ebp
     29f:	89 e5                	mov    %esp,%ebp
     2a1:	83 e4 f0             	and    $0xfffffff0,%esp
     2a4:	83 ec 40             	sub    $0x40,%esp
  static char buf[100];
  int fd;
  int status;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2a7:	eb 15                	jmp    2be <main+0x20>
    if(fd >= 3){
     2a9:	83 7c 24 20 02       	cmpl   $0x2,0x20(%esp)
     2ae:	7e 0e                	jle    2be <main+0x20>
      close(fd);
     2b0:	8b 44 24 20          	mov    0x20(%esp),%eax
     2b4:	89 04 24             	mov    %eax,(%esp)
     2b7:	e8 2b 10 00 00       	call   12e7 <close>
      break;
     2bc:	eb 1f                	jmp    2dd <main+0x3f>
  static char buf[100];
  int fd;
  int status;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2be:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     2c5:	00 
     2c6:	c7 04 24 7b 18 00 00 	movl   $0x187b,(%esp)
     2cd:	e8 2d 10 00 00       	call   12ff <open>
     2d2:	89 44 24 20          	mov    %eax,0x20(%esp)
     2d6:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
     2db:	79 cc                	jns    2a9 <main+0xb>
      break;
    }
  }
  
  // Read and run input commands.
  int jobcntr = 0;
     2dd:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%esp)
     2e4:	00 
  struct joblist* jlist;
  jlist = malloc(sizeof(*jlist));
     2e5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     2ec:	e8 62 14 00 00       	call   1753 <malloc>
     2f1:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  jlist->first = 0;
     2f5:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     2f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  jlist->last = 0;
     2ff:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     303:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

  while(getcmd(buf, sizeof(buf)) >= 0){
     30a:	e9 77 03 00 00       	jmp    686 <main+0x3e8>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     30f:	0f b6 05 e0 1d 00 00 	movzbl 0x1de0,%eax
     316:	3c 63                	cmp    $0x63,%al
     318:	75 62                	jne    37c <main+0xde>
     31a:	0f b6 05 e1 1d 00 00 	movzbl 0x1de1,%eax
     321:	3c 64                	cmp    $0x64,%al
     323:	75 57                	jne    37c <main+0xde>
     325:	0f b6 05 e2 1d 00 00 	movzbl 0x1de2,%eax
     32c:	3c 20                	cmp    $0x20,%al
     32e:	75 4c                	jne    37c <main+0xde>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     330:	c7 04 24 e0 1d 00 00 	movl   $0x1de0,(%esp)
     337:	e8 af 0d 00 00       	call   10eb <strlen>
     33c:	83 e8 01             	sub    $0x1,%eax
     33f:	c6 80 e0 1d 00 00 00 	movb   $0x0,0x1de0(%eax)
      if(chdir(buf+3) < 0)
     346:	c7 04 24 e3 1d 00 00 	movl   $0x1de3,(%esp)
     34d:	e8 dd 0f 00 00       	call   132f <chdir>
     352:	85 c0                	test   %eax,%eax
     354:	79 21                	jns    377 <main+0xd9>
        printf(2, "cannot cd %s\n", buf+3);
     356:	c7 44 24 08 e3 1d 00 	movl   $0x1de3,0x8(%esp)
     35d:	00 
     35e:	c7 44 24 04 83 18 00 	movl   $0x1883,0x4(%esp)
     365:	00 
     366:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     36d:	e8 f5 10 00 00       	call   1467 <printf>
      continue;
     372:	e9 0f 03 00 00       	jmp    686 <main+0x3e8>
     377:	e9 0a 03 00 00       	jmp    686 <main+0x3e8>
    }



    if(buf[0] == 'j' && buf[1] == 'o' && buf[2] == 'b' && buf[3] == 's' && (buf[4] == '\n' || buf[4] == ' ')){
     37c:	0f b6 05 e0 1d 00 00 	movzbl 0x1de0,%eax
     383:	3c 6a                	cmp    $0x6a,%al
     385:	0f 85 39 01 00 00    	jne    4c4 <main+0x226>
     38b:	0f b6 05 e1 1d 00 00 	movzbl 0x1de1,%eax
     392:	3c 6f                	cmp    $0x6f,%al
     394:	0f 85 2a 01 00 00    	jne    4c4 <main+0x226>
     39a:	0f b6 05 e2 1d 00 00 	movzbl 0x1de2,%eax
     3a1:	3c 62                	cmp    $0x62,%al
     3a3:	0f 85 1b 01 00 00    	jne    4c4 <main+0x226>
     3a9:	0f b6 05 e3 1d 00 00 	movzbl 0x1de3,%eax
     3b0:	3c 73                	cmp    $0x73,%al
     3b2:	0f 85 0c 01 00 00    	jne    4c4 <main+0x226>
     3b8:	0f b6 05 e4 1d 00 00 	movzbl 0x1de4,%eax
     3bf:	3c 0a                	cmp    $0xa,%al
     3c1:	74 0f                	je     3d2 <main+0x134>
     3c3:	0f b6 05 e4 1d 00 00 	movzbl 0x1de4,%eax
     3ca:	3c 20                	cmp    $0x20,%al
     3cc:	0f 85 f2 00 00 00    	jne    4c4 <main+0x226>
    	struct job* job = jlist->first;
     3d2:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     3d6:	8b 00                	mov    (%eax),%eax
     3d8:	89 44 24 38          	mov    %eax,0x38(%esp)
    	while (job != 0) {
     3dc:	e9 b0 00 00 00       	jmp    491 <main+0x1f3>
    		//printf(1, "jobID:%d.\n",job->jid);
			if (!printjob(job->jid)) { //no processes - delete job.
     3e1:	8b 44 24 38          	mov    0x38(%esp),%eax
     3e5:	8b 00                	mov    (%eax),%eax
     3e7:	89 04 24             	mov    %eax,(%esp)
     3ea:	e8 78 0f 00 00       	call   1367 <printjob>
     3ef:	85 c0                	test   %eax,%eax
     3f1:	0f 85 8f 00 00 00    	jne    486 <main+0x1e8>
				if (jlist->first == job && jlist->last == job)
     3f7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     3fb:	8b 00                	mov    (%eax),%eax
     3fd:	3b 44 24 38          	cmp    0x38(%esp),%eax
     401:	75 17                	jne    41a <main+0x17c>
     403:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     407:	8b 40 04             	mov    0x4(%eax),%eax
     40a:	3b 44 24 38          	cmp    0x38(%esp),%eax
     40e:	75 0a                	jne    41a <main+0x17c>
					jlist->first = 0;
     410:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     414:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				if (jlist->first == job)
     41a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     41e:	8b 00                	mov    (%eax),%eax
     420:	3b 44 24 38          	cmp    0x38(%esp),%eax
     424:	75 0d                	jne    433 <main+0x195>
					jlist->first = job->next;
     426:	8b 44 24 38          	mov    0x38(%esp),%eax
     42a:	8b 50 44             	mov    0x44(%eax),%edx
     42d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     431:	89 10                	mov    %edx,(%eax)
				if (jlist->last == job)
     433:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     437:	8b 40 04             	mov    0x4(%eax),%eax
     43a:	3b 44 24 38          	cmp    0x38(%esp),%eax
     43e:	75 0e                	jne    44e <main+0x1b0>
					jlist->last = job->prev;
     440:	8b 44 24 38          	mov    0x38(%esp),%eax
     444:	8b 50 48             	mov    0x48(%eax),%edx
     447:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     44b:	89 50 04             	mov    %edx,0x4(%eax)
				if (job->prev)
     44e:	8b 44 24 38          	mov    0x38(%esp),%eax
     452:	8b 40 48             	mov    0x48(%eax),%eax
     455:	85 c0                	test   %eax,%eax
     457:	74 11                	je     46a <main+0x1cc>
					job->prev->next = job->next;
     459:	8b 44 24 38          	mov    0x38(%esp),%eax
     45d:	8b 40 48             	mov    0x48(%eax),%eax
     460:	8b 54 24 38          	mov    0x38(%esp),%edx
     464:	8b 52 44             	mov    0x44(%edx),%edx
     467:	89 50 44             	mov    %edx,0x44(%eax)
				if (job->next)
     46a:	8b 44 24 38          	mov    0x38(%esp),%eax
     46e:	8b 40 44             	mov    0x44(%eax),%eax
     471:	85 c0                	test   %eax,%eax
     473:	74 11                	je     486 <main+0x1e8>
					job->next->prev = job->prev;
     475:	8b 44 24 38          	mov    0x38(%esp),%eax
     479:	8b 40 44             	mov    0x44(%eax),%eax
     47c:	8b 54 24 38          	mov    0x38(%esp),%edx
     480:	8b 52 48             	mov    0x48(%edx),%edx
     483:	89 50 48             	mov    %edx,0x48(%eax)
			}
			job = job->next;
     486:	8b 44 24 38          	mov    0x38(%esp),%eax
     48a:	8b 40 44             	mov    0x44(%eax),%eax
     48d:	89 44 24 38          	mov    %eax,0x38(%esp)



    if(buf[0] == 'j' && buf[1] == 'o' && buf[2] == 'b' && buf[3] == 's' && (buf[4] == '\n' || buf[4] == ' ')){
    	struct job* job = jlist->first;
    	while (job != 0) {
     491:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
     496:	0f 85 45 ff ff ff    	jne    3e1 <main+0x143>
				if (job->next)
					job->next->prev = job->prev;
			}
			job = job->next;
		}
		if (!jlist->first)
     49c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     4a0:	8b 00                	mov    (%eax),%eax
     4a2:	85 c0                	test   %eax,%eax
     4a4:	75 19                	jne    4bf <main+0x221>
			printf(1, "There are no jobs.\n");
     4a6:	c7 44 24 04 91 18 00 	movl   $0x1891,0x4(%esp)
     4ad:	00 
     4ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4b5:	e8 ad 0f 00 00       	call   1467 <printf>
		continue;
     4ba:	e9 c7 01 00 00       	jmp    686 <main+0x3e8>
     4bf:	e9 c2 01 00 00       	jmp    686 <main+0x3e8>
	}

    if(buf[0] == 'f' && buf[1] == 'g' && (buf[2] == '\n' || buf[2] == ' ')){
     4c4:	0f b6 05 e0 1d 00 00 	movzbl 0x1de0,%eax
     4cb:	3c 66                	cmp    $0x66,%al
     4cd:	0f 85 97 00 00 00    	jne    56a <main+0x2cc>
     4d3:	0f b6 05 e1 1d 00 00 	movzbl 0x1de1,%eax
     4da:	3c 67                	cmp    $0x67,%al
     4dc:	0f 85 88 00 00 00    	jne    56a <main+0x2cc>
     4e2:	0f b6 05 e2 1d 00 00 	movzbl 0x1de2,%eax
     4e9:	3c 0a                	cmp    $0xa,%al
     4eb:	74 0b                	je     4f8 <main+0x25a>
     4ed:	0f b6 05 e2 1d 00 00 	movzbl 0x1de2,%eax
     4f4:	3c 20                	cmp    $0x20,%al
     4f6:	75 72                	jne    56a <main+0x2cc>
    			char* c = &buf[2];
     4f8:	c7 44 24 34 e2 1d 00 	movl   $0x1de2,0x34(%esp)
     4ff:	00 
    			while (*c == ' ')
     500:	eb 05                	jmp    507 <main+0x269>
    				++c;
     502:	83 44 24 34 01       	addl   $0x1,0x34(%esp)
		continue;
	}

    if(buf[0] == 'f' && buf[1] == 'g' && (buf[2] == '\n' || buf[2] == ' ')){
    			char* c = &buf[2];
    			while (*c == ' ')
     507:	8b 44 24 34          	mov    0x34(%esp),%eax
     50b:	0f b6 00             	movzbl (%eax),%eax
     50e:	3c 20                	cmp    $0x20,%al
     510:	74 f0                	je     502 <main+0x264>
    				++c;
    			int jid = 0;
     512:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
     519:	00 
    			while (*c != ' ' && *c != '\n'){
     51a:	eb 27                	jmp    543 <main+0x2a5>
    				jid = jid*10;
     51c:	8b 54 24 30          	mov    0x30(%esp),%edx
     520:	89 d0                	mov    %edx,%eax
     522:	c1 e0 02             	shl    $0x2,%eax
     525:	01 d0                	add    %edx,%eax
     527:	01 c0                	add    %eax,%eax
     529:	89 44 24 30          	mov    %eax,0x30(%esp)
    				jid += (int)*c - 48;
     52d:	8b 44 24 34          	mov    0x34(%esp),%eax
     531:	0f b6 00             	movzbl (%eax),%eax
     534:	0f be c0             	movsbl %al,%eax
     537:	83 e8 30             	sub    $0x30,%eax
     53a:	01 44 24 30          	add    %eax,0x30(%esp)
    				++c;
     53e:	83 44 24 34 01       	addl   $0x1,0x34(%esp)
    if(buf[0] == 'f' && buf[1] == 'g' && (buf[2] == '\n' || buf[2] == ' ')){
    			char* c = &buf[2];
    			while (*c == ' ')
    				++c;
    			int jid = 0;
    			while (*c != ' ' && *c != '\n'){
     543:	8b 44 24 34          	mov    0x34(%esp),%eax
     547:	0f b6 00             	movzbl (%eax),%eax
     54a:	3c 20                	cmp    $0x20,%al
     54c:	74 0b                	je     559 <main+0x2bb>
     54e:	8b 44 24 34          	mov    0x34(%esp),%eax
     552:	0f b6 00             	movzbl (%eax),%eax
     555:	3c 0a                	cmp    $0xa,%al
     557:	75 c3                	jne    51c <main+0x27e>
    				jid = jid*10;
    				jid += (int)*c - 48;
    				++c;
    			}
    			fg(jid);
     559:	8b 44 24 30          	mov    0x30(%esp),%eax
     55d:	89 04 24             	mov    %eax,(%esp)
     560:	e8 12 0e 00 00       	call   1377 <fg>
    			continue;
     565:	e9 1c 01 00 00       	jmp    686 <main+0x3e8>
    		}

    struct job* job;
	job = malloc(sizeof(*job));
     56a:	c7 04 24 4c 00 00 00 	movl   $0x4c,(%esp)
     571:	e8 dd 11 00 00       	call   1753 <malloc>
     576:	89 44 24 18          	mov    %eax,0x18(%esp)
	memset(job, 0, sizeof(*job));
     57a:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
     581:	00 
     582:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     589:	00 
     58a:	8b 44 24 18          	mov    0x18(%esp),%eax
     58e:	89 04 24             	mov    %eax,(%esp)
     591:	e8 7c 0b 00 00       	call   1112 <memset>
	job->jid = ++jobcntr;
     596:	83 44 24 3c 01       	addl   $0x1,0x3c(%esp)
     59b:	8b 44 24 18          	mov    0x18(%esp),%eax
     59f:	8b 54 24 3c          	mov    0x3c(%esp),%edx
     5a3:	89 10                	mov    %edx,(%eax)

	char* s = job->cmd;
     5a5:	8b 44 24 18          	mov    0x18(%esp),%eax
     5a9:	83 c0 04             	add    $0x4,%eax
     5ac:	89 44 24 2c          	mov    %eax,0x2c(%esp)
	char* t = buf;
     5b0:	c7 44 24 28 e0 1d 00 	movl   $0x1de0,0x28(%esp)
     5b7:	00 
	int i = sizeof(buf);
     5b8:	c7 44 24 24 64 00 00 	movl   $0x64,0x24(%esp)
     5bf:	00 
	while(--i > 0 && *t != '\n' && (*s++ = *t++) != 0) ;
     5c0:	83 6c 24 24 01       	subl   $0x1,0x24(%esp)
     5c5:	83 7c 24 24 00       	cmpl   $0x0,0x24(%esp)
     5ca:	7e 2d                	jle    5f9 <main+0x35b>
     5cc:	8b 44 24 28          	mov    0x28(%esp),%eax
     5d0:	0f b6 00             	movzbl (%eax),%eax
     5d3:	3c 0a                	cmp    $0xa,%al
     5d5:	74 22                	je     5f9 <main+0x35b>
     5d7:	8b 44 24 2c          	mov    0x2c(%esp),%eax
     5db:	8d 50 01             	lea    0x1(%eax),%edx
     5de:	89 54 24 2c          	mov    %edx,0x2c(%esp)
     5e2:	8b 54 24 28          	mov    0x28(%esp),%edx
     5e6:	8d 4a 01             	lea    0x1(%edx),%ecx
     5e9:	89 4c 24 28          	mov    %ecx,0x28(%esp)
     5ed:	0f b6 12             	movzbl (%edx),%edx
     5f0:	88 10                	mov    %dl,(%eax)
     5f2:	0f b6 00             	movzbl (%eax),%eax
     5f5:	84 c0                	test   %al,%al
     5f7:	75 c7                	jne    5c0 <main+0x322>
	*s = 0;
     5f9:	8b 44 24 2c          	mov    0x2c(%esp),%eax
     5fd:	c6 00 00             	movb   $0x0,(%eax)
	if(fork1() == 0) {
     600:	e8 d6 00 00 00       	call   6db <fork1>
     605:	85 c0                	test   %eax,%eax
     607:	75 29                	jne    632 <main+0x394>
		attachjob(getpid(), job);
     609:	e8 31 0d 00 00       	call   133f <getpid>
     60e:	8b 54 24 18          	mov    0x18(%esp),%edx
     612:	89 54 24 04          	mov    %edx,0x4(%esp)
     616:	89 04 24             	mov    %eax,(%esp)
     619:	e8 51 0d 00 00       	call   136f <attachjob>
		runcmd(parsecmd(buf));
     61e:	c7 04 24 e0 1d 00 00 	movl   $0x1de0,(%esp)
     625:	e8 26 04 00 00       	call   a50 <parsecmd>
     62a:	89 04 24             	mov    %eax,(%esp)
     62d:	e8 ce f9 ff ff       	call   0 <runcmd>
	}
	if (jlist->first == 0) {
     632:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     636:	8b 00                	mov    (%eax),%eax
     638:	85 c0                	test   %eax,%eax
     63a:	75 17                	jne    653 <main+0x3b5>
		jlist->first = job;
     63c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     640:	8b 54 24 18          	mov    0x18(%esp),%edx
     644:	89 10                	mov    %edx,(%eax)
		jlist->last = job;
     646:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     64a:	8b 54 24 18          	mov    0x18(%esp),%edx
     64e:	89 50 04             	mov    %edx,0x4(%eax)
     651:	eb 27                	jmp    67a <main+0x3dc>
	} else {
		job->prev = jlist->last;
     653:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     657:	8b 50 04             	mov    0x4(%eax),%edx
     65a:	8b 44 24 18          	mov    0x18(%esp),%eax
     65e:	89 50 48             	mov    %edx,0x48(%eax)
		jlist->last->next = job;
     661:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     665:	8b 40 04             	mov    0x4(%eax),%eax
     668:	8b 54 24 18          	mov    0x18(%esp),%edx
     66c:	89 50 44             	mov    %edx,0x44(%eax)
		jlist->last = job;
     66f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     673:	8b 54 24 18          	mov    0x18(%esp),%edx
     677:	89 50 04             	mov    %edx,0x4(%eax)
	}
    wait(&status);
     67a:	8d 44 24 14          	lea    0x14(%esp),%eax
     67e:	89 04 24             	mov    %eax,(%esp)
     681:	e8 41 0c 00 00       	call   12c7 <wait>
  struct joblist* jlist;
  jlist = malloc(sizeof(*jlist));
  jlist->first = 0;
  jlist->last = 0;

  while(getcmd(buf, sizeof(buf)) >= 0){
     686:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     68d:	00 
     68e:	c7 04 24 e0 1d 00 00 	movl   $0x1de0,(%esp)
     695:	e8 a6 fb ff ff       	call   240 <getcmd>
     69a:	85 c0                	test   %eax,%eax
     69c:	0f 89 6d fc ff ff    	jns    30f <main+0x71>
		jlist->last->next = job;
		jlist->last = job;
	}
    wait(&status);
  }
  exit(0);
     6a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     6a9:	e8 11 0c 00 00       	call   12bf <exit>

000006ae <panic>:
}

void
panic(char *s)
{
     6ae:	55                   	push   %ebp
     6af:	89 e5                	mov    %esp,%ebp
     6b1:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     6b4:	8b 45 08             	mov    0x8(%ebp),%eax
     6b7:	89 44 24 08          	mov    %eax,0x8(%esp)
     6bb:	c7 44 24 04 a5 18 00 	movl   $0x18a5,0x4(%esp)
     6c2:	00 
     6c3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     6ca:	e8 98 0d 00 00       	call   1467 <printf>
  exit(0);
     6cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     6d6:	e8 e4 0b 00 00       	call   12bf <exit>

000006db <fork1>:
}

int
fork1(void)
{
     6db:	55                   	push   %ebp
     6dc:	89 e5                	mov    %esp,%ebp
     6de:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     6e1:	e8 d1 0b 00 00       	call   12b7 <fork>
     6e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     6e9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     6ed:	75 0c                	jne    6fb <fork1+0x20>
    panic("fork");
     6ef:	c7 04 24 a9 18 00 00 	movl   $0x18a9,(%esp)
     6f6:	e8 b3 ff ff ff       	call   6ae <panic>
  return pid;
     6fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     6fe:	c9                   	leave  
     6ff:	c3                   	ret    

00000700 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     700:	55                   	push   %ebp
     701:	89 e5                	mov    %esp,%ebp
     703:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     706:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     70d:	e8 41 10 00 00       	call   1753 <malloc>
     712:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     715:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     71c:	00 
     71d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     724:	00 
     725:	8b 45 f4             	mov    -0xc(%ebp),%eax
     728:	89 04 24             	mov    %eax,(%esp)
     72b:	e8 e2 09 00 00       	call   1112 <memset>
  cmd->type = EXEC;
     730:	8b 45 f4             	mov    -0xc(%ebp),%eax
     733:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     739:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     73c:	c9                   	leave  
     73d:	c3                   	ret    

0000073e <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     73e:	55                   	push   %ebp
     73f:	89 e5                	mov    %esp,%ebp
     741:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     744:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     74b:	e8 03 10 00 00       	call   1753 <malloc>
     750:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     753:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     75a:	00 
     75b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     762:	00 
     763:	8b 45 f4             	mov    -0xc(%ebp),%eax
     766:	89 04 24             	mov    %eax,(%esp)
     769:	e8 a4 09 00 00       	call   1112 <memset>
  cmd->type = REDIR;
     76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     771:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     777:	8b 45 f4             	mov    -0xc(%ebp),%eax
     77a:	8b 55 08             	mov    0x8(%ebp),%edx
     77d:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     780:	8b 45 f4             	mov    -0xc(%ebp),%eax
     783:	8b 55 0c             	mov    0xc(%ebp),%edx
     786:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     789:	8b 45 f4             	mov    -0xc(%ebp),%eax
     78c:	8b 55 10             	mov    0x10(%ebp),%edx
     78f:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     792:	8b 45 f4             	mov    -0xc(%ebp),%eax
     795:	8b 55 14             	mov    0x14(%ebp),%edx
     798:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     79e:	8b 55 18             	mov    0x18(%ebp),%edx
     7a1:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     7a7:	c9                   	leave  
     7a8:	c3                   	ret    

000007a9 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     7a9:	55                   	push   %ebp
     7aa:	89 e5                	mov    %esp,%ebp
     7ac:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7af:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     7b6:	e8 98 0f 00 00       	call   1753 <malloc>
     7bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     7be:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     7c5:	00 
     7c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     7cd:	00 
     7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7d1:	89 04 24             	mov    %eax,(%esp)
     7d4:	e8 39 09 00 00       	call   1112 <memset>
  cmd->type = PIPE;
     7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7dc:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7e5:	8b 55 08             	mov    0x8(%ebp),%edx
     7e8:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ee:	8b 55 0c             	mov    0xc(%ebp),%edx
     7f1:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     7f7:	c9                   	leave  
     7f8:	c3                   	ret    

000007f9 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     7f9:	55                   	push   %ebp
     7fa:	89 e5                	mov    %esp,%ebp
     7fc:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7ff:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     806:	e8 48 0f 00 00       	call   1753 <malloc>
     80b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     80e:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     815:	00 
     816:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     81d:	00 
     81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     821:	89 04 24             	mov    %eax,(%esp)
     824:	e8 e9 08 00 00       	call   1112 <memset>
  cmd->type = LIST;
     829:	8b 45 f4             	mov    -0xc(%ebp),%eax
     82c:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     832:	8b 45 f4             	mov    -0xc(%ebp),%eax
     835:	8b 55 08             	mov    0x8(%ebp),%edx
     838:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     83e:	8b 55 0c             	mov    0xc(%ebp),%edx
     841:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     844:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     847:	c9                   	leave  
     848:	c3                   	ret    

00000849 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     849:	55                   	push   %ebp
     84a:	89 e5                	mov    %esp,%ebp
     84c:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     84f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     856:	e8 f8 0e 00 00       	call   1753 <malloc>
     85b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     85e:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     865:	00 
     866:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     86d:	00 
     86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     871:	89 04 24             	mov    %eax,(%esp)
     874:	e8 99 08 00 00       	call   1112 <memset>
  cmd->type = BACK;
     879:	8b 45 f4             	mov    -0xc(%ebp),%eax
     87c:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     882:	8b 45 f4             	mov    -0xc(%ebp),%eax
     885:	8b 55 08             	mov    0x8(%ebp),%edx
     888:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     88e:	c9                   	leave  
     88f:	c3                   	ret    

00000890 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     890:	55                   	push   %ebp
     891:	89 e5                	mov    %esp,%ebp
     893:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
     896:	8b 45 08             	mov    0x8(%ebp),%eax
     899:	8b 00                	mov    (%eax),%eax
     89b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     89e:	eb 04                	jmp    8a4 <gettoken+0x14>
    s++;
     8a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     8a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
     8aa:	73 1d                	jae    8c9 <gettoken+0x39>
     8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8af:	0f b6 00             	movzbl (%eax),%eax
     8b2:	0f be c0             	movsbl %al,%eax
     8b5:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b9:	c7 04 24 c0 1d 00 00 	movl   $0x1dc0,(%esp)
     8c0:	e8 71 08 00 00       	call   1136 <strchr>
     8c5:	85 c0                	test   %eax,%eax
     8c7:	75 d7                	jne    8a0 <gettoken+0x10>
    s++;
  if(q)
     8c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     8cd:	74 08                	je     8d7 <gettoken+0x47>
    *q = s;
     8cf:	8b 45 10             	mov    0x10(%ebp),%eax
     8d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8d5:	89 10                	mov    %edx,(%eax)
  ret = *s;
     8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8da:	0f b6 00             	movzbl (%eax),%eax
     8dd:	0f be c0             	movsbl %al,%eax
     8e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     8e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8e6:	0f b6 00             	movzbl (%eax),%eax
     8e9:	0f be c0             	movsbl %al,%eax
     8ec:	83 f8 29             	cmp    $0x29,%eax
     8ef:	7f 14                	jg     905 <gettoken+0x75>
     8f1:	83 f8 28             	cmp    $0x28,%eax
     8f4:	7d 28                	jge    91e <gettoken+0x8e>
     8f6:	85 c0                	test   %eax,%eax
     8f8:	0f 84 94 00 00 00    	je     992 <gettoken+0x102>
     8fe:	83 f8 26             	cmp    $0x26,%eax
     901:	74 1b                	je     91e <gettoken+0x8e>
     903:	eb 3c                	jmp    941 <gettoken+0xb1>
     905:	83 f8 3e             	cmp    $0x3e,%eax
     908:	74 1a                	je     924 <gettoken+0x94>
     90a:	83 f8 3e             	cmp    $0x3e,%eax
     90d:	7f 0a                	jg     919 <gettoken+0x89>
     90f:	83 e8 3b             	sub    $0x3b,%eax
     912:	83 f8 01             	cmp    $0x1,%eax
     915:	77 2a                	ja     941 <gettoken+0xb1>
     917:	eb 05                	jmp    91e <gettoken+0x8e>
     919:	83 f8 7c             	cmp    $0x7c,%eax
     91c:	75 23                	jne    941 <gettoken+0xb1>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     91e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     922:	eb 6f                	jmp    993 <gettoken+0x103>
  case '>':
    s++;
     924:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     928:	8b 45 f4             	mov    -0xc(%ebp),%eax
     92b:	0f b6 00             	movzbl (%eax),%eax
     92e:	3c 3e                	cmp    $0x3e,%al
     930:	75 0d                	jne    93f <gettoken+0xaf>
      ret = '+';
     932:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     939:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     93d:	eb 54                	jmp    993 <gettoken+0x103>
     93f:	eb 52                	jmp    993 <gettoken+0x103>
  default:
    ret = 'a';
     941:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     948:	eb 04                	jmp    94e <gettoken+0xbe>
      s++;
     94a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     94e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     951:	3b 45 0c             	cmp    0xc(%ebp),%eax
     954:	73 3a                	jae    990 <gettoken+0x100>
     956:	8b 45 f4             	mov    -0xc(%ebp),%eax
     959:	0f b6 00             	movzbl (%eax),%eax
     95c:	0f be c0             	movsbl %al,%eax
     95f:	89 44 24 04          	mov    %eax,0x4(%esp)
     963:	c7 04 24 c0 1d 00 00 	movl   $0x1dc0,(%esp)
     96a:	e8 c7 07 00 00       	call   1136 <strchr>
     96f:	85 c0                	test   %eax,%eax
     971:	75 1d                	jne    990 <gettoken+0x100>
     973:	8b 45 f4             	mov    -0xc(%ebp),%eax
     976:	0f b6 00             	movzbl (%eax),%eax
     979:	0f be c0             	movsbl %al,%eax
     97c:	89 44 24 04          	mov    %eax,0x4(%esp)
     980:	c7 04 24 c6 1d 00 00 	movl   $0x1dc6,(%esp)
     987:	e8 aa 07 00 00       	call   1136 <strchr>
     98c:	85 c0                	test   %eax,%eax
     98e:	74 ba                	je     94a <gettoken+0xba>
      s++;
    break;
     990:	eb 01                	jmp    993 <gettoken+0x103>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     992:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     993:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     997:	74 0a                	je     9a3 <gettoken+0x113>
    *eq = s;
     999:	8b 45 14             	mov    0x14(%ebp),%eax
     99c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     99f:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     9a1:	eb 06                	jmp    9a9 <gettoken+0x119>
     9a3:	eb 04                	jmp    9a9 <gettoken+0x119>
    s++;
     9a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     9a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
     9af:	73 1d                	jae    9ce <gettoken+0x13e>
     9b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9b4:	0f b6 00             	movzbl (%eax),%eax
     9b7:	0f be c0             	movsbl %al,%eax
     9ba:	89 44 24 04          	mov    %eax,0x4(%esp)
     9be:	c7 04 24 c0 1d 00 00 	movl   $0x1dc0,(%esp)
     9c5:	e8 6c 07 00 00       	call   1136 <strchr>
     9ca:	85 c0                	test   %eax,%eax
     9cc:	75 d7                	jne    9a5 <gettoken+0x115>
    s++;
  *ps = s;
     9ce:	8b 45 08             	mov    0x8(%ebp),%eax
     9d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9d4:	89 10                	mov    %edx,(%eax)
  return ret;
     9d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     9d9:	c9                   	leave  
     9da:	c3                   	ret    

000009db <peek>:

int
peek(char **ps, char *es, char *toks)
{
     9db:	55                   	push   %ebp
     9dc:	89 e5                	mov    %esp,%ebp
     9de:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
     9e1:	8b 45 08             	mov    0x8(%ebp),%eax
     9e4:	8b 00                	mov    (%eax),%eax
     9e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     9e9:	eb 04                	jmp    9ef <peek+0x14>
    s++;
     9eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
     9f5:	73 1d                	jae    a14 <peek+0x39>
     9f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9fa:	0f b6 00             	movzbl (%eax),%eax
     9fd:	0f be c0             	movsbl %al,%eax
     a00:	89 44 24 04          	mov    %eax,0x4(%esp)
     a04:	c7 04 24 c0 1d 00 00 	movl   $0x1dc0,(%esp)
     a0b:	e8 26 07 00 00       	call   1136 <strchr>
     a10:	85 c0                	test   %eax,%eax
     a12:	75 d7                	jne    9eb <peek+0x10>
    s++;
  *ps = s;
     a14:	8b 45 08             	mov    0x8(%ebp),%eax
     a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a1a:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a1f:	0f b6 00             	movzbl (%eax),%eax
     a22:	84 c0                	test   %al,%al
     a24:	74 23                	je     a49 <peek+0x6e>
     a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a29:	0f b6 00             	movzbl (%eax),%eax
     a2c:	0f be c0             	movsbl %al,%eax
     a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a33:	8b 45 10             	mov    0x10(%ebp),%eax
     a36:	89 04 24             	mov    %eax,(%esp)
     a39:	e8 f8 06 00 00       	call   1136 <strchr>
     a3e:	85 c0                	test   %eax,%eax
     a40:	74 07                	je     a49 <peek+0x6e>
     a42:	b8 01 00 00 00       	mov    $0x1,%eax
     a47:	eb 05                	jmp    a4e <peek+0x73>
     a49:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a4e:	c9                   	leave  
     a4f:	c3                   	ret    

00000a50 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     a50:	55                   	push   %ebp
     a51:	89 e5                	mov    %esp,%ebp
     a53:	53                   	push   %ebx
     a54:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a5a:	8b 45 08             	mov    0x8(%ebp),%eax
     a5d:	89 04 24             	mov    %eax,(%esp)
     a60:	e8 86 06 00 00       	call   10eb <strlen>
     a65:	01 d8                	add    %ebx,%eax
     a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
     a71:	8d 45 08             	lea    0x8(%ebp),%eax
     a74:	89 04 24             	mov    %eax,(%esp)
     a77:	e8 60 00 00 00       	call   adc <parseline>
     a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     a7f:	c7 44 24 08 ae 18 00 	movl   $0x18ae,0x8(%esp)
     a86:	00 
     a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
     a8e:	8d 45 08             	lea    0x8(%ebp),%eax
     a91:	89 04 24             	mov    %eax,(%esp)
     a94:	e8 42 ff ff ff       	call   9db <peek>
  if(s != es){
     a99:	8b 45 08             	mov    0x8(%ebp),%eax
     a9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     a9f:	74 27                	je     ac8 <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     aa1:	8b 45 08             	mov    0x8(%ebp),%eax
     aa4:	89 44 24 08          	mov    %eax,0x8(%esp)
     aa8:	c7 44 24 04 af 18 00 	movl   $0x18af,0x4(%esp)
     aaf:	00 
     ab0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     ab7:	e8 ab 09 00 00       	call   1467 <printf>
    panic("syntax");
     abc:	c7 04 24 be 18 00 00 	movl   $0x18be,(%esp)
     ac3:	e8 e6 fb ff ff       	call   6ae <panic>
  }
  nulterminate(cmd);
     ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     acb:	89 04 24             	mov    %eax,(%esp)
     ace:	e8 a3 04 00 00       	call   f76 <nulterminate>
  return cmd;
     ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ad6:	83 c4 24             	add    $0x24,%esp
     ad9:	5b                   	pop    %ebx
     ada:	5d                   	pop    %ebp
     adb:	c3                   	ret    

00000adc <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     adc:	55                   	push   %ebp
     add:	89 e5                	mov    %esp,%ebp
     adf:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
     ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae9:	8b 45 08             	mov    0x8(%ebp),%eax
     aec:	89 04 24             	mov    %eax,(%esp)
     aef:	e8 bc 00 00 00       	call   bb0 <parsepipe>
     af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     af7:	eb 30                	jmp    b29 <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     af9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     b00:	00 
     b01:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     b08:	00 
     b09:	8b 45 0c             	mov    0xc(%ebp),%eax
     b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
     b10:	8b 45 08             	mov    0x8(%ebp),%eax
     b13:	89 04 24             	mov    %eax,(%esp)
     b16:	e8 75 fd ff ff       	call   890 <gettoken>
    cmd = backcmd(cmd);
     b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b1e:	89 04 24             	mov    %eax,(%esp)
     b21:	e8 23 fd ff ff       	call   849 <backcmd>
     b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     b29:	c7 44 24 08 c5 18 00 	movl   $0x18c5,0x8(%esp)
     b30:	00 
     b31:	8b 45 0c             	mov    0xc(%ebp),%eax
     b34:	89 44 24 04          	mov    %eax,0x4(%esp)
     b38:	8b 45 08             	mov    0x8(%ebp),%eax
     b3b:	89 04 24             	mov    %eax,(%esp)
     b3e:	e8 98 fe ff ff       	call   9db <peek>
     b43:	85 c0                	test   %eax,%eax
     b45:	75 b2                	jne    af9 <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     b47:	c7 44 24 08 c7 18 00 	movl   $0x18c7,0x8(%esp)
     b4e:	00 
     b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
     b52:	89 44 24 04          	mov    %eax,0x4(%esp)
     b56:	8b 45 08             	mov    0x8(%ebp),%eax
     b59:	89 04 24             	mov    %eax,(%esp)
     b5c:	e8 7a fe ff ff       	call   9db <peek>
     b61:	85 c0                	test   %eax,%eax
     b63:	74 46                	je     bab <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     b65:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     b6c:	00 
     b6d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     b74:	00 
     b75:	8b 45 0c             	mov    0xc(%ebp),%eax
     b78:	89 44 24 04          	mov    %eax,0x4(%esp)
     b7c:	8b 45 08             	mov    0x8(%ebp),%eax
     b7f:	89 04 24             	mov    %eax,(%esp)
     b82:	e8 09 fd ff ff       	call   890 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     b87:	8b 45 0c             	mov    0xc(%ebp),%eax
     b8a:	89 44 24 04          	mov    %eax,0x4(%esp)
     b8e:	8b 45 08             	mov    0x8(%ebp),%eax
     b91:	89 04 24             	mov    %eax,(%esp)
     b94:	e8 43 ff ff ff       	call   adc <parseline>
     b99:	89 44 24 04          	mov    %eax,0x4(%esp)
     b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ba0:	89 04 24             	mov    %eax,(%esp)
     ba3:	e8 51 fc ff ff       	call   7f9 <listcmd>
     ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     bae:	c9                   	leave  
     baf:	c3                   	ret    

00000bb0 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     bb0:	55                   	push   %ebp
     bb1:	89 e5                	mov    %esp,%ebp
     bb3:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb9:	89 44 24 04          	mov    %eax,0x4(%esp)
     bbd:	8b 45 08             	mov    0x8(%ebp),%eax
     bc0:	89 04 24             	mov    %eax,(%esp)
     bc3:	e8 68 02 00 00       	call   e30 <parseexec>
     bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     bcb:	c7 44 24 08 c9 18 00 	movl   $0x18c9,0x8(%esp)
     bd2:	00 
     bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
     bda:	8b 45 08             	mov    0x8(%ebp),%eax
     bdd:	89 04 24             	mov    %eax,(%esp)
     be0:	e8 f6 fd ff ff       	call   9db <peek>
     be5:	85 c0                	test   %eax,%eax
     be7:	74 46                	je     c2f <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     be9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     bf0:	00 
     bf1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     bf8:	00 
     bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
     bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
     c00:	8b 45 08             	mov    0x8(%ebp),%eax
     c03:	89 04 24             	mov    %eax,(%esp)
     c06:	e8 85 fc ff ff       	call   890 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
     c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
     c12:	8b 45 08             	mov    0x8(%ebp),%eax
     c15:	89 04 24             	mov    %eax,(%esp)
     c18:	e8 93 ff ff ff       	call   bb0 <parsepipe>
     c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
     c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c24:	89 04 24             	mov    %eax,(%esp)
     c27:	e8 7d fb ff ff       	call   7a9 <pipecmd>
     c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     c32:	c9                   	leave  
     c33:	c3                   	ret    

00000c34 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     c34:	55                   	push   %ebp
     c35:	89 e5                	mov    %esp,%ebp
     c37:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     c3a:	e9 f6 00 00 00       	jmp    d35 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     c3f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     c46:	00 
     c47:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     c4e:	00 
     c4f:	8b 45 10             	mov    0x10(%ebp),%eax
     c52:	89 44 24 04          	mov    %eax,0x4(%esp)
     c56:	8b 45 0c             	mov    0xc(%ebp),%eax
     c59:	89 04 24             	mov    %eax,(%esp)
     c5c:	e8 2f fc ff ff       	call   890 <gettoken>
     c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     c64:	8d 45 ec             	lea    -0x14(%ebp),%eax
     c67:	89 44 24 0c          	mov    %eax,0xc(%esp)
     c6b:	8d 45 f0             	lea    -0x10(%ebp),%eax
     c6e:	89 44 24 08          	mov    %eax,0x8(%esp)
     c72:	8b 45 10             	mov    0x10(%ebp),%eax
     c75:	89 44 24 04          	mov    %eax,0x4(%esp)
     c79:	8b 45 0c             	mov    0xc(%ebp),%eax
     c7c:	89 04 24             	mov    %eax,(%esp)
     c7f:	e8 0c fc ff ff       	call   890 <gettoken>
     c84:	83 f8 61             	cmp    $0x61,%eax
     c87:	74 0c                	je     c95 <parseredirs+0x61>
      panic("missing file for redirection");
     c89:	c7 04 24 cb 18 00 00 	movl   $0x18cb,(%esp)
     c90:	e8 19 fa ff ff       	call   6ae <panic>
    switch(tok){
     c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c98:	83 f8 3c             	cmp    $0x3c,%eax
     c9b:	74 0f                	je     cac <parseredirs+0x78>
     c9d:	83 f8 3e             	cmp    $0x3e,%eax
     ca0:	74 38                	je     cda <parseredirs+0xa6>
     ca2:	83 f8 2b             	cmp    $0x2b,%eax
     ca5:	74 61                	je     d08 <parseredirs+0xd4>
     ca7:	e9 89 00 00 00       	jmp    d35 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     cac:	8b 55 ec             	mov    -0x14(%ebp),%edx
     caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cb2:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     cb9:	00 
     cba:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     cc1:	00 
     cc2:	89 54 24 08          	mov    %edx,0x8(%esp)
     cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
     cca:	8b 45 08             	mov    0x8(%ebp),%eax
     ccd:	89 04 24             	mov    %eax,(%esp)
     cd0:	e8 69 fa ff ff       	call   73e <redircmd>
     cd5:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     cd8:	eb 5b                	jmp    d35 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     cda:	8b 55 ec             	mov    -0x14(%ebp),%edx
     cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ce0:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     ce7:	00 
     ce8:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     cef:	00 
     cf0:	89 54 24 08          	mov    %edx,0x8(%esp)
     cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
     cf8:	8b 45 08             	mov    0x8(%ebp),%eax
     cfb:	89 04 24             	mov    %eax,(%esp)
     cfe:	e8 3b fa ff ff       	call   73e <redircmd>
     d03:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     d06:	eb 2d                	jmp    d35 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     d08:	8b 55 ec             	mov    -0x14(%ebp),%edx
     d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d0e:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     d15:	00 
     d16:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     d1d:	00 
     d1e:	89 54 24 08          	mov    %edx,0x8(%esp)
     d22:	89 44 24 04          	mov    %eax,0x4(%esp)
     d26:	8b 45 08             	mov    0x8(%ebp),%eax
     d29:	89 04 24             	mov    %eax,(%esp)
     d2c:	e8 0d fa ff ff       	call   73e <redircmd>
     d31:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     d34:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     d35:	c7 44 24 08 e8 18 00 	movl   $0x18e8,0x8(%esp)
     d3c:	00 
     d3d:	8b 45 10             	mov    0x10(%ebp),%eax
     d40:	89 44 24 04          	mov    %eax,0x4(%esp)
     d44:	8b 45 0c             	mov    0xc(%ebp),%eax
     d47:	89 04 24             	mov    %eax,(%esp)
     d4a:	e8 8c fc ff ff       	call   9db <peek>
     d4f:	85 c0                	test   %eax,%eax
     d51:	0f 85 e8 fe ff ff    	jne    c3f <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     d57:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d5a:	c9                   	leave  
     d5b:	c3                   	ret    

00000d5c <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     d5c:	55                   	push   %ebp
     d5d:	89 e5                	mov    %esp,%ebp
     d5f:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     d62:	c7 44 24 08 eb 18 00 	movl   $0x18eb,0x8(%esp)
     d69:	00 
     d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
     d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
     d71:	8b 45 08             	mov    0x8(%ebp),%eax
     d74:	89 04 24             	mov    %eax,(%esp)
     d77:	e8 5f fc ff ff       	call   9db <peek>
     d7c:	85 c0                	test   %eax,%eax
     d7e:	75 0c                	jne    d8c <parseblock+0x30>
    panic("parseblock");
     d80:	c7 04 24 ed 18 00 00 	movl   $0x18ed,(%esp)
     d87:	e8 22 f9 ff ff       	call   6ae <panic>
  gettoken(ps, es, 0, 0);
     d8c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     d93:	00 
     d94:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     d9b:	00 
     d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
     d9f:	89 44 24 04          	mov    %eax,0x4(%esp)
     da3:	8b 45 08             	mov    0x8(%ebp),%eax
     da6:	89 04 24             	mov    %eax,(%esp)
     da9:	e8 e2 fa ff ff       	call   890 <gettoken>
  cmd = parseline(ps, es);
     dae:	8b 45 0c             	mov    0xc(%ebp),%eax
     db1:	89 44 24 04          	mov    %eax,0x4(%esp)
     db5:	8b 45 08             	mov    0x8(%ebp),%eax
     db8:	89 04 24             	mov    %eax,(%esp)
     dbb:	e8 1c fd ff ff       	call   adc <parseline>
     dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     dc3:	c7 44 24 08 f8 18 00 	movl   $0x18f8,0x8(%esp)
     dca:	00 
     dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
     dce:	89 44 24 04          	mov    %eax,0x4(%esp)
     dd2:	8b 45 08             	mov    0x8(%ebp),%eax
     dd5:	89 04 24             	mov    %eax,(%esp)
     dd8:	e8 fe fb ff ff       	call   9db <peek>
     ddd:	85 c0                	test   %eax,%eax
     ddf:	75 0c                	jne    ded <parseblock+0x91>
    panic("syntax - missing )");
     de1:	c7 04 24 fa 18 00 00 	movl   $0x18fa,(%esp)
     de8:	e8 c1 f8 ff ff       	call   6ae <panic>
  gettoken(ps, es, 0, 0);
     ded:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     df4:	00 
     df5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     dfc:	00 
     dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
     e00:	89 44 24 04          	mov    %eax,0x4(%esp)
     e04:	8b 45 08             	mov    0x8(%ebp),%eax
     e07:	89 04 24             	mov    %eax,(%esp)
     e0a:	e8 81 fa ff ff       	call   890 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
     e12:	89 44 24 08          	mov    %eax,0x8(%esp)
     e16:	8b 45 08             	mov    0x8(%ebp),%eax
     e19:	89 44 24 04          	mov    %eax,0x4(%esp)
     e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e20:	89 04 24             	mov    %eax,(%esp)
     e23:	e8 0c fe ff ff       	call   c34 <parseredirs>
     e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     e2e:	c9                   	leave  
     e2f:	c3                   	ret    

00000e30 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     e30:	55                   	push   %ebp
     e31:	89 e5                	mov    %esp,%ebp
     e33:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     e36:	c7 44 24 08 eb 18 00 	movl   $0x18eb,0x8(%esp)
     e3d:	00 
     e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
     e41:	89 44 24 04          	mov    %eax,0x4(%esp)
     e45:	8b 45 08             	mov    0x8(%ebp),%eax
     e48:	89 04 24             	mov    %eax,(%esp)
     e4b:	e8 8b fb ff ff       	call   9db <peek>
     e50:	85 c0                	test   %eax,%eax
     e52:	74 17                	je     e6b <parseexec+0x3b>
    return parseblock(ps, es);
     e54:	8b 45 0c             	mov    0xc(%ebp),%eax
     e57:	89 44 24 04          	mov    %eax,0x4(%esp)
     e5b:	8b 45 08             	mov    0x8(%ebp),%eax
     e5e:	89 04 24             	mov    %eax,(%esp)
     e61:	e8 f6 fe ff ff       	call   d5c <parseblock>
     e66:	e9 09 01 00 00       	jmp    f74 <parseexec+0x144>

  ret = execcmd();
     e6b:	e8 90 f8 ff ff       	call   700 <execcmd>
     e70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e76:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     e79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     e80:	8b 45 0c             	mov    0xc(%ebp),%eax
     e83:	89 44 24 08          	mov    %eax,0x8(%esp)
     e87:	8b 45 08             	mov    0x8(%ebp),%eax
     e8a:	89 44 24 04          	mov    %eax,0x4(%esp)
     e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e91:	89 04 24             	mov    %eax,(%esp)
     e94:	e8 9b fd ff ff       	call   c34 <parseredirs>
     e99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     e9c:	e9 8f 00 00 00       	jmp    f30 <parseexec+0x100>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     ea1:	8d 45 e0             	lea    -0x20(%ebp),%eax
     ea4:	89 44 24 0c          	mov    %eax,0xc(%esp)
     ea8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     eab:	89 44 24 08          	mov    %eax,0x8(%esp)
     eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb2:	89 44 24 04          	mov    %eax,0x4(%esp)
     eb6:	8b 45 08             	mov    0x8(%ebp),%eax
     eb9:	89 04 24             	mov    %eax,(%esp)
     ebc:	e8 cf f9 ff ff       	call   890 <gettoken>
     ec1:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ec4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ec8:	75 05                	jne    ecf <parseexec+0x9f>
      break;
     eca:	e9 83 00 00 00       	jmp    f52 <parseexec+0x122>
    if(tok != 'a')
     ecf:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     ed3:	74 0c                	je     ee1 <parseexec+0xb1>
      panic("syntax");
     ed5:	c7 04 24 be 18 00 00 	movl   $0x18be,(%esp)
     edc:	e8 cd f7 ff ff       	call   6ae <panic>
    cmd->argv[argc] = q;
     ee1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     eea:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     eee:	8b 55 e0             	mov    -0x20(%ebp),%edx
     ef1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ef4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     ef7:	83 c1 08             	add    $0x8,%ecx
     efa:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     efe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     f02:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     f06:	7e 0c                	jle    f14 <parseexec+0xe4>
      panic("too many args");
     f08:	c7 04 24 0d 19 00 00 	movl   $0x190d,(%esp)
     f0f:	e8 9a f7 ff ff       	call   6ae <panic>
    ret = parseredirs(ret, ps, es);
     f14:	8b 45 0c             	mov    0xc(%ebp),%eax
     f17:	89 44 24 08          	mov    %eax,0x8(%esp)
     f1b:	8b 45 08             	mov    0x8(%ebp),%eax
     f1e:	89 44 24 04          	mov    %eax,0x4(%esp)
     f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f25:	89 04 24             	mov    %eax,(%esp)
     f28:	e8 07 fd ff ff       	call   c34 <parseredirs>
     f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     f30:	c7 44 24 08 1b 19 00 	movl   $0x191b,0x8(%esp)
     f37:	00 
     f38:	8b 45 0c             	mov    0xc(%ebp),%eax
     f3b:	89 44 24 04          	mov    %eax,0x4(%esp)
     f3f:	8b 45 08             	mov    0x8(%ebp),%eax
     f42:	89 04 24             	mov    %eax,(%esp)
     f45:	e8 91 fa ff ff       	call   9db <peek>
     f4a:	85 c0                	test   %eax,%eax
     f4c:	0f 84 4f ff ff ff    	je     ea1 <parseexec+0x71>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     f52:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f58:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     f5f:	00 
  cmd->eargv[argc] = 0;
     f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f63:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f66:	83 c2 08             	add    $0x8,%edx
     f69:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     f70:	00 
  return ret;
     f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f74:	c9                   	leave  
     f75:	c3                   	ret    

00000f76 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     f76:	55                   	push   %ebp
     f77:	89 e5                	mov    %esp,%ebp
     f79:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     f7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f80:	75 0a                	jne    f8c <nulterminate+0x16>
    return 0;
     f82:	b8 00 00 00 00       	mov    $0x0,%eax
     f87:	e9 c9 00 00 00       	jmp    1055 <nulterminate+0xdf>
  
  switch(cmd->type){
     f8c:	8b 45 08             	mov    0x8(%ebp),%eax
     f8f:	8b 00                	mov    (%eax),%eax
     f91:	83 f8 05             	cmp    $0x5,%eax
     f94:	0f 87 b8 00 00 00    	ja     1052 <nulterminate+0xdc>
     f9a:	8b 04 85 20 19 00 00 	mov    0x1920(,%eax,4),%eax
     fa1:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     fa3:	8b 45 08             	mov    0x8(%ebp),%eax
     fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     fa9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     fb0:	eb 14                	jmp    fc6 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
     fb8:	83 c2 08             	add    $0x8,%edx
     fbb:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     fbf:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     fc2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     fcc:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     fd0:	85 c0                	test   %eax,%eax
     fd2:	75 de                	jne    fb2 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     fd4:	eb 7c                	jmp    1052 <nulterminate+0xdc>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     fd6:	8b 45 08             	mov    0x8(%ebp),%eax
     fd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fdf:	8b 40 04             	mov    0x4(%eax),%eax
     fe2:	89 04 24             	mov    %eax,(%esp)
     fe5:	e8 8c ff ff ff       	call   f76 <nulterminate>
    *rcmd->efile = 0;
     fea:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fed:	8b 40 0c             	mov    0xc(%eax),%eax
     ff0:	c6 00 00             	movb   $0x0,(%eax)
    break;
     ff3:	eb 5d                	jmp    1052 <nulterminate+0xdc>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     ff5:	8b 45 08             	mov    0x8(%ebp),%eax
     ff8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     ffb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ffe:	8b 40 04             	mov    0x4(%eax),%eax
    1001:	89 04 24             	mov    %eax,(%esp)
    1004:	e8 6d ff ff ff       	call   f76 <nulterminate>
    nulterminate(pcmd->right);
    1009:	8b 45 e8             	mov    -0x18(%ebp),%eax
    100c:	8b 40 08             	mov    0x8(%eax),%eax
    100f:	89 04 24             	mov    %eax,(%esp)
    1012:	e8 5f ff ff ff       	call   f76 <nulterminate>
    break;
    1017:	eb 39                	jmp    1052 <nulterminate+0xdc>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
    1019:	8b 45 08             	mov    0x8(%ebp),%eax
    101c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
    101f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1022:	8b 40 04             	mov    0x4(%eax),%eax
    1025:	89 04 24             	mov    %eax,(%esp)
    1028:	e8 49 ff ff ff       	call   f76 <nulterminate>
    nulterminate(lcmd->right);
    102d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1030:	8b 40 08             	mov    0x8(%eax),%eax
    1033:	89 04 24             	mov    %eax,(%esp)
    1036:	e8 3b ff ff ff       	call   f76 <nulterminate>
    break;
    103b:	eb 15                	jmp    1052 <nulterminate+0xdc>

  case BACK:
    bcmd = (struct backcmd*)cmd;
    103d:	8b 45 08             	mov    0x8(%ebp),%eax
    1040:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
    1043:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1046:	8b 40 04             	mov    0x4(%eax),%eax
    1049:	89 04 24             	mov    %eax,(%esp)
    104c:	e8 25 ff ff ff       	call   f76 <nulterminate>
    break;
    1051:	90                   	nop
  }
  return cmd;
    1052:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1055:	c9                   	leave  
    1056:	c3                   	ret    

00001057 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1057:	55                   	push   %ebp
    1058:	89 e5                	mov    %esp,%ebp
    105a:	57                   	push   %edi
    105b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    105c:	8b 4d 08             	mov    0x8(%ebp),%ecx
    105f:	8b 55 10             	mov    0x10(%ebp),%edx
    1062:	8b 45 0c             	mov    0xc(%ebp),%eax
    1065:	89 cb                	mov    %ecx,%ebx
    1067:	89 df                	mov    %ebx,%edi
    1069:	89 d1                	mov    %edx,%ecx
    106b:	fc                   	cld    
    106c:	f3 aa                	rep stos %al,%es:(%edi)
    106e:	89 ca                	mov    %ecx,%edx
    1070:	89 fb                	mov    %edi,%ebx
    1072:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1075:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1078:	5b                   	pop    %ebx
    1079:	5f                   	pop    %edi
    107a:	5d                   	pop    %ebp
    107b:	c3                   	ret    

0000107c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    107c:	55                   	push   %ebp
    107d:	89 e5                	mov    %esp,%ebp
    107f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1082:	8b 45 08             	mov    0x8(%ebp),%eax
    1085:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1088:	90                   	nop
    1089:	8b 45 08             	mov    0x8(%ebp),%eax
    108c:	8d 50 01             	lea    0x1(%eax),%edx
    108f:	89 55 08             	mov    %edx,0x8(%ebp)
    1092:	8b 55 0c             	mov    0xc(%ebp),%edx
    1095:	8d 4a 01             	lea    0x1(%edx),%ecx
    1098:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    109b:	0f b6 12             	movzbl (%edx),%edx
    109e:	88 10                	mov    %dl,(%eax)
    10a0:	0f b6 00             	movzbl (%eax),%eax
    10a3:	84 c0                	test   %al,%al
    10a5:	75 e2                	jne    1089 <strcpy+0xd>
    ;
  return os;
    10a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10aa:	c9                   	leave  
    10ab:	c3                   	ret    

000010ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10ac:	55                   	push   %ebp
    10ad:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10af:	eb 08                	jmp    10b9 <strcmp+0xd>
    p++, q++;
    10b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10b5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10b9:	8b 45 08             	mov    0x8(%ebp),%eax
    10bc:	0f b6 00             	movzbl (%eax),%eax
    10bf:	84 c0                	test   %al,%al
    10c1:	74 10                	je     10d3 <strcmp+0x27>
    10c3:	8b 45 08             	mov    0x8(%ebp),%eax
    10c6:	0f b6 10             	movzbl (%eax),%edx
    10c9:	8b 45 0c             	mov    0xc(%ebp),%eax
    10cc:	0f b6 00             	movzbl (%eax),%eax
    10cf:	38 c2                	cmp    %al,%dl
    10d1:	74 de                	je     10b1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10d3:	8b 45 08             	mov    0x8(%ebp),%eax
    10d6:	0f b6 00             	movzbl (%eax),%eax
    10d9:	0f b6 d0             	movzbl %al,%edx
    10dc:	8b 45 0c             	mov    0xc(%ebp),%eax
    10df:	0f b6 00             	movzbl (%eax),%eax
    10e2:	0f b6 c0             	movzbl %al,%eax
    10e5:	29 c2                	sub    %eax,%edx
    10e7:	89 d0                	mov    %edx,%eax
}
    10e9:	5d                   	pop    %ebp
    10ea:	c3                   	ret    

000010eb <strlen>:

uint
strlen(char *s)
{
    10eb:	55                   	push   %ebp
    10ec:	89 e5                	mov    %esp,%ebp
    10ee:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10f8:	eb 04                	jmp    10fe <strlen+0x13>
    10fa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    10fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1101:	8b 45 08             	mov    0x8(%ebp),%eax
    1104:	01 d0                	add    %edx,%eax
    1106:	0f b6 00             	movzbl (%eax),%eax
    1109:	84 c0                	test   %al,%al
    110b:	75 ed                	jne    10fa <strlen+0xf>
    ;
  return n;
    110d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1110:	c9                   	leave  
    1111:	c3                   	ret    

00001112 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1112:	55                   	push   %ebp
    1113:	89 e5                	mov    %esp,%ebp
    1115:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1118:	8b 45 10             	mov    0x10(%ebp),%eax
    111b:	89 44 24 08          	mov    %eax,0x8(%esp)
    111f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1122:	89 44 24 04          	mov    %eax,0x4(%esp)
    1126:	8b 45 08             	mov    0x8(%ebp),%eax
    1129:	89 04 24             	mov    %eax,(%esp)
    112c:	e8 26 ff ff ff       	call   1057 <stosb>
  return dst;
    1131:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1134:	c9                   	leave  
    1135:	c3                   	ret    

00001136 <strchr>:

char*
strchr(const char *s, char c)
{
    1136:	55                   	push   %ebp
    1137:	89 e5                	mov    %esp,%ebp
    1139:	83 ec 04             	sub    $0x4,%esp
    113c:	8b 45 0c             	mov    0xc(%ebp),%eax
    113f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1142:	eb 14                	jmp    1158 <strchr+0x22>
    if(*s == c)
    1144:	8b 45 08             	mov    0x8(%ebp),%eax
    1147:	0f b6 00             	movzbl (%eax),%eax
    114a:	3a 45 fc             	cmp    -0x4(%ebp),%al
    114d:	75 05                	jne    1154 <strchr+0x1e>
      return (char*)s;
    114f:	8b 45 08             	mov    0x8(%ebp),%eax
    1152:	eb 13                	jmp    1167 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1154:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1158:	8b 45 08             	mov    0x8(%ebp),%eax
    115b:	0f b6 00             	movzbl (%eax),%eax
    115e:	84 c0                	test   %al,%al
    1160:	75 e2                	jne    1144 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1162:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1167:	c9                   	leave  
    1168:	c3                   	ret    

00001169 <gets>:

char*
gets(char *buf, int max)
{
    1169:	55                   	push   %ebp
    116a:	89 e5                	mov    %esp,%ebp
    116c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    116f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1176:	eb 4c                	jmp    11c4 <gets+0x5b>
    cc = read(0, &c, 1);
    1178:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    117f:	00 
    1180:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1183:	89 44 24 04          	mov    %eax,0x4(%esp)
    1187:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    118e:	e8 44 01 00 00       	call   12d7 <read>
    1193:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1196:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    119a:	7f 02                	jg     119e <gets+0x35>
      break;
    119c:	eb 31                	jmp    11cf <gets+0x66>
    buf[i++] = c;
    119e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11a1:	8d 50 01             	lea    0x1(%eax),%edx
    11a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11a7:	89 c2                	mov    %eax,%edx
    11a9:	8b 45 08             	mov    0x8(%ebp),%eax
    11ac:	01 c2                	add    %eax,%edx
    11ae:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11b2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11b4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11b8:	3c 0a                	cmp    $0xa,%al
    11ba:	74 13                	je     11cf <gets+0x66>
    11bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c0:	3c 0d                	cmp    $0xd,%al
    11c2:	74 0b                	je     11cf <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11c7:	83 c0 01             	add    $0x1,%eax
    11ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11cd:	7c a9                	jl     1178 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11d2:	8b 45 08             	mov    0x8(%ebp),%eax
    11d5:	01 d0                	add    %edx,%eax
    11d7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11da:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11dd:	c9                   	leave  
    11de:	c3                   	ret    

000011df <stat>:

int
stat(char *n, struct stat *st)
{
    11df:	55                   	push   %ebp
    11e0:	89 e5                	mov    %esp,%ebp
    11e2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11ec:	00 
    11ed:	8b 45 08             	mov    0x8(%ebp),%eax
    11f0:	89 04 24             	mov    %eax,(%esp)
    11f3:	e8 07 01 00 00       	call   12ff <open>
    11f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11ff:	79 07                	jns    1208 <stat+0x29>
    return -1;
    1201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1206:	eb 23                	jmp    122b <stat+0x4c>
  r = fstat(fd, st);
    1208:	8b 45 0c             	mov    0xc(%ebp),%eax
    120b:	89 44 24 04          	mov    %eax,0x4(%esp)
    120f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1212:	89 04 24             	mov    %eax,(%esp)
    1215:	e8 fd 00 00 00       	call   1317 <fstat>
    121a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    121d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1220:	89 04 24             	mov    %eax,(%esp)
    1223:	e8 bf 00 00 00       	call   12e7 <close>
  return r;
    1228:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    122b:	c9                   	leave  
    122c:	c3                   	ret    

0000122d <atoi>:

int
atoi(const char *s)
{
    122d:	55                   	push   %ebp
    122e:	89 e5                	mov    %esp,%ebp
    1230:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1233:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    123a:	eb 25                	jmp    1261 <atoi+0x34>
    n = n*10 + *s++ - '0';
    123c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    123f:	89 d0                	mov    %edx,%eax
    1241:	c1 e0 02             	shl    $0x2,%eax
    1244:	01 d0                	add    %edx,%eax
    1246:	01 c0                	add    %eax,%eax
    1248:	89 c1                	mov    %eax,%ecx
    124a:	8b 45 08             	mov    0x8(%ebp),%eax
    124d:	8d 50 01             	lea    0x1(%eax),%edx
    1250:	89 55 08             	mov    %edx,0x8(%ebp)
    1253:	0f b6 00             	movzbl (%eax),%eax
    1256:	0f be c0             	movsbl %al,%eax
    1259:	01 c8                	add    %ecx,%eax
    125b:	83 e8 30             	sub    $0x30,%eax
    125e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1261:	8b 45 08             	mov    0x8(%ebp),%eax
    1264:	0f b6 00             	movzbl (%eax),%eax
    1267:	3c 2f                	cmp    $0x2f,%al
    1269:	7e 0a                	jle    1275 <atoi+0x48>
    126b:	8b 45 08             	mov    0x8(%ebp),%eax
    126e:	0f b6 00             	movzbl (%eax),%eax
    1271:	3c 39                	cmp    $0x39,%al
    1273:	7e c7                	jle    123c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1275:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1278:	c9                   	leave  
    1279:	c3                   	ret    

0000127a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    127a:	55                   	push   %ebp
    127b:	89 e5                	mov    %esp,%ebp
    127d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1280:	8b 45 08             	mov    0x8(%ebp),%eax
    1283:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1286:	8b 45 0c             	mov    0xc(%ebp),%eax
    1289:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    128c:	eb 17                	jmp    12a5 <memmove+0x2b>
    *dst++ = *src++;
    128e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1291:	8d 50 01             	lea    0x1(%eax),%edx
    1294:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1297:	8b 55 f8             	mov    -0x8(%ebp),%edx
    129a:	8d 4a 01             	lea    0x1(%edx),%ecx
    129d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12a0:	0f b6 12             	movzbl (%edx),%edx
    12a3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12a5:	8b 45 10             	mov    0x10(%ebp),%eax
    12a8:	8d 50 ff             	lea    -0x1(%eax),%edx
    12ab:	89 55 10             	mov    %edx,0x10(%ebp)
    12ae:	85 c0                	test   %eax,%eax
    12b0:	7f dc                	jg     128e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12b5:	c9                   	leave  
    12b6:	c3                   	ret    

000012b7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12b7:	b8 01 00 00 00       	mov    $0x1,%eax
    12bc:	cd 40                	int    $0x40
    12be:	c3                   	ret    

000012bf <exit>:
SYSCALL(exit)
    12bf:	b8 02 00 00 00       	mov    $0x2,%eax
    12c4:	cd 40                	int    $0x40
    12c6:	c3                   	ret    

000012c7 <wait>:
SYSCALL(wait)
    12c7:	b8 03 00 00 00       	mov    $0x3,%eax
    12cc:	cd 40                	int    $0x40
    12ce:	c3                   	ret    

000012cf <pipe>:
SYSCALL(pipe)
    12cf:	b8 04 00 00 00       	mov    $0x4,%eax
    12d4:	cd 40                	int    $0x40
    12d6:	c3                   	ret    

000012d7 <read>:
SYSCALL(read)
    12d7:	b8 05 00 00 00       	mov    $0x5,%eax
    12dc:	cd 40                	int    $0x40
    12de:	c3                   	ret    

000012df <write>:
SYSCALL(write)
    12df:	b8 10 00 00 00       	mov    $0x10,%eax
    12e4:	cd 40                	int    $0x40
    12e6:	c3                   	ret    

000012e7 <close>:
SYSCALL(close)
    12e7:	b8 15 00 00 00       	mov    $0x15,%eax
    12ec:	cd 40                	int    $0x40
    12ee:	c3                   	ret    

000012ef <kill>:
SYSCALL(kill)
    12ef:	b8 06 00 00 00       	mov    $0x6,%eax
    12f4:	cd 40                	int    $0x40
    12f6:	c3                   	ret    

000012f7 <exec>:
SYSCALL(exec)
    12f7:	b8 07 00 00 00       	mov    $0x7,%eax
    12fc:	cd 40                	int    $0x40
    12fe:	c3                   	ret    

000012ff <open>:
SYSCALL(open)
    12ff:	b8 0f 00 00 00       	mov    $0xf,%eax
    1304:	cd 40                	int    $0x40
    1306:	c3                   	ret    

00001307 <mknod>:
SYSCALL(mknod)
    1307:	b8 11 00 00 00       	mov    $0x11,%eax
    130c:	cd 40                	int    $0x40
    130e:	c3                   	ret    

0000130f <unlink>:
SYSCALL(unlink)
    130f:	b8 12 00 00 00       	mov    $0x12,%eax
    1314:	cd 40                	int    $0x40
    1316:	c3                   	ret    

00001317 <fstat>:
SYSCALL(fstat)
    1317:	b8 08 00 00 00       	mov    $0x8,%eax
    131c:	cd 40                	int    $0x40
    131e:	c3                   	ret    

0000131f <link>:
SYSCALL(link)
    131f:	b8 13 00 00 00       	mov    $0x13,%eax
    1324:	cd 40                	int    $0x40
    1326:	c3                   	ret    

00001327 <mkdir>:
SYSCALL(mkdir)
    1327:	b8 14 00 00 00       	mov    $0x14,%eax
    132c:	cd 40                	int    $0x40
    132e:	c3                   	ret    

0000132f <chdir>:
SYSCALL(chdir)
    132f:	b8 09 00 00 00       	mov    $0x9,%eax
    1334:	cd 40                	int    $0x40
    1336:	c3                   	ret    

00001337 <dup>:
SYSCALL(dup)
    1337:	b8 0a 00 00 00       	mov    $0xa,%eax
    133c:	cd 40                	int    $0x40
    133e:	c3                   	ret    

0000133f <getpid>:
SYSCALL(getpid)
    133f:	b8 0b 00 00 00       	mov    $0xb,%eax
    1344:	cd 40                	int    $0x40
    1346:	c3                   	ret    

00001347 <sbrk>:
SYSCALL(sbrk)
    1347:	b8 0c 00 00 00       	mov    $0xc,%eax
    134c:	cd 40                	int    $0x40
    134e:	c3                   	ret    

0000134f <sleep>:
SYSCALL(sleep)
    134f:	b8 0d 00 00 00       	mov    $0xd,%eax
    1354:	cd 40                	int    $0x40
    1356:	c3                   	ret    

00001357 <uptime>:
SYSCALL(uptime)
    1357:	b8 0e 00 00 00       	mov    $0xe,%eax
    135c:	cd 40                	int    $0x40
    135e:	c3                   	ret    

0000135f <pstat>:
SYSCALL(pstat)
    135f:	b8 16 00 00 00       	mov    $0x16,%eax
    1364:	cd 40                	int    $0x40
    1366:	c3                   	ret    

00001367 <printjob>:
SYSCALL(printjob)
    1367:	b8 17 00 00 00       	mov    $0x17,%eax
    136c:	cd 40                	int    $0x40
    136e:	c3                   	ret    

0000136f <attachjob>:
SYSCALL(attachjob)
    136f:	b8 18 00 00 00       	mov    $0x18,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <fg>:
SYSCALL (fg)
    1377:	b8 19 00 00 00       	mov    $0x19,%eax
    137c:	cd 40                	int    $0x40
    137e:	c3                   	ret    

0000137f <waitpid>:
SYSCALL(waitpid)
    137f:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1384:	cd 40                	int    $0x40
    1386:	c3                   	ret    

00001387 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1387:	55                   	push   %ebp
    1388:	89 e5                	mov    %esp,%ebp
    138a:	83 ec 18             	sub    $0x18,%esp
    138d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1390:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1393:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    139a:	00 
    139b:	8d 45 f4             	lea    -0xc(%ebp),%eax
    139e:	89 44 24 04          	mov    %eax,0x4(%esp)
    13a2:	8b 45 08             	mov    0x8(%ebp),%eax
    13a5:	89 04 24             	mov    %eax,(%esp)
    13a8:	e8 32 ff ff ff       	call   12df <write>
}
    13ad:	c9                   	leave  
    13ae:	c3                   	ret    

000013af <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13af:	55                   	push   %ebp
    13b0:	89 e5                	mov    %esp,%ebp
    13b2:	56                   	push   %esi
    13b3:	53                   	push   %ebx
    13b4:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13be:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13c2:	74 17                	je     13db <printint+0x2c>
    13c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13c8:	79 11                	jns    13db <printint+0x2c>
    neg = 1;
    13ca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13d1:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d4:	f7 d8                	neg    %eax
    13d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13d9:	eb 06                	jmp    13e1 <printint+0x32>
  } else {
    x = xx;
    13db:	8b 45 0c             	mov    0xc(%ebp),%eax
    13de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13e8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13eb:	8d 41 01             	lea    0x1(%ecx),%eax
    13ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13f7:	ba 00 00 00 00       	mov    $0x0,%edx
    13fc:	f7 f3                	div    %ebx
    13fe:	89 d0                	mov    %edx,%eax
    1400:	0f b6 80 ce 1d 00 00 	movzbl 0x1dce(%eax),%eax
    1407:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    140b:	8b 75 10             	mov    0x10(%ebp),%esi
    140e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1411:	ba 00 00 00 00       	mov    $0x0,%edx
    1416:	f7 f6                	div    %esi
    1418:	89 45 ec             	mov    %eax,-0x14(%ebp)
    141b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    141f:	75 c7                	jne    13e8 <printint+0x39>
  if(neg)
    1421:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1425:	74 10                	je     1437 <printint+0x88>
    buf[i++] = '-';
    1427:	8b 45 f4             	mov    -0xc(%ebp),%eax
    142a:	8d 50 01             	lea    0x1(%eax),%edx
    142d:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1430:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1435:	eb 1f                	jmp    1456 <printint+0xa7>
    1437:	eb 1d                	jmp    1456 <printint+0xa7>
    putc(fd, buf[i]);
    1439:	8d 55 dc             	lea    -0x24(%ebp),%edx
    143c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    143f:	01 d0                	add    %edx,%eax
    1441:	0f b6 00             	movzbl (%eax),%eax
    1444:	0f be c0             	movsbl %al,%eax
    1447:	89 44 24 04          	mov    %eax,0x4(%esp)
    144b:	8b 45 08             	mov    0x8(%ebp),%eax
    144e:	89 04 24             	mov    %eax,(%esp)
    1451:	e8 31 ff ff ff       	call   1387 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1456:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    145a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    145e:	79 d9                	jns    1439 <printint+0x8a>
    putc(fd, buf[i]);
}
    1460:	83 c4 30             	add    $0x30,%esp
    1463:	5b                   	pop    %ebx
    1464:	5e                   	pop    %esi
    1465:	5d                   	pop    %ebp
    1466:	c3                   	ret    

00001467 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1467:	55                   	push   %ebp
    1468:	89 e5                	mov    %esp,%ebp
    146a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    146d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1474:	8d 45 0c             	lea    0xc(%ebp),%eax
    1477:	83 c0 04             	add    $0x4,%eax
    147a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    147d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1484:	e9 7c 01 00 00       	jmp    1605 <printf+0x19e>
    c = fmt[i] & 0xff;
    1489:	8b 55 0c             	mov    0xc(%ebp),%edx
    148c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    148f:	01 d0                	add    %edx,%eax
    1491:	0f b6 00             	movzbl (%eax),%eax
    1494:	0f be c0             	movsbl %al,%eax
    1497:	25 ff 00 00 00       	and    $0xff,%eax
    149c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    149f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14a3:	75 2c                	jne    14d1 <printf+0x6a>
      if(c == '%'){
    14a5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14a9:	75 0c                	jne    14b7 <printf+0x50>
        state = '%';
    14ab:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14b2:	e9 4a 01 00 00       	jmp    1601 <printf+0x19a>
      } else {
        putc(fd, c);
    14b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14ba:	0f be c0             	movsbl %al,%eax
    14bd:	89 44 24 04          	mov    %eax,0x4(%esp)
    14c1:	8b 45 08             	mov    0x8(%ebp),%eax
    14c4:	89 04 24             	mov    %eax,(%esp)
    14c7:	e8 bb fe ff ff       	call   1387 <putc>
    14cc:	e9 30 01 00 00       	jmp    1601 <printf+0x19a>
      }
    } else if(state == '%'){
    14d1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14d5:	0f 85 26 01 00 00    	jne    1601 <printf+0x19a>
      if(c == 'd'){
    14db:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14df:	75 2d                	jne    150e <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14e4:	8b 00                	mov    (%eax),%eax
    14e6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14ed:	00 
    14ee:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14f5:	00 
    14f6:	89 44 24 04          	mov    %eax,0x4(%esp)
    14fa:	8b 45 08             	mov    0x8(%ebp),%eax
    14fd:	89 04 24             	mov    %eax,(%esp)
    1500:	e8 aa fe ff ff       	call   13af <printint>
        ap++;
    1505:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1509:	e9 ec 00 00 00       	jmp    15fa <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    150e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1512:	74 06                	je     151a <printf+0xb3>
    1514:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1518:	75 2d                	jne    1547 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    151a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    151d:	8b 00                	mov    (%eax),%eax
    151f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1526:	00 
    1527:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    152e:	00 
    152f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1533:	8b 45 08             	mov    0x8(%ebp),%eax
    1536:	89 04 24             	mov    %eax,(%esp)
    1539:	e8 71 fe ff ff       	call   13af <printint>
        ap++;
    153e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1542:	e9 b3 00 00 00       	jmp    15fa <printf+0x193>
      } else if(c == 's'){
    1547:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    154b:	75 45                	jne    1592 <printf+0x12b>
        s = (char*)*ap;
    154d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1550:	8b 00                	mov    (%eax),%eax
    1552:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1555:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1559:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    155d:	75 09                	jne    1568 <printf+0x101>
          s = "(null)";
    155f:	c7 45 f4 38 19 00 00 	movl   $0x1938,-0xc(%ebp)
        while(*s != 0){
    1566:	eb 1e                	jmp    1586 <printf+0x11f>
    1568:	eb 1c                	jmp    1586 <printf+0x11f>
          putc(fd, *s);
    156a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    156d:	0f b6 00             	movzbl (%eax),%eax
    1570:	0f be c0             	movsbl %al,%eax
    1573:	89 44 24 04          	mov    %eax,0x4(%esp)
    1577:	8b 45 08             	mov    0x8(%ebp),%eax
    157a:	89 04 24             	mov    %eax,(%esp)
    157d:	e8 05 fe ff ff       	call   1387 <putc>
          s++;
    1582:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1586:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1589:	0f b6 00             	movzbl (%eax),%eax
    158c:	84 c0                	test   %al,%al
    158e:	75 da                	jne    156a <printf+0x103>
    1590:	eb 68                	jmp    15fa <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1592:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1596:	75 1d                	jne    15b5 <printf+0x14e>
        putc(fd, *ap);
    1598:	8b 45 e8             	mov    -0x18(%ebp),%eax
    159b:	8b 00                	mov    (%eax),%eax
    159d:	0f be c0             	movsbl %al,%eax
    15a0:	89 44 24 04          	mov    %eax,0x4(%esp)
    15a4:	8b 45 08             	mov    0x8(%ebp),%eax
    15a7:	89 04 24             	mov    %eax,(%esp)
    15aa:	e8 d8 fd ff ff       	call   1387 <putc>
        ap++;
    15af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15b3:	eb 45                	jmp    15fa <printf+0x193>
      } else if(c == '%'){
    15b5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15b9:	75 17                	jne    15d2 <printf+0x16b>
        putc(fd, c);
    15bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15be:	0f be c0             	movsbl %al,%eax
    15c1:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c5:	8b 45 08             	mov    0x8(%ebp),%eax
    15c8:	89 04 24             	mov    %eax,(%esp)
    15cb:	e8 b7 fd ff ff       	call   1387 <putc>
    15d0:	eb 28                	jmp    15fa <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15d2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15d9:	00 
    15da:	8b 45 08             	mov    0x8(%ebp),%eax
    15dd:	89 04 24             	mov    %eax,(%esp)
    15e0:	e8 a2 fd ff ff       	call   1387 <putc>
        putc(fd, c);
    15e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15e8:	0f be c0             	movsbl %al,%eax
    15eb:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ef:	8b 45 08             	mov    0x8(%ebp),%eax
    15f2:	89 04 24             	mov    %eax,(%esp)
    15f5:	e8 8d fd ff ff       	call   1387 <putc>
      }
      state = 0;
    15fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1601:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1605:	8b 55 0c             	mov    0xc(%ebp),%edx
    1608:	8b 45 f0             	mov    -0x10(%ebp),%eax
    160b:	01 d0                	add    %edx,%eax
    160d:	0f b6 00             	movzbl (%eax),%eax
    1610:	84 c0                	test   %al,%al
    1612:	0f 85 71 fe ff ff    	jne    1489 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1618:	c9                   	leave  
    1619:	c3                   	ret    

0000161a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    161a:	55                   	push   %ebp
    161b:	89 e5                	mov    %esp,%ebp
    161d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1620:	8b 45 08             	mov    0x8(%ebp),%eax
    1623:	83 e8 08             	sub    $0x8,%eax
    1626:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1629:	a1 4c 1e 00 00       	mov    0x1e4c,%eax
    162e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1631:	eb 24                	jmp    1657 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1633:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1636:	8b 00                	mov    (%eax),%eax
    1638:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    163b:	77 12                	ja     164f <free+0x35>
    163d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1640:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1643:	77 24                	ja     1669 <free+0x4f>
    1645:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1648:	8b 00                	mov    (%eax),%eax
    164a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    164d:	77 1a                	ja     1669 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    164f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1652:	8b 00                	mov    (%eax),%eax
    1654:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1657:	8b 45 f8             	mov    -0x8(%ebp),%eax
    165a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    165d:	76 d4                	jbe    1633 <free+0x19>
    165f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1662:	8b 00                	mov    (%eax),%eax
    1664:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1667:	76 ca                	jbe    1633 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1669:	8b 45 f8             	mov    -0x8(%ebp),%eax
    166c:	8b 40 04             	mov    0x4(%eax),%eax
    166f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1676:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1679:	01 c2                	add    %eax,%edx
    167b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167e:	8b 00                	mov    (%eax),%eax
    1680:	39 c2                	cmp    %eax,%edx
    1682:	75 24                	jne    16a8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1684:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1687:	8b 50 04             	mov    0x4(%eax),%edx
    168a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168d:	8b 00                	mov    (%eax),%eax
    168f:	8b 40 04             	mov    0x4(%eax),%eax
    1692:	01 c2                	add    %eax,%edx
    1694:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1697:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    169a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169d:	8b 00                	mov    (%eax),%eax
    169f:	8b 10                	mov    (%eax),%edx
    16a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a4:	89 10                	mov    %edx,(%eax)
    16a6:	eb 0a                	jmp    16b2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ab:	8b 10                	mov    (%eax),%edx
    16ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b5:	8b 40 04             	mov    0x4(%eax),%eax
    16b8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c2:	01 d0                	add    %edx,%eax
    16c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16c7:	75 20                	jne    16e9 <free+0xcf>
    p->s.size += bp->s.size;
    16c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16cc:	8b 50 04             	mov    0x4(%eax),%edx
    16cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d2:	8b 40 04             	mov    0x4(%eax),%eax
    16d5:	01 c2                	add    %eax,%edx
    16d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16da:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16e0:	8b 10                	mov    (%eax),%edx
    16e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e5:	89 10                	mov    %edx,(%eax)
    16e7:	eb 08                	jmp    16f1 <free+0xd7>
  } else
    p->s.ptr = bp;
    16e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16ef:	89 10                	mov    %edx,(%eax)
  freep = p;
    16f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f4:	a3 4c 1e 00 00       	mov    %eax,0x1e4c
}
    16f9:	c9                   	leave  
    16fa:	c3                   	ret    

000016fb <morecore>:

static Header*
morecore(uint nu)
{
    16fb:	55                   	push   %ebp
    16fc:	89 e5                	mov    %esp,%ebp
    16fe:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1701:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1708:	77 07                	ja     1711 <morecore+0x16>
    nu = 4096;
    170a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1711:	8b 45 08             	mov    0x8(%ebp),%eax
    1714:	c1 e0 03             	shl    $0x3,%eax
    1717:	89 04 24             	mov    %eax,(%esp)
    171a:	e8 28 fc ff ff       	call   1347 <sbrk>
    171f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1722:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1726:	75 07                	jne    172f <morecore+0x34>
    return 0;
    1728:	b8 00 00 00 00       	mov    $0x0,%eax
    172d:	eb 22                	jmp    1751 <morecore+0x56>
  hp = (Header*)p;
    172f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1732:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1735:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1738:	8b 55 08             	mov    0x8(%ebp),%edx
    173b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    173e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1741:	83 c0 08             	add    $0x8,%eax
    1744:	89 04 24             	mov    %eax,(%esp)
    1747:	e8 ce fe ff ff       	call   161a <free>
  return freep;
    174c:	a1 4c 1e 00 00       	mov    0x1e4c,%eax
}
    1751:	c9                   	leave  
    1752:	c3                   	ret    

00001753 <malloc>:

void*
malloc(uint nbytes)
{
    1753:	55                   	push   %ebp
    1754:	89 e5                	mov    %esp,%ebp
    1756:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1759:	8b 45 08             	mov    0x8(%ebp),%eax
    175c:	83 c0 07             	add    $0x7,%eax
    175f:	c1 e8 03             	shr    $0x3,%eax
    1762:	83 c0 01             	add    $0x1,%eax
    1765:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1768:	a1 4c 1e 00 00       	mov    0x1e4c,%eax
    176d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1770:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1774:	75 23                	jne    1799 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1776:	c7 45 f0 44 1e 00 00 	movl   $0x1e44,-0x10(%ebp)
    177d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1780:	a3 4c 1e 00 00       	mov    %eax,0x1e4c
    1785:	a1 4c 1e 00 00       	mov    0x1e4c,%eax
    178a:	a3 44 1e 00 00       	mov    %eax,0x1e44
    base.s.size = 0;
    178f:	c7 05 48 1e 00 00 00 	movl   $0x0,0x1e48
    1796:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1799:	8b 45 f0             	mov    -0x10(%ebp),%eax
    179c:	8b 00                	mov    (%eax),%eax
    179e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    17a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a4:	8b 40 04             	mov    0x4(%eax),%eax
    17a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17aa:	72 4d                	jb     17f9 <malloc+0xa6>
      if(p->s.size == nunits)
    17ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17af:	8b 40 04             	mov    0x4(%eax),%eax
    17b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17b5:	75 0c                	jne    17c3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ba:	8b 10                	mov    (%eax),%edx
    17bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17bf:	89 10                	mov    %edx,(%eax)
    17c1:	eb 26                	jmp    17e9 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c6:	8b 40 04             	mov    0x4(%eax),%eax
    17c9:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17cc:	89 c2                	mov    %eax,%edx
    17ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d7:	8b 40 04             	mov    0x4(%eax),%eax
    17da:	c1 e0 03             	shl    $0x3,%eax
    17dd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17e6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17ec:	a3 4c 1e 00 00       	mov    %eax,0x1e4c
      return (void*)(p + 1);
    17f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f4:	83 c0 08             	add    $0x8,%eax
    17f7:	eb 38                	jmp    1831 <malloc+0xde>
    }
    if(p == freep)
    17f9:	a1 4c 1e 00 00       	mov    0x1e4c,%eax
    17fe:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1801:	75 1b                	jne    181e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1803:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1806:	89 04 24             	mov    %eax,(%esp)
    1809:	e8 ed fe ff ff       	call   16fb <morecore>
    180e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1815:	75 07                	jne    181e <malloc+0xcb>
        return 0;
    1817:	b8 00 00 00 00       	mov    $0x0,%eax
    181c:	eb 13                	jmp    1831 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    181e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1821:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1824:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1827:	8b 00                	mov    (%eax),%eax
    1829:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    182c:	e9 70 ff ff ff       	jmp    17a1 <malloc+0x4e>
}
    1831:	c9                   	leave  
    1832:	c3                   	ret    
