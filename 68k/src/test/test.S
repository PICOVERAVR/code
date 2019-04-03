	.section .rodata
.set RESET_SSP_PTR, 0x40000
.set RESET_PC, 0x00000400 | start point

.long RESET_SSP_PTR
.long RESET_PC
.space 0x3F8

.set MFP_VR, 0x40017
.set MFP_IMRA, 0x40013
.set MFP_IMRB, 0x40015
.set MFP_UART_SCR, 0x40027
.set MFP_UART_UCR, 0x40029
.set MFP_UART_RSR, 0x4002B
.set MFP_UART_TSR, 0x4002D
.set MFP_UART_DATA, 0x4002F

	.text
	.global start

| NOTE: MFP doesn't work at 16MHz.  Downclock to <=14MHz, use either 12 or 8MHz.
| Maybe do a DTACK generator, but the chip should generate its own DTACK.  Check up on this, since it's always asserted?

| baud rate should be 115200, check with bp

| TODO: fix the DTACK problem, but not by creating a seperate DTACK generator!!
| Can't use the second probe on the function generator, since it only goes to 3v at max.
| TODO: almost definitely not a hardware problem, since the MFP can toggle IO lines in response to the processor.  Check other registers.

| TODO: I shouldn't need to create a seperate DTACK generator for this chip, because it has one onboard.  Could be leading to weird UART problems.

| Things to check:
| - UART registers
| - Interrupt registers
| - Vector registers

start:
	move.b #0xFF, (0x40005) | all IO pins outputs
	move.b #0x1, (0x40001) | set I0 to high
	
	move.b #0x40, (MFP_VR) | point IVR to right after mandatory section of EVT
	move.b #0x8, (MFP_UART_UCR) | uart: 1 start bit, 1 stop bit, async
	
	move.b #0x0, (MFP_IMRA) | clear mask registers - interrupt bits are recognizable, but cannot trigger an interrupt
	move.b #0x0, (MFP_IMRB)
	
	bset #2, (MFP_UART_TSR) | tx idles high
	bset #0, (MFP_UART_TSR) | enable tx, has to be last in init routine
	
	|bset #6, (MFP_VR) | interrupt vectors point to right after end of mandatory section of EVT
	|bset #3, (MFP_UART_UCR) | uart: 1 start bit, 1 stop bit, async
	
	|bset #2, (MFP_UART_TSR) | transmitter idles high
	
	|bset #0, (MFP_UART_RSR) | enable rx
	|bset #0, (MFP_UART_TSR) | enable tx
	
print:
	| MFP Buffer Empty bit set when ready, cleared when in the process of transmitting
	| cleared by writing to UDR
	
	| check transmit underrun vs buffer empty!
	
1:	btst #7, (MFP_UART_TSR)
	beq 1b | MFP set when ready for byte transfer, Z bit cleared when ready
	move.b #'A', (MFP_UART_DATA) | 0x41
	bra print

|	clr %d1 | use as zero register
|	move #str, %a0
|1:	cmp.b (%a0), %d1 | check for null char
|	beq end
|2:	btst #7, (MFP_UART_TSR) | MFP set when ready, Z bit cleared when ready
|	beq 2b
|	move.b (%a0)+, (MFP_UART_DATA)
|	bra 1b
|end:
|	nop
|	bra print

	.data
str: .asciz "Hello, World!"

