# Called like /bin/bash /downloads/sync-subtitles.sh "{{episode}}" "{{subtitles}}" "{{directory}}" "{{episode_name}}" "{{subtitles_language_code2}}"
# episode = full path to video file
# subtitles = full path to subtitle file
# directory = path to directory where file is located
# episode name = video file name, without path
# subtitles language code 2 = two letter langauge code (f.e. EN)

episode_path="$1"
subtitle_path="$2"
directory="$3"
episode_name="$4"
language="$5"

ffs "$episode_path" -i "$subtitle_path" -o "$directory/$episode_name.synced.$language.srt"
