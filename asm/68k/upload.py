#!/usr/bin/env python3
import sys # for exit
import os # for checking file existance
from math import ceil # for arithmetic
import argparse # for argument processing
import logging # for simple debug logging

if __name__ == "__main__":
	parser = argparse.ArgumentParser(description='Python script to interface with a pair of GLS29EE010 EEPROMs.')
	parser.add_argument('--version', action='version', version='EEPROM flasher tool v0.2')
	parser.add_argument('-a', '--action', type=str, default='nop', help='action to perform. <include list of actions>')
	parser.add_argument('-d', '--device', type=str, help='device to communicate with, usually something like \'/dev/ttyUSB0\'.')
	parser.add_argument('-v', '--verbose', action='store_true', help='enable verbose output.')
	parser.add_argument('-b', '--binary', type=str, default='', help='binary to manipulate.')
	parser.add_argument('-s', '--size'. type=int, default=0x1FFFF, help='EEPROM size, defaults to 128K')
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
	
	serport = serial.Serial(device_str, 115200, timeout=5)
	serport.readline()

	if args.action == 'erase':
		print("Erasing EEPROM chips...", end='')
		serport.write("ER;".encode('ascii', 'encode'))
		temp = serport.readline()
		while temp != b'done.\r\n':
			temp = serport.readline()
		print("done.")
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
		# TODO: fix page counting, should be half of bin size since we're consuming a word at a time.
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
	
	elif args.action == 'read':
		print("Reading EEPROM contents into file dump.bin...")
		
		# read contents into memory, then file
		
		try:
			with open(args.binary, "wb") as readfile:
				print("stuff")
		except IOError:
			logging.error("binary cannot be opened!")
		else:
			logging.info("binary located.")

	elif args.action == 'nop':
		logging.info('doing nothing.')
	
	else:
		logging.error("unknown action!")
		sys.exit(1)
	
