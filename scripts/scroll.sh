#!/bin/sh
#Autoscroll test

mouseid=12
button=2
 
buttondown () {
	xinput --query-state $mouseid | grep "button\\[$button\\]" | grep --silent down
}
gety () {
	xdotool getmouselocation | sed 's/y://' | cut -d ' ' -f2
}

starty=$(gety)
printf $'Start Y:\t%s\n' $starty

while buttondown; do
	sleep 0.02
done

distance=$(expr $(gety) - $starty)

if [ $distance -gt 0 ]; then
	direction=5 # Down
else
	direction=4 # Up
	distance=$(printf %s "$distance" | sed s/-//)
fi

printf $'Distance:\t%s\n' $distance
printf $'Direction:\t%s\n' $direction
xdotool click --repeat $(expr $distance / 30 \| 1) --delay 3 $direction
