# Media-Raspberry-Pi scripts

These scripts aren't meant to be placed anywhere. Rather, they're assistants for some parts of the manual configuration.
Simply copy-paste these into your console, follow the instructions, and let it automate the boring stuff.

## Before you use them
First **always check out what the code does**. I don't have any ill intentions, mind you, but it's a good habit to form. Running unknown Javascript can lead to e.g. compromised accounts.
I commented what everything did in the scripts for full transparency.

## Indexer.js: adding indexers to Sonarr & Radarr
The code in [indexer.js](indexer.js) will make adding indexers a *lot* less tedious. Navigate to Settings > Indexers. At the top of the script, fill in the categories you'd like to use, your Jackett API key and the names & urls of the indexers you'd like add (refer Jackett to get the URL values). Instead of having to manually press add > torznab custom and then pasting everything over and over.

## Manual-import.js: non-tedious manual importing to Sonarr
Sometimes, Sonarr just doesn't find your show. So after you've placed your files in $media_path/transcoded and navigated to Wanted > Manual Import and selected the folder (located in /import), you have to select the series over and over again. Copy and paste the code in [manual-import.js](manual-import.js). Then use any of the following commands:
- Series("series name"):
  - Replace series name with (at least a part of) the name of the series these files refer to. This isn't case-sensetive, but do keep notes of any spaces & special characters (and keep the double quotes).

- Season(1);
  - You can replace 1 with any positive number. Double quotes optional.
- Episodes();
  - No parameters needed here. The script will just assume that the top-most file is episode 1, and keep going from there.
