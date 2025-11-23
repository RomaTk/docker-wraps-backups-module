#!/bin/bash

function main {
    local image_name="$1"
    local folder="$2"
    

    local image_id
    local save_file_path

    if [ -z "$folder" ] || [ -z "$image_name" ]; then
        echo "Usage: $0 <folder> <image_name>" >&2
        exit 1
    fi

    image_id=$(docker images -q "$image_name" 2> /dev/null)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to retrieve image ID for '$image_name'." >&2
        exit 1
    fi

    if [ -z "$image_id" ]; then
        echo "Error: Image '$image_name' not found." >&2
        exit 1
    fi

    if [ ! -d "$folder" ]; then
        mkdir -p "$folder"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to create directory '$folder'." >&2
            exit 1
        fi
    fi

    save_file_path="$folder/$image_id.tar"

    if [ -f "$save_file_path" ]; then
        echo "File '$save_file_path' already exists. Skipping save."
        exit 0
    fi

    date_now=$(date +%s)
    new_image_name="$image_name-$date_now"

    (docker image tag "$image_name" "$new_image_name")
    if [ $? -ne 0 ]; then
        echo "Error: Failed to tag image '$image_name' as '$new_image_name'." >&2
        exit 1
    fi

    (docker save -o "$save_file_path" "$new_image_name")
    if [ $? -ne 0 ]; then
        echo "Error: Failed to save image '$image_name'." >&2
        exit 1
    fi

    (docker rmi -f "$new_image_name")
    if [ $? -ne 0 ]; then
        echo "Error: Failed to remove temporary image '$new_image_name'." >&2
        exit 1
    fi

    exit 0
}