#include "proc.h"

#pragma once

uint32_t *proc_setup(int argc, char **argv, proc *p);
void proc_teardown(uint32_t *hex_mem, proc *p);

