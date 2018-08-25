	.global main

	.text
main:
	
	mov $0xff, %rax
	push %rax
	
	mov $60, %rax
	xor %rdi, %rdi
	syscall

