/* simple m68k link script */
MEMORY
{
  rom (rx) : ORIGIN = 0x0, LENGTH = 128K
  ram (wx) : ORIGIN = 0x20000, LENGTH = 128K
}

SECTIONS
{
  /* room for EVT table */
  .rodata : { *(.rodata) } > rom 
  . = 0x400;
  boot_text : { *(boot_text) } > rom
  .data : { *(.data) } > rom
  .bss : { *(.bss) *(COMMON) } > ram
  /* room for not bootloader code */
  . = 0x10000;
  ram_text : { *(ram_text) } > ram
}
