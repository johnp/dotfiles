## Installation

1. Install [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/#basic-installation)

    ```
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    ```
2. Install [homeshick](https://github.com/andsens/homeshick/wiki/Installation)

    ```
    git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    ```
3. Clone this repo

    ```
    $HOME/.homesick/repos/homeshick/bin/homeshick clone johnp/dotfiles
    ```
4. Install oh-my-zsh plugins

    ```
    sh $HOME/.homesick/repos/dotfiles/install_plugins.sh
    ```
5. Install diff-so-fancy (used for git diffs) via package manager or npm.

## TODO

* [Bootstrapping](https://github.com/andsens/homeshick/wiki/Simplistic-bootstraping-script)
* Auto-Update for oh-my-zsh plugins
* Check out getantibody/antibody
