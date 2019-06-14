set nocompatible " enable extra VIM features
set number " enable number lines
set novisualbell " turn off audible bells
set noerrorbells " turn off error bells
set t_vb= " same as above
set tabstop=4 " tabs = 4 spaces

set ignorecase " ignore case when searching
set smartcase " better case matching

set ai " autoindent

set nomodeline " modeline currently has a security vuln allowing arbitrary code execution

syntax enable " enable syntax highlighting

try " try to enable desert colorscheme, do nothing if it fails
	colorscheme desert
catch
endtry

" pathogen pulls in vim plugins every time you start vim
" in order to pull in a plugin, put it in .vim/bundle/<package name> and restart vim

try " execute pathogen, if installed
	execute pathogen#infect()
catch
endtry
