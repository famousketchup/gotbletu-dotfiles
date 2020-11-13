#!/bin/bash
#
# z3bra -- 2014-01-21 original author
# tmathmeyer -- 2015-10-26 tweaks to make it more usable

test -z "$1" && exit

W3MIMGDISPLAY="/usr/lib/w3m/w3mimgdisplay"
FILENAME=$1
FONTH=17 # Size of one terminal row
FONTW=9  # Size of one terminal column

XMIN=$2 # number of cells
YMIN=$3 # number of cells

COLUMNS=`tput cols`
LINES=`tput lines`
TOP=0
LEFT=0

read width height <<< `echo -e "5;$FILENAME" | $W3MIMGDISPLAY`


max_width=$(($FONTW * $(($COLUMNS - $XMIN))))
max_height=$(($FONTH * $(($LINES - $YMIN - 2)))) # substract one line for prompt

if test $width -gt $max_width; then
    height=$(($height * $max_width / $width))
    width=$max_width
fi
if test $height -gt $max_height; then
    width=$(($width * $max_height / $height))
    height=$max_height
fi

xml=$(($XMIN * $FONTW))
yml=$(($YMIN * $FONTH))
lines=$(($LINES * $FONTH))
columns=$(($COLUMNS * $FONTW))
TOP=$(($(($lines - $height + $yml)) / 2))
LEFT=$(($(($columns - $width + $xml)) / 2))
w3m_command="0;1;$LEFT;$TOP;$width;$height;;;;;$FILENAME\n4;\n3;"

tput cup $(($height / $FONTH)) 0
echo -e $w3m_command|$W3MIMGDISPLAY
