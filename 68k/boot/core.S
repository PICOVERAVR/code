| Core lib stuff that should be helpful for application programs...
| thisis going to be smaller than any kind of actual *utils library
| and worse
.text

| copy memory
memcpy:
	rts

| xor method
checksum:
	rts

| delay a bit
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

