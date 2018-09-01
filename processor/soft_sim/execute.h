#include "proc.h"

#pragma once

int instr_add(proc *p);
int instr_sub(proc *p);

int instr_ld(proc *p, uint16_t *ram);

void instr_sex(proc *p);
