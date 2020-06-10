# This script will configure sickbeard_mp4_automator to convert into formats that are as universal as possible
# Because when Direct Play isn't possible, the Raspberry Pi will probably not be able to handle the transcoding 
# I've tested this config with Chromecast, mobile (Android), Plex Windows 10 app, Firefox and Chrome
# This script assumes defaults, and will only overwrite what is explicitly necessary

from configparser import ConfigParser
from dotenv import load_dotenv
from os import getenv
load_dotenv()

config = ConfigParser()
config.read("repo/config/autoProcess.ini")

config["Converter"]["ffmpeg"] = "ffmpeg"
config["Converter"]["ffprobe"] = "ffprobe"
config["Converter"]["process-same-extensions"] = True

config["Video"]["profile"] = "high"
config["Video"]["max-level"] = "4.2"
config["Video"]["pix-fmt"] = "YUV420P"

config["Audio"]["codec"] = "aac"
config["Universal Audio"]["codec"] = "aac"


config["Sonarr"]["host"] = getenv("PIE_IP")
config["Radarr"]["host"] = getenv("PIE_IP")

if getenv("PORT_SONARR"):
    port_sonarr = 8989
else:
    port_sonarr = getenv("PORT_SONARR")
if getenv("PORT_RADARR"):
    port_radarr = 7878
    

config["Sonarr"]["port"] = getenv("PORT_SONARR")
config["Radarr"]["port"] = getenv("PORT_RADARR")

config["Sonarr"]["apikey"] = getenv("APIKEY_SONARR")
config["Radarr"]["apikey"] = getenv("APIKEY_RADARR")


# https://developers.google.com/cast/docs/media#chromecast_1st_and_2nd_gen
if getenv("CHROMECAST_GEN_1_OR_2"):
    config["Video"]["max-level"] = "4.1"
