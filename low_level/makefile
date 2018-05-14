CC := clang
CFLAGS := -Wall

SRC := main.c # fix this eventually please

test: 
	@$(CC) $(CFLAGS) -O3 -o test.out $(SRC)
	@echo "test build completed."

debug:
	@$(CC) $(CFLAGS) -S $(SRC)
	@echo "debug build completed."

clean:
	@rm -f *.out
	@rm -f *.o
	@rm -f *.s
