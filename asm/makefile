CC = gcc
SRC = $(filter-out test.S, $(wildcard *.S)) # grab all asm files except the test one

debug:
	@$(CC) -nostdlib $(SRC)-g
	@echo "dev build completed."

release:
	@$(CC) -nostdlib $(SRC)-o release.out
	@tar -zcf KForth.tar.gz release.out #this is not accurate anymore.
	@echo "zipped build completed."

clean:
	@rm -f	*.out #remove executable and any leftover object files
	@rm -f *.o
	@rm -f KForth.tar.gz
