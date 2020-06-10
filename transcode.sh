transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
pie_ip=$(cat .env | grep PIE_IP= | cut -d '=' -f2)
media_path=$(cat .env | grep MEDIA_PATH= | cut -d '=' -f2)

smb="%transcoder_path%/mnt/"

cd %transcoder_path%
source %transcoder_path%/m4avenv/bin/activate

cd "$smb/to-transcode/sonarr/"
for d in * ; do
    py -3 "%transcoder_path%/repo/manual.py" -i "$d" -m "$smb/transcoded/sonarr/$d/" --auto --preserverelative > "$smb/logs/transcode-process-sonarr-$d-$(date +'%d-%m-%Y--%H-%M-%S').log"
    py -3 "%transcoder_path%/process.py" "%transcoder_path%/repo/" "$d/" sonarr >> "$smb/logs/transcode-process-sonarr-$d-$(date +'%d-%m-%Y--%H-%M-%S').log"
done

cd "$smb/to-transcode/radarr/"
for d in * ; do
    py -3 "%transcoder_path%/repo/manual.py" -i "$d" -m "$smb/transcoded/radarr/$d/" --auto --preserverelative > "$smb/logs/transcode-process-radarr-$d-$(date +'%d-%m-%Y--%H-%M-%S').log"
    py -3 "%transcoder_path%/process.py" "%transcoder_path%/repo/" "$d/" radarr >> "$smb/logs/transcode-process-radarr-$d-$(date +'%d-%m-%Y--%H-%M-%S').log"
done
