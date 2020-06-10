transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
pie_ip=$(cat .env | grep PIE_IP= | cut -d '=' -f2)
smb_username=$(cat .env | grep SMB_USERNAME= | cut -d '=' -f2)
smb_password=$(cat .env | grep SMB_PASSWORD= | cut -d '=' -f2)

sudo apt-get update
sudo apt-get upgrade

mkdir -p $transcoder_path
cp .env $transcoder_path
cd $transcoder_path
mkdir -p mnt
mkdir -p mnt/to-transcode
mkdir -p mnt/transcoded

# Mount the samba share on each startup, following instructions from https://help.ubuntu.com/community/Samba/SambaClientGuide
sudo apt-get -y install python3-pip samba-client cifs-utils gcc make git
echo -e "\nusername=$smb_username" | sudo tee -a /etc/samba/user
echo -e "password=$smb_password\n" | sudo tee -a /etc/samba/user
sudo chmod 0400 /etc/samba/user


# Install homebrew using instructions from https://brew.sh/, and use brew to easily install ffmpeg
if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
fi

brew tap homebrew-ffmpeg/ffmpeg
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac


# Clone mp4 automator and install requirements
python3 -m pip venv
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git repo
python3 -m venv m4avenv
source m4avenv/bin/activate
python3 -m pip install -r repo/setup/requirements.txt

curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/transcode.sh" > transcode.sh
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/process.py" > process.py
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/mount-drvfs.sh" > mount-drvfs.sh
chmod +x transcode.sh
chmod +x mount-drvfs.sh
sudo mount -t drvfs "//$pie_ip/to-transcode" "$transcoder_path/mnt/to-transcode/"
sudo mount -t drvfs "//$pie_ip/transcoded" "$transcoder_path/mnt/transcoded/"

# NOTE: you can probably mount through fstab if you're not using Windows/WSL
echo "Crontab will now be opened. Copy and paste the following lines into it"
echo "@reboot $transcoder_path/mount-drvfs.sh"
echo "0 * * * * $transcoder_path/transcode.sh."
echo "Press ENTER to continue"
read
sudo crontab -e


exit

# Following lines are yet to be (re)moved
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/windows-task.bat" > scan-hourly-for-transcode.bat
sed -i "s|%transcoder_path%|$transcoder_path|g" scan-hourly-for-transcode.bat
echo "The transcoder path and your startup folder will now open in explorer"
echo "Copy scan-hourly-for-transcode.bat from the transcoder folder to startup to allow windows to run it on startup"
explorer.exe "shell:startup"
explorer.exe .



