transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
pie_ip=$(cat .env | grep PIE_IP= | cut -d '=' -f2)

cd "$transcoder_path/repo/" 
source $transcoder_path/m4avenv/Scripts/activate
py -3 $transcoder_path/repo/manual.py -i //$pie_ip/to-transcode/sonarr/ -m //$pie_ip/transcoded/sonarr/ --auto
py -3 $transcoder_path/process-sonarr.py //$pie_ip/to-transcode/sonarr/

py -3 $transcoder_path/repo/manual.py -i //$pie_ip/to-transcode/radarr/ -m //$pie_ip/transcoded/radarr/ --auto
py -3 $transcoder_path/process-radarr.py //$pie_ip/transcoded/radarr/
