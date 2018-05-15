#include "header.h"

#define start() uint64_t start = mach_absolute_time()
#define end(time) time = mach_absolute_time() - start;

int main(int argc, char **argv) {
	volatile int* restrict p = malloc(15 * sizeof(int));
	
	volatile int src = *(p+4);
	volatile register int result;
	
	mach_timebase_info_data_t info;
	mach_timebase_info(&info);
	uint64_t duration;
	
	start();
	asm("nop");	
	
	//stuff goes here
	
	asm("nop");
	end(duration);
	
	duration *= info.numer;
	duration /= info.denom;
	
	double duration_us = duration / 1000;
	
	printf("Time taken was: %llu ns, %f us\n", duration, duration_us);
	
	
	return 0;
}

