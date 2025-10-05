#!/bin/bash

function isBackupAlreadyExist {
    local image_name_with_tag="$1"
    local image_name_without_tag="$2"
    local backup_tags="$3"

    local image_id
    local image_id_of_backup_tag

    if [ -z "$backup_tags" ]; then
        echo "false"
        exit 0
    fi

    image_id="$(docker image inspect --format='{{.Id}}' "$image_name_with_tag")"
    [ $? -ne 0 ] && exit 1

    for tag in $backup_tags; do
        image_id_of_backup_tag="$(docker image inspect --format='{{.Id}}' "$image_name_without_tag:$tag")"
        [ $? -ne 0 ] && exit 1

        if [ "$image_id" == "$image_id_of_backup_tag" ]; then
            echo "true"
            exit 0
        fi
    done

    echo "false"
    exit 0
}

function createBackupImage {
    local image_name_with_tag="$1"
    local image_name_without_tag="$2"
    local backup_tags="$3"

    local i=1

    for tag in $backup_tags; do
        if [[ "$tag" != "backup.$i" ]]; then
            (docker tag "$image_name_with_tag" "$image_name_without_tag:$tag")
            [ $? -ne 0 ] && exit 1
            
            exit 0
        fi
        i=$((i + 1))
    done

    (docker tag "$image_name_with_tag" "$image_name_without_tag:backup.$i")
    [ $? -ne 0 ] && exit 1

    exit 0
}

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

    is_backup_already_exist="$(isBackupAlreadyExist "$image_name_with_tag" "$image_name_without_tag" "$backup_tags")"
    [ $? -ne 0 ] && exit 1

    if [ "$is_backup_already_exist" == "true" ]; then
        exit 0
    fi

    (createBackupImage "$image_name_with_tag" "$image_name_without_tag" "$backup_tags")
    [ $? -ne 0 ] && exit 1

    exit 0
}
