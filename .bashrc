#
# ~/.bashrc
#

# PATH
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# if running on WSL, then source cli env config
if [[ $(grep WSL /proc/version) ]]; then
    [ -f $HOME/.config/bash/cli-env.rc ] && source $HOME/.config/bash/cli-env.rc
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias ls='ls --color=auto'
alias ls='exa'

alias ll='ls -l'
alias la='ls -la'
alias lh='ls -lh'
alias lf='ls -F'

alias grep='grep --color'
alias tree='tree -C'

alias k="kde-open5"
alias x="xdg-open"

# less : hightlight (-R) and line number (-N)
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS="-R"

# Git alias
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
# gitmydot
# https://wiki.archlinux.org/title/Dotfiles#Tracking_dotfiles_directly_with_Git
alias gitdot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
[ -f /usr/share/bash-completion/completions/git ] && source /usr/share/bash-completion/completions/git
__git_complete gitdot __git_main

# ranger : A VIM-inspired filemanager for the console
# https://github.com/ranger/ranger/wiki
function _ranger_auto_cd {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )
    
    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}
alias ra='_ranger_auto_cd'
alias sra="sudo -E ranger"

# fzf : A command-line fuzzy finder
# https://github.com/junegunn/fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --border'
export FZF_COMPLETION_TRIGGER='\'
export fzf_preview_cmd='[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --color=always --line-range 0:200 {}) 2> /dev/null'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}" # ^T preview the content of the file
export FZF_CTRL_T_OPTS="--preview '${fzf_preview_cmd}'"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow' # Alt+C cd into the selected directory
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

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
alias bc="bc -lq" # calculator
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

# Set CLI proxy server
# https://wiki.archlinux.org/index.php/Proxy_server#Environment_variables
# also check this repo: (https://github.com/comwrg/FUCK-GFW)
assignProxy(){
    PROXY_ENV="http_proxy ftp_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY"
    for envar in $PROXY_ENV
    do
        export $envar=$1
    done
    for envar in "no_proxy NO_PROXY"
    do
        export $envar=$2
    done
}
clrProxy(){
    PROXY_ENV="http_proxy ftp_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY"
    for envar in $PROXY_ENV
    do
        unset $envar
    done
}
myProxy(){
    # user=YourUserName
    # read -p "Password: " -s pass &&  echo -e " "
    # proxy_value="http://$user:$pass@ProxyServerAddress:Port"
    proxy_value="http://127.0.0.1:7890"
    no_proxy_value="localhost,127.0.0.1,LocalAddress,LocalDomain.com"
    assignProxy $proxy_value $no_proxy_value
}

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
