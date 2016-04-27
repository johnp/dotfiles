# firefox
export JSGC_DISABLE_POISONING=1
#export MOZ_USE_XINPUT2=1
# less
export LESS='NiX'
# rust
export RUST_BACKTRACE=1

# source machine specific profile
if [ -f "$HOME/.local/profile" ] ; then
    . "$HOME/.local/profile"
fi
