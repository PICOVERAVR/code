# small makefile for C projects

CC = g++
CFLAGS = 
DFLAGS = $(CFLAGS) -g -Wall #generate symbol information

SRC = $(wildcard *.cpp) #grab anything with a .c ending
FINAL = $(SRC) $(wildcard *.h) #grab the headers related to all of it

all:
	$(CC) $(FINAL) $(CFLAGS) -O3 -march=native -o 'out' 
	@echo "Build completed."

clean:
	@rm -f *out
	@rm -f *.s
	@rm -f *.o

debug:
	$(CC) $(FINAL) $(DFLAGS) -fopenmp -o 'db.out'
	@echo "Debug build completed."

parallel:
	$(CC) $(FINAL) $(CFLAGS) -fopenmp -o 'p.out'

#command-line options in make
