#include "db.h"

void step(pid_t child) {
	if (ptrace(PTRACE_SINGLESTEP, child, 0, 0)) {
		perror("ptrace");
		exit(2);
	}
}

void print_info(pid_t child, struct user_regs_struct *regs) {
	printf("Program information:\n");
	
	printf("RIP: 0x%llx\n", regs->rip);
}

void run_debugger(pid_t child) {
	int wait_status;
	long long int data; // instruction to store while using breakpoints
	long long int addr; 
	
	bool running = false;
	
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
					step(child);
					running = true;
					break;
				case 'c': 
					ptrace(PTRACE_CONT, child, 0, 0);
					running = true;
					break; 
				case 'b': 
					addr = get_mem_break();
					data = ptrace(PTRACE_PEEKTEXT, child, (void*) addr, 0);
					long long int mod_data = (data & 0xFFFFFF00) | 0xCC;
					ptrace(PTRACE_POKETEXT, child, (void*) addr, (void*) mod_data);
					printf("Set breakpoint at %llx\n", addr);
					break;
				case 'r': // this sould be integrated into continue!
					ptrace(PTRACE_POKETEXT, child, addr, data);
					regs.rip -= 1;
					ptrace(PTRACE_SETREGS, child, 0, &regs);
					ptrace(PTRACE_CONT, child, 0, 0);
					running = true;
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
					printf("Unknown command %c (%d)\n", temp, (int)temp);
			}
		}
			
		// wait for child to stop again
		wait(&wait_status);
	}
	printf("Child exited with status %d\n",WEXITSTATUS(wait_status));
}

void run_target(const char *program_name) {
	
	printf("Starting program %s\n", program_name);
	
	// asks the kernel if the parent can trace it
	if (ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
		perror("ptrace");
		exit(2);
	}
	
	// exec needs a NULL sentinel at the end
	execl(program_name, program_name, NULL);
}


// take in a program name and fork
// child runs the program, parent uses ptrace to examine state
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
