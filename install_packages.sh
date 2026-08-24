#!/bin/bash

# 1. Definição de pacotes

APT_PKGS=("zsh" "fastfetch" "curl" "wget" "git" "build-essential" "fzf" "fd-find" "jq" "btop" "tmux" "flatpak" "micro" "picocom" "cowsay" "fortune" "calcurse" "taskwarrior")
CARGO_PKGS=("ripgrep" "bat" "eza" "tldr") 
FLATPAK_PKGS=("com.bitwarden.desktop" "com.visualstudio.code" "md.obsidian.Obsidian")

# Dicionário para scripts de instalação via curl/wget
declare -A CUSTOM_CMDS
CUSTOM_CMDS=(
    ["oh-my-zsh"]="sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"\" --unattended"
    ["rustup"]="curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
    ["uv"]="curl -LsSf https://astral.sh/uv/install.sh | sh"
    ["zoxide"]="curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh"
    ["pet"]="URL=\$(curl -s https://api.github.com/repos/knqyf263/pet/releases/latest | grep 'browser_download_url.*linux_amd64.tar.gz' | cut -d '\"' -f 4) && wget -qO /tmp/pet.tar.gz \"\$URL\" && tar -xzf /tmp/pet.tar.gz -C /tmp && sudo mv /tmp/pet /usr/local/bin/ && rm /tmp/pet*"
    ["lazygit"]="LAZYGIT_VERSION=\$(curl -s \"https://api.github.com/repos/jesseduffield/lazygit/releases/latest\" | grep -Po '\"tag_name\": \"v\\K[^\"]*') && curl -Lo lazygit.tar.gz \"https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_\${LAZYGIT_VERSION}_Linux_x86_64.tar.gz\" && tar xf lazygit.tar.gz lazygit && sudo install lazygit -D -t /usr/local/bin/ && rm lazygit.tar.gz lazygit"
    ["esptool"]="uv tool install esptool"
    ["mpremote"]="uv tool install mpremote"
    ["shell-gpt"]="uv tool install shell-gpt"
)

# Define color codes
YELLOW='\033[0;33m'  # Yellow
RED='\033[0;31m'     # Red
GREEN='\033[0;32m'   # Green
NC='\033[0m'         # No Color (reset to default)

# Garante Flathub
if command -v flatpak &> /dev/null; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

echo "Analisando o sistema..."

AVAILABLE=()
INSTALLED=()

check_install() {
    if command -v "$1" &> /dev/null || dpkg -l | grep -q -w "^ii  $1 " 2>/dev/null; then
        INSTALLED+=("$1")
    else
        AVAILABLE+=("$1")
    fi
}

for pkg in "${APT_PKGS[@]}" "${CARGO_PKGS[@]}" "${!CUSTOM_CMDS[@]}"; do 
    check_install "$pkg"
done

for pkg in "${FLATPAK_PKGS[@]}"; do
    if command -v flatpak &> /dev/null && flatpak list | grep -q "$pkg" 2>/dev/null; then 
        INSTALLED+=("$pkg")
    else 
        AVAILABLE+=("$pkg")
    fi
done

echo -e "\n=== Pacotes já instalados ==="
for p in "${INSTALLED[@]}"; do echo " [✓] $p"; done

echo -e "\n=== Pacotes disponíveis para instalação ==="
for i in "${!AVAILABLE[@]}"; do 
    echo " [$i] ${AVAILABLE[$i]}"
done

echo -e "\nDigite os números dos pacotes que deseja instalar (separados por espaço) ou digite 'todos':"
read -r escolhas


TO_INSTALL=()
if [[ "$escolhas" == "todos" ]]; then
    TO_INSTALL=("${AVAILABLE[@]}")
else
    for i in $escolhas; do 
        if [[ -n "${AVAILABLE[$i]}" ]]; then
            TO_INSTALL+=("${AVAILABLE[$i]}")
        fi
    done
fi

if [ ${#TO_INSTALL[@]} -eq 0 ]; then 
    echo "Nenhum pacote selecionado. Saindo."
    exit 0
fi

echo -e "\n${YELLOW}Confirma a instalação dos seguintes pacotes? (s/n)${NC}"
for p in "${TO_INSTALL[@]}"; do echo " - $p"; done
read -r conf

if [[ "$conf" != "s" && "$conf" != "S" ]]; then 
    echo "Instalação cancelada."
    exit 0
fi

sudo apt update

for pkg in "${TO_INSTALL[@]}"; do
    echo -e "\n${YELLOW}Instalando: ${GREEN}$pkg${NC}..."
    
    if [[ " ${APT_PKGS[*]} " =~ " ${pkg} " ]]; then
        sudo apt install -y "$pkg"
    elif [[ " ${CARGO_PKGS[*]} " =~ " ${pkg} " ]]; then
        cargo install "$pkg"
    elif [[ " ${FLATPAK_PKGS[*]} " =~ " ${pkg} " ]]; then
        flatpak install -y flathub "$pkg"
    elif [[ -n "${CUSTOM_CMDS[$pkg]}" ]]; then
        eval "${CUSTOM_CMDS[$pkg]}"
    fi
done

if command -v zsh &> /dev/null; then
    echo -e "\nConfigurando Zsh como shell padrão..."
    sudo chsh -s "$(which zsh)" "$USER"
    echo "Zsh configurado. Reinicie a sessão para aplicar."
fi

echo -e "\nConfiguração finalizada!"
