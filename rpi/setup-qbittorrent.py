# This script will configure qbittorrent to use the post-download script
from configparser import RawConfigParser
from dotenv import load_dotenv
from os import getenv
load_dotenv()

conf_path = "config/qbittorrent/qBittorrent/qBittorrent.conf"

config = RawConfigParser()
config.read(conf_path)

config["AutoRun"]["enabled"] = "true"
config["AutoRun"]["program"] = r"/bin/bash /downloads/post-download.sh \"%R\" \"%N\" \"%L\""

with open(conf_path, "w") as configfile:
    config.write(configfile)