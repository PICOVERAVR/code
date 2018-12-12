# Setup Instructions
## These are only valid for Ubuntu 18.10
1. Install Ubuntu, full install, uncheck "install third party drivers" box
2. if no wifi:
	- `lspci | grep 0280` to check for wifi hardware
	- `sudo apt-get update && sudo apt-get upgrade`
	- `sudo apt-get install (kernel stuff kept back)`
	- `sudo apt-get install bcmwl-kernel-source`

3. snap install spotify
	- launch with spotify --force-device-scale-factor=2
	- enable high quality streaming
	- turn off autoplay

4. general settings:
	- reverse scroll direction
	- set clock to AM/PM
	- auto hide and show the dock
	- file -> preferences -> behavior -> run executable text files
5. Firefox:
	- configure - add synced tabs to menu bar
	- select dark theme
	- disable all firefox home content
	- set default browser to DDG
	- turn off one-click search engines
	- customize -> toolbars (at bottom) -> bookmark toolbars
6. CLI
	(most of the dev tools I want were installed by bcmwl-kernel-source)
	- make font size smaller (size 10)
	- apt-get install git
	  - follow git setup instructions in repo
	- run sudo dpkg-reconfigure dash and select option not to use dash
	- modify .bashrc
	  - strip out comments
	  - enable color by uncommenting the force color line
	  - add export EDITOR=/usr/bin/vim
	- sudo apt-get install vim (ubuntu version comes with a bunch of options disabled)
	  - link vimrc from config directory
	- create .inputrc, write `set bell-style none` to turn off bell

7. Thunderbird Mail
	- use \<name\>@icloud.com
	- use app-specific password to get around 2FA

8. NVIDIA driver
	```
	$ sudo apt-add-repository ppa:graphics-drivers/ppa
	$ sudo apt update
	$ sudo apt-get install nvidia-driver-<version>
	$ sudo reboot
	```
	- open software and updates and select \<version\>
	
	- `sudo apt --purge autoremove nvidia*` to removes nvidia driver
	
	- `$ ubuntu-drivers list` will list all available drivers
	- `$ nvidia-smi`
	
10. to fix:
	- battery not full
	- takes a while to sleep
	- fans spin up when watching youtube
	  - driver problem?
	  - not an iGPU problem
	- `prime-select <intel/nvidia>` breaks everything, never type this
	- make gnome faster?

