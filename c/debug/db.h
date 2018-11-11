#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdarg.h>

#include <sys/types.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <sys/user.h>

#include <signal.h>
#include <stdbool.h>

#define NUM_BREAKPOINTS 32
#define TRAP_CODE 0xCC

#pragma once

enum {
	DUMP_REGS,
    SINGLE_STEP,
    B_CONTINUE,
    B_BREAK,
    PROG_INFO,
    KILL_QUIT,
 	HELP,
    END_CMD // sentinel value
 };

int get_input();
int get_mem_break();

extern const char *help_text;
