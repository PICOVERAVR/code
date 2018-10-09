CC = gcc
DFLAGS = -Wall -std=gnu11
SRC := $(filter-out $(exclude), $(wildcard *.c)) # grab anything with a .c ending

USER_FLAGS := $(vars)
UNAME := $(shell uname -sm)

debug: pre
	@$(CC) $(SRC) $(DFLAGS) -Og -o 'db.out'
	@echo "Build completed."

pre:
	@echo "Building on $(UNAME), user params: $(USER_FLAGS)"

clean:
	@rm -f *.out
	@rm -f *.o
	
