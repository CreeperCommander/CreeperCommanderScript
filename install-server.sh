#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "You must run this script as root"
    exit 1
fi

# Check if the required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <server_version> <server_name>"
    exit 1
fi

# Extract arguments
serverVersion="$1"
serverName="$2"

# Check if the server name is provided
if [ -z "$serverName" ]; then
    echo "You must specify the server name"
    exit 1
fi

# Check if the server already exists
if [ -d "$HOME/CreeperCommander/servers/$serverVersion-$serverName" ]; then
    echo "Server already exists with the same name and version"
    exit 1
fi

# Create the minecraft user if not exists
if ! id "minecraft" &>/dev/null; then
    useradd -m -d /home/minecraft -s /bin/bash minecraft
fi

# Set up sudo permissions for the minecraft user
echo "minecraft ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/minecraft
echo "Defaults:minecraft !requiretty" >> /etc/sudoers.d/minecraft

# Create the server directory
serverDir="$HOME/CreeperCommander/servers/$serverVersion-$serverName"
mkdir -p "$serverDir"
cd "$serverDir" || exit 1

# Install the server
wget "https://maven.fabricmc.net/net/fabricmc/fabric-installer/$serverVersion/fabric-installer-$serverVersion.jar" -O "server.jar"
echo "eula=true" > eula.txt

# Create server properties
cat << EOF > server.properties
serverJar=server.jar
serverVersion=$serverVersion
serverName=minecraft-server-$serverVersion
serverPort=25565
serverIp=localhost
serverMaxPlayers=20
serverMotd=Welcome to the server
serverDifficulty=easy
serverGamemode=survival
serverWorld=world
serverSeed=
serverSpawnProtection=16
serverViewDistance=10
EOF

# Start the server
java -Xmx1024M -Xms512M -jar server.jar

# Clean up server jar
rm "server.jar"

# Optional: Create service and start it (uncomment if needed)
# Create the service
# cat << EOF > minecraft-server-$serverVersion.service
# [Unit]
# Description=Minecraft Server
# After=network.target
#
# [Service]
# Type=simple
# User=$USER
# WorkingDirectory=$serverDir
# ExecStart=/usr/bin/java -Xms1G -Xmx1G -jar server.jar
# Restart=on-failure
#
# [Install]
# WantedBy=multi-user.target
# EOF
#
# # Enable and start the service
# systemctl enable "$serverDir/minecraft-server-$serverVersion.service"
# systemctl start "minecraft-server-$serverVersion"

# Check if the server is running
# if systemctl is-active --quiet "minecraft-server-$serverVersion"; then
#     echo "Server is running"
# else
#     echo "Server failed to start"
# fi

exit 0
