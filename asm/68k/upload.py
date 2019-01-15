#!/usr/bin/env python3
import sys # for exit
import os # for checking file existance
from math import ceil # for arithmetic
import argparse # for argument processing
import logging # for simple debug logging

# add values to dictionary for different chips
# TODO: come up with a more robust way of doing this, values will collide eventually.
eeprom_id_values = {0x7: "GLS29EE010", 0x8: "GLS29VE010"}

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='Python script to interface with a pair of GLS29EE010 EEPROMs.')
	parser.add_argument('--version', action='version', version='EEPROM flasher tool v0.2')
	parser.add_argument('-a', '--action', type=str, default='nop', help='action to perform. <include list of actions>')
	parser.add_argument('-d', '--device', type=str, help='device to communicate with, usually something like \'/dev/ttyUSB0\'.')
	parser.add_argument('-v', '--verbose', action='store_true', help='enable verbose output.') # TODO: use this!
	parser.add_argument('-b', '--binary', type=str, default='', help='binary to manipulate.')
	parser.add_argument('-s', '--size', type=int, default=0x1FFFF, help='EEPROM size, defaults to 128K')
	args = parser.parse_args()

	EEPROM_SIZE = args.size
	
	try:
		import serial
	except ModuleNotFoundError:
		logging.error("pyserial module not found!")
		logging.debug("try \'pip3 install pyserial\'")
		sys.exit(2)
	else:
		logging.info("pyserial module found.")
	
	if args.device:
		device_str = args.device
	else:
		logging.error("device not found!")
		sys.exit(3)
	
	serport = serial.Serial(device_str, 2000000, timeout=5)
	serport.readline()

	if args.action == 'erase':
		print("Erasing EEPROM chips...", end='')
		serport.write("ER;".encode('ascii', 'encode'))
		temp = serport.readline()
		while temp != b'done.\r\n':
			temp = serport.readline()
		print("done.")
	elif args.action == 'id':
		print("Version info:")
		serport.write("VE;".encode('ascii', 'encode'))
		print(serport.readline().decode('ascii').strip('\n')) # reader version
		print(serport.readline().decode('ascii').strip('\n')) # manufacturer ID
		num = serport.readline().decode('ascii').strip('\n') # device ID
		print("Device Model: ", end='')
		print(eeprom_id_values[int(num[11:14], 16)])
		
	elif args.action == 'write':
		try:
			with open(args.binary, "rb") as binfile:
				bindata = binfile.read(EEPROM_SIZE)
		except IOError:
			logging.error("binary cannot be opened!")
			sys.exit(4)
		else:
			logging.info("binary located.")
		
		# TODO: make sure byte and word order is same as 68k memory layout!
		# TODO: write a byte at a time because doing a whole seperate socket is annoying
		# write all the pages up to the last one, since the last one may not be on a page boundary.
		
		endpage = len(bindata) + (128 - len(bindata) % 128)
		
		print("Writing " + str(endpage) + " bytes to EEPROM...")
		
		for page in range(0, endpage, 128):
			page_str = "WP:" + str(page)
			for word in range(0, 256, 2):
				if (page + word + 1) >= len(bindata):
					page_str += ":0"
				else:
					page_str += ":" + str(((bindata[page + word]) << 8) + bindata[page + word + 1])
			page_str += ";"
			logging.debug(page_str)
			
			serport.write(page_str.encode("ascii", "encode"))
			temp = serport.readline()
			while temp != b'done.\r\n':
				temp = serport.readline()
			print("writing page " + str((page // 128) + 1) + "/" + str(endpage // 128) + "...") # number of pages written still correct, bytes split up.
		print("done.")
	
	# WARNING: this takes ~25 seconds to complete for a 128K EEPROM at a baud rate of 2M.
	elif args.action == 'read':
		print("Reading EEPROM contents into file ", end='')
		print(args.binary, end='')
		print("...")
		
		try:
			with open(args.binary, "wb") as readfile:
				logging.info("binary located.")
		except IOError:
			logging.error("binary cannot be opened!")
			sys.exit(5)
		for page in range(0, EEPROM_SIZE, 128):
			page_str = "RP:" + str(page) + ";"
			serport.write(page_str.encode("ascii", "encode"))
			print(serport.readline().decode('ascii').strip('\n'))
			serport.readline()

	elif args.action == 'nop':
		logging.info('doing nothing.')
	
	else:
		logging.error("unknown action!")
		sys.exit(1)
	
