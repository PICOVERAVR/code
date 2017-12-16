CC = gcc

SRC = $(filter-out test.S, $(wildcard *.S)) # grab all asm files except the test one
# use gcc, throw in debugging info always

all:
	$(CC) -nostdlib $(SRC)-g 
	@echo "Build completed."

final:
	$(CC) -nostdlib $(SRC)
	@echo "Prod build completed."

clean:
	@rm -f	*.out #remove executable and any leftover object files
	@rm -f *.o
