| stuff to deal with the MFP
| timer set, clear
| uart write, read, errcnt, read and write strings/blocks
| GPIO control

	.text

| reset and configure the MFP for basic operation
mfp_init:
	bset #6, (0x40017) | interrupts occur right after end of mandatory section of EVT
	bset #3, (0x40029) | UART: 1 start bit, 1 stop bit, async
	
	bset #0, (0x4002b) | UART: enable RX
	bset #0, (0x4002d) | UART: enable TX
	
	rts

