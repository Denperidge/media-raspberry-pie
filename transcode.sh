cd $transcoder_path
transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
pie_ip=$(cat .env | grep PIE_IP= | cut -d '=' -f2)
media_path=$(cat .env | grep MEDIA_PATH= | cut -d '=' -f2)

source $transcoder_path/m4avenv/Scripts/activate

cd //$pie_ip/to-transcode/sonarr/
for d in * ; do
    py -3 "$transcoder_path/repo/manual.py" -i "$d" -m "//$pie_ip/transcoded/sonarr/$d/" --auto --preserverelative
    py -3 "$transcoder_path/process.py" "$transcoder_path/repo/" "$d/" sonarr
done

cd //$pie_ip/to-transcode/radarr/
for d in * ; do
    py -3 "$transcoder_path/repo/manual.py" -i "$d" -m "//$pie_ip/transcoded/radarr/$d/" --auto --preserverelative
    py -3 "$transcoder_path/process.py" "$transcoder_path/repo/" "$d/" radarr
done
