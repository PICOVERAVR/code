#include "header.h"

void test(int *p) {
	*p = 42;;
}


int main(int argc, char **argv) {
	
	int *p = malloc(1);
	test(p);
	
}
