#!/bin/bash

# Array of package names
packages=(
    "zsh"
    "bat"
    #"grex"
    "exa"
    #"dust"
    "ripgrep"  # 'rg' is installed as 'ripgrep'
    "fd-find"  # 'fd' is installed as 'fd-find'
    "neofetch"
)

# Function to check which packages are already installed
check_installed_packages() {
    installed=()
    not_installed=()

    for package in "${packages[@]}"; do
        if dpkg -l | grep -q "^ii  $package"; then
            installed+=("$package")
        else
            not_installed+=("$package")
        fi
    done

    # Display the packages that are already installed
    if [ ${#installed[@]} -gt 0 ]; then
        echo "The following packages are already installed:"
        for package in "${installed[@]}"; do
            echo -e "  - \e[32m$package\e[0m"  # Green color for installed packages
        done
    else
        echo "No packages are already installed."
    fi

    # Display the packages that will be installed
    if [ ${#not_installed[@]} -gt 0 ]; then
        echo "The following packages will be installed:"
        for package in "${not_installed[@]}"; do
            echo -e "  - \e[33m$package\e[0m"  # Yellow color for packages to be installed
        done
    else
        echo "All specified packages are already installed. Nothing to do."
    fi
}

# Function to display the packages to be installed and ask for confirmation
ask_for_confirmation() {
    check_installed_packages

    if [ ${#not_installed[@]} -eq 0 ]; then
        return 1  # Exit if no packages need to be installed
    fi

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
    for package in "${not_installed[@]}"; do
        echo -e "⬇️  Installing \e[33m$package\e[0m..."
        #sudo apt install "$package"
    done
    echo "Installation complete."
}

# Main script execution
if ask_for_confirmation; then
    install_packages
fi
