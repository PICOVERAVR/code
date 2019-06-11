set fish_greeting "" # turn off greeting when starting a new shell
function fish_prompt
	set_color 33CCCC # turquoise
	echo -n (whoami) # username
	set_color normal
	echo -n "@"
	set_color $fish_color_cwd
	echo -n (pwd | sed "s|^$HOME|~|") # pwd, but replace home dir with '~'
	set_color normal
	echo -n "> "
end
