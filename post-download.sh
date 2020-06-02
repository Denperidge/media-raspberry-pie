clamscan -r "$1" > "/logs/download-$2-($(date +"%d-%m-%Y--%H-%M-%S")).log"
mv "$1" /scanned