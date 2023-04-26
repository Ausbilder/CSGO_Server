## Clone Repo

git clone https://github.com/Ausbilder/CSGO_Server.git

## Enter Folder

cd CSGO_Server

## Build Container 

docker build -t "svenahlfeld/csgo:latest" .

## Deploy server

Edit the scripts to adjust number of required containers



----------------------------

Downloading Counter-Strike: Global Offensive Configs
=================================
default configs from https://github.com/GameServerManagers/Game-Server-Configs
fetching GitHub server.cfg...OK
copying server.cfg config file.
'/home/linuxgsm/lgsm/config-default/config-game/server.cfg' -> '/home/linuxgsm/serverfiles/csgo/cfg/csgoserver.cfg'
changing hostname.
changing rcon/admin password.

Config File Locations
=================================
Game Server Config File: /home/linuxgsm/serverfiles/csgo/cfg/csgoserver.cfg
LinuxGSM Config: /home/linuxgsm/lgsm/config-lgsm/csgoserver
Documentation: https://docs.linuxgsm.com/configuration/game-server-config
fetching GitHub install_gslt.sh...OK

Game Server Login Token
=================================
GSLT is required to run a public Counter-Strike: Global Offensive server
Get more info and a token here:
https://docs.linuxgsm.com/steamcmd/gslt

The GSLT can be changed by editing /home/linuxgsm/lgsm/config-lgsm/csgoserver/csgoserver.cfg.

fetching GitHub fix.sh...OK
fetching GitHub install_stats.sh...OK

LinuxGSM Stats
=================================
Assist LinuxGSM development by sending anonymous stats to developers.
More info: https://docs.linuxgsm.com/configuration/linuxgsm-stats
The following info will be sent:
* game server
* distro
* game server resource usage
* server hardware info
Information! auto-install leaves stats off by default. Stats can be enabled in common.cfg
fetching GitHub install_complete.sh...OK
