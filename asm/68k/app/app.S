| Application section of 68k device

	.text
	.global user_start

user_start:
	|andi #0xDFFF, %sr (put in by bootloader)
	nop
	
	.section .bss
.align 4

	.section .data
.align 4
.byte '$' | to indicate end of app
