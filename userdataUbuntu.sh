#!/bin/bash

sudo apt update -y
sudo apt install default-jdk -y

java -version

mkdir /opt/minecraft/
mkdir /opt/minecraft/server/
cd /opt/minecraft/server/
wget https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar

java -Xmx1024M -Xms1024M -jar server.jar nogui