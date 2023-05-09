#!/bin/bash

log_directory=""
target_directory=""
mkdir -p "$target_directory"
tmp_directory="$(mktemp -d)"


find "$log_directory" -maxdepth 1 -type f | while read -r file; do
    file_date=$(date -r "$file" +"%Y-%m-%d")
    mkdir -p "$tmp_directory/$file_date"
    cp "$file" "$tmp_directory/$file_date"
done

for date_dir in "$tmp_directory"/*; do
    date_str=$(basename "$date_dir")
    formatted_date=$(date -d "$date_str" +"%d-%m-%Y")
    tar -czf "$target_directory/Logs-${formatted_date}.tar.gz" -C "$date_dir" .
done

# delete
rm -rf "$tmp_directory"
find "$log_directory" -maxdepth 1 -type f -mtime +15 -exec rm {} \;
