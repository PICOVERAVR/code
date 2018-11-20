#include "libassist.h"

// function to free all parameters passed to it
// first parameter is how many parameters there are
void __assist_free_all(int numfree, void *arg1, ...) {
    va_list args;
    void *vp;
    free(arg1);
    va_start(args, arg1);

    for(int i = 0; i < numfree-1; i++) {
        vp = va_arg(args, void *);
        free(vp);
    }

    va_end(args);
}

// version of asprintf to use when asprintf isn't available
// WARNING: this allocates memory that needs to be freed!
// modified from 21st century C book
int __assist_asprintf(char **str, char *fmt, ...) {
	va_list argp;
	va_start(argp, fmt);
	char one[1];
	int len = vsnprintf(one, 1, fmt, argp); // check for formatting errors
	if (len < 1) { // formatting error occurred, returning error code
		return len;
	}
	va_end(argp);

	*str = malloc(len+1);
	if (!str) {
		perror("malloc");
		return -1;
	}

	va_start(argp, fmt);
	vsnprintf(*str, len+1, fmt, argp);
	va_end(argp);
	return len;
}

