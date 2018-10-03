#include <stdio.h>
#include <omp.h>

int global = 0;

int func() {
	int tid;
	#pragma omp parallel private(tid)
	{
		tid = omp_get_thread_num();
		printf("T%d, global val %d, setting to %d\n", tid, global, tid);
		global = tid;
	}

	return 0;
}

int main() {
	
	printf("In master thread\n");
	func();
	printf("done\n");
}
