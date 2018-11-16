.name jmp_add.asm

RESET: BN org

.org 0x100
org:
	LD 0xFFF0, BP
	MOV BP, SP

	LD loop, R4
	LD 100, R3 // cmp to
	LD 0, R1 // counter
	LD 0x200, R2 // addr to finish

loop:
	ADD 1, R1, R1 // R1 = R1 + 1
	BNE R1, R3, R4
	STOP

----------------

.org 0x0
0x0700 0200 - BN 0x100

.org 0x100
0x8a3a fc3f - LD 0xFFF0, BP
0x957c 0700 - MOV BP, SP
0x8a08 4600 - LD loop(org+0x18), R4
0x8a06 1900 - LD 100, R3
0x8a02 0000 - LD 0, R1
0x8a04 8000 - LD 0x200, R2

loop:
0x8243 0800 - ADD 1, R1, R1
0x49c8 0800 - BNE R1, R3, R4
0x0000 0000 - STOP
