#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <directory-path>"
  exit 1
fi

folder_path="$1"

echo "Folder size:"
du -sh "$folder_path"

folder_name=$(basename "$folder_path")
folder_name_lower=$(echo "$folder_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

rar a "${folder_name_lower}.rar" "$folder_path"

echo "Folder compressed as ${folder_name_lower}.rar"