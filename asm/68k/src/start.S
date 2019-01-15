| Bootloader section of 68k device

	.section .rodata
.long SSP_PTR
.long PC
.space 0x3F8

.set SSP_PTR, 0x40000 | stack is pre-decrement
.set PC, 0x400

.set SCRATCH_SPACE, 0xFFFF

	.text
	.global _start

# TODO: add another .text section in RAM so we can execute out of it

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
	
| zero out .bss segment
	move.w scratch, %a0
	move.l #scratch+0xFFFF, %d0
1:	move.w #0x0, (%a0)+
	cmpa %d0, %a0
	bne 1b
	
	jsr uart_setup
	
	move.w (boot_text), -(%sp)
	jsr uart_write
	addq #4, %sp
	
user_start:
| switch to user mode and initialize stack
	andi #0xDFFF, %sr
	move.l #0x3FF00, %sp
	
ram_cmp_error:
	reset
1:	jmp .
	
	.data
.align 4
boot_text: .asciz "Nomadic"

	.bss
.align 4
scratch: .space SCRATCH_SPACE
