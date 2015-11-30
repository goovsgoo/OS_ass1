// Shell.

#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "jobs.h"

// Parsed command representation
#define EXEC  1
#define REDIR 2
#define PIPE  3
#define LIST  4
#define BACK  5

#define MAXARGS 10

struct cmd {
  int type;
};

struct execcmd {
  int type;
  char *argv[MAXARGS];
  char *eargv[MAXARGS];
};

struct redircmd {
  int type;
  struct cmd *cmd;
  char *file;
  char *efile;
  int mode;
  int fd;
};

struct pipecmd {
  int type;
  struct cmd *left;
  struct cmd *right;
};

struct listcmd {
  int type;
  struct cmd *left;
  struct cmd *right;
};

struct backcmd {
  int type;
  struct cmd *cmd;
};

///////////////////////
// Function defenitions
///////////////////////

int fork1(void);  // Fork but panics on failure.
void panic(char*);
struct cmd *parsecmd(char*);
void removeJobFromList(struct joblist* list, struct job* job);
void addJobToList(struct joblist* jlist, struct job* job);
void clearFinishedJobs(struct joblist* jlist);

///////////////////////

int jobs_pipe[2];
char childBuf[100];
struct joblist* jlist;
  
// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
  int p[2];
  struct backcmd *bcmd;
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;
  int status;			//For wait func

  if(cmd == 0)
    exit(0);
  
  switch(cmd->type){
  default:
    panic("runcmd");

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    
    //read(0, childBuf, 100);
    //printf(1, "executing command %s\n", childBuf);
    
    if(ecmd->argv[0] == 0)
      exit(0);
    
    exec(ecmd->argv[0], ecmd->argv);
    printf(2, "exec %s failed\n", ecmd->argv[0]);  
    exit(-1);
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
      exit(-1);
    }
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
      runcmd(lcmd->left);
    wait(&status);
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
      close(1);
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
      close(0);
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }
    close(p[0]);
    close(p[1]);
    wait(&status);
    wait(&status);
    break;
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    runcmd(bcmd->cmd);
    break;
  }
  exit(0);
}

int
getcmd(char *buf, int nbuf, int bPrintDollar)
{
  if (bPrintDollar) {
    printf(2, "$ ");
  }
  
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  
  if (buf[0] == 0 && jlist->fgJob != 0) {
      close(jlist->fgJob->fd);
      jlist->fgJob = 0;
  }
  else if (buf[0] == 0) {
    return -1;
  }
      
  char *t = buf;
  while (*t++ != '\0');
  
  return t - buf - 1;
}

int
main(void)
{
  static char buf[100];
  int fd;
  //int status;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
    if(fd >= 3){
      close(fd);
      break;
    }
  }
  
  // Read and run input commands.
  int jobcntr = 0;
  jlist = malloc(sizeof(*jlist));
  jlist->first = 0;
  jlist->last = 0;
  jlist->fgJob = 0;
  
  int waitStatus;
  int bPrintDollar = 1;
  int cmdLen = 0;
  while((cmdLen = getcmd(buf, sizeof(buf), bPrintDollar)) >= 0){

      clearFinishedJobs(jlist);
	
      // Check if there's a forground job running. 
      // If so - the shell should not function, but only transfer the data received from the console to the job's pipe
      if (jlist->fgJob != 0) {
	  bPrintDollar = 0;
	  write(jlist->fgJob->fd, buf, cmdLen);
	  continue;
      }
      bPrintDollar = 1;
      
      if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
	// Clumsy but will have to do for now.
	// Chdir has no effect on the parent if run in the child.
	buf[strlen(buf)-1] = 0;  // chop \n
	if(chdir(buf+3) < 0)
	  printf(2, "cannot cd %s\n", buf+3);
	continue;
      }

      if(buf[0] == 'j' && buf[1] == 'o' && buf[2] == 'b' && buf[3] == 's' && (buf[4] == '\n' || buf[4] == ' ')) {
	  struct job* job = jlist->first;
	  while (job != 0) {
	      printjob(job->jid);
	      job = job->next;
	  }
	  if (!jlist->first)
		  printf(1, "There are no jobs.\n");
	  continue;
      }

      if(buf[0] == 'f' && buf[1] == 'g' && (buf[2] == '\n' || buf[2] == ' ')) {
	  char* c = &buf[3];

	  int jid = atoi(c);

	  struct job* j = jlist->first;
	  while ( j->jid != jid && j != 0) {
	      j = j->next;
	  }
	  jlist->fgJob = j;
	  //fg(jid);
	  continue;
      }

      // 0x0A - new line
      if (buf[0] != 0x0A ) { 
	
	  // create a pipe so the the shell sends the input to jobs_pipe[1] and the new process gets it in jobs_pipe[0]
	  if (pipe(jobs_pipe) == -1) {
	      panic("pipe");
	  }	  
	  
	  struct job* job;
	  job = malloc(sizeof(*job));
	  memset(job, 0, sizeof(*job));
	  job->jid = ++jobcntr;
	  job->fd = jobs_pipe[1];
	  
	  //char* s = job->cmd;
	  //char* t = buf;
	  //int i = sizeof(buf);
	  //while(--i > 0 && *t != '\n' && (*s++ = *t++) != 0) ;
	  //*s = 0;

	  

	  struct cmd* command = parsecmd(buf);
	  int childPid = fork1();
	  if(childPid == 0) {	    
	      close(0);	      
	      dup(jobs_pipe[0]);
	      close(jobs_pipe[1]);
	      if(fork1() == 0)
		  runcmd(command);
	      exit(0);
	  }
	  close(jobs_pipe[0]); // The shell doesn't need the READ end.
	  
	  attachjob(childPid, job); // Attach proc to job (Sys call)
		      
	  // shell writes the input to job_buffer ONLY IF the cmd isn't a backgraound job
	  if (command->type != BACK) {
	      jlist->fgJob = job;
	      bPrintDollar = 0;
	  }
	  
	  addJobToList(jlist, job);
	  
	  wait(&waitStatus);
      }
    }
    exit(0);
}


void clearFinishedJobs(struct joblist* jlist) {
    struct job* job = jlist->first;
    while (job != 0) {
	if (isJobEmpty(job->jid) == 1) { //no processes - delete job.
	    close(job->fd);
	    free(job);
	    removeJobFromList(jlist, job);		    
	}
	job = job->next;
    }  
}

void addJobToList(struct joblist* jlist, struct job* job)
{
    if (jlist->first == 0) {
	    jlist->first = job;
	    jlist->last = job;
    } 
    else {
	    job->prev = jlist->last;
	    jlist->last->next = job;
	    jlist->last = job;
    }
}

void removeJobFromList(struct joblist* jlist, struct job* job)
{  
    if (jlist->fgJob == job)
	jlist->fgJob = 0;
    
    if (jlist->first == job && jlist->last == job)
	    jlist->first = 0;
    if (jlist->first == job)
	    jlist->first = job->next;
    if (jlist->last == job)
	    jlist->last = job->prev;
    
    if (job->prev)
	    job->prev->next = job->next;
    if (job->next)
	    job->next->prev = job->prev;
}

void
panic(char *s)
{
  printf(2, "%s\n", s);
  exit(0);
}

int
fork1(void)
{
  int pid;
  
  pid = fork();
  if(pid == -1)
    panic("fork");
  return pid;
}

//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = REDIR;
  cmd->cmd = subcmd;
  cmd->file = file;
  cmd->efile = efile;
  cmd->mode = mode;
  cmd->fd = fd;
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = PIPE;
  cmd->left = left;
  cmd->right = right;
  return (struct cmd*)cmd;
}

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = LIST;
  cmd->left = left;
  cmd->right = right;
  return (struct cmd*)cmd;
}

struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = BACK;
  cmd->cmd = subcmd;
  return (struct cmd*)cmd;
}
//PAGEBREAK!
// Parsing

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
  case '|':
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
}

struct cmd *parseline(char**, char*);
struct cmd *parsepipe(char**, char*);
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
  peek(&s, es, "");
  if(s != es){
    printf(2, "leftovers: %s\n", s);
    panic("syntax");
  }
  nulterminate(cmd);
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
  if(!peek(ps, es, ")"))
    panic("syntax - missing )");
  gettoken(ps, es, 0, 0);
  cmd = parseredirs(cmd, ps, es);
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
  int i;
  struct backcmd *bcmd;
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    *rcmd->efile = 0;
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    nulterminate(pcmd->left);
    nulterminate(pcmd->right);
    break;
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
