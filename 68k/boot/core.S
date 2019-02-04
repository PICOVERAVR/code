| Core lib and kernel stuff that should be helpful for application programs...
| thisis going to be smaller than any kind of actual *utils library
| and worse
.text

trap_handler:
	move.l 4(%sp), %d0
	movem %d0-%d2/%a0-%a2, -(%sp)
	| execute the proper kernel function
	movem (%sp)+, %d0-%d2/%a0-%a2
	rte

| xor all bytes in a block
| @param: length of block - 1
| @param: start address
| @returns: checksum
checksum:
	move.l 4(%sp), %d1 | len
	move.l 8(%sp), %a0 | addr
	clr %d0 | running checksum
	
	| TODO: xor_byte ^= arr[i];
	
	| dbf %d1, 1b | TODO: find out if this is even supported on the OG 68k
	rts

| software delay subroutine
| ((ms * 1000) / 22) loops required
| @param: ms to delay for
delay:
	move.l 4(%sp), %d0
	mulu.w #1000, %d0 | ms -> us
	divu.w #22, %d1 | divide by loop execution time
	move.w %d1, %d0 | move quotient into d0
	clr %d1

1:	addq.l #1, %d1 | 8 cc
	cmp.l %d1, %d0 | 6 cc
	beq.b 1b | 8 cc when not taken
	| 22 cc total
	rts

.data
kernel_func_table:
.long mfp_write
.long mfp_read
.long mfp_writeblock
.long mfp_readblock
.long mfp_readc
.long mfp_writec
.long mfp_setdir
.long mfp_setpin
