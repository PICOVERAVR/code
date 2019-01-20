| Bootloader section of 68k device

| to use: replace with space and set to exception processing code
	.section .rodata
.long RESET_SSP_PTR
.long RESET_PC
.space 4 | BUS_ERROR
.space 4 | ADDRESS_ERROR
.space 4 | ILLEGAL_INSTRUCTION
.space 4 | ZERO_DIVIDE
.space 4 | CHK_INSTRUCTION
.space 4 | TRAPV_INSTRUCTION
.space 4 | PRIVILEGE_VIOLATION
.space 4 | TRACE
.space 4 | LINE_1010_EMULATOR
.space 4 | LINE_1111_EMULATOR
.space 4 | -
.space 4 | -
.space 4 | FORMAT_ERROR
.space 4 | UNINITIALIZED_INTERRUPT
.space 32 | -
.space 4 | SPURIOUS_INTERRUPT
.space 4 | LEVEL_1_INTERRUPT
.space 4 | LEVEL_2_INTERRUPT
.space 4 | LEVEL_3_INTERRUPT
.space 4 | LEVEL_4_INTERRUPT
.space 4 | LEVEL_5_INTERRUPT
.space 4 | LEVEL_6_INTERRUPT
.space 4 | LEVEL_7_INTERRUPT
.space 64 | TRAP vectors
.space 64 | -
.space 768 | user interrupt vectors

| configs for booting 68k system
.set RESET_SSP_PTR, 0x40000 | stack is pre-decrement
.set RESET_PC, 0x400

.set config_parameters, 0b00000001
| 0: verbose bootloading
| 1: ?

.set ram_addr, 0x20000

	.text
	.global _start

| TODO: actually check for verbose booting.
| TODO: make sure none of the sections are overlapping in memory (data section is overlapping... fix!)
| and also make sure start and length parameters are correct.
| TODO: add a R/W line to EEPROM and test to add self-update capabilities?

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
	
	move.l (splash_message), -(%sp)
	jsr uart_write
	addq #4, %sp
	
	| need to add space for andi #0xDFFF, %sr to change to user mode
	move.l #ram_addr, %d0
	addq #4, %d0
	move.l %d0, -(%sp) | wait for a '$' from the host to indicate app code is done being uploaded
	move.l #'$', -(%sp)
	jsr uart_read
	add #8, %sp

	move.l (done_message), -(%sp)
	jsr uart_write
	addq #4, %sp
	
	jmp ram_addr

ram_cmp_error:
	reset
1:	jmp .
	
	.section .data
.align 4
boot_name: .asciz "Nomadic\n"
splash_message: .asciz "Bootloader initialized.\n"
done_message: .asciz "Booting application...\n"
.byte config_parameters | bootloader configuration parameters
