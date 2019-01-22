# code
Personal projects from almost non-existant to small.
## Looking for working and/or complete projects?
Check the showcase folder!
## On a new dev box:
- set bashrc location
- clone repository: `clone https://www.github.com/PICOVERAVR/code`
- manually point .gitconfig to inside repo: `git config --local include.path ../.gitconfig` in main folder
- checkout and track individual branches: `git checkout --track origin/<branch>`
- link .bashrc and .vimrc files to home directory

## To try:
(product ideas excluded)
### Major Topics:
- 3D graphics/rendering in C (OpenGL)
	- Graphics hardware (OpenGL book has this?)
	- Simple graphics API
	- Graphics software (OpenGL book)
- TCP/IP
	- Raw sockets
	- HTTP/HTTPS using ESP32
	- Embedded HTML
- Learning Scheme (similar to forth!)
- FPGA project that actually benefits from using an FPGA
	- Fives currently in progress
	- Cache behavior / IO
	- Networking basics (token ring, RR, etc)
### Major Projects:
- 68000 system with MMU and DMA, write custom OS for this obviously
	- Need to skip the breadboarding, processor has too many pins.  Use the simplest working computer in the datasheet and modify for my needs
	- Processor, RAM, and boot ROM all need to be socketed, ROM should either be in a removable card or a ZIF socket (maybe both?)
	- Order to add things: Processor, ROM, RAM, IO (UART), DMA, MMU
	- Find a C compiler that supports the 68000 (gcc?) and use it
	- Find a Forth implementation that works on the 68000 and use it (use something existing already!)
- Graphical program in Python
- Doing something major with Go
### Minor Projects:
- Examine features of C++ at asm level
- UART in Verilog
- Low level C / asm with GDB
- Using more modern C
- Learn sed
### Refresher:
- OpenGL
- OpenMP / OpenCL / Pthread
- Git (always more to learn...)
- Anything EE
## Things to fix:
- Fix makefile softlinks everywhere
	- constantly breaking all the time
