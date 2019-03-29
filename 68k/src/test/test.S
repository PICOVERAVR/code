	.section .rodata
.set RESET_SSP_PTR, 0x40000
.set RESET_PC, 0x00000400 | start point

.long RESET_SSP_PTR
.long RESET_PC
.space 0x3F8

.set MFP_VR, 0x40017
.set MFP_UART_SCR, 0x40027
.set MFP_UART_UCR, 0x40029
.set MFP_UART_RSR, 0x4002B
.set MFP_UART_TSR, 0x4002D
.set MFP_UART_DATA, 0x4002F

	.text
	.global start

| NOTE: MFP doesn't work at 16MHz.  Either implement a DTACK generator circuit or (bad) downclock to <=14MHz
| baud rate should be 115200, check with bp

| TODO: convert this to move a single byte to the MFP instead of all of these bit ops
| TODO: set the MFP UART registers anyways

start:
	move.b #0xFF, (0x40005) | all IO pins outputs
	
	bset #6, (MFP_VR) | interrupt vectors point to right after end of mandatory section of EVT
	bset #3, (MFP_UART_UCR) | uart: 1 start bit, 1 stop bit, async
	bset #7, (MFP_UART_UCR) | clock is divided by 16
	
	bset #2, (MFP_UART_TSR) | transmitter idles high
	
	bset #0, (MFP_UART_RSR) | enable rx
	bset #0, (MFP_UART_TSR) | enable tx
	
print:
	move.l #str, %a0
	clr %d1 | use as zero register
1:	cmp.b (%a0), %d1 | check for null char
	beq end
2:	btst #7, (MFP_UART_TSR) | MFP set when ready, Z bit cleared when ready
	beq 2b
	move.b (%a0)+, (MFP_UART_DATA)
	bra 1b
end:
	stop #0x700

	.data
str: .asciz "Hello, World!"

