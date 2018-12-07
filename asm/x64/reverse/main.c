#include "header.h"

bool check_access(const char *check_str, const char *ref_str) {
	return strcmp(check_str, ref_str);
}

int main(int argc, char **argv) {
	int magic_num = 55;
	char user_buf[50];
	printf("Enter password:\n> ");
	scanf("%s", user_buf);
	if (check_access(user_buf, "password")) {
		printf("Access denied.\n");
	} else {
		printf("Magic number is %d!\n", magic_num);
	}
}
