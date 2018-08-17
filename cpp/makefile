# small makefile for C++ projects
CC = g++
DFLAGS = -g -Wall #generate symbol information

SRC = $(wildcard *.cpp) #grab anything with a .c ending

debug:
	@$(CC) $(SRC) $(DFLAGS) -o 'db.out'
	@echo "Debug build completed."

clean:
	@rm -f *out
	@rm -f *.o
	@rm -rf *.dSYM
