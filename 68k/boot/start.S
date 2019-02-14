| Bootloader section of 68k device
| TODO: verify this by looking up each instruction in the manual and verifying that the output is correct.
| TODO: verify 68k memory layout.

| TODO: adjust memory map to be above user stack pointer - application can't trash memory used by UART or kernel possibly.

| defined because a straight jump is illegal for some reason
.set ram_start, 0x20000
.set ram_end, 0x40000
| what to set the user stack pointer to
.set user_stack_pointer, 0x37000

	.text
	.global _start

_start:
	or.i #0x700, %sr | set IPL to 7
	
	| test the RAM by reading and writing to all memory locations
	| jump to ram_cmp_error if problems occur.
	
	clr %d0

	move.l #ram_start, %a0
	move.l #ram_end, %a1
1:	move.w #0xCAFE, (%a0)
	cmpa.l %a0, %a1
	addq #2, %a0
	bne 1b

2:	move.w (%a0), %d0
	cmpi.w #0xCAFE, %d0
	bne ram_cmp_error
	cmpa %a0, %a1
	subq #2, %a0
	bne 2b
	
	jsr mfp_init
	
	| bootloader format:
	| <config byte> (lsb) <32b length> <actual memory>
	| application config byte layout: 0b0000_00VE
	| E: write program to EEPROM instead of RAM
	| V: verbose output

	clr %d0
	clr %d2

	jsr mfp_readc
	
	| TODO: write code to update the bootloader itself or load app into ROM
	| this is going to be complicated...

	| no config options to parse yet
	
	jsr mfp_readc | read a 32-bit value out of the mfp, one byte at a time
	move.b %d0, %d1 
	jsr mfp_readc
	lsl.l #8, %d0
	or.l %d0, %d1
	jsr mfp_readc
	moveq #16, %d2
	lsl.l %d2, %d0
	or.l %d0, %d1
	jsr mfp_readc
	addq #8, %d2
	lsl.l %d2, %d0
	or.l %d0, %d1
	
	move.l %d0, -(%sp) | len
	move.l #ram_start, -(%sp) | start
	jsr mfp_readblock
	addq #8, %sp
	
	move.l #user_stack_pointer, %a5
	move.l %a5, %usp
	andi #0xD8FF, %sr | clear supervisor flag and set IPL to 0
	jmp ram_start | jump to user program

ram_cmp_error:
	stop #0x700 | set IPL to max

	.section .data
.align 4
.byte version

