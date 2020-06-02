transcoderpath=$(cat .env | grep TRANSCODERPATH= | cut -d '=' -f2)
mkdir $transcoderpath
cp .env $transcoderpath/.env
cp transcode.sh $transcoderpath/transcode.sh
cd $transcoderpath

# Clone mp4 automator
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git repo
py -3 -m venv m4avenv
source m4avenv/Scripts/activate
py -3 -m pip install -r repo/setup/requirements.txt



#cp transcode.sh "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/StartUp"
#cd "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/StartUp"

#sed -i "s/transcoderpath/$transcoderpath/g" transcode.sh