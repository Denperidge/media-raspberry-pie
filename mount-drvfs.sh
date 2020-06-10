transcoder_path=$(cat .env | grep TRANSCODER_PATH= | cut -d '=' -f2)
pie_ip=$(cat .env | grep PIE_IP= | cut -d '=' -f2)

mount -t drvfs //192.168.0.230/to-transcode /home/stijn/rpi-transcoder/mnt/to-transcode/
mount -t drvfs //192.168.0.230/transcoded /home/stijn/rpi-transcoder/mnt/transcoded/