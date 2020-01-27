# you can use the GCC -H option to list all included directories, helps with build debugging

# LIBSRC is for header-only or source libraries
# LINK is for packages installed with pacman

CC := g++

LINKLIBS := $(shell pkg-config --libs glfw3 assimp) -ldl
LINKFLAGS := $(shell pkg-config --cflags glfw3 assimp)

LIBSRC := -I header -I lib $(LINKLIBS)
CFLAGS := -Wall -std=c++14 $(LIBSRC) $(LINKFLAGS)
SRC := $(wildcard src/*.cpp) lib/glad/glad.c
UNAME := $(shell uname -sm)

debug: pre
	@$(CC) $(SRC) $(CFLAGS) -g -Og -o 'db.out'
	@echo "Debug build completed."

fast: pre
	@$(CC) $(SRC) $(CFLAGS) -Ofast -march=native -o 'prod.out'
	@echo "Optimized build completed."

pre:
	@echo "Building on: $(UNAME)."

clean:
	@rm -f *.out
	@rm -f *.s *.o

