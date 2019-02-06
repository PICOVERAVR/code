| Application section of 68k device

	.text
	.global user_start

user_start: | user-mode at startup
	nop
	
	.section .bss
.align 4

	.section .data
.align 4
