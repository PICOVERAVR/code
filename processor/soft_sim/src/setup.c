#include "proc.h"

const char *help_string = "proc -vhb: \
\nh: print help menu \
\nv: print version info \
\nb <path>: pass path to simulator";

const char *version_string = "Fives 0.2, by Kyle Neil";
// sets up execution environment for the processor
// by loading the file passed to it into memory and resetting the processor

uint32_t *proc_setup(int argc, char **argv) {
	if (argc < 2) {
		fprintf(stderr, "INFO: No arguments provided, doing nothing.\n");
		exit(0);
	}
	
	int c;
	char *hex_path = NULL;
	while ((c = getopt(argc, argv, "vhb:")) != -1) {
		switch (c) {
			case 'v':
				printf("%s\n", version_string);
				exit(0);
			case 'h':
				printf("%s\n", help_string);
				exit(0);
			case 'b':
				hex_path = optarg;
				break;
			case '?':
				break;
		}
	}
	
	FILE *hex = fopen(hex_path, "rb"); // get the hex file and load it into memory
	if (hex == NULL) {
		perror("ERR");
		return NULL;
	}
	
	fseek(hex, 0, SEEK_END);
	long hex_size = ftell(hex);
	rewind(hex);
	
	uint32_t *hex_mem = malloc(hex_size+1);
	int err = fread(hex_mem, sizeof(uint32_t), hex_size, hex);
	if (err != hex_size / 4) {
		perror("fread");
		return NULL;
	}
	fclose(hex);
	
	return hex_mem;
}
