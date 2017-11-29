CC = gcc

SRC = $(wildcard *.S) # grab asm files
# use gcc, throw in debugging info always

all:
	$(CC) -nostdlib $(SRC)-g 
	@echo "Build completed."

clean:
	@rm -f	*.out #remove executable and any leftover object files
	@rm -f *.o
