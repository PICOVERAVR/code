.text
.global main

main:
	addi	sp, sp, -16
	sd	ra, 8(sp)
	sd	s0, 0(sp) # save return address and frame pointer
	addi	s0, sp, 16
	
	lui 	a5, %hi(msg)
	addi 	a0, a5, %lo(msg)
	call 	puts
	
	li 	a5, 0
	mv	a0, a5
	
	ld 	ra, 8(sp)
	ld	s0, 0(sp)
	addi	sp, sp, 16
	jr	ra

msg:
	.string "Assembly!\n"
