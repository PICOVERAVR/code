| Core lib stuff that should be helpful for application programs...
| thisis going to be smaller than any kind of actual *utils library
| and worse
.text

| integer to ascii conversion, base 10. (32 bit)
| parameters: address to put converted integer, integer itself
| returns: nothing
lib_itoa:
	move.l 4(%sp), %a0 | addr
	move.l 8(%sp), %d0 | int
	
	| 
	
	| TODO: finish this
	rts
