#!/usr/bin/env python3
import sys # for exit
import os # for checking file existance
from math import ceil # for arithmetic

try:
	import serial # for serial communication, try "pip3 install pyserial"
except ModuleNotFoundError:
	print("ERR: pyserial module not found!")
	sys.exit(2)
else:
	print("pyserial module found.")

EEPROM_SIZE = 0x1FFFF # 128Kbytes memory to flash

if __name__ == "__main__":
	print("EEPROM flasher tool v0.1")
	if len(sys.argv) < 4:
		print("usage: ./upload.py <binary file> <instruction> <device>")
		sys.exit(1)
	
	try:
		with open(sys.argv[1], "rb") as binfile:
			bindata = binfile.read(EEPROM_SIZE)
	except IOError:
		print("ERR: cannot locate binary file!")
	else:
		print("binary located.")
	
	device_str = sys.argv[3]
	
	serport = serial.Serial(device_str, 115200, timeout=5)
	serport.readline()

	if sys.argv[2] == '-v': # version
		print("Kyle's EEPROM flasher, currently targeting two GLS29EE010 EEPROM chips")
	elif sys.argv[2] == '-e':
		print("Erasing EEPROM chips...", end='')
		serport.write("ER;".encode('ascii', 'encode'))
		temp = serport.readline()
		while temp != b'done.\r\n':
			temp = serport.readline()
		print("done.")
	elif sys.argv[2] == '-w':
		
		# WARNING WARNING WARNING the page boundaries for this really don't line up.
		# WP writes 128 sequential bytes to the target, but we want 128 words, and then arduino will write odd and even bytes onto data bus.
		# should inc by 256 instead of 128, since we're writing one word at a time!
		
		# write all the pages up to the last one, since the last one may not be on a page boundary.
		endpage = len(bindata) + (128 - len(bindata) % 128)
		
		print("Writing " + str(endpage) + " bytes to EEPROM...")
		
		for page in range(0, endpage, 128):
			page_str = "WP:" + str(page)
			for byte in range(0, 128):
				if (page + byte) >= len(bindata):
					page_str += ":0"
				else: 
					page_str += ":" + str(bindata[page + byte])
			page_str += ";"
			print(page_str)
			
			serport.write(page_str.encode("ascii", "encode"))
			temp = serport.readline()
			while temp != b'done.\r\n':
				temp = serport.readline()
			print("writing page " + str((page // 128) + 1) + "/" + str(endpage // 128) + "...")
		
		print("done.")
	
	elif sys.argv[2] == '-r':
		print("Reading EEPROM contents...")
		# ...
		print("done.")

	else:
		print("unknown argument!")
		sys.exit(1)
	
