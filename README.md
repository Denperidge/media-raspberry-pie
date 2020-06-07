# Media Raspberry Pie

Can you use a Raspberry Pie to download and stream your media? Yes. Should you? No idea.

I wanted to see if I could make the following process to be set up in no more than a few minutes:
- Allow Sonarr & Radarr to send download requests to Qbittorrent
- Let qbittorrent download the files and let them be scanned for viruses
- Let the files be transcoded by an *external computer* into MP4 H.264, so that all the media is uniform *and* the Raspberry Pie doesn't need to transcode later on (since more obscure encodings in Plex sometimes require on-the-fly transcoding)
- Automatically download subtitles using Bazarr
- Automatically sync subtitles using ffsubsync
- Allow the media to be streamed through Plex

**Why use this setup if you need an external computer?**
You *could* build a dedicated machine for your media, but that'll cost you quite a few hundred bucks. The Raspberry Pie doesn't need anything but a small purchase and some storage. And most of use a computer besides the Raspberry Pie either way, so that that computer can handle the transcoding.

## Disclaimers
---

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
---
You'll need:
- A Raspberry Pi -> this will download, store and stream your media
- A (Windows) computer -> this will transcode the media to lighten the load on the Raspberry Pi

The instructions will refer to:
- The Raspberry Pi as **(media)-rpi**
- The Windows machine as **transcoder**

I'll cut straight to the point: for context behind what I do or why I do it, look at [the explanations](#explanations)

### In case you haven't set up your Raspberry Pi yet
- Get yourself prefferably desktop-GUI-less, 64bit distro on your Raspberry Pi [(Raspberry's Imager tool is my tool of choice)](https://www.raspberrypi.org/downloads/)
- [Enhance the security](https://www.raspberrypi.org/documentation/configuration/security.md)
- [If you want, give yourself a static ip address for convenience](https://thepihut.com/blogs/raspberry-pi-tutorials/how-to-give-your-raspberry-pi-a-static-ip-address-update)
- [If you want, put your dphys-swapfile on an external drive to up the performance of your rpi](http://manpages.ubuntu.com/manpages/bionic/man8/dphys-swapfile.8.html)


### Install prerequisites on rpi
- [Install Docker](https://www.raspberrypi.org/blog/docker-comes-to-raspberry-pi/)
- Install [pip](https://www.raspberrypi.org/documentation/linux/software/python.md) and [Docker Compose](https://docs.docker.com/compose/install/#install-using-pip)
- Install and git (```sudo apt-get install git```)

### Install prerequisites on Transcoder
- [A Git install](https://git-scm.com/download/win)
- You'll need a program that can run .sh files. Luckily, the git installation above here comes with Git Bash
- FFMPEG:
  - Note: some own choices are advised by me personally --> these are usually broad tools which may help with specific encodings, even if not as common 
  - **Select the build target system:** Select both (1) or 64-bit (3)
  - **Build FFmpeg with which license?** Non-free (1)
  - **Build standalone binaries for libraries included in FFmpeg?** Yes (1)
  - **Build vpx [VP8/VP9 encoder]?** Own choice, advised
  - **Build aom [Alliance for Open Media codec]?** Own choice, advised
  - **Build rav1e [Alternative, faster AV1 standalone encoder]?** Own choice
  - **Build dav1d [Alternative, faster AV1 decoder]?** Own choice
  - **Build x264 [H.264 encoder]?** Lib/binary with 8 and 10-bit (1) or Lib/binary with 8 and 10-bit, and libavformat and ffms2 (4)
  - **Build x265 [5.265 encoder]?** Own choice, advised
  - **Build Kvazaar? [H.265 encoder]** Own choice
  - **Build SVT-HEVC? [H.265 encoder]** Own choice
  - **Build xvc? [HEVC and AV1 competitor]** Own choice, *not advised* by the builder itself
  - **Build Fraunhofer VVC? [H.265 successor enc/decoder]** Own choice
  - **Build SVT-AV1? [AV1 encoder]** Own choice
  - **Build SVT-VP9? [VP9 encoder]** Own choice
  - **Build FLAC? [Free Lossless Audio Codec]** Own choice
  - **Build FDK-AAC library and binary? [AAC-LC/HE/HEv2 codec]** Yes (1)
  - **Build FAAC library and binary? [old, low-quality and nonfree AAC-LC codec]** Own choice, *not advised* by the builder 
  - **Build exhale binary? [open-source ISO/IEC 23003-3 USAC, xHE-AAC encoder]** Own choice
  - **Build mediainfo binaries [Multimedia file information tool]?** Own choice
  - **Build sox binaries [Sound processing tool]?** Own choice
  - **Build FFmpeg binaries and libraries:** Yes (1), or another yes-answer if you know what you're doing
  - **Always build FFmpeg when libraries have been updated?** Own choice
  - **Choose ffmpeg and mpv optional libraries?** No (Light build) (2) or Yes (1)
  - **Build static mp4box [mp4 muxer/toolbox] binary?** Own choice
  - **Build static rtmpdump binaries [rtmp tools]?** Own choice, *not advised* by the builder itself 
  - **Build mpv?** Own choice
  - **Build vlc?** Own choice, *not advised* by the builder itself 
  - **Build static bmx tools?** Own choice
  - **Build static curl?** Own choice
  - **Build FFMedia Broadcast binary?** Own choice, *not advised* by the builder itself 
  - **Build cyanrip (CLI CD ripper)?** Own choice
  - **Build redshift (f.lux FOSS clone)?** Own choice
  - **Build ripgrep (faster grep in Rust)?** Own choice
  - **Build jq (CLI JSON processor)?** Own choice
  - **Build jo (CLI JSON from shell)?** Own choice
  - **Build dssim (multiscale SSIM in Rust)?** Own choice
  - **Build avs2 (Audio Video Coding Standard Gen2 encoder/decoder)?** Own choice
  - **Use clang instead of gcc (C compiler)?** No (2)
  - **Number of CPU Cores/Threads for compiling:** 2 or 4, depending on your pc. If you're doubting, use 2.
  - **Number of CPU Cores/Threads for compiling:** Yes (1)
  - **Strip compiled files binaries?** Yes (1)
  - **Pack compiled files?** No (2)
  - **Write logs of compilation commands?** Yes (1)
  - **Create script to update suite files automatically?** Own choice
  - **Create script to update suite files automatically?** Own choice
  - **Use ccache when compiling?** Own choice
  - **Are you running this script through ssh or similar?** Own choice. If you don't know what this means, you probably didn't.


### Installation
- Download the .env.example and rename it to .env
- Customize the .env file:
  - PUID = The ID of the user that you'd like to assign to the to-be-downloaded-files
  - PGID = The ID of the group that you'd like to assign to the to-be-downloaded-files
  - TZ = Your [TZ Timezone database name](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
  - The umask that will be applied to downloaded files (default is 022)
  - Point to the *absolute* paths you'd like to use
  - PORT_{SERVICE} = The port on which you'll be able to access the service
  - MEDIA_PATH = the **absolute** path where the media-rpi will store all the created files (downloads, config, logs, scripts, and video files)
  - TRANSCODER_PATH = The **absolute** path where the transcoder will keep the scripts to transcode
  - PIE_IP = The static ip of your rpi (or hostname, if you customize your hosts/are running a custom DNS)
- Put the .env in a folder on the Raspberry Pi as well as the transcoder
  - Download & run build-transcoder.sh from the same folder as the .env on the transcoder
  - Download & run build-raspberry.sh from the same folder as the .env on the rpi, and follow the instructions shown in it


### Initial setup
  - Configure Jackett: direct your browser of choice to ip:9117
    - Press `Add indexer` and add your favourites
    - Follow the instructions provided in Jackett for Sonarr and Radarr
    - <details>
        <summary>Config assistance whilst adding indexer in Sonarr/Radarr</summary>
        
        ----
  
        Name: personal preference, usually the name of the indexer
  
        ----
        
        Categories: check page 86 ([the predefined categories of Newznab](https://buildmedia.readthedocs.org/media/pdf/newznab/latest/newznab.pdf)) for which categories you need
        - For TV shows on Sonarr, I personally use 5000,5030,5040
        - For Movies on Radarr, I personally use 2000,2010,2020,2030,2035,2040,2045,2050,2060,5070
        
        ----

        Anime categories: the same as before, along with anime categories 
        
        - For TV shows on Sonarr, I personally use 5000,5030,5040,5070
        - For Movies on Radarr, I personally use 2000,2010,2020,2030,2035,2040,2045,2050,2060,5070
        
        ----  
      </details>
  - Configure Sonarr: direct your browser of choice to ip:8989
    - Open Settings > Download Client > Add > qBittorrent (http://ip:8989/settings/indexers)
  - Configure Plex: direct your browser of choice to ip:32400/web
    - Configure movies and tv-shows to /movies and /tv respectively

  
```sh
curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/build-raspberry.sh" > build-raspberry.sh && chmod +x build-raspberry.sh

curl "https://raw.githubusercontent.com/Denperidge/media-raspberry-pie/master/build-transcoder.sh" > build-transcoder.sh && chmod +x build-transcoder.sh
```