#!/bin/bash
# tutorial video: https://www.youtube.com/watch?v=9T4VtC5Bhmo
# http://crunchbang.org/forums/viewtopic.php?pid=396202#p396202
# shoutcast_radionomy_search.sh
# search shoutcast and radionomy,
# send url to radiotray, mpg123, mplayer or another player
# send url to streamripper to record
#
# version 3.1
#
# needs curl, [radiotray, dbus | mpg123 | mplayer], streamripper, [xsel], [perl]
# xsel enables pasting from the X selection (to a config file etc.)
# Comment out line 288 "printf '%s'..." if you don't use it.
# perl is used to urlencode the query.
# Comment out line 246 and uncomment line 245 to escape spaces only
# if your system doesn't have perl.
#
# KEYBOARD SHORTCUTS:
# Ctrl+C to exit normally
# Ctrl+\ to terminate and close player
# Ctrl+Z to start recording current station (handles SIGTSTP)

##### choose from radiotray, mpg123 or mplayer #####
# player=radiotray
#player=mpg123
player=mplayer

# Set this to something other than 'true'
# to have audio player exit with script.
# Otherwise player will continue till closed separately.
# Even with 'keep_player=true', if script is stopped with Ctrl+\
# then player will exit too.
keep_player=true

##### code to record a radio stream (url is $1) in a new terminal #####
# Add your own options to streamripper's command line,
# edit ~/.config/streamripper/streamripper.ini,
# change urxvt to another terminal
# or use a different command altogether.
recorder() {
    ( setsid urxvt -e streamripper "$1" >/dev/null 2>&1 & )
}

# where to put player control fifo
# (radiotray doesn't use this)
rpipe=/tmp/radio_pipe

HELP="This is an interactive script to query the Shoutcast and Radionomy listings,
put the results in a menu,
and load the chosen radio station in radiotray, mpg123 or mplayer.
There is also an option to record with streamripper.

If you exit the script and leave mpg123 or mplayer running,
you can close either of them with the command:
echo quit >$rpipe

KEYBOARD SHORTCUTS:
Ctrl+C to exit normally
Ctrl+\ to terminate and close player
Ctrl+Z to start recording current station (handles SIGTSTP)"

##########################################################################

case $1 in
--help|-h)
    echo "$HELP"
    exit
    ;;
esac

case $player in

##### RADIOTRAY SETTINGS #####
radiotray)
required_commands='curl streamripper radiotray'
start_player() {
    if pgrep radiotray >/dev/null
    then
        echo "$player is already running"
    else
        ( setsid radiotray >/dev/null 2>&1 & )
    fi
}
radioplay() {
    radiotray "$1"
}
cleanup() { # run just before exit
    [[ $player_ok = true ]] && [[ $keep_player = true ]] && {
        echo "$player will continue to play.
You can control it from the system tray icon
or run the script again to choose another station."
        sleep 4
        return
    }
    pkill radiotray && echo "Closed radiotray."
    sleep 4
}
;;
##### END RADIOTRAY #####

##### MPLAYER SETTINGS #####
mplayer)
required_commands='curl streamripper mplayer'
player_regex="^mplayer .*-input file=$rpipe"
launch_player() {
    [[ -p $rpipe ]] || { mkfifo "$rpipe" || error_exit "cannot make fifo $rpipe"; }
    ( setsid sh -c "mplayer -really-quiet -idle -slave -input file=$rpipe; rm -f $rpipe;" >/dev/null 2>&1 & )
    sleep 4 & launching_player=$!
}
load_url() {
    echo "loadlist $1" >"$rpipe"
}
;;&
##### END MPLAYER #####

##### MPG123 SETTINGS #####
mpg123)
required_commands='curl streamripper mpg123'
player_regex="^mpg123 .*--fifo $rpipe"
launch_player() { # mpg123 will make fifo if necessary
    ( setsid sh -c "mpg123 --remote --fifo $rpipe; rm -f $rpipe;" >/dev/null 2>&1 & )
    (sleep 2; echo 'silence' >"$rpipe") & launching_player=$!
}
load_url() {
    echo "loadlist 1 $1" >"$rpipe"
}
;;&
##### END MPG123 #####

##### COMMON TO MPLAYER AND MPG123 #####
mplayer|mpg123)
start_player() {
    if pgrep -f "$player_regex" >/dev/null
    then
        echo "$player is already running"
        [[ -p $rpipe ]] || error_exit "fifo missing $rpipe"
        (:>"$rpipe") & test_pipe=$!
        (sleep 2; kill $test_pipe 2>/dev/null && kill -s SIGPIPE $selfpid) &
    else
        launch_player
    fi
}
radioplay() {
    wait $launching_player
    [[ -p $rpipe ]] || error_exit "fifo missing $rpipe"
    pgrep -f "$player_regex" >/dev/null || error_exit "$player not running"
    load_url "$1"
}
cleanup() { # run just before exit
    [[ -p $rpipe ]] || { player_ok=false; echo "Script error: fifo $rpipe does not exist." >&2 ;}
    pgrep -f "$player_regex" >/dev/null || { player_ok=false; echo "Script error: $player not running" >&2 ;}
    [[ $player_ok = true ]] && {
        [[ $keep_player = true ]] && {
            echo "$player will continue to play.
You can stop it with the command:
echo quit >$rpipe
or run the script again to choose another station."
            sleep 4
            return
        }
        echo "closing $player..."
        echo 'quit' >"$rpipe" # try to close player nicely
        sleep 2 # time for player to quit
    }
    pkill -f "$player_regex" && echo "$player close forced."
    echo "removing $rpipe"
    rm -f "$rpipe" # in case it has become a normal file
}
;;
##### END COMMON TO MPLAYER AND MPG123 #####

*)
echo "$0: chosen player $player has not been configured.
Please check line 17 of the script" >&2
exit 1
;;
esac

##########################################################################
selfpid=$$
player_ok=true
error_exit() {
    echo "Script error: $1" >&2
    player_ok=false
    exit 1
}
trap 'cleanup' EXIT
trap 'echo " Exit script
Goodbye..."; exit' SIGHUP SIGINT
trap 'echo " Exit script
($player will be shut down)
Goodbye..."; keep_player=false; exit' SIGQUIT
trap 'error_exit "script terminated"' SIGTERM
trap 'error_exit "broken pipe"' SIGPIPE
trap 'recorder "${playing_url%.m3u}"' SIGTSTP

missing_commands=
for i in $required_commands
do
    hash $i || missing_commands+=" $i"
done
[[ $missing_commands ]] && error_exit "This script requires the following commands: $missing_commands
Please install the packages containing the missing commands
and rerun the script."

query_shoutcast() {
    curl -s --data "query=$1" "http://www.shoutcast.com/Search/UpdateSearch" | awk '
    BEGIN {
        RS="},{"
    }
    {
        url = name = $0
        if($0=="[]") {exit}
        sub(/^.*\"ID\":/,"",url)
        sub(/,.*$/,"",url)
        url = "http://yp.shoutcast.com/sbin/tunein-station.pls?id=" url
        sub(/^.*\"Name\":\"/,"",name)
        sub(/\".*$/,"",name)
        print url,name
    }
    '
}
query_radionomy() {
    curl -sL "http://www.radionomy.com/en/search?q=$1" |awk '
    BEGIN {
        RS="<h2 class=\"radio-title-list\"><a href=\"/en/radio/"
        FS="</a></h2>"
    }
    NR < 2 {next}
    {
        url = name = $1
        sub(/^.*>/,"",name)
        sub(/\/index\".*$/,"",url)
        url="http://listen.radionomy.com/" url ".m3u"
        print url,name
    }
    '
}

start_player

unset playing_name playing_url
while true
do
echo "Please enter keyword(s)"
read keyword
#keyword_esc="${keyword// /%20}" # escape spaces for url
keyword_esc=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$keyword")
results_sh=$( query_shoutcast "$keyword_esc" )
results_ra=$( query_radionomy "$keyword_esc" )

if [[ $results_sh ]] && [[ $results_ra ]]
then
    results="$results_sh"$'\n'"$results_ra"
elif [[ $results_sh ]]
then
    echo "No results for $keyword on radionomy"
    results="$results_sh"
elif [[ $results_ra ]]
then
    echo "No results for $keyword on shoutcast"
    results="$results_ra"
else
    echo "Sorry, no results for $keyword"
    continue
fi

unset list
declare -A list # make associative array
while read -r url name # read in awk's output
do
    list["$name"]="$url"
done <<< "$results"

PS3='Please enter the number of your choice > '
while true
do
    menu=("${!list[@]}")
    [[ $playing_name && $playing_url ]] && menu+=("RECORD \"$playing_name\"")
    select station in "${menu[@]}" 'SEARCH AGAIN' QUIT
    do
        [[ $station = "RECORD \"$playing_name\"" ]] && {
            recorder "${playing_url%.m3u}" # streamripper won't take m3u urls
            break
        }
        [[ $station = 'SEARCH AGAIN' ]] && break 2
        [[ $station = QUIT ]] && { echo 'Goodbye...'; exit; }
        [[ $station ]] && {
# comment out next line if you don't use xsel
            printf '%s' "${list[$station]}" | xsel --input #--clipboard  # can paste url
            radioplay "${list[$station]}"
            playing_name=$station
            playing_url=${list[$station]}
            break
        }
    done
echo "
Station last chosen was \"$playing_name\" ( $playing_url )
"
done # closes loop started at line 274

done # closes loop started at line 241

exit

