if [[ -v ZSH_PROF ]]; then
  zmodload zsh/zprof
fi

# zsh-lovers(1) stuff
zstyle ':completion:*' cache-path ~/.cache/zcompcache
zstyle ':completion:*' use-cache on
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:functions' ignored-patterns '_*'

# path to my oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"
# load rustup/pipenv completions
fpath+="$HOME/.zfunc"

## Dotfiles (andsens/homeshick)
if [ -f "$HOME/.homesick/repos/homeshick/homeshick.sh" ]; then
  source "$HOME/.homesick/repos/homeshick/homeshick.sh"
  fpath+="$HOME/.homesick/repos/homeshick/completions"
  # check castles every week (costs ~30ms startup time if called synchronously)
  #(homeshick -qb refresh 7 &) # better do this manually
fi

## Theme
if [[ "$(tty)" == "/dev/tty"* ]]; then
  # do not theme login shell
  ZSH_THEME=""
else
  # hide user@host if $DEFAULT_USER@localhost
  export DEFAULT_USER='johnp'
  if [[ -d "$ZSH/custom/themes/powerlevel9k" ]]; then
	# loading the theme costs 30-40ms startup time
    ZSH_THEME="powerlevel9k/powerlevel9k"
    # Powerlevel9k configuration
    # bhilburn/powerlevel9k
    # ryanoasis/nerd-fonts
    if [[ -v DISPLAY ]]; then
        POWERLEVEL9K_MODE='nerdfont-complete'
    fi # else use the default mode (e.g. for tmux on tty)
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh context dir dir_writable vcs root_indicator)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time virtualenv custom_icon)
    POWERLEVEL9K_TIME_BACKGROUND='255'
    POWERLEVEL9K_CUSTOM_ICON_BACKGROUND='255'
    POWERLEVEL9K_CUSTOM_ICON="echo $'\uf303'"
    #POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
    #POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
    POWERLEVEL9K_SHORTEN_DELIMITER="…"
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
UPDATE_ZSH_DAYS=7
DISABLE_UPDATE_PROMPT="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

## Plugins
plugins=(git gitfast git-extras colored-man-pages common-aliases extract history \
 systemd archlinux dnf gpg-agent sudo man rsync django rust cargo golang fd ripgrep \
 alias-tips history-search-multi-word fast-syntax-highlighting)
# zsh-autosuggestions)

## Plugin configuration
# suggest aliases
export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="" # space separated
export ZSH_PLUGINS_ALIAS_TIPS_EXPAND=1
#export ZSH_PLUGINS_ALIAS_TIPS_REVEAL=1 # demo mode

## User configuration
export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin"

# golang
export GOPATH=${GOPATH-~/go}

# source host-specific .zshrc overrides
if [ -f "$HOME/.local/$HOST/zshrc" ]; then
    source "$HOME/.local/$HOST/zshrc"
fi

# Uncomment the following line to enable profiling oh-my-zsh startup
# ENABLE_PROFILING="true"

# source oh-my-zsh
source "$ZSH/oh-my-zsh.sh"

# disable zsh wildcards
unsetopt nomatch

# history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
export HISTCONTROL=ignorespace

# source custom aliases
source "$HOME/.aliases"

# gpg-agent workaround for ssh/scp
ssh() {
  gpg-connect-agent updatestartuptty /bye
  if [[ "$TERM" == "alacritty" ]]; then
    env TERM=xterm-256color ssh $*
  else
    env ssh $*
  fi
}
scp() {
  gpg-connect-agent updatestartuptty /bye
  env scp $*
}

# some default compiler & linker options
#export CPPFLAGS="-D_FORTIFY_SOURCE=2"
COMMON_FLAGS="-march=native -Wall -Wextra -Wpedantic -Wformat=2 -Wshadow -Wconversion -Wstrict-overflow=2 -Wfloat-equal -Wdouble-promotion -Wcast-qual -Wsuggest-attribute=pure -Wsuggest-attribute=const -Wpadded -Wunsafe-loop-optimizations -Wno-aggressive-loop-optimizations -Wwrite-strings -Wredundant-decls -Og -fno-plt -fstack-check -pipe -fstack-protector-strong"
export CFLAGS="-Wmissing-prototypes -Wstrict-prototypes -Wold-style-definition -Wbad-function-cast $COMMON_FLAGS"
export MYCFLAGS="-std=c17 $CFLAGS"
export MYCXXFLAGS="-std=c++17 -Wmissing-declarations -Weffc++ $COMMON_FLAGS"
export MYLDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"

# TODO: this is probably keyboard/device-specific!
# --> compare with .inputrc / put it someplace sane
bindkey '^[Od' backward-word
bindkey '^[Oc' forward-word

# euank/pazi directory autojumper
if command -v pazi &>/dev/null; then
  eval "$(pazi init zsh)"
fi
