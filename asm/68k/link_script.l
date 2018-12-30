/* not sure about filename extension */
SECTIONS
{
  . = 0x0;
  .rodata : { *(.rodata) }
  . = 0x400;
  .text : { *(.text) }
}
