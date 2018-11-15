#include "dispatch.h"
#include "execute.h"

static int check_arithmetic(proc *p) {
	if (p->i.f_d == REGISTER_R0) {
		dbprintf("Write to R0 detected.");
		return -1; // not an error according to the isa, but return an error code to
			   // abort executing anything
	}
	return 0;
}

int disp(proc *p, uint16_t *ram) {
	// every op is broken out into a function in order for profiler to catch all
	// instructions that get executed
	// also looks better... kinda
	
	switch (p->i.opcode) {
		case ADD ... DIV:
		case AND ... INV:
			// not everything here is an error, but all will abort instruction execution
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
		default:
			printf("ERR: unknown opcode!\n");
			return EXCP_ILL_INSTR;
	}
	return 0;
}
