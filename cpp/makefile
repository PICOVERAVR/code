# small makefile for C++ projects
CC = g++
DFLAGS = -Wall -std=c++17

SRC = $(wildcard *.cpp) #grab anything with a .c ending

debug:
	@$(CC) $(SRC) $(DFLAGS)
	@echo "Debug build completed."

clean:
	@rm -f *out
	@rm -f *.o
	@rm -rf *.dSYM
