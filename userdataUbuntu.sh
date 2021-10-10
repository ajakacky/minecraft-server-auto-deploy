#!/bin/bash

sudo apt update -y
sudo apt install default-jdk -y

java -version

mkdir /opt/minecraft/
mkdir /opt/minecraft/server/
cd /opt/minecraft/server/
wget https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar

java -Xmx1024M -Xms1024M -jar server.jar nogui

sudo sed -i 's/eula=false/eula=true/' eula.txt

cat <<EOT >> /etc/systemd/system/minecraft.service
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
ExecStart=java -Xmx1024M -Xms1024M -jar server.jar nogui
ExecStop=/opt/minecraft/tools/mcrcon/mcrcon -H 127.0.0.1 -P 25575 -p strong-password stop

[Install]
WantedBy=multi-user.target
EOT

chmod 664 /etc/systemd/system/minecraft.service
systemctl daemon-reload