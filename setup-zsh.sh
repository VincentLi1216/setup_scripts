#!/bin/bash

set -e  # 遇到錯誤就停止腳本

echo "🔍 Detecting OS and installing Zsh..."

# 自動偵測系統
if [ "$(uname)" == "Darwin" ]; then
    OS="mac"
elif [ -f /etc/alpine-release ]; then
    OS="alpine"
elif [ -f /etc/debian_version ]; then
    OS="debian"
else
    echo "❌ Unsupported OS."
    exit 1
fi

# 根據系統安裝 zsh
case "$OS" in
    mac)
        if ! command -v brew >/dev/null 2>&1; then
            echo "Installing Homebrew first..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install zsh
        ;;
    debian)
        sudo apt-get update
        sudo apt-get install -y zsh curl git
        ;;
    alpine)
        sudo apk update
        sudo apk add zsh curl git
        ;;
esac

# 確認 zsh 安裝成功
if ! command -v zsh >/dev/null 2>&1; then
    echo "❌ Error: Zsh installation failed."
    exit 1
fi

echo "✅ Zsh installed successfully."

# 查看可用的 shell
echo "Available shells:"
cat /etc/shells

# 安裝 Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🎉 Installing Oh My Zsh..."
    export RUNZSH=no
    export CHSH=no
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "✅ Oh My Zsh already installed."
fi

# 確保 ~/.zshrc 存在
if [ ! -f "$HOME/.zshrc" ]; then
    echo "Creating new ~/.zshrc..."
    touch "$HOME/.zshrc"
fi

# 設定 Zsh 為預設 shell
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" != "zsh" ]; then
    echo "🔧 Setting Zsh as default shell..."
    chsh -s "$(which zsh)"
else
    echo "✅ Zsh is already the default shell."
fi

# 複製別名設定
if [ -n "$CONFIG_DIR" ] && [ -f "$CONFIG_DIR/aliases" ]; then
    echo "🔗 Appending aliases from $CONFIG_DIR/aliases to ~/.zshrc..."
    cat "$CONFIG_DIR/aliases" >> "$HOME/.zshrc"
else
    echo "⚠️ CONFIG_DIR is not set or aliases file does not exist. Skipping alias setup."
fi

# 支援 vim 模式（vi keybindings）
echo "⚙️ Enabling vi mode in Zsh..."
{
    echo ""
    echo "# Enable vi key bindings"
    echo "bindkey -v"
    echo "export KEYTIMEOUT=1"
    echo "bindkey '^V' edit-command-line"
} >> "$HOME/.zshrc"

echo "🎯 Setup complete! Please restart your terminal or run 'exec zsh'."
