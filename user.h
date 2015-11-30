struct stat;
struct rtcdate;
struct procstat;
struct job;

// system calls
int fork(void);
int exit(int status) __attribute__((noreturn));
int wait(int *status);
int pipe(int*);
int write(int, void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(char*, char**);
int open(char*, int);
int mknod(char*, short, short);
int unlink(char*);
int fstat(int fd, struct stat*);
int link(char*, char*);
int mkdir(char*);
int chdir(char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);

// new system calls
int pstat(int pid, struct procstat *stat);
int printjob(int jid);
int isJobEmpty(int jid);
int attachjob(int pid, struct job* job);
int fg(int jid);
int waitpid(int pid, int* status, int options);
sighandler_t signal(int signum, sighandler_t handler);

// ulib.c
int stat(char*, struct stat*);
char* strcpy(char*, char*);
void *memmove(void*, void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void printf(int, char*, ...);
char* gets(char*, int max);
uint strlen(char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);
