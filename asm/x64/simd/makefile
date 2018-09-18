CC = gcc
SRC = $(filter-out test.S, $(wildcard *.S)) # grab all asm files except the test one

debug:
	@$(CC) -nostdlib $(SRC)-g
	@echo "dev build completed."

clean:
	@rm -f	*.out #remove executable and any leftover object files
	@rm -f *.o
