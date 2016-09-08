# firefox
export JSGC_DISABLE_POISONING=1
# XXX: this causes more problems than it solves
#export MOZ_USE_XINPUT2=1
# less
export LESS='NiX'
# rust
export RUST_BACKTRACE=1
# work around coreutils bug
# https://unix.stackexchange.com/questions/258679
export QUOTING_STYLE=literal

# source machine specific profile
if [ -f "$HOME/.local/$HOST/profile" ] ; then
    . "$HOME/.local/$HOST/profile"
fi
