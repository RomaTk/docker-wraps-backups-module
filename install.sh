#!/bin/bash

function main() {
    local current_file="${BASH_SOURCE[0]}"
    local current_dir
    local mktemp_file
    
    current_dir="$(dirname "$current_file")"
    [ $? -ne 0 ] && exit 1

    cd "$current_dir" || exit 1
    [ $? -ne 0 ] && exit 1

    mkdir -p "../../env-scripts/not-by-wrap-name"
    [ $? -ne 0 ] && exit 1

    ln -sf "../../$current_dir/env-scripts/not-by-wrap-name/backups" "../../env-scripts/not-by-wrap-name/backups"
    [ $? -ne 0 ] && exit 1

    exit 0
}