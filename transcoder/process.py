from sys import argv, path
path.insert(1, argv[1])

from autoprocess import sonarr, radarr
from resources.readsettings import ReadSettings

"""
argv[1] = path to repo
argv[2] = relative path to media directory from /import/
argv[3] = sonarr or radarr string
"""

repo_path = argv[1]
import_path = "/import/" + argv[2]
sonarr_or_radarr = argv[3].lower()

settings = ReadSettings()

if "sonarr" in sonarr_or_radarr:
    sonarr.processEpisode(import_path, settings)
elif "radarr" in sonarr_or_radarr:
    radarr.processMovie(import_path, settings)



