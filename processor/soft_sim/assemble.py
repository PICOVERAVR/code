#!/usr/bin/env python3

def get_instr_info(instr_type):
	temp = { # there has to be a better way of doing this...
		'A': 1, 'a': 1,
		'B': 2, 'b': 2,
		'C': 3, 'c': 3,
		'D': 4, 'd': 4,
		'E': 5, 'e': 5,
		'F': 6, 'f': 6,
		'G': 7, 'g': 7
	}.get(instr_type, -1)
	
	if temp == 1:
		print('A type')
	
	
	return 0



opcode = int(input("opcode: "))
pm = (int(input("pm[0]: "))) + (int(input("pm[1]: ")) << 1) + (int(input("pm[2]: ")) << 2)


print(opcode)
print(pm)

get_instr_info(input('instruction type: '))
