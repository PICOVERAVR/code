#include "execute.h"

#define regfile p->regfile

int instr_sanity_check(instr *i, int def) {
	if (i->opcode != def) {
		fprintf(stderr, "EXP: wrong instruction passed execute!\n");
		return EXCP_ILL_OPCODE;
	}
	return 0;
}

// F type instruction
int instr_add(proc *p) {
	
	if (instr_sanity_check(&(p->i), ADD)) {
		return EXCP_ILL_OPCODE;
	}
	switch (p->i.pm) {
		case 0: 
			regfile[p->i.f_d] = regfile[p->i.f_s0] + regfile[p->i.f_s1];
			return 0;
		case 1: 
			regfile[p->i.f_d] = (int16_t) regfile[p->i.f_s0] + (int16_t) regfile[p->i.f_s1];
			return 0;
		case 2: 
			regfile[p->i.f_d] = (uint8_t) regfile[p->i.f_s0] + (uint8_t) regfile[p->i.f_s1];
			return 0;
		case 3: 
			regfile[p->i.f_d] = (int8_t) regfile[p->i.f_s0] + (int8_t) regfile[p->i.f_s1];
			return 0;
		default:
			return EXCP_ILL_OPCODE;
	}
}

void instr_sub(proc *p) {
	return;
}

void instr_sex(proc *p) {
	//extend MSB to 16b, given an 8b value
	
}
