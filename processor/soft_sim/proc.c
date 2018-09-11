#include "proc.h" 
#include "setup.h" // for system setup and initialization
#include "execute.h" // for individual instruction implementations

#define PROC_FEAT_SET(bitpos, val) \
s->proc_ext_state |= val << bitpos

#define PROC_FEAT_GET(bitpos) \
(s->proc_ext_state >> bitpos) & 1

bool interrupt_requested;

static void interrupt_handle(state *s) {
	
	unsigned int interrupt_level;
	printf("Caught interrupt\n");
	printf("3bu ilevel: ");
	scanf("%d", &interrupt_level);
	
	if (interrupt_level > 7) {
		printf("WARN: invalid interrupt level!\n");
	}

	s->p.PC = 4 * interrupt_level; // jump to interrupt vector
}

void signal_handler(int signum) {
	interrupt_requested = true;
}

int main(int argc, char **argv) {
	state *s = malloc(sizeof(state));
	uint16_t *ram = malloc(PROC_RAM);
	
	uint64_t perf_counter = 0;

	jmp_buf start;
	if (setjmp(start)) {
		printf("RST encountered, resetting processor\n");
	}

	uint32_t *hex_mem = proc_setup(argc, argv, s); // this clears processor state!
	if (hex_mem == NULL) {
		fprintf(stderr, "ERR: setup error.\n");
		exit(NO_HEX_ERROR);
	}
	
	// configure interrupt system at start
	PROC_FEAT_SET(PROC_FEAT_IE, 1);
	
	interrupt_requested = false;
	signal(SIGQUIT, signal_handler);

	printf("starting simulation... (ctl-\\ for interrupt)\n");
	for(;;) {
		if (interrupt_requested && s->proc_ext_state) {
			interrupt_handle(s);
			interrupt_requested = false; // clear interrupt flag
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
				instr_mul(&(s->p));
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
			case IO:
				instr_io(&(s->p));
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
