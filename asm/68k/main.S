	.global main

	.section .rodata
.long SSP_PTR
.long PC
.set SSP_PTR, 0xFFFFFFFF
.set PC, 0x400

	.text
main:
#ori 0x2700, %SR
# not handling immediates correctly!
# show .rodata, don't disassemble it
move.l $0xDEAD, %D0
move.l %D0, $0xDEAD
move.l %D0, (0x2700)
move.l (0x2700), %D1
cmp %D1, %D0
#Bcc ??
jmp no_ram_found



no_ram_found:
reset
