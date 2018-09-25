#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include <sys/types.h> // for pid_t types
#include <sys/ptrace.h> // for tracing another process
#include <sys/wait.h> // for waiting on another process
#include <sys/user.h>

//#define VERB

void run_debugger(pid_t child) {
	int wait_status;
	unsigned int counter = 0;
	printf("Debugger started.\n");
	
	// wait until something happens
	wait(&wait_status);
	
	// check if it's because the child stopped
	while (WIFSTOPPED(wait_status)) {
		counter++;

		struct user_regs_struct regs;
		ptrace(PTRACE_GETREGS, child, 0, &regs);
		
		#ifdef VERB
			printf("counter: %u RIP: 0x%08llx\n", counter, regs.rip);
		#endif
		
		// restart the process, execute one instruction, and stop again
		if (ptrace(PTRACE_SINGLESTEP, child, 0, 0)) {
			perror("ptrace");
			exit(2);
		}
		
		// wait for child to stop again
		wait(&wait_status);
	}
	printf("Child executed %d instructions\n", counter);
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
