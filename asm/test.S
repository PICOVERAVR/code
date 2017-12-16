//sandbox environment, do not push since we don't care about whatever is here

	.global _start
	
	.text
_start:
	push $255
	mov $thing, %rsi
	lodsq //load rsi into rax
	
	//my code:
	//mov %rsi, %rax
	//ad $8, %rsi
	//jmp *(%rax)
	
	//jonesforth code:
	//lodsl
	//jmp *(%eax)
	mov $60, %rax
	xor %rdi, %rdi
	syscall

thing:
	.quad stuff

stuff:
	mov $1, %rbx
