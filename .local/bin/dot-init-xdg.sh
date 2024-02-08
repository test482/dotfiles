#! /usr/bin/env bash

_init_xdg_dir() {
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
}

_copy_pacman_conf_to_etc() {
    sudo cp $HOME/.config/pacman/pacman.conf /etc/pacman.conf &&
        sudo cp -r $HOME/.config/pacman/pacman.d /etc/
}

_init_archlinuxcn_repo() {
    # if /etc/pacman.conf have [archlinuxcn] line
    if grep -q '\[archlinuxcn\]' /etc/pacman.conf; then
        sudo pacman -Sy archlinuxcn-keyring
    fi

}

_init_arch4edu_repo() {
    # if /etc/pacman.conf have [arch4edu] line
    if grep -q '\[arch4edu\]' /etc/pacman.conf; then
        # import GPG key
        sudo pacman-key --recv-keys 7931B6D628C8D3BA &&
            sudo pacman-key --finger 7931B6D628C8D3BA &&
            sudo pacman-key --lsign-key 7931B6D628C8D3BA
    fi
}

_pull_github_keys() {
    $HOME/.local/bin/pull-github-keys.sh
}

_enable_user_systemd_services() {
    systemctl --user enable --now ssh-agent.service
    systemctl --user enable --now pull-github-keys.timer
}

_init_some_apps_xdg() {
    # bash
    if [ ! -d "$XDG_STATE_HOME"/bash ]; then
        mkdir -p "$XDG_STATE_HOME"/bash && touch "$XDG_STATE_HOME"/bash/history
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

    # wget
    if [ ! -f "$XDG_CONFIG_HOME/wget/wgetrc" ]; then
        mkdir -p "$XDG_CONFIG_HOME/wget" &&
            touch "$XDG_CONFIG_HOME/wget/wgetrc" &&
            echo hsts-file \= "$XDG_CACHE_HOME"/wget/wget-hsts >>"$XDG_CONFIG_HOME/wget/wgetrc"
    fi
}

# main
_copy_pacman_conf_to_etc
_init_archlinuxcn_repo
_init_arch4edu_repo
_pull_github_keys
_enable_user_systemd_services
_init_some_apps_xdg
