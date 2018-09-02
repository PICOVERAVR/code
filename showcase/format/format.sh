#!/bin/bash
NAME="Kyle Neil"
CLASS="CIS 278 (online)"
INSTR="Dave Harden"

SRC=./*.?pp

VERB=
INP=
while [ "$1" != "" ]; do
	case $1 in 
		-v | --verbose )   VERB=1
				   ;;
		-f | --file )      shift
				   SRC=$1
				   ;;
		-i | --inplace )   INP=1
				   ;;
		* )		 echo "error: unknown argument"
				 exit 1
	esac
	shift
done

# remove any files already touched
rm -f *.new

# if no files exist, don't fail
shopt -s nullglob
for f in $SRC; do
	
	# enable verbose output
	if [[ $VERB == 1 ]]; then
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
	if [[ $INP == 1 ]]; then
		mv $f.new $f
	fi
done
