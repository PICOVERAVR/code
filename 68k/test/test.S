	.section .rodata
.long RESET_SSP_PTR
.long RESET_PC
.space 0x3FC

.set RESET_SSP_PTR, 0x40000 | stack is pre-decrement
.set RESET_PC, 0x400

	.text
	.global test_start

| obvious memory access pattern to test the 68000
test_start:
	move.b (0x10000), %d0
	move.b (0x20000), %d0
	move.b (0x30000), %d0
	move.b (0x40000), %d0
	move.b (0x50000), %d0
	move.b (0x60000), %d0
	move.b (0x70000), %d0
	move.b (0x80000), %d0
	move.b (0x90000), %d0
	move.b (0xA0000), %d0
	move.b (0xB0000), %d0
	move.b (0xC0000), %d0
	move.b (0xD0000), %d0
	move.b (0xE0000), %d0
	move.b (0xF0000), %d0
	move.b (0x1), %d0
	bra test_start
