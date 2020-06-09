# We will store all the files in the path configured in .env
# Everything from config to the video files 
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/docker-compose.yml" > docker-compose.yml
sudo docker-compose up --detach


media_path=$(cat .env | grep MEDIA_PATH= | cut -d '=' -f2)
mkdir -p $media_path
cd "$media_path"

mkdir "downloads"  # Downloads: stored here after download in qbittorrent
mkdir "torrents"  #  Torrents: .torrent files are kept here
mkdir -p -m 777 "scanned"  #  Scanned: stored here after CLAMAV has scanned. Kept here until transcoder moves them
mkdir -p -m 777 "scanned/sonarr"
mkdir -p -m 777 "scanned/radarr"
mkdir -p -m 777 "transcoded"  # After transcoder is finished, files are moved here and kept there until moved by 
mkdir -p -m 777 "transcoded/sonarr"
mkdir -p -m 777 "transcoded/radarr"
mkdir -p -m 777 "logs"  # Logs will be stored here 
mkdir -p "tv"  # Directory to keep tv show files after being downloaded, scanned and transcoded
mkdir -p "movies"  # Directory to keep movies files after being downloaded, scanned and transcoded

curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/post-download.sh" > downloads/post-download.sh
chmod +x downloads/post-download.sh

clear
echo "Open qbittorrent (ip:8080) > tools > options > downloads > Run external program on torrent completion"
echo "Enable it and insert the following line:"
echo "/bin/bash /downloads/post-download.sh \"%R\" \"%N\" \"%L\""
echo "and press Save"
read

clear

sudo apt-get install samba samba-common-bin

echo "downloads setup complete, now setup for transcoding!"
echo "A samba share will now be set up, used by the transcoder to transcode"
echo "/etc/samba/smb.conf will now be opened. Copy the the following lines and add them to the bottom."
echo [scanned]
echo Comment = Folder to allow transcoder to reach files
echo Path = $media_path/scanned
echo Browseable = yes
echo Writeable = Yes
echo only guest = no
echo Public = yes
echo
echo [transcoded]
echo Comment = Folder to allow transcoder to reach files
echo Path = $media_path/transcoded
echo Browseable = yes
echo Writeable = Yes
echo only guest = no
echo Public = yes
echo
echo [logs]
echo Comment = Folder to allow transcoder to reach files
echo Path = $media_path/logs
echo Browseable = yes
echo Writeable = Yes
echo only guest = no
echo Public = yes
read
sudo nano /etc/samba/smb.conf

sudo service smbd restart

clear
echo "Use smbpasswd -a $USER to create a password to let the transcoder log in!"
echo "build-raspberry done"

modified the quick build sh

sudo apt-get install gcc-mingw-w64-i686 g++-mingw-w64-i686 yasm make automake autoconf git pkg-config libtool-bin nasm gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 -y
git clone https://github.com/rdp/ffmpeg-windows-build-helpers.git
cd ffmpeg-windows-build-helpers
quick_build/quick_cross_compile_ffmpeg_fdk_aac_and_x264_using_packaged_mingw64.sh
mv sandbox_quick/win64 "$media_path/downloads/scanned/win64"



sudo apt-get update
sudo apt-get install subversion ragel curl texinfo g++ bison flex cvs yasm automake libtool autoconf gcc cmake git make pkg-config zlib1g-dev mercurial unzip pax nasm gperf autogen bzip2 autoconf-archive p7zip-full meson clang libtool-bin ed

sudo apt-get install build-essential


git clone https://github.com/mxe/mxe.git
make cc







sudo apt-get install build-essential


sudo apt-get install \
    autoconf \
    automake \
    autopoint \
    bash \
    bison \
    bzip2 \
    flex \
    g++ \
    gettext \
    git \
    gperf \
    intltool \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libssl-dev \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    make \
    openssl \
    p7zip-full \
    patch \
    perl \
    python \
    ruby \
    sed \
    unzip \
    wget \
    xz-utils
make cc
mv mxe /opt/mxe


brew tap homebrew-ffmpeg/ffmpeg