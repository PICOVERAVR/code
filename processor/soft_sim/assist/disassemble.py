#!/usr/bin/env python3
import sys # for exit control
import struct # for packing data

opcodes = [
'STOP',
'NOP',
'ADD',
'SUB',
'MUL',
'DIV',
'SEX',
'BN',
'BS',
'Bcc',
'LD',
'ST',
'IO',
'AND',
'OR',
'XOR',
'NOT',
'INV',
'CALL',
'RET',
'PS',
'MOV',
'BR',
'RST',
'LDU'
]

if __name__ == '__main__':
	opcode_list = {}
	for i in range(0, len(opcodes)):
		opcode_list[i] = opcodes[i]
	
	# check if file exists
	
	print('Disassembling executable...')
	with open(sys.argv[1], 'rb') as executable:
		instr_byte_str = executable.read(4) # executable is always 32 bits long
		instr = int.from_bytes(instr_byte_str, byteorder='little')
		
		zeroes = 0 # keep track of zero instructions skipped over
		
		while instr_byte_str:
			if instr != 0:
				if zeroes > 0:
					print('\tskipped %d' % zeroes)
				zeroes = 0
				opcode = instr & 0x3F
				flags = (instr & 0x1C0) >> 6

				o3 = (instr & 0x3E00) >> 9
				o2 = (instr & 0x7C000) >> 14
				o1 = (instr & 0xF80000) >> 19
				o0 = (instr & 0x1F000000) >> 24
				
				print('@0x%x' % executable.tell(), end='')
				print('\t%s, %s  ' % (opcodes[opcode], bin(flags)), end='')
				print('\to0: %d, o1: %d, o2: %d, o3: %d' % (o0, o1, o2, o3), end='')
				print('\tinstr: %s (0x%x)' % (bin(instr), instr))
			else:
				zeroes += 1

			instr_byte_str = executable.read(4)
			instr = int.from_bytes(instr_byte_str, byteorder='little')
