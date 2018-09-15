#include "proc.h"

int disp(state *s, uint16_t *ram);

// instruction can't write to R0, skip check
enum no_check_group {
	// add stuff here
	FILL_THIS
};
