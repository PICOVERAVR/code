|  0x00000 -> 0x1FFFF: EEPROM
	|  0x0 -> 0x400: EVT
|  0x20000 -> 0x3FFFF: SRAM
	|  0x3FFFE -> 0x3FF00: Supervisor stack (254b)
	|  0x3FEFE -> 0x3FE00: User stack (254b)
|  0x40000 -> 0x40001: UART data (00 is cntl, 01 is data)

|  will need to adjust link script when we start executing code out of RAM
|  NOTE: we cannot actually load anything into RAM at assemble time.  

	.section .rodata
.long SSP_PTR
.long PC
.space 0x3F8 | 0x400 bytes for the EVT, no executable code here

.set SSP_PTR, 0x40000 | stack is pre-decrement
.set PC, 0x400

	.text
	.global _start
_start:
	ori #0x2700, %sr | set IPL to max
	reset
	
test_fill:
	move.l #0x20000, %a0 | start address
	move.l #0x40000, %a1 | end address
	move.w #0xCAFE, (%a0)+
	cmpa %a0, %a1
	bra test_fill

test_read:
	move.w -(%a0), %d0
	cmp.w #0xCAFE, %d0
	bne ram_cmp_error
	bra test_read
	
	
	
	| zero out .bss segment
	move.w scratch, %a0
	move.l #scratch+0xFFFF, %d0
bss_zero_loop:
	move.w #0x0, (%a0)+
	cmpa %d0, %a0
	bra bss_zero_loop	
	
	jsr uart_setup
	
	jmp user_start
	
user_start:
	| the below instructions would crash the system in its current state
	| since EEPROM is deselected when you go out of supervisor mode
	#andi #0xDFFF, %sr | switch to user mode
	#move.l #0x3FF00, %sp
	
	move.w (boot_text), -(%sp)
	jsr uart_write
	addq #4, %sp | recover stack space
	
	| boot the rest of the system here
	
	move.w (boot_done), -(%sp)
	jsr uart_write
	addq #4, %sp
	
ram_cmp_error:
hang: jmp hang
	
	.data
boot_text: .asciz "Booting..."
boot_done: .asciz "done."

	.bss
.align 4
scratch: .space 0xFFFF | 64Kbytes for scratch memory
