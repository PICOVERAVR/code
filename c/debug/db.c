#include "db.h"

void print_info(pid_t child, struct user_regs_struct *regs) {
	printf("Program information:\n");
	
	printf("RIP: %#llx\n", regs->rip);
	printf("RSP: %#llx\n", regs->rsp);
}

void run_debugger(pid_t child) {
	int wait_status;
	long long int data = 0; // instruction to store while using breakpoints
	long long int addr = 0; 
	
	bool running = false;
	long long int bp_list[NUM_BREAKPOINTS] = {0};
	int bp_free = 0;
	
	struct user_regs_struct regs;
	
	printf("Debugger started.\n");
	
	// wait until something happens
	wait(&wait_status);
	
	// check if it's because the child stopped
	while (WIFSTOPPED(wait_status)) {
		
		printf("Child stopped: %s\n", strsignal(WSTOPSIG(wait_status)));
		running = false;
		
		while (!running) {
			char temp = get_input();
			switch (temp) {
				case 's':
					ptrace(PTRACE_SINGLESTEP, child, 0, 0);
					running = true;
					break;
				case 'c':
					ptrace(PTRACE_GETREGS, child, 0, &regs);
					for (int i = 0; i < NUM_BREAKPOINTS; i++) {
						if (bp_list[i] == regs.rip-1) {
							printf("Resuming from breakpoint %d\n", i);
							ptrace(PTRACE_POKETEXT, child, addr, data);
							regs.rip -= 1;
							ptrace(PTRACE_SETREGS, child, 0, &regs);
							ptrace(PTRACE_CONT, child, 0, 0);
						}
					}
					ptrace(PTRACE_CONT, child, 0, 0);
					running = true;
					break; 
				case 'b': 
					// NOTE: there's a bug here where if you set multiple breakpoints 
					// the instruction data gets overwritten and probably segfaults.
					addr = get_mem_break();
					data = ptrace(PTRACE_PEEKTEXT, child, (void*) addr, 0);
					long long int mod_data = (data & 0xFFFFFF00) | 0xCC;
					ptrace(PTRACE_POKETEXT, child, (void*) addr, (void*) mod_data);
					printf("Set breakpoint %d at %llx\n", bp_free, addr);
					bp_list[bp_free++] = addr;
					break;
				case 'i':
					// update registers
					ptrace(PTRACE_GETREGS, child, 0, &regs);
					print_info(child, &regs);
					break;
				case 'x': 
					kill(child, SIGKILL);
					exit(0);
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
		perror("ptrace");
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
		run_debugger(child);
	} else {
		perror("Fork");
		exit(3);
	}
	
}
