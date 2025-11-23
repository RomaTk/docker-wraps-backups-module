#!/bin/bash

function main {
    local target_dir="$1"
    local current_dir="$(pwd)"

    cd "$target_dir"
    [ $? -ne 0 ] && exit 1

    for item in * .*; do
        # The glob pattern '.*' matches '.', '..', and '.gitkeep'. We must skip them.
        if [[ "$item" == "." || "$item" == ".." || "$item" == ".gitkeep" ]]; then
        continue # Skip to the next item in the loop.
        fi

        # Remove the item recursively and forcefully.
        rm -rf "$item"
        [ $? -ne 0 ] && exit 1
    done

    cd "$current_dir"
    [ $? -ne 0 ] && exit 1

    exit 0
}