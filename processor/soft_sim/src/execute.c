#include "execute.h"

#define REGISTER_DEST p->regfile[p->i.f_d]

#define REGISTER_SRC0 p->regfile[p->i.f_s0]
#define REGISTER_SRC1 p->regfile[p->i.f_s1]

#define REGISTER_SRC0_LOW p->byte_regfile[(2 * p->i.f_s0)]
#define REGISTER_SRC1_LOW p->byte_regfile[(2 * p->i.f_s1)]
#define REGISTER_DEST_LOW p->byte_regfile[(2 * p->i.f_d)]

static uint16_t imm_or_reg(proc *p) {
	if ((p->i.pm >> 2) & 1) {
		return p->i.f2_short_imm;
	} else {
		return REGISTER_SRC0;
	}
}

static uint8_t imm_or_reg_byte(proc *p) {	
	p->regfile[0] = p->regfile[0]; // to shut up compiler warnings
	return imm_or_reg(p);
}

int instr_stop(proc *p) {
	dbprintf("reached STOP instr, PC 0x%x", p->PC);
	p->regfile[0] = p->regfile[0];
	return RET_STOP;
}

int instr_nop(proc *p) {
	p->regfile[0] = p->regfile[0];
	return RET_OK;
}

int instr_rst(proc *p) {
	memset(p->regfile, 0, sizeof(p->regfile));
	return RET_OK;
}

// F type instructions for arithmetic
int instr_add(proc *p) {
	switch (p->i.pm & 0b11) {
		case 0: 
			REGISTER_DEST_LOW = REGISTER_SRC1_LOW + imm_or_reg_byte(p);
			break;
		case 1: 
			REGISTER_DEST = (int16_t) REGISTER_SRC1 + (int16_t) imm_or_reg(p);
			break;
		case 2: 
			REGISTER_DEST = REGISTER_SRC1 + imm_or_reg(p);
			break;
		case 3: 
			REGISTER_DEST_LOW = (int8_t) REGISTER_SRC1_LOW + (int8_t) imm_or_reg_byte(p);
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return RET_OK;
}

int instr_sub(proc *p) {
	switch (p->i.pm & 0b11) {
		case 0: 
			REGISTER_DEST_LOW = REGISTER_SRC1_LOW - imm_or_reg_byte(p);
			break;
		case 1: 
			REGISTER_DEST = (int16_t) REGISTER_SRC1 - (int16_t) imm_or_reg(p);
			break;
		case 2: 
			REGISTER_DEST = REGISTER_SRC1 - imm_or_reg(p);
			break;
		case 3: 
			REGISTER_DEST = (int8_t) REGISTER_SRC1 - (int8_t) imm_or_reg(p);
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return RET_OK;
}

int instr_mul(proc *p) {
	uint32_t temp = p->regfile[p->i.g_s0] * p->regfile[p->i.g_s1];
	
	switch (p->i.pm & 0b11) {
		case 0:
			//p->regfile[p->i.g_h] = (temp >> 16) & 0xffff;
			//p->regfile[p->i.g_l] = temp & 0xffff;
			p->regfile[p->i.g_l] = (uint16_t) (temp & 0xffff);
			break;
		case 1:
			p->regfile[p->i.g_h] = (int16_t) ((temp >> 16) & 0xffff);
			p->regfile[p->i.g_l] = (int16_t) (temp & 0xffff);
			break;
		case 2:
			//p->regfile[p->i.g_l] = (uint16_t) (temp & 0xffff);
			p->regfile[p->i.g_h] = (temp >> 16) & 0xffff;
			p->regfile[p->i.g_l] = temp & 0xffff;
			break;
		case 3:
			p->regfile[p->i.g_l] = (int16_t) (temp & 0xffff);
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return RET_OK;
}

int instr_div(proc *p) {
	
	if (p->regfile[p->i.g_s1] == 0) {
		fprintf(stderr, "EXCP: Division by zero, PC 0x%x\n", p->PC);
		
		#ifdef HAVE_TRAP
		trap_service(p, EXCP_DIV_ZERO_VEC);
		#endif
		return RET_DIV_ZERO;
	}

	div_t temp = div((int) p->regfile[p->i.g_s0], (int) p->regfile[p->i.g_s1]);
	
	switch (p->i.pm & 0b11) {
		case 0:
			//p->regfile[p->i.g_h] = temp.quot;
			//p->regfile[p->i.g_l] = temp.rem;
			
			p->regfile[p->i.g_h] = (uint8_t) temp.quot;
			p->regfile[p->i.g_l] = (uint8_t) temp.rem;
			break;
		case 1:
			p->regfile[p->i.g_h] = (int16_t) temp.quot;
			p->regfile[p->i.g_l] = (int16_t) temp.rem;
			break;
		case 2:
			
			p->regfile[p->i.g_h] = temp.quot;
			p->regfile[p->i.g_l] = temp.rem;
			
			//p->regfile[p->i.g_h] = (uint8_t) temp.quot;
			//p->regfile[p->i.g_l] = (uint8_t) temp.rem;
			break;
		case 3:
			p->regfile[p->i.g_h] = (int8_t) temp.quot;
			p->regfile[p->i.g_l] = (int8_t) temp.rem;
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return RET_OK;
}

int instr_and(proc *p) {
	switch ((p->i.pm >> 1) & 1) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC1 & imm_or_reg(p);
			break;
		case 1: 
			REGISTER_DEST_LOW = (int8_t) REGISTER_SRC1_LOW & (int8_t) imm_or_reg_byte(p);
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return RET_OK;
}

int instr_or(proc *p) {
	switch ((p->i.pm >> 1) & 1) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC1 | imm_or_reg(p);
			break;
		case 1: 
			REGISTER_DEST_LOW = (int8_t) REGISTER_SRC1_LOW | (int8_t) imm_or_reg_byte(p);
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return RET_OK;
}

int instr_xor(proc *p) {
	switch ((p->i.pm >> 1) & 1) {
		case 0: 
			REGISTER_DEST = REGISTER_SRC1 ^ imm_or_reg(p);
			break;
		case 1: 
			REGISTER_DEST_LOW = (int8_t) REGISTER_SRC1_LOW ^ (int8_t) imm_or_reg_byte(p);
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return RET_OK;
	
}

int instr_not(proc *p) {
	switch ((p->i.pm >> 1) & 1) {
		case 0: 
			REGISTER_DEST = ~REGISTER_SRC1;
			break;
		case 1: 
			REGISTER_DEST = (uint8_t) ~REGISTER_SRC1_LOW;
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return RET_OK;

}

int instr_inv(proc *p) {
	switch ((p->i.pm >> 1) & 1) {
		case 0: 
			REGISTER_DEST = !REGISTER_SRC1;
			break;
		case 1: 
			REGISTER_DEST = (int8_t) REGISTER_SRC1_LOW * (int8_t) -1;
			break;
		default:
			return EXCP_ILL_INSTR;
	}
	return RET_OK;
}

int instr_ld(proc *p, uint16_t *ram) {
	uint16_t temp;

	if ((p->i.pm & 1) == 1) {
		temp = ram[p->regfile[p->i.e_imm]];
	} else {
		temp = p->i.e_imm;
	}

	if (((p->i.pm >> 1) & 1) == 1) {
		p->regfile[p->i.e_s] = temp;
	} else {
		p->regfile[p->i.e_s] = (uint8_t) temp;
	}
	return RET_OK;
}

int instr_mov(proc *p) {
	
	if (((p->i.pm >> 1) & 1) == 1) {
		REGISTER_DEST = REGISTER_SRC1;
	} else {
		REGISTER_DEST = (uint8_t) REGISTER_SRC1;
	}
	return RET_OK;
}

int instr_st(proc *p, uint16_t *ram) {
	fprintf(stderr, "ST is not fully implemented.\n");
	ram[REGISTER_DEST] = REGISTER_SRC1;
	return RET_OK;
}

int instr_ldu(proc *p) {
	p->PCH = REGISTER_SRC1;
	return RET_OK;
}

int instr_bs(proc *p) {
	p->PCL = REGISTER_SRC1 + REGISTER_DEST;
	return RET_OK;
}

int instr_bn(proc *p) {
	p->PCL = p->i.b_imm;
	return RET_OK;
}

int instr_br(proc *p) {
	p->PCL = p->PCL + REGISTER_DEST;
	return RET_OK;
}

int instr_sex(proc *p) {
	// don't really need to know how to do this at any level, verilog 
	// handles this?
	// s assumed to be 8bs
	p->regfile[p->i.c_s] = (int16_t) p->regfile[p->i.c_s];
	return RET_OK;
}

int instr_bcc(proc *p) { // F type
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
	return RET_OK;
}

int instr_io(proc *p) { // E type
	if (p->i.e_pm) { // input op
		int temp;
		printf("16bu io input at address %d: ", p->i.e_imm);
		int err = scanf("%d", &temp);
		if (err) {
			perror("scanf");
		}
		p->regfile[p->i.e_s] = (uint16_t) temp;
	} else { // output op
		printf("16bu io output %d at address %d\n", p->regfile[p->i.e_s], p->i.e_imm);
	}
	return RET_OK;
}


int instr_call(proc *p) {
	p->BP = p->PC; // ST PC, BP
	p->BP -= 4; // SUB 4, BP, BP
	p->PC = p->i.b_imm; // BN imm16
	return RET_OK;
}

int instr_ret(proc *p) {
	p->BP += 4; // ADD 4, BP, BP
	p->PC = p->SP; // LD BP, PC
	return RET_OK;
}

int instr_ps(proc *p) { // C type
	p->regfile[p->i.c_s] = p->proc_ext_state;
	return RET_OK;
}


