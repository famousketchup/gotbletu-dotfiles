#!/bin/bash
#             _   _     _      _         
#  __ _  ___ | |_| |__ | | ___| |_ _   _ 
# / _` |/ _ \| __| '_ \| |/ _ \ __| | | |
#| (_| | (_) | |_| |_) | |  __/ |_| |_| |
# \__, |\___/ \__|_.__/|_|\___|\__|\__,_|
# |___/                                  
#       http://www.youtube.com/user/gotbletu
#       https://twitter.com/gotbletu
#       https://plus.google.com/+gotbletu
#       https://github.com/gotbletu
#       gotbleu@gmail.com

# a simple popup reminder script using zenity
# requirements: zenity mplayer wmctrl

# I stolen this script from:
# https://urukrama.wordpress.com/2010/06/16/a-simple-timer/
# http://unix.stackexchange.com/a/152297


REMINDER=`zenity --entry --title="Timer" \
 --text="What should I do?"`
WAIT=`zenity --entry --title="Timer" \
 --text="When should I do this? \n\n e.g 30=sec, 1m=mins, 2h=hours, 3d=days"`
sleep $WAIT

# optional sound, comment out if needed
(sleep 1 && mplayer ~/.soundeffects/batman_rachel_dawes_defines.ogg) &
# (sleep 1 && mplayer ~/.soundeffects/metalgear_alert.ogg) &

# always on top
(sleep 1 && wmctrl -F -a "Timer" -b add,above) &
$(zenity --info --width=200 --height=100 --title="Timer" --text="$REMINDER")



