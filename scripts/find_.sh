#!/bin/zsh

# Default values for arguments
file_name=""
directory="."
target_type="f"

# Parse arguments using getopts
while getopts ":n:d:t:" opt; do
  case $opt in
    n) file_name="$OPTARG";;
    d) directory="$OPTARG";;
    t) target_type="$OPTARG";;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1;;
  esac
done

# Check if the file name argument is provided
if [ -z "$file_name" ]; then
  echo "Please provide a file name using -n option."
  exit 1
fi

# Check if the target type is valid (only f and d are allowed)
if [ "$target_type" != "f" ] && [ "$target_type" != "d" ]; then
  echo "Invalid target type: $target_type. Use 'f' for files or 'd' for directories."
  exit 1
fi

# Find files or directories with the specified name in the provided directory
if [ "$target_type" = "f" ]; then
  selected_files=$(find "$directory" -type f -name "$file_name")
else
  selected_files=$(find "$directory" -type d -name "$file_name")
fi

# Check if any files or directories were found
if [ -n "$selected_files" ]; then
  echo "Files/Dirs found:"
  echo "$selected_files"
else
  echo "No $target_type with the name '$file_name' found in the directory '$directory'."
  exit 1
fi

