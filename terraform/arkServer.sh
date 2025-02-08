#!/bin/bash

apt-get install lib32gcc1 -y

adduser ark
sudo su
mkdir /opt/ark/
mkdir /opt/ark/server/
cd /opt/ark/server
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

tar -xvzf steamcmd_linux.tar.gz
./steamcmd.sh +login anonymous +force_install_dir /opt/ark/server +app_update 376030 validate +quit

cat <<EOT >> /etc/systemd/system/ark-dedicated.service
[Unit]
Description=Ark: Survival Server
After=network.target

[Service]
User=ark
Nice=5
KillMode=none
SuccessExitStatus=0 1
InaccessibleDirectories=/root /sys /srv /media -/lost+found
NoNewPrivileges=true
WorkingDirectory=/opt/ark/server
ReadWriteDirectories=/opt/ark/server
ExecStart=/opt/ark/server/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?SessionName=MyServer?ServerPassword=MyPassword?ServerAdminPassword=MyAdminPassword -server -log
ExecStop=/opt/ark/server/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?SessionName=MyServer?ServerPassword=MyPassword?ServerAdminPassword=MyAdminPassword -server -log
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOT

chmod 664 /etc/systemd/system/ark.service
systemctl daemon-reload
systemctl enable ark.service
systemctl start ark.service
