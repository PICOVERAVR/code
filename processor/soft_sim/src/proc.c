#include "proc.h" 
#include "setup.h" // for system setup and initialization
#include "execute.h" // for individual instruction implementations
#include "dispatch.h" // for individual instruction dispatch

#define HAVE_TRAP 1 // tell execute.c that we can trap things

static void proc_feat_set(proc *p, int bitpos, int val) {
	p->proc_ext_state |= val << bitpos;
}

static uint16_t proc_feat_get(proc *p, int bitpos) {
	return (p->proc_ext_state >> bitpos);
}

void trap_service(proc *p, int trap_vector) {
	// p->roc_ext_state = trap_vector / 4; NOT SHIFTED PROPERLY
	p->SP = p->PC; // save PC, keep SP
	p->SP -= 4;
	p->PC = trap_vector; // jump to trap
}

volatile sig_atomic_t interrupt_requested = 0;

static void interrupt_handle(proc *p) {
	
	unsigned int interrupt_level;
	dbprintf("caught interrupt, PC 0x%x", p->PC);
	printf("3bu ilevel: ");
	int err = scanf("%d", &interrupt_level);
	if (err < 0) {
		perror("scanf");
	}

	if (interrupt_level > 7) {
		printf("WARN: invalid interrupt level!\n");
	}
	
	p->BP = p->PC; // save PC and jump
	p->BP -= 4;
	p->PC = (4 * interrupt_level) + SYSTEM_TRAP_VEC_SIZE; // jump to interrupt vector, skip trap table
}

void signal_handler(int signum) {
	interrupt_requested = 1;
}

int main(int argc, char **argv) {
	proc *p = malloc(sizeof(proc));
	
	uint64_t perf_counter = 0;

	jmp_buf start;
	if (setjmp(start)) {
		dbprintf("RST encountered, resetting processor\n");
	}

	uint32_t *hex_mem = proc_setup(argc, argv, p); // this clears processor state!
	if (hex_mem == NULL) {
		fprintf(stderr, "ERR: setup error.\n");
		free(p);
		exit(NO_HEX_ERROR);
	}
	
	// disable interrupts until we want them
	proc_feat_set(p, PROC_FEAT_IE, 0);
	
	interrupt_requested = false;
	signal(SIGQUIT, signal_handler);
	
	uint16_t *ram = malloc(PROC_RAM);
	
	dbprintf("starting simulation... (ctl-\\ for interrupt)\n");
	for(;;) {
		
		perf_counter++;
		if (p->PC % 4 != 0 || p->SP % 4 != 0 || p->BP % 4 != 0) {
			fprintf(stderr, "EXCP: Misaligned cntl!\n");
			p->PC = EXCP_MISALIGNED_CNTL_VEC;
		}
		
		if (interrupt_requested && proc_feat_get(p, PROC_FEAT_IE)) {
			interrupt_handle(p);
			interrupt_requested = false; // clear interrupt flag
		} else {
			p->i.raw_instr = hex_mem[p->PC / sizeof(uint32_t)];
			dbprintf("fetched instruction 0x%x, PC 0x%x", p->i.raw_instr, p->PC);
			
			p->PC += 4;
		}
		
		int err = disp(p, ram);
		if (err == EXCP_ILL_INSTR) {
			fprintf(stderr, "EXCP: Illegal instruction 0x%x!\n", p->i.raw_instr);
			p->PC = EXCP_ILL_INSTR_VEC;
		} else if (err == SIM_STOP) {
			break;
		}
		
	}
	
	free(p);
	free(ram);
	
	fprintf(stderr, "INFO: reached end of sim\n");
	return INTERNAL_ERROR;
}
