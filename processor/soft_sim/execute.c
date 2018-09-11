#include "execute.h"

#define REGISTER_R0 0

// F type instruction
int instr_add(proc *p) {
	switch (p->i.pm) {
		case 0: 
			p->regfile[p->i.f_d] = p->regfile[p->i.f_s0] + p->regfile[p->i.f_s1];
			break;;
		case 1: 
			p->regfile[p->i.f_d] = (int16_t) p->regfile[p->i.f_s0] + (int16_t) p->regfile[p->i.f_s1];
			break;
		case 2: 
			p->regfile[p->i.f_d] = (uint8_t) p->regfile[p->i.f_s0] + (uint8_t) p->regfile[p->i.f_s1];
			break;
		case 3: 
			p->regfile[p->i.f_d] = (int8_t) p->regfile[p->i.f_s0] + (int8_t) p->regfile[p->i.f_s1];
			break;
		default:
			return EXCP_ILL_OPCODE;
	}
	return 0;
}

int instr_sub(proc *p) {
	switch (p->i.pm) {
		case 0: 
			p->regfile[p->i.f_d] = p->regfile[p->i.f_s0] - p->regfile[p->i.f_s1];
			break;
		case 1: 
			p->regfile[p->i.f_d] = (int16_t) p->regfile[p->i.f_s0] - (int16_t) p->regfile[p->i.f_s1];
			break;
		case 2: 
			p->regfile[p->i.f_d] = (uint8_t) p->regfile[p->i.f_s0] - (uint8_t) p->regfile[p->i.f_s1];
			break;
		case 3: 
			p->regfile[p->i.f_d] = (int8_t) p->regfile[p->i.f_s0] - (int8_t) p->regfile[p->i.f_s1];
			break;
		default:
			return EXCP_ILL_OPCODE;
	}
	return 0;
}

int instr_mul(proc *p) {
	uint32_t temp;
	temp = p->regfile[p->i.g_s0] * p->regfile[p->i.g_s1];
	
	switch (p->i.pm) {
		case 0:
			p->regfile[p->i.g_h] = (temp >> 16) & 0xffff;
			p->regfile[p->i.g_l] = temp & 0xffff;
			break;
		case 1:
			p->regfile[p->i.g_h] = (int16_t) ((temp >> 16) & 0xffff);
			p->regfile[p->i.g_l] = (int16_t) (temp & 0xffff);
			break;
		case 2:
			p->regfile[p->i.g_l] = (uint16_t) (temp & 0xffff);
			break;
		case 3:
			p->regfile[p->i.g_l] = (int16_t) (temp & 0xffff);
			break;
		default:
			return EXCP_ILL_OPCODE;
	}
	return 0;
}

int instr_div(proc *p) {
	
	return 0;
}

void instr_ld(proc *p, uint16_t *ram) {
	if (p->i.e_s == REGISTER_R0) { 
		return; //writing to R0 has no effect
	}

	if (p->i.pm == 1) {
		p->regfile[p->i.e_s] = ram[p->regfile[p->i.e_imm]];
	} else {
		p->regfile[p->i.e_s] = p->i.e_imm;
	}
}

void instr_mov(proc *p) {
	if (p->i.d_d == REGISTER_R0) {
		return;
	}
	
	if (p->i.pm == 2) {
		p->regfile[p->i.d_d] = (uint8_t) p->regfile[p->i.d_s];
	} else {	
		p->regfile[p->i.d_d] = p->regfile[p->i.d_s];
	}
}

void instr_st(proc *p, uint16_t *ram) {
	ram[p->regfile[p->i.d_d]] = p->regfile[p->i.d_s];
}

void instr_bs(proc *p) {
	p->PC = p->regfile[p->i.d_s] + p->regfile[p->i.d_d];
}

void instr_bn(proc *p) {
	p->PC = p->i.b_imm;
}

void instr_sex(proc *p) {
	// don't really need to know how to do this at any level, verilog 
	// handles this?
	// s assumed to be 8bs
	p->regfile[p->i.c_s] = (int16_t) p->regfile[p->i.c_s];
}

void instr_bcc(proc *p) { // F type
	switch (p->i.pm) {
		case BRANCH_EQ: 
			if (p->regfile[p->i.f_s0] == p->regfile[p->i.f_s1]) { 
				p->PC = p->regfile[p->i.f_d]; 
			} break;

		case BRANCH_NE:
			if (p->regfile[p->i.f_s0] != p->regfile[p->i.f_s1]) {
				p->PC = p->regfile[p->i.f_d];
			} break;
		case BRANCH_GT:
			break;
		case BRANCH_GE:
			break;
		case BRANCH_LT:
			break;
		case BRANCH_LE:
			break;
		case BRANCH_Z:
			break;
		case BRANCH_NZ:
			break;
	}
}
