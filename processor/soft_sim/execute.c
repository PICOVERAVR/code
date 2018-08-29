#include "execute.h"

int instr_sanity_check(instr *i) {
	if (false) {
		fprintf(stderr, "EXP: wrong instruction passed execute!\n");
		return -1;
	}
	return 0;
}

// F type instruction
void instr_add(proc *p) {
	//uint16_t temp;
	
	if (instr_sanity_check(&(p->i))) {
		return; // do not change state on error
	}
	
	//do actual add here, then modify according to flags
	
	if ((p->i.pm & 1)) { //1 for signed add
		printf("signed add\n");
	} else {
		printf("unsigned add\n");
	}
	if ((p->i.pm & 2)) {
		printf("8b add\n");
	} else {
		printf("16b add\n");
	}
	
	//modify instruction state here
}

void instr_sub(proc *p) {
	return;
}

void instr_sex(proc *p) {
	//extend MSB to 16b, given an 8b value
	
}
