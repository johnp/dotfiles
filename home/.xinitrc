# set environment variables for my X11/i3 environment
export VISUAL=gedit
export EDITOR=nano
export _JAVA_AWT_WM_NONREPARENTING=1
# import $DISPLAY for dunst notification daemon (issue #347)
systemctl --user import-environment DISPLAY
#exec cinnamon-session
exec i3
#exec i3 -V >> ~/i3log-$(date +'%F-%k-%M-%S') 2>&1
