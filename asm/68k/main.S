	.global main

	.section .rodata
.long SSP_PTR
.long PC
.set SSP_PTR, 0x2FFFF
.set PC, 0x400

	.text
| src -> dest
main:
ori #0x2700, SR | set IPL to max
reset | only asserts ~RESET signal, doesn't reset processor
move.l #0xDEADBEEF, %D0 | easiest memory test ever
move.l %D0, (0x20000)
move.l (0x20000), %D1
cmp %D1, %D0
bne no_ram_found
jmp setup

no_ram_found:
reset
jmp main

setup:
nop
