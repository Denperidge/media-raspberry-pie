# This script will configure qbittorrent to use the post-download script
from configparser import ConfigParser
from dotenv import load_dotenv
from os import getenv
load_dotenv()

conf_path = "config/qbittorrent/qBittorrent.conf"

config = ConfigParser()
config.read(conf_path)

config["AutoRun"]["enabled"] = "true"
config["AutoRun"]["program"] = '/bin/bash /downloads/post-download.sh \"%R\" \"%N\" \"%L\"'


with open(conf_path, "w") as configfile:
    config.write(configfile)