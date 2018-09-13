.name bigger.asm

BN 0x7
LD 0xA
MUL 0x4
SUB 0x3
Bcc 0x9
IO 0xB
RET 0x13
MOV 0x15

RESET: BN org
INT_0: BN int

.org 0x100
org:
	LD 0xffff, SP
	
	LD 100, R1
	LD 2, R2
loop:
	MOV PC, R4
	MUL R1, R2, R3
	SUB 1, R1, R1 
	BNE R1, R0, R4	
	BN PC
	
int:
	IO R1, 0xbeef
	RET
	
I should write a flex/bison parser for the assembly, it would make writing programs way easier!

