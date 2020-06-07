echo "self-mnimize solution from https://stackoverflow.com/a/22357573"
cd "%transcoder_path%"

if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit

:everyhour
transcode.sh
timeout /nobreak 3600
goto everyhour

exit