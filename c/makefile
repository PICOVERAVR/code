# small makefile for C projects

CC = gcc
CFLAGS = -std=c11 #use C11
DFLAGS = $(CFLAGS) -g -Wall #generate symbol information

SRC = $(wildcard *.c) #grab anything with a .c ending
FINAL = $(SRC) $(wildcard *.h) #grab the headers related to all of it

all:
	$(CC) $(FINAL) $(CFLAGS) -O3 -march=native -o 'prod.out' 
	@echo "Build completed."

clean:
	@rm -f *out
	@rm -f *.s
	@rm -f *.o

debug:
	$(CC) $(FINAL) $(DFLAGS) -fopenmp -o 'db.out'
	@echo "Debug build completed."

parallel:
	$(CC) $(FINAL) $(DFLAGS) -fopenmp -o 'p.out'

# for graphics in the terminal
gui:
	$(CC) $(FINAL) $(DFLAGS) -lncurses -o 'gui.out'

