#include "execute.h"

#define REGISTER_R0 0

// F type instruction
int instr_add(proc *p) {
	switch (p->i.pm) {
		case 0: 
			p->regfile[p->i.f_d] = p->regfile[p->i.f_s0] + p->regfile[p->i.f_s1];
			return 0;
		case 1: 
			p->regfile[p->i.f_d] = (int16_t) p->regfile[p->i.f_s0] + (int16_t) p->regfile[p->i.f_s1];
			return 0;
		case 2: 
			p->regfile[p->i.f_d] = (uint8_t) p->regfile[p->i.f_s0] + (uint8_t) p->regfile[p->i.f_s1];
			return 0;
		case 3: 
			p->regfile[p->i.f_d] = (int8_t) p->regfile[p->i.f_s0] + (int8_t) p->regfile[p->i.f_s1];
			return 0;
		default:
			return EXCP_ILL_OPCODE;
	}
}

int instr_sub(proc *p) {
	switch (p->i.pm) {
		case 0: 
			p->regfile[p->i.f_d] = p->regfile[p->i.f_s0] - p->regfile[p->i.f_s1];
			return 0;
		case 1: 
			p->regfile[p->i.f_d] = (int16_t) p->regfile[p->i.f_s0] - (int16_t) p->regfile[p->i.f_s1];
			return 0;
		case 2: 
			p->regfile[p->i.f_d] = (uint8_t) p->regfile[p->i.f_s0] - (uint8_t) p->regfile[p->i.f_s1];
			return 0;
		case 3: 
			p->regfile[p->i.f_d] = (int8_t) p->regfile[p->i.f_s0] - (int8_t) p->regfile[p->i.f_s1];
			return 0;
		default:
			return EXCP_ILL_OPCODE;
	}
}

int instr_ld(proc *p, uint16_t *ram) {

	if (p->i.e_s == REGISTER_R0) { 
		return 0; //writing to R0 has no effect
	}

	if (p->i.pm == 1) {
		p->regfile[p->i.e_s] = ram[p->regfile[p->i.e_imm]];
		return 0;
	}
	p->regfile[p->i.e_s] = p->i.e_imm;
	return 0;
}

int instr_st(proc *p, uint16_t *ram) {
	ram[p->regfile[p->i.d_d]] = p->regfile[p->i.d_s];
	return 0;	
}

int instr_bs(proc *p) {
	p->PC = p->regfile[p->i.d_s] + p->regfile[p->i.d_d];
	return 0;
}

int instr_bn(proc *p) {
	p->PC = p->i.b_imm;
	return 0;
}

void instr_sex(proc *p) {
	//extend MSB to 16b, given an 8b value
	
}
