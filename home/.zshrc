# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# github.com/andsens/homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
# check castles every other day
homeshick --quiet refresh 2

# Set name of the theme to load.
ZSH_THEME="powerlevel9k/powerlevel9k"

# Powerlevel9k configuration
# AUR: powerline-fonts-git
POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time)
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHOW_CHANGESET=true
POWERLEVEL9K_CHANGESET_HASH_LENGTH=6

# Hyphen-insensitive completion.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# disable the venv cd feature of the virtualenvwrapper plugin
export DISABLE_VENV_CD=1

# virualenv home
export WORKON_HOME=~/.virtualenvs

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(gitfast git-extras virtualenvwrapper colored-man-pages common-aliases history systemd archlinux fedora sudo man rsync zsh-syntax-highlighting alias-tips)

# Plugin configs
export ZSH_PLUGINS_ALIAS_TIPS_EXPAND=1

# User configuration

export PATH="/usr/lib64/ccache:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/home/johnp/.local/bin:/home/johnp/bin"
# export MANPATH="/usr/local/man:$MANPATH"

# source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Don't use the fancy zsh wildcards
unsetopt nomatch

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
source "$HOME/.aliases"

# gpg-agent
# Note: .xinitrc contains initialization code, but is not included in dotfiles for now
GPG_TTY=$(tty)
export GPG_TTY
