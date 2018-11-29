CC = iverilog

run:
	@$(CC) -Wall -Winfloop -o v.out -s main src/*.v test/*.v
	@vvp v.out
	@open /Applications/gtkwave.app proc_dump.vcd config.gtkw

all:
	@$(CC) -Wall -o v.out -s main $(USE)

clean:
	@rm -rf *out
