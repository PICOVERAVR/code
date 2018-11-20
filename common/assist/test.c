// gcc -Wall test.c -o test.out -lassist
#include <stdio.h>
#include "libassist.h"

int main() {
	printf("malloc'ing memory...\n");
	int *p = malloc(sizeof(int) * 32);
	
	printf("freeing memory...\n");
	__assist_free_all(1, p);
	
	printf("done.\n");
	return 0;
}
