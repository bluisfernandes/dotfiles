# Dotfiles Setup

This repository contains the configuration files and scripts to set up the environment quickly and easily. 

## Prerequisites
- Linux Ubuntu
- Make sure you have the following packages installed on your system.
  - Git: `sudo apt install git`
  - zsh: `sudo apt install zsh`
  - Oh my zsh: [Oh My Zsh](https://ohmyz.sh/#install)
  - Cargo: `curl https://sh.rustup.rs -sSf | sh`



## Installation

To set up your environment, follow these steps:

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```
2. **Install packages:**
`./install_packages.sh`

3. **Install themes and scripts:**
`./configure.sh`

## Plugins and Themes
- Oh my zsh
  - **zsh-autosuggestions**: `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions` and add 'zsh-autosuggestions' to the list of plugins inside `~/.zshrc`
  - **zsh-syntax-highlighting**: `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting` and add 'zsh-syntax-highlighting' to the list of plugins inside `~/.zshrc`

  - **Power level 10k**: `git clone --depth=1 https://github.com/romkatv/p owerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k` and Set `ZSH_THEME="powerlevel10k/powerlevel10k"` in `~/.zshrc`

  - **Install Fonts**: [MesloLGS NF](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#meslo-nerd-font-patched-for-powerlevel10k) install and set as default in VSCode, Windows Terminal, Tilix.. 

