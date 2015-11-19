
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
      13:	e8 01 12 00 00       	call   1219 <exit>
  
  switch(cmd->type){
      18:	8b 45 08             	mov    0x8(%ebp),%eax
      1b:	8b 00                	mov    (%eax),%eax
      1d:	83 f8 05             	cmp    $0x5,%eax
      20:	77 09                	ja     2b <runcmd+0x2b>
      22:	8b 04 85 ac 17 00 00 	mov    0x17ac(,%eax,4),%eax
      29:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      2b:	c7 04 24 80 17 00 00 	movl   $0x1780,(%esp)
      32:	e8 d1 05 00 00       	call   608 <panic>

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
      4e:	e8 c6 11 00 00       	call   1219 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      53:	8b 45 f4             	mov    -0xc(%ebp),%eax
      56:	8d 50 04             	lea    0x4(%eax),%edx
      59:	8b 45 f4             	mov    -0xc(%ebp),%eax
      5c:	8b 40 04             	mov    0x4(%eax),%eax
      5f:	89 54 24 04          	mov    %edx,0x4(%esp)
      63:	89 04 24             	mov    %eax,(%esp)
      66:	e8 e6 11 00 00       	call   1251 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      6e:	8b 40 04             	mov    0x4(%eax),%eax
      71:	89 44 24 08          	mov    %eax,0x8(%esp)
      75:	c7 44 24 04 87 17 00 	movl   $0x1787,0x4(%esp)
      7c:	00 
      7d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      84:	e8 28 13 00 00       	call   13b1 <printf>
    exit(-1);
      89:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
      90:	e8 84 11 00 00       	call   1219 <exit>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      95:	8b 45 08             	mov    0x8(%ebp),%eax
      98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9e:	8b 40 14             	mov    0x14(%eax),%eax
      a1:	89 04 24             	mov    %eax,(%esp)
      a4:	e8 98 11 00 00       	call   1241 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
      ac:	8b 50 10             	mov    0x10(%eax),%edx
      af:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b2:	8b 40 08             	mov    0x8(%eax),%eax
      b5:	89 54 24 04          	mov    %edx,0x4(%esp)
      b9:	89 04 24             	mov    %eax,(%esp)
      bc:	e8 98 11 00 00       	call   1259 <open>
      c1:	85 c0                	test   %eax,%eax
      c3:	79 2a                	jns    ef <runcmd+0xef>
      printf(2, "open %s failed\n", rcmd->file);
      c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
      c8:	8b 40 08             	mov    0x8(%eax),%eax
      cb:	89 44 24 08          	mov    %eax,0x8(%esp)
      cf:	c7 44 24 04 97 17 00 	movl   $0x1797,0x4(%esp)
      d6:	00 
      d7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      de:	e8 ce 12 00 00       	call   13b1 <printf>
      exit(-1);
      e3:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
      ea:	e8 2a 11 00 00       	call   1219 <exit>
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
     108:	e8 28 05 00 00       	call   635 <fork1>
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
     125:	e8 f7 10 00 00       	call   1221 <wait>
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
     149:	e8 db 10 00 00       	call   1229 <pipe>
     14e:	85 c0                	test   %eax,%eax
     150:	79 0c                	jns    15e <runcmd+0x15e>
      panic("pipe");
     152:	c7 04 24 a7 17 00 00 	movl   $0x17a7,(%esp)
     159:	e8 aa 04 00 00       	call   608 <panic>
    if(fork1() == 0){
     15e:	e8 d2 04 00 00       	call   635 <fork1>
     163:	85 c0                	test   %eax,%eax
     165:	75 3b                	jne    1a2 <runcmd+0x1a2>
      close(1);
     167:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     16e:	e8 ce 10 00 00       	call   1241 <close>
      dup(p[1]);
     173:	8b 45 e0             	mov    -0x20(%ebp),%eax
     176:	89 04 24             	mov    %eax,(%esp)
     179:	e8 13 11 00 00       	call   1291 <dup>
      close(p[0]);
     17e:	8b 45 dc             	mov    -0x24(%ebp),%eax
     181:	89 04 24             	mov    %eax,(%esp)
     184:	e8 b8 10 00 00       	call   1241 <close>
      close(p[1]);
     189:	8b 45 e0             	mov    -0x20(%ebp),%eax
     18c:	89 04 24             	mov    %eax,(%esp)
     18f:	e8 ad 10 00 00       	call   1241 <close>
      runcmd(pcmd->left);
     194:	8b 45 e8             	mov    -0x18(%ebp),%eax
     197:	8b 40 04             	mov    0x4(%eax),%eax
     19a:	89 04 24             	mov    %eax,(%esp)
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     1a2:	e8 8e 04 00 00       	call   635 <fork1>
     1a7:	85 c0                	test   %eax,%eax
     1a9:	75 3b                	jne    1e6 <runcmd+0x1e6>
      close(0);
     1ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     1b2:	e8 8a 10 00 00       	call   1241 <close>
      dup(p[0]);
     1b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1ba:	89 04 24             	mov    %eax,(%esp)
     1bd:	e8 cf 10 00 00       	call   1291 <dup>
      close(p[0]);
     1c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c5:	89 04 24             	mov    %eax,(%esp)
     1c8:	e8 74 10 00 00       	call   1241 <close>
      close(p[1]);
     1cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d0:	89 04 24             	mov    %eax,(%esp)
     1d3:	e8 69 10 00 00       	call   1241 <close>
      runcmd(pcmd->right);
     1d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1db:	8b 40 08             	mov    0x8(%eax),%eax
     1de:	89 04 24             	mov    %eax,(%esp)
     1e1:	e8 1a fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1e9:	89 04 24             	mov    %eax,(%esp)
     1ec:	e8 50 10 00 00       	call   1241 <close>
    close(p[1]);
     1f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1f4:	89 04 24             	mov    %eax,(%esp)
     1f7:	e8 45 10 00 00       	call   1241 <close>
    wait(&status);
     1fc:	8d 45 d8             	lea    -0x28(%ebp),%eax
     1ff:	89 04 24             	mov    %eax,(%esp)
     202:	e8 1a 10 00 00       	call   1221 <wait>
    wait(&status);
     207:	8d 45 d8             	lea    -0x28(%ebp),%eax
     20a:	89 04 24             	mov    %eax,(%esp)
     20d:	e8 0f 10 00 00       	call   1221 <wait>
    break;
     212:	eb 20                	jmp    234 <runcmd+0x234>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     214:	8b 45 08             	mov    0x8(%ebp),%eax
     217:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     21a:	e8 16 04 00 00       	call   635 <fork1>
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
     23b:	e8 d9 0f 00 00       	call   1219 <exit>

00000240 <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     240:	55                   	push   %ebp
     241:	89 e5                	mov    %esp,%ebp
     243:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     246:	c7 44 24 04 c4 17 00 	movl   $0x17c4,0x4(%esp)
     24d:	00 
     24e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     255:	e8 57 11 00 00       	call   13b1 <printf>
  memset(buf, 0, nbuf);
     25a:	8b 45 0c             	mov    0xc(%ebp),%eax
     25d:	89 44 24 08          	mov    %eax,0x8(%esp)
     261:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     268:	00 
     269:	8b 45 08             	mov    0x8(%ebp),%eax
     26c:	89 04 24             	mov    %eax,(%esp)
     26f:	e8 f8 0d 00 00       	call   106c <memset>
  gets(buf, nbuf);
     274:	8b 45 0c             	mov    0xc(%ebp),%eax
     277:	89 44 24 04          	mov    %eax,0x4(%esp)
     27b:	8b 45 08             	mov    0x8(%ebp),%eax
     27e:	89 04 24             	mov    %eax,(%esp)
     281:	e8 3d 0e 00 00       	call   10c3 <gets>
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
     2a9:	83 7c 24 28 02       	cmpl   $0x2,0x28(%esp)
     2ae:	7e 0e                	jle    2be <main+0x20>
      close(fd);
     2b0:	8b 44 24 28          	mov    0x28(%esp),%eax
     2b4:	89 04 24             	mov    %eax,(%esp)
     2b7:	e8 85 0f 00 00       	call   1241 <close>
      break;
     2bc:	eb 1f                	jmp    2dd <main+0x3f>
  static char buf[100];
  int fd;
  int status;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2be:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     2c5:	00 
     2c6:	c7 04 24 c7 17 00 00 	movl   $0x17c7,(%esp)
     2cd:	e8 87 0f 00 00       	call   1259 <open>
     2d2:	89 44 24 28          	mov    %eax,0x28(%esp)
     2d6:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
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
     2ec:	e8 ac 13 00 00       	call   169d <malloc>
     2f1:	89 44 24 24          	mov    %eax,0x24(%esp)
  jlist->first = 0;
     2f5:	8b 44 24 24          	mov    0x24(%esp),%eax
     2f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  jlist->last = 0;
     2ff:	8b 44 24 24          	mov    0x24(%esp),%eax
     303:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

  while(getcmd(buf, sizeof(buf)) >= 0){
     30a:	e9 d1 02 00 00       	jmp    5e0 <main+0x342>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     30f:	0f b6 05 40 1d 00 00 	movzbl 0x1d40,%eax
     316:	3c 63                	cmp    $0x63,%al
     318:	75 62                	jne    37c <main+0xde>
     31a:	0f b6 05 41 1d 00 00 	movzbl 0x1d41,%eax
     321:	3c 64                	cmp    $0x64,%al
     323:	75 57                	jne    37c <main+0xde>
     325:	0f b6 05 42 1d 00 00 	movzbl 0x1d42,%eax
     32c:	3c 20                	cmp    $0x20,%al
     32e:	75 4c                	jne    37c <main+0xde>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     330:	c7 04 24 40 1d 00 00 	movl   $0x1d40,(%esp)
     337:	e8 09 0d 00 00       	call   1045 <strlen>
     33c:	83 e8 01             	sub    $0x1,%eax
     33f:	c6 80 40 1d 00 00 00 	movb   $0x0,0x1d40(%eax)
      if(chdir(buf+3) < 0)
     346:	c7 04 24 43 1d 00 00 	movl   $0x1d43,(%esp)
     34d:	e8 37 0f 00 00       	call   1289 <chdir>
     352:	85 c0                	test   %eax,%eax
     354:	79 21                	jns    377 <main+0xd9>
        printf(2, "cannot cd %s\n", buf+3);
     356:	c7 44 24 08 43 1d 00 	movl   $0x1d43,0x8(%esp)
     35d:	00 
     35e:	c7 44 24 04 cf 17 00 	movl   $0x17cf,0x4(%esp)
     365:	00 
     366:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     36d:	e8 3f 10 00 00       	call   13b1 <printf>
      continue;
     372:	e9 69 02 00 00       	jmp    5e0 <main+0x342>
     377:	e9 64 02 00 00       	jmp    5e0 <main+0x342>
    }



    if(buf[0] == 'j' && buf[1] == 'o' && buf[2] == 'b' && buf[3] == 's' && (buf[4] == '\n' || buf[4] == ' ')){
     37c:	0f b6 05 40 1d 00 00 	movzbl 0x1d40,%eax
     383:	3c 6a                	cmp    $0x6a,%al
     385:	0f 85 39 01 00 00    	jne    4c4 <main+0x226>
     38b:	0f b6 05 41 1d 00 00 	movzbl 0x1d41,%eax
     392:	3c 6f                	cmp    $0x6f,%al
     394:	0f 85 2a 01 00 00    	jne    4c4 <main+0x226>
     39a:	0f b6 05 42 1d 00 00 	movzbl 0x1d42,%eax
     3a1:	3c 62                	cmp    $0x62,%al
     3a3:	0f 85 1b 01 00 00    	jne    4c4 <main+0x226>
     3a9:	0f b6 05 43 1d 00 00 	movzbl 0x1d43,%eax
     3b0:	3c 73                	cmp    $0x73,%al
     3b2:	0f 85 0c 01 00 00    	jne    4c4 <main+0x226>
     3b8:	0f b6 05 44 1d 00 00 	movzbl 0x1d44,%eax
     3bf:	3c 0a                	cmp    $0xa,%al
     3c1:	74 0f                	je     3d2 <main+0x134>
     3c3:	0f b6 05 44 1d 00 00 	movzbl 0x1d44,%eax
     3ca:	3c 20                	cmp    $0x20,%al
     3cc:	0f 85 f2 00 00 00    	jne    4c4 <main+0x226>
    	struct job* job = jlist->first;
     3d2:	8b 44 24 24          	mov    0x24(%esp),%eax
     3d6:	8b 00                	mov    (%eax),%eax
     3d8:	89 44 24 38          	mov    %eax,0x38(%esp)
    	while (job != 0) {
     3dc:	e9 b0 00 00 00       	jmp    491 <main+0x1f3>
    		//printf(1, "jobID:%d.\n",job->jid);
			if (!printjob(job->jid)) { //no processes - delete job.
     3e1:	8b 44 24 38          	mov    0x38(%esp),%eax
     3e5:	8b 00                	mov    (%eax),%eax
     3e7:	89 04 24             	mov    %eax,(%esp)
     3ea:	e8 d2 0e 00 00       	call   12c1 <printjob>
     3ef:	85 c0                	test   %eax,%eax
     3f1:	0f 85 8f 00 00 00    	jne    486 <main+0x1e8>
				if (jlist->first == job && jlist->last == job)
     3f7:	8b 44 24 24          	mov    0x24(%esp),%eax
     3fb:	8b 00                	mov    (%eax),%eax
     3fd:	3b 44 24 38          	cmp    0x38(%esp),%eax
     401:	75 17                	jne    41a <main+0x17c>
     403:	8b 44 24 24          	mov    0x24(%esp),%eax
     407:	8b 40 04             	mov    0x4(%eax),%eax
     40a:	3b 44 24 38          	cmp    0x38(%esp),%eax
     40e:	75 0a                	jne    41a <main+0x17c>
					jlist->first = 0;
     410:	8b 44 24 24          	mov    0x24(%esp),%eax
     414:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
				if (jlist->first == job)
     41a:	8b 44 24 24          	mov    0x24(%esp),%eax
     41e:	8b 00                	mov    (%eax),%eax
     420:	3b 44 24 38          	cmp    0x38(%esp),%eax
     424:	75 0d                	jne    433 <main+0x195>
					jlist->first = job->next;
     426:	8b 44 24 38          	mov    0x38(%esp),%eax
     42a:	8b 50 44             	mov    0x44(%eax),%edx
     42d:	8b 44 24 24          	mov    0x24(%esp),%eax
     431:	89 10                	mov    %edx,(%eax)
				if (jlist->last == job)
     433:	8b 44 24 24          	mov    0x24(%esp),%eax
     437:	8b 40 04             	mov    0x4(%eax),%eax
     43a:	3b 44 24 38          	cmp    0x38(%esp),%eax
     43e:	75 0e                	jne    44e <main+0x1b0>
					jlist->last = job->prev;
     440:	8b 44 24 38          	mov    0x38(%esp),%eax
     444:	8b 50 48             	mov    0x48(%eax),%edx
     447:	8b 44 24 24          	mov    0x24(%esp),%eax
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
     49c:	8b 44 24 24          	mov    0x24(%esp),%eax
     4a0:	8b 00                	mov    (%eax),%eax
     4a2:	85 c0                	test   %eax,%eax
     4a4:	75 19                	jne    4bf <main+0x221>
			printf(1, "There are no jobs.\n");
     4a6:	c7 44 24 04 dd 17 00 	movl   $0x17dd,0x4(%esp)
     4ad:	00 
     4ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4b5:	e8 f7 0e 00 00       	call   13b1 <printf>
		continue;
     4ba:	e9 21 01 00 00       	jmp    5e0 <main+0x342>
     4bf:	e9 1c 01 00 00       	jmp    5e0 <main+0x342>
	}

    struct job* job;
	job = malloc(sizeof(*job));
     4c4:	c7 04 24 4c 00 00 00 	movl   $0x4c,(%esp)
     4cb:	e8 cd 11 00 00       	call   169d <malloc>
     4d0:	89 44 24 20          	mov    %eax,0x20(%esp)
	memset(job, 0, sizeof(*job));
     4d4:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
     4db:	00 
     4dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4e3:	00 
     4e4:	8b 44 24 20          	mov    0x20(%esp),%eax
     4e8:	89 04 24             	mov    %eax,(%esp)
     4eb:	e8 7c 0b 00 00       	call   106c <memset>
	job->jid = ++jobcntr;
     4f0:	83 44 24 3c 01       	addl   $0x1,0x3c(%esp)
     4f5:	8b 44 24 20          	mov    0x20(%esp),%eax
     4f9:	8b 54 24 3c          	mov    0x3c(%esp),%edx
     4fd:	89 10                	mov    %edx,(%eax)

	char* s = job->cmd;
     4ff:	8b 44 24 20          	mov    0x20(%esp),%eax
     503:	83 c0 04             	add    $0x4,%eax
     506:	89 44 24 34          	mov    %eax,0x34(%esp)
	char* t = buf;
     50a:	c7 44 24 30 40 1d 00 	movl   $0x1d40,0x30(%esp)
     511:	00 
	int i = sizeof(buf);
     512:	c7 44 24 2c 64 00 00 	movl   $0x64,0x2c(%esp)
     519:	00 
	while(--i > 0 && *t != '\n' && (*s++ = *t++) != 0) ;
     51a:	83 6c 24 2c 01       	subl   $0x1,0x2c(%esp)
     51f:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
     524:	7e 2d                	jle    553 <main+0x2b5>
     526:	8b 44 24 30          	mov    0x30(%esp),%eax
     52a:	0f b6 00             	movzbl (%eax),%eax
     52d:	3c 0a                	cmp    $0xa,%al
     52f:	74 22                	je     553 <main+0x2b5>
     531:	8b 44 24 34          	mov    0x34(%esp),%eax
     535:	8d 50 01             	lea    0x1(%eax),%edx
     538:	89 54 24 34          	mov    %edx,0x34(%esp)
     53c:	8b 54 24 30          	mov    0x30(%esp),%edx
     540:	8d 4a 01             	lea    0x1(%edx),%ecx
     543:	89 4c 24 30          	mov    %ecx,0x30(%esp)
     547:	0f b6 12             	movzbl (%edx),%edx
     54a:	88 10                	mov    %dl,(%eax)
     54c:	0f b6 00             	movzbl (%eax),%eax
     54f:	84 c0                	test   %al,%al
     551:	75 c7                	jne    51a <main+0x27c>
	*s = 0;
     553:	8b 44 24 34          	mov    0x34(%esp),%eax
     557:	c6 00 00             	movb   $0x0,(%eax)
	if(fork1() == 0) {
     55a:	e8 d6 00 00 00       	call   635 <fork1>
     55f:	85 c0                	test   %eax,%eax
     561:	75 29                	jne    58c <main+0x2ee>
		attachjob(getpid(), job);
     563:	e8 31 0d 00 00       	call   1299 <getpid>
     568:	8b 54 24 20          	mov    0x20(%esp),%edx
     56c:	89 54 24 04          	mov    %edx,0x4(%esp)
     570:	89 04 24             	mov    %eax,(%esp)
     573:	e8 51 0d 00 00       	call   12c9 <attachjob>
		runcmd(parsecmd(buf));
     578:	c7 04 24 40 1d 00 00 	movl   $0x1d40,(%esp)
     57f:	e8 26 04 00 00       	call   9aa <parsecmd>
     584:	89 04 24             	mov    %eax,(%esp)
     587:	e8 74 fa ff ff       	call   0 <runcmd>
	}
	if (jlist->first == 0) {
     58c:	8b 44 24 24          	mov    0x24(%esp),%eax
     590:	8b 00                	mov    (%eax),%eax
     592:	85 c0                	test   %eax,%eax
     594:	75 17                	jne    5ad <main+0x30f>
		jlist->first = job;
     596:	8b 44 24 24          	mov    0x24(%esp),%eax
     59a:	8b 54 24 20          	mov    0x20(%esp),%edx
     59e:	89 10                	mov    %edx,(%eax)
		jlist->last = job;
     5a0:	8b 44 24 24          	mov    0x24(%esp),%eax
     5a4:	8b 54 24 20          	mov    0x20(%esp),%edx
     5a8:	89 50 04             	mov    %edx,0x4(%eax)
     5ab:	eb 27                	jmp    5d4 <main+0x336>
	} else {
		job->prev = jlist->last;
     5ad:	8b 44 24 24          	mov    0x24(%esp),%eax
     5b1:	8b 50 04             	mov    0x4(%eax),%edx
     5b4:	8b 44 24 20          	mov    0x20(%esp),%eax
     5b8:	89 50 48             	mov    %edx,0x48(%eax)
		jlist->last->next = job;
     5bb:	8b 44 24 24          	mov    0x24(%esp),%eax
     5bf:	8b 40 04             	mov    0x4(%eax),%eax
     5c2:	8b 54 24 20          	mov    0x20(%esp),%edx
     5c6:	89 50 44             	mov    %edx,0x44(%eax)
		jlist->last = job;
     5c9:	8b 44 24 24          	mov    0x24(%esp),%eax
     5cd:	8b 54 24 20          	mov    0x20(%esp),%edx
     5d1:	89 50 04             	mov    %edx,0x4(%eax)
	}
    wait(&status);
     5d4:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     5d8:	89 04 24             	mov    %eax,(%esp)
     5db:	e8 41 0c 00 00       	call   1221 <wait>
  struct joblist* jlist;
  jlist = malloc(sizeof(*jlist));
  jlist->first = 0;
  jlist->last = 0;

  while(getcmd(buf, sizeof(buf)) >= 0){
     5e0:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     5e7:	00 
     5e8:	c7 04 24 40 1d 00 00 	movl   $0x1d40,(%esp)
     5ef:	e8 4c fc ff ff       	call   240 <getcmd>
     5f4:	85 c0                	test   %eax,%eax
     5f6:	0f 89 13 fd ff ff    	jns    30f <main+0x71>
		jlist->last->next = job;
		jlist->last = job;
	}
    wait(&status);
  }
  exit(0);
     5fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     603:	e8 11 0c 00 00       	call   1219 <exit>

00000608 <panic>:
}

void
panic(char *s)
{
     608:	55                   	push   %ebp
     609:	89 e5                	mov    %esp,%ebp
     60b:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     60e:	8b 45 08             	mov    0x8(%ebp),%eax
     611:	89 44 24 08          	mov    %eax,0x8(%esp)
     615:	c7 44 24 04 f1 17 00 	movl   $0x17f1,0x4(%esp)
     61c:	00 
     61d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     624:	e8 88 0d 00 00       	call   13b1 <printf>
  exit(0);
     629:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     630:	e8 e4 0b 00 00       	call   1219 <exit>

00000635 <fork1>:
}

int
fork1(void)
{
     635:	55                   	push   %ebp
     636:	89 e5                	mov    %esp,%ebp
     638:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     63b:	e8 d1 0b 00 00       	call   1211 <fork>
     640:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     643:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     647:	75 0c                	jne    655 <fork1+0x20>
    panic("fork");
     649:	c7 04 24 f5 17 00 00 	movl   $0x17f5,(%esp)
     650:	e8 b3 ff ff ff       	call   608 <panic>
  return pid;
     655:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     658:	c9                   	leave  
     659:	c3                   	ret    

0000065a <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     65a:	55                   	push   %ebp
     65b:	89 e5                	mov    %esp,%ebp
     65d:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     660:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     667:	e8 31 10 00 00       	call   169d <malloc>
     66c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     66f:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     676:	00 
     677:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     67e:	00 
     67f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     682:	89 04 24             	mov    %eax,(%esp)
     685:	e8 e2 09 00 00       	call   106c <memset>
  cmd->type = EXEC;
     68a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     68d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     693:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     696:	c9                   	leave  
     697:	c3                   	ret    

00000698 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     698:	55                   	push   %ebp
     699:	89 e5                	mov    %esp,%ebp
     69b:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     69e:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     6a5:	e8 f3 0f 00 00       	call   169d <malloc>
     6aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     6ad:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     6b4:	00 
     6b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     6bc:	00 
     6bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c0:	89 04 24             	mov    %eax,(%esp)
     6c3:	e8 a4 09 00 00       	call   106c <memset>
  cmd->type = REDIR;
     6c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cb:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     6d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6d4:	8b 55 08             	mov    0x8(%ebp),%edx
     6d7:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     6da:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6dd:	8b 55 0c             	mov    0xc(%ebp),%edx
     6e0:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     6e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6e6:	8b 55 10             	mov    0x10(%ebp),%edx
     6e9:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ef:	8b 55 14             	mov    0x14(%ebp),%edx
     6f2:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     6f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6f8:	8b 55 18             	mov    0x18(%ebp),%edx
     6fb:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     6fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     701:	c9                   	leave  
     702:	c3                   	ret    

00000703 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     703:	55                   	push   %ebp
     704:	89 e5                	mov    %esp,%ebp
     706:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     709:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     710:	e8 88 0f 00 00       	call   169d <malloc>
     715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     718:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     71f:	00 
     720:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     727:	00 
     728:	8b 45 f4             	mov    -0xc(%ebp),%eax
     72b:	89 04 24             	mov    %eax,(%esp)
     72e:	e8 39 09 00 00       	call   106c <memset>
  cmd->type = PIPE;
     733:	8b 45 f4             	mov    -0xc(%ebp),%eax
     736:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     73c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     73f:	8b 55 08             	mov    0x8(%ebp),%edx
     742:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     745:	8b 45 f4             	mov    -0xc(%ebp),%eax
     748:	8b 55 0c             	mov    0xc(%ebp),%edx
     74b:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     74e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     751:	c9                   	leave  
     752:	c3                   	ret    

00000753 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     753:	55                   	push   %ebp
     754:	89 e5                	mov    %esp,%ebp
     756:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     759:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     760:	e8 38 0f 00 00       	call   169d <malloc>
     765:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     768:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     76f:	00 
     770:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     777:	00 
     778:	8b 45 f4             	mov    -0xc(%ebp),%eax
     77b:	89 04 24             	mov    %eax,(%esp)
     77e:	e8 e9 08 00 00       	call   106c <memset>
  cmd->type = LIST;
     783:	8b 45 f4             	mov    -0xc(%ebp),%eax
     786:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     78c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     78f:	8b 55 08             	mov    0x8(%ebp),%edx
     792:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     795:	8b 45 f4             	mov    -0xc(%ebp),%eax
     798:	8b 55 0c             	mov    0xc(%ebp),%edx
     79b:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     79e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     7a1:	c9                   	leave  
     7a2:	c3                   	ret    

000007a3 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     7a3:	55                   	push   %ebp
     7a4:	89 e5                	mov    %esp,%ebp
     7a6:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7a9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     7b0:	e8 e8 0e 00 00       	call   169d <malloc>
     7b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     7b8:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     7bf:	00 
     7c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     7c7:	00 
     7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7cb:	89 04 24             	mov    %eax,(%esp)
     7ce:	e8 99 08 00 00       	call   106c <memset>
  cmd->type = BACK;
     7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7d6:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7df:	8b 55 08             	mov    0x8(%ebp),%edx
     7e2:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     7e8:	c9                   	leave  
     7e9:	c3                   	ret    

000007ea <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     7ea:	55                   	push   %ebp
     7eb:	89 e5                	mov    %esp,%ebp
     7ed:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
     7f0:	8b 45 08             	mov    0x8(%ebp),%eax
     7f3:	8b 00                	mov    (%eax),%eax
     7f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     7f8:	eb 04                	jmp    7fe <gettoken+0x14>
    s++;
     7fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     801:	3b 45 0c             	cmp    0xc(%ebp),%eax
     804:	73 1d                	jae    823 <gettoken+0x39>
     806:	8b 45 f4             	mov    -0xc(%ebp),%eax
     809:	0f b6 00             	movzbl (%eax),%eax
     80c:	0f be c0             	movsbl %al,%eax
     80f:	89 44 24 04          	mov    %eax,0x4(%esp)
     813:	c7 04 24 0c 1d 00 00 	movl   $0x1d0c,(%esp)
     81a:	e8 71 08 00 00       	call   1090 <strchr>
     81f:	85 c0                	test   %eax,%eax
     821:	75 d7                	jne    7fa <gettoken+0x10>
    s++;
  if(q)
     823:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     827:	74 08                	je     831 <gettoken+0x47>
    *q = s;
     829:	8b 45 10             	mov    0x10(%ebp),%eax
     82c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     82f:	89 10                	mov    %edx,(%eax)
  ret = *s;
     831:	8b 45 f4             	mov    -0xc(%ebp),%eax
     834:	0f b6 00             	movzbl (%eax),%eax
     837:	0f be c0             	movsbl %al,%eax
     83a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     840:	0f b6 00             	movzbl (%eax),%eax
     843:	0f be c0             	movsbl %al,%eax
     846:	83 f8 29             	cmp    $0x29,%eax
     849:	7f 14                	jg     85f <gettoken+0x75>
     84b:	83 f8 28             	cmp    $0x28,%eax
     84e:	7d 28                	jge    878 <gettoken+0x8e>
     850:	85 c0                	test   %eax,%eax
     852:	0f 84 94 00 00 00    	je     8ec <gettoken+0x102>
     858:	83 f8 26             	cmp    $0x26,%eax
     85b:	74 1b                	je     878 <gettoken+0x8e>
     85d:	eb 3c                	jmp    89b <gettoken+0xb1>
     85f:	83 f8 3e             	cmp    $0x3e,%eax
     862:	74 1a                	je     87e <gettoken+0x94>
     864:	83 f8 3e             	cmp    $0x3e,%eax
     867:	7f 0a                	jg     873 <gettoken+0x89>
     869:	83 e8 3b             	sub    $0x3b,%eax
     86c:	83 f8 01             	cmp    $0x1,%eax
     86f:	77 2a                	ja     89b <gettoken+0xb1>
     871:	eb 05                	jmp    878 <gettoken+0x8e>
     873:	83 f8 7c             	cmp    $0x7c,%eax
     876:	75 23                	jne    89b <gettoken+0xb1>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     878:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     87c:	eb 6f                	jmp    8ed <gettoken+0x103>
  case '>':
    s++;
     87e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     882:	8b 45 f4             	mov    -0xc(%ebp),%eax
     885:	0f b6 00             	movzbl (%eax),%eax
     888:	3c 3e                	cmp    $0x3e,%al
     88a:	75 0d                	jne    899 <gettoken+0xaf>
      ret = '+';
     88c:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     893:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     897:	eb 54                	jmp    8ed <gettoken+0x103>
     899:	eb 52                	jmp    8ed <gettoken+0x103>
  default:
    ret = 'a';
     89b:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     8a2:	eb 04                	jmp    8a8 <gettoken+0xbe>
      s++;
     8a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     8a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
     8ae:	73 3a                	jae    8ea <gettoken+0x100>
     8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8b3:	0f b6 00             	movzbl (%eax),%eax
     8b6:	0f be c0             	movsbl %al,%eax
     8b9:	89 44 24 04          	mov    %eax,0x4(%esp)
     8bd:	c7 04 24 0c 1d 00 00 	movl   $0x1d0c,(%esp)
     8c4:	e8 c7 07 00 00       	call   1090 <strchr>
     8c9:	85 c0                	test   %eax,%eax
     8cb:	75 1d                	jne    8ea <gettoken+0x100>
     8cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8d0:	0f b6 00             	movzbl (%eax),%eax
     8d3:	0f be c0             	movsbl %al,%eax
     8d6:	89 44 24 04          	mov    %eax,0x4(%esp)
     8da:	c7 04 24 12 1d 00 00 	movl   $0x1d12,(%esp)
     8e1:	e8 aa 07 00 00       	call   1090 <strchr>
     8e6:	85 c0                	test   %eax,%eax
     8e8:	74 ba                	je     8a4 <gettoken+0xba>
      s++;
    break;
     8ea:	eb 01                	jmp    8ed <gettoken+0x103>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     8ec:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     8ed:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     8f1:	74 0a                	je     8fd <gettoken+0x113>
    *eq = s;
     8f3:	8b 45 14             	mov    0x14(%ebp),%eax
     8f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8f9:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     8fb:	eb 06                	jmp    903 <gettoken+0x119>
     8fd:	eb 04                	jmp    903 <gettoken+0x119>
    s++;
     8ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     903:	8b 45 f4             	mov    -0xc(%ebp),%eax
     906:	3b 45 0c             	cmp    0xc(%ebp),%eax
     909:	73 1d                	jae    928 <gettoken+0x13e>
     90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     90e:	0f b6 00             	movzbl (%eax),%eax
     911:	0f be c0             	movsbl %al,%eax
     914:	89 44 24 04          	mov    %eax,0x4(%esp)
     918:	c7 04 24 0c 1d 00 00 	movl   $0x1d0c,(%esp)
     91f:	e8 6c 07 00 00       	call   1090 <strchr>
     924:	85 c0                	test   %eax,%eax
     926:	75 d7                	jne    8ff <gettoken+0x115>
    s++;
  *ps = s;
     928:	8b 45 08             	mov    0x8(%ebp),%eax
     92b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     92e:	89 10                	mov    %edx,(%eax)
  return ret;
     930:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     933:	c9                   	leave  
     934:	c3                   	ret    

00000935 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     935:	55                   	push   %ebp
     936:	89 e5                	mov    %esp,%ebp
     938:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
     93b:	8b 45 08             	mov    0x8(%ebp),%eax
     93e:	8b 00                	mov    (%eax),%eax
     940:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     943:	eb 04                	jmp    949 <peek+0x14>
    s++;
     945:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     949:	8b 45 f4             	mov    -0xc(%ebp),%eax
     94c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     94f:	73 1d                	jae    96e <peek+0x39>
     951:	8b 45 f4             	mov    -0xc(%ebp),%eax
     954:	0f b6 00             	movzbl (%eax),%eax
     957:	0f be c0             	movsbl %al,%eax
     95a:	89 44 24 04          	mov    %eax,0x4(%esp)
     95e:	c7 04 24 0c 1d 00 00 	movl   $0x1d0c,(%esp)
     965:	e8 26 07 00 00       	call   1090 <strchr>
     96a:	85 c0                	test   %eax,%eax
     96c:	75 d7                	jne    945 <peek+0x10>
    s++;
  *ps = s;
     96e:	8b 45 08             	mov    0x8(%ebp),%eax
     971:	8b 55 f4             	mov    -0xc(%ebp),%edx
     974:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     976:	8b 45 f4             	mov    -0xc(%ebp),%eax
     979:	0f b6 00             	movzbl (%eax),%eax
     97c:	84 c0                	test   %al,%al
     97e:	74 23                	je     9a3 <peek+0x6e>
     980:	8b 45 f4             	mov    -0xc(%ebp),%eax
     983:	0f b6 00             	movzbl (%eax),%eax
     986:	0f be c0             	movsbl %al,%eax
     989:	89 44 24 04          	mov    %eax,0x4(%esp)
     98d:	8b 45 10             	mov    0x10(%ebp),%eax
     990:	89 04 24             	mov    %eax,(%esp)
     993:	e8 f8 06 00 00       	call   1090 <strchr>
     998:	85 c0                	test   %eax,%eax
     99a:	74 07                	je     9a3 <peek+0x6e>
     99c:	b8 01 00 00 00       	mov    $0x1,%eax
     9a1:	eb 05                	jmp    9a8 <peek+0x73>
     9a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
     9a8:	c9                   	leave  
     9a9:	c3                   	ret    

000009aa <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     9aa:	55                   	push   %ebp
     9ab:	89 e5                	mov    %esp,%ebp
     9ad:	53                   	push   %ebx
     9ae:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     9b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
     9b4:	8b 45 08             	mov    0x8(%ebp),%eax
     9b7:	89 04 24             	mov    %eax,(%esp)
     9ba:	e8 86 06 00 00       	call   1045 <strlen>
     9bf:	01 d8                	add    %ebx,%eax
     9c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     9c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9c7:	89 44 24 04          	mov    %eax,0x4(%esp)
     9cb:	8d 45 08             	lea    0x8(%ebp),%eax
     9ce:	89 04 24             	mov    %eax,(%esp)
     9d1:	e8 60 00 00 00       	call   a36 <parseline>
     9d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     9d9:	c7 44 24 08 fa 17 00 	movl   $0x17fa,0x8(%esp)
     9e0:	00 
     9e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9e4:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e8:	8d 45 08             	lea    0x8(%ebp),%eax
     9eb:	89 04 24             	mov    %eax,(%esp)
     9ee:	e8 42 ff ff ff       	call   935 <peek>
  if(s != es){
     9f3:	8b 45 08             	mov    0x8(%ebp),%eax
     9f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     9f9:	74 27                	je     a22 <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     9fb:	8b 45 08             	mov    0x8(%ebp),%eax
     9fe:	89 44 24 08          	mov    %eax,0x8(%esp)
     a02:	c7 44 24 04 fb 17 00 	movl   $0x17fb,0x4(%esp)
     a09:	00 
     a0a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     a11:	e8 9b 09 00 00       	call   13b1 <printf>
    panic("syntax");
     a16:	c7 04 24 0a 18 00 00 	movl   $0x180a,(%esp)
     a1d:	e8 e6 fb ff ff       	call   608 <panic>
  }
  nulterminate(cmd);
     a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a25:	89 04 24             	mov    %eax,(%esp)
     a28:	e8 a3 04 00 00       	call   ed0 <nulterminate>
  return cmd;
     a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     a30:	83 c4 24             	add    $0x24,%esp
     a33:	5b                   	pop    %ebx
     a34:	5d                   	pop    %ebp
     a35:	c3                   	ret    

00000a36 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     a36:	55                   	push   %ebp
     a37:	89 e5                	mov    %esp,%ebp
     a39:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
     a3f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a43:	8b 45 08             	mov    0x8(%ebp),%eax
     a46:	89 04 24             	mov    %eax,(%esp)
     a49:	e8 bc 00 00 00       	call   b0a <parsepipe>
     a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     a51:	eb 30                	jmp    a83 <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     a53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a5a:	00 
     a5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a62:	00 
     a63:	8b 45 0c             	mov    0xc(%ebp),%eax
     a66:	89 44 24 04          	mov    %eax,0x4(%esp)
     a6a:	8b 45 08             	mov    0x8(%ebp),%eax
     a6d:	89 04 24             	mov    %eax,(%esp)
     a70:	e8 75 fd ff ff       	call   7ea <gettoken>
    cmd = backcmd(cmd);
     a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a78:	89 04 24             	mov    %eax,(%esp)
     a7b:	e8 23 fd ff ff       	call   7a3 <backcmd>
     a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     a83:	c7 44 24 08 11 18 00 	movl   $0x1811,0x8(%esp)
     a8a:	00 
     a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
     a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
     a92:	8b 45 08             	mov    0x8(%ebp),%eax
     a95:	89 04 24             	mov    %eax,(%esp)
     a98:	e8 98 fe ff ff       	call   935 <peek>
     a9d:	85 c0                	test   %eax,%eax
     a9f:	75 b2                	jne    a53 <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     aa1:	c7 44 24 08 13 18 00 	movl   $0x1813,0x8(%esp)
     aa8:	00 
     aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
     aac:	89 44 24 04          	mov    %eax,0x4(%esp)
     ab0:	8b 45 08             	mov    0x8(%ebp),%eax
     ab3:	89 04 24             	mov    %eax,(%esp)
     ab6:	e8 7a fe ff ff       	call   935 <peek>
     abb:	85 c0                	test   %eax,%eax
     abd:	74 46                	je     b05 <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     abf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     ac6:	00 
     ac7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     ace:	00 
     acf:	8b 45 0c             	mov    0xc(%ebp),%eax
     ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
     ad6:	8b 45 08             	mov    0x8(%ebp),%eax
     ad9:	89 04 24             	mov    %eax,(%esp)
     adc:	e8 09 fd ff ff       	call   7ea <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
     ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae8:	8b 45 08             	mov    0x8(%ebp),%eax
     aeb:	89 04 24             	mov    %eax,(%esp)
     aee:	e8 43 ff ff ff       	call   a36 <parseline>
     af3:	89 44 24 04          	mov    %eax,0x4(%esp)
     af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     afa:	89 04 24             	mov    %eax,(%esp)
     afd:	e8 51 fc ff ff       	call   753 <listcmd>
     b02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b08:	c9                   	leave  
     b09:	c3                   	ret    

00000b0a <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     b0a:	55                   	push   %ebp
     b0b:	89 e5                	mov    %esp,%ebp
     b0d:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     b10:	8b 45 0c             	mov    0xc(%ebp),%eax
     b13:	89 44 24 04          	mov    %eax,0x4(%esp)
     b17:	8b 45 08             	mov    0x8(%ebp),%eax
     b1a:	89 04 24             	mov    %eax,(%esp)
     b1d:	e8 68 02 00 00       	call   d8a <parseexec>
     b22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     b25:	c7 44 24 08 15 18 00 	movl   $0x1815,0x8(%esp)
     b2c:	00 
     b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
     b30:	89 44 24 04          	mov    %eax,0x4(%esp)
     b34:	8b 45 08             	mov    0x8(%ebp),%eax
     b37:	89 04 24             	mov    %eax,(%esp)
     b3a:	e8 f6 fd ff ff       	call   935 <peek>
     b3f:	85 c0                	test   %eax,%eax
     b41:	74 46                	je     b89 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     b43:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     b4a:	00 
     b4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     b52:	00 
     b53:	8b 45 0c             	mov    0xc(%ebp),%eax
     b56:	89 44 24 04          	mov    %eax,0x4(%esp)
     b5a:	8b 45 08             	mov    0x8(%ebp),%eax
     b5d:	89 04 24             	mov    %eax,(%esp)
     b60:	e8 85 fc ff ff       	call   7ea <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     b65:	8b 45 0c             	mov    0xc(%ebp),%eax
     b68:	89 44 24 04          	mov    %eax,0x4(%esp)
     b6c:	8b 45 08             	mov    0x8(%ebp),%eax
     b6f:	89 04 24             	mov    %eax,(%esp)
     b72:	e8 93 ff ff ff       	call   b0a <parsepipe>
     b77:	89 44 24 04          	mov    %eax,0x4(%esp)
     b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b7e:	89 04 24             	mov    %eax,(%esp)
     b81:	e8 7d fb ff ff       	call   703 <pipecmd>
     b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b8c:	c9                   	leave  
     b8d:	c3                   	ret    

00000b8e <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     b8e:	55                   	push   %ebp
     b8f:	89 e5                	mov    %esp,%ebp
     b91:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     b94:	e9 f6 00 00 00       	jmp    c8f <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     b99:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     ba0:	00 
     ba1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     ba8:	00 
     ba9:	8b 45 10             	mov    0x10(%ebp),%eax
     bac:	89 44 24 04          	mov    %eax,0x4(%esp)
     bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb3:	89 04 24             	mov    %eax,(%esp)
     bb6:	e8 2f fc ff ff       	call   7ea <gettoken>
     bbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     bbe:	8d 45 ec             	lea    -0x14(%ebp),%eax
     bc1:	89 44 24 0c          	mov    %eax,0xc(%esp)
     bc5:	8d 45 f0             	lea    -0x10(%ebp),%eax
     bc8:	89 44 24 08          	mov    %eax,0x8(%esp)
     bcc:	8b 45 10             	mov    0x10(%ebp),%eax
     bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
     bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd6:	89 04 24             	mov    %eax,(%esp)
     bd9:	e8 0c fc ff ff       	call   7ea <gettoken>
     bde:	83 f8 61             	cmp    $0x61,%eax
     be1:	74 0c                	je     bef <parseredirs+0x61>
      panic("missing file for redirection");
     be3:	c7 04 24 17 18 00 00 	movl   $0x1817,(%esp)
     bea:	e8 19 fa ff ff       	call   608 <panic>
    switch(tok){
     bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bf2:	83 f8 3c             	cmp    $0x3c,%eax
     bf5:	74 0f                	je     c06 <parseredirs+0x78>
     bf7:	83 f8 3e             	cmp    $0x3e,%eax
     bfa:	74 38                	je     c34 <parseredirs+0xa6>
     bfc:	83 f8 2b             	cmp    $0x2b,%eax
     bff:	74 61                	je     c62 <parseredirs+0xd4>
     c01:	e9 89 00 00 00       	jmp    c8f <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     c06:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c0c:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     c13:	00 
     c14:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     c1b:	00 
     c1c:	89 54 24 08          	mov    %edx,0x8(%esp)
     c20:	89 44 24 04          	mov    %eax,0x4(%esp)
     c24:	8b 45 08             	mov    0x8(%ebp),%eax
     c27:	89 04 24             	mov    %eax,(%esp)
     c2a:	e8 69 fa ff ff       	call   698 <redircmd>
     c2f:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c32:	eb 5b                	jmp    c8f <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     c34:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c3a:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     c41:	00 
     c42:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     c49:	00 
     c4a:	89 54 24 08          	mov    %edx,0x8(%esp)
     c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
     c52:	8b 45 08             	mov    0x8(%ebp),%eax
     c55:	89 04 24             	mov    %eax,(%esp)
     c58:	e8 3b fa ff ff       	call   698 <redircmd>
     c5d:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c60:	eb 2d                	jmp    c8f <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     c62:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c68:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     c6f:	00 
     c70:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     c77:	00 
     c78:	89 54 24 08          	mov    %edx,0x8(%esp)
     c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
     c80:	8b 45 08             	mov    0x8(%ebp),%eax
     c83:	89 04 24             	mov    %eax,(%esp)
     c86:	e8 0d fa ff ff       	call   698 <redircmd>
     c8b:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c8e:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     c8f:	c7 44 24 08 34 18 00 	movl   $0x1834,0x8(%esp)
     c96:	00 
     c97:	8b 45 10             	mov    0x10(%ebp),%eax
     c9a:	89 44 24 04          	mov    %eax,0x4(%esp)
     c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
     ca1:	89 04 24             	mov    %eax,(%esp)
     ca4:	e8 8c fc ff ff       	call   935 <peek>
     ca9:	85 c0                	test   %eax,%eax
     cab:	0f 85 e8 fe ff ff    	jne    b99 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     cb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cb4:	c9                   	leave  
     cb5:	c3                   	ret    

00000cb6 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     cb6:	55                   	push   %ebp
     cb7:	89 e5                	mov    %esp,%ebp
     cb9:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     cbc:	c7 44 24 08 37 18 00 	movl   $0x1837,0x8(%esp)
     cc3:	00 
     cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
     cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
     ccb:	8b 45 08             	mov    0x8(%ebp),%eax
     cce:	89 04 24             	mov    %eax,(%esp)
     cd1:	e8 5f fc ff ff       	call   935 <peek>
     cd6:	85 c0                	test   %eax,%eax
     cd8:	75 0c                	jne    ce6 <parseblock+0x30>
    panic("parseblock");
     cda:	c7 04 24 39 18 00 00 	movl   $0x1839,(%esp)
     ce1:	e8 22 f9 ff ff       	call   608 <panic>
  gettoken(ps, es, 0, 0);
     ce6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     ced:	00 
     cee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     cf5:	00 
     cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
     cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
     cfd:	8b 45 08             	mov    0x8(%ebp),%eax
     d00:	89 04 24             	mov    %eax,(%esp)
     d03:	e8 e2 fa ff ff       	call   7ea <gettoken>
  cmd = parseline(ps, es);
     d08:	8b 45 0c             	mov    0xc(%ebp),%eax
     d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
     d0f:	8b 45 08             	mov    0x8(%ebp),%eax
     d12:	89 04 24             	mov    %eax,(%esp)
     d15:	e8 1c fd ff ff       	call   a36 <parseline>
     d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     d1d:	c7 44 24 08 44 18 00 	movl   $0x1844,0x8(%esp)
     d24:	00 
     d25:	8b 45 0c             	mov    0xc(%ebp),%eax
     d28:	89 44 24 04          	mov    %eax,0x4(%esp)
     d2c:	8b 45 08             	mov    0x8(%ebp),%eax
     d2f:	89 04 24             	mov    %eax,(%esp)
     d32:	e8 fe fb ff ff       	call   935 <peek>
     d37:	85 c0                	test   %eax,%eax
     d39:	75 0c                	jne    d47 <parseblock+0x91>
    panic("syntax - missing )");
     d3b:	c7 04 24 46 18 00 00 	movl   $0x1846,(%esp)
     d42:	e8 c1 f8 ff ff       	call   608 <panic>
  gettoken(ps, es, 0, 0);
     d47:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     d4e:	00 
     d4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     d56:	00 
     d57:	8b 45 0c             	mov    0xc(%ebp),%eax
     d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
     d5e:	8b 45 08             	mov    0x8(%ebp),%eax
     d61:	89 04 24             	mov    %eax,(%esp)
     d64:	e8 81 fa ff ff       	call   7ea <gettoken>
  cmd = parseredirs(cmd, ps, es);
     d69:	8b 45 0c             	mov    0xc(%ebp),%eax
     d6c:	89 44 24 08          	mov    %eax,0x8(%esp)
     d70:	8b 45 08             	mov    0x8(%ebp),%eax
     d73:	89 44 24 04          	mov    %eax,0x4(%esp)
     d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d7a:	89 04 24             	mov    %eax,(%esp)
     d7d:	e8 0c fe ff ff       	call   b8e <parseredirs>
     d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     d88:	c9                   	leave  
     d89:	c3                   	ret    

00000d8a <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     d8a:	55                   	push   %ebp
     d8b:	89 e5                	mov    %esp,%ebp
     d8d:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     d90:	c7 44 24 08 37 18 00 	movl   $0x1837,0x8(%esp)
     d97:	00 
     d98:	8b 45 0c             	mov    0xc(%ebp),%eax
     d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
     d9f:	8b 45 08             	mov    0x8(%ebp),%eax
     da2:	89 04 24             	mov    %eax,(%esp)
     da5:	e8 8b fb ff ff       	call   935 <peek>
     daa:	85 c0                	test   %eax,%eax
     dac:	74 17                	je     dc5 <parseexec+0x3b>
    return parseblock(ps, es);
     dae:	8b 45 0c             	mov    0xc(%ebp),%eax
     db1:	89 44 24 04          	mov    %eax,0x4(%esp)
     db5:	8b 45 08             	mov    0x8(%ebp),%eax
     db8:	89 04 24             	mov    %eax,(%esp)
     dbb:	e8 f6 fe ff ff       	call   cb6 <parseblock>
     dc0:	e9 09 01 00 00       	jmp    ece <parseexec+0x144>

  ret = execcmd();
     dc5:	e8 90 f8 ff ff       	call   65a <execcmd>
     dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
     dd0:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     dd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     dda:	8b 45 0c             	mov    0xc(%ebp),%eax
     ddd:	89 44 24 08          	mov    %eax,0x8(%esp)
     de1:	8b 45 08             	mov    0x8(%ebp),%eax
     de4:	89 44 24 04          	mov    %eax,0x4(%esp)
     de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     deb:	89 04 24             	mov    %eax,(%esp)
     dee:	e8 9b fd ff ff       	call   b8e <parseredirs>
     df3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     df6:	e9 8f 00 00 00       	jmp    e8a <parseexec+0x100>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     dfb:	8d 45 e0             	lea    -0x20(%ebp),%eax
     dfe:	89 44 24 0c          	mov    %eax,0xc(%esp)
     e02:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     e05:	89 44 24 08          	mov    %eax,0x8(%esp)
     e09:	8b 45 0c             	mov    0xc(%ebp),%eax
     e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
     e10:	8b 45 08             	mov    0x8(%ebp),%eax
     e13:	89 04 24             	mov    %eax,(%esp)
     e16:	e8 cf f9 ff ff       	call   7ea <gettoken>
     e1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
     e1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e22:	75 05                	jne    e29 <parseexec+0x9f>
      break;
     e24:	e9 83 00 00 00       	jmp    eac <parseexec+0x122>
    if(tok != 'a')
     e29:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     e2d:	74 0c                	je     e3b <parseexec+0xb1>
      panic("syntax");
     e2f:	c7 04 24 0a 18 00 00 	movl   $0x180a,(%esp)
     e36:	e8 cd f7 ff ff       	call   608 <panic>
    cmd->argv[argc] = q;
     e3b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e41:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e44:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     e48:	8b 55 e0             	mov    -0x20(%ebp),%edx
     e4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e4e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     e51:	83 c1 08             	add    $0x8,%ecx
     e54:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     e58:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     e5c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     e60:	7e 0c                	jle    e6e <parseexec+0xe4>
      panic("too many args");
     e62:	c7 04 24 59 18 00 00 	movl   $0x1859,(%esp)
     e69:	e8 9a f7 ff ff       	call   608 <panic>
    ret = parseredirs(ret, ps, es);
     e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
     e71:	89 44 24 08          	mov    %eax,0x8(%esp)
     e75:	8b 45 08             	mov    0x8(%ebp),%eax
     e78:	89 44 24 04          	mov    %eax,0x4(%esp)
     e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e7f:	89 04 24             	mov    %eax,(%esp)
     e82:	e8 07 fd ff ff       	call   b8e <parseredirs>
     e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     e8a:	c7 44 24 08 67 18 00 	movl   $0x1867,0x8(%esp)
     e91:	00 
     e92:	8b 45 0c             	mov    0xc(%ebp),%eax
     e95:	89 44 24 04          	mov    %eax,0x4(%esp)
     e99:	8b 45 08             	mov    0x8(%ebp),%eax
     e9c:	89 04 24             	mov    %eax,(%esp)
     e9f:	e8 91 fa ff ff       	call   935 <peek>
     ea4:	85 c0                	test   %eax,%eax
     ea6:	0f 84 4f ff ff ff    	je     dfb <parseexec+0x71>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
     eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
     eb2:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     eb9:	00 
  cmd->eargv[argc] = 0;
     eba:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ec0:	83 c2 08             	add    $0x8,%edx
     ec3:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     eca:	00 
  return ret;
     ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ece:	c9                   	leave  
     ecf:	c3                   	ret    

00000ed0 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     ed0:	55                   	push   %ebp
     ed1:	89 e5                	mov    %esp,%ebp
     ed3:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     ed6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     eda:	75 0a                	jne    ee6 <nulterminate+0x16>
    return 0;
     edc:	b8 00 00 00 00       	mov    $0x0,%eax
     ee1:	e9 c9 00 00 00       	jmp    faf <nulterminate+0xdf>
  
  switch(cmd->type){
     ee6:	8b 45 08             	mov    0x8(%ebp),%eax
     ee9:	8b 00                	mov    (%eax),%eax
     eeb:	83 f8 05             	cmp    $0x5,%eax
     eee:	0f 87 b8 00 00 00    	ja     fac <nulterminate+0xdc>
     ef4:	8b 04 85 6c 18 00 00 	mov    0x186c(,%eax,4),%eax
     efb:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     efd:	8b 45 08             	mov    0x8(%ebp),%eax
     f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     f03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f0a:	eb 14                	jmp    f20 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f12:	83 c2 08             	add    $0x8,%edx
     f15:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     f19:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     f1c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f23:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f26:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     f2a:	85 c0                	test   %eax,%eax
     f2c:	75 de                	jne    f0c <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     f2e:	eb 7c                	jmp    fac <nulterminate+0xdc>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     f30:	8b 45 08             	mov    0x8(%ebp),%eax
     f33:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f39:	8b 40 04             	mov    0x4(%eax),%eax
     f3c:	89 04 24             	mov    %eax,(%esp)
     f3f:	e8 8c ff ff ff       	call   ed0 <nulterminate>
    *rcmd->efile = 0;
     f44:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f47:	8b 40 0c             	mov    0xc(%eax),%eax
     f4a:	c6 00 00             	movb   $0x0,(%eax)
    break;
     f4d:	eb 5d                	jmp    fac <nulterminate+0xdc>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     f4f:	8b 45 08             	mov    0x8(%ebp),%eax
     f52:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f58:	8b 40 04             	mov    0x4(%eax),%eax
     f5b:	89 04 24             	mov    %eax,(%esp)
     f5e:	e8 6d ff ff ff       	call   ed0 <nulterminate>
    nulterminate(pcmd->right);
     f63:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f66:	8b 40 08             	mov    0x8(%eax),%eax
     f69:	89 04 24             	mov    %eax,(%esp)
     f6c:	e8 5f ff ff ff       	call   ed0 <nulterminate>
    break;
     f71:	eb 39                	jmp    fac <nulterminate+0xdc>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     f73:	8b 45 08             	mov    0x8(%ebp),%eax
     f76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f7c:	8b 40 04             	mov    0x4(%eax),%eax
     f7f:	89 04 24             	mov    %eax,(%esp)
     f82:	e8 49 ff ff ff       	call   ed0 <nulterminate>
    nulterminate(lcmd->right);
     f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f8a:	8b 40 08             	mov    0x8(%eax),%eax
     f8d:	89 04 24             	mov    %eax,(%esp)
     f90:	e8 3b ff ff ff       	call   ed0 <nulterminate>
    break;
     f95:	eb 15                	jmp    fac <nulterminate+0xdc>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     f97:	8b 45 08             	mov    0x8(%ebp),%eax
     f9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
     fa0:	8b 40 04             	mov    0x4(%eax),%eax
     fa3:	89 04 24             	mov    %eax,(%esp)
     fa6:	e8 25 ff ff ff       	call   ed0 <nulterminate>
    break;
     fab:	90                   	nop
  }
  return cmd;
     fac:	8b 45 08             	mov    0x8(%ebp),%eax
}
     faf:	c9                   	leave  
     fb0:	c3                   	ret    

00000fb1 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     fb1:	55                   	push   %ebp
     fb2:	89 e5                	mov    %esp,%ebp
     fb4:	57                   	push   %edi
     fb5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     fb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
     fb9:	8b 55 10             	mov    0x10(%ebp),%edx
     fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
     fbf:	89 cb                	mov    %ecx,%ebx
     fc1:	89 df                	mov    %ebx,%edi
     fc3:	89 d1                	mov    %edx,%ecx
     fc5:	fc                   	cld    
     fc6:	f3 aa                	rep stos %al,%es:(%edi)
     fc8:	89 ca                	mov    %ecx,%edx
     fca:	89 fb                	mov    %edi,%ebx
     fcc:	89 5d 08             	mov    %ebx,0x8(%ebp)
     fcf:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     fd2:	5b                   	pop    %ebx
     fd3:	5f                   	pop    %edi
     fd4:	5d                   	pop    %ebp
     fd5:	c3                   	ret    

00000fd6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     fd6:	55                   	push   %ebp
     fd7:	89 e5                	mov    %esp,%ebp
     fd9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     fdc:	8b 45 08             	mov    0x8(%ebp),%eax
     fdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     fe2:	90                   	nop
     fe3:	8b 45 08             	mov    0x8(%ebp),%eax
     fe6:	8d 50 01             	lea    0x1(%eax),%edx
     fe9:	89 55 08             	mov    %edx,0x8(%ebp)
     fec:	8b 55 0c             	mov    0xc(%ebp),%edx
     fef:	8d 4a 01             	lea    0x1(%edx),%ecx
     ff2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     ff5:	0f b6 12             	movzbl (%edx),%edx
     ff8:	88 10                	mov    %dl,(%eax)
     ffa:	0f b6 00             	movzbl (%eax),%eax
     ffd:	84 c0                	test   %al,%al
     fff:	75 e2                	jne    fe3 <strcpy+0xd>
    ;
  return os;
    1001:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1004:	c9                   	leave  
    1005:	c3                   	ret    

00001006 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1006:	55                   	push   %ebp
    1007:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1009:	eb 08                	jmp    1013 <strcmp+0xd>
    p++, q++;
    100b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    100f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1013:	8b 45 08             	mov    0x8(%ebp),%eax
    1016:	0f b6 00             	movzbl (%eax),%eax
    1019:	84 c0                	test   %al,%al
    101b:	74 10                	je     102d <strcmp+0x27>
    101d:	8b 45 08             	mov    0x8(%ebp),%eax
    1020:	0f b6 10             	movzbl (%eax),%edx
    1023:	8b 45 0c             	mov    0xc(%ebp),%eax
    1026:	0f b6 00             	movzbl (%eax),%eax
    1029:	38 c2                	cmp    %al,%dl
    102b:	74 de                	je     100b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    102d:	8b 45 08             	mov    0x8(%ebp),%eax
    1030:	0f b6 00             	movzbl (%eax),%eax
    1033:	0f b6 d0             	movzbl %al,%edx
    1036:	8b 45 0c             	mov    0xc(%ebp),%eax
    1039:	0f b6 00             	movzbl (%eax),%eax
    103c:	0f b6 c0             	movzbl %al,%eax
    103f:	29 c2                	sub    %eax,%edx
    1041:	89 d0                	mov    %edx,%eax
}
    1043:	5d                   	pop    %ebp
    1044:	c3                   	ret    

00001045 <strlen>:

uint
strlen(char *s)
{
    1045:	55                   	push   %ebp
    1046:	89 e5                	mov    %esp,%ebp
    1048:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    104b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1052:	eb 04                	jmp    1058 <strlen+0x13>
    1054:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1058:	8b 55 fc             	mov    -0x4(%ebp),%edx
    105b:	8b 45 08             	mov    0x8(%ebp),%eax
    105e:	01 d0                	add    %edx,%eax
    1060:	0f b6 00             	movzbl (%eax),%eax
    1063:	84 c0                	test   %al,%al
    1065:	75 ed                	jne    1054 <strlen+0xf>
    ;
  return n;
    1067:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    106a:	c9                   	leave  
    106b:	c3                   	ret    

0000106c <memset>:

void*
memset(void *dst, int c, uint n)
{
    106c:	55                   	push   %ebp
    106d:	89 e5                	mov    %esp,%ebp
    106f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1072:	8b 45 10             	mov    0x10(%ebp),%eax
    1075:	89 44 24 08          	mov    %eax,0x8(%esp)
    1079:	8b 45 0c             	mov    0xc(%ebp),%eax
    107c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1080:	8b 45 08             	mov    0x8(%ebp),%eax
    1083:	89 04 24             	mov    %eax,(%esp)
    1086:	e8 26 ff ff ff       	call   fb1 <stosb>
  return dst;
    108b:	8b 45 08             	mov    0x8(%ebp),%eax
}
    108e:	c9                   	leave  
    108f:	c3                   	ret    

00001090 <strchr>:

char*
strchr(const char *s, char c)
{
    1090:	55                   	push   %ebp
    1091:	89 e5                	mov    %esp,%ebp
    1093:	83 ec 04             	sub    $0x4,%esp
    1096:	8b 45 0c             	mov    0xc(%ebp),%eax
    1099:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    109c:	eb 14                	jmp    10b2 <strchr+0x22>
    if(*s == c)
    109e:	8b 45 08             	mov    0x8(%ebp),%eax
    10a1:	0f b6 00             	movzbl (%eax),%eax
    10a4:	3a 45 fc             	cmp    -0x4(%ebp),%al
    10a7:	75 05                	jne    10ae <strchr+0x1e>
      return (char*)s;
    10a9:	8b 45 08             	mov    0x8(%ebp),%eax
    10ac:	eb 13                	jmp    10c1 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    10ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10b2:	8b 45 08             	mov    0x8(%ebp),%eax
    10b5:	0f b6 00             	movzbl (%eax),%eax
    10b8:	84 c0                	test   %al,%al
    10ba:	75 e2                	jne    109e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    10bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
    10c1:	c9                   	leave  
    10c2:	c3                   	ret    

000010c3 <gets>:

char*
gets(char *buf, int max)
{
    10c3:	55                   	push   %ebp
    10c4:	89 e5                	mov    %esp,%ebp
    10c6:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    10c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10d0:	eb 4c                	jmp    111e <gets+0x5b>
    cc = read(0, &c, 1);
    10d2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    10d9:	00 
    10da:	8d 45 ef             	lea    -0x11(%ebp),%eax
    10dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    10e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10e8:	e8 44 01 00 00       	call   1231 <read>
    10ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    10f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10f4:	7f 02                	jg     10f8 <gets+0x35>
      break;
    10f6:	eb 31                	jmp    1129 <gets+0x66>
    buf[i++] = c;
    10f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10fb:	8d 50 01             	lea    0x1(%eax),%edx
    10fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1101:	89 c2                	mov    %eax,%edx
    1103:	8b 45 08             	mov    0x8(%ebp),%eax
    1106:	01 c2                	add    %eax,%edx
    1108:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    110c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    110e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1112:	3c 0a                	cmp    $0xa,%al
    1114:	74 13                	je     1129 <gets+0x66>
    1116:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    111a:	3c 0d                	cmp    $0xd,%al
    111c:	74 0b                	je     1129 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    111e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1121:	83 c0 01             	add    $0x1,%eax
    1124:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1127:	7c a9                	jl     10d2 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1129:	8b 55 f4             	mov    -0xc(%ebp),%edx
    112c:	8b 45 08             	mov    0x8(%ebp),%eax
    112f:	01 d0                	add    %edx,%eax
    1131:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1134:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1137:	c9                   	leave  
    1138:	c3                   	ret    

00001139 <stat>:

int
stat(char *n, struct stat *st)
{
    1139:	55                   	push   %ebp
    113a:	89 e5                	mov    %esp,%ebp
    113c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    113f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1146:	00 
    1147:	8b 45 08             	mov    0x8(%ebp),%eax
    114a:	89 04 24             	mov    %eax,(%esp)
    114d:	e8 07 01 00 00       	call   1259 <open>
    1152:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1155:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1159:	79 07                	jns    1162 <stat+0x29>
    return -1;
    115b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1160:	eb 23                	jmp    1185 <stat+0x4c>
  r = fstat(fd, st);
    1162:	8b 45 0c             	mov    0xc(%ebp),%eax
    1165:	89 44 24 04          	mov    %eax,0x4(%esp)
    1169:	8b 45 f4             	mov    -0xc(%ebp),%eax
    116c:	89 04 24             	mov    %eax,(%esp)
    116f:	e8 fd 00 00 00       	call   1271 <fstat>
    1174:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1177:	8b 45 f4             	mov    -0xc(%ebp),%eax
    117a:	89 04 24             	mov    %eax,(%esp)
    117d:	e8 bf 00 00 00       	call   1241 <close>
  return r;
    1182:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1185:	c9                   	leave  
    1186:	c3                   	ret    

00001187 <atoi>:

int
atoi(const char *s)
{
    1187:	55                   	push   %ebp
    1188:	89 e5                	mov    %esp,%ebp
    118a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    118d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1194:	eb 25                	jmp    11bb <atoi+0x34>
    n = n*10 + *s++ - '0';
    1196:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1199:	89 d0                	mov    %edx,%eax
    119b:	c1 e0 02             	shl    $0x2,%eax
    119e:	01 d0                	add    %edx,%eax
    11a0:	01 c0                	add    %eax,%eax
    11a2:	89 c1                	mov    %eax,%ecx
    11a4:	8b 45 08             	mov    0x8(%ebp),%eax
    11a7:	8d 50 01             	lea    0x1(%eax),%edx
    11aa:	89 55 08             	mov    %edx,0x8(%ebp)
    11ad:	0f b6 00             	movzbl (%eax),%eax
    11b0:	0f be c0             	movsbl %al,%eax
    11b3:	01 c8                	add    %ecx,%eax
    11b5:	83 e8 30             	sub    $0x30,%eax
    11b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11bb:	8b 45 08             	mov    0x8(%ebp),%eax
    11be:	0f b6 00             	movzbl (%eax),%eax
    11c1:	3c 2f                	cmp    $0x2f,%al
    11c3:	7e 0a                	jle    11cf <atoi+0x48>
    11c5:	8b 45 08             	mov    0x8(%ebp),%eax
    11c8:	0f b6 00             	movzbl (%eax),%eax
    11cb:	3c 39                	cmp    $0x39,%al
    11cd:	7e c7                	jle    1196 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    11cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11d2:	c9                   	leave  
    11d3:	c3                   	ret    

000011d4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    11d4:	55                   	push   %ebp
    11d5:	89 e5                	mov    %esp,%ebp
    11d7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    11da:	8b 45 08             	mov    0x8(%ebp),%eax
    11dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    11e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    11e6:	eb 17                	jmp    11ff <memmove+0x2b>
    *dst++ = *src++;
    11e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11eb:	8d 50 01             	lea    0x1(%eax),%edx
    11ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
    11f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
    11f4:	8d 4a 01             	lea    0x1(%edx),%ecx
    11f7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    11fa:	0f b6 12             	movzbl (%edx),%edx
    11fd:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    11ff:	8b 45 10             	mov    0x10(%ebp),%eax
    1202:	8d 50 ff             	lea    -0x1(%eax),%edx
    1205:	89 55 10             	mov    %edx,0x10(%ebp)
    1208:	85 c0                	test   %eax,%eax
    120a:	7f dc                	jg     11e8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    120c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    120f:	c9                   	leave  
    1210:	c3                   	ret    

00001211 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1211:	b8 01 00 00 00       	mov    $0x1,%eax
    1216:	cd 40                	int    $0x40
    1218:	c3                   	ret    

00001219 <exit>:
SYSCALL(exit)
    1219:	b8 02 00 00 00       	mov    $0x2,%eax
    121e:	cd 40                	int    $0x40
    1220:	c3                   	ret    

00001221 <wait>:
SYSCALL(wait)
    1221:	b8 03 00 00 00       	mov    $0x3,%eax
    1226:	cd 40                	int    $0x40
    1228:	c3                   	ret    

00001229 <pipe>:
SYSCALL(pipe)
    1229:	b8 04 00 00 00       	mov    $0x4,%eax
    122e:	cd 40                	int    $0x40
    1230:	c3                   	ret    

00001231 <read>:
SYSCALL(read)
    1231:	b8 05 00 00 00       	mov    $0x5,%eax
    1236:	cd 40                	int    $0x40
    1238:	c3                   	ret    

00001239 <write>:
SYSCALL(write)
    1239:	b8 10 00 00 00       	mov    $0x10,%eax
    123e:	cd 40                	int    $0x40
    1240:	c3                   	ret    

00001241 <close>:
SYSCALL(close)
    1241:	b8 15 00 00 00       	mov    $0x15,%eax
    1246:	cd 40                	int    $0x40
    1248:	c3                   	ret    

00001249 <kill>:
SYSCALL(kill)
    1249:	b8 06 00 00 00       	mov    $0x6,%eax
    124e:	cd 40                	int    $0x40
    1250:	c3                   	ret    

00001251 <exec>:
SYSCALL(exec)
    1251:	b8 07 00 00 00       	mov    $0x7,%eax
    1256:	cd 40                	int    $0x40
    1258:	c3                   	ret    

00001259 <open>:
SYSCALL(open)
    1259:	b8 0f 00 00 00       	mov    $0xf,%eax
    125e:	cd 40                	int    $0x40
    1260:	c3                   	ret    

00001261 <mknod>:
SYSCALL(mknod)
    1261:	b8 11 00 00 00       	mov    $0x11,%eax
    1266:	cd 40                	int    $0x40
    1268:	c3                   	ret    

00001269 <unlink>:
SYSCALL(unlink)
    1269:	b8 12 00 00 00       	mov    $0x12,%eax
    126e:	cd 40                	int    $0x40
    1270:	c3                   	ret    

00001271 <fstat>:
SYSCALL(fstat)
    1271:	b8 08 00 00 00       	mov    $0x8,%eax
    1276:	cd 40                	int    $0x40
    1278:	c3                   	ret    

00001279 <link>:
SYSCALL(link)
    1279:	b8 13 00 00 00       	mov    $0x13,%eax
    127e:	cd 40                	int    $0x40
    1280:	c3                   	ret    

00001281 <mkdir>:
SYSCALL(mkdir)
    1281:	b8 14 00 00 00       	mov    $0x14,%eax
    1286:	cd 40                	int    $0x40
    1288:	c3                   	ret    

00001289 <chdir>:
SYSCALL(chdir)
    1289:	b8 09 00 00 00       	mov    $0x9,%eax
    128e:	cd 40                	int    $0x40
    1290:	c3                   	ret    

00001291 <dup>:
SYSCALL(dup)
    1291:	b8 0a 00 00 00       	mov    $0xa,%eax
    1296:	cd 40                	int    $0x40
    1298:	c3                   	ret    

00001299 <getpid>:
SYSCALL(getpid)
    1299:	b8 0b 00 00 00       	mov    $0xb,%eax
    129e:	cd 40                	int    $0x40
    12a0:	c3                   	ret    

000012a1 <sbrk>:
SYSCALL(sbrk)
    12a1:	b8 0c 00 00 00       	mov    $0xc,%eax
    12a6:	cd 40                	int    $0x40
    12a8:	c3                   	ret    

000012a9 <sleep>:
SYSCALL(sleep)
    12a9:	b8 0d 00 00 00       	mov    $0xd,%eax
    12ae:	cd 40                	int    $0x40
    12b0:	c3                   	ret    

000012b1 <uptime>:
SYSCALL(uptime)
    12b1:	b8 0e 00 00 00       	mov    $0xe,%eax
    12b6:	cd 40                	int    $0x40
    12b8:	c3                   	ret    

000012b9 <pstat>:
SYSCALL(pstat)
    12b9:	b8 16 00 00 00       	mov    $0x16,%eax
    12be:	cd 40                	int    $0x40
    12c0:	c3                   	ret    

000012c1 <printjob>:
SYSCALL(printjob)
    12c1:	b8 17 00 00 00       	mov    $0x17,%eax
    12c6:	cd 40                	int    $0x40
    12c8:	c3                   	ret    

000012c9 <attachjob>:
SYSCALL(attachjob)
    12c9:	b8 18 00 00 00       	mov    $0x18,%eax
    12ce:	cd 40                	int    $0x40
    12d0:	c3                   	ret    

000012d1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    12d1:	55                   	push   %ebp
    12d2:	89 e5                	mov    %esp,%ebp
    12d4:	83 ec 18             	sub    $0x18,%esp
    12d7:	8b 45 0c             	mov    0xc(%ebp),%eax
    12da:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    12dd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    12e4:	00 
    12e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
    12e8:	89 44 24 04          	mov    %eax,0x4(%esp)
    12ec:	8b 45 08             	mov    0x8(%ebp),%eax
    12ef:	89 04 24             	mov    %eax,(%esp)
    12f2:	e8 42 ff ff ff       	call   1239 <write>
}
    12f7:	c9                   	leave  
    12f8:	c3                   	ret    

000012f9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    12f9:	55                   	push   %ebp
    12fa:	89 e5                	mov    %esp,%ebp
    12fc:	56                   	push   %esi
    12fd:	53                   	push   %ebx
    12fe:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1301:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1308:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    130c:	74 17                	je     1325 <printint+0x2c>
    130e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1312:	79 11                	jns    1325 <printint+0x2c>
    neg = 1;
    1314:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    131b:	8b 45 0c             	mov    0xc(%ebp),%eax
    131e:	f7 d8                	neg    %eax
    1320:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1323:	eb 06                	jmp    132b <printint+0x32>
  } else {
    x = xx;
    1325:	8b 45 0c             	mov    0xc(%ebp),%eax
    1328:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    132b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1332:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1335:	8d 41 01             	lea    0x1(%ecx),%eax
    1338:	89 45 f4             	mov    %eax,-0xc(%ebp)
    133b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    133e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1341:	ba 00 00 00 00       	mov    $0x0,%edx
    1346:	f7 f3                	div    %ebx
    1348:	89 d0                	mov    %edx,%eax
    134a:	0f b6 80 1a 1d 00 00 	movzbl 0x1d1a(%eax),%eax
    1351:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1355:	8b 75 10             	mov    0x10(%ebp),%esi
    1358:	8b 45 ec             	mov    -0x14(%ebp),%eax
    135b:	ba 00 00 00 00       	mov    $0x0,%edx
    1360:	f7 f6                	div    %esi
    1362:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1365:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1369:	75 c7                	jne    1332 <printint+0x39>
  if(neg)
    136b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    136f:	74 10                	je     1381 <printint+0x88>
    buf[i++] = '-';
    1371:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1374:	8d 50 01             	lea    0x1(%eax),%edx
    1377:	89 55 f4             	mov    %edx,-0xc(%ebp)
    137a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    137f:	eb 1f                	jmp    13a0 <printint+0xa7>
    1381:	eb 1d                	jmp    13a0 <printint+0xa7>
    putc(fd, buf[i]);
    1383:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1386:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1389:	01 d0                	add    %edx,%eax
    138b:	0f b6 00             	movzbl (%eax),%eax
    138e:	0f be c0             	movsbl %al,%eax
    1391:	89 44 24 04          	mov    %eax,0x4(%esp)
    1395:	8b 45 08             	mov    0x8(%ebp),%eax
    1398:	89 04 24             	mov    %eax,(%esp)
    139b:	e8 31 ff ff ff       	call   12d1 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    13a0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    13a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13a8:	79 d9                	jns    1383 <printint+0x8a>
    putc(fd, buf[i]);
}
    13aa:	83 c4 30             	add    $0x30,%esp
    13ad:	5b                   	pop    %ebx
    13ae:	5e                   	pop    %esi
    13af:	5d                   	pop    %ebp
    13b0:	c3                   	ret    

000013b1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    13b1:	55                   	push   %ebp
    13b2:	89 e5                	mov    %esp,%ebp
    13b4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    13b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    13be:	8d 45 0c             	lea    0xc(%ebp),%eax
    13c1:	83 c0 04             	add    $0x4,%eax
    13c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    13c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13ce:	e9 7c 01 00 00       	jmp    154f <printf+0x19e>
    c = fmt[i] & 0xff;
    13d3:	8b 55 0c             	mov    0xc(%ebp),%edx
    13d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13d9:	01 d0                	add    %edx,%eax
    13db:	0f b6 00             	movzbl (%eax),%eax
    13de:	0f be c0             	movsbl %al,%eax
    13e1:	25 ff 00 00 00       	and    $0xff,%eax
    13e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    13e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13ed:	75 2c                	jne    141b <printf+0x6a>
      if(c == '%'){
    13ef:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    13f3:	75 0c                	jne    1401 <printf+0x50>
        state = '%';
    13f5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    13fc:	e9 4a 01 00 00       	jmp    154b <printf+0x19a>
      } else {
        putc(fd, c);
    1401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1404:	0f be c0             	movsbl %al,%eax
    1407:	89 44 24 04          	mov    %eax,0x4(%esp)
    140b:	8b 45 08             	mov    0x8(%ebp),%eax
    140e:	89 04 24             	mov    %eax,(%esp)
    1411:	e8 bb fe ff ff       	call   12d1 <putc>
    1416:	e9 30 01 00 00       	jmp    154b <printf+0x19a>
      }
    } else if(state == '%'){
    141b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    141f:	0f 85 26 01 00 00    	jne    154b <printf+0x19a>
      if(c == 'd'){
    1425:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1429:	75 2d                	jne    1458 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    142b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    142e:	8b 00                	mov    (%eax),%eax
    1430:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1437:	00 
    1438:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    143f:	00 
    1440:	89 44 24 04          	mov    %eax,0x4(%esp)
    1444:	8b 45 08             	mov    0x8(%ebp),%eax
    1447:	89 04 24             	mov    %eax,(%esp)
    144a:	e8 aa fe ff ff       	call   12f9 <printint>
        ap++;
    144f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1453:	e9 ec 00 00 00       	jmp    1544 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1458:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    145c:	74 06                	je     1464 <printf+0xb3>
    145e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1462:	75 2d                	jne    1491 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1464:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1467:	8b 00                	mov    (%eax),%eax
    1469:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1470:	00 
    1471:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1478:	00 
    1479:	89 44 24 04          	mov    %eax,0x4(%esp)
    147d:	8b 45 08             	mov    0x8(%ebp),%eax
    1480:	89 04 24             	mov    %eax,(%esp)
    1483:	e8 71 fe ff ff       	call   12f9 <printint>
        ap++;
    1488:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    148c:	e9 b3 00 00 00       	jmp    1544 <printf+0x193>
      } else if(c == 's'){
    1491:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1495:	75 45                	jne    14dc <printf+0x12b>
        s = (char*)*ap;
    1497:	8b 45 e8             	mov    -0x18(%ebp),%eax
    149a:	8b 00                	mov    (%eax),%eax
    149c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    149f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    14a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14a7:	75 09                	jne    14b2 <printf+0x101>
          s = "(null)";
    14a9:	c7 45 f4 84 18 00 00 	movl   $0x1884,-0xc(%ebp)
        while(*s != 0){
    14b0:	eb 1e                	jmp    14d0 <printf+0x11f>
    14b2:	eb 1c                	jmp    14d0 <printf+0x11f>
          putc(fd, *s);
    14b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b7:	0f b6 00             	movzbl (%eax),%eax
    14ba:	0f be c0             	movsbl %al,%eax
    14bd:	89 44 24 04          	mov    %eax,0x4(%esp)
    14c1:	8b 45 08             	mov    0x8(%ebp),%eax
    14c4:	89 04 24             	mov    %eax,(%esp)
    14c7:	e8 05 fe ff ff       	call   12d1 <putc>
          s++;
    14cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    14d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d3:	0f b6 00             	movzbl (%eax),%eax
    14d6:	84 c0                	test   %al,%al
    14d8:	75 da                	jne    14b4 <printf+0x103>
    14da:	eb 68                	jmp    1544 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    14dc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    14e0:	75 1d                	jne    14ff <printf+0x14e>
        putc(fd, *ap);
    14e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14e5:	8b 00                	mov    (%eax),%eax
    14e7:	0f be c0             	movsbl %al,%eax
    14ea:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ee:	8b 45 08             	mov    0x8(%ebp),%eax
    14f1:	89 04 24             	mov    %eax,(%esp)
    14f4:	e8 d8 fd ff ff       	call   12d1 <putc>
        ap++;
    14f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14fd:	eb 45                	jmp    1544 <printf+0x193>
      } else if(c == '%'){
    14ff:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1503:	75 17                	jne    151c <printf+0x16b>
        putc(fd, c);
    1505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1508:	0f be c0             	movsbl %al,%eax
    150b:	89 44 24 04          	mov    %eax,0x4(%esp)
    150f:	8b 45 08             	mov    0x8(%ebp),%eax
    1512:	89 04 24             	mov    %eax,(%esp)
    1515:	e8 b7 fd ff ff       	call   12d1 <putc>
    151a:	eb 28                	jmp    1544 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    151c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1523:	00 
    1524:	8b 45 08             	mov    0x8(%ebp),%eax
    1527:	89 04 24             	mov    %eax,(%esp)
    152a:	e8 a2 fd ff ff       	call   12d1 <putc>
        putc(fd, c);
    152f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1532:	0f be c0             	movsbl %al,%eax
    1535:	89 44 24 04          	mov    %eax,0x4(%esp)
    1539:	8b 45 08             	mov    0x8(%ebp),%eax
    153c:	89 04 24             	mov    %eax,(%esp)
    153f:	e8 8d fd ff ff       	call   12d1 <putc>
      }
      state = 0;
    1544:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    154b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    154f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1552:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1555:	01 d0                	add    %edx,%eax
    1557:	0f b6 00             	movzbl (%eax),%eax
    155a:	84 c0                	test   %al,%al
    155c:	0f 85 71 fe ff ff    	jne    13d3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1562:	c9                   	leave  
    1563:	c3                   	ret    

00001564 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1564:	55                   	push   %ebp
    1565:	89 e5                	mov    %esp,%ebp
    1567:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    156a:	8b 45 08             	mov    0x8(%ebp),%eax
    156d:	83 e8 08             	sub    $0x8,%eax
    1570:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1573:	a1 ac 1d 00 00       	mov    0x1dac,%eax
    1578:	89 45 fc             	mov    %eax,-0x4(%ebp)
    157b:	eb 24                	jmp    15a1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    157d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1580:	8b 00                	mov    (%eax),%eax
    1582:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1585:	77 12                	ja     1599 <free+0x35>
    1587:	8b 45 f8             	mov    -0x8(%ebp),%eax
    158a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    158d:	77 24                	ja     15b3 <free+0x4f>
    158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1592:	8b 00                	mov    (%eax),%eax
    1594:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1597:	77 1a                	ja     15b3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1599:	8b 45 fc             	mov    -0x4(%ebp),%eax
    159c:	8b 00                	mov    (%eax),%eax
    159e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15a7:	76 d4                	jbe    157d <free+0x19>
    15a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15ac:	8b 00                	mov    (%eax),%eax
    15ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    15b1:	76 ca                	jbe    157d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    15b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15b6:	8b 40 04             	mov    0x4(%eax),%eax
    15b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    15c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15c3:	01 c2                	add    %eax,%edx
    15c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15c8:	8b 00                	mov    (%eax),%eax
    15ca:	39 c2                	cmp    %eax,%edx
    15cc:	75 24                	jne    15f2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    15ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15d1:	8b 50 04             	mov    0x4(%eax),%edx
    15d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15d7:	8b 00                	mov    (%eax),%eax
    15d9:	8b 40 04             	mov    0x4(%eax),%eax
    15dc:	01 c2                	add    %eax,%edx
    15de:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15e1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    15e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15e7:	8b 00                	mov    (%eax),%eax
    15e9:	8b 10                	mov    (%eax),%edx
    15eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15ee:	89 10                	mov    %edx,(%eax)
    15f0:	eb 0a                	jmp    15fc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    15f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15f5:	8b 10                	mov    (%eax),%edx
    15f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15fa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    15fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15ff:	8b 40 04             	mov    0x4(%eax),%eax
    1602:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1609:	8b 45 fc             	mov    -0x4(%ebp),%eax
    160c:	01 d0                	add    %edx,%eax
    160e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1611:	75 20                	jne    1633 <free+0xcf>
    p->s.size += bp->s.size;
    1613:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1616:	8b 50 04             	mov    0x4(%eax),%edx
    1619:	8b 45 f8             	mov    -0x8(%ebp),%eax
    161c:	8b 40 04             	mov    0x4(%eax),%eax
    161f:	01 c2                	add    %eax,%edx
    1621:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1624:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1627:	8b 45 f8             	mov    -0x8(%ebp),%eax
    162a:	8b 10                	mov    (%eax),%edx
    162c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    162f:	89 10                	mov    %edx,(%eax)
    1631:	eb 08                	jmp    163b <free+0xd7>
  } else
    p->s.ptr = bp;
    1633:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1636:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1639:	89 10                	mov    %edx,(%eax)
  freep = p;
    163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    163e:	a3 ac 1d 00 00       	mov    %eax,0x1dac
}
    1643:	c9                   	leave  
    1644:	c3                   	ret    

00001645 <morecore>:

static Header*
morecore(uint nu)
{
    1645:	55                   	push   %ebp
    1646:	89 e5                	mov    %esp,%ebp
    1648:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    164b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1652:	77 07                	ja     165b <morecore+0x16>
    nu = 4096;
    1654:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    165b:	8b 45 08             	mov    0x8(%ebp),%eax
    165e:	c1 e0 03             	shl    $0x3,%eax
    1661:	89 04 24             	mov    %eax,(%esp)
    1664:	e8 38 fc ff ff       	call   12a1 <sbrk>
    1669:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    166c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1670:	75 07                	jne    1679 <morecore+0x34>
    return 0;
    1672:	b8 00 00 00 00       	mov    $0x0,%eax
    1677:	eb 22                	jmp    169b <morecore+0x56>
  hp = (Header*)p;
    1679:	8b 45 f4             	mov    -0xc(%ebp),%eax
    167c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1682:	8b 55 08             	mov    0x8(%ebp),%edx
    1685:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1688:	8b 45 f0             	mov    -0x10(%ebp),%eax
    168b:	83 c0 08             	add    $0x8,%eax
    168e:	89 04 24             	mov    %eax,(%esp)
    1691:	e8 ce fe ff ff       	call   1564 <free>
  return freep;
    1696:	a1 ac 1d 00 00       	mov    0x1dac,%eax
}
    169b:	c9                   	leave  
    169c:	c3                   	ret    

0000169d <malloc>:

void*
malloc(uint nbytes)
{
    169d:	55                   	push   %ebp
    169e:	89 e5                	mov    %esp,%ebp
    16a0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16a3:	8b 45 08             	mov    0x8(%ebp),%eax
    16a6:	83 c0 07             	add    $0x7,%eax
    16a9:	c1 e8 03             	shr    $0x3,%eax
    16ac:	83 c0 01             	add    $0x1,%eax
    16af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    16b2:	a1 ac 1d 00 00       	mov    0x1dac,%eax
    16b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    16ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    16be:	75 23                	jne    16e3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    16c0:	c7 45 f0 a4 1d 00 00 	movl   $0x1da4,-0x10(%ebp)
    16c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16ca:	a3 ac 1d 00 00       	mov    %eax,0x1dac
    16cf:	a1 ac 1d 00 00       	mov    0x1dac,%eax
    16d4:	a3 a4 1d 00 00       	mov    %eax,0x1da4
    base.s.size = 0;
    16d9:	c7 05 a8 1d 00 00 00 	movl   $0x0,0x1da8
    16e0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16e6:	8b 00                	mov    (%eax),%eax
    16e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    16eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ee:	8b 40 04             	mov    0x4(%eax),%eax
    16f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    16f4:	72 4d                	jb     1743 <malloc+0xa6>
      if(p->s.size == nunits)
    16f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16f9:	8b 40 04             	mov    0x4(%eax),%eax
    16fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    16ff:	75 0c                	jne    170d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1701:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1704:	8b 10                	mov    (%eax),%edx
    1706:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1709:	89 10                	mov    %edx,(%eax)
    170b:	eb 26                	jmp    1733 <malloc+0x96>
      else {
        p->s.size -= nunits;
    170d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1710:	8b 40 04             	mov    0x4(%eax),%eax
    1713:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1716:	89 c2                	mov    %eax,%edx
    1718:	8b 45 f4             	mov    -0xc(%ebp),%eax
    171b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    171e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1721:	8b 40 04             	mov    0x4(%eax),%eax
    1724:	c1 e0 03             	shl    $0x3,%eax
    1727:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    172a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    172d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1730:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1733:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1736:	a3 ac 1d 00 00       	mov    %eax,0x1dac
      return (void*)(p + 1);
    173b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    173e:	83 c0 08             	add    $0x8,%eax
    1741:	eb 38                	jmp    177b <malloc+0xde>
    }
    if(p == freep)
    1743:	a1 ac 1d 00 00       	mov    0x1dac,%eax
    1748:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    174b:	75 1b                	jne    1768 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    174d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1750:	89 04 24             	mov    %eax,(%esp)
    1753:	e8 ed fe ff ff       	call   1645 <morecore>
    1758:	89 45 f4             	mov    %eax,-0xc(%ebp)
    175b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    175f:	75 07                	jne    1768 <malloc+0xcb>
        return 0;
    1761:	b8 00 00 00 00       	mov    $0x0,%eax
    1766:	eb 13                	jmp    177b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1768:	8b 45 f4             	mov    -0xc(%ebp),%eax
    176b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    176e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1771:	8b 00                	mov    (%eax),%eax
    1773:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1776:	e9 70 ff ff ff       	jmp    16eb <malloc+0x4e>
}
    177b:	c9                   	leave  
    177c:	c3                   	ret    
