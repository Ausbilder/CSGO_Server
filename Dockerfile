FROM ubuntu:20.04

LABEL maintainer="LinuxGSM <me@danielgibbs.co.uk>"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM=xterm
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install UTF-8 unicode
RUN echo "**** Install UTF-8 ****" \
    && apt-get update \
    && apt-get install -y locales apt-utils debconf-utils
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

## Upgrade Ubuntu
RUN echo "**** apt upgrade ****" \
    && apt-get update; \
    apt-get upgrade -y

## Install Base LinuxGSM Requirements
RUN echo "**** Install Base LinuxGSM Requirements ****" \
    && apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository multiverse \
    && apt-get update \
    && apt-get install -y \
    bc \
    binutils \
    bsdmainutils \
    bzip2 \
    ca-certificates \
	cron \
    cpio \
    curl \
    distro-info \
    file \
    gzip \
    hostname \
    jq \
    lib32gcc1 \
    lib32stdc++6 \
    netcat \
    python3 \
    tar \
    tmux \
    unzip \
    util-linux \
    wget \
    xz-utils \
    # Docker Extras
    cron \
    iproute2 \
    iputils-ping \
    nano \
    vim \
    sudo \
    tini

# Install SteamCMD
RUN echo "**** Install SteamCMD ****" \
    && echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends libsdl2-2.0-0:i386 steamcmd \
    && ln -s /usr/games/steamcmd /usr/bin/steamcmd

# Install NodeJS
RUN echo "**** Install NodeJS ****" \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get update && apt-get install -y nodejs

# Install GameDig https://docs.linuxgsm.com/requirements/gamedig
RUN echo "**** Install GameDig ****" \
    && npm install -g gamedig

# Install Cleanup
RUN echo "**** Cleanup ****"  \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

##Need use xterm for LinuxGSM##

ENV DEBIAN_FRONTEND noninteractive

ARG USERNAME=linuxgsm
ARG USER_UID=1000
ARG USER_GID=$USER_UID

## Add linuxgsm user
RUN echo "**** Add linuxgsm user ****" \
# Create the user
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && chown $USERNAME:$USERNAME /home/$USERNAME

# Create /opt/linuxgsm
#RUN echo "**** Create /opt/linuxgsm ****" \
#    && mkdir -p /opt/linuxgsm \
#    && chown linuxgsm:linuxgsm /opt/linuxgsm

WORKDIR /home/linuxgsm
ENV PATH=$PATH:/home/linuxgsm
USER linuxgsm

## Download linuxgsm.sh
RUN echo "**** Download linuxgsm.sh ****" \
    && set -ex \
    && wget -O linuxgsm.sh https://linuxgsm.sh \
    && chmod +x /linuxgsm.sh \
    && bash linuxgsm.sh csgoserver

RUN ./csgoserver auto-install 
#&& ./csgoserver force-update && ./csgoserver validate

# VOLUME FOR STORING RECORDS
VOLUME /home/linuxgsm/serverfiles/csgo/matches

# COPY CONFIG
COPY config/* /home/linuxgsm/serverfiles/csgo/cfg/
# COPY MAPS - CUSTOM MAPS
COPY maps/* /home/linuxgsm/serverfiles/csgo/maps/

CMD sed -i "s/hostname.*/hostname $SERVER_HOSTNAME/" /home/linuxgsm/serverfiles/csgo/cfg/csgoserver.cfg && \
sed -i "s/tv_name.*/tv_name '$SERVER_HOSTNAME GOTV'/" /home/linuxgsm/serverfiles/csgo/cfg/eslgotv.cfg && \
sed -i "s/rcon_password.*/rcon_password $RCON_PASSWORD/" /home/linuxgsm/serverfiles/csgo/cfg/csgoserver.cfg && \
sed -i "s/sv_password.*/sv_password $SERVER_PASSWORD/" /home/linuxgsm/serverfiles/csgo/cfg/csgoserver.cfg && \
sed -i "s/sv_lan.*/sv_lan 1/" /home/linuxgsm/serverfiles/csgo/cfg/csgoserver.cfg && \
./serverfiles/srcds_run -game csgo -usercon -port 27015 +clientport 27005 +tv_port 27020 -tickrate $TICKRATE +map $MAP -maxplayers_override $MAXPLAYERS +mapgroup $MAPGROUP +game_mode $GAME_MODE +game_type $GAME_TYPE +servercfgfile csgoserver.cfg
