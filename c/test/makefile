# small makefile for C projects

CC = clang
CFLAGS = -std=c11 #use C11
DFLAGS = $(CFLAGS) -g -Wall #generate symbol information

SRC = $(wildcard *.c) #grab anything with a .c ending
FINAL = $(SRC) $(wildcard *.h) #grab the headers related to all of it

debug:
	@$(CC) $(FINAL) $(DFLAGS)
	@echo "Debug build completed."

all:
	@$(CC) $(FINAL) $(CFLAGS) -O3 -march=native -o 'prod.out' 
	@echo "Build completed."

clean:
	@rm -f *out
	@rm -f *.s
	@rm -f *.o



