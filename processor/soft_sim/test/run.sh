#!/bin/bash

for fn in *.src; do
	checkmk $fn > "${fn%%.*}.c"
done

flags=$(pkg-config --cflags --libs check)
srcdir=/root/main/processor/soft_sim/src

for src in *.c; do
	src_out="${src%%.*}"
	gcc $src_out.c -I$srcdir $srcdir/execute.c $srcdir/dispatch.c $flags -o $src_out.out
	CK_VERBOSITY=verbose ./$src_out.out
done

