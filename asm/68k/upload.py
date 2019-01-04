#!/usr/bin/env python3
import sys # for exit
import os # for changing permissions
import serial # for serial communication
# pip3 install pyserial to get pyserial module

EEPROM_SIZE = 0x1FFFF # 128Kbytes memory to flash

if __name__ == "__main__":
	print("EEPROM flasher tool v0.1")
	if len(sys.argv) < 3:
		print("usage: ./upload.py <binary> <instruction>")
		sys.exit(1)
	
	try:
		with open(sys.argv[1], "rb") as binfile:
			bindata = binfile.read(EEPROM_SIZE)
	except IOError:
		print("ERR: cannot locate binary file!")
	else:
		print("binary file read in.")
	
	if os.system("ls /dev/ | grep USB > /dev/null") != 0:
		print("ERR: cannot find arduino!")
		sys.exit(2)
	
	device_str = "/dev/ttyUSB0"
	os.system("chmod a+rw " + device_str)
	
	serport = serial.Serial(device_str, 9600, timeout=5)
	#print(serport.readline())
	#serport.write("stuff".encode('ascii', 'encode'))
	#print(serport.readline())
	
	# crappy option parsing, fix later
	if sys.argv[2] == '-v': # version
		print("Kyle's EEPROM flasher targeting the <name> EEPROM chip")
	elif sys.argv[2] == '-e':
		print("Erasing EEPROM chips...", end='')
		
		
		
		print("done.")
		
	else:
		print("unknown argument!")
	
	sys.exit(0)

