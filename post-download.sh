clamscan -r "$1" > "/logs/$3-$2-($(date +"%d-%m-%Y--%H-%M-%S")).log"
category="$(echo "$3" | tr "[:upper:]" "[:lower:]")"
mkdir -p "/scanned/radarr/$1/"
if [[ $category ==  *"radarr"* ]]; then
  mv "$1" "/scanned/radarr/$1/$1"
elif [[ $category ==  *"sonarr"* ]]; then
  mv "$1" "/scanned/sonarr/$1/$1"
fi