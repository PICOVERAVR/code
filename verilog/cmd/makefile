CC = iverilog

SRC = $(wildcard *.v)

all:
	@$(CC) -o a.out -s main $(SRC)
	@vvp a.out 

clean:
	@rm -f *out

