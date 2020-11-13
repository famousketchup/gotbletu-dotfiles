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

# Script to download wallpapers from reddit subreddits

# dir to save wallpapers to
cd ~/Pictures/Wallpapers

lynx -dump "http://www.reddit.com/r/wallpaper/new" | awk '/jpg$/ || /png$/ { print $2}' | xargs -n1 wget -N 
lynx -dump "http://www.reddit.com/r/wallpapers/new" | awk '/jpg$/ || /png$/ { print $2}' | xargs -n1 wget -N 
lynx -dump "http://www.reddit.com/r/Animewallpaper/new/" | awk '/jpg$/ || /png$/ { print $2}' | xargs -n1 wget -N 
lynx -dump "http://www.reddit.com/r/WQHD_Wallpaper/new/" | awk '/jpg$/ || /png$/ { print $2}' | xargs -n1 wget -N 

# NSFW Wallpapers
# lynx -dump "http://www.reddit.com/r/NSFW_Wallpapers/new/" | awk '/jpg$/ || /png$/ { print $2}' | xargs -n1 wget -N 

