/* not sure about filename extension */
MEMORY
{
  rom (rx) : ORIGIN = 0x0, LENGTH = 128K
  ram (wx) : ORIGIN = 0x20000, LENGTH = 128K 
}

SECTIONS
{
  .rodata : { *(.rodata) }
  . = 0x400;
  .text : { *(.text) }
  .data : { *(.data) }
  .bss : { *(.bss) *(COMMON) }
  /* none of this stuff actually works yet */
}
