#!/bin/bash
# sbtv bash clicker
# http://toolbartv.swagbucks.com
# xdotool getmouselocation
# xdotool mousemove x y

# Users only need to change the number ranges and sound

# y cordinates ranges (top to bottom)
FIXEDBOX=$(shuf -i 520-577 -n 1)

# x cordinates ranges (left to right)
# will select a random number within that range
BOX1=$(shuf -i 32-105 -n 1)
BOX2=$(shuf -i 116-190 -n 1)
BOX3=$(shuf -i 200-274 -n 1)
BOX4=$(shuf -i 285-357 -n 1)

# x & y cordinates ranges for the right green arrow
# will select a random number within that range
X_ARROW=$(shuf -i 366-375 -n 1)	# left to right
Y_ARROW=$(shuf -i 540-565 -n 1) # top to bottom

# sleep timer before next click (dont need to change this)
SLPNUM=$(shuf -i 55-80 -n 1)

# sound play when finish
alertme() {
	mplayer ~/Public/sound-effects/mariobros/cheerRedTeam.wav
}

ocrthecode() {
	sleep 2 && scrot -s "/tmp/code.png"
	sleep 2
	xdotool mousemove 497 330
	xdotool click 1
	sleep 2
	tesseract /tmp/code.png /tmp/swagcode
	sleep 3
	awk 'NR==22' /tmp/swagcode.txt | sed 's/ *$//' | xclip -selection clipboard
}
pastethecode() {
	# click on code field
	xdotool mousemove 62 513
	xte 'keydown Control_L' 'key V' 'keyup Control_L'
}



# made it move 2 times to the same box
# my lame way of making it click if i am on the computer using the mouse also.
video_one() {
	xdotool mousemove $BOX1 $FIXEDBOX
	xdotool click 1
	sleep $SLPNUM
}
video_two() {
	xdotool mousemove $BOX2 $FIXEDBOX
	xdotool click 1
	sleep $SLPNUM
}

video_three() {
	xdotool mousemove $BOX3 $FIXEDBOX
	xdotool click 1
	sleep $SLPNUM
}
video_four() {
	xdotool mousemove $BOX4 $FIXEDBOX
	xdotool click 1
	sleep $SLPNUM
}

arrow_click() {
	xdotool mousemove $X_ARROW $Y_ARROW
	xdotool click 1
	sleep 5
}

# start from box1
method_a() {
	# initial sleep time delay; so u can move your terminal/apps out of the way
	sleep 3
	video_one && video_two && video_three && video_four
	arrow_click
	video_one && video_two && video_three && video_four
	arrow_click
	video_one && video_two
	ocrthecode
	pastethecode
	#alertme
}

# start from box3
method_b() {
	# initial sleep time delay; so u can move your terminal/apps out of the way
	sleep 3
	video_three && video_four
	arrow_click
	video_one && video_two && video_three && video_four
	arrow_click
	video_one && video_two && video_three && video_four
	ocrthecode
	pastethecode
#	alertme
}


# This is for when i need to take a long shit; so make it stop at video number 9
# start from box1
shit_a() {
	# initial sleep time delay; so u can move your terminal/apps out of the way
	sleep 3
	video_one && video_two && video_three && video_four
	arrow_click
	video_one && video_two && video_three && video_four
	arrow_click
	video_one
}
# start from box3
shit_b() {
	# initial sleep time delay; so u can move your terminal/apps out of the way
	sleep 3
	video_three && video_four
	arrow_click
	video_one && video_two && video_three && video_four
	arrow_click
	video_one && video_two && video_three
}

# enter in options users like to run
if [[ "$1" == 1 ]]; then
	method_a
elif [[ "$1" == 2 ]]; then
	method_b	
elif [[ "$1" == 1shit ]]; then
	shit_a
elif [[ "$1" == 2shit ]]; then
	shit_b
else
	echo "enter argument 1, 2, 1shit, 2shit. example: swagtv 2"
fi
