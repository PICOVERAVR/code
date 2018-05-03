#include "header.h"
#define NUM_THREADS 4

typedef struct thread_msg {
	long thread_id;
	long *global_num;
} thread_msg;

pthread_mutex_t mut;

void *func(void *p) {
	thread_msg *t = (thread_msg*) p;
	long tid = t->thread_id;
	
	printf("thread %ld checking in\n", tid);
	
	pthread_mutex_lock(&mut);
	*t->global_num = tid;
	pthread_mutex_unlock(&mut);
	
	pthread_exit(NULL);
}


int main(int argc, char **argv) {
	long *global_num = malloc(sizeof(long));
	pthread_t *threadList = malloc(sizeof(pthread_t) * NUM_THREADS);
	thread_msg *threadArgList = malloc(sizeof(thread_msg) * NUM_THREADS);
	
	pthread_mutex_init(&mut, NULL);
	
	for (long i = 0; i < NUM_THREADS; i++) {
		threadArgList[i].thread_id = i;
		threadArgList[i].global_num = global_num;
		
		pthread_create(&threadList[i], NULL, func, (void *)&threadArgList[i]);
	}
	
	//this has to be in here. If it is removed, the threadList memory will get freed before the threads are done!
	void *status;
	for (long i = 0; i < NUM_THREADS; i++) {
		pthread_join(threadList[i], &status);
	}
	
	printf("global is %ld\n", *global_num);
	free(global_num);
	free(threadList);
	free(threadArgList);
	
	pthread_mutex_destroy(&mut);
	pthread_exit(NULL);
}
