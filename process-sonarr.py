from repo.autoprocess import sonarr, radarr
from resources.readsettings import ReadSettings

settings = ReadSettings()

sonarr.processEpisode(path, settings)