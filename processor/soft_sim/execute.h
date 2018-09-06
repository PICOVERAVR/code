#include "proc.h"

#pragma once

// we don't need to pass the entire processor state to the function here,
// it just makes it more likely for instruction to touch random parts of 
// the processor

int instr_add(proc *p);
int instr_sub(proc *p);

int instr_mul(proc *p);


void instr_ld(proc *p, uint16_t *ram);
void instr_st(proc *p, uint16_t *ram);

void instr_bn(proc *p);
void instr_bs(proc *p);

void instr_sex(proc *p);
