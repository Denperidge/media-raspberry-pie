#!/bin/bash

set -e  # Exit on error

# Install requirements through apt-get
sudo apt-get -y install git samba samba-common-bin

# .env configuration
function setup_env {
    if [ ! "$4" ]; then  # If outputfule isn't set, default to env
        outputfile=".env"
    else
        outputfile="$4"
    fi

    # Only add to env if key isn't already set
    if ! grep -q "$2" "$outputfile"; then
        read -p "$1 [$3]: " env_value
        env_value="${env_value:-$3}"
        echo "$2=$env_value" >> $outputfile
    fi   
}

# We will store all the config & video files in the path configured in .env
# (media_path also needs to be set in .env)
setup_env "Install location (if possible, a non sd-card is recommended)" MEDIA_PATH /usr/local/bin/mrpi-media/
media_path=$(cat .env | grep MEDIA_PATH= | cut -d '=' -f2)
sudo mkdir -p $media_path
username=$(whoami)
sudo chown $username $media_path
mv .env "$media_path/.env"
cd "$media_path"

setup_env "Timezone (en.wikipedia.org/wiki/List_of_tz_database_time_zones)" TZ "$(cat /etc/timezone)"
setup_env "Qbittorrent port" PORT_QBITTORRENT 8080
setup_env "Sonarr port" PORT_SONARR 8989
setup_env "Radarr port" PORT_RADARR 7878
setup_env "Jackett port" PORT_JACKETT 9117
setup_env "Bazarr port" PORT_BAZARR 6767
echo "The following three settings will effect ownership/permissions of the files created by docker"
setup_env "  UID" PUID "$(id -u)"
setup_env "  GID" PGID "$(id -g)"
setup_env "  Umask (file permissions = 777 minus umask)" UMASK 022
echo "Env setup done!"

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
mkdir -p "dockerbld"  # Directory to keep Dockerfile for qbittorrent+clamav

# post-download moves downloads to the samba share
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/rpi/post-download.sh" > scripts/post-download.sh
chmod +x scripts/post-download.sh

# sync-subtitles syncs subtitles downloaded by bazarr
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/rpi/sync-subtitles.sh" > scripts/sync-subtitles.sh
chmod +x scripts/sync-subtitles.sh

# Previously the script checked if docker-compose didn't already exist
# However, now that docker-compose.override is supplied, user changes can be made through that
# So just download docker-compose as normal
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/rpi/docker-compose.yml" > docker-compose.yml

# Fetch override file if it doesn't already exist
if [ ! -f docker-compose.override.yml ]; then
    curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/rpi/docker-compose.override.yml" > docker-compose.override.yml
fi

# Dockerfile to add clamav to qbittorrent
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/rpi/Dockerfile" > dockerbld/Dockerfile

sudo docker-compose up --detach


echo "downloads setup complete, now setup for transcoding!"
echo "A samba share will now be set up, used by the transcoder to transcode"
if ! grep -q "to-transcode" "/etc/samba/smb.conf"; then

    sudo sh -c "echo \"
[to-transcode]
    Comment = Folder to allow transcoder to reach files that have to be transcoded
    Path = $media_path/scanned
    Browseable = yes
    Writeable = Yes
    Public = no

[transcoded]
    Comment = Folder where the transcoder will put transcoded files
    Path = $media_path/transcoded
    Browseable = yes
    Writeable = Yes
    Public = no

[logs]
    Comment = Folder to allow transcoder to read logs if need be
    Path = $media_path/logs
    Browseable = yes
    Writeable = Yes
    Public = no

[torrents]
    Comment = Folder to allow the transcoder to access saved .torrent files (if configured)
    Path = $media_path/torrents
    Browseable = yes
    Writeable = Yes
    Public = no\" >> /etc/samba/smb.conf"

    sudo service smbd restart
fi;

if ! sudo pdbedit -L | grep -q $username; then
    read -p "Samba username (must be an existing user on your system) [$username]: " smb_username
    smb_username="${smb_username:-$username}"
    echo "Enter a password to use when logging into your samba share"
    sudo pdbedit -u $smb_username -a
fi;

echo "build-raspberry done!"
