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

#alias ls='ls --color=auto'
[ -f "$HOME"/.config/bash/exa.sh ] && source "$HOME"/.config/bash/exa.sh

# git
[ -f "$HOME"/.config/bash/git.sh ] && source "$HOME"/.config/bash/git.sh

# yazi: Blazing fast terminal file manager written in Rust
# https://yazi-rs.github.io/docs/installation
[ -f "$HOME"/.config/bash/yazi.sh ] && source "$HOME"/.config/bash/yazi.sh

# fzf : A command-line fuzzy finder
# https://github.com/junegunn/fzf
[ -f "$HOME"/.config/bash/fzf.sh ] && source "$HOME"/.config/bash/fzf.sh

# yarn : A package manager for Node.js
[ -f "$XDG_CONFIG_HOME/yarn/config" ] && alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# fnm : Fast Node Manager
#command -v "fnm" >/dev/null 2>&1 && eval "$(fnm env --use-on-cd)"
fnm() {
    eval "$(/usr/bin/fnm env --use-on-cd)"

    /usr/bin/fnm "$@"
}

# adb
[ -d "$XDG_DATA_HOME"/android ] && alias adb='HOME="$XDG_DATA_HOME"/android adb'

# source conda alias
[ -f /opt/miniconda/etc/profile.d/conda.sh ] && alias sourceconda='source /opt/miniconda/etc/profile.d/conda.sh'

# Set CLI proxy server
# https://wiki.archlinux.org/index.php/Proxy_server#Environment_variables
# also check this repo: (https://github.com/comwrg/FUCK-GFW)
[ -f "$HOME"/.config/bash/cli-proxy.sh ] && source "$HOME"/.config/bash/cli-proxy.sh

# bash_completion
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

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
alias neo="macchina"
alias cp="cp -i --reflink=auto"
alias ssh="TERM=xterm-256color ssh"
alias bc="bc -lq"                                 # calculator
alias pvb="pv -W -F'All:%b In:%t Cu:%r Av:%a %p'" # monitor the progress of data through a pipe
alias kwin-blur="xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0"
alias kwin-clear="xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -remove _KDE_NET_WM_BLUR_BEHIND_REGION"
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

alias clipboard="xclip -selection clipboard"
alias Ci="clipboard -i"
alias Co="clipboard -o"
alias Copng="Co -target image/png"

# device specific conf
[ -f "$HOME"/.config/bash/specific-conf ] && source "$HOME"/.config/bash/specific-conf

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
alias _aur_helper='paru'
alias Syua="_aur_helper -Syu --noconfirm"
alias Sya='_aur_helper -Sy --aur'
alias Ssa="_aur_helper -Ss --aur"
alias Sia="_aur_helper -Si --aur"

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
PS1='\[\033]0;\w\007\]\n\[\033[32m\]\D{%R} \u@\[\033[35m\]\h \[\033[33m\]\w\[\033[36m\]\[\033[0m\]\n$ ' # Git Bash for Windows style
