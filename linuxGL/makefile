# you can use the GCC -H option to list all included directories, helps with build debugging
# and make -j for makefile debugging

# TODO: differentiate debug and release builds.

# specify directories to search for files
VPATH := ./src ./header
CC := g++

# get compilation options from libraries used, assuming they're actually installed
LIBS := $(shell pkg-config --libs glfw3 assimp glm) -ldl
LIBFLAGS := $(shell pkg-config --cflags glfw3 assimp glm)

DIRS := -I header
CFLAGS := -Wall -g -std=c++14 $(DIRS) $(LIBFLAGS)

# specify a single target name here
TARGETS := debug release
MAINS := $(addsuffix .o, $(TARGETS) )
OBJFILES := camera.o main.o program.o vloader.o window.o glad.o

# NOTE NOTE NOTE: glad.c has to be renamed to glad.cpp to make things easier
# also glad.h and khrplatform have to be in folders to avoid having to adjust glad.cpp

.PHONY: all clean

# build for all possible targets
all: $(TARGETS)

# clean out .o and executable files
clean:
	@rm -f $(TARGETS) $(OBJFILES)

# for each object file: that matches %.o: replace with %.cpp and use stb_image.h
$(OBJFILES): %.o: %.cpp stb_image.h
	$(CC) -c -o $@ $< $(CFLAGS)

# for each target: compile in all dependancies as well as all library link flags we need
$(TARGETS): % : $(filter-out $(MAINS), $(OBJFILES))
	$(CC) -o $@ $(LIBS) $^

# for each cpp file: update timestamp, but don't create a file if you can't find it.
%.cpp:
	touch -c $@

