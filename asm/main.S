# For 64-bit linux
# Forth interpreter
# Made with serious help from jonesforth!
# By Kyle Neil

#instead of using explicit call instructions, we can store the addresses directly.
#this means we have to load the address of each word into rax at the end of the previous word
#also uses an extra level of indirection, called ITC
#used so that we can make our own forth words

#using %rbp (normal stack pointer) for parameter stack and %rbp for return stack

.macro NEXT #get the next forth word on the stack
	lodsq #load rsi into rax and inc rsi by 8?
	jmp *(%rax) #() makes this ITC insread of DTC
.endm

.macro PUSHRSP reg
	lea -8(%rbp), %rbp #push reg on return stack
	movq \reg, (%rbp)
.endm

.macro POPRSP reg
	mov (%rbp), \reg #pop reg off of return stack
	lea 8(%rbp), %rbp
.endm

.text
.align 8
DOCOL: 
	PUSHRSP %rsi #push %rsi on return stack
	add $8, %rax #rax points to address of DOCOL, inc to point to DUP, move to rax and jmp to it
	mov %rax, %rsi
	NEXT

.text
.globl _start

_start:
	
	cld #clears direction flag, string ops increment rsi or rdi
	mov %esp, var_s0 #save the initial data stack pointer in a forth variable???
	mov $return_stack_top, %ebp #initialize return stack
	call set_up_data_segment #sets up data segment for user-defined forth words to be executed
	
	mov $cold_start, %esi #initialize interpreter
	NEXT #run the interpreter!
	
		
	mov $60, %rax #syscall 60 is exit
	xor %rdi, %rdi #return code 0
	syscall #end of program

.section .rodata
cold_start:
	.int QUIT

#define a forth word using gnu macros
.set F_IMMED,0x80
.set F_HIDDEN,0x20 #?????
.set F_LENMASK,0x1F

.set link,0 #store the chain of links in linked list

.macro defword name, namelen, flags=0, label
.section .rodata
.align 8
.globl \label
name_\label:
	.int link
	.set link,name_\label
	.byte \flags+\namelen #flags + length byte
	.ascii "\name" #public name
	.align 8
	.globl \label
\label:
	.int DOCOL #
	#list of stuff to follow
.endm

#define a word in assembly
.macro defcode name, namelen, flags=0, label
.section .rodata
.align 8
.globl name_\label
name_\label:
	.int link
	.set link,name_\label
	.byte \flags+\namelen
	.ascii "\name"
	.align 8
	.globl \label
\label:
	.int code_\label
	.text
	.globl code_\label
	code_\label:
	.endm

defcode "DROP",4,,DROP #deletes the top item of stack
pop %rax
NEXT

defcode "SWAP",4,,SWAP #swaps the top 2 items of the stack
pop %rax
pop %rbx
push %rax
push %rbx
NEXT

defcode "DUP",3,,DUP #copies top element and pushes it on stack
mov (%rsp), %rax
push %rax
NEXT

defcode "OVER",4,,OVER #pushes 2nd element on stack
mov 8(%rsp), %rax
push %rax
NEXT

defcode "ROT",3,,ROT #pops items as a, b, c, pushes as c, b, a?
pop %rax
pop %rbx
pop %rcx
push %rax
push %rcx
push %rbx
NEXT

defcode "-ROT",4,,NROT #opposite of above?
pop %rax
pop %rbx
pop %rcx
push %rax
push %rcx
push %rbx
NEXT

defcode "2DROP",5,,TWODROP #drop two elements from stack
pop %rax
pop %rax
NEXT

defcode "2DUP",4,,TWODUP #dup two elements from stack
mov (%rsp), %rax
mov 8(%rsp), %rbx
push %rbx
push %rax
NEXT

defcode "2SWAP",5,,TWOSWAP #swaps top 2 pairs
pop %rax
pop %rbx
pop %rcx
pop %rdx
push %rbx
push %rax
push %rdx
push %rcx
NEXT

defcode "?DUP",4,,QDUP #duplicate if non-zero
movq (%rsp), %rax
test %rax, %rax
jz 1f
push %rax
1: NEXT

defcode "1+",2,,INCR #tos++
incq (%rsp)
NEXT

defcode "1-",2,,DECR #tos--
decq (%rsp)
NEXT

defcode "4+",2,,INCR4 #tos += 4
addq $4, (%rsp)
NEXT

defcode "4-",2,,DECR4 #tos -= 4
subq $4, (%rsp)
NEXT

defcode "+",1,,ADD #tos += rax
pop %rax
addq %rax, (%rsp) #CISC is great
NEXT

defcode "-",1,,SUB #tos -= rax
pop %rax
subq %rax, (%rsp)
NEXT

defcode "*",1,,MUL #rax *= rbx
pop %rax
pop %rbx
imulq %rbx, %rax
push %rax
NEXT

# we are not implementing division in asm because x64 returns qot and div in rax and rbx, and forth is easier here
# can improve on this later

defcode "/MOD",4,,DIVMOD #get remainder
xor %rdx, %rdx
pop %rbx
pop %rax
idivq %rbx
push %rdx
push %rax
NEXT

defcode "=",1,,EQU #are top two words equal?
pop %rax
pop %rbx
cmp %rbx, %rax
sete %al #sets byte to 1 if ZF == 1, 0 otherwise
movzbq %al, %rax #move al to rax, sign extend
pushq %rax
NEXT

defcode "<>",2,,NEQU #are top two words not equal?
pop %rax
pop %rbx
cmp %rbx, %rax
setne %al
movzbq %al, %rax
pushq %rax
NEXT

defcode "<",1,,LT #is x < y?
pop %rax
pop %rbx
cmp %rbx, %rax
setl %al
movzbq %al, %rax
pushq %rax
NEXT

defcode ">",1,,GT #is x > y?
pop %rax
pop %rbx
cmp %rbx, %rax
setg %al
movzbq %al, %rax
pushq %rax
NEXT

defcode "<=",2,,LE #is x <= y?
pop %rax
pop %rbx
cmp %rbx, %rax
setle %al
movzbq %al, %rax
pushq %rax
NEXT

defcode ">=",2,,GE #is x >= y?
pop %rax
pop %rbx
cmp %rbx, %rax
setge %al
movzbq %al, %rax
pushq %rax
NEXT

defcode "0=",2,,ZEQU #is tos == 0?
pop %rax
test %rax, %rax
setz %%al
movzbq %%al, %rax
pushq %rax
NEXT

defcode "0<>",3,,ZNEQU
pop %rax
test %rax, %rax
setnz %al
movzbq %al, %rax
push %rax
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
push %rax
NEXT

defcode "0>=",3,,ZGT
pop %rax
test %rax, %rax
setge %al
movzbq %al, %rax
push %rax
NEXT

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

defcode "INVERT",6,,NOT
notq (%rsp)
NEXT

defcode "EXIT",4,,EXIT #exit from function
POPRSP %rsi #pop top of return stack into rsi
NEXT

defcode "LIT",3,,LIT #preface to a literal, tells the interpreter to throw it on the stack directly instead of executing it
lodsq
push %rax
NEXT

defcode "!",1,,STORE #store 64-bit literal rbx at addr rax (lowest level of memory management!)
pop %rbx
pop %rax
mov %rax, (%rbx)
NEXT

defcode "@",1,,FETCH #fetch 64-bit literal at addr rbx, push on tos
pop %rbx
mov (%rbx), %rax
push %rax
NEXT

defcode "+!",2,,ADDSTORE #add rax to data at address rbx
pop %rbx
pop %rax
addq %rax (%rbx)
NEXT

defcode "-!",2,,SUBSTORE #opposite of above
pop %rbx
pop %rax
subq %rax, (%rbx)
NEXT

defcode "C!",2,,STOREBYTE #store a byte
pop %rbx
pop %rax
movb %al, (%rbx)
NEXT

defcode "C@",2,,FETCHBYTE
pop %rbx
xor %rax, %rax
movb (%rbx), %al
push %rax
NEXT

defcode "C@C!",4,,CCOPY #byte copy primitive
movq 8(%rsp),%rbx #get source address
movb (%rbx), %al
pop %rdi
stosb #store al at address rdi
push %rdi
incq 8(%rsp)
NEXT

defcode "CMOVE",5,,CMOVE
mov %rsi, %rdx #save rsi
pop %rcx
pop %rdi
pop %rsi
rep movsb #string copy instruction
mov %rdx, %rsi #restore rsi
NEXT

#forth has a few built-in variables
#STATE: executing code or compiling a word?
#LATEST: points to most recently defined word in dictonary
#HERE: points to next free byte of memory
#S0: stores address of parameter stack
#BASE: current base for reading and printing numbers

.macro defvar name, namelen, flags=0, label, initial=0
defcode \name,\namelen,\flags,\label
push $var_\name
NEXT
.data
.align 8
var_\name:
	.int \initial
.endm

defvar "STATE",5,,STATE
defvar "HERE",4,,HERE
defvar "LATEST",6,,LATEST,name_SYSCALL0 #must be last in dictonary for some reason
defvar "S0",2,,SZ
defvar "BASE",4,,BASE,10 #dec by default

#forth has a few built-in constants as well
#VERSION: current version
#R0: address of top of return stack
#DOCOL: pointer to DOCOL
#F_IMMED: the IMMEDIATE flag actual value
#F_HIDDEN: HIDDEN flag actual value
#F_LENMASK: length mask in the flags/len byte
#SYS_*: numeric codes for linux system calls

#include <asm/unistd.h>

.macro defconst name, namelen, flags=0, label, value #wrapper macro for defcode that pushes var
defcode \name,\namelen,\flags,\label
push $\value
NEXT
.endm

defconst "VERSION",7,,VERSION,1
defconst "R0",2,,RZ,return_stack_top
defconst "DOCOL",5,,__DOCOL,DOCOL
defconst "F_IMMED",7,,__F_IMMED,F_IMMED
defconst "F_HIDDEN",8,,__F_HIDDEN,F_HIDDEN
defconst "F_LENMASK",9,,__F_LENMASK,F_HIDDEN

defconst "SYS_EXIT",8,,SYS_EXIT,__NR_exit
defconst "SYS_OPEN",8,,SYS_OPEN,__NR_open
defconst "SYS_CLOSE",9,,SYS_CLOSE,__NR_close
defconst "SYS_READ",8,,SYS_READ,__NR_read
defconst "SYS_WRITE",9,,SYS_WRITE,__NR_write
defconst "SYS_CREAT",9,,SYS_CREAT,__NR_creat
defconst "SYS_BRK",7,,SYS_BRK,__NR_brk

defconst "O_RDONLY",8,,__O_RDONLY,0
defconst "O_WRONLY",8,,__O_WRONLY,1
defconst "O_RDWR",6,,__O_RDWR,2
defconst "O_CREAT",7,,__O_CREAT,0100
defconst "O_EXCL",6,,__O_EXCL,0200
defconst "O_TRUNC",7,,__O_TRUNC,01000
defconst "O_APPEND",8,,__O_APPEND,02000
defconst "O_NONBLOCK",10,,__O_NONBLOCK,04000

#register rbp points to return stack

defcode ">R",2,,TOR #pop tos from parameter stack and push on return stack
pop %rax
PUSHRP %rax
NEXT

defcode "R>",2,,FROMR #opposite from above
POPRSP %rax
push %rax
NEXT

defcode "RSP@",4,,RSPFETCH #fetch return stack pointer
push %rbp
NEXT

defcode "RSP!",4,,RSPSTORE #store a return stack pointer
pop %rbp
NEXT

defcode "RDROP",4,,RDROP #pop and throw away entry
addq $8, %rbp
NEXT

#linux sets up a parameter stack for us, and it is accessed through rsp
defcode "DSP@",4,,DSPFETCH
mov %rsp, %rax
push %rax
NEXT

defcode "DSP!",4,,DSPSTORE
pop %rsp
NEXT

#input and output written in assembly, even though it could be written in forth
#there is no difference in forth between reading code and reading input, part of an interpreted language
#input buffer of some size used, with a few internal variables to track progress
#uses linux read(2), and when input buffer overflows, it gets refilled (?)
#if stdin is closed, the interpreter exits! cool!






















