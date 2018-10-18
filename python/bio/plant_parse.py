#!/usr/bin/env python3
import xml.etree.ElementTree as et # xml processing
import os # call actual tree thing
import sys # for exit

if __name__ == "__main__":
	if len(sys.argv) < 2:
		print("Usage: prog <xml doc>")
		sys.exit(1)
	
	tree = et.parse(sys.argv[1]) # check if filename is valid here
	root = tree.getroot()
	
	list_names = []
	for i in root.findall('.//traits/*'):
		list_names.append(i.tag)
	
	list_names = list(set(list_names))
	print('List of plant attributes: ', end='')
	print(list_names)
	
	list_plant_attribs = []
	temp_list = []
	for i in range(0, len(list_names)):
		temp_list = []
		for j in root.findall('.//traits/' + list_names[i] + '/../../name'):
			temp_list.append(j.text)
		print('Params for ' + list_names[i] + ': ')
		for i in temp_list:
			print('\t' + i + ': ' + 'Grab data from XML sheet again and put here')
		print()
	

