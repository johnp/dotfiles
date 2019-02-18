# disable firefox nightly default debug option
export JSGC_DISABLE_POISONING=1
# enable the firefox wayland backend
export MOZ_ENABLE_WAYLAND=1
# make firefox use the xdg-desktop-portal for file manager integration
#export GTK_USE_PORTAL=1
# XXX: this causes more problems than it solves
#export MOZ_USE_XINPUT2=1
# less
export LESS='NiXRF'
export LESSSECURE=1
# rust
export RUST_BACKTRACE=1
export RUSTC_WRAPPER=sccache
# less+rust=bat
export BAT_PAGER="$HOME/.local/bin/.bat-pager.sh"
# work around coreutils bug
# https://unix.stackexchange.com/questions/258679
export QUOTING_STYLE=literal

# source machine specific profile
if [ -f "$HOME/.local/$HOST/profile" ] ; then
    . "$HOME/.local/$HOST/profile"
fi
