#!/bin/sh

# finder.sh
#
# Accepts two runtime arguments:
# 1. filesdir: A path to a directory on the filesystem.
# 2. searchstr: A text string to be searched within files in 'filesdir' and its subdirectories.
#
# Behavior:
# - Exits with return value 1 and prints an error if any of the parameters are not specified.
# - Exits with return value 1 and prints an error if 'filesdir' does not represent a directory.
# - Prints a message "The number of files are X and the number of matching lines are Y"
#   where X is the number of files in 'filesdir' and its subdirectories,
#   and Y is the total number of matching lines found in those files.

# Assign command line arguments to descriptive variables
filesdir=$1
searchstr=$2

# Exits with return value 1 and print statements if any of the parameters above were not specified
if [ -z "$filesdir" ] || [ -z "$searchstr" ]; then
    echo "Error: Missing parameters."
    echo "Usage: $0 <filesdir> <searchstr>"
    exit 1
fi

# Exits with return value 1 and print statements if filesdir does not represent a directory on the filesystem
if [ ! -d "$filesdir" ]; then
    echo "Error: '$filesdir' is not a directory."
    exit 1
fi

# Initialize counters
num_files=0
num_matching_lines=0

# Find all files in the specified directory and its subdirectories
# and process them to count files and matching lines.
# Using 'find ... -print0 | xargs -0 grep -l' for file count
# and 'find ... -exec grep -c {} +' for line count is generally more efficient
# for large numbers of files than a 'while read' loop.
# However, for simplicity and compatibility with basic 'sh', the loop is fine.

# Count the number of files
num_files=$(find "$filesdir" -type f | wc -l)

# Count the number of matching lines
# We use 'grep -r' for recursive search, '-s' to suppress error messages for unreadable files,
# and '-c' to count lines. '2>/dev/null' redirects any errors from grep itself.
# The 'awk' command then sums up all the counts from grep.
# If no files are found or no matches, grep might not output anything, or output 0s.
# 'awk' handles this gracefully.
num_matching_lines=$(grep -r "$searchstr" "$filesdir" 2>/dev/null | wc -l)

# Print the final result
echo "The number of files are $num_files and the number of matching lines are $num_matching_lines"

exit 0