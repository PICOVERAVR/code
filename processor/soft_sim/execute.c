#include "execute.h"

#define REGISTER_R0 0

#define REGISTER_DEST p->regfile[p->i.c_s]

#define REGISTER_SRC0 p->regfile[p->i.f_s0]
#define REGISTER_SRC1 p->regfile[p->i.f_s1]

static int imm_or_reg(proc *p) {
	if ((p->i.pm >> 2) & 1) {
		return p->i.f2_short_imm;
	} else {
		return p->regfile[p->i.c_s];
	}
}

// F type instructions for arithmetic
// there is no checking for R0 write for any of this.
int instr_add(proc *p) {
	
	switch (p->i.pm) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC0 + imm_or_reg(p);
			break;;
		case 1: 
			REGISTER_DEST = (int16_t) REGISTER_SRC0 + (int16_t) imm_or_reg(p);
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) REGISTER_SRC0 + (uint8_t) imm_or_reg(p);
			break;
		case 3: 
			REGISTER_DEST = (int8_t) REGISTER_SRC0 + (int8_t) imm_or_reg(p);
			break;
		default:
			return EXCP_ILL_OPCODE;
	}
	return 0;
}

int instr_sub(proc *p) {
	switch (p->i.pm) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC0 - imm_or_reg(p);
			break;
		case 1: 
			REGISTER_DEST = (int16_t) REGISTER_SRC0 - (int16_t) imm_or_reg(p);
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) REGISTER_SRC0 - (uint8_t) imm_or_reg(p);
			break;
		case 3: 
			REGISTER_DEST = (int8_t) REGISTER_SRC0 - (int8_t) imm_or_reg(p);
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

int instr_and(proc *p) {
	switch (p->i.pm) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC0 & imm_or_reg(p);
			break;;
		case 1: 
			REGISTER_DEST = (int16_t) REGISTER_SRC0 & (int16_t) imm_or_reg(p);
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) REGISTER_SRC0 & (uint8_t) imm_or_reg(p);
			break;
		case 3: 
			REGISTER_DEST = (int8_t) REGISTER_SRC0 & (int8_t) imm_or_reg(p);
			break;
		default:
			return EXCP_ILL_OPCODE;
	}
	return 0;
}

int instr_or(proc *p) {
	switch (p->i.pm) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC0 | imm_or_reg(p);
			break;;
		case 1: 
			REGISTER_DEST = (int16_t) REGISTER_SRC0 | (int16_t) imm_or_reg(p);
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) REGISTER_SRC0 | (uint8_t) imm_or_reg(p);
			break;
		case 3: 
			REGISTER_DEST = (int8_t) REGISTER_SRC0 | (int8_t) imm_or_reg(p);
			break;
		default:
			return EXCP_ILL_OPCODE;
	}
	return 0;
}

int instr_xor(proc *p) {
	switch (p->i.pm) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC0 ^ imm_or_reg(p);
			break;;
		case 1: 
			REGISTER_DEST = (int16_t) REGISTER_SRC0 ^ (int16_t) imm_or_reg(p);
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) REGISTER_SRC0 ^ (uint8_t) imm_or_reg(p);
			break;
		case 3: 
			REGISTER_DEST = (int8_t) REGISTER_SRC0 ^ (int8_t) imm_or_reg(p);
			break;
		default:
			return EXCP_ILL_OPCODE;
	}
	return 0;
	
}

int instr_not(proc *p) {
	switch (p->i.pm) {
		case 0: 
			REGISTER_DEST = ~REGISTER_SRC0;
			break;
		case 1: 
			REGISTER_DEST = (int16_t) ~REGISTER_SRC0;
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) ~REGISTER_SRC0;
			break;
		case 3: 
			REGISTER_DEST = (int8_t) ~REGISTER_SRC0;
			break;
		default:
			return EXCP_ILL_OPCODE;
	}
	return 0;

}

int instr_inv(proc *p) {
	switch (p->i.pm) {
		case 0: 
			REGISTER_DEST = !REGISTER_SRC0;
			break;
		case 1: 
			REGISTER_DEST = (int16_t) !REGISTER_SRC0;
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) !REGISTER_SRC0;
			break;
		case 3: 
			REGISTER_DEST = (int8_t) !REGISTER_SRC0;
			break;
		default:
			return EXCP_ILL_OPCODE;
	}
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
		REGISTER_DEST = (uint8_t) REGISTER_SRC0;
	} else {	
		REGISTER_DEST = REGISTER_SRC0;
	}
}

void instr_st(proc *p, uint16_t *ram) {
	ram[REGISTER_DEST] = REGISTER_SRC0;
}

void instr_bs(proc *p) {
	p->PC = REGISTER_SRC0 + REGISTER_DEST;
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
			if (REGISTER_SRC0 == p->regfile[p->i.c_s]) { 
				p->PC = REGISTER_DEST; 
			} break;

		case BRANCH_NE:
			if (REGISTER_SRC0 != p->regfile[p->i.c_s]) {
				p->PC = REGISTER_DEST;
			} break;
		case BRANCH_GT:
			if (REGISTER_SRC0 > p->regfile[p->i.c_s]) {
				p->PC = REGISTER_DEST;
			} break;
			break;
		case BRANCH_GE:
			if (REGISTER_SRC0 >= p->regfile[p->i.c_s]) {
				p->PC = REGISTER_DEST;
			} break;
			break;
		case BRANCH_LT:
			if (REGISTER_SRC0 < p->regfile[p->i.c_s]) {
				p->PC = REGISTER_DEST;
			} break;
			break;
		case BRANCH_LE:
			if (REGISTER_SRC0 <= p->regfile[p->i.c_s]) {
				p->PC = REGISTER_DEST;
			} break;
			break;
		case BRANCH_Z:
			break;
		case BRANCH_NZ:
			break;
	}
}

void instr_io(proc *p) { // E type
	if (p->i.e_pm) { // input op
		int temp;
		printf("16bu io input at address %d: ", p->i.e_imm);
		scanf("%d", &temp);
		p->regfile[p->i.e_s] = (uint16_t) temp;
	} else { // output op
		printf("16bu io output %d at address %d\n", p->regfile[p->i.e_s], p->i.e_imm);
	}
}


void instr_call(proc *p) {
	p->SP = p->PC; // ST PC, SP
	p->SP -= 4; // SUB 4, SP, SP
	p->PC = p->i.b_imm; // BN imm16
}

void instr_ret(proc *p) {
	p->SP += 4; // ADD 4, SP, SP
	p->PC = p->SP; // LD SP, PC
}

void instr_ps(state *s) { // C type
	s->p.regfile[s->p.i.c_s] = s->proc_ext_state;
}
