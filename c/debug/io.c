#include "db.h"

typedef struct cmd_string_s {
	int num;
	const char *str;
	const char *short_str;
} cmd_string;

cmd_string list_cmd [END_CMD] = {{DUMP_REGS, "dump", "d"},
	{SINGLE_STEP, "step", "s"},
	{B_CONTINUE,  "continue", "c"},
	{B_BREAK,     "break", "b"},
	{PROG_INFO,   "info", "i"},
	{KILL_QUIT,   "quit", "q"},
	{HELP,        "help", "h"}
};

int get_input() {
	char in[512];
	printf("> ");
	int err = scanf(" %s", in); // remove newline here?
	if (err < 0) {
		perror("scanf");
		return -1;
	} else {
		for (int i = 0; i < END_CMD; i++) { // latter could be a character... don't just cmp first character of string.
			if (strcmp(in, list_cmd[i].str) == 0 || strcmp(in, list_cmd[i].short_str) == 0) {
				return list_cmd[i].num;
			}
		}
	}
	return -1;
}

int get_mem_break() {
	long long int addr;
	int err = scanf(" %llx", &addr);
	if (err < 0) {
		perror("scanf");
		return -1;
	}
	return addr;
}
