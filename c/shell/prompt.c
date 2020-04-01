#include "header.h"
#define Func(x) functab[(uint8_t)hash(x)]

int (*functab[255])(char *); //lookup table of all known functions, kinda small
char *argbuf[8]; //formatted input, not a ton of args

int sqrt_shell(char *args) {
	//return sqrt((double)atoi(strtok(args, "-")));
	return sqrt(atoi("43")); //always fails if not a literal number.  compiler or linker bug?
}

long hash(char *str) {
    unsigned long seed = 5381;
    int c;

    while (c = *str++) {
        seed = ((seed << 5) + seed) + c; /* seed * 33 + c */
    }

    return seed;
}

void funcset(void) {
	Func("sin") = sqrt_shell;
}

int main(void) {
	char combuf[128]; //raw input
	char *tok; //active token
	
	printf("initializing...");
	memset((void*)functab, 0, 255*sizeof(int*));
	funcset(); //add functions!
	printf("done.\n");
	
	printf("KSH v1.0, by Kyle Neil, 7/17\n");
	printf("Ready. (use com-arg-arg...)\n");
	for(;;) {
		printf("~ ");
		scanf("%s", combuf);
		int i = 0;
		for (tok = strtok(combuf, "-"); tok != NULL; tok = strtok(NULL, "-")) {
			argbuf[i++] = tok;
		} 
		argbuf[i++] = NULL;
		if (functab[(uint8_t)hash(argbuf[0])] !=  NULL) {
			printf("stop code %d.\n", functab[(uint8_t)hash(argbuf[0])](argbuf[1])); //exec the function given all args
		} else {
			printf("unknown command \"%s\"\n", argbuf[0]);
		}
	}
	return -1;	
}
