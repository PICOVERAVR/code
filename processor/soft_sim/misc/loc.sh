#!/bin/bash

../src/fives -v | head -1

# TODO: figure out how this works
SRCLINES=$( ( find ../src/ -name '*.[ch]' -print0 | xargs -0 cat ) | wc -l)
TESTLINES=$( ( find ../test/ -name '*.src' -print0 | xargs -0 cat ) | wc -l)
echo "Source lines written: $SRCLINES"
echo "Test lines written: $TESTLINES"

TOTAL=$(( $SRCLINES + $TESTLINES ))
echo "Total lines written: $TOTAL"
