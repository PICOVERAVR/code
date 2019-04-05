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

start:
	move.b #0xFF, (0x40005) | all IO pins outputs
	move.b #0x1, (0x40001) | set I0 to high
	
	move.b #0x40, (MFP_VR) | point IVR to right after mandatory section of EVT
	move.b #0x8, (MFP_UART_UCR) | uart: 1 start bit, 1 stop bit, async
	
	move.b #0x0, (MFP_IMRA) | clear mask registers - interrupt bits are recognizable, but cannot trigger an interrupt
	move.b #0x0, (MFP_IMRB)
	
	move.b #0x4, (MFP_UART_TSR) | idle high
	move.b #0x1, (MFP_UART_TSR) | enable tx
	
|	move.b #0x1, (MFP_UART_RSR)
|	read stuff out with the Buffer Full bit (7)
| 	eventually check for read / write errors in both registers!

print:
	| MFP Buffer Empty bit set when ready, cleared when in the process of transmitting
	
|1:	btst #7, (MFP_UART_TSR)
|	beq 1b | MFP set when ready for byte transfer, Z bit cleared when ready
|	move.b #'h', (MFP_UART_DATA) | 0x41
|1:	btst #7, (MFP_UART_TSR)
|	beq 1b
|	move.b #'i', (MFP_UART_DATA)
|1:	btst #7, (MFP_UART_TSR)
|	beq 1b
|	move.b #'\n', (MFP_UART_DATA)
|	bra print

	| a moveq probably works too since that is also encoded into the instruction
	| TODO possibilities:
	| - hardware is not being selected properly on a byte memory access
	| - software pointer stuff is wrong (unlikely)

	| check byte selection stuff (LDS, UDS)
	|  move a word at a time instead of a byte at a time and see if that works
	|  will also tell me if the wrong byte is getting sent over the wire
	|  check the LDS and UDS signals for cold solder joints
	| run program with %d0 cleared and see what happens
	| EEPROM write isn't an issue because if EEPROMs are written to with SDP on they are inaccessible for ~300us, which would break stuff

	clr %d0
	move.b (str), %d0

1:	btst #7, (MFP_UART_TSR)
	beq 1b
	move.b %d0, (MFP_UART_DATA)
	
2:	btst #7, (MFP_UART_TSR)
	beq 2b
	move.b #'W', (MFP_UART_DATA)

	bra print

|6:	move.l #str, %a0

|1:	move.b (%a0)+, %d0
|	beq 3f
|2:	btst #7, (MFP_UART_TSR)
|	beq 2b
|	move.b %d0, (MFP_UART_DATA)
|	bra 6b
	
|3:	stop #0x700

	.data
str: .asciz "hello\n"
