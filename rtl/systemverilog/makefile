VC = iverilog

SRC = $(wildcard *.sv)
VFLAGS = -g2009 -Winfloop -Wall

all:
	@$(VC) $(VFLAGS) -o v.out $(SRC)

clean:
	@rm -f *out

