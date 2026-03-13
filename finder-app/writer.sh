#!/bin/sh

# writer.sh
#
# Accepts two arguments:
# 1. writefile: A full path to a file (including filename) on the filesystem.
# 2. writestr: A text string to be written into the file.
#
# Behavior:
# - Exits with value 1 and prints an error if either argument is not specified.
# - Creates a new file at 'writefile' with content 'writestr'.
# - Overwrites any existing file at 'writefile'.
# - Creates the directory path if it doesn't exist.
# - Exits with value 1 and prints an error if the file could not be created.

# Assign command line arguments to descriptive variables
writefile=$1
writestr=$2

# Check if both arguments were provided
if [ -z "$writefile" ] || [ -z "$writestr" ]; then
    echo "Error: Missing parameters."
    echo "Usage: $0 <writefile> <writestr>"
    exit 1
fi

# Create the directory path if it doesn't exist.
# dirname "$writefile" extracts the directory part of the path.
# -p option prevents error if directory already exists.
mkdir -p "$(dirname "$writefile")"

# Check if the directory creation was successful.
# This is a good practice, though mkdir -p usually succeeds unless permissions are an issue.
if [ $? -ne 0 ]; then
    echo "Error: Could not create directory path for $writefile."
    exit 1
fi

# Write the string to the file, overwriting if it exists.
# The '||' operator executes the block on its right if the command on its left fails.
echo "$writestr" > "$writefile" || {
    echo "Error: Could not create or write to file $writefile."
    exit 1
}

# If we reached here, the operation was successful.
exit 0