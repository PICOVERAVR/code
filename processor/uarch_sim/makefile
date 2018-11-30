CC = iverilog

USER_FLAGS := $(src)

run:
	@$(CC) -Wall -Winfloop -o v.out -s $(src)_unit src/$(src).v test/$(src)_test.v
	@vvp v.out
	@open /Applications/gtkwave.app proc_dump.vcd config.gtkw

all:
	@$(CC) -Wall -o v.out -s main src/*.v

clean:
	@rm -rf *out
