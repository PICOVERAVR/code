# code
Personal projects from almost non-existant to small.
## Looking for working and/or complete projects?
Check the showcase folder!
## On a new dev box:
- set bashrc location
- clone repository: `git clone https://www.github.com/PICOVERAVR/code`
- manually point .gitconfig to inside repo: `git config --local include.path ../.gitconfig` in main folder
- checkout and track individual branches: `git checkout --track origin/<branch>`
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
	- first make sure I know how everything works and that it works properly, then try doing more fancy stuff
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
