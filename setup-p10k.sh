#!/bin/bash

set -e  # 遇到錯誤直接停下

echo "🔍 Detecting OS..."

# 自動偵測 OS
if [ "$(uname)" = "Darwin" ]; then
    OS="mac"
elif [ -f /etc/alpine-release ]; then
    OS="alpine"
elif [ -f /etc/debian_version ]; then
    OS="debian"
else
    echo "❌ Unsupported OS."
    exit 1
fi

# 確認 ~/.p10k.zsh 是否存在
if [ -f "$HOME/.p10k.zsh" ]; then
  echo "✅ .p10k.zsh configuration file found. Ensuring it's sourced in .zshrc..."
  if ! grep -q 'source ~/.p10k.zsh' ~/.zshrc; then
    echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
    echo "✅ Added sourcing .p10k.zsh to .zshrc."
  else
    echo "✅ .p10k.zsh is already sourced in .zshrc."
  fi
else
  echo "⚠️ .p10k.zsh not found. You can run 'p10k configure' later to generate it."
fi

# 安裝 Powerlevel10k 主題
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "📥 Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
else
  echo "✅ Powerlevel10k theme already installed."
fi

# 設定 Powerlevel10k 為預設 Zsh 主題
echo "🎨 Setting Powerlevel10k as the default Zsh theme..."
if grep -q 'ZSH_THEME=' ~/.zshrc; then
  sed -i.bak 's|ZSH_THEME=".*"|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc
else
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
fi

# 安裝 Meslo Nerd Fonts
echo "📥 Installing Meslo Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"

# 下載字體
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

# 字體快取刷新
if [ "$OS" = "mac" ]; then
    echo "ℹ️ Skipping font cache refresh on Mac. Font should be available automatically."
elif [ "$OS" = "debian" ]; then
    echo "🔄 Refreshing font cache on Debian/Ubuntu..."
    sudo apt-get install -y fontconfig
    fc-cache -fv
elif [ "$OS" = "alpine" ]; then
    echo "🔄 Refreshing font cache on Alpine..."
    sudo apk add fontconfig
    fc-cache -fv
fi

# GNOME Terminal 字體設定（僅 Linux 桌面適用）
if [ "$OS" != "mac" ]; then
    if command -v gsettings >/dev/null 2>&1 && command -v dconf >/dev/null 2>&1; then
        echo "🛠 Setting GNOME Terminal font to 'MesloLGS NF 12'..."
        PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
        dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/font "'MesloLGS NF 12'"
        dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/use-system-font false
        echo "✅ GNOME Terminal font set successfully."
    else
        echo "⚠️ GNOME Terminal or dconf not available. Skipping GNOME font setup."
    fi
fi

# 完成提示
echo "🎯 Powerlevel10k setup complete! Please restart your terminal or run 'exec zsh'."
exec zsh
