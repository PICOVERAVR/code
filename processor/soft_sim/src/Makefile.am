bin_PROGRAMS = proc

proc_SOURCES = dispatch.c execute.c proc.c setup.c
include_HEADERS = dispatch.h execute.h proc.h setup.h

proc_CFLAGS = -I$(top_srcdir)/include # include headers without changing everything to be #include "../stuff/include"

# include debugging info for now
AM_CFLAGS=-g -Wall i-Wextra -Og

# include doc for how to use processor and test programs for software simulator
noinst_DIST = isa.txt notes.txt software.txt test_programs

