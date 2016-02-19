#/bin/sh
# This script clones custom themes and plugins for oh-my-zsh.
# Therefore, oh-my-zsh has to be installed first.

# custom plugins
git clone --depth 1 https://github.com/djui/alias-tips.git $HOME/.oh-my-zsh/custom/plugins/alias-tips
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# custom themes
git clone --depth 1 https://github.com/bhilburn/powerlevel9k.git $HOME/.oh-my-zsh/custom/themes/powerlevel9k
