clamscan -r "$1" > "/logs/$3-$2-($(date +"%d-%m-%Y--%H-%M-%S")).log"
$category=$(echo "$3" | tr "[:upper:]" "[:lower:]")
if [[ $3 ==  *"radarr"*]]; 
then
  mv "$1" /scanned/radarr/
elif [[ $3 ==  *"sonarr"*]];
then
  mv "$1" /scanned/sonarr/
fi