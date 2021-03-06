#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "jobs.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  int status;
	if (argint(0, &status) < 0)
		return -1;			//Mybe need to add exit(-1)???
	exit(status);
  return 0;  // not reached
}

int
sys_wait(void)
{
  int status;
  if (argint(0, &status) < 0)		//If there is no process
    return -1;
  return wait((int*)status);		
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;
  
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_pstat(void) {
	struct procstat *stat=0;
	int pid;
	  if (argint(0, &pid) < 0)
		  return -1;
	  if(argptr(1, (char**)&stat, 4) < 0)
		  return -1;

	int ret = pstat(pid, (struct procstat *)stat);
	return ret;
}

int
sys_attachjob(void) {
	int pid;
	int job;
	if (argint(0, &pid) < 0 || argint(1, &job) < 0)
		return -1;
	return attachjob(pid, (struct job*) job);
}

int
sys_isJobEmpty(void) {
	int jid;
	if (argint(0, &jid) < 0)
		return -1;
	return isJobEmpty(jid);
}

int
sys_printjob(void) {
	int jid;
	if (argint(0, &jid) < 0)
		return -1;
	return printjob(jid);
}

int
sys_fg(void) {
	int jid;
	if (argint(0, &jid) < 0)
		return -1;
	return fg(jid);
}


int
sys_waitpid(void)
{
	int pid;
	int status;

	if ( (argint(0, &pid) < 0) | (argint(1, &status) < 0) )
		return -1;
	return waitpid(pid, (int*)status);
}

int
sys_signal(void)
{
	int signum;
	int handler;

	if ( (argint(0, &signum) < 0) | (argint(1, &handler) < 0) )
		return -1;
	return signal(signum, (sighandler_t)handler);
}