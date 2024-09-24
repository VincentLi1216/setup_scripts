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