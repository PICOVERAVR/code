#include "header.h"

pthread_attr_t global_thread_attr;

void init(void) {
	size_t stacksize;
	void *stackaddr; //add stack address in the future, could be fun

	pthread_attr_getstacksize(&global_thread_attr, &stacksize);

	printf("\tGlobal Thread Attributes\n");
	printf("~ %lu MB of stack space\n", stacksize / 1048576);

	printf("\tStats done\n\n");
}

void *func(void *tid) {
	printf("Thread %ld, checking in.\n", (long int) tid);
	
	
	pthread_exit((void*) ((long int) tid * 2));
}


int main(int argc, char **argv) {
	
	long int nthreads;
	
	if (argc > 1) {
		nthreads = strtol(argv[1]+1, NULL, 10);			
		if (!nthreads) {
			printf("use ./p.out -<thread_num>\n");
			exit(-1);
		}
	} else {
		nthreads = 4;
	}
	

	pthread_t threadlist[nthreads]; //master array of thread instances
	
	pthread_once_t init_attr;

	pthread_attr_init(&global_thread_attr);
	pthread_once(&init_attr, init); //run init once
	
	void *status; //return status for thread

	for (long int i = 0; i < nthreads; i++) {
		if (pthread_create(&threadlist[i], NULL, func, (void*) i)) {
			printf("error creating thread %ld, terminating\n", i);
			exit(-1);
		}
	}
	
	for (long int i = 0; i < nthreads; i++) {
		if (pthread_join(threadlist[i], &status)) {
			printf("error joining thread %ld, terminating\n", i);
			exit(-1);
		} else {
			printf("thread %ld exited with code %ld\n", i, (long int) status);
		}
	}
	
	pthread_exit(NULL); //wait for all threads to finish before quitting
}
