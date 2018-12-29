|  0x00000 -> 0x1FFFF: EEPROM
|  0x20000 -> 0x3FFFF: SRAM
|  0x40000 -> 0x40001: UART data (00 is cntl, 01 is data)

	.global main

	.section .rodata
.long SSP_PTR
.long PC
.set SSP_PTR, 0x3FFFE
.set PC, 0x400

	.text
main:
ori #0x2700, %SR | set IPL to max
reset

move.l #0xDEADBEEF, %D0
move.l %D0, (0x20000)
move.l (0x20000), %D1

cmp %D1, %D0
bne no_ram_found
jmp uart_setup

uart_setup:
bset #0, (0x40000) | reset the ACIA
bset #1, (0x40000)

bclr #0, (0x40000) | divide clock by 1
bclr #1, (0x40000)

bset #2, (0x40000) | 8N1 encoding
bclr #3, (0x40000)
bset #4, (0x40000)

bclr #5, (0x40000) | tx interrupt disabling
bclr #6, (0x40000)

bclr #7, (0x40000) | rx interrupt disabling

no_ram_found:
reset
jmp main
