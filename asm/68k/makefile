CC := m68k-elf-as
SRC := $(filter-out test.S, $(wildcard *.S))

FLAGS := -march=68000 -mcpu=68000
DFLAGS := $(FLAGS)

UNAME := $(shell uname)

debug: pre
	@$(CC) $(DFLAGS) $(SRC) -o db.out # @m68k-elf-ld -T link_script.l db.out
	@echo "Debug build completed."

check: pre debug
	@m68k-elf-objdump -d db.out

release: pre
	@$(CC) $(SRC)-o release.out

pre:
	@echo "Building on: $(UNAME)"
	
clean:
	@rm -f	{*.out,*.o}
