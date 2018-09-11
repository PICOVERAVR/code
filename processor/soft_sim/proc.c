#include "proc.h" // main project header file
#include "setup.h"
#include "execute.h" // for individual instruction implementations

bool interrupt_requested;

void signal_handler(int signum) {
	interrupt_requested = true;
}

int main(int argc, char **argv) {
	state *s = malloc(sizeof(state));
	uint16_t *ram = malloc(PROC_RAM);
	
	uint64_t perf_counter = 0;
	
	interrupt_requested = false;
	unsigned int interrupt_level = 0;

	jmp_buf start;
	if (setjmp(start)) {
		printf("RST encountered, resetting processor\n");
	}
	
	uint32_t *hex_mem = proc_setup(argc, argv, s);
	if (hex_mem == NULL) {
		fprintf(stderr, "ERR: setup error.\n");
		exit(EXCP_NO_HEX);
	}
	
	interrupt_requested = false;
	signal(SIGQUIT, signal_handler);

	printf("starting simulation... (ctl-\\ for interrupt)\n");
	for(;;) {
		if (interrupt_requested) {
			printf("Caught interrupt\n");
			printf("3bu ilevel: ");
			scanf("%d", &interrupt_level);
			
			if (interrupt_level > 7) {
				printf("WARN: invalid interrupt level!\n");
			}

			s->p.PC = 4 * interrupt_level; // jump to interrupt vector
			interrupt_requested = false; // clear interrupt flag

			// if we save registers here, we'll have to restore them later, and provide instructions to do so.
			
		} else {
			s->p.i.raw_instr = hex_mem[s->p.PC / sizeof(uint32_t)];
			s->p.PC += 4;
		}

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
				instr_bcc(&(s->p));
				break;
			case STOP:
				printf("WARN: reached STOP instr\n");
				return SIM_STOP;
			default: 
				printf("ERR: unknown opcode!\n");
				return EXCP_ILL_OPCODE;
		};
		
	}
	fprintf(stderr, "ERR: reached end of sim\n");
	return INTERNAL_ERROR;
}
