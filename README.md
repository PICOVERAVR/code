# My things
A variety of personal projects and tidbits from almost non-existant to small.
## Projects:
### In Progress:
Nothing right now...
### On Hold:
- 68000 based microcomputer (m68k branch)
- Custom CPU (simulated in C and will be written in Verilog) (processor branch)
- Forth interpreter, based on jonesforth but re-written for x86-64 (showcase folder)
- Special code formatter for a class that is now done (misc branch)
## Learning:
### Future:
- Languages:
	- Rust
	- Go
	- Scheme
	- something fp
	- sed/awk
- APIs:
	- Vulkan
	- Pthreads
- Topics:
	- Networking basics (token ring, RR, etc)
	- Raw sockets
	- HTTP/HTTPS using ESP32
- Programs:
	- Vivado
	- gdb (more)
### In Progress:
- OpenGL
- Modern C++ (not writing C in C++, as a lot of people do)
### Tabled:
- OpenCL - is being merged into Vulkan, learn that instead
## Setup guide on new hardware:
- set bashrc location
- clone repository: `git --recurse-submodules clone https://www.github.com/PICOVERAVR/code`
- manually point .gitconfig to inside repo: `git config --local include.path ../.gitconfig` in main folder
- add a new remote in order to pull branches besides the master branch: `git remote add origin <url>`
	- use `git remote -v` to verify the "origin" branch is detected.
- pull all other branches into workspace: `git fetch origin`
- checkout and track individual branches: `git checkout --track origin/<branch>`
- link .bashrc and .vimrc files to home directory
## General things to fix:
- Better doc for branches
