	.section .rodata
.set RESET_SSP_PTR, 0x40000
.set RESET_PC, 0x00000400 | start point

.long RESET_SSP_PTR
.long RESET_PC
.space 0x3F8

	.text
	.global start

start:
	ori.w #0x700, %sr | set IPL to 7
        
    move.l #0x20000, %a0
    move.l #0x40000, %a1
1:  move.w #0xCAFE, (%a0)
    cmpa.l %a0, %a1 
    addq #2, %a0
    bne 1b

2:  move.w (%a0), %d0 
    cmpi.w #0xCAFE, %d0
    bne error
    cmpa %a0, %a1 
    subq #2, %a0
    bne 2b

	andi #0xD8FF, %sr | clear supervisor flag and set IPL to 0, obvious indicator that memory check is successful
	
error:
	stop #0xFFFF
