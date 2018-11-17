#include "proc.h"

enum RET_COND {
	RET_OK,
	RET_ERR,
	RET_DIV_ZERO,
	RET_STOP,
};

#pragma once

// we don't need to pass the entire processor state to the function here,
// it just makes it more likely for instruction to touch random parts of 
// the processor

int instr_add(proc *p);
int instr_sub(proc *p);

int instr_and(proc *p);
int instr_or(proc *p);
int instr_xor(proc *p);

int instr_not(proc *p);
int instr_inv(proc *p);

int instr_mul(proc *p);
int instr_div(proc *p);

int instr_ld(proc *p, uint16_t *ram);
int instr_st(proc *p, uint16_t *ram);

int instr_mov(proc *p);

int instr_ldu(proc *p);
int instr_bn(proc *p);
int instr_bs(proc *p);
int instr_bcc(proc *p);
int instr_br(proc *p);

int instr_sex(proc *p);

int instr_io(proc *p);

int instr_call(proc *p);
int instr_ret(proc *p);

int instr_ps(proc *p);

int instr_stop(proc *p);
int instr_nop(proc *p);
int instr_rst(proc *p);

enum COND_BRANCH_TYPES {
	BRANCH_EQ, // 0
	BRANCH_NE, // 1
	BRANCH_GT, // 2
	BRANCH_GE, // 3
	BRANCH_LT, // 4
	BRANCH_LE, // 5
};

