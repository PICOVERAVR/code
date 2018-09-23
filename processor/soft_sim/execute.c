#include "execute.h"

#define REGISTER_R0 0

#define REGISTER_DEST p->regfile[p->i.f_d]

#define REGISTER_SRC0 p->regfile[p->i.f_s0]
#define REGISTER_SRC1 p->regfile[p->i.f_s1]

static int imm_or_reg(proc *p) {
	if ((p->i.pm >> 2) & 1) {
		return p->i.f2_short_imm;
	} else {
		return REGISTER_SRC0;
	}
}

// F type instructions for arithmetic
// there is no checking for R0 write for any of this.
int instr_add(proc *p) {
	switch (p->i.pm >> 1) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC1 + imm_or_reg(p);
			break;;
		case 1: 
			REGISTER_DEST = (int16_t) REGISTER_SRC1 + (int16_t) imm_or_reg(p);
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) REGISTER_SRC1 + (uint8_t) imm_or_reg(p);
			break;
		case 3: 
			REGISTER_DEST = (int8_t) REGISTER_SRC1 + (int8_t) imm_or_reg(p);
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return 0;
}

int instr_sub(proc *p) {
	switch (p->i.pm >> 1) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC1 - imm_or_reg(p);
			break;
		case 1: 
			REGISTER_DEST = (int16_t) REGISTER_SRC1 - (int16_t) imm_or_reg(p);
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) REGISTER_SRC1 - (uint8_t) imm_or_reg(p);
			break;
		case 3: 
			REGISTER_DEST = (int8_t) REGISTER_SRC1 - (int8_t) imm_or_reg(p);
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return 0;
}

int instr_mul(proc *p) {
	uint32_t temp = p->regfile[p->i.g_s0] * p->regfile[p->i.g_s1];
	
	switch (p->i.pm >> 1) {
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
			return EXCP_ILL_INSTR;
	}
	return 0;
}

int instr_div(proc *p) {
	
	if (p->regfile[p->i.g_s1] == 0) {
		fprintf(stderr, "EXCP: Division by zero, PC 0x%x\n", p->PC);
		
		#ifdef HAVE_TRAP
		trap_service(p, EXCP_DIV_ZERO_VEC);
		#endif
		return EXCP_DIV_ZERO;
	}

	div_t temp = div((int) p->regfile[p->i.g_s0], (int) p->regfile[p->i.g_s1]);
	
	switch (p->i.pm >> 1) {
		case 0:
			p->regfile[p->i.g_h] = temp.quot;
			p->regfile[p->i.g_l] = temp.rem;
			break;
		case 1:
			p->regfile[p->i.g_h] = (int16_t) temp.quot;
			p->regfile[p->i.g_l] = (int16_t) temp.rem;
			break;
		case 2:
			p->regfile[p->i.g_h] = (uint8_t) temp.quot;
			p->regfile[p->i.g_l] = (uint8_t) temp.rem;
			break;
		case 3:
			p->regfile[p->i.g_h] = (int8_t) temp.quot;
			p->regfile[p->i.g_l] = (int8_t) temp.rem;
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return 0;
}

int instr_and(proc *p) {
	switch (p->i.pm >> 1) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC1 & imm_or_reg(p);
			break;;
		case 1: 
			REGISTER_DEST = (int16_t) REGISTER_SRC1 & (int16_t) imm_or_reg(p);
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) REGISTER_SRC1 & (uint8_t) imm_or_reg(p);
			break;
		case 3: 
			REGISTER_DEST = (int8_t) REGISTER_SRC1 & (int8_t) imm_or_reg(p);
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return 0;
}

int instr_or(proc *p) {
	switch (p->i.pm >> 1) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC1 | imm_or_reg(p);
			break;;
		case 1: 
			REGISTER_DEST = (int16_t) REGISTER_SRC1 | (int16_t) imm_or_reg(p);
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) REGISTER_SRC1 | (uint8_t) imm_or_reg(p);
			break;
		case 3: 
			REGISTER_DEST = (int8_t) REGISTER_SRC1 | (int8_t) imm_or_reg(p);
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return 0;
}

int instr_xor(proc *p) {
	switch (p->i.pm >> 1) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC1 ^ imm_or_reg(p);
			break;;
		case 1: 
			REGISTER_DEST = (int16_t) REGISTER_SRC1 ^ (int16_t) imm_or_reg(p);
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) REGISTER_SRC1 ^ (uint8_t) imm_or_reg(p);
			break;
		case 3: 
			REGISTER_DEST = (int8_t) REGISTER_SRC1 ^ (int8_t) imm_or_reg(p);
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return 0;
	
}

int instr_not(proc *p) {
	switch (p->i.pm) {
		case 0: 
			REGISTER_DEST = ~REGISTER_SRC1;
			break;
		case 1: 
			REGISTER_DEST = (int16_t) ~REGISTER_SRC1;
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) ~REGISTER_SRC1;
			break;
		case 3: 
			REGISTER_DEST = (int8_t) ~REGISTER_SRC1;
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return 0;

}

int instr_inv(proc *p) {
	switch (p->i.pm) {
		case 0: 
			REGISTER_DEST = !REGISTER_SRC1;
			break;
		case 1: 
			REGISTER_DEST = (int16_t) !REGISTER_SRC1;
			break;
		case 2: 
			REGISTER_DEST = (uint8_t) !REGISTER_SRC1;
			break;
		case 3: 
			REGISTER_DEST = (int8_t) !REGISTER_SRC1;
			break;
		default:
			return EXCP_ILL_INSTR;
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
		REGISTER_DEST = REGISTER_SRC1;
	} else {
		REGISTER_DEST = (uint8_t) REGISTER_SRC1;
	}
}

void instr_st(proc *p, uint16_t *ram) {
	fprintf(stderr, "ST is not fully implemented.\n");
	ram[REGISTER_DEST] = REGISTER_SRC1;
}

void instr_bs(proc *p) {
	p->PC = REGISTER_SRC1 + REGISTER_DEST;
}

void instr_bn(proc *p) {
	p->PC = p->i.b_imm;
}

void instr_br(proc *p) {
	p->PC = p->PC + REGISTER_DEST;
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
			if (REGISTER_SRC1 == REGISTER_SRC0) { 
				p->PC = REGISTER_DEST; 
			} break;

		case BRANCH_NE:
			if (REGISTER_SRC1 != REGISTER_SRC0) {
				p->PC = REGISTER_DEST;
			} break;
		case BRANCH_GT:
			if (REGISTER_SRC1 > REGISTER_SRC0) {
				p->PC = REGISTER_DEST;
			} break;
			break;
		case BRANCH_GE:
			if (REGISTER_SRC1 >= REGISTER_SRC0) {
				p->PC = REGISTER_DEST;
			} break;
			break;
		case BRANCH_LT:
			if (REGISTER_SRC1 < REGISTER_SRC0) {
				p->PC = REGISTER_DEST;
			} break;
			break;
		case BRANCH_LE:
			if (REGISTER_SRC1 <= REGISTER_SRC0) {
				p->PC = REGISTER_DEST;
			} break;
			break;
	}
}

void instr_cmpcc(proc *p) {
	// test stuff, not sure of output format
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
	p->BP = p->PC; // ST PC, BP
	p->BP -= 4; // SUB 4, BP, BP
	p->PC = p->i.b_imm; // BN imm16
}

void instr_ret(proc *p) {
	p->BP += 4; // ADD 4, BP, BP
	p->PC = p->SP; // LD BP, PC
}

void instr_ps(state *s) { // C type
	s->p.regfile[s->p.i.c_s] = s->p.proc_ext_state;
}


