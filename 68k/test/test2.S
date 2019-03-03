	.section .rodata
.long RESET_SSP_PTR
.long RESET_PC
.space 0x3F8

.set RESET_SSP_PTR, 0x40000 | stack is pre-decrement
.set RESET_PC, 0x400

.set RAM_START, 0x20000

	.text
	.global test_start

| a bigger test once the first test is confirmed working.
test_start:
	| check RAM
	| load an infinite loop into RAM
	| execute it
	
	| use a dbcc here...

ram_load:
	move.w (0xFF000000), %d0
	move.b (0x1), %d0
	move.b (0x2), %d0
	jmp #RAM_START | can't have a "jmp ram_load" as that will point into ROM
	| not sure if jump address is correct
ram_load_end:
