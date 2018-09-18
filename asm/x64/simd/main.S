.macro start
	rdtsc
	shl $32, %rdx
	or %rax, %rdx
	push %rdx
.endm

.macro stop
	start
	pop %rdx
	sub (%rsp), %rdx
.endm


	.global _start

	.text
_start:
	movaps (src), %xmm0
	movaps (src), %xmm1
	addps %xmm0, %xmm1
	movaps %xmm1, (scratch)
	
	mov $60, %rax
	xor %rdi, %rdi
	syscall

fill:
	ret
	



	.data
.align 16
src:	# 4 32-bit ints
	.long 2
	.long 4
	.long 8
	.long 16

	.bss
scratch: .quad 
scratch2: .quad
