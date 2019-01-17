| Application section of 68k device

	.text
	.global user_start

user_start:
	|andi #0xDFFF, %sr (put in by bootloader)
	nop|

	.section .data
.align 4
	
	.section .bss
.align 4
