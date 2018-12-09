#include "proc.h"
#include "config.h"

#pragma once

uint32_t *proc_setup(int argc, char **argv);
void proc_teardown(uint32_t *hex_mem, proc *p);

