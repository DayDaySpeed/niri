# ~/.zshrc (./setup.sh deploy 从项目的 dotfiles/ 复制)
# 本机私有的内容 (密钥、个人工具路径) 放 ~/.config/zsh/local.zsh, 不入库
source ~/.config/zsh/zshrc
eval "$(starship init zsh)"
export EDITOR=nvim
export PATH="$HOME/.local/share/npm/bin:$HOME/.local/bin:$PATH"

[ -f ~/.config/zsh/local.zsh ] && source ~/.config/zsh/local.zsh
