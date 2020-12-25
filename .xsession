source $HOME/.profile
xrdb   $HOME/.Xresources
xset r rate 200
$HOME/.dwm_date.sh &
setroot --fit-width $HOME/Pictures/wallpaper.jpeg
xmodmap -e "keycode 108 = Multi_key" # the right alt key
case $(hostname) in
	z-nixos-desktop)
		xrandr --rate 144.00
		xbindkeys
		;;
esac

dwm
