CC = gcc
CFLAGS = -Wall

SRC := $(filter-out $(exclude), $(wildcard *.c)) # grab anything with a .c ending

debug:
	@$(CC) $(SRC) $(CFLAGS) -o 'build.out'
	@echo "Build completed."

clean:
	@rm -f *.out
