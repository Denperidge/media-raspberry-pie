transcoderpath=$(cat .env | grep TRANSCODERPATH= | cut -d '=' -f2)
pieip=$(cat .env | grep PIEIP= | cut -d '=' -f2)

cd $transcoderpath
source m4avenv/Scripts/activate
py -3 repo/manual.py -i //$pieip/to-transcode/sonarr/ -m //$pieip/transcoded/sonarr/ --auto
py -3 process-sonarr.py

py -3 repo/manual.py -i //$pieip/to-transcode/radarr/ -m //$pieip/transcoded/radarr/ --auto
py -3 process-radarr.py
