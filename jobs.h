/*
 * jobs.h
 */

#ifndef JOBS_H_
#define JOBS_H_


struct job {
	int jid;
	int fd;
	char cmd[64];
	struct job* next;
	struct job* prev;
};

struct joblist {
	struct job* first;
	struct job* last;
	struct job* fgJob; // Pointer to forground job, or 0 if there is no such job.
};


#endif /* JOBS_H_ */
