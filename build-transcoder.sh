transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
pie_ip=$(cat .env | grep PIE_IP= | cut -d '=' -f2)

# Assume windows if not Linux.
# The script would need presumably modifications to run on Mac, yet I do not have a machine to test this on
if [  $(uname -s) = "Darwin" ]; then
    echo "This script isn't meant to natively run on Mac, since I cannot test it on there"
    echo "Please modify the script to make sure that mac compatibility works"
    exit 1
elif [ $(uname -s) != "Linux" ]; then  
    os="windows"
    python="py -3"
else
    os="linux"
    python="python3"
fi

mkdir -p $transcoder_path
cp .env $transcoder_path
cd $transcoder_path

# Create venv if need be
if ! [ -d "m4avenv" ]; then
    python3 -m pip venv
    python3 -m venv m4avenv
fi

# Activate venv
if [ $os = "windows" ]; then  
    source m4avenv/Scripts/activate
else 
    source m4avenv/bin/activate
fi

# Clone mp4 automator and install requirements
if ! [ -d "repo" ]; then
    git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git repo
    $python -m pip install -r repo/setup/requirements.txt
    cp repo/setup/autoProcess.ini.sample repo/config/autoProcess.ini
    $python -m pip python-dotenv
    $python "modify-ini.py"
fi

curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/transcode.sh" > transcode.sh
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/process.py" > process.py
chmod +x transcode.sh

# For Windows, assist with automatic startup configuration
if [ $os = "windows" ]; then  
    curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/windows-task.bat" > scan-hourly-for-transcode.bat
    sed -i "s|%transcoder_path%|$transcoder_path|g" scan-hourly-for-transcode.bat
    echo "The transcoder path and your startup folder will now open in explorer"
    echo "Copy scan-hourly-for-transcode.bat from the transcoder folder to startup to allow windows to run it on startup"
    explorer.exe "shell:startup"
    explorer.exe .
fi
