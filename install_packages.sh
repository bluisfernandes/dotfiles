#!/bin/bash

# Array of package names
packages=(
    "bat"
    "grex"
    "exa"
    "dust"
    "ripgrep"  # 'rg' is installed as 'ripgrep'
    "fd-find"  # 'fd' is installed as 'fd-find'
    "neofetch"
)

# Function to display the packages to be installed and ask for confirmation
ask_for_confirmation() {
    echo "The following packages will be installed:"
    for package in "${packages[@]}"; do
        echo "  - $package"
    done

    read -p "Do you want to proceed with the installation? (y/n): " answer
    case $answer in
        [Yy]* )
            return 0
            ;;
        [Nn]* )
            echo "Installation cancelled."
            return 1
            ;;
        * )
            echo "Invalid response. Please enter 'y' or 'n'."
            return 2
            ;;
    esac
}

# Function to install packages
install_packages() {
    echo "Starting installation..."
    for package in "${packages[@]}"; do
        echo -e "⬇️  Installing \e[33m$package\e[0m..."
        #sudo apt install "$package"
    done
    echo "Installation complete."
}

# Main script execution
if ask_for_confirmation; then
    install_packages
fi
