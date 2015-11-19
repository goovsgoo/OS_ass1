#include "types.h"
#include "stat.h"
#include "user.h"

char buf[512];

///////////////////debag
enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// system call which will return (via variable stat) information regarding the process with a given pid.
//The returned information is defined by
struct procstat {
char name[16]; // process name
uint sz; // size of memory
uint nofile; // amount of open file descriptors
enum procstate state; // process state
};
////////

void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    write(1, buf, n);
  if(n < 0){
    printf(1, "cat: read error\n");
    exit(-1);
  }
}

int
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit(-1);
    }
    cat(fd);
    close(fd);
  }
  ////////////debag
  struct procstat *stat = malloc(sizeof(struct procstat));
  int ret =  pstat(3, stat);
  printf(1,"log:: pstat- isWork-> %d; ",ret);
  printf(1,"name: ");  printf(1,"%s ",stat->name);
  printf(1,"state: "); printf(1,"%d ",stat->state);
  printf(1,"sz: "); printf(1,"%d ",stat->sz);
  printf(1,"nofile: "); printf(1," %d\n ",stat->nofile);

  //////////////
  exit(0);
}
