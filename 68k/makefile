exclude := src/boot/start.S
SRC := $(filter-out $(exclude), $(wildcard src/boot/*.S))
APP := $(wildcard src/app/*.S)
TEST := src/test/test.S
TESTC := src/test/test.c

BOOT_LINK := src/boot/link_boot_script.l
APP_LINK := src/app/link_app_script.l

FLAGS := -march=68000 -mcpu=68000

UNAME := $(shell uname)

lang: pre # compile a C file
	@m68k-elf-gcc $(FLAGS) $(TESTC)

boot: pre # assemble the bootloader
	@m68k-elf-as $(FLAGS) $(exclude) $(SRC) -o boot.o # start.S code always executes first, putting it in the SRC variable means other files may be put at 0x400
	@m68k-elf-ld -T $(BOOT_LINK) boot.o -o boot.out
	@m68k-elf-objcopy -O binary boot.out boot.bin
	@m68k-elf-readelf -S boot.out

asm: pre # dump assembly of bootloader
	@m68k-elf-objdump -d boot.out

test: pre # assemble a test file only, then dump assembly
	@m68k-elf-as $(FLAGS) $(TEST) -o test.o
	@m68k-elf-ld -T $(BOOT_LINK) test.o -o test.out # shouldn't matter where we link stuff to, just that it works properly
	@m68k-elf-objcopy -O binary test.out test.bin
	@echo "Test build completed."
	@m68k-elf-readelf -S test.out
	@m68k-elf-objdump -D test.out
app: pre # assemble an application suitable to be booted into
	@m68k-elf-as $(FLAGS) $(APP) -o app.o
	@m68k-elf-ld -T $(APP_LINK) app.o -o app.out
	@m68k-elf-objcopy -O binary app.out app.bin
	@m68k-elf-readelf -S app.out

pre: # announce host and eventually check that binutils exists
	@echo "Building on: $(UNAME)"
	@echo "Using $(shell which m68k-elf-as) as assembler."
	@echo "Using $(shell which m68k-elf-gcc) as C compiler."

clean:
	@rm -f	{*.out,*.o,*.bin,*.lsb,*.msb}
