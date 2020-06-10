cd %transcoder_path%
source %transcoder_path%/m4avenv/bin/activate

smb="%transcoder_path%/mnt/"

cd "$smb/to-transcode/sonarr/"
for d in * ; do
    logfile_transcode = "$smb/logs/[$(date +'%d-%m-%Y--%H-%M-%S')]-transcode-sonarr-$d.log"
    logfile_process = "$smb/logs/[$(date +'%d-%m-%Y--%H-%M-%S')]-process-sonarr-$d.log"

    python3 "%transcoder_path%/repo/manual.py" -i "$d" -m "$smb/transcoded/sonarr/$d/" --auto --preserverelative > logfile_transcode
    python3 "%transcoder_path%/process.py" "%transcoder_path%/repo/" "$d/" sonarr > logfile_process
done

cd "$smb/to-transcode/radarr/"
for d in * ; do
    logfile_transcode = "$smb/logs/[$(date +'%d-%m-%Y--%H-%M-%S')]-transcode-radarr-$d.log"
    logfile_process = "$smb/logs/[$(date +'%d-%m-%Y--%H-%M-%S')]-process-radarr-$d.log"

    python3 "%transcoder_path%/repo/manual.py" -i "$d" -m "$smb/transcoded/radarr/$d/" --auto --preserverelative > logfile_transcode
    python3 "%transcoder_path%/process.py" "%transcoder_path%/repo/" "$d/" radarr > logfile_process
done
