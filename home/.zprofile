# Firefox tuning environment variables
export JSGC_DISABLE_POISONING=1
# XXX: this causes more problems than it solves
#export MOZ_USE_XINPUT2=1
# less
export LESS='NiXR'
export LESSECURE=1
# rust
export RUST_BACKTRACE=1
export RUSTC_WRAPPER=sccache
# work around coreutils bug
# https://unix.stackexchange.com/questions/258679
export QUOTING_STYLE=literal

# source machine specific profile
if [ -f "$HOME/.local/$HOST/profile" ] ; then
    . "$HOME/.local/$HOST/profile"
fi
