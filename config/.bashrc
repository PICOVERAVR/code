# bashrc read when starting subshells

export SHELL=/bin/bash
export EDITOR=/usr/bin/vim

# include .filename in pathname expansion
shopt -s dotglob

export HISTCONTROL=ignoredups
export DIR_STACK=""

# options for color
# same as PS1="\u@\h:\w\$ "
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export PS2="-> "

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export GREP_OPTIONS='--color=auto'

