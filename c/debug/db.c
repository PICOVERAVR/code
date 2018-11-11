#include "db.h"

const char *help_text = "Help menu:\nd: disassemble the current program\ns: single-step the current program\nc: continue from breakpoint\n b: set a breakpoint\ni: info about PC and SP\nx: kill child and quit\nh: this help menu\n\n";

void print_info(pid_t child, struct user_regs_struct *regs) {
	printf("Program information:\n");
	
	printf("RIP: %#llx\n", regs->rip);
	printf("RBP: %#llx\n", regs->rbp);
	printf("RSP: %#llx\n", regs->rsp);
}

void check_clear_bp(pid_t child, uint64_t *list, uint64_t *data, int *next_free) {
	struct user_regs_struct temp_regs;

	ptrace(PTRACE_GETREGS, child, 0, &temp_regs);
	for (int i = 0; i <= *next_free; i++) {
		if (list[i] == temp_regs.rip-1) {
			printf("Resuming from breakpoint %d\n", i);
			ptrace(PTRACE_POKETEXT, child, list[i], data[i]);
			temp_regs.rip--;
			ptrace(PTRACE_SETREGS, child, 0, &temp_regs);
			(*next_free)--;
		}
	}
}

void free_all(int numfree, void *arg1, ...) {
	va_list args;
	void *vp;
	free(arg1);
	va_start(args, arg1);

	for (int i = 0; i < numfree-1; i++) {
		vp = va_arg(args, void *);
		free(vp);
	}
	va_end(args);
}

void run_debugger(pid_t child, const char *child_name) {
	int wait_status;
	uint64_t data = 0; // instruction to store while using breakpoints
	uint64_t addr = 0; 
	
	bool running = false;
	uint64_t *bp_list = calloc(NUM_BREAKPOINTS, sizeof(uint64_t));
	uint64_t *bp_data = calloc(NUM_BREAKPOINTS, sizeof(uint64_t));
	if (bp_list == NULL || bp_data == NULL) {
		printf("ERR: could not allocate debugger memory.\n");
	}
	int bp_free = 0;
	
	struct user_regs_struct regs;
	
	char system_str[512];
	
	printf("Debugger started. Enter 'h' for help.\n");
	
	ptrace(PTRACE_SETOPTIONS, child, 0, PTRACE_O_TRACESYSGOOD);
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
					// security vuln here: if program is named '<program>; <cmd>', cmd will be executed
					snprintf(system_str, sizeof(system_str), "objdump -d %s", child_name);
					int err = system(system_str);
					if (err) printf("ERR: cannot dump executable.\n");
					break;
				case 's':
					check_clear_bp(child, bp_list, bp_data, &bp_free);
					ptrace(PTRACE_SINGLESTEP, child, 0, 0);
					running = true;
					break;
				case 'c':
					check_clear_bp(child, bp_list, bp_data, &bp_free);
					ptrace(PTRACE_CONT, child, 0, 0);
					running = true;
					break; 
				case 'b': 
					addr = get_mem_break();
					data = ptrace(PTRACE_PEEKTEXT, child, (void*) addr, 0);
					// patch the instruction at the breakpoint with a 'int 3' opcode: 0xCC
					uint64_t mod_data = (data & 0xFFFFFF00) | TRAP_CODE;
					ptrace(PTRACE_POKETEXT, child, (void*) addr, (void*) mod_data);
					printf("Set breakpoint %d at %lx\n", bp_free, addr);
					bp_list[bp_free] = addr;
					bp_data[bp_free] = data;
					bp_free++;
					break;
				case 'i':
					print_info(child, &regs);
					break;
				case 'x':
					if (kill(child, SIGKILL) < 0) {
						perror("kill");
					}
					free_all(2, bp_list, bp_data);
					exit(0);
				case 'h':
					printf("%s", help_text);
					break;
				default: 
					printf("Unknown command %c\n", temp);
					break;
			}
		}
		
		// wait for child to stop again
		wait(&wait_status);
	}
	free_all(2, bp_list, bp_data);
	printf("Child exited with status %d\n", WEXITSTATUS(wait_status));
}

void run_target(const char *program_name) {
	
	// asks the kernel if the parent can trace it
	if (ptrace(PTRACE_TRACEME, 0, 0, 0) < 0) {
		perror("trace");
		exit(1);
	}
	
	// exec needs a NULL sentinel at the end
	if (execl(program_name, program_name, NULL) < 0) {
		perror("exec");
		exit(-1);
	}
	
	printf("Starting program %s.\n", program_name);
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
		exit(1);
	}
}
