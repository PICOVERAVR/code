# My things
A variety of personal projects and tidbits from almost non-existant to small.
## Projects:
### Major Ideas:
- TCP/IP C stuff
	- Networking basics (token ring, RR, etc)
	- Raw sockets
	- HTTP/HTTPS using ESP32
	- Embedded HTML
- FPGA project that actually benefits from using an FPGA
	- Get RISC-V to work on the Artix board I have, extend the ISA
	- Cache behavior / IO
	- Make it fast
- Embedded OpenGL implementation
	- Start this once I finish learning OpenGL
	- Target OpenGL ES 1.1 Common Lite spec and go from there
### Minor Ideas:
- Examine features of C++ at asm level
- Low level C / asm with GDB
### In Progress:
Nothing right now, just learning
### On Hold:
- 68000 based microcomputer (m68k branch)
- Custom CPU (simulated in C and will be written in Verilog) (processor branch)
- Forth interpreter, based on jonesforth but re-written for x86-64 (showcase folder)
- Special code formatter for a class that is now done (showcase folder)
## Learning:
### Future:
- Languages:
	- Rust
	- Go
	- Scheme
	- something fp
	- sed/awk
- Other:
	- Vulkan
### In Progress:
- OpenGL
- Modern C++
### Tabled:
- Computer Architectures
	- RISC-V
	- x86-64
	- 68000
	- Patterson book
- OpenMP / Pthreads / OpenCL
- More Git
## Setup guide on new hardware:
- set bashrc location
- clone repository: `clone https://www.github.com/PICOVERAVR/code`
- manually point .gitconfig to inside repo: `git config --local include.path ../.gitconfig` in main folder
- add a new remote in order to pull branches besides the master branch: `git remote add origin <url>`
	- use `git remote -v` to verify the "origin" branch is detected.
- pull all other branches into workspace: `git fetch origin`
- checkout and track individual branches: `git checkout --track origin/<branch>`
- link .bashrc and .vimrc files to home directory
## General things to fix:
- Better doc for branches
