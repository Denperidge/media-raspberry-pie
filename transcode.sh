transcoderpath=$(cat .env | grep TRANSCODERPATH= | cut -d '=' -f2)
pieip=$(cat .env | grep PIEIP= | cut -d '=' -f2)

cd $transcoderpath
source m4avenv/Scripts/activate
py -3 repo/manual.py -i //$pieip/to-transcode/ -m //pieip/transcoded/ --auto
