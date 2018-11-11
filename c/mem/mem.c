// valgrind -v db.out
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

// frees all memory passed to it
// first param is how many things to free
void free_all(int numfree, void *arg1, ...) {
	va_list args;
    void *vp;
    free(arg1);
	va_start(args, arg1);

    for(int i = 0; i < numfree-1; i++) {
        vp = va_arg(args, void *);
        printf("freeing %p\n", vp);
        free(vp);
    }
    
    va_end(args);
}

int main() {
	
	int *p = malloc(sizeof(int) * 80);
	int *q = malloc(sizeof(int) * 32);
	int *r = malloc(sizeof(int) * 12);
	
	free_all(3, p, q, r);
	
}
