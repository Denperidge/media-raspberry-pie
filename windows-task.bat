echo "self-mnimize solution from https://stackoverflow.com/a/22357573"
if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit

:everyhour

TIMEOUT 3600‬ /nobreak

goto everyhour

exit