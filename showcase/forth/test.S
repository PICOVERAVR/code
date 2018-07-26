	.global main

	.text
main:
	mov $96, %rdi
	call putchar
	ret

msg:
	.asciz "Hello, world"
