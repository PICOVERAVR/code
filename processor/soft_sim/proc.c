#include "proc.h" // main project header file
#include "setup.h"
#include "execute.h" // for individual instruction implementations

#define FREE_ALL() free_state(3, (void*) hex_mem, (void*) s, (void*) ram);

//fetch the next instruction from hex_mem
uint32_t fetch(uint16_t addr, uint32_t *hex_mem) {
	return hex_mem[addr];
}

//varadic macro to free everything we allocated
void free_state(int num_free, ...) {
	va_list args;
	va_start(args, num_free);
	for (int i = 0; i < num_free; i++) {
		free(va_arg(args, void *));
	}
	va_end(args);
}

int main(int argc, char **argv) {
	
	state *s = malloc(sizeof(state));
	uint32_t *ram = malloc(PROC_RAM);

	jmp_buf start;
	if (setjmp(start)) {
		printf("RST encountered, resetting processor\n");
	}
	
	uint32_t *hex_mem = proc_setup(argc, argv, s);
	if (hex_mem == NULL) {
		fprintf(stderr, "ERR: setup error.\n");
		exit(EXCP_NO_HEX);
	}

	for(;;) {
		s->p.i.raw_instr = fetch(s->p.PC, hex_mem);
		s->p.PC += 4;
		
		switch (s->p.i.opcode) {
			case NOP: break;
			case RST: longjmp(start, 1);
			case ADD:
				instr_add(&(s->p));
				break;
			case SUB:
				instr_sub(&(s->p));
				break;
			case SEX:
				instr_sub(&(s->p));
				break;
			case STOP:
				printf("reached STOP instr\n");
				FREE_ALL();
				return SIM_STOP;
			default: 
				printf("unknown opcode!\n");
				FREE_ALL();
				return EXCP_ILL_OPCODE;
		};
		
	}
	fprintf(stderr, "reached end of program somehow...\n");
	FREE_ALL();
	return INTERNAL_ERROR;
}
