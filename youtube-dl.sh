## source: https://askubuntu.com/questions/784240/how-can-i-download-a-youtube-playlist
## source: https://www.howtoforge.com/tutorial/install-and-use-youtube-dl-on-ubuntu-1604/

## remove/purge old version of youtube-dl if needed
sudo apt-get remove <application_name> ## removes only the package
sudo apt-get purge <package-name> ## removes package + its config files
sudo apt-get autoremove ## run this after a purge

## update and upgrade repos
sudo apt-get update -y
sudo apt-get upgrade -y

## install curl
sudo apt-get install curl -y

## install youtube-dl binary
sudo curl -L https://yt-dl.org/latest/youtube-dl -o /usr/bin/youtube-dl

## change permissions
sudo chmod 755 /usr/bin/youtube-dl

## add PPA
sudo add-apt-repository ppa:nilarimogard/webupd8

## update package repo
sudo apt-get update -y
sudo apt-get install youtube-dlg -y

## now you can launch from Unity Dash

####################################

## To use youtube-dl

## install all the available options
youtube-dl --h

## download a playlist as mp4 (format code = 18)
youtube-dl -f 18 https://www.youtube.com/watch?v=j_JgXJ-apXs

## if you want to check available formats 
youtube-dl -F https://www.youtube.com/watch?v=j_JgXJ-apXs

## download mp3 format
youtube-dl https://www.youtube.com/watch?v=j_JgXJ-apXs -x --audio-format mp3

## if the playlist is behind a proxy
youtube-dl --proxy http://proxy-ip:port https://www.youtube.com/watch?v=j_JgXJ-apXs

## download from a specified list of URLs
youtube-dl -a youtube-list.txt ## but first save URLs in youtube-list.txt, one per line
