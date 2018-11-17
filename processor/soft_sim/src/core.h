#include "proc.h"

#pragma once

void trap_service(proc *p, int trap_vector);
void interrupt_handle(proc *p);
void signal_handler(int signum);
