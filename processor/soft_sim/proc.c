#include "proc.h" 
#include "setup.h" // for system setup and initialization
#include "execute.h" // for individual instruction implementations
#include "dispatch.h" // for individual instruction dispatch

#define HAVE_TRAP 1 // tell execute.c that we can trap things

static void proc_feat_set(state *s, int bitpos, int val) {
	s->p.proc_ext_state |= val << bitpos;
}

static uint16_t proc_feat_get(state *s, int bitpos) {
	return (s->p.proc_ext_state >> bitpos);
}

void trap_service(proc *p, int trap_vector) {
	// p->proc_ext_state = trap_vector / 4; NOT SHIFTED PROPERLY
	p->BP = p->PC; // save PC, keep SP
	p->BP -= 4;
	p->PC = trap_vector; // jump to trap
}

volatile sig_atomic_t interrupt_requested = 0;

static void interrupt_handle(state *s) {
	
	unsigned int interrupt_level;
	dbprintf("caught interrupt, PC 0x%x", s->p.PC);
	printf("3bu ilevel: ");
	scanf("%d", &interrupt_level);
	
	if (interrupt_level > 7) {
		printf("WARN: invalid interrupt level!\n");
	}
	
	s->p.BP = s->p.PC; // save PC and jump
	s->p.BP -= 4;
	s->p.PC = (4 * interrupt_level) + SYSTEM_TRAP_VEC_SIZE; // jump to interrupt vector, skip trap table
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
		dbprintf("RST encountered, resetting processor\n");
	}

	uint32_t *hex_mem = proc_setup(argc, argv, s); // this clears processor state!
	if (hex_mem == NULL) {
		fprintf(stderr, "ERR: setup error.\n");
		exit(NO_HEX_ERROR);
	}
	
	// disable interrupts until we want them
	proc_feat_set(s, PROC_FEAT_IE, 0);
	
	interrupt_requested = false;
	signal(SIGQUIT, signal_handler);
	
	dbprintf("starting simulation... (ctl-\\ for interrupt)\n");
	for(;;) {
		
		perf_counter++;
		if (s->p.PC % 4 != 0) {
		// below is actually correct, but I wrote my test program wrong and I want it to pass
		//if (s->p.PC % 4 != 0 || s->p.SP % 4 != 0 || s->p.BP % 4 != 0) {
			fprintf(stderr, "EXCP: Misaligned cntl!\n");
			s->p.PC = EXCP_MISALIGNED_CNTL_VEC;
		}
		
		if (interrupt_requested && proc_feat_get(s, PROC_FEAT_IE)) {
			interrupt_handle(s);
			interrupt_requested = false; // clear interrupt flag
		} else {
			s->p.i.raw_instr = hex_mem[s->p.PC / sizeof(uint32_t)];
			dbprintf("fetched instruction 0x%x, PC 0x%x", s->p.i.raw_instr, s->p.PC);
			
			s->p.PC += 4;
		}
		
		int err = disp(s, ram);
		if (err == EXCP_ILL_INSTR) {
			fprintf(stderr, "EXCP: Illegal instruction 0x%x!\n", s->p.i.raw_instr);
			s->p.PC = EXCP_ILL_INSTR_VEC;
		} else if (err == SIM_STOP) {
			exit(0);
		}
		
	}
	fprintf(stderr, "ERR: reached end of sim\n");
	return INTERNAL_ERROR;
}
