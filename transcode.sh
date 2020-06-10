cd %transcoder_path%
source %transcoder_path%/m4avenv/bin/activate

smb="%transcoder_path%/mnt/"

cd "$smb/to-transcode/sonarr/"
for d in * ; do
    python3 "%transcoder_path%/repo/manual.py" -i "$d" -m "$smb/transcoded/sonarr/$d/" --auto --preserverelative > "$smb/logs/transcode-process-sonarr-$d-$(date +'%d-%m-%Y--%H-%M-%S').log"
    python3 "%transcoder_path%/process.py" "%transcoder_path%/repo/" "$d/" sonarr >> "$smb/logs/transcode-process-sonarr-$d-$(date +'%d-%m-%Y--%H-%M-%S').log"
done

cd "$smb/to-transcode/radarr/"
for d in * ; do
    python3 "%transcoder_path%/repo/manual.py" -i "$d" -m "$smb/transcoded/radarr/$d/" --auto --preserverelative > "$smb/logs/transcode-process-radarr-$d-$(date +'%d-%m-%Y--%H-%M-%S').log"
    python3 "%transcoder_path%/process.py" "%transcoder_path%/repo/" "$d/" radarr >> "$smb/logs/transcode-process-radarr-$d-$(date +'%d-%m-%Y--%H-%M-%S').log"
done
