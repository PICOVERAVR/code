.name bigger.asm

RESET: BN org
INT_0: BN int

.org 0x100
org:
	LD 0xffff, SP // init stack pointer
	
	LD 100, R1
	LD 2, R2
loop:
	MUL R1, R2, R3
	SUB 1, R1, R1
	BNE R1, R0, loop
	
loop:	
	BN loop

int:
	IO R1, 0xbeef
	RET
	
I should write a flex/bison parser for the assembly, it would make writing programs way easier!

