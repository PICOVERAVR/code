| stuff to deal with the MFP
| timer set, clear

	.text

.set MFP_UART_DATA, 0x4002F
.set MFP_TX_STS, 0x4002D
.set MFP_RX_STS, 0x4002B
.set MFP_IO_DDR, 0x40005
.set MFP_IO_GPDR, 0x40001

| reset and configure the MFP for basic operation
mfp_init:
	bset #6, (0x40017) | interrupts occur right after end of mandatory section of EVT
	bset #3, (0x40029) | mfp: 1 start bit, 1 stop bit, async
	
	bset #0, (MFP_RX_STS) | mfp: enable RX
	bset #0, (MFP_TX_STS) | mfp: enable TX
	
	rts

| write a null-terminated string to output
| @param: address of string to print
| @returns: number of characters printed
mfp_write:
	move.l 4(%sp), %a0
	clr %d0
	clr %d1
1:	cmp.b -1(%a0), %d1 | test for null character
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
1:	cmp.b -1(%a0), %d1 | test last character written for end character
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
| 0 is Hi-Z input, 1 is output
mfp_setdir:
	move.b -4(%sp), (MFP_IO_DDR)
	rts

| set pin state
| 0 is off, 1 is on
mfp_setpin:
	move.b -4(%sp), (MFP_IO_GPDR)
	rts

