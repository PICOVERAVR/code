#!/bin/bash

function check () {
	if [ $? -ne 0 ]; then
		echo "Build Failed!"
		exit -1
	fi
}

echo "	Building for $(uname -sm), target architecture: RV64"

cd /root
mkdir install
export RISCV=/root/install

echo "	Fetching RISC-V Frontend Server..."
git clone https://github.com/riscv/riscv-fesvr
check

cd riscv-fesvr

mkdir build
cd build

echo "	Building RISC-V Frontend Server..."
../configure --prefix=$RISCV --target=riscv64-unknown-elf
check
make install
check

cd /root

echo "	Fetching RISC-V Spike simulator..."
git clone https://github.com/riscv/riscv-isa-sim
check
apt-get install --yes device-tree-compiler

cd riscv-isa-sim
mkdir build
cd build

echo "	Building RISC-V Spike simulator..."
../configure --prefix=$RISCV --with-fesvr=$RISCV
check
make
check
make install
check
cd /root

echo "	Fetching RISC-V GNU Toolchain..."
git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
check
apt-get install --yes autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev

cd riscv-gnu-toolchain
export PATH=$PATH:$RISCV/bin

echo "	Building RISC-V GNU Toolchain..."
./configure --prefix=$RISCV
check
make -j 16 # large since this is mostly IO bound, according to some
check

cd /root

echo "	Fetching RISC-V Proxy Kernel..."
git clone https://github.com/riscv/riscv-pk
check
cd riscv-pk
mkdir build
cd build

echo "	Building RISC-V Proxy Kernel..."
../configure --prefix=$RISCV --host=riscv64-unknown-elf
check
make
check
make install
check

cd /root
rm -rf riscv-isa-sim riscv-gnu-toolchain riscv-pk riscv-fesvr

echo "Done!"
