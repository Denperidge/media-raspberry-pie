transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
pie_ip=$(cat .env | grep PIE_IP= | cut -d '=' -f2)

mkdir -p $transcoder_path
cp .env $transcoder_path
cd $transcoder_path
mkdir -p mnt
mkdir -p mnt/to-transcode
mkdir -p mnt/transcoded

curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/transcode.sh" > transcode.sh
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/process.py" > process.py
chmod +x transcode.sh



sudo apt-get update
sudo apt-get upgrade
sudo apt-get install python3-pip samba-client cifs-utils -y

sudo mount -t cifs //$pie_ip/to-transcode ~/mnt/to-transcode -o username=stijn,noexec
sudo mount -t cifs //$pie_ip/to-transcode ~/mnt/to-transcode -o username=stijn,noexec


python3 -m pip venv

# Clone mp4 automator and install requirements
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git repo
python3 -m venv m4avenv
source m4avenv/bin/activate
python3 -m pip install -r repo/setup/requirements.txt

smbclient //$pie_ip

exit

# Following lines can be removed for non-Windows implementations
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/windows-task.bat" > scan-hourly-for-transcode.bat
sed -i "s|%transcoder_path%|$transcoder_path|g" scan-hourly-for-transcode.bat
echo "The transcoder path and your startup folder will now open in explorer"
echo "Copy scan-hourly-for-transcode.bat from the transcoder folder to startup to allow windows to run it on startup"
explorer.exe "shell:startup"
explorer.exe .

start https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6
echo "dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart"
echo "Enable-WindowsOptionalFeature -online -featurename Microsoft-Windows-Subsystem-Linux"


/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

brew tap homebrew-ffmpeg/ffmpeg
sudo apt-get install gcc make  
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac --with-openh264 --HEAD
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac