#include "proc.h"

#pragma once

uint32_t *proc_setup(int argc, char **argv, state *s);
void proc_teardown(uint32_t *hex_mem, state *s);

