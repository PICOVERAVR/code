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
//start of testing section, should be removed when forth system is fully self-hosting
defword "TEST",4,,TEST
	.quad INIT_TEST //feed initial values
	.quad END_TEST

defcode "INIT_TEST",9,,INIT_TEST
	mov $0xDEADBEEFCAFE, %rax
	push %rax //no pushing 64 bit literals directly...?
	
	//allocate some memory to test quad and byte load and store
	
	NEXT

defcode "END_TEST",8,,END_TEST
	
	//break here when debugging
	
	mov $60, %rax
	mov $0, %rdi
	syscall

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

defcode "2SWAP",5,,TWOSWAP //(n1 n2 n3 n4 -- n3 n4 n1 n2)
	pop %rax
	pop %rbx
	pop %rcx
	pop %rdx
	push %rbx
	push %rax
	push %rdx
	push %rcx
	NEXT

defcode "?DUP",4,,QDUP //(n -- n n) if non-zero
	movq (%rsp), %rax
	test %rax, %rax
	jz 1f
	push %rax
1:	NEXT

defcode "1+",2,,INCR //(n -- n+1)
	incq (%rsp)
	NEXT

defcode "1-",2,,DECR//(n -- n-1)
	decq (%rsp)
	NEXT

defcode "4+",2,,INCR4//(n -- n+4)
	addq $4, (%rsp)
	NEXT

defcode "4-",2,,DECR4//(n -- n-4)
	subq $4, (%rsp)
	NEXT

//going to throw in INCR8 and DECR8 because we're using 8-byte pointers and this is a 64-bit system
defcode "8+",2,,INCR8 //(n -- n+8)
	addq $8, (%rsp)
	NEXT

defcode "8-",2,,DECR8 //(n -- n-8)
	subq $8, (%rsp)
	NEXT

defcode "+",1,,ADD //(n1 n2 -- n1 + n2)
	pop %rax
	addq %rax, (%rsp)
	NEXT

defcode "-",1,,SUB //(n1 n2 -- n1 - n2)
	pop %rax
	subq %rax, (%rsp)
	NEXT

defcode "*",1,,MUL //(n1 n2 -- n1 * n2)
	pop %rax
	pop %rbx
	imulq %rbx, %rax
	push %rax
	NEXT

defcode "/MOD",4,,DIVMOD //basic division that pushes quotient and remainder on the stack, other versions in forth
	xor %rdx, %rdx
	pop %rbx
	pop %rax
	idivq %rbx
	push %rdx
	push %rax
	NEXT

//here, a 1 is "TRUE" and a 0 is "FALSE"
//all of the following abide by (n1 n2 -- f) depending on condition
defcode "=",1,,EQU
	pop %rax
	pop %rbx
	cmp %rax, %rbx
	sete %al //set al to 1 if condition == 1
	movzbq %al, %rax //extend to 64-bit register
	pushq %rax
	NEXT

defcode "<>",2,,NEQU
	pop %rax
	pop %rbx
	cmp %rbx, %rax
	setne %al
	movzbq %al, %rax
	pushq %rax
	NEXT

defcode "<",1,,LT
	pop %rax
	pop %rbx
	cmp %rax, %rbx
	setl %al
	movzbq %al, %rax
	pushq %rax
	NEXT

defcode ">",1,,GT
	pop %rax
	pop %rbx
	cmp %rax, %rbx
	setg %al
	movzbq %al, %rax
	pushq %rax
	NEXT

defcode "<=",2,,LE
	pop %rax
	pop %rbx
	cmp %rax, %rbx
	setle %al
	movzbq %al, %rax
	pushq %rax
	NEXT

defcode ">=",2,,GE
	pop %rax
	pop %rbx
	cmp %rax, %rbx
	setge %al
	movzbq %al, %rax
	pushq %rax
	NEXT

//zero test words abide by (n -- f)
defcode "0=",2,,ZEQU
	pop %rax
	test %rax, %rax
	setz %al
	movzbq %al, %rax
	pushq %rax
	NEXT

defcode "0<>",3,,ZNEQU
	pop %rax
	test %rax, %rax
	setne %al
	movzbq %al, %rax
	pushq %rax
	NEXT

defcode "0<",2,,ZLT
	pop %rax
	test %rax, %rax
	setl %al
	movzbq %al, %rax
	pushq %rax
	NEXT

defcode "0>",2,,ZGT
	pop %rax
	test %rax, %rax
	setg %al
	movzbq %al, %rax
	pushq %rax
	NEXT

defcode "0<=",3,,ZLE
	pop %rax
	test %rax, %rax
	setle %al
	movzbq %al, %rax
	pushq %rax
	NEXT

defcode "0>=",3,,ZGE
	pop %rax
	test %rax, %rax
	setge %al
	movzbq %al, %rax
	pushq %rax
	NEXT

//finally at the bitwise ops
defcode "AND",3,,AND
	pop %rax
	andq %rax, (%rsp)
	NEXT

defcode "OR",2,,OR
	pop %rax
	orq %rax, (%rsp)
	NEXT

defcode "XOR",3,,XOR
	pop %rax
	xorq %rax, (%rsp)
	NEXT

defcode "INVERT",6,,INVERT
	notq (%rsp)
	NEXT

//back to forth operations
defcode "EXIT",4,,EXIT
	POPRSP %rsi //pop return stack into rsi
	NEXT

defcode "LIT",3,,LIT //prepend before a literal number.  This pushes the number on the stack instead of trying to execute it.
	mov %rsi, %rax
	add $8, %rsi //same as NEXT but no jmp *(%rax)
	push (%rax)
	NEXT

//memory read and write
defcode "!",1,,STORE //(addr data -- )
	pop %rbx
	pop %rax
	mov %rax, (%rbx)
	NEXT

defcode "@",1,,FETCH //(addr -- )
	pop %rbx
	mov (%rbx), %rax
	push %rax
	NEXT

//adds a specified amount to a memory location
defcode "+!",2,,ADDSTORE //(addr add -- )
	pop %rbx
	pop %rax
	addq %rax, (%rbx)
	NEXT

defcode "-!",2,,SUBSTORE
	pop %rbx
	pop %rax
	subq %rax, (%rbx)
	NEXT

//read and write a byte
defcode "C!",2,,STOREBYTE //(addr byte -- )
	pop %rbx
	pop %rax
	movb %al, (%rbx)
	NEXT

defcode "C@",2,,FETCHBYTE //(addr -- byte)
	pop %rbx
	xor %rax, %rax //clear upper part of rax
	movb (%rbx), %al
	push %rax
	NEXT

//add block copy



.bss
	.align 4096
return_stack:
	.space 8192
return_stack_top:
