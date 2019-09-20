# m68k
Code related to the 68000 microcomputer I built.
## Setup
GNU binutils needs to be in the PATH variable, and built for [m68k-elf](https://daveho.github.io/2012/10/26/m68k-elf-cross-compiler.html).
## Usage
Makefile exists because going from assembly to a binary suitable to upload to the board isn't trivial.
	- `make test`: assembles the src/test/test.S file and dumps assembly
	- `make boot`: assembles the bootloader
	- `make app`: assembles an application that sits after the bootloader?
	- `make clean`: clean binaries out
