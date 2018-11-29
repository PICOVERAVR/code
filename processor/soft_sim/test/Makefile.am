TESTS = $(check_PROGRAMS)
check_PROGRAMS = arith cntl branch

arith_SOURCES = arith.c $(top_builddir)/src/execute.c $(top_builddir)/src/dispatch.c
arith_CFLAGS = -I$(top_builddir)/src -O3 @CHECK_CFLAGS@
arith_LDADD = @CHECK_LIBS@

cntl_SOURCES = cntl.c $(top_builddir)/src/execute.c 
cntl_CFLAGS = -I$(top_builddir)/src -O3 @CHECK_CFLAGS@
cntl_LDADD = @CHECK_LIBS@

branch_SOURCES = branch.c $(top_builddir)/src/execute.c
branch_CFLAGS = -I$(top_builddir)/src -O3 @CHECK_CFLAGS@
branch_LDADD = @CHECK_LIBS@

