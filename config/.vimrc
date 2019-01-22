set nocompatible " enable extra VIM features
set number " enable number lines
set novisualbell " turn off audible bells
set noerrorbells " turn off error bells
set t_vb= " same as above
set tabstop=4 " tabs = 4 spaces

set ignorecase " ignore case when searching
set smartcase " better case matching

set showmatch " show matching brackets when text indicator is over them

set ai " autoindent

syntax enable " enable syntax highlighting

try " try to enable desert colorscheme, do nothing if it fails
	colorscheme desert
catch
endtry
