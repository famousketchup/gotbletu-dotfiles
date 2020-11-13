#!/bin/sh
# http://sourceforge.net/p/finchnotify/home/Home/
# Finchnotify is a small bash script which is used to notifying the events of finch.

lastest_line=`find ~/.purple/logs/ -mtime -1 -printf "%T@ %Tx %TX %p\n" | sort -n -r | head | cut -d ' ' -f 2- | awk '{print $NF}' | head -1 | xargs tail -1 | sed -e 's#<[^>]*>##g'`
protocol=`find ~/.purple/logs/ -mtime -1 -printf "%T@ %Tx %TX %p\n" | sort -n -r | awk '{print $NF}' | head -1 | sed -e 's#<[^>]*>##g' | cut -d '/' -f 6- | awk -F '/' '{print $1}'`


case "$1" in
  "/usr/share/sounds/purple/send.wav"     )   mplayer $1 >/dev/null 2>&1 &;;
  "/usr/share/sounds/purple/receive.wav"  )   mplayer $1 >/dev/null 2>&1 &
   case "$protocol" in
      "aim"          )  icon=$HOME"/.purple/icons/protocols/message/aim.png";;
      "facebook"     )  icon=$HOME"/.purple/icons/protocols/message/facebook.png";;
      "gadugadu"     )  icon=$HOME"/.purple/icons/protocols/message/gadugadu.png";;
      "icq"          )  icon=$HOME"/.purple/icons/protocols/message/icq.png";;
      "irc"          )  icon=$HOME"/.purple/icons/protocols/message/irc.png";;
      "jabber"       )  icon=$HOME"/.purple/icons/protocols/message/jabber.png";;
      "msn"          )  icon=$HOME"/.purple/icons/protocols/message/msn.png";;
      "myspace"      )  icon=$HOME"/.purple/icons/protocols/message/myspace.png";;
      "qq"           )  icon=$HOME"/.purple/icons/protocols/message/qq.png";;
      "sametime"     )  icon=$HOME"/.purple/icons/protocols/message/sametime.png";;
      "skype"        )  icon=$HOME"/.purple/icons/protocols/message/skype.png";;
      "yahoo"        )  icon=$HOME"/.purple/icons/protocols/message/yahoo.png";;
         *           )  icon=$HOME"/.purple/icons/protocols/message/other.png";;
   esac
                                              notify-send -t 5000 --icon=$icon "`echo $lastest_line | cut -d ':' -f 3 | awk -F ') ' '{print $2}'`" "`echo $lastest_line | cut -d ':' -f 4- | cut -c 2-`";;
  "/usr/share/sounds/purple/alert.wav"    )   mplayer $1 >/dev/null 2>&1 &;;
  "/usr/share/sounds/purple/login.wav"    )   mplayer $1 >/dev/null 2>&1 &
   case "$protocol" in
      "aim"          )  icon=$HOME"/.purple/icons/protocols/big/aim.png";;
      "facebook"     )  icon=$HOME"/.purple/icons/protocols/big/facebook.png";;
      "gadugadu"     )  icon=$HOME"/.purple/icons/protocols/big/gadugadu.png";;
      "icq"          )  icon=$HOME"/.purple/icons/protocols/big/icq.png";;
      "irc"          )  icon=$HOME"/.purple/icons/protocols/big/irc.png";;
      "jabber"       )  icon=$HOME"/.purple/icons/protocols/big/jabber.png";;
      "msn"          )  icon=$HOME"/.purple/icons/protocols/big/msn.png";;
      "myspace"      )  icon=$HOME"/.purple/icons/protocols/big/myspace.png";;
      "qq"           )  icon=$HOME"/.purple/icons/protocols/big/qq.png";;
      "sametime"     )  icon=$HOME"/.purple/icons/protocols/big/sametime.png";;
      "skype"        )  icon=$HOME"/.purple/icons/protocols/big/skype.png";;
      "yahoo"        )  icon=$HOME"/.purple/icons/protocols/big/yahoo.png";;
         *           )  icon=$HOME"/.purple/icons/protocols/big/other.png";;
   esac
                                              notify-send -t 5000 --icon=$icon "`echo $lastest_line | cut -d '(' -f 1 | awk '{for(i=3;i<=NF;i++)printf("%s ",$i);}'`" "`echo je teraz online`";;
  "/usr/share/sounds/purple/logout.wav"   )   mplayer $1 >/dev/null 2>&1 &
   case "$protocol" in
      "aim"          )  icon=$HOME"/.purple/icons/protocols/big/aim.png";;
      "facebook"     )  icon=$HOME"/.purple/icons/protocols/big/facebook.png";;
      "gadugadu"     )  icon=$HOME"/.purple/icons/protocols/big/gadugadu.png";;
      "icq"          )  icon=$HOME"/.purple/icons/protocols/big/icq.png";;
      "irc"          )  icon=$HOME"/.purple/icons/protocols/big/irc.png";;
      "jabber"       )  icon=$HOME"/.purple/icons/protocols/big/jabber.png";;
      "msn"          )  icon=$HOME"/.purple/icons/protocols/big/msn.png";;
      "myspace"      )  icon=$HOME"/.purple/icons/protocols/big/myspace.png";;
      "qq"           )  icon=$HOME"/.purple/icons/protocols/big/qq.png";;
      "sametime"     )  icon=$HOME"/.purple/icons/protocols/big/sametime.png";;
      "skype"        )  icon=$HOME"/.purple/icons/protocols/big/skype.png";;
      "yahoo"        )  icon=$HOME"/.purple/icons/protocols/big/yahoo.png";;
         *           )  icon=$HOME"/.purple/icons/protocols/big/other.png";;
   esac
                                              notify-send -t 5000 --icon=$icon "`echo $lastest_line | cut -d '(' -f 1 | awk '{for(i=3;i<=NF;i++)printf("%s ",$i);}'`" "`echo je teraz offline`";;
    *                                     )   notify-send -t 5000 --icon=$HOME"/.purple/icons/error.png" "Neznáma akcia programu Finch!";;
esac
