#!/bin/bash

# Code snippet to be added
code='
# Start of added section
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
# End of added section'

# List of files where we want to add the code (in the current directory)
files=(
    "./.bashrc"
    "./.zshrc"
    # Add other files here if necessary
)

# Function to add the code to a file if not already present
add_code_to_file() {
    local file=$1
    local code=$2

    # Check if the file exists
    if [ -f "$file" ]; then
        # Check if the code is already present in the file
        if ! grep -qF "$code" "$file"; then
            echo "Adding code to $file"
            echo "$code" >> "$file"
        else
            echo "The code is already present in $file"
        fi
    else
        echo "File $file not found. Creating and adding code."
        echo "$code" > "$file"
    fi
}

# Iterate over the list of files and add the code to each
for file in "${files[@]}"; do
    add_code_to_file "$file" "$code"
done

echo "Operation completed."
