#!/bin/bash

#install java
sudo apt update -y
sudo apt upgrade -y
sudo apt install openjdk-17-jdk-headless -y

java -version

mkdir /opt/minecraft/

# Run commands to install mcrcon, a tool that allows you to run commands for the minecraft server
mkdir/opt/minecraft/tools/
cd /opt/minecraft/tools/
git clone https://github.com/Tiiffi/mcrcon.git
cd mcrcon
make
sudo make install

# download the minecraft server
mkdir /opt/minecraft/server/
cd /opt/minecraft/server/
wget https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar

# start up the server and fix the eula.txt file
sudo java -Xmx1024M -Xms1024M -jar server.jar nogui

sudo sed -i 's/eula=false/eula=true/' eula.txt

sudo cat <<EOT >> /etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft Server
After=syslog.target network.target

[Service]
# Ensure to set the correct user and working directory (installation directory of your server) here
User=minecraft
WorkingDirectory=/opt/minecraft/server

# You can customize the maximum amount of memory as well as the JVM flags here
ExecStart=/usr/bin/java -Xmx4048M -Xms1024M -jar server.jar --nojline --noconsole

# Restart the server when it is stopped or crashed after 30 seconds
# Comment out RestartSec if you want to restart immediately
Restart=always
RestartSec=30

# Alternative: Restart the server only when it stops regularly
# Restart=on-success

# Do not remove this!
StandardInput=null

[Install]
WantedBy=multi-user.target
EOT

sudo chmod 664 /etc/systemd/system/minecraft.service
sudo systemctl daemon-reload
sudo systemctl enable minecraft.service