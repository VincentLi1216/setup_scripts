#!/bin/bash

# Make sure the setup scripts are executable
chmod +x setup-zsh.sh setup-oh-my-zsh.sh setup-p10k.sh

# Define the config directory as current working directory
CONFIG_DIR=$(pwd)

# Function to run command with sudo if available, otherwise directly
run_cmd() {
    if command -v sudo &> /dev/null; then
        sudo "$@"
    else
        "$@"
    fi
}

# Function to install basic packages depending on OS
install_packages() {
    echo "🔍 Detecting OS and installing essential packages..."

    if [ -f /etc/alpine-release ]; then
        echo "🐧 Alpine Linux detected."
        run_cmd apk update
        run_cmd apk add --no-cache git zsh curl vim tmux python3 py3-pip
    elif [ -f /etc/debian_version ]; then
        echo "🐧 Debian/Ubuntu detected."
        run_cmd apt update
        run_cmd apt install -y git zsh curl vim tmux python3 python3-pip
    elif [ "$(uname)" == "Darwin" ]; then
        echo "🍏 macOS detected."
        if ! command -v brew &> /dev/null; then
            echo "📦 Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew update
        brew install git zsh curl vim tmux python3
    else
        echo "❌ Unsupported OS. Exiting setup."
        exit 1
    fi
}

# Start installation
install_packages

# Verify essential tools
verify_install() {
    local tool="$1"
    if command -v "$tool" &> /dev/null; then
        echo "✅ $tool installed successfully: $($tool --version 2>/dev/null || echo OK)"
    else
        echo "❌ $tool installation failed. Exiting."
        exit 1
    fi
}

verify_install git
verify_install zsh
verify_install curl

# Function to append config file if exists
append_config() {
    local src="$1"
    local dest="$2"

    if [ -f "$CONFIG_DIR/$src" ]; then
        echo "📄 Appending $src to $dest..."
        cat "$CONFIG_DIR/$src" >> "$dest"
    else
        echo "⚠️ $CONFIG_DIR/$src not found. Skipping."
    fi
}

# Append configuration files
append_config vimrc ~/.vimrc
append_config gitconfig ~/.gitconfig
append_config tmux.conf ~/.tmux.conf

# Append aliases to bashrc and reload
if [ -f "$CONFIG_DIR/aliases" ]; then
    echo "📄 Appending aliases to ~/.bashrc..."
    cat "$CONFIG_DIR/aliases" >> ~/.bashrc
    source ~/.bashrc
else
    echo "⚠️ No aliases file found. Skipping."
fi

# SSH key setup
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "🔑 Generating SSH key..."
    mkdir -p ~/.ssh
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/id_rsa -N ""
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    echo "📄 Your public SSH key:"
    cat ~/.ssh/id_rsa.pub
else
    echo "🔑 SSH key already exists. Skipping generation."
fi

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🛠 Setting zsh as the default shell..."
    run_cmd chsh -s "$(which zsh)" || echo "⚠️ Failed to change default shell. Please set manually."
else
    echo "✅ zsh is already the default shell."
fi

# Setup scripts executable (optional if you have them)
chmod +x setup-zsh.sh setup-oh-my-zsh.sh setup-p10k.sh 2>/dev/null || true

# Final message
echo "🎉 Development environment setup complete!"
