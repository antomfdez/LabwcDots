cp ~/.config/labwc-themes/everforest/labwc/rc.xml ~/.config/labwc
cp -r ~/.config/labwc-themes/everforest/sfwbar/* ~/.config/sfwbar
labwc --reconfigure
pkill sfwbar; sfwbar >/dev/null 2>&1 & disown
