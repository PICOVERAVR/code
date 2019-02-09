| Bootloader section of 68k device
| TODO: review all this code once it's fully written
| TODO: verify 68k memory layout.

| defined because a straight jump is illegal for some reason
.set ram_start, 0x20000

	.text
	.global _start

_start:
	or.i #0x700, %sr | set IPL to 7
	
	| test the RAM by reading and writing to all memory locations
	| jump to ram_cmp_error if problems occur.
	
	move.l #0x20000, %a0
	move.l #0x40000, %a1
1:	move.w #0xCAFE, (%a0)
	cmpa.l %a0, %a1
	addq #2, %a0
	bne 1b

2:	move.w (%a0), %d0
	cmpi.w #0xCAFE, %d0
	bne ram_cmp_error
	cmpa %a0, %a1
	subq.b #2, %a0
	bne 2b
	
	| reset and test MFP, once lib code is written
	
	| bootloader format:
	| want this to be small, not feature-packed.
	| <config byte> (lsb) <32b length> <actual memory>
	| application config byte layout: none yet
	clr %d0
	clr %d2
	jsr mfp_readc
	
	| TODO: if no UART is connected, this will hang waiting for the host to write data.
	| - set timer interrupt once, in ISR clear it and disable interrupts again
	| - have the timer just be incrementing a register
	
	| TODO: write code to update the bootloader itself
	| bootloader code can't load all 128K at once, since bootloader has to be executing from RAM when updating
	| and there needs to be a little space to pull in more code and poll the EEPROM until complete.

	| no config options to parse yet
	
	jsr mfp_readc | read a 32-bit value out of the mfp, one byte at a time
	move.b %d0, %d1 | the instruction "movep" could also be used here, but doc is sparse on how it works.
	jsr mfp_readc
	lsl.l #8, %d0
	or.l %d0, %d1
	jsr mfp_readc
	move.b #16, %d2
	lsl.l %d2, %d0
	or.l %d0, %d1
	jsr mfp_readc
	addq #8, %d2
	lsl.l %d2, %d0
	or.l %d0, %d1
	
	move.l %d0, -(%sp) | len
	move.l #0x20000, -(%sp) | start
	jsr mfp_readblock
	addq #8, %sp
	
	move.l #0x37000, %a5 | set user stack pointer to 0x3700
	move.l %a5, %usp
	andi #0xD8FF, %sr | clear supervisor flag and set IPL to 0
	jmp ram_start | jump to user program

ram_cmp_error:
	reset
	jmp .
	
	.section .data
.align 4
.byte version

