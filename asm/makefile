CC = gcc

SRC = $(wildcard *.S) # grab asm files
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
