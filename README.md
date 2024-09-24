# Features
## Auto Install Useful Packages
- `Git`
- `Vim`
- `Tmux`

## Copy Your Default Config Files
- `~/.bashrc` or `~/.zshrc` 
- `~/.gitconfig`
- `~/.vimrc`
- `~/.tmux.conf`

## Advance
### Switch from Bash to Zsh
run
```shell
sh setup-zsh.sh
```

### Setup oh-my-zsh
Install other plugins: `zsh-autosuggestions` `zsh-syntax-highlighting`   

run
```shell
sh setup-oh-my-zsh.sh
```

### PowerLevel10K
**This step requires partially manual setup.**

run
```shell
sh setup-p10k.sh
```

### Auto Generated SSH-KEY
`setup.zsh` will detect whether the ssh-key exists or not, if not then automatically generate it.

# Installation
## Step 1
Cloning the project
```shell
git clone https://github.com/VincentLi1216/setup_scripts.git
cd setup_scripts
```

## Step2
Making the scripts executable.
```shell
chmod +x setup.sh
```

## Step3
Run the Scripts.
```shell
sh setup.sh
```

## Step4(Optional)
Setting up the `zsh`, and `oh my Zsh`.
```shell
sh setup-zsh.sh
``` 

```shell
sh setup-oh-my-zsh.sh
```
---
Setting up `PowerLevel10K`.
```shell
sh setup-p10k.sh
```