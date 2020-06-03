clamscan -r "$1" > "/logs/$3-$2-($(date +"%d-%m-%Y--%H-%M-%S")).log"
$category="$(echo "$3" | tr "[:upper:]" "[:lower:]")"
if [[ $category ==  *"radarr"*]]
then
  mv "$1" /scanned/radarr/
elif [[ $category ==  *"sonarr"*]]
then
  mv "$1" /scanned/sonarr/
fi