clamscan -r "$1" > "/logs/$3-$2-($(date +"%d-%m-%Y--%H-%M-%S")).log"
category="$(echo "$3" | tr "[:upper:]" "[:lower:]")"
if [[ $category ==  *"radarr"* ]]; then
  mkdir -p "/scanned/radarr/$1/"
  mv "$1" "/scanned/radarr/$1/$1"
elif [[ $category ==  *"sonarr"* ]]; then
  mkdir -p "/scanned/sonarr/$1/"
  mv "$1" "/scanned/sonarr/$1/$1"
fi