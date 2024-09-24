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

# 設置 Oh My Zsh 主題
echo "Setting Zsh theme to 'jonathan'..."
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="jonathan"/' ~/.zshrc

# 安裝 Zsh syntax highlighting 插件
echo "Installing Zsh Syntax Highlighting plugin..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 安裝 Zsh autosuggestions 插件
echo "Installing Zsh Autosuggestions plugin..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 修改 .zshrc 以啟用插件
echo "Enabling plugins in .zshrc..."
if grep -q "^plugins=" ~/.zshrc; then
  sed -i '/^plugins=/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc
else
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc
fi

# 通知重啟 Zsh 以應用更改
echo "Zsh setup complete! Please restart your terminal or run 'exec zsh' to apply changes."
