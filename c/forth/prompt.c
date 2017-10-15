#include "header.h"

int main(void) {
	char *argbuf[32] = {0}; //formatted input, not a ton of room
	char combuf[128] = {0}; //raw input
	char *tok; //active token
	
	printf("initializing...");
	memset((void*)functab, 0, 65535*sizeof(int*));
	
 	add_core_all();
	heaptr = malloc(2048 * sizeof(int));

	printf("done.\n");
	
	printf("Kforth v1.0, by Kyle Neil, 8/17\n");
	printf("Ready.\n");
	for(;;) {
		printf("> ");
		gets(combuf); //not safe
		int len = 0;
		for (tok = strtok(combuf, " "); tok != NULL; tok = strtok(NULL, " ")) {
			argbuf[len++] = tok;
		}
		argbuf[len] = NULL;
		for (int i = 0; i < len; i++) {
			
			char *err;
			int topush = strtol(argbuf[i], &err, 10); 
			if (functab[(uint16_t)hash(argbuf[i])].funcptr != NULL) {
				functab[(uint16_t)hash(argbuf[i])].funcptr();
			} else if (err != argbuf[i] && err != '\0') { 
				push(topush);
			} else {
				printf("??\n");
			}
		}
	}
	return -1;
}
