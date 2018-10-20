#!/usr/bin/env python3
import json
import sys
from pprint import pprint

if __name__ == "__main__":
	if len(sys.argv) < 2:
		print("Usage: json_parse.py <json file>")
		sys.exit(1)
	
	with open(sys.argv[1]) as data_file:
		data = json.load(data_file)
	
	pprint(data)
	print()
	# print(data['plantlist'][0]['name'])
	
	plant_traits = []
	for tag, data in data.items():
		print(data)
