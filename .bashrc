# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

SHELL=bash
# TERMINAL=kitty
# QT_QPA_PLATFORM=xcb

export PATH="$HOME/bin:$PATH"

# emacs var
export PATH="$HOME/.emacs.d/bin:$PATH"

# i3 var
export PATH="$HOME/i3status-rust:$PATH"

# bemenu var
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"

# Go var
export PATH="$PATH:/usr/local/go/bin"

# less color variables
export LESS_TERMCAP_mb=$'\E[38;5;3m'
export LESS_TERMCAP_md=$'\E[38;5;12m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[48;5;15;38;5;0m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[38;5;2m'

# use nvim as your pager
# export MANPAGER='nvim +Man!'

# ranger variables
export TERMCMD=kitty
export VISUAL=nvim

# helix var
export HELIX_RUNTIME=~/src/helix/runtime

fnv() {
    find . -iname "$1" | xargs nvim
}

fn() {
    find . -iname "*$1*"
}

freg() {
    find . -iregex ".*$1.*"
}

tgz() {
    tar -cz -f "$2.tar.gz" "$1"
}

txz() {
    tar -cJ -f "$2.tar.xz" "$1"
}

fzv() {
    local file
    file=$(fzf)  # Run fzf and capture its output
    if [ -n "$file" ]; then  # Check if the output is non-empty
        nvim "$file"  # Open the selected file with nvim
    else
        echo "No file selected."
    fi
}

# You can then call this function like this:
# fzf_to_nvim

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Color codes
BLACK="\e[38;5;0m"
RED="\e[38;5;1m"
GREEN="\e[38;5;2m"
YELLOW="\e[38;5;3m"
BLUE="\e[38;5;4m"
MAGENTA="\e[38;5;5m"
CYAN="\e[38;5;6m"
WHITE="\e[38;5;7m"
RESET="\e[0m"
# with escapes
# BLACK="\[\e[38;5;0m\]"  
# RED="\[\e[38;5;1m\]"
# GREEN="\[\e[38;5;2m\]"
# YELLOW="\[\e[38;5;3m\]"
# BLUE="\[\e[38;5;4m\]"
# MAGENTA="\[\e[38;5;5m\]"
# CYAN="\[\e[38;5;6m\]"
# WHITE="\[\e[38;5;7m\]"
# RESET="\[\e[0m\]"
# \[\]
#\[\e[38;5;1m\]c\[\e[38;5;2m\]h\[\e[38;5;3m\]e\[\e[38;5;4m\]l\[\e[38;5;5m\]l

# color_username() {
#     local user="$1"
#     local colors=($RED $GREEN $YELLOW $BLUE $MAGENTA $CYAN $WHITE)
#     local result=""
#     local index=0

#     for (( i=0; i<${#user}; i++ )); do
#         char="${user:$i:1}"
#         result+="${colors[$index]}$char"
#         index=$(( (index + 1) % ${#colors[@]} ))
#     done

#     echo -ne "$result"
# }

color_prompt=yes
if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # PS1='$(color_username \u)\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # PS1='\e[38;5;7;48;5;235m\u \e[0m\e[38;5;7;48;5;8m: \e[0m\e[38;5;0;48;5;8m\w\e[0m \e[38;5;7;48;5;0m$\e[0m '
    # PS1='\e[38;5;2;48;5;0m\u:\w\e[0m $ '
    # PS1='\e[48;5;0m$(color_username \u)\e[38;5;7;48;5;0m :\w\e[0m $ '
    # PS1="\[\e[48;5;0m\]$(color_username \u)\[\e[38;5;7;48;5;0m\] :\w\[\e[0m\] $ "
    # PS1='$(color_username \u) $ '
    # PS1='\[\e[48;5;0m\]\[\e[38;5;1m\]c\[\e[38;5;2m\]h\[\e[38;5;3m\]e\[\e[38;5;4m\]l\[\e[38;5;5m\]l-\u\[\e[38;5;7;48;5;0m\] :\w\[\e[0m\] $ '
    # PS1='\[\e[38;5;1m\]c\[\e[38;5;2m\]h\[\e[38;5;3m\]e\[\e[38;5;4m\]l\[\e[38;5;5m\]l-\u\[\e[38;5;7;48;5;0m\] :\w\[\e[0m\] $ '
    PS1='\[\e[38;5;12m\]\u\[\e[0m\]@\[\e[38;5;10m\]\t:\[\e[38;5;7;48;5;0m\] :\w\[\e[0m\] $ '
    PS1='\[\e[38;5;12m\]\u\[\e[0m\]@\[\e[38;5;10m\]\t:\[\e[38;5;7m\] :\w\[\e[0m\] $ '
else
    # PS1='\[\033[01;32m\]test\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\u:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

## enable color support of ls and also add handy aliases
#if [ -x /usr/bin/dircolors ]; then
#    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
#    alias ls='ls --color=auto'
#    alias dir='dir --color=auto'
#    alias vdir='vdir --color=auto'

#    alias grep='grep --color=always'
#    alias fgrep='fgrep --color=auto'
#    alias egrep='egrep --color=auto'
#fi

## colored GCC warnings and errors
##export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

## some more ls aliases
#alias ll='ls -alF'
#alias la='ls -A'
#alias l='ls -CF'

## Add an "alert" alias for long running commands.  Use like so:
##   sleep 10; alert
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# source Alias file
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

. "$HOME/.cargo/env"
source ~/.bash_completion/alacritty

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
