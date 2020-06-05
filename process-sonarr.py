from repo.autoprocess import sonarr, radarr
from repo.resources.readsettings import ReadSettings
from sys import argv

settings = ReadSettings()

sonarr.processEpisode(argv[1], settings)