#!/usr/bin/env python3
import sys # for exit control
import struct # for packing data

def input_shift(shift: int, msg: str) -> int:
	return int(input(msg), 16) << shift

def get_instr_info(instr_type: int) -> int:
	temp = { # there has to be a better way of doing this...
		'A': 1, 'a': 1,
		'B': 2, 'b': 2,
		'C': 3, 'c': 3,
		'D': 4, 'd': 4,
		'E': 5, 'e': 5,
		'F': 6, 'f': 6,
		'G': 7, 'g': 7
	}.get(instr_type, -1)
	
	
	# should really do error checking here... user could input a num > 1 or < 0
	if temp == 1: # A
		return 0
	elif temp == 2: # B
		return input_shift(9, '16b imm: ')
	elif temp == 3: # C
		return input_shift(9, '5b reg: ')
	elif temp == 4: # D
		return input_shift(9, '5b dest: ') + input_shift(14, '5b src: ')
	elif temp == 5: # E
		return input_shift(9, '5b reg: ') + input_shift(14, '16b imm: ')
	elif temp == 6: # F
		return input_shift(9, '5b dest: ') + input_shift(14, '5b s1: ') + input_shift(19, '5b s0: ')
	elif temp == 7: # G
		print('not implemented.')
		sys.exit(0)
	else:
		return 0

opcode = int(input("opcode: "), 16)
pm = (int(input("pm[0]: "), 2)) + (int(input("pm[1]: "), 2) << 1) + (int(input("pm[2]: "), 2) << 2)

instr = opcode + (pm << 6) + get_instr_info(input('instruction type: '))

print('note: instructions are in wrong endian!');
print('formatted instruction: ');

print('\t', format(instr, '#06x'))
print('\t', format(instr, '#032b'))
