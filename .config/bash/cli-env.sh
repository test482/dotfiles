# XDG DIRs
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_RUNTIME_DIR=/run/user/$UID

export PATH=$HOME/.local/bin:$PATH

export EDITOR=vim
export VISUAL=vim

# bash_history
export HISTFILE=${XDG_DATA_HOME}/bash/history
# python startup.py
export PYTHONSTARTUP=${XDG_CONFIG_HOME}/python/startup.py
# mysql history
export MYSQL_HISTFILE=${XDG_DATA_HOME}/mysql_history
# less
export LESSKEY=${XDG_CONFIG_HOME}/less/lesskey
export LESSHISTFILE=${XDG_CACHE_HOME}/less/history
# wget
# For wget-hsts, need run: echo hsts-file \= "$XDG_CACHE_HOME"/wget/wget-hsts >> "$XDG_CONFIG_HOME/wget/wgetrc"
export WGETRC=${XDG_CONFIG_HOME}/wget/wgetrc
# cargo
export CARGO_HOME="$XDG_DATA_HOME"/cargo
# rustup
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
