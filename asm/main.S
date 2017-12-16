.macro NEXT //execute the next word
	lodsq //(rsi) -> rax, rsi += 8
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
	
	mov $TEST_START_PT, %rsi
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
\label:
	.quad code_\label
	.text
	.align 8
	.globl code_\label
code_\label:
	//asm here
.endm

//start of forth words implemented in assembly for speed, and we need some forth words to write
//start of testing section, should be removed when forth system is fully self-hosting
TEST_START_PT:
	.quad TEST

defword "TEST",4,,TEST
	.quad INIT_TEST //feed initial stack and set up memory
	.quad KEY
	.quad EMIT
	.quad END_TEST //break and analyze

defcode "INIT_TEST",9,,INIT_TEST
	push $0xFF
		
	push $0x41 //'A'
		
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

defcode "C@C!",3,,CCOPY //(src dest -- src+8 dest+8)???
	movq 8(%rsp), %rbx
	movb (%rbx), %al
	pop %rdi
	mov %al, (%rdi)
	push %rdi
	incq 8(%rsp)
	NEXT

defcode "CMOVE",5,,CMOVE
	mov %rsi, %rdx
	pop %rcx
	pop %rdi
	pop %rsi
	rep movsb
	mov %rdx, %rsi
	NEXT

//variable macro to hold a few variables outside of the stack (global state)
.macro defvar name, namelen, flags=0, label, initial=0
	defcode \name, \namelen, \flags, \label
	push $var_\name
	NEXT	
	.data
	.align 8
var_\name:
	.quad \initial
.endm

defvar "STATE",5,,STATE
defvar "HERE",4,,HERE
//defvar "LATEST",6,,LATEST,name_SYSCALL0 //must be last in dictonary for some reason
defvar "S0",2,,SZ
defvar "BASE",4,,BASE

//constant macro, similar to defvar but only pushes to stack
.macro defconst name, namelen, flags=0, label, value
	defcode \name,\namelen,\flags,\label //is there a better way to do this?
	push $\value
	NEXT
.endm

defconst "VERSION",7,,VERSION,-1 //whatever the most recent git version is
defconst "R0",2,,RZ,return_stack_top //pointer to tos in memory
defconst "DOCOL",5,,__DOCOL,DOCOL
//defconst "F_IMMED",7,,__F_IMMED,F_IMMED
//defconst "F_HIDDEN",8,,__F_HIDDEN,F_HIDDEN
//defconst "F_LENMASK",9,,__F_LENMASK,F_LENMASK //will become useful once we get to compiling words

//some words to manuipulate the return stack
//note: these values must be popped before the word returns or the interpreter will crash!
defcode ">R",2,,TOR //(n -- )
	pop %rax
	PUSHRSP %rax
	NEXT

defcode "R>",2,,FROMR //( -- n)
	POPRSP %rax
	push %rax
	NEXT

//these words actually get and set the return stack pointer
defcode "RSP@",4,,RSPFETCH //( -- n)
	push %rbp
	NEXT

defcode "RSP!",4,,RSPSTORE //(n -- )
	pop %rbp
	NEXT

defcode "RDROP",5,,RDROP //( -- )
	addq $8, %rbp
	NEXT

//these words get and set the parameter stack pointer directly
defcode "DSP@",4,,DSPFETCH
	mov %rsp, %rax
	push %rax
	NEXT

defcode "DSP!",4,,DSPSTORE
	pop %rsp
	NEXT

//we're approaching a fully functional forth system here.  All the basic mechanics are in place, and all that is left is to make it user-interactive instead of a fixed program.
//this is where the assembly gets bigger than ~5 instructions.

//read a byte from stdin, meant to be used with WORD and such
defcode "KEY",3,,KEY
	call _KEY
	push %rax
	NEXT
_KEY:
	mov (currkey), %rbx //no $ indicates a memory read
	cmp (bufftop), %rbx //at end of buffer?
	jge 1f
	xor %rax, %rax
	mov (%rbx), %al //get next char, increment bufptr
	inc %rbx
	mov %rbx, (currkey) //increment currkey
	ret

1: //get input from read syscall
	xor %rax, %rax //read syscall
	xor %rdi, %rdi //use stdin
	mov %rsi, %r14 //save %rsi
	mov $buffer, %rsi
	mov %rsi, currkey //?????
	mov $BUFFER_SIZE, %rdx
	syscall
	
	test %rax, %rax //if rax <= 0, exit
	jbe 2f
	addq %rax, %rsi //buffer + rax = bufftop
	mov %rcx, bufftop
	mov %r14, %rsi //restore rsi
	jmp _KEY

2: //error / EOF, exit
	mov $60, %rax
	mov $1, %rdi //return exit code 1
	syscall
	
	.data
	.align 8
currkey:
	.quad buffer //current place
bufftop:
	.quad buffer //last valid data

//write a byte to stdout
defcode "EMIT",4,,EMIT
	pop %rax
	call _EMIT
	NEXT
_EMIT:
	mov %rsi, %r14 //save rsi again
	mov $1, %rdi
	mov %al, emit_byte
	mov $emit_byte, %rsi //write needs an address
	mov $1, %rdx
	mov $1, %rax
	syscall
	mov %r14, %rsi //restore rsi
	ret
	
	.data
emit_byte:
	.space 1 //scratch byte





.set RET_STACK_SIZE, 8192
.set BUFFER_SIZE, 4096

.bss
	.align 4096
return_stack:
	.space 8192
return_stack_top:

	.align 4096
buffer:
	.space BUFFER_SIZE

