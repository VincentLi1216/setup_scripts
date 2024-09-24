#!/bin/zsh

# 安裝 Powerlevel10k 主題
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
  echo "Powerlevel10k theme is already installed."
fi

# 設置 Powerlevel10k 為 Zsh 主題
echo "Setting Powerlevel10k as the default Zsh theme..."
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# 安裝 Meslo Nerd 字體 (Powerlevel10k 推薦字體)
echo "Installing Meslo Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p $FONT_DIR
cd $FONT_DIR

# 下載字體文件
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

# 刷新字體緩存
echo "Refreshing font cache..."
fc-cache -f -v

# 提示設置終端字體
echo "Please manually set your terminal font to 'MesloLGS NF' for the best Powerlevel10k experience."

# 設置 Zsh 為預設的 shell
echo "Setting Zsh as the default shell..."
chsh -s $(which zsh)

# 確認 .p10k.zsh 配置檔案是否存在
if [ -f "$HOME/.p10k.zsh" ]; then
  echo ".p10k.zsh configuration file found. Ensuring it's sourced in .zshrc..."
  # 確保 .zshrc 中已包含 .p10k.zsh
  if ! grep -q 'source ~/.p10k.zsh' ~/.zshrc; then
    echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
    echo "Added .p10k.zsh to .zshrc."
  else
    echo ".p10k.zsh is already sourced in .zshrc."
  fi
else
  echo ".p10k.zsh not found. You can run 'p10k configure' to generate it."
fi

# 提示重啟終端
echo "Powerlevel10k setup complete! Please restart your terminal or run 'exec zsh' to apply changes."
exec zsh