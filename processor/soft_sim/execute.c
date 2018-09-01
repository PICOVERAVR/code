#include "execute.h"

#define regfile p->regfile
#define REGISTER_R0 0

// F type instruction
int instr_add(proc *p) {
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

int instr_sub(proc *p) {
	return 0;
}

int instr_ld(proc *p, uint16_t *ram) {

	if (p->i.e_s == REGISTER_R0) { 
		return 0; //writing to R0 has no effect
	}

	if (p->i.pm == 1) {
		regfile[p->i.e_s] = ram[regfile[p->i.e_imm]];
		return 0;
	}
	regfile[p->i.e_s] = p->i.e_imm;
	return 0;
}

void instr_sex(proc *p) {
	//extend MSB to 16b, given an 8b value
	
}
