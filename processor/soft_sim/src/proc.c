#include "proc.h" 
#include "setup.h" // for system setup and initialization
#include "execute.h" // for individual instruction implementations
#include "dispatch.h" // for individual instruction dispatch
#include "core.h" // for misc assist functions
#include "__assist.h" // for external assist functions

#define HAVE_TRAP 1 // tell execute.c that we can trap things

volatile sig_atomic_t interrupt_requested = 0;

int main(int argc, char **argv) {
	uint64_t perf_counter = 0;

	jmp_buf start;
	if (setjmp(start)) {
		dbprintf("RST encountered, resetting processor\n");
	}
	
	uint32_t *hex_mem = proc_setup(argc, argv); // this inits all proc state to 0
	if (hex_mem == NULL) {
		fprintf(stderr, "ERR: setup error.\n");
		return SETUP_ERROR;
	}

	proc *p = malloc(sizeof(proc));
	if (!p) {
		perror("malloc");
		return INTERNAL_ERROR;
	}

	memset(p, 0, sizeof(proc));
	p->proc_ext_feat |= 1 << 1; // hardware mul/div supported
	
	// disable interrupts by default
	proc_feat_set(p, PROC_FEAT_IE, 0);
	
	interrupt_requested = false;
	signal(SIGQUIT, signal_handler);
	
	uint16_t *ram = malloc(PROC_RAM);
	if (!ram) {
		perror("malloc");
		return INTERNAL_ERROR;
	}
	
	fprintf(stderr, "INFO: starting sim (ctl-\\ for interrupt)\n");
	for(;;) {
		
		perf_counter++;
		// check for misaligned control registers
		if (p->PC % 4 != 0 || p->SP % 4 != 0 || p->BP % 4 != 0) {
			fprintf(stderr, "EXCP: Misaligned cntl!\n");
			p->PC = EXCP_MISALIGNED_CNTL_VEC;
		}
		
		// check for interrupts and handle it if necessary
		if (interrupt_requested && proc_feat_get(p, PROC_FEAT_IE)) {
			interrupt_handle(p);
			interrupt_requested = false;
		} else {
			p->i.raw_instr = hex_mem[p->PC / sizeof(uint32_t)];
			dbprintf("fetched instruction 0x%x, PC 0x%x", p->i.raw_instr, p->PC);
			
			p->PC += 4;
		}
		
		// dispatch fetched instruction
		int err = disp(p, ram);
		if (err == EXCP_ILL_INSTR) {
			fprintf(stderr, "EXCP: Illegal instruction 0x%x!\n", p->i.raw_instr);
			p->PC = EXCP_ILL_INSTR_VEC;
		} else if (err == RET_STOP) {
			break;
		}
	}
	
	__assist_free_all(3, p, hex_mem, ram);
	
	fprintf(stderr, "INFO: reached end of sim\n");
	return INTERNAL_ERROR;
}
