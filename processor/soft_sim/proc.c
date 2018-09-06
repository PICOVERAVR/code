#include "proc.h" // main project header file
#include "setup.h"
#include "execute.h" // for individual instruction implementations

//varadic macro to free everything we allocated at start, in case we need this
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
	uint16_t *ram = malloc(PROC_RAM);
	
	uint64_t perf_counter = 0;

	jmp_buf start;
	if (setjmp(start)) {
		printf("RST encountered, resetting processor\n");
	}
	
	uint32_t *hex_mem = proc_setup(argc, argv, s);
	if (hex_mem == NULL) {
		fprintf(stderr, "ERR: setup error.\n");
		exit(EXCP_NO_HEX);
	}
	
	/*
		idea: write sim of peripherals as well
			simple:
				ultra-basic MMU
					checking for jumping to 0x0
					checking for execution outside of ROM/RAM area
				timer
				I/O handling
				etc.
		
		make linked list of function pointers to update functions, pass processor state
		run through all updates every processor cycle
		should be able to trigger other stuff (cause list pointer to go back/forward)
		
	*/
	
	for(;;) {
		s->p.i.raw_instr = hex_mem[s->p.PC / sizeof(uint32_t)];
		
		s->p.PC += 4;
		perf_counter++;
		
		
		// every op is broken out into a function in order for profiler to catch all
		// instructions that get executed
		// also looks better
		switch (s->p.i.opcode) {
			case NOP: break;
			case RST: longjmp(start, 1);
			case ADD:
				instr_add(&(s->p)); //possible and a good idea to 
						    //do more error checking here!
				break;
			case SUB:
				instr_sub(&(s->p));
				break;
			case MUL:
				//
				break;
			case DIV:
				//
				break;
			case SEX:
				instr_sex(&(s->p));
				break;
			case LD:
				instr_ld(&(s->p), ram);
				break;
			case BN:
				instr_bn(&(s->p));
				break;
			case BS:
				instr_bs(&(s->p));
				break;
			case Bcc:
				
				break;
			case STOP:
				printf("reached STOP instr\n");
				return SIM_STOP;
			default: 
				printf("unknown opcode!\n");
				return EXCP_ILL_OPCODE;
		};
		
	}
	fprintf(stderr, "ERR: reached end of sim\n");
	return INTERNAL_ERROR;
}
