#!/bin/bash
#             _   _     _      _         
#  __ _  ___ | |_| |__ | | ___| |_ _   _ 
# / _` |/ _ \| __| '_ \| |/ _ \ __| | | |
#| (_| | (_) | |_| |_) | |  __/ |_| |_| |
# \__, |\___/ \__|_.__/|_|\___|\__|\__,_|
# |___/                                  
#       https://www.youtube.com/user/gotbletu
#       https://twitter.com/gotbletu
#       https://plus.google.com/+gotbletu
#       https://github.com/gotbletu
#       gotbleu@gmail.com

# Tutorial video: https://www.youtube.com/watch?v=4LouA5E76FM
# Custom Actions that can be used on any File Manager with Custom Actions Support
# This script is to convert audio file (single) to mp3
# Requirements: ffmpeg notify-send

# thunar custom actions
# command: /path/to/script %n
# note: %n is the first selected filename (without paths)
# conditions: audio files

IMG_LOGO=~/.custom_actions/custom_actions_convert_to_mp3.png

# check if mp3 file NOT exist already to avoid overwriting
if [ ! -f "${1%.*}".mp3 ]; then
  notify-send -i "$IMG_LOGO" 'Convert to MP3' 'Starting ...' -t 5000
  ffmpeg -i "$1" -codec:a libmp3lame -qscale:a 2 "${1%.*}".mp3
  notify-send -i "$IMG_LOGO" 'Convert to MP3' 'Completed !!!' -t 5000

else
  exit
fi



