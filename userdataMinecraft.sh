#!/bin/bash

#install java

sudo apt update
sudo apt install make

sudo wget https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz
sudo tar xvf openjdk-17.0.2_linux-x64_bin.tar.gz
sudo mv jdk-17.0.2/ /opt/jdk-17/
echo 'export JAVA_HOME=/opt/jdk-17' | tee -a ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin '|tee -a ~/.bashrc
source ~/.bashrc

java -version

mkdir /opt/minecraft/

# Run commands to install mcrcon, a tool that allows you to run commands for the minecraft server
sudo mkdir /opt/minecraft/tools/
cd /opt/minecraft/tools/
sudo git clone https://github.com/Tiiffi/mcrcon.git
cd mcrcon
make
sudo make install

# download the minecraft server
sudo mkdir /opt/minecraft/server/
cd /opt/minecraft/server/
sudo wget https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar

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
ExecStart=java -Xmx4048M -Xms1024M -jar server.jar --nojline --noconsole

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