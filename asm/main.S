.macro NEXT //execute the next word
	mov %rsi, %rax
	add $8, %rsi
	jmp *(%rax)
.endm

.macro PUSHRSP reg //push register on return stack (actual stack)
	lea -8(%rbp), %rbp //make space for reg
	movq \reg, (%rbp) //put reg in there
.endm

.macro POPRSP reg //pop register from return stack
	mov (%rbp), \reg //get reg from rbp
	lea 8(%rbp), %rbp //delete reg space
.endm

.text
.align 8

DOCOL:
	PUSHRSP %rsi //push previous address on return stack
	addq $8, %rax //rax points to codeword, so add 8 and make rsi point to first code word
	movq %rax, %rsi
	NEXT

.text
.globl _start
_start:
	//rsi is the pointer to the next word to execute
	//set pointer to start of code
	mov %rsp, %r15 //save initial stack frame
	mov $return_stack_top, %rbp
	
	//call set_up_data_segment
	
	mov $TEST, %rsi
	NEXT

.quad 0 //pointer to previous word
.byte 4
.ascii "TEST"
.byte 0
.byte 0
.byte 0 //padding bytes to get to 8-byte boundary
TEST:
	.quad DOCOL
	.quad one
	.quad two
	.quad three

one:
	mov $1, %rbx
	NEXT

two:
	mov $2, %rbx
	NEXT

three:
	mov $60, %rax
	xor %rdi, %rdi
	syscall

.bss
	.align 4096
return_stack:
	.space 8192
return_stack_top:
