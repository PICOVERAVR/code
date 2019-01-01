|  Memory Map:
|  0x00000 -> 0x1FFFF: EEPROM
	|  0x0 -> 0x3FC: EVT
	|  0x1FFFF: config byte
|  0x20000 -> 0x3FFFF: SRAM
	|  0x3FFFE -> 0x3FF00: Supervisor stack (254b)
	|  0x3FEFE -> 0x3FE00: User stack (254b)
|  0x40000 -> 0x40001: UART data (00 is cntl, 01 is data)

|  TODO: write stuff to zero out .bss segment, required for C programs
|  will need to adjust link script when we start executing code out of RAM
|  also need to write enough startup code that gcc will work ok
|  or compile some small version of libc to go with gcc

	.section .rodata
.long SSP_PTR
.long PC
.space 0x3F8 | 0x400 bytes for the EVT, no executable code here

.set SSP_PTR, 0x3FFFE
.set PC, 0x400

	.text
	.global init
init:
	ori #0x2700, %SR | set IPL to max
	reset
	
	move.l #0xDEADBEEF, %D0
	move.l %D0, (0x20000)
	move.l (0x20000), %D1
	
	cmp %D1, %D0
	reset
	jsr uart_setup
	jmp _start
	
_start:
	andi #0xDFFF, %SR | switch to user mode
	move.l #0x3FEFE, %A7 | set up user stack
	| (user mode code starts here)




| UART interfacing stuff
| written to work with the MC6850 ACIA
uart_setup:
	bset #0, (0x40000) | reset the ACIA
	bset #1, (0x40000)
	
	bclr #0, (0x40000) | pull out of reset, divide clock by 1
	bclr #1, (0x40000)
	
	bset #2, (0x40000) | 8N1 encoding
	bclr #3, (0x40000)
	bset #4, (0x40000)
	
	bclr #5, (0x40000) | tx interrupt disable
	bclr #6, (0x40000)
	
	bclr #7, (0x40000) | rx interrupt disable
	rts

	.data | for future use...
.ascii "Booting..."
.ascii "done."

	.bss
.space 0xFFF | 40 Kbytes for stuff
