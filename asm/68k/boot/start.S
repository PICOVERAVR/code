| Bootloader section of 68k device
| TODO: review all this code once it's fully written

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

.set ram_addr, 0x20000

	.text
	.global _start

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
	
	move.l splash_message, -(%sp)
	jsr print_if_verbose
	
	| bootloader format:
	| <8b><8b><8b><8b>(lsb);<actual memory>

	| TODO: read in longword for length of memory to write (bin, not ascii!)
	| TODO: read in a block of memory

	move.l %d0, %d7 | save number of bytes read from host

	move.l done_message, -(%sp)
	jsr print_if_verbose
	addq #4, %sp

	andi #0xDFFF, %sr
	jmp ram_addr

ram_cmp_error:
	reset
	jmp .

| print if config_parameters[0] is set
| @param: addr of string to print
| @returns: uart_write(address of string to print)
print_if_verbose:
	btst #0, config_parameters
	bne 1f
	jsr uart_write
	addq #4, %sp
1:	rts

	.section .data
.align 4
boot_name: .asciz "Nomadic\n"
splash_message: .asciz "Bootloader initialized.\n"
done_message: .asciz "Booting application...\n"
.byte config_parameters | bootloader configuration parameters

