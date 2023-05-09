#!/bin/bash

# Set the directory containing the logs
log_directory=""

# Set the target directory for the archives
target_directory=""

# Create the target directory if it doesn't exist
mkdir -p "$target_directory"

# Create a temporary directory to store the daily files
tmp_directory="$(mktemp -d)"

# Loop through all the log files
find "$log_directory" -maxdepth 1 -type f | while read -r file; do
    # Extract the date from the file's modification time
    file_date=$(date -r "$file" +"%Y-%m-%d")

    # Create a subdirectory for the date, if it doesn't exist
    mkdir -p "$tmp_directory/$file_date"

    # Copy the file to the corresponding date subdirectory
    cp "$file" "$tmp_directory/$file_date"
done

# Loop through all the date subdirectories
for date_dir in "$tmp_directory"/*; do
    # Get the date from the directory name
    date_str=$(basename "$date_dir")

    # Convert the date format to DD-MM-YYYY
    formatted_date=$(date -d "$date_str" +"%d-%m-%Y")

    # Create a .tar.gz archive with the specified name format for each day
    tar -czf "$target_directory/Logs-${formatted_date}.tar.gz" -C "$date_dir" .
done

# Remove the temporary directory
rm -rf "$tmp_directory"
