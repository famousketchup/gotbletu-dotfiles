# The 411 Listing
- Converted Markdown to HTML, Exported as Styled HTML (http://dillinger.io/)
- Using PythonSimpleHTTPServer to host html.
- This page link is at: http://192.168.1.100:5000


# Port Rules
- System Ports (0-1023): Avoid standard ports, it is used by many common services.
- User Ports (1024-49151): Avoid IANA reserve ports for applications.
- Dynamic and/or Private Ports (49152-65535): Ideal for custom port numbers.

![alt text](http://i.imgur.com/48EANfc.jpg)

# WebUI
- asus-router		http://192.168.1.1
- obihai		http://192.168.1.99
- calibre-book  	http://192.168.1.100:57770 (default: 8080)
- calibre-comic   	http://192.168.1.100:57771
- calibre-dojinshi	http://192.168.1.100:57772
- calibre-super  	http://192.168.1.100:57773
- cups	         	http://192.168.1.100:631
- nzbget	       	http://192.168.1.100:6789
- simplehttpserver     	http://192.168.1.100:8000
- pyload	       	http://192.168.1.100:8228 (Remote Port: 7227)
- syncthing	       	http://192.168.1.100:8384
- ubooquity	    	http://192.168.1.100:2202
  - ubooquity-admin	http://192.168.1.100:2202/admin
- transmission    	http://192.168.1.100:9091/transmission/web/
- webmin		https://192.168.1.100:10000 (http/https)
- wififiletransfer	http://192.168.1.115:1234 (Samsung Note 2)
- ~~btsync		http://192.168.1.100:7349 (listening: 6349 ; custom webui: 7349 )~~
- ~~mediatomb		http://192.168.1.100:49152/ (no default port)~~
- ~~sharlin		http://192.168.1.100:7349 (listening: 6349 ; custom webui: 7349 )~~
- ~~subsonic		http://192.168.1.100:4040~~

# Software
- kodi webserver	http://192.168.1.100:49155 (default: 8080 --> 49155 )
- mpd			6600
- samba			TCP 139/445 ; UDP 137/138
- ssh			BOTH 22
- sopcast		localport(sp-sc): 55050 ; playerport (vlc,mplayer): 55051
- ~~aircomicserver	remote port: 21002~~

# Service Device
- 192.168.1.99      OBi200 (Obihai); 9C:AD:EF:60:43:92
- 192.168.1.98      Pogoplug Mobile (POGO-V4-A1-01 eth0); 00:25:31:06:31:6F
- 192.168.1.197     Pogoplug Pro (POGO-P02 Wifi); 48:5D:60:4B:DC:2E 
  - 192.168.1.97      Pogoplug Pro (POGO-P02 eth0); 00:25:31:01:C2:06

# Server Machine
- 192.168.1.100     Arch Server; D4:3D:7E:F5:B9:A9
- 192.168.1.201     RPi B wifi (Openelec); C8:3A:35:C6:A6:7C
  - 192.168.1.101     RPi B eth0 (Openelec); B8:27:EB:FB:EE:5B 


# Desktop/Laptop
- 192.168.1.105     SteamOS (Windows PC); 00:A1:B0:C0:16:13
- 192.168.1.107     iMac 17" Early 2006; 00:16:CB:83:DD:3B
- 192.168.1.102     EEEPC
- ~~192.168.1.106     Mom PC~~
- ~~192.168.1.108     HP Laptop~~
- 192.168.1.97      Asus Router (Repeater)
- 192.168.1.109     Zotac Zbox AD10 eth0 00:01:2E:40:A1:72
- 192.168.1.209     Zotac Zbox AD10 wifi 00:08:CA:39:67:E5

# Portable Device
- 192.168.1.115     Samsung Note 2; 5C:0A:5B:FB:31:25

# Virtual Machine
- 192.168.1.150     Windows XP
- 192.168.1.152     Windows 7
- ~~192.168.1.151     Windows Vista~~
- ~~192.168.1.153     Windows 8~~


- ~~192.168.1.155     Ubuntu~~
- ~~192.168.1.155     Xubuntu~~
- ~~192.168.1.156     Lubuntu~~
- ~~192.168.1.157     Ubuntu Mate~~

# UnAssigned


# References
- http://stackoverflow.com/questions/10476987/best-tcp-port-number-range-for-internal-applications
- http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml
