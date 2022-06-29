# XDG DIRs
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_RUNTIME_DIR=/run/user/$UID
export XDG_STATE_HOME=$HOME/.local/state

export PATH=$HOME/.local/bin:$PATH

export EDITOR=vim
export VISUAL=vim

export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java # java config
export CARGO_HOME="$XDG_DATA_HOME"/cargo # rust cargo
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker # docker config
export FFMPEG_DATADIR="$XDG_CONFIG_HOME"/ffmpeg # ffmpeg config
export GOPATH="$XDG_DATA_HOME"/go
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export HISTFILE="$XDG_STATE_HOME"/bash/history # bash history
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc # readline config
export KDEHOME="$XDG_CONFIG_HOME"/kde # kde config
export LESSHISTFILE=$XDG_CACHE_HOME/less/history # less history
export LESSKEY=$XDG_CONFIG_HOME/less/lesskey # less keybindings
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME"/docker-machine # docker-machine storage
export MYSQL_HISTFILE=$XDG_DATA_HOME/mysql_history # mysql history
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc # npm config
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass" # postgresql password file
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf" # postgresql service file
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history" # postgresql history
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc" # postgresql config
export PYENV_ROOT=$XDG_DATA_HOME/pyenv # python env
export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/startup.py # python startup.py
export REDISCLI_HISTFILE="$XDG_DATA_HOME"/redis/rediscli_history # rediscli history
export REDISCLI_RCFILE="$XDG_CONFIG_HOME"/redis/redisclirc # rediscli config
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep/config # ripgrep config
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup # rust rustup
export RXVT_SOCKET="$XDG_RUNTIME_DIR"/urxvtd # urxvtd socket
export TS3_CONFIG_DIR="$XDG_CONFIG_HOME/ts3client" # teamspeak3 client config
export WGETRC=$XDG_CONFIG_HOME/wget/wgetrc # wget config
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default # wine config
