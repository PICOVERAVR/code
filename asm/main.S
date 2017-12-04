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
	addq $8, %rax //rax points to codeword, so add 8 and make rsi point to first data word
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

.set link, 0 //linked list for word defns

//this is a macro to generate a forth word
//it includes a link pointer to point to the previous word declared,
//a name to look up and a length of that name, 
//and the actual code, prefixed by a DOCOL, as always

.macro defword name, namelen, flags=0, label
	.section .rodata
	.align 8
	.global name_\label
name_\label:
	.quad link //pointer to previous word
	.set link, name_\label
	.byte \flags+\namelen
	.ascii "\name"
	.align 8
	.globl \label
\label:
	.quad DOCOL
.endm

//this is a similar macro, except it is written to define words directly
//in assembly.  The code field is the same, as forth does not treat forth words
//and assembly words differently.
.macro defcode name, namelen, flags=0, label
	.section .rodata
	.align 8
	.globl name_\label
name_\label:
	.quad link
	.set link, name_\label
	.byte \flags+\namelen
	.ascii "\name"
	.align 8
	.globl \label
//note: jonesforth had a pointer to code here.
//bug hunt caused me to just put code here
\label:
	//asm here
.endm

//start of forth words implemented in assembly for speed, and we need some forth words to write
//more forth words
defcode "DROP",4,,DROP //(n -- )
	pop %rax
	NEXT

defcode "SWAP",4,,SWAP //(n1 n2 -- n2 n1)
	pop %rax
	pop %rbx
	push %rax
	push %rbx
	NEXT

defcode "DUP",3,,DUP //(n -- n n)
	mov (%rsp), %rax
	push %rax
	NEXT

defcode "OVER",4,,OVER //(n1 n2 -- n1 n2 n1)
	mov 8(%rsp), %rax
	push %rax
	NEXT

defcode "ROT",3,,ROT //(n1 n2 n3 -- n2 n3 n1)
	pop %rax
	pop %rbx
	pop %rcx
	push %rbx
	push %rax
	push %rcx
	NEXT

defcode "-ROT",4,,NROT //(n1 n2 n3 -- n3 n1 n2)
	pop %rax
	pop %rbx
	pop %rcx
	push %rax
	push %rcx
	push %rbx
	NEXT

defcode "2DROP",5,,TWODROP //(n n -- )
	pop %rax
	pop %rax
	NEXT

defcode "2DUP",4,,TWODUP //(n n -- n n n n)
	mov (%rsp), %rax
	mov 8(%rsp), %rbx
	push %rbx
	push %rax
	NEXT




//start of testing section, should be removed when forth system is fully self-hosting
defword "TEST",4,,TEST
	.quad END_TEST

defcode "END_TEST",8,,END_TEST
	mov $60, %rax
	mov $0, %rdi
	syscall

.bss
	.align 4096
return_stack:
	.space 8192
return_stack_top:
