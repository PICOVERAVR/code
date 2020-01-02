#!/bin/bash
ARCH=rv64imafdc
ABI=lp64d

# generates assembly and binaries for a given file
# riscv64-unknown-elf-gcc -g -march=$ARCH -mabi=$ABI -o hello hello.c
riscv64-unknown-elf-gcc -g -march=$ARCH -mabi=$ABI -o rv.out src/test_func.S

if [ $? -ne 0 ]; then
	echo "Build failed!"
	exit -1
fi

# spike pk hello
