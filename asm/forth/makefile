CC = gcc
SRC = $(filter-out test.S, $(wildcard *.S)) # grab all asm files except the test one
FLAGS = -nostdlib -no-pie

DFLAGS = $(FLAGS) -g

debug:
	@$(CC) $(DFLAGS) $(SRC)
	@echo "dev build completed."

release:
	@$(CC) $(FLAGS) $(SRC)-o release.out
	@tar -zcf KForth.tar.gz release.out #this is not accurate anymore.
	@echo "zipped build completed."

clean:
	@rm -f	*.out #remove executable and any leftover object files
	@rm -f *.o
	@rm -f KForth.tar.gz
