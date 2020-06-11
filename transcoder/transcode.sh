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

# Get environment variables & go to transcoder
transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
pie_ip=$(cat .env | grep PIE_IP= | cut -d '=' -f2)
cd "$transcoder_path"

# Activate venv
if [ $os = "windows" ]; then  
    source "$transcoder_path/m4avenv/Scripts/activate"
else 
    source "$transcoder_path/m4avenv/bin/activate"
fi

# Process tv shows
cd "//$pie_ip/to-transcode/sonarr/"
for d in * ; do
    logfile_transcode="//$pie_ip/logs/[$(date +'%d-%m-%Y--%H-%M-%S')]-transcode-sonarr-$d.log"
    logfile_process="//$pie_ip/logs/[$(date +'%d-%m-%Y--%H-%M-%S')]-process-sonarr-$d.log"

    $python "$transcoder_path/repo/manual.py" -i "$d" -m "//$pie_ip/transcoded/sonarr/$d/" --auto --preserverelative > "$logfile_transcode"
    $python "$transcoder_path/process.py" "$transcoder_path/repo/" "$d/" sonarr > "$logfile_process"
done

# Process movies
cd "//$pie_ip/to-transcode/radarr/"
for d in * ; do
    logfile_transcode="//$pie_ip/logs/[$(date +'%d-%m-%Y--%H-%M-%S')]-transcode-radarr-$d.log"
    logfile_process="//$pie_ip/logs/[$(date +'%d-%m-%Y--%H-%M-%S')]-process-radarr-$d.log"

    $python "$transcoder_path/repo/manual.py" -i "$d" -m "//$pie_ip/transcoded/radarr/$d/" --auto --preserverelative > "$logfile_transcode"
    $python "$transcoder_path/process.py" "$transcoder_path/repo/" "$d/" radarr > "$logfile_process"
done
