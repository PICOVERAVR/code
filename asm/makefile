CC = gcc
SRC = $(filter-out test.S, $(wildcard *.S)) # grab all asm files except the test one

debug:
	$(CC) -nostdlib $(SRC)-g -o dev.out
	@echo "dev build completed."

check: 
	GCC_EXISTS := $(shell gcc --version 2>/dev/null)
	ifndef GCC_EXISTS
		$(error "gcc not found, please install and retry.")
	endif
 
release:
	$(CC) -nostdlib $(SRC)-o release.out
	@tar -zcf KForth.tar.gz release.out
	@echo "zipped build completed."

clean:
	@rm -f	*.out #remove executable and any leftover object files
	@rm -f *.o
	@rm -f KForth.tar.gz
