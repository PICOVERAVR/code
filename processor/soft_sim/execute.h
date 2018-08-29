#include "proc.h"

#pragma once

int instr_sanity_check(instr *i, int instr);

int instr_add(proc *p);
void instr_sub(proc *p);

void instr_sex(proc *p);
