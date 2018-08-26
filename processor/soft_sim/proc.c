#include "proc.h" // main project header file
#include "execute.h" // for individual instruction implementations

//fetch the next instruction from hex_mem
uint32_t fetch(uint16_t addr, uint32_t *hex_mem) {
	return hex_mem[addr];
}

void break_ill_opcode() {
	fprintf(stderr, "EXCP: illegal opcode!");
	proc_teardown();
	exit(EXCP_ILL_OPCODE);
}


//actual memory for processor!
uint32_t *rom, *ram;

int main(int argc, char **argv) {
	
	
	uint32_t *hex_mem = NULL;
	state *s = NULL;
	
	
	jmp_buf start;
	if (setjmp(start)) {
		printf("resetting after HALT instruction\n");
	}
	
	//read hex file into ROM, init state
	proc_setup(argc, argv, hex_mem, s);
	
	for(;;) {
		s->p.i.raw_instr = fetch(0, hex_mem);
		s->p.PC += 4;
		
		switch (s->p.i.opcode) {
			case NOP: break;
			case HALT: longjmp(start, 1);
			case ADD:
				instr_add(&(s->p.i));
			
			default: break_ill_opcode();
		};
		
	}
}
