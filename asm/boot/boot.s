.code16		#generate 16-bit code since we haven't set up enough for 32-bit execution
.text
	.globl _start;
.start:
	
	#no idea how to assemble and run this... something to do with qemu.
	#need to figure out how to use qemu with a docker instance
	# -serial stdio? or -kernel, use .elf
	
	. = _start + 510 #write the 0x55AA for MBR
	.byte 0x55
	.byte 0xAA
