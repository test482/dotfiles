#! /usr/bin/env bash

# if xdg dir not exist, create it
if [ ! -d $XDG_CACHE_HOME ]; then
    mkdir -p $XDG_CACHE_HOME
fi
if [ ! -d $XDG_CONFIG_HOME ]; then
    mkdir -p $XDG_CONFIG_HOME
fi
if [ ! -d $XDG_DATA_HOME ]; then
    mkdir -p $XDG_DATA_HOME
fi
if [ ! -d $XDG_STATE_HOME ]; then
    mkdir -p $XDG_STATE_HOME
fi

# bash
if [! -d "$XDG_STATE_HOME"/bash]; then
    mkdir -p "$XDG_STATE_HOME"/bash
fi

# simplescreenrecorder
# Will use $XDG_CONFIG_HOME/simplescreenrecorder/ ONLY if it already was created otherwise defaults to ~/.ssr
if [ ! -d "$XDG_CONFIG_HOME/simplescreenrecorder" ]; then
    mkdir -p "$XDG_CONFIG_HOME/simplescreenrecorder"
fi

# wine
if [ ! -d "$XDG_DATA_HOME/wineprefixes" ]; then
    mkdir -p "$XDG_DATA_HOME"/wineprefixes
fi

# pg sql
if [ ! -d "$XDG_CONFIG_HOME/pg" ]; then
    mkdir -p "$XDG_CONFIG_HOME/pg"
fi

# wget
if [ ! -f "$XDG_CONFIG_HOME/wget/wgetrc" ]; then
    mkdir -p "$XDG_CONFIG_HOME/wget"
    touch "$XDG_CONFIG_HOME/wget/wgetrc"
    echo hsts-file \= "$XDG_CACHE_HOME"/wget/wget-hsts >> "$XDG_CONFIG_HOME/wget/wgetrc"
fi
