#include "proc.h"

uint32_t *proc_setup(int argc, char **argv, proc *p) {
	if (argc < 2) {
		fprintf(stderr, "ERR: no hex file provided!\n");
		return NULL;
	}
	
	FILE *hex = fopen(*(argv+1), "rb"); // get the hex file and load it into memory
	if (hex == NULL) {
		fprintf(stderr, "ERR: unable to open hex file!\n");
		return NULL;
	}
	
	fseek(hex, 0, SEEK_END);
	long hex_size = ftell(hex);
	rewind(hex);
	
	uint32_t *hex_mem = malloc(hex_size+1);
	int err = fread(hex_mem, sizeof(uint32_t), hex_size, hex);
	if (err * sizeof(uint32_t) != hex_size) {
		perror("fread");
		return NULL;
	}
	fclose(hex);
	
	hex_mem[hex_size-1] = 0; // make the file NULL-terminated, for ease of mind

	memset(p, 0, sizeof(proc)); // clear proc state
	return hex_mem;
}
