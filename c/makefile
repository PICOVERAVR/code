CC = gcc
CFLAGS = -std=c11 #use C11
DFLAGS = $(CFLAGS) -g -Wall -pg #generate symbol information

SRC = $(wildcard *.c) #grab anything with a .c ending

debug:
	@$(CC) $(SRC) $(DFLAGS) -o 'db.out'
	@echo "Debug build completed."

all:
	@$(CC) $(SRC) $(CFLAGS) -O3 -march=native -o 'prod.out' 
	@echo "Optimized build completed."

clean:
	@rm -f *.out
	
	@rm -rf *.out.dSYM # get rid of debug info, macOS specific
	@rm -f *.gch
	
	@rm -f *.s *.o

