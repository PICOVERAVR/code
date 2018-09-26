#include "dispatch.h"
#include "execute.h"

int disp(state *s, uint16_t *ram) {
		// every op is broken out into a function in order for profiler to catch all
		// instructions that get executed
		// also looks better... kinda
	switch (s->p.i.opcode) {
		case ADD ... DIV:
		case AND ... INV:
			if (s->p.i.f_d == REGISTER_R0) {
				dbprintf("Write to R0 detected.\n");
				return 0;
			}
	}
		
	switch (s->p.i.opcode) {
		case NOP: break;
		case RST: 
			memset(s->p.regfile, 0, sizeof(s->p.regfile));
			break;
		case ADD:
			instr_add(&(s->p)); //possible and a good idea to 
					    //do more error checking here!
			break;
		case SUB:
			instr_sub(&(s->p));
			break;
		case MUL:
			instr_mul(&(s->p));
			break;
		case DIV:
			instr_div(&(s->p));
			break;
		case AND:
			instr_and(&(s->p));
			break;
		case OR:
			instr_or(&(s->p));
			break;
		case XOR:
			instr_xor(&(s->p));
			break;
		case NOT:
			instr_not(&(s->p));
			break;
		case INV:
			instr_inv(&(s->p));
			break;
		case SEX:
			instr_sex(&(s->p));
			break;
		case LD:
			instr_ld(&(s->p), ram);
			break;
		case ST:
			instr_st(&(s->p), ram);
			break;
		case BN:
			instr_bn(&(s->p));
			break;
		case BS:
			instr_bs(&(s->p));
			break;
		case BR:
			instr_br(&(s->p));
			break;
		case MOV:
			instr_mov(&(s->p));
			break;
		case Bcc:
			instr_bcc(&(s->p));
			break;
		case IO:
			instr_io(&(s->p));
			break;
		case CALL:
			instr_call(&(s->p));
			break;
		case RET:
			instr_ret(&(s->p));
			break;
		case PS:
			instr_ps(s);
		case STOP:
			dbprintf("reached STOP instr, PC 0x%x", s->p.PC);
			return SIM_STOP;
		default:
			printf("ERR: unknown opcode!\n");
			return EXCP_ILL_INSTR;
	}
	return 0;
}
