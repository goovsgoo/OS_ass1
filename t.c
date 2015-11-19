#include "types.h"
#include "stat.h"
#include "user.h"

char *argv[] ={"cat", 0};

int main() {	
	kill(2);
	sleep(1);
	if (fork()==0) {		
		exec(argv[0], argv);
	}
	exit(0);
}
