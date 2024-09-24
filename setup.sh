#!/bin/bash

# 定義你的配置檔案目錄為當前目錄
CONFIG_DIR=./

# 更新系統並安裝必要套件
echo "Updating system and installing necessary packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y vim git tmux curl python3 python3-pip

# 檢查並複製 Vimrc 設定
if [ -f "$CONFIG_DIR/vimrc" ]; then
  echo "Appending Vimrc from $CONFIG_DIR to ~/.vimrc..."
  cat "$CONFIG_DIR/vimrc" >> ~/.vimrc
else
  echo "$CONFIG_DIR/vimrc does not exist."
fi


# 設置 Git 並將 Gitconfig 加入系統 Gitconfig 的最後面
export GIT_EDITOR=vim
if [ -f "$CONFIG_DIR/gitconfig" ]; then
  echo "Appending Gitconfig from $CONFIG_DIR to ~/.gitconfig..."
  cat "$CONFIG_DIR/gitconfig" >> ~/.gitconfig
else
  echo "$CONFIG_DIR/gitconfig does not exist."
fi

# 檢查並複製 Tmux 設定
if [ -f "$CONFIG_DIR/tmux.conf" ]; then
  echo "Appending Tmux config from $CONFIG_DIR to ~/.tmux.conf..."
  cat "$CONFIG_DIR/tmux.conf" >> ~/.tmux.conf
else
  echo "$CONFIG_DIR/tmux.conf does not exist."
fi

# 檢查並複製別名設定
if [ -f "$CONFIG_DIR/aliases" ]; then
  echo "Appending aliases from $CONFIG_DIR to ~/.bashrc..."
  cat "$CONFIG_DIR/aliases" >> ~/.bashrc
  source ~/.bashrc
else
  echo "$CONFIG_DIR/aliases does not exist."
fi

# ssh key
if [ ! -f ~/.ssh/id_rsa ]; then
  echo "Generating SSH key..."
  ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  echo "Your public SSH key:"
  cat ~/.ssh/id_rsa.pub
else
  echo "SSH key already exists."
fi


# 安裝完成提示
echo "Development environment setup complete!"
