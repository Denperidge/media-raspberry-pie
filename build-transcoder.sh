transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
mkdir -p $transcoder_path
cp {transcode.sh,process-sonarr.py,process-radarr.py,.env} $transcoder_path
cd $transcoder_path

# Clone mp4 automator and install requirements
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git repo
py -3 -m venv m4avenv
source m4avenv/Scripts/activate
py -3 -m pip install -r repo/setup/requirements.txt



#cp transcode.sh "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/StartUp"
#cd "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/StartUp"