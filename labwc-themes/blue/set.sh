cp ~/.config/labwc-themes/blue/labwc/rc.xml ~/.config/labwc
cp -r ~/.config/labwc-themes/blue/sfwbar/* ~/.config/sfwbar
labwc --reconfigure
pkill sfwbar; sfwbar >/dev/null 2>&1 & disown
