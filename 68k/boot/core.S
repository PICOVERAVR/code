| Core lib and kernel stuff that should be helpful for application programs...
| this is going to be smaller than any kind of actual *utils library
| and worse

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

| itoa, implemented in assembly
| all numbers are considered unsigned, printed in hex
| @param: number to convert to int
| @param: space to write int to (max space needed is 8 chars for hex)
asm_itoa:
	move.l %d2, -(%sp) | save d2
	move 4(%sp), %d0 | space
	move 8(%sp), %d1 | num
	
	| TODO: get lower 4 bits
	| add '0'
	| write to buffer
	| lsr num >> 4
	| loop until 0
	
2:	| move #0, (%d2) | add a null byte
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

| TODO: check the heck out of this

| write a 128-byte page of memory to one of two EEPROM chips, blocking until the write is complete.
| @param: address of block to write
| @param: EEPROM address to write block to (128-byte aligned)
eeprom_write_page:
	move.l %d2, -(%sp)
	move.l 4(%sp), %d0 | memory address
	move.l 8(%sp), %d1 | EEPROM address
	
	move.b #128, %d2 | length of block, TODO: should this be adjusted by 1?
	
	| get length of RAM program, write into ram - length is a constant here
	jmp ram_function | start of kernel memory and where we dumped the RAM function

1:	move.l (%sp)+, %d2
	rts

| program to run in RAM to write a page of EEPROM memory
ewp_ram_prog:
	
	| dbf ?
	jmp 1b
	
| end of program in RAM
ewp_ram_prog_end:


.data
.align 4
system_error_message: .asciz "System crash - no longer nomadic!\n"
