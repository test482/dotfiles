#! /usr/bin/env bash

# https://wiki.archlinux.org/title/Bubblewrap/Examples#Steam

set -e

STEAM_HOME="$HOME/.local/share/steam_bwrap"

RUN_USER="$XDG_RUNTIME_DIR"

mkdir -p "$STEAM_HOME"

_bind() {
    _bind_arg=$1
    shift
    for _path in "$@"; do
        args+=("$_bind_arg" "$_path" "$_path")
    done
}

bind() {
    _bind --bind-try "$@"
}

robind() {
    _bind --ro-bind-try "$@"
}

devbind() {
    _bind --dev-bind-try "$@"
}

args=(
    --tmpfs /tmp
    --proc /proc
    --dev /dev
    --dir /etc
    --dir /var
    --dir "$RUN_USER"
    --bind "$STEAM_HOME" "$HOME"
    --dir "$HOME"
    --dir "$XDG_CONFIG_HOME"
    --dir "$XDG_CACHE_HOME"
    --dir "$XDG_DATA_HOME"
    --dir "$XDG_STATE_HOME"
    --symlink /usr/lib /lib
    --symlink /usr/lib /lib64
    --symlink /usr/bin /bin
    --symlink /usr/bin /sbin
    --symlink /run /var/run
)

robind \
    /usr \
    /etc \
    /opt \
    /sys \
    /var/empty \
    /var/lib/alsa \
    /var/lib/dbus \
    "$RUN_USER/systemd/resolve"

devbind \
    /dev/dri \
    /dev/nvidia*

# steam
bind \
    "$HOME/.Xauthority" \
    "$HOME/.local/bin/proton" \
    "$HOME/.pki" \
    "$HOME/.steam" \
    "$HOME/.steampath" \
    "$HOME/.steampid" \
    "$HOME/Downloads" \
    "$HOME/Games" \
    "$RUN_USER"/.mutter-X* \
    "$RUN_USER"/ICE* \
    "$RUN_USER"/dbus* \
    "$RUN_USER"/gnome* \
    "$RUN_USER"/pipewire* \
    "$RUN_USER"/pulse* \
    "$RUN_USER"/wayland* \
    "$RUN_USER/at-spi" \
    "$RUN_USER/bus" \
    "$RUN_USER/dconf" \
    "$RUN_USER/systemd" \
    "$XDG_CACHE_HOME" \
    "$XDG_CONFIG_HOME" \
    "$XDG_DATA_HOME" \
    "$XDG_STATE_HOME" \
    "/var/lib/bluetooth" \
    /run/systemd \
    /tmp/.ICE-unix \
    /tmp/.X11-unix

# fix Steam unable to open a connection to X
if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    xhost +si:localuser:"$(whoami)"
fi

exec bwrap "${args[@]}" /usr/lib/steam/steam "$@"
