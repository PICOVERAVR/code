/* simple m68k link script */

/* RAM shouldn't be included because we can't allocate anything there at assemble time */

MEMORY
{
  rom (rx) : ORIGIN = 0x0, LENGTH = 128K
}

SECTIONS
{
  /* room for EVT table */
  .rodata : { *(.rodata) } > rom 
  . = 0x400;
  .text : { *(.text) } > rom
  .data : { *(.data) } > rom
}
