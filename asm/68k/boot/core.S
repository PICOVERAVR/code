| Core lib stuff that should be helpful for application programs...
| thisis going to be smaller than any kind of actual *utils library
| and worse
.text

| integer to ascii conversion, base 10. (32 bit)
| @param: address to put converted integer
| @param: integer itself
lib_itoa:
	move.l 4(%sp), %a0 | addr
	move.l 8(%sp), %d0 | int
	
	| TODO: finish this
	rts

| copy memory
memcpy:

| fun time with optimization?
| hehe just ask the GPU board to do it
prime_finder:
	
| check validity of stuff
checksum:
	
