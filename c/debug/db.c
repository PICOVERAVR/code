#include "db.h"

void print_info(pid_t child, struct user_regs_struct *regs) {
	printf("Program information:\n");
	
	printf("RIP: %#llx\n", regs->rip);
	printf("RSP: %#llx\n", regs->rsp);
}

void run_debugger(pid_t child, const char *child_name) {
	int wait_status;
	uint64_t data = 0; // instruction to store while using breakpoints
	uint64_t addr = 0; 
	
	bool running = false;
	uint64_t bp_list[NUM_BREAKPOINTS];
	uint64_t bp_data[NUM_BREAKPOINTS];
	int bp_free = 0;
	
	struct user_regs_struct regs;
	
	char system_str[128];
	
	printf("Debugger started.\n");
	
	// wait until something happens
	wait(&wait_status);
	
	// check if it's because the child stopped
	while (WIFSTOPPED(wait_status)) {
		
		ptrace(PTRACE_GETREGS, child, 0, &regs);
		printf("Child stopped @%#llx: %s\n", regs.rip, strsignal(WSTOPSIG(wait_status)));
		running = false;
		// update registers on debug side
		
		while (!running) {
			char temp = get_input();
			switch (temp) {
				case 'd':
					snprintf(system_str, sizeof(system_str), "objdump -d %s", child_name);
					int err = system(system_str);
					if (err) printf("ERR: cannot dump executable.\n");
					break;
				case 's':
					ptrace(PTRACE_SINGLESTEP, child, 0, 0);
					running = true;
					break;
				case 'c':
					ptrace(PTRACE_GETREGS, child, 0, &regs);
					for (int i = 0; i < NUM_BREAKPOINTS; i++) {
						if (bp_list[i] == regs.rip-1) {
							printf("Resuming from breakpoint %d\n", i);
							ptrace(PTRACE_POKETEXT, child, bp_list[i], bp_data[i]);
							regs.rip--;
							ptrace(PTRACE_SETREGS, child, 0, &regs);
							ptrace(PTRACE_CONT, child, 0, 0);
						}
					}
					ptrace(PTRACE_CONT, child, 0, 0);
					running = true;
					break; 
				case 'b': 
					addr = get_mem_break();
					data = ptrace(PTRACE_PEEKTEXT, child, (void*) addr, 0);
					// patch the instruction at the breakpoint with a 'int 3' opcode: 0xCC
					uint64_t mod_data = (data & 0xFFFFFF00) | 0xCC;
					ptrace(PTRACE_POKETEXT, child, (void*) addr, (void*) mod_data);
					printf("Set breakpoint %d at %lx\n", bp_free, addr);
					bp_list[bp_free] = addr;
					bp_data[bp_free++] = data;
					break;
				case 'i':
					print_info(child, &regs);
					break;
				case 'x': 
					if (kill(child, SIGKILL)< 0) {
						perror("sigkill");
					}
					exit(0);
				case 'h':
					printf("Help menu:\nd: disassemble the current program\ns: single-step the current program\nc: continue from breakpoint\nb: set a breakpoint\ni: info about PC and SP\nx: kill child and quit\nh: this help menu\n\n");
					break;
				default: 
					printf("Unknown command %c\n", temp);
			}
		}
		
		// wait for child to stop again
		wait(&wait_status);
	}
	printf("Child exited with status %d\n",WEXITSTATUS(wait_status));
}

void run_target(const char *program_name) {
	
	printf("Starting program %s.\n", program_name);
	
	// asks the kernel if the parent can trace it
	if (ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
		perror("trace");
		exit(2);
	}
	
	// exec needs a NULL sentinel at the end
	execl(program_name, program_name, NULL);
}

int main(int argc, char **argv) {
	pid_t child;
	
	if (argc < 2) {
		fprintf(stderr, "Usage: db <program>\n");
		exit(1);
	}
	
	child = fork();
	if (child == 0) {
		// child process runs the target
		run_target(argv[1]);
	} else if (child > 0) {
		run_debugger(child, argv[1]);
	} else {
		perror("fork");
		exit(3);
	}
}
