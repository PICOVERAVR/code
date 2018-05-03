# small makefile for C projects

CC = gcc
CFLAGS = -std=c11 #use C11
DFLAGS = $(CFLAGS) -g -Wall #generate symbol information

SRC = $(wildcard *.c) #grab anything with a .c ending
FINAL = $(SRC) $(wildcard *.h) #grab the headers related to all of it

parallel:
	@$(CC) $(FINAL) $(DFLAGS) -lpthread -o 'p.out'
	@echo "Parallel build completed."

clean:
	@rm -f *out
	@rm -f *.s
	@rm -f *.o


