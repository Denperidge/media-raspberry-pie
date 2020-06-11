# apt-get update & upgrade before installing requirements
sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install samba samba-common-bin

# We will store all the files in the path configured in .env
# Everything from config to the video files 
media_path=$(cat .env | grep MEDIA_PATH= | cut -d '=' -f2)
mkdir -p $media_path
cd "$media_path"

mkdir -p "downloads"  # Downloads: stored here after download in qbittorrent
mkdir -p "torrents"  #  Torrents: .torrent files are kept here
mkdir -p -m 1777 "scanned"  #  Scanned: stored here after CLAMAV has scanned. Kept here until transcoder moves them
mkdir -p -m 1777 "scanned/sonarr"
mkdir -p -m 1777 "scanned/radarr"
mkdir -p -m 1777 "transcoded"  # After transcoder is finished, files are moved here and kept there until imported back to Sonarr/Radarr
mkdir -p -m 1777 "transcoded/sonarr"
mkdir -p -m 1777 "transcoded/radarr"
mkdir -p -m 1777 "logs"  # Logs will be stored here 
mkdir -p "tv"  # Directory to keep tv show files after being downloaded, scanned and transcoded
mkdir -p "movies"  # Directory to keep movies files after being downloaded, scanned and transcoded

# post-download moves downloads to the samba share
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/rpi/post-download.sh" > downloads/post-download.sh
chmod +x downloads/post-download.sh

# setup docker
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/rpi/docker-compose.yml" > docker-compose.yml
sudo docker-compose up --detach

# Add some necessary defaults to qbittorrent
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/rpi/setup-qbittorrent.py" > setup-qbittorrent.py
python3 setup-qbittorrent.py

read
clear

echo "downloads setup complete, now setup for transcoding!"
echo "A samba share will now be set up, used by the transcoder to transcode"
echo "/etc/samba/smb.conf will now be opened. Copy the the following lines and add them to the bottom."
echo "[to-transcode]"
echo "   Comment = Folder to allow transcoder to reach files that have to be transcoded"
echo "   Path = $media_path/scanned"
echo "   Browseable = yes"
echo "   Writeable = Yes"
echo "   only guest = no"
echo "   Public = yes"
echo
echo "[transcoded]"
echo "   Comment = Folder where the transcoder will put transcoded files"
echo "   Path = $media_path/transcoded"
echo "   Browseable = yes"
echo "   Writeable = Yes"
echo "   only guest = no"
echo "   Public = yes"
echo
echo "[logs]"
echo "   Comment = Folder to allow transcoder to read logs if need be"
echo "   Path = $media_path/logs"
echo "   Browseable = yes"
echo "   Writeable = Yes"
echo "   only guest = no"
echo "   Public = yes"
read
sudo nano /etc/samba/smb.conf

sudo service smbd restart

clear
echo "Use smbpasswd -a $USER to create a password to let the transcoder log in!"
echo "build-raspberry done"
