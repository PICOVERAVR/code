// figure out size of prefetch input queue
// on x86-64 processors
// This program will fail because we need to mark the page as writable and executable!

.global main

main:
	movq ahead, %bx
	movw $0x9090, %cs:(%bx)
	
ahead:
	jmp end
	.space 4 // slowly increase this!
end:
	mov $60, %rax
	syscall
