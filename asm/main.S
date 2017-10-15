# For 64-bit linux

	.global main

	.text

main:
	#pushq %rbp
	#movq %rsp, %rbp
	
	mov $message, %rdi
	call puts
	ret




	#mov $60, %rax
	#xor %rdi, %rdi
	#syscall #sys_exit

message:
	.asciz "hello!"
