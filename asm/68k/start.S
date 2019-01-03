|  Memory Map:
|  0x00000 -> 0x1FFFF: EEPROM
	|  0x0 -> 0x3FC: EVT
	|  0x1FFFF: config byte
|  0x20000 -> 0x3FFFF: SRAM
	|  0x3FFFE -> 0x3FF00: Supervisor stack (254b)
	|  0x3FEFE -> 0x3FE00: User stack (254b)
|  0x40000 -> 0x40001: UART data (00 is cntl, 01 is data)

|  will need to adjust link script when we start executing code out of RAM
|  also need to write enough startup code that gcc will work ok
|  or compile some small version of libc to go with gcc

|  find some version of libc small enough to link to this, c libs would be really helpful later on!
|  use newlib?

	.section .rodata
.long SSP_PTR
.long PC
.space 0x3F8 | 0x400 bytes for the EVT, no executable code here

.set SSP_PTR, 0x3FFFE
.set PC, 0x400

	.text
	.global init
init:
	ori #0x2700, %sr | set IPL to max
	reset
	
	move.l #0xDEADBEEF, %d0
	move.l %d0, (0x20000)
	move.l (0x20000), %d1
	
	cmp %d1, %d0
	reset
	jsr uart_setup
	jmp _start
	
_start:
	| the below instructions would crash the system in its current state
	| since EEPROM is deselected when you go out of supervisor mode
	#andi #0xDFFF, %sr | switch to user mode
	#move.l #0x3FEFE, %sp
	
	move.w (boot_text), -(%sp)
	jsr uart_write
	addq #4, %sp | recover stack space
	
	| boot the rest of the system here
	| zero out .bss segment here?
	
	move.w (boot_done), -(%sp)
	jsr uart_write
	addq #4, %sp
	


|  UART interfacing stuff
|  written to work with the MC6850 ACIA
|  should be enough to load an image into RAM over UART

|  Set up the ACIA on reset
|  parameters: none
|  returns: 0
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
	moveq #0, %d0
	rts

| write a null-terminated string to output
| parameters: address of string to print
| returns: number of characters printed
uart_write:
	move.l -4(%sp), %a0
begin:
	btst #1, (0x40000) | test for transmit bit clear
	bne begin
	moveq #0, %d0
	moveq #0, %d1
loop:
	cmp.b (%a0), %d1 | test for null character
	beq done
	move.b (%a0)+, (0x40001) | write byte to ACIA
	addq #1, %d0
	bra loop
done:
	rts

	.data
boot_text: .asciz "Booting..."
boot_done: .asciz "done."

	.bss
.space 0xFFF | 40 Kbytes for stuff
