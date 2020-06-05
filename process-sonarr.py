from autoprocess import sonarr, radarr
from resources.readsettings import ReadSettings
from sys import argv, path
path.insert(1, "repo/")

settings = ReadSettings()

sonarr.processEpisode(argv[1], settings)