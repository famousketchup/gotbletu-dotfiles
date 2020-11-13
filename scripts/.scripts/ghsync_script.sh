#!/bin/bash
# http://linuxtidbits.wordpress.com/2012/05/30/managing-scripts-and-configurations-on-github-with-a-script/
# https://gist.github.com/Gen2ly/2839879
# Create a github repository for scripts

# Github repository name to use, Github repository address
#gh_rp_nm="github_scripts"
#gh_rp_dr="git@github.com:Gen2ly/scripts.git"
gh_rp_nm="dotfiles"
gh_rp_dr="git@github.com:gotbletu/dotfiles.git" # click the ssh button on page

# Base directory, repository directory
#base_dir=""$HOME"/.scripts/"
#repo_dir=""$HOME"/.github-scripts/"
base_dir=""$HOME"/Public/Dropbox/dotfiles/"			# local folder
repo_dir=""$HOME"/Public/github_repository/dotfiles/"		# repository

# Files and directories to upload to github repository
#gitadd=(file1 dir1)
gitadd=(
	.aliases_gotbletu
	.tmux.conf
	.torrtuxrc
	.vimrc
	.Xresources
	)

# Files and directories it ignore in above repo_dir
gitignore=(.gitignore
            root/arch/vault
            root/vault
            vault)

# Create local repository directory if doesn't exist
[ ! -d "$repo_dir" ] && mkdir -p "$repo_dir"

# Clone base_dir when gitadd has files http://tinyurl.com/rsync-del-filenames
cd "$base_dir"
#rm -fr "$repo_dir"*
#rsync -axSR         "${gitadd[@]}" "$repo_dir"
# Clone base_dir when gitadd is single directory
rsync -axS --delete "${gitadd[@]}" "$repo_dir"

# Initialize local repository to git; define remote repository
cd "$repo_dir"
git init
git remote add "$gh_rp_nm" "$gh_rp_dr"

# Set ignore files/directories from gitignore array
for i in ${gitignore[@]}; do
    echo "$i" >> .gitignore || exit
    echo " Placed in git ignore list: "$i""
done

# Sort git ignore list
sort -u .gitignore -o .gitignore || exit

# Add files and directories to git index
for i in ${gitadd[@]}; do
  if [ ! -e "$i" ]; then
    echo " No file or directory by the name of "$base_dir"/"$i"" && exit
  else
    git add "$i" 2> /dev/null
    echo " Added to git index: "$i""
  fi
done

# Record changes to all files, rm those not in index, and add commit message
git commit -a -m "Weekly update" || exit
echo " Recorded repository contents, created commit message"

# Enter ssh passphrase automatically
#echo "  Starting ssh-agent, automatically entering password..."
#eval $(ssh-agent)
#entpass=$(echo "spawn ssh-add /home/$USER/.ssh/id_rsa
#expect \"Enter passphrase for key.*\"
#send \"thepassphrase\\n\"
#expect eof" | expect -f -)
#echo $entpass || exit

# Sync local repository to github repository
git push --force "$gh_rp_nm" master && \
echo " Synced local repository to github repository"
