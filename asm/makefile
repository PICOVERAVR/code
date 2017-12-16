CC = gcc
SRC = $(filter-out test.S, $(wildcard *.S)) # grab all asm files except the test one

debug:
	$(CC) -nostdlib $(SRC)-g -o dev.out
	@echo "dev build completed."

check: #if gmake is not installed, then this makefile will fail, fix
	GCC_EXISTS := $(shell gcc --version 2>/dev/null)
	ifndef GCC_EXISTS
		$(error "gcc not found, please install and retry.")
	endif
 
release:
	$(CC) -nostdlib $(SRC) -o release.out
	@echo "release build completed."

clean:
	@rm -f	*.out #remove executable and any leftover object files
	@rm -f *.o
