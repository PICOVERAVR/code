| Bootloader section of 68k device
| TODO: review all this code once it's fully written

| make rom/mfp priviliged - safer, slower
| traditional OS vs unikernel approach

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
	| <config>(lsb)<8b><8b><8b><8b><actual memory>
	| application config byte layout:
	| (msb)????_????
	
	clr %d0
	clr %d2
	jsr mfp_readc
	
	| no config options to parse yet
	| TODO: go to app code if no response (nothing needs to be uploaded)
	
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
	
	move.l #0x37000, %a5 | set user stack pointer to 0x3700, can change
	move.l %a5, %usp
	andi #0xD8FF, %sr | clear supervisor flag and set IPL to 0
	jmp ram_addr

ram_cmp_error:
	reset
	jmp .
	
	.section .data
.align 4
.byte version

