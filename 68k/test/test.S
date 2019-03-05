	.section .rodata
.set RESET_SSP_PTR, 0x40000
.set RESET_PC, 0x00000400 | start point

.long RESET_SSP_PTR
.long RESET_PC
.space 0x3F8

	.text
	.global start

| do a byte memory test later as well
| this project is going to be done instantly if I have to calculate branch offsets manually.
| find another way to do this.

start:
	ori.w #0x700, %sr

	move.l #0x20000, %a0
1:	move.w #0xCAFE, (%a0)
	move.w (%a0), %d0
	cmp.w #0xCAFE, %d0
	bne 6
	jmp 1b

.align 2
error:
	stop #0x0700 | set interrupt mask to 7
