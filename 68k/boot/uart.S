|  UART interfacing code, written to work with the MC6850 ACIA
|  should be enough to load an image into RAM over UART

.text
|  Set up the ACIA on reset
uart_setup:
	bset #0, (0x40000) | reset the ACIA
	bset #1, (0x40000)
	
	bclr #0, (0x40000) | pull out of reset, divide clock by 1
	bclr #1, (0x40000)
	
	bset #2, (0x40000) | 8N1 encoding
	bclr #3, (0x40000)
	bset #4, (0x40000)
	
	bclr #5, (0x40000) | tx interrupt disable
	bclr #6, (0x40000)
	
	bclr #7, (0x40000) | rx interrupt disable
	rts

| write a null-terminated string to output
| @param: address of string to print
| @returns: number of characters printed
uart_write:
	move.l 4(%sp), %a0
	clr %d0
	clr %d1
1:	cmp.b -1(%a0), %d1 | test for null character
	beq 3f
2:	btst #1, (0x40000) | wait until buffer is empty
	bne 2b
	move.b (%a0)+, (0x40001) | write byte to ACIA
	addq #1, %d0
	bra 1b
3:	rts

| read a null-terminated string from input
| @param: address of string to print
| @param: character to stop at
| @returns: number of characters read (not including stop character)
uart_read:
	move.l 4(%sp), %a0 | addr
	move.l 8(%sp), %d1 | char
	clr %d0
1:	cmp.b -1(%a0), %d1 | test last character written for end character
	beq 3f
2:	btst #0, (0x40000) | wait until characters are available to read
	bne 2b
	move.b (0x40001), (%a0)+ | read character
	addq #1, %d0
	bra 1b
3:	rts

| read memory contents out of UART
| @param: address to read
| @param: length of block to read
uart_readblock:
	move.l 4(%sp), %a0 | start
	move.l 8(%sp), %a1 | len
	add.l %a1, %a0
1:	cmp.l %a0, %a1
	beq 3f
2:	btst #0, (0x40000)
	bne 2b
	move.b (0x40001), (%a0)+
3:	rts

| write memory contents into UART
| @param: address to write
| @param: length of block to write
uart_writeblock:
	move.l 4(%sp), %a0 | start
	move.l 8(%sp), %a1 | len
	add.l %a1, %a0
1:	cmp.l %a0, %a1
	beq 3f
2:	btst #1, (0x40000)
	bne 2b
	move.b (%a0)+, (0x40001)
3:	rts

| NOTE: both uart_writec and uart_readc are non-blocking!

| pop character off stack and write it to the ACIA
| @param: character to write
uart_writec:
	move.b +4(%sp), (0x40001)
	rts

| read a character from the ACIA and pushes it on stack
uart_readc:
	move.b (0x40001), -4(%sp)
	rts

| check for ACIA errors
| @returns: error bits in d0
| bit 0: Framing Error
| bit 1: Overrun Error
| bit 2: Parity Error
uart_errcount:
	move.b (0x40000), %d0
	and.b #0x70, %d0
	lsr.b #4, %d0
	rts
