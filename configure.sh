#!/bin/bash

# Creates a symlink to .aliases
if [ ! -f ~/.aliases ]; then
    echo "creating symlink to .aliases..."
    ln -sf $(pwd)/.aliases ~/.aliases
fi

# Define color codes
YELLOW='\033[0;33m'  # Yellow
RED='\033[0;31m'     # Red
GREEN='\033[0;32m'   # Green
NC='\033[0m'         # No Color (reset to default)

# Creates a symlink to .zshrc
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.bak
    echo -e ".zshrc backup created in ${YELLOW}~/.zshrv.bak${NC}"
fi
    echo "creating symlink to .zshrc..." 
    ln -sf $(pwd)/.zshrc ~/.zshrc


# Creates a symlink to .p10k.zsh
if [ -f ~/.p10k.zsh ]; then
    cp ~/.p10k.zsh ~/.p10k.zsh.bak
    echo -e ".p10k.zsh backup created in ${YELLOW}~/.p10k.zsh.bak${NC}"
fi  
    echo "creating symlink to .p10k.zsh..."  
    ln -sf $(pwd)/.p10k.zsh ~/.p10k.zsh


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


# Check the current default shell
current_shell=$(echo $SHELL)

# Check the path to zsh
zsh_path=$(which zsh)

# Compare current shell with zsh
if [ "$current_shell" != "$zsh_path" ]; then
    echo "Changing the default shell to zsh..."
    chsh -s "$zsh_path"
    
    # Verify if the change was successful
    if [ $? -eq 0 ]; then
        echo "Default shell successfully changed to zsh. Please log out and log back in."
    else
        echo "Failed to change the default shell."
    fi
fi