# This script runs forth, passing first a bootstrap program
# and then any user-supplied programs to the forth interpreter

cat core.f $1 - | ./a.out
