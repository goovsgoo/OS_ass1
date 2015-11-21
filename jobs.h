/*
 * jobs.h
 */

#ifndef JOBS_H_
#define JOBS_H_


struct job {
	int jid;
	int fd;
	int isFG;
	char cmd[64];
	struct job* next;
	struct job* prev;
};

struct joblist {
	struct job* first;
	struct job* last;
};


#endif /* JOBS_H_ */
