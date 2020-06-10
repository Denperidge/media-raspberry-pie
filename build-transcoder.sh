transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
pie_ip=$(cat .env | grep PIE_IP= | cut -d '=' -f2)

sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install python3-pip samba-client gcc make git

mkdir -p $transcoder_path
cp .env $transcoder_path
cd $transcoder_path
mkdir -p mnt
mkdir -p mnt/to-transcode
mkdir -p mnt/transcoded
mkdir -p mnt/logs


# Install brew using instructions from https://brew.sh/, and use brew to easily install ffmpeg
if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
fi
if ! [ -x "$(command -v ffmpeg)" ]; then
    brew tap homebrew-ffmpeg/ffmpeg
    brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac
fi

# Clone mp4 automator and install requirements
if ! [ -d "m4avenv" ]; then
    python3 -m pip venv
    python3 -m venv m4avenv
fi
source m4avenv/bin/activate
if ! [ -d "repo" ]; then
    git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git repo
    python3 -m pip install -r repo/setup/requirements.txt
fi


curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/transcode.sh" > transcode.sh
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/mount-drvfs.sh" > mount-drvfs.sh
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/process.py" > process.py
chmod +x transcode.sh mount-drvfs.sh

sed -i "s|%transcoder_path%|$transcoder_path|g" transcode.sh

sed -i "s|%transcoder_path%|$transcoder_path|g" mount-drvfs.sh
sed -i "s|%pie_ip%|$pie_ip|g" mount-drvfs.sh

# Start cronjobs on startup
if ! grep -q "sudo cron" ~/.bashrc; then
    echo -e "\n\nsudo cron" >> ~/.bashrc
fi


# NOTE: you can probably mount through fstab if you're not using Windows/WSL
echo "Crontab will now be opened. Copy and paste the following lines into it"
echo "@reboot $transcoder_path/mount-drvfs.sh"
echo "0 * * * * $transcoder_path/transcode.sh"
echo "Press ENTER to continue"
read
sudo crontab -e

echo "Visudo will now be opened. Copy and paste the following lines into it"
echo "$USER ALL=(root) NOPASSWD: /usr/sbin/cron"
echo "$USER ALL=(root) NOPASSWD: /usr/bin/mount"
echo "Press ENTER to continue"
read
sudo visudo

exit

# Following lines are yet to be (re)moved
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/windows-task.bat" > scan-hourly-for-transcode.bat
sed -i "s|%transcoder_path%|$transcoder_path|g" scan-hourly-for-transcode.bat
echo "The transcoder path and your startup folder will now open in explorer"
echo "Copy scan-hourly-for-transcode.bat from the transcoder folder to startup to allow windows to run it on startup"
explorer.exe "shell:startup"
explorer.exe .



