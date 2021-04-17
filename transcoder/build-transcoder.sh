#!/bin/bash

set -e

# Assume windows if not Linux.
# The script would presumably need modifications to run on Mac, but I do not have a machine to test this on
if [ "$(uname -s)" = "Darwin" ] ; then
    echo "This script isn't meant to natively run on Mac, since I cannot test it on there"
    echo "Please modify the script to make sure that mac compatibility works"
    exit 1
elif [ "$(uname -s)" != "Linux" ] ; then
    os="windows"
    python="py -3"
    sudo=""  # Sudo can't be used under git bash
    transcoder_path="C:/mrpi-transcoder/"
else
    os="linux"
    python="python3"
    sudo="sudo "
    transcoder_path="/usr/local/bin/mrpi-transcoder/"
fi

$sudo mkdir -p $transcoder_path
username=$(whoami)
$sudo chown $username $transcoder_path
cd $transcoder_path || exit 1  # Exit on fail

# Setup .env
# setup_env(prompt, key, default_value, outputfile)
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

setup_env "Sonarr port" PORT_SONARR 8989
setup_env "Radarr port" PORT_RADARR 7878
setup_env "Sonarr API key" APIKEY_SONARR
setup_env "Radarr API key" APIKEY_RADARR
setup_env "IP Address of RPI" PIE_IP


# Mount samba share
if [ $os = "windows" ]; then  
    echo "(Windows) Smb share not automatically mounted"
else 
    setup_env "MediaRPI Smb username" username "" .smbcredentials
    setup_env "MediaRPI Smb password" password "" .smbcredentials
    sudo chmod 700 .smbcredentials

    $sudo apt-get install cifs-utils  # Prerequisite
    mount_path="/mnt/mediarpi/media"
    $sudo mkdir -p $mount_path
    $sudo chown $username $mount_path
    $sudo chgrp $username $mount_path

    # Make subdirectories
    to_transcode="$mount_path/to-transcode"
    transcoded="$mount_path/transcoded"
    logs="$mount_path/logs"

    #group="$(id -g)"
    pie_ip=$(cat .env | grep PIE_IP= | cut -d '=' -f2)


    folderpaths=( $to_transcode $transcoded $logs )
    foldernames=( "to-transcode" "transcoded" "logs" )
    for (( i=0; i<${#folderpaths[@]}; i++));
    do
        folderpath="${folderpaths[$i]}"
        foldername="${foldernames[i]}"
        if ! grep -q "$folderpath" "/etc/fstab"; then
            mkdir -p $folderpath
            $sudo chown $username $folderpath
            $sudo chgrp $username $folderpath
            $sudo sh -c "echo \"//$pie_ip/$foldername $folderpath cifs uid=$username,gid=$username,credentials=$transcoder_path/.smbcredentials,iocharset=utf8,sec=ntlmssp,_netdev 0 0\" >> /etc/fstab"
        fi
    done
    
    $sudo mount -a
fi

# Fetch scripts
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/transcoder/transcode.sh" > transcode.sh
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/transcoder/process.py" > process.py
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/transcoder/modify-ini.py" > modify-ini.py
chmod +x transcode.sh

# Create venv if need be
if ! [ -d "m4avenv" ]; then
    $python -m pip install venv || $python -m pip install virtualenv || $sudo apt-get install python3-venv
    $python -m venv m4avenv
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
    $python -m pip install python-dotenv
    $python "modify-ini.py"
fi

# Let transcoder work automatically
# Windows
if [ $os = "windows" ]; then  
    curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/transcoder/windows-only/scan-hourly-for-transcode.bat" > scan-hourly-for-transcode.bat
    sed -i "s|%transcoder_path%|$transcoder_path|g" scan-hourly-for-transcode.bat
    echo "The transcoder path and your startup folder will now open in explorer"
    echo "Copy scan-hourly-for-transcode.bat from the transcoder folder to startup to allow windows to run it on startup"
    echo "Press ENTER to continue"
    read
    explorer.exe "shell:startup"
    explorer.exe .
else  # Linux
    $sudo sh -c "echo \"30 *\t* * *\t$username\t$transcoder_path/transcode.sh\" >> /etc/crontab"
fi

echo "Press ENTER to finish."
read
