bin_PROGRAMS = fives

fives_SOURCES = dispatch.c execute.c proc.c setup.c core.c __assist.h config.h
include_HEADERS = dispatch.h execute.h proc.h setup.h core.h

# include headers without changing everything to be #include "../stuff/include"
# also include debugging info and turn down optimization level
fives_CFLAGS = -I$(top_srcdir)/include $(AM_CFLAGS) -g -Og

# include doc for how to use processor and test programs for software simulator
noinst_DIST = test_programs assist test

