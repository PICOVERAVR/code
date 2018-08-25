This utility is designed to format text according to a very specific set of instructions so I don't have to do it myself.

usage is
./format [-v]

-v: verbose output

the script will then take anything with a .cpp or .hpp filename and add a custom header (defined in shell script) and then lint it with clang-format.


