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
I'll cut straight to the point: for context behind what I do or why I do it, look at [the explanations](#explanations)

### In case you haven't set up your Raspberry Pie yet
- Get yourself prefferably desktop-GUI-less, 64bit distro on your Raspberry Pi [(Raspberry's Imager tool is my tool of choice)](https://www.raspberrypi.org/downloads/)
- [Enhance the security](https://www.raspberrypi.org/documentation/configuration/security.md)
- [If you want, give yourself a static ip address for convenience](https://thepihut.com/blogs/raspberry-pi-tutorials/how-to-give-your-raspberry-pi-a-static-ip-address-update)


### Install prerequisites
- [Install Docker](https://www.raspberrypi.org/blog/docker-comes-to-raspberry-pi/)
- Install [pip](https://www.raspberrypi.org/documentation/linux/software/python.md) and [Docker Compose](https://docs.docker.com/compose/install/#install-using-pip)
- Install ffmpeg and git (```sudo apt-get install ffmpeg git```)

### Setup
- Create a new folder to store the configuration of Docker. cd into it and wget the [docker-compose]() and the [.env]() file
- Customize the .env file to:
  - Point to the *absolute* paths you'd like to use
  - Point to your [TZ Timezone database name](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
  - The ID of the user (PUID) and group (PGID) that you'd like to assign to the to-be-downloaded-files
  - The umask (default is 022)
 - ```sudo docker-compose up```
 - Now we'll configure our services:
  - Configure Jackett: direct your browser of choice to ip:9117
    - Press `Add indexer` and add your favourites
    - Follow the instructions provided in Jackett for Sonarr and Radarr
    - <details>
        <summary>Config assistance</summary>
        
        ----
  
        Name: personal reference, usually the name of the indexer
  
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