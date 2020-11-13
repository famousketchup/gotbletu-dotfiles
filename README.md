### Aliases and Functions are usually in:
    aliasrc
    bashrc
    zshrc
    
- I try to write notes on each sh/t in the config, hope that helps =)

![alt text](http://i.imgur.com/EcQoF8a.gif)


### Fresh Install Info
    sudo pacman -S git stow
    cd ~/Public
    git clone https://github.com/gotbletu/dotfiles.git
    mkdir -p ~/Downloads/stowbackup
    mv ~/.bashrc ~/Downloads/stowbackup
    # symlink all files in dotfiles dir to home dir
    cd ~/Public/dotfiles
    
    # link only folders (trailing slash)
    stow -v -t ~ */
        # delete (-D flag)
        stow -v -D -t ~ */
        stow -v -D -t ~ tmux
        # redo link (-R)
        stow -v -R -t ~ */
        stow -v -R -t ~ tmux
    sudo pacman -S zsh zsh-completions
    chsh -s /usr/bin/zsh
    cd ~/Public/dotfiles/zshrc
    git clone https://github.com/robbyrussell/oh-my-zsh.git
    

### Essentials
    aria2 atool coreutils curl gvfs htop less mlocate moreutils ranger tmux util-linux vim wget

### CLI
    cclive clamav cmatrix cmus finch ffmpeg glances handbrake-cli inxi livestreamer lynx mutt ncdu newsbeuter pastebinit pianobar plowshare quvi rsync samba scrot sshfs surfraw transmission-cli transmission-remote-cli w3m weechat xclip youtube-dl
   
### Terminal Games
    curseofwar
    
### GUI
    mplayer mpv parcellite ristretto vlc

### Other


    wicd-curses
    trash-cli
    tty-clock urlview 
    fuseiso
    cdw
    task-spooler
    patool
    mps-youtube
    youtube-viewer
    wego
    rtv
    cava

    
### Antegros Specific
    cronie openssh  python2-pip syncthing yaourt

### Arch AUR Specific
    detox debtap fasd feednix fu-git fzf keepassc kpcli manga_downloader mountie quicktile-git scim-spreadsheet

### Pip2 Specific
    flexget==1.2.128 patool periscope pyload

### Manually
    ubooquity tsp sopcast

### Debian Specific
    aptitude chkconfig cron openssh-client openssh-server python-pip surfraw-extra sysv-rc-conf task-spooler transmission-deamon weechat-plugins weechat-scripts


#chromium
Google Voice
RSS
uBlock Origin
vimium
.torrent to transmission
Shine for reddit
    
# vim plugins
cd ~/.vim/bundle
https://github.com/tpope/vim-pathogen
git clone https://github.com/tomtom/tcomment_vim.git
git clone https://github.com/suan/vim-instant-markdown
git clone https://github.com/vimwiki/vimwiki
git clone https://github.com/vim-scripts/snipMate
translate
    


### pip specific

cfdisk

stag



keepassc kpcli
glances
scim


flexget syncthing ubooquity pyload feednix periscope fu
translate manga-downloader pip2 inxi patool fzf fasd
mountie

----

                 _   _     _      _         
      __ _  ___ | |_| |__ | | ___| |_ _   _ 
     / _` |/ _ \| __| '_ \| |/ _ \ __| | | |
    | (_| | (_) | |_| |_) | |  __/ |_| |_| |
     \__, |\___/ \__|_.__/|_|\___|\__|\__,_|
     |___/                                  

- http://www.youtube.com/user/gotbletu
- https://twitter.com/gotbletu
- https://plus.google.com/+gotbletu
- https://github.com/gotbletu
- gotbletu@gmail.com
 

