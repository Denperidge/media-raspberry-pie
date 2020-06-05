transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
pie_ip=$(cat .env | grep PIE_IP= | cut -d '=' -f2)

cd $transcoder_path
source m4avenv/Scripts/activate
py -3 repo/manual.py -i //$pie_ip/to-transcode/sonarr/ -m //$pie_ip/transcoded/sonarr/ --auto
py -3 process-sonarr.py

py -3 repo/manual.py -i //$pie_ip/to-transcode/radarr/ -m //$pie_ip/transcoded/radarr/ --auto
py -3 process-radarr.py
