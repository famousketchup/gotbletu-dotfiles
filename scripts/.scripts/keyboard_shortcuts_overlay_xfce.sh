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

# zenity to display keyboard shortcuts list reminder
# requirements: zenity wmctrl


REMINDER="
Super+B					Show Keyboard Shortcuts Binding List (script)
Super+R					Change Wallpaper Randomly (xfdesktop -N)
Super+P					Package Manager (octopi)
Super+G					Garbage | Trash (thunar trash:///)
Super+E					Text Editor (mousepad)
Super+C					Calculator (gnome-calculator)
Super+F					File Manager (thunar)
Super+M					Music Player (deadbeef)
Super+L					Locate File (catfish)
Super+T					Terminal (xfce4-terminal)
Super+V					Volume Control (pavucontrol)
Super+W					Web Browser (chromium)
Super+K					Keyboard Shortcuts Settings (xfce4-keyboard-settings)
Super+S					System Settings (xfce4-settings-manager)
grave					Toggle Drop Down Terminal

Ctrl+Alt+Backspace		Logout Screen (xfce4-session-logout)
Ctrl+Alt+ArrowKeys		Change Workspace
Ctrl+FKeys (F1-F12)		Change Workspace (Specific)
Ctrl+Alt+Delete			Task Manager (xfce4-taskmanager) [WinXP Style]
Ctrl+Alt+L				Lock Screen (xscreensaver-command -lock)
Ctrl+Alt+D				Show Desktop
Ctrl+Shift+Esc			Kill Window (xkill)

PrintScr					Take Screenshot Fullscreen (xfce4-screenshooter -f)
Alt+PrintScr				Take Screenshot Window (xfce4-screenshooter -w)
Ctrl+PrintScr				Take Screenshot Region Using Mouse (xfce4-screenshooter -r)

Alt+Delete				Delete Workspace
Alt+Insert				Add Workspace
Alt+Tab					Cycle Windows
Super+Space				Application Launcher (xfce4-popup-whiskermenu)
Ctrl+Space				Application Launcher | Window Picker (xfdashboard)

Clipboard (parcellite -n)
Super+H					Clipboard Manager History
Super+J					Clipboard Manager Preferences Settings
Ctrl+Shift+B				Paste in Plain Text (script)

Windows Tiling (quicktile) [Compiz Grid | Aero Snap]
>> /home/heoyea-core/.config/quicktile/quicktile.py --daemonize
Ctrl+Super+H				Tile Left
Ctrl+Super+L				Tile Right
Ctrl+Super+J				Tile Bottom
Ctrl+Super+K				Tile Top
Ctrl+Super+N				Tile Bottom Left
Ctrl+Super+M			Tile Bottom Right
Ctrl+Super+I				Tile Top Left
Ctrl+Super+O				Tile Top Right
Ctrl+Super+0 (zero)		Maximize Window
Ctrl+Super+C				Center Window
Ctrl+Super+B				Maximize Horizontal
Ctrl+Super+V				Maximize Vertical
Ctrl+Super+NumPad (0-9)	Tile Alternative Hotkeys

Shift+PrintScr				Take Screenshot Fullscreen (autosave)
Ctrl+Esc					Task Manager (xfce4-taskmanager) [KDE Style]

"

# Windows Picker (skippy-xd) [Compiz Scale | OSX Expose]
# >> skippy-xd --start-daemon
# Super+A					Window Picker (skippy-xd --activate-window-picker)
# --HJKL					Vim Keys to Move
# --Middle Click				Close Window

# # always on top
(sleep 1 && wmctrl -F -a "Keyboard Shortcuts" -b add,above) &
(zenity --info --width=800 --title="Keyboard Shortcuts" --text="$REMINDER")


