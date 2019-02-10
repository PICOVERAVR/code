| basic library code to interface with the 68901 MFP
| Note: interrupt enable is sets if the MFP will note an interrupt at all. If 0, MFP will not change state for interrupt.
| Interrupt pending is for when interrupt is recognized
| Interrupt mask register is for controlling if an interrupt is triggered.  ISR bit in interrupt pending register still set regardless.
| Interrupt in service states whether ISR is being serviced.

| TODO: byte-write not really a possiblity here...

	.text

.set MFP_UART_DATA, 0x4002F
.set MFP_TX_STS, 0x4002D
.set MFP_RX_STS, 0x4002B
.set MFP_IO_DDR, 0x40005
.set MFP_IO_GPDR, 0x40001

| reset and configure the MFP for basic operation
mfp_init:
	bset #6, (0x40017) | set vector register so interrupts occur right after end of mandatory section of EVT
	bset #3, (0x40029) | mfp: 1 start bit, 1 stop bit, async
	
	| automatic ISR bit clearing by default

	bset #2, (MFP_TX_STS) | transmitter idles high
	
	bset #0, (MFP_RX_STS) | enable rx
	bset #0, (MFP_TX_STS) | enable tx

	rts

| write a null-terminated string to output
| @param: address of string to print
| @returns: number of characters printed
mfp_write:
	move.l 4(%sp), %a0
	clr %d0
	clr %d1
1:	cmp.b (%a0), %d1 | test for null character
	beq 3f
2:	btst #7, (MFP_TX_STS) | wait until buffer is ready
	beq 2b
	move.b (%a0)+, (MFP_UART_DATA) | write byte to MFP
	addq #1, %d0
	bra 1b
3:	rts

| read a null-terminated string from input
| @param: address of string to print
| @param: character to stop at
| @returns: number of characters read (not including stop character)
mfp_read:
	move.l 4(%sp), %a0 | addr
	move.l 8(%sp), %d1 | char
	clr %d0
1:	cmp.b (%a0), %d1 | test last character written for end character
	beq 3f
2:	btst #7, (MFP_RX_STS) | wait until characters are available to read
	beq 2b
	move.b (MFP_UART_DATA), (%a0)+ | read character
	addq #1, %d0
	bra 1b
3:	rts

| read memory contents out of mfp
| @param: address to read
| @param: length of block to read
mfp_readblock:
	move.l 4(%sp), %a0 | start
	move.l 8(%sp), %a1 | len
	add.l %a1, %a0
1:	cmp.l %a0, %a1
	beq 3f
2:	btst #7, (MFP_RX_STS)
	bne 2b
	move.b (MFP_UART_DATA), (%a0)+
3:	rts

| write memory contents into mfp
| @param: address to write
| @param: length of block to write
mfp_writeblock:
	move.l 4(%sp), %a0 | start
	move.l 8(%sp), %a1 | len
	add.l %a1, %a0
1:	cmp.l %a0, %a1
	beq 3f
2:	btst #7, (MFP_TX_STS)
	bne 2b
	move.b (%a0)+, (MFP_UART_DATA)
3:	rts

| pop character off stack and write it to the MFP
| @param: byte character to write
mfp_writec:
1:	btst #7, (MFP_TX_STS)
	bne 1b
	move.b %d0, (MFP_UART_DATA)
	rts

| read a character from the MFP and pushes it on stack
| @returns: byte character read
mfp_readc:
1:	btst #7, (MFP_RX_STS)
	bne 1b
	move.b (MFP_UART_DATA), %d0
	rts

| check for MFP errors
| @returns: error bits in d0
| bit 0: frame error
| bit 1: parity error
| bit 2: overrun error
| bit 3: underrun error
mfp_errcount:
	move.b (MFP_RX_STS), %d0
	and.b #0x70, %d0
	lsr.b #4, %d0
	move.b (MFP_TX_STS), %d1
	and.b #0x40, %d1
	lsr.b #3, %d1
	or.b %d1, %d0
	rts

| set data direction
| @param: IO pin direction state
| 0 is Hi-Z input, 1 is output
mfp_setdir:
	move.b 4(%sp), (MFP_IO_DDR)
	rts

| set pin state
| @param: IO pin direction state
| 0 is off, 1 is on
mfp_setpin:
	move.b 4(%sp), (MFP_IO_GPDR)
	rts

| set timer to which mode?
| load timer counter
| count events
| waveform generation - using timer outputs to drive a speaker or something

| set timer parameters
| @param: long 0-4 (0 = timer A, 1 = timer B, etc)
| @param: (msb) timer settings, and (lsb) timer data
mfp_configtimer:
	rts

| reset timer counter
| @param: long 0-4
| @param: value to set timer to
mfp_resettimer:
	move 4(%sp), %d0
	rts

| Note: MFP uart space is from 0x20000 -> 0x2003F
| TODO: need a way to keep track of where in the buffer we should write the character

| triggers when byte is received by MFP
| @returns: last position in buffer
mfp_rx_isr:
	rte

| triggers when byte is sent by MFP
| @returns: last position in buffer
mfp_tx_isr:
	rte

