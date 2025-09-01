#
# ~/.bashrc
#

export HISTFILESIZE=5000
export HISTSIZE=5000
shopt -s histappend

# PATH
if [[ ! "${PATH}" =~ "${USER}" ]]; then
  export $(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias ls='ls --color=auto'
[ -f "$XDG_CONFIG_HOME"/bash/exa.sh ] && source "$XDG_CONFIG_HOME"/bash/exa.sh

# git
[ -f "$XDG_CONFIG_HOME"/bash/git.sh ] && source "$XDG_CONFIG_HOME"/bash/git.sh

# yazi: Blazing fast terminal file manager written in Rust
# https://yazi-rs.github.io/docs/installation
[ -f "$XDG_CONFIG_HOME"/bash/yazi.sh ] && source "$XDG_CONFIG_HOME"/bash/yazi.sh

# fzf : A command-line fuzzy finder
# https://github.com/junegunn/fzf
[ -f "$XDG_CONFIG_HOME"/bash/fzf.sh ] && source "$XDG_CONFIG_HOME"/bash/fzf.sh

# yarn : A package manager for Node.js
[ -f "$XDG_CONFIG_HOME/yarn/config" ] && alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# fnm : Fast Node Manager
#command -v "fnm" >/dev/null 2>&1 && eval "$(/usr/bin/fnm env --use-on-cd --shell bash)"
fnm() {
  [[ "${PATH}" =~ "fnm" ]] || eval "$(/usr/bin/fnm env --use-on-cd --shell bash)"

  /usr/bin/fnm "$@"
}

# adb
[ -d "$XDG_DATA_HOME"/android ] && alias adb='HOME="$XDG_DATA_HOME"/android adb'

# Set CLI proxy server
# https://wiki.archlinux.org/index.php/Proxy_server#Environment_variables
# also check this repo: (https://github.com/comwrg/FUCK-GFW)
[ -f "$XDG_CONFIG_HOME"/bash/cli-proxy.sh ] && source "$XDG_CONFIG_HOME"/bash/cli-proxy.sh

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

alias ustart="systemctl --user start"
alias ustop="systemctl --user stop"
alias urestart="systemctl --user restart"
alias ustatus="systemctl --user status"

# Docker command alias
alias dps='docker container ls --format "table  {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"'

alias .="source"
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

# Pacman aliases and functions
function Syu() {
  sudo pacman -Syu "$@" && sync --file-system /
  pacman -Qtdq | ifne sudo pacman -Rcs - && sync --file-system /
  sudo pacman -Fy && sync --file-system /
  pacdiff --output
}
alias Rcs="sudo pacman -Rcs"
alias Rs="sudo pacman -Rs"
alias Ss="pacman -Ss"
alias Si="pacman -Si"
alias Sl="pacman -Sl"
alias Sg="pacman -Sg"
alias Sy="sudo pacman -Sy"
function Qs() {
  if [ $# -eq 0 ]; then
    pacman -Qq | fzf --preview 'pacman -Qil {}' | ifne sh -c 'pacman -Qil - | view'
  else
    pacman -Qs "$@"
  fi
}
alias Qi="pacman -Qi"
alias Qo="pacman -Qo"
alias Ql="pacman -Ql"
alias Qlp="pacman -Qlp"
alias Qm="pacman -Qm"
alias Qn="pacman -Qn"
alias U="sudo pacman -U"
# pacfiles: A pacman -F alternative that runs blazingly fast
alias F="pacfiles -F"
alias Fo="pacfiles -F"
alias Fl="pacfiles -Fl"
alias Fy="sudo pacfiles -Fy"

# paru: aur helper
alias _aur_helper='paru'
alias Syua="_aur_helper -Syu --aur"
alias Sya="_aur_helper -Sy --aur"
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

# zoxide : A smarter cd command.
export _ZO_EXCLUDE_DIRS="$HOME:/mnt/*:/tmp/*:/run/*"
command -v "zoxide" >/dev/null 2>&1 && eval "$(zoxide init bash --cmd cd)"

# device specific conf
[ -f "$XDG_CONFIG_HOME"/bash/specific-conf ] && source "$XDG_CONFIG_HOME"/bash/specific-conf
