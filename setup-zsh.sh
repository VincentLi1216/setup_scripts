#!/bin/bash

# 更新系統並安裝 zsh
echo "Updating system and installing Zsh..."
sudo apt-get update
sudo apt-get install -y zsh

# 檢查 Zsh 是否成功安裝
if ! command -v zsh >/dev/null 2>&1; then
  echo "Error: Zsh is not installed. Please check the installation process."
  exit 1
fi

# 查看可用的 shell
echo "Available shells:"
cat /etc/shells

# 安裝 Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# 檢查是否成功生成 ~/.zshrc
if [ ! -f ~/.zshrc ]; then
  echo "~/.zshrc file not found. Creating a new one..."
  touch ~/.zshrc
fi

# 設置 Zsh 為預設的 shell
echo "Setting Zsh as the default shell..."
echo 'exec zsh' >> ~/.bashrc
echo 'exec zsh' >> ~/.bash_profile
chsh -s $(which zsh)

# 如果無法自動切換到 zsh，手動修改 ~/.bashrc 或 ~/.bash_profile
if [[ "$SHELL" != "$(which zsh)" ]]; then
  echo "Modifying ~/.bashrc or ~/.bash_profile to set Zsh as the default shell..."
  echo 'exec zsh' >> ~/.bashrc
  echo 'exec zsh' >> ~/.bash_profile
  echo "Please restart your terminal or source ~/.bashrc to apply changes."
else
  echo "Zsh is now the default shell."
fi

# 檢查並複製別名設定
if [ -f "$CONFIG_DIR/aliases" ]; then
  echo "Appending aliases from $CONFIG_DIR to ~/.zshrc..."
  cat "$CONFIG_DIR/aliases" >> ~/.zshrc
  source ~/.bashrc
else
  echo "$CONFIG_DIR/aliases does not exist."
fi


