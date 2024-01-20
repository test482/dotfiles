#! /usr/bin/env bash

# https://wiki.archlinux.org/title/Bubblewrap/Examples#Steam

set -e

STEAM_HOME="$HOME/.local/share/steam_bwrap/cn"

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
	"$XDG_CACHE_HOME/mesa_shader_cache" \
	"$XDG_CACHE_HOME/nv" \
	"$XDG_CACHE_HOME/nvidia" \
	"$XDG_CACHE_HOME/radv_builtin_shaders64" \
	"$XDG_CONFIG_HOME/Epic" \
	"$XDG_CONFIG_HOME/Loop_Hero" \
	"$XDG_CONFIG_HOME/MangoHud" \
	"$XDG_CONFIG_HOME/ModTheSpire" \
	"$XDG_CONFIG_HOME/RogueLegacy" \
	"$XDG_CONFIG_HOME/RogueLegacyStorageContainer" \
	"$XDG_CONFIG_HOME/cef_user_data" \
	"$XDG_CONFIG_HOME/proton" \
	"$XDG_CONFIG_HOME/pulse" \
	"$XDG_CONFIG_HOME/unity3d" \
	"$XDG_DATA_HOME/3909/PapersPlease" \
	"$XDG_DATA_HOME/Colossal Order" \
	"$XDG_DATA_HOME/Dredmor" \
	"$XDG_DATA_HOME/FasterThanLight" \
	"$XDG_DATA_HOME/HotlineMiami" \
	"$XDG_DATA_HOME/IntoTheBreach" \
	"$XDG_DATA_HOME/Paradox Interactive" \
	"$XDG_DATA_HOME/PillarsOfEternity" \
	"$XDG_DATA_HOME/RogueLegacy" \
	"$XDG_DATA_HOME/RogueLegacyStorageContainer" \
	"$XDG_DATA_HOME/Steam" \
	"$XDG_DATA_HOME/SuperHexagon" \
	"$XDG_DATA_HOME/Terraria" \
	"$XDG_DATA_HOME/applications" \
	"$XDG_DATA_HOME/aspyr-media" \
	"$XDG_DATA_HOME/bohemiainteractive" \
	"$XDG_DATA_HOME/cdprojektred" \
	"$XDG_DATA_HOME/feral-interactive" \
	"$XDG_DATA_HOME/frictionalgames" \
	"$XDG_DATA_HOME/icons" \
	"$XDG_DATA_HOME/proton" \
	"$XDG_DATA_HOME/vpltd" \
	"$XDG_DATA_HOME/vulkan" \
	"/var/lib/bluetooth" \
	/run/systemd \
	/tmp/.ICE-unix \
	/tmp/.X11-unix

# fix Steam unable to open a connection to X
if [ -n "$DISPLAY" ]; then
	xhost +si:localuser:$(whoami)
fi

exec bwrap "${args[@]}" /usr/lib/steam/steam "$@"
