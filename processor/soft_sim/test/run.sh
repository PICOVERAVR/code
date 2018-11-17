#!/bin/bash

for fn in *.src; do
	checkmk $fn > $fn.c
done

flags=$(pkg-config --cflags --libs check)
srcdir=/root/main/processor/soft_sim/src

for fn in *.src.c; do
	gcc $fn -I$srcdir $srcdir/execute.c $srcdir/dispatch.c $flags -o $fn.out
	CK_VERBOSITY=verbose ./$fn.out
done

# gcc *.src.c -I$srcdir $srcdir/execute.c $srdcdir/dispatch.c $flags -o cproc.out
# CK_VERBOSITY=verbose ./cproc.out
