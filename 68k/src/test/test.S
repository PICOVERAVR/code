| Working bootloader for 68k device
    .section .rodata
.set RESET_SSP_PTR, 0x40000
.set RESET_PC, 0x00000400

.long RESET_SSP_PTR
.long RESET_PC
.space 0x3F8

.set MFP_VR, 0x40017
.set MFP_IMRA, 0x40013
.set MFP_IMRB, 0x40015
.set MFP_UART_SCR, 0x40027
.set MFP_UART_UCR, 0x40029
.set MFP_UART_RSR, 0x4002B
.set MFP_UART_TSR, 0x4002D
.set MFP_UART_DATA, 0x4002F

.set RAM_START, 0x20000
.set RAM_END, 0x40000
.set USP_VAL, 0x37000

	.text
	.global _start

| NOTE: loading code into RAM means that altering the IVT isn't possible right now, since we don't have a 68010 to work with

_start:
	or.i #0x700, %sr | set IPL to 7
	
	jsr mfp_init
	
	clr %d0
	clr %d2
	
    | bootloader format:
	| (LSB first)
    | <config byte> <4 byte length> <binary>
    | config byte layout: 0b0000_0SVE (1 for enabled)
    | S: jump to code in supervisor mode instead of user mode - allows for a more microcontroller-like system
    | V: verbose output through MFP
    | E: write program to EEPROM instead of RAM, has to be <128K since bootloader needs room as well.

	jsr mfp_readc | read config byte
	move.b %d0, %d3
	
1:	jsr mfp_readc
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
    or.l %d0, %d1 | 32-bit word in %d1
	
	| TODO: verified up to here
	
	move.l #RAM_START, -(%sp) | start
	
	btst #0, %d1 | word-align if not word-aligned (TODO: remove when hardware supports byte-wide memory accesses)
	beq 8f
	addq #1, %d1
8:	move.l %d1, -(%sp) | len
	jsr mfp_readblock
	addq #8, %sp

	move.l #USP_VAL, %a5
	move.l %a5, %usp
	andi #0xD8FF, %sr
	jmp (RAM_START)

mfp_readblock:
	move.l 4(%sp), %a0 | len
	move.l 8(%sp), %a1 | start
	add.l %a1, %a0 | get end addr, goes in a0
	
1:	cmp.l %a1, %a0
	beq 4f
2:	btst #7, (MFP_UART_RSR) | inline mfp_readc twice
	beq 2b
	move.b (MFP_UART_DATA), %d0
	lsl.l #8, %d0
3:	btst #7, (MFP_UART_RSR)
	beq 3b
	move.b (MFP_UART_DATA), %d0
	
	| TODO: adjust byte ordering from host, if needed
	
	move.w %d0, (%a1)+
	
	bne 1b
	
4:	rts

mfp_readc:
1:	btst #7, (MFP_UART_RSR)
	beq 1b
	move.b (MFP_UART_DATA), %d0
	rts

mfp_writec:
1:	btst #7, (MFP_UART_TSR)
	beq 1b
	move.b %d0, (MFP_UART_DATA)
	rts

mfp_init:
    move.b #0x40, (MFP_VR) | point IVR to right after EVT
    move.b #0x8, (MFP_UART_UCR) | uart: 1 start bit, 1 stop bit, async

    move.b #0x0, (MFP_IMRA) | clear mask registers, interrupts are pollable but don't trigger actual interrupt
    move.b #0x0, (MFP_IMRB)

    move.b #0x4, (MFP_UART_TSR) | idle high
    move.b #0x1, (MFP_UART_TSR) | enable tx
    
	move.b #0x1, (MFP_UART_RSR) | enable rx
	
    rts

