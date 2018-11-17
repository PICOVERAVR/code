bin_PROGRAMS = proc

proc_SOURCES = dispatch.c execute.c proc.c setup.c core.c
include_HEADERS = dispatch.h execute.h proc.h setup.h core.h

proc_CFLAGS = -I$(top_srcdir)/include # include headers without changing everything to be #include "../stuff/include"

# include doc for how to use processor and test programs for software simulator
noinst_DIST = test_programs assist test

