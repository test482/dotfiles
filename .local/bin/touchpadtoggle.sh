#!/bin/sh
# Toggle touchpad status
# Using libinput and xinput

# Use xinput list and do a search for touchpads. Then get the first one and get its id.
device="$(xinput list | grep -Ei 'touchpad|synaptics' | grep -oP 'id=\K\d+' | head -n1)"

# If it was activated disable it and if it wasn't disable it
if [[ "$(xinput list-props "$device" | grep -P ".*Device Enabled.*\K.(?=$)" -o)" == "1" ]]; then
    xinput disable "$device"
    notify-send "Touchpad Disabled" "Your touchpad has been disabled."
else
    xinput enable "$device"
    notify-send "Touchpad Enabled" "Your touchpad has been enabled."
fi
