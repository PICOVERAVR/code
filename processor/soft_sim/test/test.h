#include "proc.h"
#include "execute.h"
#include "dispatch.h"

#pragma once

#define SETUP_M() \
proc *p = malloc(sizeof(proc)); \
proc_set_vec(p);

enum registers {
    R0,
    R1,
    R2,
    R3,
    R4,
    R5,
    R6,
};

void proc_set_vec(proc *p) {
    for (int i = 0; i < 32; i++) {
        p->regfile[i] = i;
    }

    p->i.f_s0 = R1;
    p->i.f_s1 = R2;
    p->i.f_d = R3;
}


