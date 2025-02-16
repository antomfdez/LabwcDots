cp ~/.config/labwc-themes/red/labwc/rc.xml ~/.config/labwc
cp -r ~/.config/labwc-themes/red/sfwbar/* ~/.config/sfwbar
labwc --reconfigure
pkill sfwbar; sfwbar >/dev/null 2>&1 & disown
