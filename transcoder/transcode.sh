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

# Go to working directory of transcode.sh
# One-liner from https://stackoverflow.com/a/246128
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Get environment variables & go to transcoder
pie_ip=$(cat .env | grep PIE_IP= | cut -d '=' -f2)

# Activate venv and set pie path (the path will be different for Windows and Linux transcoder)
if [ $os = "windows" ]; then  
    source "$transcoder_path/m4avenv/Scripts/activate"
    pie_path="//$pie_ip/"
else 
    source "$transcoder_path/m4avenv/bin/activate"
    pie_path=$(cat .env | grep PIE_PATH= | cut -d '=' -f2)
fi

logfile="$pie_path/logs/$(date +'%d-%m-%Y').log"

# Process tv shows
cd "$pie_path/to-transcode/sonarr/"
for d in * ; do
    $python "$transcoder_path/repo/manual.py" -i "$d" -m "//$pie_ip/transcoded/sonarr/$d/" --auto --preserverelative >> "$logfile"
    $python "$transcoder_path/process.py" "$transcoder_path/repo/" "$d/" sonarr >> "$logfile"
done

# Process movies
cd "$pie_path/to-transcode/radarr/"
for d in * ; do
    $python "$transcoder_path/repo/manual.py" -i "$d" -m "//$pie_ip/transcoded/radarr/$d/" --auto --preserverelative >> "$logfile"
    $python "$transcoder_path/process.py" "$transcoder_path/repo/" "$d/" radarr >> "$logfile"
done
