SRC=${1:-"../test/programs/jmp_add/jmp_add.bin"}
if [ -e $(which pv) ]; then
	echo "pv found."
else
	echo "pv not found."
fi
echo "Running sim with program $SRC..."
../src/fives -b $SRC | pv --line-mode --rate -N Instructions\ per\ second > /dev/null
