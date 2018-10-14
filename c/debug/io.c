#include "db.h"

char get_input() {
	char in;
	printf("> ");
	int err = scanf(" %c", &in);
	if (err < 0) {
		perror("scanf");
		return -1;
	}
	return in;
}

int get_mem_break() {
	long long int addr;
	printf("addr: ");
	int err = scanf(" %llx", &addr);
	if (err < 0) {
		perror("scanf");
		return -1;
	}
	return addr;
}
