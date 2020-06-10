clamscan -r "$1" > "/logs/[$(date +"%d-%m-%Y--%H-%M-%S")]-clamscan-$3-$2.log"
category="$(echo "$3" | tr "[:upper:]" "[:lower:]")"
if [[ $category ==  *"radarr"* ]]; then
  mkdir -p "/scanned/radarr/$2/"
  mv "$1" "/scanned/radarr/$2/$2"
elif [[ $category ==  *"sonarr"* ]]; then
  mkdir -p "/scanned/sonarr/$2/"
  mv "$1" "/scanned/sonarr/$2/$2"
fi