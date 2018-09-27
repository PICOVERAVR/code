#!/bin/bash

for fn in *.src; do
	checkmk $fn > $fn.c
done

flags=$(pkg-config --cflags --libs check)
srcdir=/root/main/processor/soft_sim/src

gcc *.src.c -I$srcdir $srcdir/execute.c $srcdir/dispatch.c $flags -o cproc.out
CK_VERBOSITY=verbose ./cproc.out
