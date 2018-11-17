#include "dispatch.h"
#include "execute.h"

instr_type instr_list[] = {
	{.opcode=STOP, .fp=instr_stop, .check_level=CHECK_NONE},
	{.opcode=NOP, .fp=instr_nop, .check_level=CHECK_NONE},
	
	{.opcode=ADD, .fp=instr_add, .check_level=CHECK_ARITH},
	{.opcode=SUB, .fp=instr_sub, .check_level=CHECK_ARITH},
	{.opcode=MUL, .fp=instr_mul, .check_level=CHECK_ARITH},
	{.opcode=DIV, .fp=instr_div, .check_level=CHECK_ARITH},
	
	{.opcode=SEX, .fp=instr_sex, .check_level=CHECK_ARITH},
	
	{.opcode=BN, .fp=instr_bn, .check_level=CHECK_NONE},
	{.opcode=BS, .fp=instr_bs, .check_level=CHECK_NONE},
	{.opcode=Bcc, .fp=instr_bcc, .check_level=CHECK_NONE},
	
	{.opcode=LD, .fp_ram=instr_ld, .check_level=CHECK_ARITH},
	{.opcode=ST, .fp_ram=instr_st, .check_level=CHECK_NONE},
    
    {.opcode=IO, .fp=instr_io, .check_level=CHECK_ARITH}, // only one variant of this should be checked
	
	{.opcode=AND, .fp=instr_and, .check_level=CHECK_ARITH},
	{.opcode=OR, .fp=instr_or, .check_level=CHECK_ARITH},
	{.opcode=XOR, .fp=instr_xor, .check_level=CHECK_ARITH},
	{.opcode=NOT, .fp=instr_not, .check_level=CHECK_ARITH},
	{.opcode=INV, .fp=instr_inv, .check_level=CHECK_ARITH},

    {.opcode=CALL, .fp=instr_call, .check_level=CHECK_ARITH},
    {.opcode=RET, .fp=instr_ret, .check_level=CHECK_ARITH},
    {.opcode=PS, .fp=instr_ps, .check_level=CHECK_ARITH},
    
    {.opcode=MOV, .fp=instr_mov, .check_level=CHECK_ARITH},
    
	{.opcode=BR, .fp=instr_br, .check_level=CHECK_NONE},
    
	{.opcode=RST, .fp=instr_rst, .check_level=CHECK_NONE},
	
	{.opcode=LDU, .fp=instr_ldu, .check_level=CHECK_ARITH},
	{.opcode=STU, .fp=instr_stu, .check_level=CHECK_NONE},
};

static int check_arithmetic(proc *p) {
	if (p->i.f_d == REGISTER_R0) {
		dbprintf("Write to R0 detected.");
		return -1; // not an error according to the isa, but return an error code to
			   // don't execute anything
	}
	return 0;
}

int disp(proc *p, uint16_t *ram) {
	
	for (unsigned int i = 0; i < sizeof(instr_list) / sizeof(instr_list[0]); i++) {
		if (instr_list[i].opcode == p->i.opcode) {
			
			if (instr_list[i].check_level == CHECK_ARITH) {
				if (check_arithmetic(p)) {
					dbprintf("Arithmetic check failed, aborting instruction execution.");
					return 0;
				}
			}

			int err;
			if (p->i.opcode == LD || p->i.opcode == ST) {
				err = instr_list[i].fp_ram(p, ram);
			} else {
				err = instr_list[i].fp(p);
			}
			return err;
		}
	}
	
	printf("ERR: unknown opcode!\n");
	return EXCP_ILL_INSTR;

	/*
	switch (p->i.opcode) {
		case ADD ... DIV:
		case AND ... INV:
			if (check_arithmetic(p)) {
				dbprintf("Arithmetic encoding problem, aborting instruction execution.");
				return 0;
			}
			break;
	}
	
	switch (p->i.opcode) {
		case NOP: break;
		case RST: 
			memset(p->regfile, 0, sizeof(p->regfile));
			break;
		case ADD:
			instr_add(p); 
			break;
		case SUB:
			instr_sub(p);
			break;
		case MUL:
			instr_mul(p);
			break;
		case DIV:
			instr_div(p);
			break;
		case AND:
			instr_and(p);
			break;
		case OR:
			instr_or(p);
			break;
		case XOR:
			instr_xor(p);
			break;
		case NOT:
			instr_not(p);
			break;
		case INV:
			instr_inv(p);
			break;
		case SEX:
			instr_sex(p);
			break;
		case LD:
			instr_ld(p, ram);
			break;
		case ST:
			instr_st(p, ram);
			break;
		case BN:
			instr_bn(p);
			break;
		case BS:
			instr_bs(p);
			break;
		case BR:
			instr_br(p);
			break;
		case MOV:
			instr_mov(p);
			break;
		case Bcc:
			instr_bcc(p);
			break;
		case IO:
			instr_io(p);
			break;
		case CALL:
			instr_call(p);
			break;
		case RET:
			instr_ret(p);
			break;
		case PS:
			instr_ps(p);
			break;
		case STOP:
			dbprintf("reached STOP instr, PC 0x%x", p->PC);
			return SIM_STOP;
		case LDU:
			instr_ldu(p);
			break;
		default:
			printf("ERR: unknown opcode!\n");
			return EXCP_ILL_INSTR;
	}
	return 0;
	*/
}
