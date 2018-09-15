.name bigger.asm

RESET: BN org
INT_0: BN int

.org 0x100
org:
	LD 0xffff, BP
	MOV BP, SP
	
	LD 100, R1
	LD 2, R2
.loop 0x110
loop:
	MOV PC, R4
	//   s0  s1  ld  hd
	MULU R1, R2, R3, R5
	SUBU 1, R1, R1
	BNE R1, R0, R4
	
.int 0x140	// not implemented
int:
	IO R1, 0xbeef
	RET
	
