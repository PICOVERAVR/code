	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 13
	.globl	_main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi0:
	.cfi_def_cfa_offset 16
Lcfi1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi2:
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	subq	$24, %rsp
Lcfi3:
	.cfi_offset %rbx, -24
	movl	$60, %edi
	callq	_malloc
	movl	16(%rax), %eax
	movl	%eax, -12(%rbp)
	leaq	-24(%rbp), %rdi
	callq	_mach_timebase_info
	callq	_mach_absolute_time
	movq	%rax, %rbx
	## InlineAsm Start
	nop
	## InlineAsm End
	movl	-12(%rbp), %eax
	movl	%eax, -28(%rbp)
	## InlineAsm Start
	nop
	## InlineAsm End
	callq	_mach_absolute_time
	subq	%rbx, %rax
	movl	-24(%rbp), %ecx
	movl	-20(%rbp), %esi
	imulq	%rcx, %rax
	xorl	%edx, %edx
	divq	%rsi
	movq	%rax, %rcx
	shrq	$3, %rax
	movabsq	$2361183241434822607, %rdx ## imm = 0x20C49BA5E353F7CF
	mulq	%rdx
	shrq	$4, %rdx
	cvtsi2sdq	%rdx, %xmm0
	leaq	L_.str(%rip), %rdi
	movb	$1, %al
	movq	%rcx, %rsi
	callq	_printf
	xorl	%eax, %eax
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"Time taken was: %llu ns, %f us\n"


.subsections_via_symbols
