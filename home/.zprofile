# disable firefox nightly default debug option
export JSGC_DISABLE_POISONING=1
# enable the firefox wayland backend
export MOZ_ENABLE_WAYLAND=1
# enable DBus remote for Firefox with X11 and Wayland
# for concurrent invocations to always use the already
# running instance, regardless of inherited GDK_BACKEND
# of the application that is e.g. opening a link
export MOZ_DBUS_REMOTE=1
# disable firefox profile downgrade protection
export MOZ_ALLOW_DOWNGRADE=1
# make firefox use the xdg-desktop-portal for file manager integration
export GTK_USE_PORTAL=1
# new radv shader compiler
export RADV_PERFTEST=aco
# XXX: this causes more problems than it solves
#export MOZ_USE_XINPUT2=1
# ncmpcpp mpd socket connection
export MPD_HOST="$XDG_RUNTIME_DIR/mpd/socket"
# less
export LESS='NiXRF'
export LESSSECURE=1
# rust
export RUST_BACKTRACE=1
export RUSTC_WRAPPER="$HOME/.cargo/bin/sccache"
export RUSTFLAGS='-g -C target-cpu=native -C link-arg=-fuse-ld=lld'
# less+rust=bat
export BAT_PAGER="$HOME/.local/bin/.bat-pager.sh"
# work around coreutils bug
# https://unix.stackexchange.com/questions/258679
export QUOTING_STYLE=literal
# django-admin colors
export DJANGO_COLORS='dark'
# default editor
export EDITOR=nano

# source machine specific profile
if [ -f "$HOME/.local/$HOST/profile" ] ; then
    . "$HOME/.local/$HOST/profile"
fi
