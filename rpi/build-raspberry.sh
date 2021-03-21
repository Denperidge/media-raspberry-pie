# Install requirements
sudo apt-get -y install samba samba-common-bin

# We will store all the files in the path configured in .env
# Everything from config to the video files 
media_path=$(cat .env | grep MEDIA_PATH= | cut -d '=' -f2)
mkdir -p $media_path
cp .env $media_path
cd "$media_path"

mkdir -p "downloads"  # Downloads: stored here after download in qbittorrent
mkdir -p "torrents"  #  Torrents: .torrent files are kept here
mkdir -p "scripts"  # Where post-download scripts are kept
mkdir -p -m 1777 "scanned"  #  Scanned: stored here after CLAMAV has scanned. Kept here until transcoder moves them
mkdir -p -m 1777 "scanned/sonarr"
mkdir -p -m 1777 "scanned/radarr"
mkdir -p -m 1777 "scanned/other"
mkdir -p -m 1777 "transcoded"  # After transcoder is finished, files are moved here and kept there until imported back to Sonarr/Radarr
mkdir -p -m 1777 "transcoded/sonarr"
mkdir -p -m 1777 "transcoded/radarr"
mkdir -p -m 1777 "logs"  # Logs will be stored here 
mkdir -p "tv"  # Directory to keep tv show files after being downloaded, scanned and transcoded
mkdir -p "movies"  # Directory to keep movies files after being downloaded, scanned and transcoded

# post-download moves downloads to the samba share
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/rpi/post-download.sh" > scripts/post-download.sh
chmod +x scripts/post-download.sh

# sync-subtitles syncs subtitles downloaded by bazarr
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/rpi/sync-subtitles.sh" > scripts/sync-subtitles.sh
chmod +x scripts/sync-subtitles.sh

# fetch docker-compose.yml if it doesn't already exist
if [ ! -f docker-compose.yml ]; then
    echo "No docker-compose file found, downloading newest version..."
    curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/rpi/docker-compose.yml" > docker-compose.yml

else
    echo "Existing docker-compose file found. It will not be replaced to ensure that any changes (mainly mounts) are kept."
    echo "However, if you want to fully recreate your setup, simply hit CTRL+C and manually remove the docker-compose.yml in your $media_path"
    echo "Press ENTER to continue (without recreating your docker setup)"
    read
fi
sudo docker-compose up --detach


echo "downloads setup complete, now setup for transcoding!"
echo "A samba share will now be set up, used by the transcoder to transcode"
echo "/etc/samba/smb.conf will now be opened. Copy the the following lines and add them to the bottom."
echo "[to-transcode]"
echo "   Comment = Folder to allow transcoder to reach files that have to be transcoded"
echo "   Path = $media_path/scanned"
echo "   Browseable = yes"
echo "   Writeable = Yes"
echo "   Public = no"
echo
echo "[transcoded]"
echo "   Comment = Folder where the transcoder will put transcoded files"
echo "   Path = $media_path/transcoded"
echo "   Browseable = yes"
echo "   Writeable = Yes"
echo "   Public = no"
echo
echo "[logs]"
echo "   Comment = Folder to allow transcoder to read logs if need be"
echo "   Path = $media_path/logs"
echo "   Browseable = yes"
echo "   Writeable = Yes"
echo "   Public = no"
echo
echo "[torrents]"
echo "   Comment = Folder to allow the transcoder to access saved .torrent files (if configured)"
echo "   Path = $media_path/torrents"
echo "   Browseable = yes"
echo "   Writeable = Yes"
echo "   Public = no"
read
sudo nano /etc/samba/smb.conf

sudo service smbd restart

clear
echo "Use smbpasswd -a $USER to create a password to let the transcoder log in!"
echo "build-raspberry done"
