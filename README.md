## Installation

1. Install oh-my-zsh
```shell
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```
2. Install homeshick
```shell
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
```
3. Clone dotfiles
```shell
$HOME/.homesick/repos/homeshick/bin/homeshick clone johnp/dotfiles
```
4. Install oh-my-zsh plugins
```shell
sh $HOME/.homesick/repos/dotfiles/install_plugins.sh
```
