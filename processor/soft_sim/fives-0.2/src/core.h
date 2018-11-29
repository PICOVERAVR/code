#include "proc.h"

#pragma once

void trap_service(proc *p, int trap_vector);
void interrupt_handle(proc *p);
void signal_handler(int signum);

void proc_feat_set(proc *p, int bitpos, int val);
uint16_t proc_feat_get(proc *p, int bitpos);
