#!/bin/bash

function main {
    local image_name_with_tag="$1"
    local image_name_without_tag
    local backup_tags
    local is_backup_already_exist

    if [ -z "$image_name_with_tag" ]; then
        exit 1
    fi

    current_file="${BASH_SOURCE[0]}"

    if [ -z "$current_file" ]; then
        exit 1
    fi

    current_dir="$(dirname "$current_file")"
    [ $? -ne 0 ] && exit 1

    source "$current_dir/utils.sh"
    [ $? -ne 0 ] && exit 1

    image_name_without_tag="$(getImageNameWithoutTag "$image_name_with_tag")"
    [ $? -ne 0 ] && exit 1

    backup_tags="$(getBackupTags "$image_name_without_tag")"
    [ $? -ne 0 ] && exit 1

    if [ -z "$backup_tags" ]; then
        exit 0
    fi

    for tag in $backup_tags; do
        (docker rmi "$image_name_without_tag:$tag")
        [ $? -ne 0 ] && exit 1
    done

    exit 0
}
