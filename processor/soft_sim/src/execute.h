#include "proc.h"

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

void instr_ld(proc *p, uint16_t *ram);
void instr_st(proc *p, uint16_t *ram);

void instr_mov(proc *p);

void instr_ldu(proc *p);
void instr_bn(proc *p);
void instr_bs(proc *p);
void instr_bcc(proc *p);
void instr_br(proc *p);

void instr_sex(proc *p);

void instr_io(proc *p);

void instr_call(proc *p);
void instr_ret(proc *p);

void instr_ps(proc *p);

enum COND_BRANCH_TYPES {
	BRANCH_EQ, // 0
	BRANCH_NE, // 1
	BRANCH_GT, // 2
	BRANCH_GE, // 3
	BRANCH_LT, // 4
	BRANCH_LE, // 5
};

