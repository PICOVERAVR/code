#include "proc.h"

#pragma once

enum check_level_e {
	CHECK_NONE,
	CHECK_ARITH,
	CHECK_ALL
};

typedef struct {
	int opcode;
	int (*fp)(proc *p);
	int (*fp_ram)(proc *p, uint16_t *ram);
	int check_level;
} instr_type;

int disp(proc *p, uint16_t *ram);

