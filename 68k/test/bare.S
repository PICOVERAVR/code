	.section .rodata
.long RESET_SSP_PTR
.long RESET_PC
.space 0x3F8

.set RESET_SSP_PTR, 0x40000 | stack is pre-decrement
.set RESET_PC, 0x400

	.text
	.global test_start

test_start:
	| set up MFP
	| write a character
	| delay a bit
	| jump to start


	.data
.asciz "Nomadic!\n"
