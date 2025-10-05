#!/bin/bash

function getImageNameWithoutTag {
    local full_image_name="$1"
    local image_name_without_tag

    image_name_without_tag="${full_image_name%%:*}"
    [ $? -ne 0 ] && exit 1

    echo "$image_name_without_tag"

    exit 0
}

function getBackupTags {
    local image_name_without_tag="$1"
    local local_tags

    if [ -z "$image_name_without_tag" ]; then
        echo "Please enter a valid image name without tag" >&2
        exit 1
    fi

    local_tags=$(docker images "$image_name_without_tag" --format "{{.Tag}}")
    [ $? -ne 0 ] && exit 1

    if [ -z "$local_tags" ]; then
        exit 0
    fi

    local_tags="$(echo "$local_tags" | grep -E '^backup\.[0-9]+$')"
    exit_code=$?

    # To check is grep return no results because empty backups
    if [ $exit_code -eq 1 ]; then
        last_action="$(echo "backup.0" | grep -E '^backup\.[0-9]+$')"
        if [ $? -ne 0 ]; then
            echo "Error with grep: $last_action" >&2
            exit 1
        fi
    fi

    if [ -z "$local_tags" ]; then
        exit 0
    fi

    local_tags="$(echo "$local_tags" | sort -t '.' -k2 -n)"
    [ $? -ne 0 ] && exit 1

    echo "$local_tags"

    exit 0
}