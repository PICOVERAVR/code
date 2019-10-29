	.text
	.global _start

_start:
	nop
	| getting here as user, so some things are already set up
	| init .bss
	| call main
