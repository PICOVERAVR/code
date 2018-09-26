checkmk test.h > execute_test.c
gcc -g execute_test.c ../src/execute.c ../src/dispatch.c `pkg-config --cflags --libs check` -o 'test.out'
CK_VERBOSITY=verbose ./test.out
