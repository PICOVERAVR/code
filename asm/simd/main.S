	.global _start

	.text
_start:
	
	push $3
	push $2
	push $1
	
	call fill
	
	# call <addr> = push %rip+8,  jmp <addr>
	# ret  <num>  = TOS->%rip, pop <num> bytes off stack
	# loop <addr> = dec %rcx, jnz <addr>
	
	# enter <num> = create a stack frame with <num> bytes of space
	# leave	      = destroys stack frame
	
	# lock?
	
	#movaps (test), %xmm0
	#movaps (test), %xmm1
	#addps %xmm0, %xmm1
	#movaps %xmm1, (test)
	
	mov $60, %rax
	xor %rdi, %rdi
	syscall

fill:
	# know this stuff
	ret
	



	.data
.align 16
test:	# 4 32-bit ints
	.long 2
	.long 4
	.long 8
	.long 16

	.bss
scratch: .quad 
scratch2: .quad
