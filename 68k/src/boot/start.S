| Bootloader for 68k device
| Currently waits for host to send code and data to load into RAM
| TODO: Future goals is to eventually fall back to executing some code out of ROM, have to have some sort of out-of-band signal to
| processor to indicate that the host is present.

| TODO: update Arduino programmer to diable SDP after writing the chips once self-update code is all ready

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
	| skip the RAM test for now...

|	move.l #ram_start, %a0
|	move.l #ram_end, %a1
|1:	move.w #0xCAFE, (%a0)
|	cmpa.l %a0, %a1
|	addq #2, %a0
|	bne 1b

|2:	move.w (%a0), %d0
|	cmpi.w #0xCAFE, %d0
|	bne ram_cmp_error
|	cmpa.l %a0, %a1
|	subq #2, %a0
|	bne 2b
	
	jsr mfp_init
	
	| bootloader format:
	| <config byte> (lsb) <32b length> <actual memory>
	| application config byte layout: 0b0000_0SVE
	| S: jump to code in supervisor mode instead of user mode - allows for a more microcontroller-like system
	| V: verbose output through MFP
	| E: write program to EEPROM instead of RAM, has to be <128K since bootloader needs room as well.

	clr %d0
	clr %d2

	jsr mfp_readc | read in config byte
	
	| some sort of ACK here?
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
	stop #0x700 | wait for either a reset or NMI, nothing to do if base RAM is broken.
	| could also cause a double bus fault and halt the processor here...

	.section .data
.align 4
.byte version

