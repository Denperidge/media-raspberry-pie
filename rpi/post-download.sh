clamscan -r "$1" >> "/logs/$(date +"%d-%m-%Y").log"
category="$(echo "$3" | tr "[:upper:]" "[:lower:]")"
if [[ $category ==  *"radarr"* ]]; then

  # If path is directory
  if [[ -d $1 ]]; then
    # Move the directory
    mv "$1" "/scanned/radarr/$2"
  # If path is a file
  else
    # Create a new folder to store it in
    mkdir -p "/scanned/radarr/$2/"
    mv "$1" "/scanned/radarr/$2/$2"
  fi
  
elif [[ $category ==  *"sonarr"* ]]; then

  # If path is directory
  if [[ -d $1 ]]; then
    # Move the directory
    mv "$1" "/scanned/sonarr/$2"
  # If path is a file
  else
    # Create a new folder to store it in
    mkdir -p "/scanned/sonarr/$2/"
    mv "$1" "/scanned/sonarr/$2/$2"
  fi

else 

  # If path is directory
  if [[ -d $1 ]]; then
    # Move the directory
    mv "$1" "/scanned/other/$2"
  # If path is a file
  else
    # Create a new folder to store it in
    mkdir -p "/scanned/other/$2/"
    mv "$1" "/scanned/other/$2/$2"
  fi

fi

# Clear out empty dirs from sonarr & radarr (solution found at https://unix.stackexchange.com/a/46326/182203)
find /downloads/ -type d -empty -delete
find /scanned/ -type d -empty -delete
