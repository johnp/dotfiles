# set environment variables for my X11/i3 environment
export VISUAL=gedit
export EDITOR=nano
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
# import $DISPLAY for dunst notification daemon (issue #347)
systemctl --user import-environment DISPLAY
#exec cinnamon-session
exec i3
#exec i3 &> /tmp/i3-$(date +'%F-%k-%M-%S').log
