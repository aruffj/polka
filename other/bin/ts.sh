#!/usr/bin/env bash

while [ "$1" ]; do
	case "$1" in
		-t|--theme) theme="$2"; shift 2;;
		*) break;;
	esac
done

themes="$(ls -1 ~/etc/colours/ | grep -iv 'current\|css')" # List of themes
if [[ -z $theme ]]; then
	theme="$(echo -e "$themes" | rofi -dmenu -i -p "What theme would you like to use?")" \
		|| exit
fi
ext() {
	echo "Invalid theme ($theme); exiting"; exit
}

# Define the colours in the theme (for rofi, startpage, firefox, dunst, etc)
[[ -f "${XDG_CONFIG_HOME:-~/.config}/colours/$theme" ]] &&
	. "${XDG_CONFIG_HOME:-~/.config}/colours/$theme" ||
	{ echo "Invalid theme '$theme'; exiting"; exit; }

echo -e "Theme chosen: $theme\n"

echo "Changing colours in:"

echo " - firefox"
# Change the colour variables in firefox and my startpage
sed --follow-symlinks -i \
	-e "s/--bg0:.*#.*\;/--bg0:      #$bg0\;/" \
	-e "s/--bg1:.*#.*\;/--bg1:      #$bg1\;/" \
	-e "s/--bg2:.*#.*\;/--bg2:      #$bg2\;/" \
	-e "s/--bg3:.*#.*\;/--bg3:      #$bg3\;/" \
	-e "s/--bg4:.*#.*\;/--bg4:      #$bg4\;/" \
	-e "s/--fg2:.*#.*\;/--fg2:      #$fg2\;/" \
	-e "s/--fg1:.*#.*\;/--fg1:      #$fg1\;/" \
	-e "s/--accent:.*#.*\;/--accent:   #$accent\;/" \
	-e "s/--accent2:.*#.*\;/--accent2:  #$accent2\;/" \
	-e "s/--border:.*#.*\;/--border:   #$border\;/" \
	-e "s/--button:.*#.*\;/--button:   #$button\;/" \
	-e "s/--contrast:.*#.*\;/--contrast: #$contrast\;/" \
	-e "s/--red:.*#.*\;/--red:      #$red\;/" \
	-e "s/--disabled:.*#.*\;/--disabled: #$disabled\;/" \
	${XDG_CONFIG_HOME:-~/.config}/.mozilla/firefox/main/chrome/userChrome.css \
	${XDG_CONFIG_HOME:-~/.config}/.mozilla/firefox/main/chrome/userContent.css

echo " - xresources"

cat << EOF > ${XDG_CONFIG_HOME:-~/.config}/Xres
*.background:   #$bg1
*.foreground:   #$fg1
*.cursorColor:  #$fg1

*.color0:       #$bg1
*.color8:       #$black

*.color1:       #$red
*.color9:       #$red

*.color2:       #$green
*.color10:      #$green

*.color3:       #$yellow
*.color11:      #$yellow

*.color4:       #$blue
*.color12:      #$blue

*.color5:       #$purple
*.color13:      #$purple

*.color6:       #$cyan
*.color14:      #$cyan

*.color7:       #$fg2
*.color15:      #$fg1

*.color16:      #$accent
*.color17:      #$accent2
EOF

sed --follow-symlinks -i \
	-e "s/normbgcolor.*/normbgcolor: #$bg3/" \
	-e "s/normfgcolor.*/normfgcolor: #$fg2/" \
	-e "s/selbgcolor.*/selbgcolor:  #$bg1/" \
	-e "s/selfgcolor.*/selfgcolor:  #$fg1/" \
	${XDG_CONFIG_HOME:-~/.config}/Xresources

echo "   * Reloading tabbed and st"
rc

echo " - 👀"
sed --follow-symlinks -i               \
	-e "s/outer=.*/outer='0x$bg1'   # outer/"      \
	-e "s/inner1=.*/inner1='0x$accent'  # focused/"      \
	-e "s/inner2=.*/inner2='0x$accent2'  # normal/"      \
	~/bin/wm/borders

echo " - dunst"
# Replace colours in dunst
# urgent notifications
dunst_urgent="$(( $(awk '/urgency_critical/ {print NR}' ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc) + 1 ))"

# low priority notifications
dunst_low="$(( $(awk '/urgency_low/ {print NR}' ${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc) + 1 ))"

sed --follow-symlinks -i \
	-e "s/background.*/background          = \"#$bg1\"/" \
	-e "s/foreground.*/foreground          = \"#$fg1\"/"  \
	-e "s/frame_color.*/frame_color         = \"#$accent\"/" \
	${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc

sed --follow-symlinks -i \
	\
	-e "${dunst_urgent}s/background.*/background          = \"#$bg1\"/" \
	-e "$(( ${dunst_urgent} + 1 ))s/foreground.*/foreground          = \"#$fg1\"/" \
	-e "$(( ${dunst_urgent} + 2 ))s/frame_color.*/frame_color         = \"#$accent2\"/" \
	\
	-e "${dunst_low}s/background.*/background          = \"#$bg1\"/" \
	-e "$(( ${dunst_low} + 1 ))s/foreground.*/foreground          = \"#$fg1\"/" \
	-e "$(( ${dunst_low} + 2 ))s/frame_color.*/frame_color         = \"#$fg1\"/" \
	\
	${XDG_CONFIG_HOME:-~/.config}/dunst/dunstrc

echo " - rofi"
# Change the theme in rofi
sed --follow-symlinks -i \
	-e "s/bg:.*#.*;/bg:         #$bg2;/g" \
	-e "s/fg:.*#.*;/fg:         #$fg1;/" \
	-e "s/accent:.*#.*;/accent:     #$accent;/"\
	-e "s/sel:.*#.*;/sel:        #$button;/"\
	-e "s/contrast:.*#.*;/contrast:   #$contrast;/"\
	${XDG_CONFIG_HOME:-~/.config}/rofi/theme.rasi

echo " - gtk context menus"
sed --follow-symlinks -i \
	-e "s|^	background-color: #.*|	background-color: #$bg3;|" \
	-e "s|^	color: #.*|	color: #$fg1;|" \
	${XDG_CONFIG_HOME:-~/.config}/gtk-3.0/menus.css


echo -e "\nChanging wallpaper"
	if [[ -f "$HOME/opt/git/Wallpapers/$wall" ]]; then
	wallthing="feh --bg-fill --no-fehbg \"$HOME/opt/git/Wallpapers/$wall\""
	eval $wallthing
else
	walgen1 "#$wall"
	wallthing="feh --bg-fill --no-fehbg \"$HOME/opt/git/Wallpapers/tile.png\""
	sleep 0.6
fi

echo "#!/bin/sh
$wallthing" > ~/bin/x/pap

#
# tbf I use like 1 gtk app, this doesn't matter
#

# Reload gtk theme - probably a major hack
#temp="$(mktemp)"
#temp2="$(mktemp)"
#echo "Net/IconThemeName \"Blank\"" > $temp2
#xsettingsd -c $temp2 &
#xse2=$!
#sleep 0.08; kill $xse2

#echo "Net/ThemeName \"$theme\"" > $temp
#echo "Net/IconThemeName \"Papirus-Dark\"" >> $temp
#xsettingsd -c $temp &
#xse=$!
#sleep 0.2; kill $xse
#rm $temp $temp2

# Manually change gtk theme
#sed --follow-symlinks -i "s/gtk-theme-name=\".*\"/gtk-theme-name=\"$theme\"/g" ${XDG_CONFIG_HOME:-~/.config}/gtk-2.0/gtkrc-2.0
#sed --follow-symlinks -i "s/gtk-theme-name=.*/gtk-theme-name=$theme/g" ${XDG_CONFIG_HOME:-~/.config}/gtk-3.0/settings.ini


echo -e "\nSending a notification"
notify-send "Theme changed to $theme"
