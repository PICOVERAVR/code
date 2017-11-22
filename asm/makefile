CC = gcc

SRC = $(wildcard *.S) # grab anything with a .S ending
# use gcc, throw in debugging info always

all:
	$(CC) -nostdlib $(SRC)-g -o out
	@echo "Build completed."

clean:
	@rm -f *out
	@rm -f *.s
	@rm -f *.o
