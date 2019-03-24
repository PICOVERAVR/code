| a small interpreter to facilitate testing of the 68000 board and manipulation of programs
| using the MFP and core code I already wrote
| 
| syntax:
| <command> #<number of args> <arg> <arg>
| number of args is required, other args optional
| comments are in perens, not nested!
| ex:
| > CheckSum #2 0xFF001 128 (checksum 128 bytes including and after 0xFF001)
| 0x45FF3D (the checksum is returned to the interpreter)
| > DumpRegisters #0 (dump all registers)
| D0: 0x0
| D1: 0x1
| ...
| 
| commands:
| - writing stuff into RAM/reading stuff out of RAM (byte, word, longword, block)
| - execute code in RAM, has to have a TRAP at the end of it or control will not be returned to the interpreter!
|  - have a choice of executing code as user or supervisor
| - hardware self-test (RAM, MFP, check if using 68000 or 68010, figure out clock speed somehow)
| - write/read pages to/from EEPROM (block)
| - dump registers/memory/stack (important for 68010 because of future long-form testing)
| - notify user when exceptions occur, and how bad they are

