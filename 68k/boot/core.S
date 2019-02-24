| Core lib and kernel stuff that should be helpful for application programs...
| this is going to be smaller than any kind of actual *utils library
| and worse

| Good News! Address registers can be odd, only the stack pointer has to be even.  With byte ops, odd addresses don't generate exceptions!

.set ram_function, 0x3FC40

.text

| generic exception handler for unrecoverable system events
bad_exception:
	move.l #0x20100, %sp | reset possibly corrupted stack pointer
	or.i #0x700, %sr | disable interrupts
	reset | try to bring the MFP back online - also clears interrupt sources
    move.l system_error_message, %a0 | code copied from mfp_write.
    clr %d0
    clr %d1
1:  cmp.b (%a0), %d1 | test for null character
    beq 3f
2:  btst #7, (0x4002D) | wait until buffer is ready
    beq 2b
    move.b (%a0)+, (MFP_UART_DATA) | write byte to MFP
    addq #1, %d0
    bra 1b
3:	stop #0x700

| incomplete trap handler
trap_handler:
	move.l 4(%sp), %d0
	movem %d0-%d2/%a0-%a2, -(%sp)
	movem (%sp)+, %d0-%d2/%a0-%a2
	rte

| xor all words in a block, returning a checksum
| @param: length of block - 1
| @param: start address
| @returns: checksum
checksum:
	move.l %d2, -(%sp) | save d2
	move.l 4(%sp), %d1 | len
	move.l 8(%sp), %a0 | addr
	clr %d0 | running checksum
1:	move.w (%a0), %d2
	eor %d2, %d0
	dbf %d1, 1b
	move.l (%sp)+, %d2 | restore d2
	rts

| TODO: finish
| itoa, implemented in assembly
| all numbers are considered unsigned, printed in hex
| @param: number to convert to int
| @param: space to write int to (max space needed is 8 chars for hex)
asm_itoa:
	move.l %d2, -(%sp) | save d2
	move 4(%sp), %a0 | space
	move 8(%sp), %d1 | num

1:	move.l %d1, %d2
	andi.b #0x0F, %d2
	cmpi.b #0xA, %d2 | if greater than 2, add from 'A', not '0'
	bgt 2f
	add #0x30, %d2 | add '0'
	bra 3f
2:	add #0x41, %d2 | add 'A'
3:	| move.b %d2, ??? | write to next byte
	
	| add a null byte
	move.l (%sp)+, %d2 | restore d2
	rts

| software delay subroutine
| ((ms * 1000) / 22) loops required
| @param: ms to delay for
delay:
	move.l 4(%sp), %d0
	mulu.w #1000, %d0 | convert ms -> us
	move.w %d0, %d1 | move into seperate register to avoid loading in remainder?
	divu.w #22, %d1 | divide by loop execution time
	move.w %d1, %d0 | move quotient into d0
	clr %d1

1:	addq.l #1, %d1 | 8 cc
	cmp.l %d1, %d0 | 6 cc
	beq.b 1b | 8 cc when not taken
	| 22 cc total
	rts

| EEPROM writing works, since you need to de-assert CS every time you write a byte and you have to wait 200us (way longer than 68k instruction fetches) in order to write a page
| SDP needs to be disabled since the SDP enable sequence is part of the page-write sequence, as well as the fact that the SDP enable sequence would be written to neither chip
| since it has both odd and even addresses.

| TODO: check the heck out of this against the EEPROM write spec

| write a 128-byte page of memory to one of two EEPROM chips, blocking until the write is complete.
| @param: address of block to write (word-aligned)
| @param: EEPROM address to write block to (128-byte aligned)
eeprom_write_page:

	.set ram_prog_size, ewp_ram_prog_end-ewp_ram_prog
	moveq #ram_prog_size, %d0 | probably less than 255 bytes
	
	move.l #ewp_ram_prog, %a0 | load EEPROM write program into RAM, since EEPROM memory will be unavailable during write.
	move.l #0x3FC40, %a1
1:	cmpi #0, %d0
	beq 2f
	move.b (%a0)+, (%a1)+
	subq #1, %d0
	bra 1b

2:	moveq #128, %d0
	clr %d1
	move.l 4(%sp), %a0 | memory address
	move.l 8(%sp), %a1 | EEPROM address

	jmp ram_function | start of kernel memory and where we dumped the RAM function

3:	rts

| program to run in RAM to write a page of EEPROM memory
ewp_ram_prog:
	move.b (%a0)+, (%a1)
	addq #2, %a1 | has to be same EEPROM chip
	| can't be a dbcc since it jumps to the wrong address, possibly a bug in binutils.
	cmp #0, %a1
	bne ram_function
	
	| TODO: wait 200 us
	
	| use toggle bit method to check for write completion
	btst #6, (%a1)
	move %sr, %d0
	btst #6, (%a1)
	move %sr, %d1
	cmp.b %d0, %d1
	| bne to proper RAM address

	jmp 3b
	
| end of program in RAM
ewp_ram_prog_end:
	nop | has to be at least one instruction here or it will alias the next label
.data
.align 4
system_error_message: .asciz "System crash - no longer nomadic!\n"
