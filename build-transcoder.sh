transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
mkdir -p $transcoder_path
cp .env $transcoder_path
cd $transcoder_path

curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/transcode.sh" > transcode.sh
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/process-sonarr.py" > process-sonarr.py
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/process-radarr.py" > process-radarr.py

# Clone mp4 automator and install requirements
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git repo
py -3 -m venv m4avenv
source m4avenv/Scripts/activate
py -3 -m pip install -r repo/setup/requirements.txt



#cp transcode.sh "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/StartUp"
#cd "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/StartUp"