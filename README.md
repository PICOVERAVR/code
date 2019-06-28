# code
Personal projects from almost non-existant to small.
## Looking for working and/or complete projects?
Check the showcase folder!
## On a new dev box:
- set bashrc location
- clone repository: `clone https://www.github.com/PICOVERAVR/code`
- manually point .gitconfig to inside repo: `git config --local include.path ../.gitconfig` in main folder
- add a new remote in order to pull branches besides the master branch: `git remote add origin <url>`
	- use `git remote -v` to verify the "origin" branch is detected.
- pull all other branches into workspace: `git fetch origin`
- checkout and track individual branches: `git checkout --track origin/<branch>`
- link .bashrc and .vimrc files to home directory

## To try:
### Major Topics:
- 3D graphics/rendering in C (OpenGL)
	- Graphics hardware
	- Simple graphics API
	- Graphics software
- TCP/IP
	- Networking basics (token ring, RR, etc)
	- Raw sockets
	- HTTP/HTTPS using ESP32
	- Embedded HTML
### Major Projects:
- Learning Scheme (similar to forth!)
- FPGA project that actually benefits from using an FPGA
	- Fives is kind of a waste of time - work on RISC-V instead.
	- Cache behavior / IO
- Graphical program in Python - maybe use PyGame?
- Doing something major with Go
- RISC-V study / possibly extending it somehow at the simulator level if I have a good idea for new instructions
### Minor Projects:
- Examine features of C++ at asm level
- UART in Verilog
- Low level C / asm with GDB
- Using more modern C/C++ (std::anything in detail)
- Learn sed
### Refresher:
- OpenGL
- OpenMP / Pthreads
- Git (always more to learn...)
- Anything EE
## Things to fix:
- Nothing major
