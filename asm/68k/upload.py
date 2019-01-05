#!/usr/bin/env python3
import sys # for exit
import os # for changing permissions
try:
	import serial # for serial communication
	# pip3 install pyserial to get pyserial module
except ModuleNotFoundError:
	print("ERR: pyserial module not found!")
	sys.exit(2)
else:
	print("pyserial module found.")

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
	
	if os.system("ls /dev/ | grep [USB,usb] > /dev/null") != 0:
		print("ERR: cannot find arduino!")
		sys.exit(2)
	
	# edit this device string to find device
	device_str = "/dev/tty.usbserial-1420"
	
	serport = serial.Serial(device_str, 115200, timeout=5)
	serport.readline()

	# crappy option parsing, fix later
	if sys.argv[2] == '-v': # version
		print("Kyle's EEPROM flasher targeting the <name> EEPROM chip")
	elif sys.argv[2] == '-e':
		print("Erasing EEPROM chips...", end='')
		serport.write("ER;".encode('ascii', 'encode'))
		temp = serport.readline()
		while temp != b'done.\r\n':
			temp = serport.readline()
		
		print("done.")
		
	else:
		print("unknown argument!")
	
	sys.exit(0)

