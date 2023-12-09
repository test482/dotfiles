#
# ~/.bashrc
#

# PATH
if [[ ! "${PATH}" =~ "${USER}" ]]; then
    export $(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
fi

export HISTFILE="$XDG_STATE_HOME"/bash/history

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

program_exist() {
    for arg in "$@"; do
        if ! command -v "$arg" >/dev/null 2>&1; then
            return 1
        fi
    done
    return 0
}

#alias ls='ls --color=auto'
if program_exist "exa"; then
    [ -f "$HOME"/.config/bash/exa.sh ] && source "$HOME"/.config/bash/exa.sh
fi

# git
if program_exist "git"; then
    [ -f "$HOME"/.config/bash/git.sh ] && source "$HOME"/.config/bash/git.sh
fi

# ranger : A VIM-inspired filemanager for the console
# https://github.com/ranger/ranger/wiki
if program_exist "ranger"; then
    [ -f "$HOME"/.config/bash/ranger.sh ] && source "$HOME"/.config/bash/ranger.sh
fi

# fzf : A command-line fuzzy finder
# https://github.com/junegunn/fzf
if program_exist "fzf" "fd" "bat"; then
    [ -f "$HOME"/.config/bash/fzf.sh ] && source "$HOME"/.config/bash/fzf.sh
fi

# yarn : A package manager for Node.js
[ -f "$XDG_CONFIG_HOME/yarn/config" ] && alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# nvm : node version manager
[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

# adb
if program_exist "adb"; then
    [ -d "$XDG_DATA_HOME"/android ] && alias adb='HOME="$XDG_DATA_HOME"/android adb'
fi

# source conda alias
[ -f /opt/miniconda/etc/profile.d/conda.sh ] && alias sourceconda='source /opt/miniconda/etc/profile.d/conda.sh'

# Set CLI proxy server
# https://wiki.archlinux.org/index.php/Proxy_server#Environment_variables
# also check this repo: (https://github.com/comwrg/FUCK-GFW)
[ -f "$HOME"/.config/bash/cli-proxy.sh ] && source "$HOME"/.config/bash/cli-proxy.sh

# bash_completion
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# custom conf
[ -f "$HOME"/.config/bash/custom.sh ] && source "$HOME"/.config/bash/custom.sh

alias grep='grep --color'
alias tree='tree -C'

alias k="kde-open5"
alias x="xdg-open"

# less : hightlight (-R) and line number (-N)
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS="-R"

# Basic systemctl usage
alias start="sudo systemctl start"
alias stop="sudo systemctl stop"
alias restart="sudo systemctl restart"
alias status="sudo systemctl status"

# Docker command alias
alias dps='docker container ls --format "table  {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"'
alias dcp="docker-compose"
alias dimageupdate='docker images --format "{{.Repository}}:{{.Tag}}" | grep ':latest' | xargs -L1 docker pull;'

alias .="source"
alias neo="neofetch"
alias cp="cp -i --reflink=auto"
alias ssh="TERM=xterm-256color ssh"
alias bc="bc -lq"                                 # calculator
alias pvb="pv -W -F'All:%b In:%t Cu:%r Av:%a %p'" # monitor the progress of data through a pipe
alias kwin-blur="xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0"
alias kwin-clear="xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -remove _KDE_NET_WM_BLUR_BEHIND_REGION"
alias scrcpy='scrcpy --disable-screensaver --hid-keyboard --stay-awake --turn-screen-off --power-off-on-close'
alias gtar="tar -Ipigz czfv"
alias btar="tar -Ilbzip2 cjfv"
alias 7tar="7z a -mmt"
alias tmux="tmux -2"
alias :q="exit"
alias :w="sync"
alias :x="sync && exit"
alias :wq="sync && exit"

# fars.ee is a temporary deployment of pb by farseerfc
alias pb="curl -F 'c=@-' 'https://fars.ee/'"

# Search for console tips and tricks via https://cheat.sh service.
# https://github.com/chubin/cheat.sh
# example usage: cheat python say hello world
cheat() {
    local query=$(echo "$*" | sed 's@ *$@@; s@^ *@@; s@ @/@; s@ @+@g')
    curl https://cheat.sh/"$query"
}

alias clipboard="xclip -selection clipboard"
alias Ci="clipboard -i"
alias Co="clipboard -o"
alias Copng="Co -target image/png"

# Pacman aliases and functions
alias Syu="sudo pacman -Syu"
alias Rcs="sudo pacman -Rcs"
alias Rs="sudo pacman -Rs"
alias Ss="pacman -Ss"
alias Si="pacman -Si"
alias Sl="pacman -Sl"
alias Sg="pacman -Sg"
alias Qs="pacman -Qs"
alias Qi="pacman -Qi"
alias Qo="pacman -Qo"
alias Ql="pacman -Ql"
alias Qlp="pacman -Qlp"
alias Qm="pacman -Qm"
alias Qn="pacman -Qn"
alias U="sudo pacman -U"
alias F="pacman -F"
alias Fo="pacman -F"
alias Fs="pacman -F"
alias Fl="pacman -Fl"
alias Fy="sudo pacman -Fy"
alias Sy="sudo pacman -Sy"

# paru: aur helper
alias a='paru --noconfirm'
alias Syua="a -Syu"
alias Sya='a -Sy'
alias Ssa="a -Ssa"
alias Sas="a -Ssa"
alias Sia="a -Sai"
alias Sai="a -Sai"

man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;37m") \
        LESS_TERMCAP_md=$(printf "\e[1;37m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;47;30m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[0;36m") \
        man "$@"
}
alias cman="env LANG=zh_CN.UTF-8 man"

# PS1='[\u@\h \W]\$ ' # default style
# PS1='\[\e[1;32m\]\u\[\e[m\]\[\e[0;32m\]@\h\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] ' # farseerfc style
PS1='\[\033]0;\w\007\]\n\[\033[32m\]\D{%R} \u@\[\033[35m\]\h \[\033[33m\]\w\[\033[36m\]\[\033[0m\]\n$ ' # Git Bash for Windows style

# Some Tricks

# Start tmux on every shell login
#if which tmux >/dev/null 2>&1; then
#    #if not inside a tmux session, and if no session is started, start a new session
#    test -z "$TMUX" && (tmux attach -t tmux || tmux new-session -s tmux)
#fi

# Use Trash replace rm
#alias rm='trash-put'
