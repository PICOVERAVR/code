#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#include <sys/types.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <sys/user.h>

#include <signal.h>
#include <stdbool.h>

#define NUM_BREAKPOINTS 32

char get_input();
int get_mem_break();
