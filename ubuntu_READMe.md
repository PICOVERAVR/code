1. fresh install, regular install, no third party drivers
2. if no wifi:
	lspci | grep 0280 (check for wifi hardware)
	sudo apt-get update / upgrade
	sudo apt-get install (kernel stuff kept back)
	sudo apt-get install bcmwl-kernel-source
	(should work now)

3. snap install spotify
	launch with spotify --force-device-scale-factor=2
	enable high quality streaming
	turn off autoplay

4. general settings:
	reverse scroll direction
	set clock to AM/PM
	auto hide and show the dock
	file -> preferences -> behavior -> run executable text files
5. Firefox:
	configure - add synced tabs to menu bar
	select dark theme
	disable all firefox home content
	set default browser to DDG
	turn off one-click search engines
	customize -> toolbars (at bottom) -> bookmark toolbars
6. CLI
	(most of the dev tools I want were installed by bcmwl-kernel-source)
	apt-get install git
	follow git setup instructions in repo
	run sudo dpkg-reconfigure dash and select option not to use dash
	modify .bashrc
		strip out comments
		enable color by uncommenting the force color line
	sudo apt-get install vim (ubuntu version comes with a bunch of options disabled)
	create .vimrc
		set nocompatible to enable arrow keys
		set number for line numbers
		set visualbell, then "set t_vb="
	create .inputrc
		set bell-style none (to turn off bell)

7. Thunderbird Mail
	use <name>@icloud.com
	use app-specific password to get around 2FA
	just google how to list it

8. Signal
	follow linux install instructions

9. NVIDIA driver
	$ sudo apt-add-repository ppa:graphics-drivers/ppa
	$ sudo apt update
	$ sudo apt-get install nvidia-driver-<version>
	open software and updates and select <version>?
	sudo reboot
		remove with "sudo apt --purge autoremove nvidia*"
	
	$ ubuntu-drivers list # will list all available drivers
	check with nvidia--smi
	
	NOTE: Nouveau probably doesn't work properly. Install NVIDIA proprietary driver.
	
?. to fix:
	keyboard backlights - works now?
	battery not full
	takes a while to sleep
	fans spin up when watching youtube
	make gnome faster?

