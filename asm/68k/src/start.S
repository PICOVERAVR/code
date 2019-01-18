| Bootloader section of 68k device

	.section .rodata
.long SSP_PTR
.long PC
.space 0x3F8

| configs for booting 68k system
.set SSP_PTR, 0x40000 | stack is pre-decrement
.set PC, 0x400
.set config_parameters, 0b00000001
| 0: verbose bootloading
| 1: ?
| etc.

	.section boot_text, "x"
	.global _start

| TODO: make sure none of the sections are overlapping in memory (data section is overlapping... fix!)
| and also make sure start and length parameters are correct.
| TODO: add a R/W line to EEPROM and test to add self-update capabilities?
| UART code can stay where it is since it's just as fast as RAM in this board.

_start:
| test the RAM by reading and writing to all memory locations
| jump to ram_cmp_error if problems occur.
	move.l #0x20000, %a0
	move.l #0x40000, %a1
1:	move.w #0xCAFE, (%a0)+
	cmpa %a0, %a1
	bne 1b

2:	move.w -(%a0), %d0
	cmp.w #0xCAFE, %d0
	bne ram_cmp_error
	cmpa %a0, %a1
	bne 2b	
	
	move.w (splash_message), -(%sp)
	jsr uart_write
	addq #4, %sp
	
	| need to add space for andi ... to %sr to change to user mode
	move.w 8(ram_text), -(%sp) | wait for a '$' from the host to indicate app code is done being uploaded
	move.w '$', -(%sp)
	jsr uart_read
	addq #8, %sp
	
	
| to be called when all bootloader code is done and a program is in RAM
| NOTE: the code to initialize the application has to be in RAM when executed, since ROM is deselected
| in user mode.
user_start:
	|jmp #...
	|andi #0xDFFF, %sr

ram_cmp_error:
	reset
1:	jmp .
	
	.section .data
.align 4
boot_name: .asciz "Nomadic\n"
splash_message: .asciz "Bootloader initialized.\n"
.byte config_parameters

	.section ram_text, "wx"
.space 0x1FFFF
