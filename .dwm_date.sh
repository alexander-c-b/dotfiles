#!/bin/sh

# Time
function clock {
	case $(date +%I) in
		01)	echo 🕐 ;;
		02)	echo 🕑 ;;
		03)	echo 🕒 ;;
		04)	echo 🕓 ;;
		05)	echo 🕔 ;;
		06)	echo 🕕 ;;
		07)	echo 🕖 ;;
		08)	echo 🕗 ;;
		09)	echo 🕘 ;;
		10)	echo 🕙 ;;
		11)	echo 🕚 ;;
		12)	echo 🕛 ;;
	esac
}

function now {
	date "+ 📅 %a %b %d %Y $(clock) %-l:%M %p %Z"
}

# Battery
battery_prefix=/sys/class/power_supply/BAT1

function capacity {
	cat $battery_prefix/capacity
}

function warn_battery {
	if [ -e $battery_prefix -a $(capacity) -lt 6 \
			-a $(< $battery_prefix/status) = Discharging ]; then
		printf 'Check battery! %.0s' 1 2 3 4 5 | \
		dmenu -fn 'UbuntuMono:size=16' -sb '#9c1f16' \
		> /dev/null
	fi
}

function status {
	case $(< $battery_prefix/status) in
		Discharging)	echo ↓ ;;
		Charging)	echo ↑ ;;
		Full)		echo ✓ ;;
	esac
}

if [[ -e $battery_prefix ]]; then
	function battery { echo " 🔋 $(status)$(capacity)%"; }
else
	function battery { echo ""; }
fi

# Main
function status_bar {
	xsetroot -name "$(battery)$(now)"
}

status_bar

sleep $(expr 60 - $(date +%S))

while true; do
	status_bar
	warn_battery
	sleep 60
done
