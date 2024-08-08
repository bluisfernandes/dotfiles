#!/bin/bash

# Creates a symlink to .aliases
if [ ! -f ~/.aliases ]; then
    echo "creating symlink to .aliases"
    ln -sf $(pwd)/.aliases ~/.aliases
fi


# List of files where we want to add the code (in the current directory)
files=(
    "$HOME/.bashrc"
    "$HOME/.zshrc"
    )

# Code snippet to be added in files
code='
# Start of added section
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
# End of added section'



# Function to add the code to a file if not already present
add_code_to_file() {
    local file=$1
    local code=$2

    # Check if the file exists
    if [ -f "$file" ]; then
        # Check if the code is already present in the file
        if ! grep -qF "~/.aliases" "$file"; then
            echo "Adding code to $file"
            echo "$code" >> "$file"
        else
            echo "The code is already present in $file"
        fi
    else
        echo "File $file not found. Creating and adding code."
        if ! echo "$code" > "$file"; then
            echo "Failed to create or write to $file"
            exit 1
        fi

    fi
}

# Iterate over the list of files and add the code to each
for file in "${files[@]}"; do
    add_code_to_file "$file" "$code"
done
