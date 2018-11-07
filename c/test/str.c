#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char **argv) {
	if (argc < 2) {
		printf("please supply an argument.\n");
		exit(1);
	}
	
	char *strm = malloc(sizeof(char) * strlen(argv[1]));
	char strs[strlen(argv[1])];
	
	strcpy(strs, argv[1]);
	strcpy(strm, argv[1]);
	
	puts(strs);
	puts(strm);
	
	free(strm);
}
