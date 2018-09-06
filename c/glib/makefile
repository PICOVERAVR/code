CC := gcc

CFLAGS := -std=c11
DFLAGS := $(CFLAGS) -g -Wall -pg # generate debugging and symbol information

SRC := $(filter-out test.c, $(wildcard *.c)) # grab anything with a .c ending

USER_FLAGS := $(vars)
UNAME := $(shell uname)

debug: pre
	@$(CC) $(SRC) $(DFLAGS) `pkg-config --cflags --libs glib-2.0` -o 'db.out'
	@echo "Debug build completed."

pre:
	@echo "Building on: $(UNAME), params: $(USER_FLAGS)"

clean:
	@rm -f *.out
	@rm -f *.s *.o
	
	@rm -rf *.out.dSYM # get rid of debug info, macOS specific
	@rm -f *.gch
