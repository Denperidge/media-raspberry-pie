transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
mkdir -p $transcoder_path
cp .env $transcoder_path
cd $transcoder_path

curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/transcode.sh" > transcode.sh
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/process.py" > process.py

# Clone mp4 automator and install requirements
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git repo
py -3 -m venv m4avenv
source m4avenv/Scripts/activate
py -3 -m pip install -r repo/setup/requirements.txt


# Following lines can be removed for non-Windows implementations
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/windows-task.bat" > scan-for-transcode-hourly.bat
echo "The transcoder path and your startup folder will now open in explorer"
echo "Copy scan-for-transcode-hourly.bat from the transcoder folder to startup to allow windows to run it on startup"
explorer.exe "shell:startup"
explorer.exe .