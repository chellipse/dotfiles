# reload bashrc
alias loadb='source ~/.bashrc'

# color test scripts
alias colorfg='bash ~/.config/scripts/colorfg.sh'
alias colorbg='bash ~/.config/scripts/colorbg.sh'

# weather script
alias weather='bash ~/.config/scripts/weather.sh'


### software specific / T480 Ubuntu LTS
alias logseq='~/Downloads/Logseq-linux-x64-0.9.11/Logseq-linux-x64/Logseq'
#alias emacsc="emacsclient -c -a 'emacs'"

# find shorthand (depreciated)
# alias fhere='find . -iname'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=critical -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# screen locker
alias lock='swaylock -eFl --image ~/Downloads/gothic_painting.jpeg --ring-color 888888 --key-hl-color dddddd --inside-color ffffff00'


### ease of use command stuff
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    # alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=always'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
# alias ll='ls -alF'
# alias la='ls -A'
# alias l='ls -CF'

# exa use
alias ls="exa -F -s Name"
alias ll="exa -l -s Name"
alias la="exa -a -s Name"

# list font families
alias fonts="fc-list :family --format='%{family}\n' | sort -u"


### quick-edit shortcuts
EDITOR='nvim'

# notes/journal files
alias note='$EDITOR ~/note.txt'

# Neorg notes workspace
alias org='nvim -c "Neorg workspace notes"'

# $EDITOR init.vim
alias qeneoinit='$EDITOR ~/.config/nvim/init.vim'

# bash
alias qebash='$EDITOR ~/.bashrc'
alias qealias='$EDITOR ~/.bash_aliases'

# kitty
alias qekitty='$EDITOR ~/.config/kitty/kitty.conf'

# sway window manager
alias qesway='$EDITOR ~/.config/sway/config'

# i3status-rust
alias qersbar='$EDITOR ~/.config/i3status-rust/config.toml'

# ranger config
alias qerc='$EDITOR /home/chell/.config/ranger/rc.conf'
# ranger scope.sh
alias qerscope='$EDITOR /home/chell/.config/ranger/scope.sh'

# dunst
alias qedunst='$EDITOR ~/.config/dunst/dunstrc'

# zathura
alias qezath='$EDITOR ~/.config/zathura/zathurarc'

# vimrc
alias qevimrc='$EDITOR ~/.vimrc'

# i3
alias qei3='$EDITOR ~/.config/i3/config'
alias qei3bar='$EDITOR ~/.config/i3status/config'

# alacritty
alias qealacritty='$EDITOR ~/.config/alacritty/alacritty.toml'

### quick-edit shortcuts
VIM='vim'

# bash
alias qvbash='$VIM ~/.bashrc'
alias qvalias='$VIM ~/.bash_aliases'


# create_aliases() {
#     while [ "$#" -gt 0 ]; do
#         alias_name=$1
#         alias_command=$2
#         alias "$alias_name"="$alias_command"
#         shift 2 done
# }

# create_aliases \
#     ls_long "ls -l" \
#     gs "git status" \
#     cdf "cd ~/Documents"
