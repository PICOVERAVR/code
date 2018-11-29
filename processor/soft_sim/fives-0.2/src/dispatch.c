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
	
	{.opcode=LDI, .fp=instr_ldi, .check_level=CHECK_ARITH},
    {.opcode=LDR, .fp_ram=instr_ldr, .check_level=CHECK_ARITH},
	{.opcode=STR, .fp_ram=instr_str, .check_level=CHECK_NONE},
	
	// only one variant of this has to be be checked
    {.opcode=IO, .fp=instr_io, .check_level=CHECK_ARITH},
	
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
			if (p->i.opcode == LDR || p->i.opcode == STR) {
				err = instr_list[i].fp_ram(p, ram);
			} else {
				err = instr_list[i].fp(p);
			}
			return err;
		}
	}
	
	printf("ERR: unknown opcode!\n");
	return EXCP_ILL_INSTR;
}
