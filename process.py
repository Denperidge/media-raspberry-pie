from autoprocess import sonarr, radarr
from resources.readsettings import ReadSettings
from sys import argv, path

"""
argv[1] = path to repo
argv[2] = path to media directory
argv[3] = sonarr or radarr string
"""

path.insert(1, argv[1])

settings = ReadSettings()

if "sonarr" in argv[3].lower():
    sonarr.processEpisode(argv[2], settings)
elif "radarr" in argv[3].lower():
    radarr.processEpisode(argv[2], settings)



