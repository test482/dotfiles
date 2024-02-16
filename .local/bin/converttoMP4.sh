#!/usr/bin/env bash

for input_file in $@; do
    # /video/foo.mkv
    base_name=$(basename "$input_file" | cut -d. -f1) # foo
    input_dir=$(dirname "$input_file")                # /video
    output_file="${base_name}.mp4"                    # foo.mp4
    mime_type=$(xdg-mime query filetype "$input_file")

    # skip MP4 video
    if [ "$mime_type" == "video/mp4" ]; then
        notify-send "'$base_name' already be MP4 format, skipping."
        continue
    fi

    # check source file is readable
    if [ ! -r "$input_file" ]; then
        notify-send "'$base_name' is not readable, skipping."
        continue
    fi

    # check source dir is writable
    if [ -w "$input_dir" ]; then
        output_path="$input_dir/${output_file}"
    else
        # fallback to $HOME/Videos
        output_path="$HOME/Videos/${output_file}"
    fi

    # check same name file
    if [ -e "$output_path" ]; then
        notify-send "'$output_file' already exists, skipping."
        continue
    fi

    # ffmpeg
    ffmpeg -i "$input_file" -codec copy "$output_path" && notify-send "Conversion completed" "'$output_path'"
done
