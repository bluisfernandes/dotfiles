#!/bin/bash

# Define color codes
YELLOW='\033[0;33m'  # Yellow
RED='\033[0;31m'     # Red
GREEN='\033[0;32m'   # Green
NC='\033[0m'         # No Color (reset to default)

# Function to display installed and to-be-installed packages
function display_packages {
    echo -e "${YELLOW}The following packages are already installed:${NC}"
    for package in "${already_installed_apt_packages[@]}"; do
        echo "- ${package}"
    done
    for package in "${already_installed_cargo_packages[@]}"; do
        echo "- ${package} (via Cargo)"
    done
    
    echo -e "${YELLOW}The following packages will be installed:${NC}"
    for package in "${to_install_apt_packages[@]}"; do
        echo "- ${package} (via apt)"
    done
    for package in "${to_install_cargo_packages[@]}"; do
        echo "- ${package} (via Cargo)"
    done
    echo ""
}

# Function to check installed packages
function check_installed_packages {
    # Check installed apt packages
    for package in "${apt_packages[@]}"; do
        if dpkg -l | grep -q "^ii  $package "; then
            already_installed_apt_packages+=("$package")
        else
            to_install_apt_packages+=("$package")
        fi
    done

    # Check installed Cargo packages
    for package in "${cargo_packages[@]}"; do
        if command -v "$package" >/dev/null 2>&1; then
            already_installed_cargo_packages+=("$package")
        else
            to_install_cargo_packages+=("$package")
        fi
    done
}

# Function to install Cargo packages
function install_cargo_packages {
    for package in "${to_install_cargo_packages[@]}"; do
        echo -e "${YELLOW}Installing $package via Cargo...${NC}"
        cargo install "$package"
        if command -v "$package" >/dev/null 2>&1; then
            echo -e "${GREEN}$package${NC} installed successfully."
        else
            echo -e "${RED}Failed to install $package${NC}."
            fail+=("$package - cargo")
        fi
    done
}

# Function to install apt packages
function install_apt_packages {
    for package in "${to_install_apt_packages[@]}"; do
        echo -e "${YELLOW}Installing $package via apt...${NC}"
        sudo apt install -y "$package"
        if command -v "$package" >/dev/null 2>&1; then
            echo -e "${GREEN}$package${NC} installed successfully."
        else
            echo -e "${RED}Failed to install $package${NC}."
            fail+=("$package - apt")
        fi
    done
}

# Function to display packages that failed to install
function display_packages_summary {
    if [ ${#fail[@]} -gt 0 ]; then
        echo -e "${RED}The following packages failed to install:${NC}"
        for package in "${fail[@]}"; do
            echo "- ${package}"
        done
    else
        echo -e "${GREEN}All specified packages were installed successfully.${NC}"
    fi
}

# Define the list of packages to install via apt
apt_packages=(
    "zsh"
    "bat"
    "ripgrep"  # 'rg' is installed as 'ripgrep'
    "fd-find"  # 'fd' is installed as 'fd-find'
    "neofetch"
)

# Define packages to be installed via Cargo
cargo_packages=(
    "exa"
    "grex"
    "dust"
)

# Arrays to keep track of installed and to-be-installed packages
already_installed_apt_packages=()
already_installed_cargo_packages=()
to_install_apt_packages=()
to_install_cargo_packages=()
fail=()

# Main script execution
check_installed_packages
display_packages

# Ask for confirmation to proceed
read -p "Do you want to proceed? (y/n): " choice
if [[ "$choice" != "y" ]]; then
    echo "Installation aborted."
    exit 1
fi

# Install the packages
install_cargo_packages
install_apt_packages

# Display installation results
display_packages_summary

