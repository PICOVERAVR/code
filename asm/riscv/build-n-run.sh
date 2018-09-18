#!/bin/bash
ARCH=rv64imafdc
ABI=lp64d

# build the actual executable
riscv64-unknown-elf-gcc -g -march=$ARCH -mabi=$ABI -o hello hello.c

# omit debug info for just looking at assembly
riscv64-unknown-elf-gcc -march=$ARCH -mabi=$ABI -o hello.asm -S hello.c

if [ $? -ne 0 ]; then
	echo "Build failed!"
	exit -1
fi
spike pk hello

