# For 64-bit linux

	.bss
.lcomm buf, 64 #input buffer


	.global _start

	.text
intro:
	.asciz "KForth v0.1, by Kyle Neil. 11/17\n"

.macro NEXT
	mov $0xFF1, %rax
.endm

DUP: #native word, (n -- n n)
#not a macro because this has to be called and stuff
	mov (%rsp), %rax
	push %rax

_start:
	mov $1, %rax #syscall 1 is write
	mov $1, %rdi #1 is stdout
	mov $intro, %rsi #give syscall a message
	mov $33, %rdx #number of bytes
	syscall
	
	mov $0, %rax #read syscall
	mov $0, %rdi #stdin?
	mov $buf, %rsi #input buffer
	mov $63, %rdx #+1 for null byte?
	syscall
	
	mov %rax, %r12 #save return value as length of input
	
	NEXT
	
		
	mov $60, %rax #syscall 60 is exit
	xor %rdi, %rdi #return code 0
	syscall

