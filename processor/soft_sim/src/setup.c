#include "setup.h"

const char *help_string = "-vhb: \
\nh: print help menu \
\nv: print version info \
\nb <path>: pass path to simulator \
\n";

const char *gpl_string_short = "Copyright (C) 2018, Kyle Neil \
\n    This program comes with ABSOLUTELY NO WARRANTY. \
\n    This is free software, and you are welcome to redistribute it \
\n    under certain conditions; re-run with '-v' for details. \
\n\n";

const char *gpl_string_full = "Copyright (C) 2018, Kyle Neil \
\n																	  \
\n    This program is free software: you can redistribute it and/or modify \
\n    it under the terms of the GNU General Public License as published by \
\n    the Free Software Foundation, either version 3 of the License, or \
\n    (at your option) any later version. \
\n										\
\n    This program is distributed in the hope that it will be useful, \
\n    but WITHOUT ANY WARRANTY; without even the implied warranty of \
\n    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  \
\n    GNU General Public License for more details. \
\n												 \
\n    You should have received a copy of the GNU General Public License \
\n    along with this program.  If not, see <http://www.gnu.org/licenses/>. \
\n\n";

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
				printf("%s %s", PACKAGE_STRING, gpl_string_full);
				exit(0);
			case 'h':
				printf("%s %s", PACKAGE_STRING, help_string);
				exit(0);
			case 'b':
				hex_path = optarg;
				break;
			case '?':
				break;
		}
	}
		
	printf("%s %s", PACKAGE_STRING, gpl_string_short);
	
	
	FILE *hex = fopen(hex_path, "rb"); // get the hex file and load it into memory
	if (hex == NULL) {
		perror("fopen");
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
