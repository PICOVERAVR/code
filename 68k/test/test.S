	.section .rodata
.set RESET_SSP_PTR, 0x40000
.set RESET_PC, 0x00000400 | start point

.long RESET_SSP_PTR
.long RESET_PC
.space 0x3F8

	.text
	.global start

start:
	move.b #0xFF, (0x40005)
	jmp start
	

	.data
str: .asciz "Hello, World!"

