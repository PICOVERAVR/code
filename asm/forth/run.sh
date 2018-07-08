# This script runs forth, passing first a bootstrap program
# and then any user-supplied programs to the forth interpreter


if [ ! -e ./a.out ]; then
	echo "no executable built."
else
	echo -n "bootstrapping... "
	cat core.f $1 - | ./a.out
fi


