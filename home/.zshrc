if [[ -v ZSH_PROF ]]; then
  zmodload zsh/zprof
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
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

# zsh built-in bracketed-paste
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# zpty for zsh-autosuggestions
zmodload zsh/zpty

# path to my oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"
# load custom completions
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
  if [[ -d "$ZSH/custom/themes/powerlevel10k" ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
    # Powerlevel10k configuration
    if [[ -v DISPLAY ]]; then
        # ryanoasis/nerd-fonts
        POWERLEVEL9K_MODE='nerdfont-complete'
    fi # else use the default mode (e.g. for tmux on tty)
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh context dir dir_writable vcs root_indicator)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time virtualenv custom_icon)
    POWERLEVEL9K_TIME_BACKGROUND='255'
    POWERLEVEL9K_CUSTOM_ICON_BACKGROUND='255'
    #DISTRO=$(awk -F'=' '/^ID=/ {print tolower($2)}' /etc/*-release 2>/dev/null)
    if [[ "$HOSTNAME" == "johnp-pc" ]]; then
        POWERLEVEL9K_CUSTOM_ICON="echo $'\uf30a'"
    elif [[ "$HOSTNAME" == "johnp-laptop" ]]; then
        POWERLEVEL9K_CUSTOM_ICON="echo $'\uf303'"
    fi
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
plugins=(git gitfast git-extras colored-man-pages common-aliases extract history bgnotify \
 systemd archlinux dnf gpg-agent sudo man rsync django rust cargo golang fd ripgrep \
 alias-tips history-search-multi-word fast-syntax-highlighting)
 # zsh-autosuggestions)

## Plugin configuration
# suggest aliases
export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="" # space separated
export ZSH_PLUGINS_ALIAS_TIPS_EXPAND=1
#export ZSH_PLUGINS_ALIAS_TIPS_REVEAL=1 # demo mode

# limit autosuggest
ZSH_AUTOSUGGEST_STRATEGY=(completion history)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HISTORY_IGNORE=120
ZSH_AUTOSUGGEST_USE_ASYNC=1

# HSMW compatibility with fsh & autosuggest
zstyle :plugin:history-search-multi-word reset-prompt-protect 1

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# https://github.com/zsh-users/zsh-autosuggestions/issues/351
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)

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

# plugin config: autosuggest via Ctrl+Space
bindkey '^ ' autosuggest-accept

# history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
export HISTCONTROL=ignorespace

# source custom aliases
source "$HOME/.aliases"

# custom shell function "aliases"
function dsf() { diff -u "$1" "$2" | diff-so-fancy; }

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
# TODO: clang specific (e.g. flto=thin), PIE/PIC
_COMMON_FLAGS="-march=native -mtune=native -g -D_FORTIFY_SOURCE=2 -Wall -Wextra -Wpedantic -Wformat=2 -Wshadow -Wconversion -Wstrict-overflow=2 -Wfloat-equal -Wdouble-promotion -Wcast-qual -Wsuggest-attribute=pure -Wsuggest-attribute=const -Wpadded -Wunsafe-loop-optimizations -Wno-aggressive-loop-optimizations -Wwrite-strings -Wredundant-decls -fno-plt -fstack-check -fstack-clash-protection -pipe -fstack-protector-strong -fasynchronous-unwind-tables"
_CFLAGS="-std=c17 -Werror=implicit-function-declaration -Wmissing-prototypes -Wstrict-prototypes -Wold-style-definition -Wbad-function-cast $_COMMON_FLAGS"
export OPT_CFLAGS="-O2 -flto $_CFLAGS"
export DBG_CFLAGS="-Og -fsanitize=undefined $_CFLAGS"
_CXXFLAGS="-std=c++17 -D_GLIBCXX_ASSERTIONS -Wmissing-declarations -Weffc++ $_COMMON_FLAGS"
export OPT_CXXFLAGS="-O2 -flto $_CXXFLAGS"
export DBG_CXXFLAGS="-Og -fsanitize=undefined $_CXXFLAGS"
export OPT_LDFLAGS="-Wl,-O2,--sort-common,--as-needed,-z,defs,-z,relro,-z,now"

# TODO: this is probably keyboard/device-specific!
# --> compare with .inputrc / put it someplace sane
bindkey '^[Od' backward-word
bindkey '^[Oc' forward-word

# euank/pazi directory autojumper
if command -v pazi &>/dev/null; then
  eval "$(pazi init zsh)"
fi
