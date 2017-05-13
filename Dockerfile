FROM phusion/baseimage:0.9.18
MAINTAINER SAH
EXPOSE 27015/tcp
EXPOSE 27015/udp
EXPOSE 27020/udp
EXPOSE 27005/udp
ENV DEBIAN_FRONTEND noninteractive
CMD bash
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y lib32gcc1 libstdc++6:i386 curl tmux bsdmainutils wget mailutils postfix git nano\
  && apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*\
  && (useradd -m cs && chown cs:cs /home/cs -R && echo "cs ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers)\
  && (curl https://raw.githubusercontent.com/dgibbs64/linuxgsm/master/CounterStrikeGlobalOffensive/csgoserver > /home/cs/csgoserver)\
  && chmod a+x /home/cs/csgoserver && chown cs:cs /home/cs/csgoserver\
  && (echo "cs ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers)
USER cs
WORKDIR /home/cs
RUN ./csgoserver auto-install
WORKDIR /home/cs
COPY config/* /home/cs/serverfiles/csgo/cfg/
COPY maps/* /home/cs/serverfiles/csgo/maps/
RUN (echo '#!/bin/bash\n\
sed -i "/hostname \"/s/\"\([^\\"]*\)\"/\"$HOSTNAME\"/" serverfiles/csgo/cfg/csgo-server.cfg\n\
sed -i "/rcon_password \"/s/\"\([^\\"]*\)\"/\"$RCONPASSWORD\"/" serverfiles/csgo/cfg/csgo-server.cfg\n\
sed -i "/sv_password \"/s/\"\([^\\"]*\)\"/\"$PASSWORD\"/" serverfiles/csgo/cfg/csgo-server.cfg\n\
sed -i "/tv_name \"/s/\"\([^\\"]*\)\"/\"GoTV $HOSTNAME\"/" serverfiles/csgo/cfg/eslgotv.cfg\n\
cd /home/cs/serverfiles\n\
./srcds_run -game csgo -usercon -strictportbind -ip $(hostname --ip-address) -port 27015 +clientport 27005 +tv_port 27020 -tickrate $TICKRATE +sv_setsteamaccount $GSLT +map $MAP +servercfgfile csgo-server.cfg -maxplayers_override $MAXPLAYERS +mapgroup $MAPGROUP +game_mode $GAMEMODE +game_type $GAMETYPE +net_public_adr $PUBLIC $CUSTOM' >> /home/cs/start)\
  && chmod a+x /home/cs/start && mkdir -p /home/cs/serverfiles/csgo/matches && (sudo sh -c "echo Europe/Berlin > /etc/timezone") && sudo dpkg-reconfigure -f noninteractive tzdata
VOLUME /home/cs/serverfiles/csgo/matches
