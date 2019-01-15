SRC := $(wildcard src/*.S)

FLAGS := -march=68000 -mcpu=68000 -mno-float
DFLAGS := $(FLAGS)

UNAME := $(shell uname)

start: pre # assemble files
	@m68k-elf-as $(DFLAGS) $(SRC) -o db.o
	@echo "Debug build completed."

check: pre start # verify linking of all files
	@m68k-elf-ld -T link_script.l db.o -o db.out
	@m68k-elf-readelf -a db.out

asm: pre start # verify assembly
	@m68k-elf-objdump -d db.o

final: check # strip out all ELF information
	@m68k-elf-objcopy -O binary db.out db.bin
	
pre:
	@echo "Building on: $(UNAME)"
	
clean:
	@rm -f	{*.out,*.o}
