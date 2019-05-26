# CS:GO Dockerfile
(Yet another) Dockerfile and start script for cs:go. Uses [LGSM](https://gameservermanagers.com/lgsm/csgoserver/) for installation and easy updates. Supports custom ip:port.

## Install Docker 

#!/bin/bash
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker


## Clone Repo

git clone https://github.com/Ausbilder/CSGO_Server.git

## Enter Folder

cd CSGO_Server

## Build Container 

docker build -t "svenahlfeld/csgo:latest" .

## Deploy server

Edit the scripts to adjust number of required containers




