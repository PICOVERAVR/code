#include "proc.h"

void proc_setup(int argc, char **argv, uint32_t *hex_mem, state *s) {
	if (argc < 2) {
		fprintf(stderr, "no hex file provided!\n");
		exit(ERR_NO_FILE);
	}
	
	FILE *hex = fopen(*(argv+1), "rb"); //get the hex file and load it into memory
	if (hex == NULL) {
		fprintf(stderr, "unable to open hex file!\n");
		exit(ERR_CANNOT_LOAD_FILE);
	}
	
	fseek(hex, 0, SEEK_END);
	long hex_size = ftell(hex);
	rewind(hex);
	
	hex_mem = malloc(hex_size+1);
	fread(hex_mem, sizeof(uint32_t), hex_size, hex);
	fclose(hex);
	
	hex_mem[hex_size] = 0; //make the file a string?
	
	s = malloc(sizeof(state));
	memset(s, 0, sizeof(state)); //initialize processor state and set to zero
}

void proc_teardown(uint32_t *hex_mem) {
	free(hex_mem);
}
