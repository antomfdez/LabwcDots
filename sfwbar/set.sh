cp ./labwc/rc.xml ~/.config/labwc
cp -r sfwbar/* ~/.config/sfwbar
labwc --reconfigure
pkill sfwbar; sfwbar >/dev/null 2>&1 & disown
