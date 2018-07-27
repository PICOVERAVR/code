// gcc -no-pie -g test.S -o test.out
	.global main

	.text
main:
	
	// $scratch is address
	// scratch is data
	
	movq $42, scratch
	
	// need to figure out how to translate char ** to asm
	// and the different sections of this file.
	mov $scratch, %rax
	mov scratch, %rbx
	mov (%rax), %rcx //same as line 12
	
	//figure out strtol
	//lea %rax, %rcx
	
	ret
	
	.data
msg_1:
	.asciz "-4"
msg_2:
	.asciz "4F"
msg_3:
	.asciz "592"
	
	.bss
scratch:
	.quad
scratch2:
	.quad

word_buffer:
	.space 512
