# m68k
Code related to the 68000 microcomputer I built.
## Setup
GNU binutils needs to be in the PATH variable, and built for [m68k-elf](https://daveho.github.io/2012/10/26/m68k-elf-cross-compiler.html).  Version 2.31 has been tested, but most other versions of binutils should work as well.
## Usage
Sample test binary upload:
```
$ make test # build the test executable, view assembly to make sure everything is right
$ ./split test.bin # splits the test.bin binary into high and low binaries
$ ./eeprom_config --action write --device /dev/ttyUSB0 --binary test.bin.msb # write each eeprom chip, insert into board
$ ./eeprom_config --action write --device /dev/ttyUSB0 --binary test.bin.lsb
```
- `make test`: assembles the src/test/test.S file and dumps assembly
- `make boot`: assembles the bootloader
- `make app`: assembles an application that sits after the bootloader
- `make clean`: clean binaries out
