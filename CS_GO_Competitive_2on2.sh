#!/bin/bash

RCONPASSWORD=blan
PASSWORD=blan
TICKRATE=128
MAP=de_dust
MAPGROUP=mg_active
MAXPLAYERS=4
GAMEMODE=2
GAMETYPE=0

SERVERPORT=27015
TVPORT=27020
CLIENTPORT=27005
TOKEN=('8B6A88B138E85729369D23E09FDBC083','42F51CC038600C2DE6DA5E7041C4E031','447BC82D97E4AA39E0E19B7AF62CDCCA','4FA854D5A32673A67073C67EBE9F3C72','F13535D149364D6F0248333DCDD81A21')

for i in {1..5}
do
PORTOFFSET=$((($i-1)*100))
CSERVERPORT=$(($SERVERPORT+$PORTOFFSET))
CTVPORT=$(($TVPORT+$PORTOFFSET))

sudo docker run \
	-d \
	-p $CSERVERPORT:27015/tcp \
	-p $CSERVERPORT:27015/udp \
	-p $CTVPORT:27020/udp \
	-p $CTVPORT:27020/tcp \
	-e "SERVER_HOSTNAME='CS:GO 2on2 WAR #$i'" \
	-e "SERVER_PASSWORD=$RCONPASSWORD" \
	-e "RCON_PASSWORD=$PASSWORD" \
	-e "TICKRATE=$TICKRATE" \
	-e "GAME_TYPE=$GAMETYPE" \
	-e "GAME_MODE=$GAMEMODE" \
	-e "MAP=$MAP" \
	-e "MAPGROUP=$MAPGROUP" \
	-e "MAXPLAYERS=$MAXPLAYERS" \
	-e "TOKEN=${TOKEN[*]}
	--name csgo_2on2_$i \
	svenahlfeld/csgo:latest
	echo "Started CS:GO 2on2 ServerID $i"
done
