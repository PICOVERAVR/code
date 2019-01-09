|  UART interfacing code, written to work with the MC6850 ACIA
|  should be enough to load an image into RAM over UART

| Memory Map:
| 0x40000: ACIA control
| 0v40001: ACIA data

.section .text

|  Set up the ACIA on reset
|  parameters: none
|  returns: nothing
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

| TODO: uart_write never prints the null character, since it returns when null is seen
| TODO: uart_writec and readc probably don't work properly since I haven't read
| the addressing mode section of the GAS manual yet.

| write a null-terminated string to output
| parameters: address of string to print
| returns: number of characters printed
uart_write:
	move.l -4(%sp), %a0
	moveq #0, %d0
	moveq #0, %d1
1:	cmp.b (%a0), %d1 | test for null character
	beq 3f
2:	btst #1, (0x40000)
	bne 2b
	move.b (%a0)+, (0x40001) | write byte to ACIA
	addq #1, %d0
	bra 1b
3:	rts

| read a null-terminated string from input
| parameters: address of string to print, character to stop at
| returns: number of characters read (not including stop character)
uart_read:
	move.l -4(%sp), %a0
	move.l -8(%sp), %d1
	moveq #0, %d0
	moveq #0, %d1
1:	cmp.b (%a0), %d1
	beq 3f
2:	btst #0, (0x40000)
	bne 2b
	move.b (0x40001), (%a0)+
	addq #1, %d0
	bra 1b
3:	rts

| pop character off stack and write it to the ACIA
| parameters: character to write
| returns: nothing
uart_writec:
	# move.b +4(%sp), (0x40001)
	rts

| read a character from the ACIA and pushes it on stack
| returns: nothing
uart_readc:
	# move.b (0x40001), -4(%sp)
	rts

| check for ACIA errors
| parameters: none
| returns: error bits in d0
| bit 0: Framing Error
| bit 1: Overrun Error
| bit 2: Parity Error
uart_errcount:
	move.b (0x40000), %d0
	and.b #0x70, %d0
	lsr.b #4, %d0
	rts
