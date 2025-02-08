#!/bin/bash

apt-get update
apt-get install docker.io -y
systemctl start docker
systemctl enable docker
usermod -a -G docker $(whoami)

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.28.1/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

mkdir -p /server
cd /server
mkdir -p data mods

cat <<EOF > docker-compose.yml
version: '3'
services:
  server:
    image: itzg/minecraft-server
    ports:
      - 25565:25565
    environment:
      EULA: true
      VERSION: 1.21.1
      TYPE: FABRIC
      HARDCORE: false
      CF_API_KEY: ${cf_api_key}
      MEMORY: 10G
      DIFFICULTY: hard
    volumes:
      - ./data:/data
      - ./mods:/data/mods
EOF