#!/bin/bash

# Files to be symlinked
files=(
    ".zshrc"
    ".zaliases"
    ".zfunctions"
    ".tmux.conf"
    ".p10k.zsh"
    ".config/pet/config.toml"
    )

# Function to create a symlink with backup
create_symlink() {
    local src_dir="$1"    # Ex: $(pwd)
    local rel_path="$2"   # Ex: .config/pet/config.toml
    local target="$HOME/$rel_path"

    # Garante que a pasta existe
    mkdir -p "(dirname "$target")"

    # Faz o backup caso exista arquivo original
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        local timestamp=$(date +%Y%m%d%H%M%S)
        local backup_file="${target}.bak_${timestamp}"

        cp "$target" "$backup_file"
        echo -e "$target backup created in ${YELLOW}$backup_file${NC}"
    fi

    echo "creating symlink to $rel_path..." 
    ln -sf "$src_dir/$rel_path" "$target"
}

# Define color codes
YELLOW='\033[0;33m'  # Yellow
RED='\033[0;31m'     # Red
GREEN='\033[0;32m'   # Green
NC='\033[0m'         # No Color (reset to default)

# Loop through the array and create symlinks
read -p "Deseja criar os symlinks? (y/N): " reply
if [[ "$reply" =~ ^[Yy]$ ]]; then
    # Loop through the array and create symlinks
    for file in "${files[@]}"; do
        create_symlink "$(pwd)" "$file"
    done
fi

# List of files where we want to add the code (in the current directory)
files=(
    "$HOME/.bashrc"
    "$HOME/.zshrc"
    )

# Code snippet to be added in files
code='
# ----- Start of added section -----

[ -f ~/.zaliases ] && source ~/.zaliases
[ -f ~/.zfunctions ] && source ~/.zfunctions

# ----- End of added section -----
'



# Function to add the code to a file if not already present
add_code_to_file() {
    local file=$1
    local code=$2

    # Check if the file exists
    if [ -f "$file" ]; then
        # Check if the code is already present in the file
        if ! grep -qF "~/.zaliases" "$file"; then
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
read -p "Deseja adicionar o 'source' aos arquivos: ${files[*]} ?(y/N): " reply
if [[ "$reply" =~ ^[Yy]$ ]]; then
    for file in "${files[@]}"; do
        add_code_to_file "$file" "$code"
    done
fi

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