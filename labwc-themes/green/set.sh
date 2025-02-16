cp ~/.config/labwc-themes/green/labwc/rc.xml ~/.config/labwc
cp -r ~/.config/labwc-themes/green/sfwbar/* ~/.config/sfwbar
labwc --reconfigure
pkill sfwbar; sfwbar >/dev/null 2>&1 & disown
