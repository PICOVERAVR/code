#include "proc.h" 
#include "setup.h" // for system setup and initialization
#include "execute.h" // for individual instruction implementations
#include "dispatch.h" // for individual instruction dispatch

static void proc_feat_set(state *s, int bitpos, int val) {
	s->proc_ext_state |= val << bitpos;
}

static uint16_t proc_feat_get(state *s, int bitpos) {
	return (s->proc_ext_state >> bitpos);
}

volatile sig_atomic_t interrupt_requested = 0;

static void interrupt_handle(state *s) {
	
	unsigned int interrupt_level;
	printf("Caught interrupt\n");
	printf("3bu ilevel: ");
	scanf("%d", &interrupt_level);
	
	if (interrupt_level > 7) {
		printf("WARN: invalid interrupt level!\n");
	}
	
	
	s->p.SP = s->p.PC; // save PC and jump
	s->p.SP -= 4;
	s->p.PC = 4 * interrupt_level; // jump to interrupt vector
}

void signal_handler(int signum) {
	interrupt_requested = 1;
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
	proc_feat_set(s, PROC_FEAT_IE, 1);
	
	interrupt_requested = false;
	signal(SIGQUIT, signal_handler);

	printf("starting simulation... (ctl-\\ for interrupt)\n");
	for(;;) {
		if (interrupt_requested && proc_feat_get(s, PROC_FEAT_IE)) {
			interrupt_handle(s);
			interrupt_requested = false; // clear interrupt flag
		} else {
			s->p.i.raw_instr = hex_mem[s->p.PC / sizeof(uint32_t)];
			s->p.PC += 4;
		}

		perf_counter++;
		if (disp(s, ram)) {
			return -1;
		}
		
	}
	fprintf(stderr, "ERR: reached end of sim\n");
	return INTERNAL_ERROR;
}
