#!/bin/bash

for fn in *.src; do
	checkmk $fn > "${fn%%.*}.c"
done

for src in *.c; do
	CK_VERBOSITY=$1 ./${src%%.*}
done

# flags=$(pkg-config --cflags --libs check)
# srcdir=/root/main/processor/soft_sim/src

# for src in *.c; do
# 	src_out="${src%%.*}" # just get the name part of filename
# 	gcc $src_out.c -I$srcdir $srcdir/execute.c $srcdir/dispatch.c $flags -o $src_out.out
# 	CK_VERBOSITY=$1 ./$src_out.out
# done

