if [[ -v ZSH_PROF ]]; then
  zmodload zsh/zprof
fi

# path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"
# rustup completions path
fpath+="$HOME/.zfunc"

## Dotfiles
# andsens/homeshick
if [ -f "$HOME/.homesick/repos/homeshick/homeshick.sh" ]; then
  source "$HOME/.homesick/repos/homeshick/homeshick.sh"
  fpath+="$HOME/.homesick/repos/homeshick/completions"
  # check castles every week (costs ~30ms startup time if called synchronously)
  (homeshick -qb refresh 7 &)
fi

## Theme
if [[ "$(tty)" == "/dev/tty"* ]]; then
  # do not theme login shell
  ZSH_THEME=""
else
  # hide user@host if $DEFAULT_USER@localhost
  export DEFAULT_USER='johnp'
  if [[ -d "$ZSH/custom/themes/powerlevel9k" ]]; then
	# cost 30-40ms startup time
    ZSH_THEME="powerlevel9k/powerlevel9k"
    # Powerlevel9k configuration
    # bhilburn/powerlevel9k
    # ryanoasis/nerd-fonts
    if [[ -v DISPLAY ]]; then
        POWERLEVEL9K_MODE='nerdfont-complete'
    fi # else use the default mode (e.g. for tmux on tty)
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh context dir dir_writable vcs root_indicator)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs time custom_icon)
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
# Do not prompt for update for now
DISABLE_UPDATE_PROMPT="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

## Plugins
plugins=(gitfast git-extras colored-man-pages common-aliases extract history systemd archlinux fedora sudo man rsync alias-tips zsh-syntax-highlighting)

## Plugin configuration
# suggest aliases
export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="" # space separated
export ZSH_PLUGINS_ALIAS_TIPS_EXPAND=1

## User configuration
export PATH="$PATH:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin"

# source local .zshrc overrides
if [ -f "$HOME/.local/$HOST/zshrc" ]; then
    source "$HOME/.local/$HOST/zshrc"
fi

# Uncomment the following line to enable profiling oh-my-zsh startup
# ENABLE_PROFILING="true"

# source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# disable zsh wildcards
unsetopt nomatch

# source custom aliases
source "$HOME/.aliases"

# gpg-agent
GPG_TTY=$(tty)
export GPG_TTY

# some default compiler & linker options
#export CPPFLAGS="-D_FORTIFY_SOURCE=2"
COMMON_FLAGS="-Wall -Wextra -Wpedantic -Wformat=2 -Wshadow -Wconversion -Wstrict-overflow=2 -Wfloat-equal -Wdouble-promotion -Wcast-qual -Wsuggest-attribute=pure -Wsuggest-attribute=const -Wpadded -Wunsafe-loop-optimizations -Wno-aggressive-loop-optimizations -Wwrite-strings -Wredundant-decls -Og -fno-plt -fstack-check -pipe -fstack-protector-strong"
export CFLAGS="-Wmissing-prototypes -Wstrict-prototypes -Wold-style-definition -Wbad-function-cast $COMMON_FLAGS"
#export CFLAGS="-std=c11 -Wmissing-prototypes -Wstrict-prototypes -Wold-style-definition -Wbad-function-cast $COMMON_FLAGS"
#export CXXFLAGS="-std=c++14 -Wmissing-declarations -Weffc++ $COMMON_FLAGS"
#export LDFLAGS="-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"


# TODO: this is probably keyboard/device-specific!
# --> compare with .inputrc / put it someplace sane
bindkey '^[Od' backward-word
bindkey '^[Oc' forward-word
