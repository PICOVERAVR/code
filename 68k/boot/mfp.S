| basic library code to interface with the 68901 MFP
| Note: interrupt enable is sets if the MFP will note an interrupt at all. If 0, MFP will not change state for interrupt.
| Interrupt pending is for when interrupt is recognized
| Interrupt mask register is for controlling if an interrupt is triggered.  ISR bit in interrupt pending register still set regardless.
| Interrupt in service states whether ISR is being serviced.

| TODO: read the finer points of the datasheet, especially all the stuff about reading and writing the data
| Note: reading the status register after reading the data register means the status register could be referring to a different byte than the data register.
| also interrupts related to TX and RX errors exist, use them?

	.text
| MFP register addresses and functions
| Note: raw addresses, not addresses listed in datasheet
.set MFP_IO_GPDR, 0x40001
.set MFP_IO_AER, 0x40003
.set MFP_IO_DDR, 0x40005
.set MFP_IPT_IERA, 0x40007
.set MFP_IPT_IERB, 0x40009
.set MFP_IPT_IPRA, 0x4000B
.set MFP_IPT_IPRB, 0x4000D
.set MFP_IPT_ISRA, 0x4000F
.set MFP_IPT_ISRB, 0x40011
.set MFP_IPT_IMRA, 0x40013
.set MFP_IPT_IMRB, 0x40015
.set MFP_VR, 0x40017
.set MFP_TMR_TACR, 0x40019
.set MFP_TMR_TBCR, 0x4001B
.set MFP_TMR_TCDCR, 0x4001D
.set MFP_TMR_TADR, 0x4001F
.set MFP_TMR_TBDR, 0x40021
.set MFP_TMR_TCDR, 0x40023
.set MFP_TMR_TDDR, 0x40025
.set MFP_UART_SCR, 0x40027
.set MFP_UART_UCR, 0x40029
.set MFP_UART_RSR, 0x4002B
.set MFP_UART_TSR, 0x4002D
.set MFP_UART_DATA, 0x4002F

| 32-byte UART buffer should be circular, would make things easy to work with
| word index of the front of the UART buffer
.set UART_START_POS, 0x20000
.set UART_BUFFER_START, 0x20062
.set UART_BUFFER_END, 0x20064

| reset and configure the MFP for basic operation
mfp_init:
	bset #6, (MFP_VR) | set vector register so interrupt vectors point to right after end of mandatory section of EVT
	bset #3, (MFP_UART_UCR) | mfp: 1 start bit, 1 stop bit, async
	
	| automatic ISR bit clearing by default

	bset #2, (MFP_UART_TSR) | transmitter idles high
	
	bset #0, (MFP_UART_RSR) | enable rx
	bset #0, (MFP_UART_TSR) | enable tx
	
	move #0, (UART_BUFFER_START)
	move #0, (UART_BUFFER_END)
	
	rts

| write a word-aligned null-terminated string to output
| @param: address of string to print
mfp_write:
	move.l 4(%sp), %a0
	clr %d1
1:	cmp.b (%a0), %d1 | check for null char
	beq 3f
2:	btst #7, (MFP_UART_TSR)
	beq 2b
	move.w (%a0)+, %d0
	move.b %d0, (MFP_UART_DATA)
	lsr #8, %d0
	move.b %d0, (MFP_UART_DATA) | TODO: bug here- no jmp, also address registers don't have to be word-aligned.
3:	rts

| read a null-terminated string from input
| @param: address of string to print
| @param: character to stop at
mfp_read:
	move.l 4(%sp), %a0 | addr
	move.l 8(%sp), %d1 | char
1:	cmp.b (%a0), %d1 | test last character written for end character
	beq 3f
2:	btst #7, (MFP_UART_RSR) | wait until characters are available to read
	beq 2b
	move.b (MFP_UART_DATA), %d0
	lsl #8, %d0
	move.b (MFP_UART_DATA), %d0
	move.w %d0, (%a0)+
	bra 1b
3:	rts

| read memory contents out of mfp
| @param: address to read
| @param: length of block to read
mfp_readblock:
	move.l 4(%sp), %a0 | start
	move.l 8(%sp), %d1 | len
	move.l #MFP_UART_DATA, %a1
	add.l %d1, %a0 | contains stop addr
1:	cmp.l %a0, %d1
	beq 3f
2:	btst #7, (MFP_UART_RSR)
	bne 2b
	move.b (MFP_UART_DATA), %d0
	lsl #8, %d0
	move.b (MFP_UART_DATA), %d0
	move.w %d0, (%a0)+
	bra 1b
3:	rts

| write memory contents into mfp
| @param: address to write
| @param: length of block to write
mfp_writeblock:
	move.l 4(%sp), %d0 | start
	move.l 8(%sp), %d1 | len
	add.l %d1, %d0
1:	cmp.l %d0, %d1
	beq 3f
2:	btst #7, (MFP_UART_TSR)
	bne 2b
	move.w (%a0)+, %d0
	move.b %d0, (MFP_UART_DATA)
	lsr #8, %d0
	move.b %d0, (MFP_UART_DATA)
	bra 1b
3:	rts

| write d0 (byte) into MFP
| @param: byte character to write
mfp_writec:
1:	btst #7, (MFP_UART_TSR)
	bne 1b
	move.b %d0, (MFP_UART_DATA)
	rts

| read a character from the MFP into d0
| @returns: byte character read
mfp_readc:
1:	btst #7, (MFP_UART_RSR)
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
	move.b (MFP_UART_RSR), %d0
	and.b #0x70, %d0
	lsr.b #4, %d0
	move.b (MFP_UART_TSR), %d1
	and.b #0x40, %d1
	lsr.b #3, %d1
	or.b %d1, %d0
	rts

| set data direction
| @param: IO pin direction state
| 0 is Hi-Z input, 1 is output
mfp_setdir:
	move.l 4(%sp), %d0
	move.b %d0, (MFP_IO_DDR)
	rts

| set pin state
| @param: IO pin direction state
| 0 is off, 1 is on
mfp_setpin:
	move.l 4(%sp), %d0
	move.b %d0, (MFP_IO_DDR)
	rts

| set timer to which mode?
| load timer counter
| count events

| set timer parameters
| @param: long 0-4 (0 = timer A, 1 = timer B, etc)
| @param: (msb) timer settings, and (lsb) timer data
mfp_configtimer:
	rts

| reset timer counter
| @param: long 0-4
| @param: value to set timer to
mfp_resettimer:
	rts

| Note: MFP uart space is from 0x20000 -> 0x2003F
| configured for auto-clearing of correct ISR bit

| triggers when byte is received by MFP
mfp_rx_isr:
	move.l #UART_START_POS, %a0
	| move.b UART_BUFFER_POS, %d1
	
	| move.b (MFP_UART_DATA), %d0 | load in data
	| move.b %d0, (0,%a0,%d1) | move byte to current position in buffer, using d1 is indirect
	| addq #1, (UART_BUFFER_POS) | increment buffer counter
	rte

| triggers when byte is sent by MFP
mfp_tx_isr:

	| TODO: move
	
	rte

