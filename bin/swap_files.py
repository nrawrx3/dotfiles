#!/usr/bin/env python

import argparse
from pathlib import Path
import sys

MAX_FILE_SIZE = 128 * 1024 * 1024

def check_file(file):
	if not file.exists:
		print('File {} does not exist.'.format(file))
		sys.exit(1)

	if file.stat().st_size > MAX_FILE_SIZE:
		print('File {} is too large'.format(file))
		sys.exit(1)

	return True

if __name__ == '__main__':
	p = argparse.ArgumentParser(description='Exchange contents of two files')
	p.add_argument('file1', type=str, help='File 1')
	p.add_argument('file2', type=str, help='File 2')

	args = p.parse_args()

	file1 = Path(args.file1)
	file2 = Path(args.file2)

	check_file(file1)
	check_file(file2)

	with open(args.file1, 'r+') as f1:
		file1_data = f1.read()
		f1.seek(0)
		with open(args.file2, 'r+') as f2:
			file2_data = f2.read()
			f2.seek(0)

			f2.write(file1_data)
			f2.truncate()
			f1.write(file2_data)
			f1.truncate()

	print('...done')
