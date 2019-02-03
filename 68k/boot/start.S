| Bootloader section of 68k device
| TODO: review all this code once it's fully written
| TODO: super inconsistant about the order in which I push stack arguments...

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
.space 4 | LEVEL_1_INTERRUPT | note: only 6800 peripherals are autovectored
.space 4 | LEVEL_2_INTERRUPT
.space 4 | LEVEL_3_INTERRUPT
.space 4 | LEVEL_4_INTERRUPT
.space 4 | LEVEL_5_INTERRUPT
.space 4 | LEVEL_6_INTERRUPT
.space 4 | LEVEL_7_INTERRUPT
.space 64 | TRAP vectors
.space 64 | -
.space 4 | MFP_GPIO_0
.space 4 | MFP_GPIO_1
.space 4 | MFP_GPIO_2
.space 4 |  MFP_GPIO_3
.space 4 | MFP_TIMER_D
.space 4 | MFP_TIMER_C
.space 4 | MFP_GPIO_4
.space 4 | MFP_GPIO_5
.space 4 | MFP_TIMER_B
.space 4 | MFP_UART_TXERR
.space 4 | MFP_UART_TXBUFE
.space 4 | MFP_UART_RXERR
.space 4 | MFP_UART_RXBUFF
.space 4 | MFP_TIMER_A
.space 4 | MFP_GPIO_6
.space 4 | MFP_GPIO_7
.space 704 | rest of user interrupt vectors

| configs for booting 68k system
.set RESET_SSP_PTR, 0x40000 | stack is pre-decrement
.set RESET_PC, 0x400

.set version, 0x1

.set ram_addr, 0x20000

	.text
	.global _start

| TODO: avoid using d0 and d1 and a0 and a1 because they could be trashed by subroutines
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
	jsr uart_readc
	
	| TODO: parse config options byte
	| TODO: go to app code if no response (nothing needs to be uploaded)
	
	jsr uart_readc
	move.b %d0, %d1
	jsr uart_readc
	lsl.l #8, %d0
	or.l %d0, %d1
	jsr uart_readc
	move.b #16, %d2
	lsl.l %d2, %d0
	or.l %d0, %d1
	jsr uart_readc
	addq #8, %d2
	lsl.l %d2, %d0
	or.l %d0, %d1
	
	move.l %d0, -(%sp) | len
	move.l #0x20000, -(%sp) | start
	jsr uart_readblock
	addq #8, %sp
	
	move.l #0x37000, %a5 | set user stack pointer to 0x3700, can change
	move.l %a5, %usp
	andi #0xD8FF, %sr | clear supervisor flag and set IPL to 0
	jmp ram_addr

ram_cmp_error:
	reset
	jmp .

print_if_verbose:
|	btst #0, <config addr>
	bne 1f
	jsr uart_write
	addq #4, %sp
1:	rts

	.section .data
.align 4
boot_name: .asciz "Nomadic\n"
.byte version

