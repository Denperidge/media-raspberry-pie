# Media Raspberry Pi

Can you use a Raspberry Pi to download and stream your media? Yes. Should you? No idea.

I wanted to see if I could make the following process to be set up in no more than a few minutes:
- Allow Sonarr & Radarr to send download requests to Qbittorrent
- Let qbittorrent download the files and let them be scanned for viruses
- Let the files be transcoded by an *external computer* into MP4 H.264, so that all the media is uniform *and* the Raspberry Pi doesn't need to transcode later on (since more obscure encodings in Plex sometimes require on-the-fly transcoding)
- Automatically download subtitles using Bazarr
- Automatically sync subtitles using ffsubsync
- Allow the media to be streamed through Plex

A delicious mix for ultimate convenience. A tasty media pie, if you will.

**Why use this setup if you need an external computer?**
You *could* build a dedicated machine for your media, but that'll cost you quite a few hundred bucks. The Media Raspberry Pie doesn't need anything but a small purchase and some storage. And most of use a computer besides the Raspberry Pi either way, so that that computer can handle the transcoding.

## Disclaimers

<details>
  <summary>Don't sue me disclaimer</summary>
  Different countries are different levels of strict on piracy. So following this tutorial does mean that you'll have to accept the risks that come with doing this. And please, support official releases if you have the chance. If you can easily get Netflix, and it houses the shows you want to watch, just don't pirate.
</details>

<details>
  <summary>Ethics disclaimer</summary>
  I have access to network television and I have Netflix. Disney+, Hulu, HBO Max, and many network-specific sites are not available in Belgium. DVD's are uncommon here and are usually imported from Australia. Many of the shows we get are dubbed, limited to old seasons, or simply unavailable in any way, shape, or form. I'd *love* to legally watch my shows - mind you, I support them with every change I get; I have bought more merch than I like to admit - but sadly not being American banishes me to the shadow realm. So that's why I'll revamp my old Raspberry Pi into a tool that allows me to watch what I'm not allowed to watch.
</details>

<details>
  <summary>Examples of impossibility to support official releases</summary>
  
  Sitcoms:
  - Brooklyn Nine-Nine: available until season 5 on Netflix. Season 6 and 7 both unavailable.
  
  Cartoons: 
  - Star Vs. The Forces Of Evil: unavailable.
  - Miraculous: only dubbed in Dutch. Netflix only uploaded half of Season 3.
  - Steven Universe: only season 4 on Netflix.
  
  
  Anime (e.g. Log Horizon, Fairy Tail): Netflix only offers French/Japanese audio with French subtitles. I speak neither.
  
  (*Why are most of these cartoons?* I'm apparently 5 years old)
</details>





## Instructions
You'll need:
- A Raspberry Pi -> this will download, store and stream your media
- A computer with a good CPU, any OS -> this will transcode the media to lighten the load on the Raspberry Pi

The instructions will refer to:
- The Raspberry Pi as **(media)-rpi**
- The good-cpu-machine as **transcoder**

I'll cut straight to the point: for context behind what I do or why I do it, look at [the explanations](#explanations)

___
### In case you haven't set up your Raspberry Pi yet

- Get yourself prefferably desktop-GUI-less, 64bit distro on your Raspberry Pi [(Raspberry's Imager tool is my tool of choice)](https://www.raspberrypi.org/downloads/)
- [Enhance the security](https://www.raspberrypi.org/documentation/configuration/security.md)
- [If you want, give yourself a static ip address for convenience](https://thepihut.com/blogs/raspberry-pi-tutorials/how-to-give-your-raspberry-pi-a-static-ip-address-update)
- [If you want, put your dphys-swapfile on an external drive to up the performance of your rpi](http://manpages.ubuntu.com/manpages/bionic/man8/dphys-swapfile.8.html)

___
### Install prerequisites on rpi

- [Install Docker](https://www.raspberrypi.org/blog/docker-comes-to-raspberry-pi/)
- Install [pip](https://www.raspberrypi.org/documentation/linux/software/python.md) and [Docker Compose](https://docs.docker.com/compose/install/#install-using-pip)
- Install git (```sudo apt-get install git```)

___
### Install prerequisites on Transcoder

<details>
    <summary>"My transcoder will run on a Windows machine"</summary>

  - [Python 3](https://www.python.org/downloads/)
    - Python 3 has to be added to path. The installer does take care of this, provided you don't uncheck the box
  - [FFMPEG](https://ffmpeg.org/download.html)
    - FFMPEG has to be added to path, yet this has to happen manually
  - [A Git install](https://git-scm.com/download/)
  - You'll need the ability to run .sh files. If you're on Windows, the git installation above here comes with Git Bash

</details>
<details>
  <summary>"My transcoder will run on a Linux machine"</summary>

  - [Python 3](https://www.python.org/downloads/)
    - If not handled by your distros python3 install, be sure that python3-pip is also installed
  - [FFMPEG](https://ffmpeg.org/download.html)
  - Git
  - (All of the above have to be added to path!)

  This script is meant to be quickly portable to Linux, and has most of the work done already to make the transition smoother. The remainder of the work should not be an issue if you've become at least a bit comfortable with your distro! Simply make sure that transcode.sh is run on an hourly basis (or whatever timeframe you prefer) and you're all settled
  
</details>


___

### Preparation

- Download the .env.example and rename it to .env
- Customize the .env file:
  - PUID = The ID of the user that you'd like to assign to the to-be-downloaded-files
  - PGID = The ID of the group that you'd like to assign to the to-be-downloaded-files
  - TZ = Your [TZ Timezone database name](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
  - UMASK_SET = The umask that will be applied to downloaded files (default is 022)
  - PORT_{SERVICE} = The port on which you'll be able to access the service
  - MEDIA_PATH = the **absolute** path where the media-rpi will store all the created files (downloads, config, logs, scripts, and video files)
  - TRANSCODER_PATH = The **absolute** path where the transcoder will keep the scripts to transcode
  - PIE_IP = The static ip of your rpi (or hostname, if you customize your hosts/are running a custom DNS)
  - If you are using a 1st or 2nd Gen Chromecast, add CHROMECAST_GEN_1_OR_2=True to your .env file. Do NOT add this line otherwise (as adding it will disable 1080p@60fps, nevertheless how uncommon that may be)
- Put the .env in a folder on the Raspberry Pi as well as the transcoder
  - On the transcoder: download & run build-transcoder.sh (from the same folder as the .env)
  - From the rpi: download & run build-raspberry.sh (from the same folder as the .env), and follow the instructions shown in it


___
### Initial setup (rpi)
Execute the following command in the same folder as your .env is located on the rpi
```sh
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/rpi/build-raspberry.sh" > build-raspberry.sh && chmod +x build-raspberry.sh
```
run build-raspberry.sh and follow the instructions provided therein. Afterwards, follow the instructions beneath.

**Configure qBittorrent: direct your browser of choice to ip:8080**
  - Open tools > options > downloads > Run external program on torrent completion
  - Enable it and insert the following line:
    `/bin/bash /downloads/post-download.sh "%R" "%N" "%L"`
  - Press Save


**Configure Jackett: direct your browser of choice to ip:9117**
  - Press `Add indexer` and add your favourites
  - Follow the instructions provided in Jackett for Sonarr and Radarr
  - <details>
    <summary>Config assistance whilst adding indexer in Sonarr/Radarr</summary>
    
    ----
  
    Name: personal preference, usually the name of the indexer
  
    ----
    
    Categories: check page 86 ([the predefined categories of Newznab](https:buildmedia.readthedocs.org/media/pdf/newznab/latest/newznab.pdf)) for whiccategories you need
    - For TV shows on Sonarr, I personally use 5000,5030,5040
    - For Movies on Radarr, I personally use 2000,2010,2020,2030,2035,2040,2045,2050,2060,5070
    
    ----

    Anime categories: the same as before, along with anime categories 
    
    - For TV shows on Sonarr, I personally use 5000,5030,5040,5070
    - For Movies on Radarr, I personally use 2000,2010,2020,2030,2035,2040,2045,2050,2060,5070
    
    ----  
  </details>

**Configure Sonarr (and Radarr): direct your browser of choice to ip:8989 (and ip:7878)**
  - Open Settings > Download Client > Add > qBittorrent (http://ip:8989/settings/indexers)
  - In Settings > Download Client, disable Completed Download Handling

**Configure Bazarr: direct your browser of choice to ip:6767**
  -  In General, nothing has to be changed! Cause we're using Docker; Bazarr, Sonarr and Radarr all use the same path mappings.
  - Subtitles:
    - Enable your favourite providers
    - Select your favourite languages
    - Enabled series & movies subtitles by default
    - Note: be careful with enabling Hearing-Impaired, since when I used it at first it didn't download _any_ non-hearing-impaired subtitles. This could (have) change(d) with newer releases, however  
  - Sonarr/Radarr:
    - Enable Use Sonarr/Radarr
    - Hostname or IP Address = PIE_IP
    - Listening Port = PORT_SONARR/PORT_RADARR (or 8989/7878)
    - API Key = APIKEY_SONARR/APIKEY_RADARR
  - After finishing initial setup, go to settings > General > Post-Processing
    - Enable `Use Post-Processing`
    - Post-processing command: `/scripts/sync-subtitles.sh "{{episode}}" "{{subtitles}}" "{{directory}}" "{{episode_name}}" {{subtitles_language_code2}}`

**Configure Plex: direct your browser of choice to ip:32400/web**
  - Configure movies and tv-shows to /movies and /tv respectively
  - After setup, enable Settings > Library > `Scan my library automatically` 


___
### Initial setup (Transcoder)
Execute the following command in the same folder as your .env is located on the rpi
```sh
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/transcoder/build-transcoder.sh" > build-transcoder.sh && chmod +x build-transcoder.sh
```
run build-transcoder.sh and follow the instructions provided therein

___
### Finished

And that's it! Let me know if you encounter any bugs or issues, and let me know how the experience goes. It's definitely an unconventional setup, and more of a fun thing to try rather than an ideal situation

## Adding more storage space
After mounting more storage space on your rpi (you can refer to [this tutorial](https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux) in case you're unfamiliar with that process), you still have to mount the hard drives in Sonarr, Radarr, Bazarr and Plex.
Start with making making directories to store tv shows and movies. Be sure that read/write over there is available for the PUID/GUID you used in  
Navigate to $media_path, and modify your docker-compose.yml. Under Sonarr, Radarr, Bazarr and Plex's `volumes:` entries, add:
  - (Sonarr): `- /mnt/yourhdd/path/for/tv/shows:/tv2`
  - (Radarr): `- /mnt/yourhdd/path/for/movies:/movies2`
  - (Bazarr and Plex): 
    - `- /mnt/yourhdd/path/for/tv/shows:/tv2`
    - `- /mnt/yourhdd/path/for/movies:/movies2`

(note: you can change tv2/movies2 to anything you want, as long as it's clear for you and **consistent across your entries**)

Afterwards, running `sudo docker-compose up` should do the trick to mount your new drive.
If it errors, you can recreate your containers using `sudo docker stop sonarr radarr bazarr plex && sudo docker rm sonarr radarr bazarr plex && sudo docker-compose up`(your config *should* be safe, considering it's stored in $media_path/config, but nevertheless refrain from this unless necessary).

In Sonarr/Radarr, you can now add the new path when adding a series. This only has to be done once, and then you can select between your drives at will.
In Plex, open Settings > Libraries > TV programmes/Films > Edit > Add Folders and add the new paths.
In Bazarr, no additional configuration is needed.


## Known issues
- If the transcoder gives an error that the ffmpeg binary couldn't be found, try modifying the ffmpeg & ffprobe value in TRANSCODER_PATH/repo/config/autoProcess.ini to ffmpeg.exe & ffprobe.exe, or perhaps even trying an absolute path
- Sometimes, transcode.sh seems to error during the MOOV process, or just skips files. Moving the files into a different folder within to-transcode/{service}/ seems to help though!
- The scan-hourly-for-transcode.bat doesn't auto-hide itself (yet).
- Automatic setup for qBittorrent was attempted, but the full conf file isn't instantly generated from startup. The risk of messing with a subject-to-change conf file will be larger than effort of pressing a few buttons during setup.