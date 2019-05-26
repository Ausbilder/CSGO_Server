#
# LinuxGSM Dockerfile
#
# https://github.com/GameServerManagers/LinuxGSM-Docker
#
FROM ubuntu:18.04

EXPOSE 27015/tcp
EXPOSE 27015/udp
EXPOSE 27020/udp
EXPOSE 27005/udp

LABEL maintainer="LinuxGSM"

ENV DEBIAN_FRONTEND noninteractive


## Base System
RUN dpkg --add-architecture i386 && \
	apt-get update -y && \
	apt-get install -y \
		binutils \
		mailutils \
		postfix \
		bc \
		curl \
		wget \
		file \
		bzip2 \
		gzip \
		unzip \
		xz-utils \
		libmariadb2 \
		bsdmainutils \
		python \
		util-linux \
		ca-certificates \
		tmux \
		lib32gcc1 \
		libstdc++6 \
		libstdc++6:i386 \
		libstdc++5:i386 \
		libsdl1.2debian \
		default-jdk \
		lib32tinfo5 \
		speex:i386 \
		libtbb2 \
		libcurl4-gnutls-dev:i386 \
		libtcmalloc-minimal4:i386 \
		libncurses5:i386 \
		zlib1g:i386 \
		libldap-2.4-2:i386 \
		libxrandr2:i386 \
		libglu1-mesa:i386 \
		libxtst6:i386 \
		libusb-1.0-0-dev:i386 \
		libxxf86vm1:i386 \
		libopenal1:i386 \
		libssl1.0.0:i386 \
		libgtk2.0-0:i386 \
		libdbus-glib-1-2:i386 \
		libnm-glib-dev:i386 \
		nano \
		sudo
	
## Get Linux GameServerManagers
RUN wget https://linuxgsm.com/dl/linuxgsm.sh

# need use xterm for LinuxGSM
ENV TERM=xterm
## Docker Details
ENV PATH=$PATH:/home/lgsm

## user config
RUN useradd -m lgsm \
	&& echo "lgsm ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
	&& cp linuxgsm.sh /home/lgsm \
	&& chown lgsm:lgsm /home/lgsm -R \
	&& chmod a+x /home/lgsm/linuxgsm.sh
	
# CHANGE USER
USER lgsm

# SET WORKING DIR
WORKDIR /home/lgsm

# INSTALL CSGO SERVER AUTOMATISATION
RUN ./linuxgsm.sh csgoserver 

RUN	chmod a+x /home/lgsm/csgoserver \
	&& chown lgsm:lgsm /home/lgsm/csgoserver

RUN ./csgoserver auto-install 
#&& ./csgoserver force-update && ./csgoserver validate

# VOLUME FOR STORING RECORDS
VOLUME /home/lgsm/serverfiles/csgo/matches

# COPY CONFIG
COPY config/* /home/lgsm/serverfiles/csgo/cfg/
# COPY MAPS - CUSTOM MAPS
COPY maps/* /home/lgsm/serverfiles/csgo/maps/

CMD sed -i "s/hostname.*/hostname $SERVER_HOSTNAME/" /home/lgsm/serverfiles/csgo/cfg/csgoserver.cfg && \
sed -i "s/tv_name.*/tv_name '$SERVER_HOSTNAME GOTV'/" /home/lgsm/serverfiles/csgo/cfg/eslgotv.cfg && \
sed -i "s/rcon_password.*/rcon_password $RCON_PASSWORD/" /home/lgsm/serverfiles/csgo/cfg/csgoserver.cfg && \
sed -i "s/sv_password.*/sv_password $SERVER_PASSWORD/" /home/lgsm/serverfiles/csgo/cfg/csgoserver.cfg && \
sed -i "s/sv_lan.*/sv_lan 1/" /home/lgsm/serverfiles/csgo/cfg/csgoserver.cfg && \
./serverfiles/srcds_run -game csgo -usercon -port 27015 +clientport 27005 +tv_port 27020 -tickrate $TICKRATE +map $MAP -maxplayers_override $MAXPLAYERS +mapgroup $MAPGROUP +game_mode $GAME_MODE +game_type $GAME_TYPE +servercfgfile csgoserver.cfg