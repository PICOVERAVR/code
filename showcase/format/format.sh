#!/bin/bash
NAME="Kyle Neil"
CLASS="CIS 278 (online)"
INSTR="Dave Harden"

# get anything with a .cpp or .hpp headers
SRC=./*.?pp

# remove any files already touched
rm -f *.new

# if no files exist, don't fail
shopt -s nullglob
for f in $SRC; do
	
	# enable verbose output
	if [[ "$@" == *"-v"* ]]; then
		echo "formatting file $f."
	fi

	(echo "
/*
    Name: $NAME
    Date: $(date)
    Class: $CLASS
    Instructor: $INSTR
    Name of file: $f
    
    Description:
        <insert>
        
        

*/
	"; cat $f; echo "
/*
    console output:
        <insert>
*/
	") | clang-format -style=file > $f.new
	# call clang-format for actual code linting
done
