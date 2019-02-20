SRC := $(wildcard boot/*.S)
APP := $(wildcard app/*.S)
TEST := test/test.S

BOOT_LINK := boot/link_boot_script.l
APP_LINK := app/link_app_script.l

FLAGS := -march=68000 -mcpu=68000 -mno-float

UNAME := $(shell uname)

boot: pre # assemble files
	@m68k-elf-as $(FLAGS) $(SRC) -o boot.o
	@echo $(BOOT_LINK)
	@m68k-elf-ld -T $(BOOT_LINK) boot.o -o boot.out
	@m68k-elf-objcopy -O binary boot.out boot.bin
	@m68k-elf-readelf -S boot.out

asm:
	@m68k-elf-objdump -d boot.out

test: pre
	@m68k-elf-as $(FLAGS) $(TEST) -o test.o
	@m68k-elf-ld -T $(APP_LINK) test.o -o test.out # shouldn't matter where we link stuff to, just that it works properly
	@m68k-elf-objcopy -O binary test.out test.bin
	@echo "Test build completed."

app: pre
	@m68k-elf-as $(FLAGS) $(APP) -o app.o
	@m68k-elf-ld -T $(APP_LINK) app.o -o app.out
	@m68k-elf-objcopy -O binary app.out app.bin
	@m68k-elf-readelf -S app.out

pre:
	@echo "Building on: $(UNAME)"

clean:
	@rm -f	{*.out,*.o,*.bin}
