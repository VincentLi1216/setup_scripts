#!/bin/bash

# Define config directory as the current directory
CONFIG_DIR=$(pwd)

# Make sure the setup scripts are executable
chmod +x setup-zsh.sh setup-oh-my-zsh.sh setup-p10k.sh

# Function to install packages based on OS
install_packages() {
    echo "Detecting OS and installing necessary packages..."

    if [ -f /etc/alpine-release ]; then
        # Alpine Linux
        echo "Alpine Linux detected."
        sudo apk update
        sudo apk add --no-cache git zsh vim tmux curl python3 py3-pip
    elif [ -f /etc/debian_version ]; then
        # Debian or Ubuntu
        echo "Debian/Ubuntu detected."
        sudo apt update && sudo apt upgrade -y
        sudo apt install -y git zsh vim tmux curl python3 python3-pip
    elif [ "$(uname)" == "Darwin" ]; then
        # macOS
        echo "macOS detected."
        # Install Homebrew if not installed
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew update
        brew install git zsh vim tmux curl python3
    else
        echo "Unsupported OS. Exiting."
        exit 1
    fi
}

# Install necessary packages
install_packages

# Function to append configuration if the file exists
append_config() {
    local src_file="$1"
    local dest_file="$2"

    if [ -f "$CONFIG_DIR/$src_file" ]; then
        echo "Appending $src_file to $dest_file..."
        cat "$CONFIG_DIR/$src_file" >> "$dest_file"
    else
        echo "$CONFIG_DIR/$src_file does not exist."
    fi
}

# Set Git editor to vim
export GIT_EDITOR=vim

# Append configs
append_config "vimrc" "$HOME/.vimrc"
append_config "gitconfig" "$HOME/.gitconfig"
append_config "tmux.conf" "$HOME/.tmux.conf"
append_config "aliases" "$HOME/.bashrc"

# Reload bashrc if aliases were appended
if [ -f "$CONFIG_DIR/aliases" ]; then
    source "$HOME/.bashrc"
fi

# Setup SSH key if not exists
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_rsa"
    echo "Your public SSH key:"
    cat "$HOME/.ssh/id_rsa.pub"
else
    echo "SSH key already exists."
fi

# Final message
echo "✅ Development environment setup complete!"
