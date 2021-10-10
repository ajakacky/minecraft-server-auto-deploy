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
After=network.target

[Service]
User=minecraft
Nice=5
KillMode=none
SuccessExitStatus=0 1
InaccessibleDirectories=/root /sys /srv /media -/lost+found
NoNewPrivileges=true
WorkingDirectory=/opt/minecraft/server
ReadWriteDirectories=/opt/minecraft/server
ExecStart=sudo /usr/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui
ExecStop=/opt/minecraft/tools/mcrcon/mcrcon -H 127.0.0.1 -P 25575 -p strong-password stop

[Install]
WantedBy=multi-user.target
EOT

sudo chmod 664 /etc/systemd/system/minecraft.service
sudo systemctl daemon-reload
sudo systemctl enable minecraft.service