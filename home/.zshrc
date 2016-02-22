# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

## Dotfiles
# andsens/homeshick
if [ -f "$HOME/.homesick/repos/homeshick/homeshick.sh" ]; then
  source "$HOME/.homesick/repos/homeshick/homeshick.sh"
  fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
  # check castles every other day
  homeshick --quiet refresh 2
fi

## Theme
if [[ "$(tty)" == "/dev/tty"* ]]; then
  # do not theme login shell
  ZSH_THEME=""
else
  # hide user@host if $DEFAULT_USER@localhost
  DEFAULT_USER='johnp'
  if [ -d "$ZSH/custom/themes/powerlevel9k" ]; then
    # powerlevel9k/powerlevel9k
    ZSH_THEME="powerlevel9k/powerlevel9k"

    # source custom code points
    # todo: add to dotfiles and combine with Xdefaults font setting
    if [ -f "$HOME/.local/p9k" ]; then
      . "$HOME/.local/p9k"
    fi

    # Powerlevel9k configuration
    # gabrielelana/awesome-terminal-fonts
    # ryanoasis/nerd-fonts
    POWERLEVEL9K_MODE='awesome-fontconfig'
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs root_indicator)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
    POWERLEVEL9K_STATUS_VERBOSE=true
    POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
    POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
    POWERLEVEL9K_SHOW_CHANGESET=true
    POWERLEVEL9K_CHANGESET_HASH_LENGTH=6
  else
    ZSH_THEME="agnoster"
  fi
fi

# Hyphen-insensitive completion.
HYPHEN_INSENSITIVE="true"
# Command auto-correction.
#ENABLE_CORRECTION="true"
# Update oh-my-zsh every 7 days.
export UPDATE_ZSH_DAYS=7
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

## Plugins
plugins=(gitfast git-extras virtualenvwrapper colored-man-pages common-aliases extract history systemd archlinux fedora sudo man rsync zsh-syntax-highlighting alias-tips)

## Plugin configuration
# suggest aliases
export ZSH_PLUGINS_ALIAS_TIPS_EXPAND=1
# disable the venv cd feature of the virtualenvwrapper plugin
export DISABLE_VENV_CD=1
# virtualenv home
export WORKON_HOME=~/.virtualenvs

## User configuration
export PATH="$PATH:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:$HOME/.local/bin:$HOME/bin"
# export MANPATH="/usr/local/man:$MANPATH"

# source local .zshrc overrides
if [ -f "$HOME/.local/zshrc" ]; then
    source "$HOME/.local/zshrc"
fi

# source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# disable zsh wildcards
unsetopt nomatch

# source custom aliases
source "$HOME/.aliases"

# gpg-agent
GPG_TTY=$(tty)
export GPG_TTY
