#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "You must run this script as root"
    exit 1
fi

sudo apt install curl jq -y

# Check if the required arguments are provided
if [ "$#" -ne 4 ] && [ "$#" -ne 5 ]; then
    echo "Usage: $0 <minecraftVersion> <modLoader> <modLoaderVersion> <installerVersion> <serverName>"
    exit 1
fi

# Extract arguments
minecraftVersion="$1"
modLoader="$2"
if [ "$modLoader" == "vanilla" ]; then
    installerVersion="$3"
    serverName="$4"
else
    modLoaderVersion="$3"
    installerVersion="$4"
    serverName="$5"
fi

# Check if the server name is provided
if [ -z "$serverName" ]; then
    echo "You must specify the minecraft version, mod loader, mod loader version, installer version and server name"
    exit 1
fi

# Check if the server already exists
if [ -d "$HOME/CreeperCommander/servers/$minecraftVersion-$serverName" ]; then
    echo "Server already exists with the same name and version"
    exit 1
fi

echo "Installing Minecraft server version $minecraftVersion with the name $serverName in $HOME/CreeperCommander/servers/$minecraftVersion-$serverName"
echo "Press Ctrl + C to stop the installation ..."
sleep 5
echo ""

# Create the minecraft user if not exists
if ! id "minecraft" &>/dev/null; then
    useradd -m -d /home/minecraft -s /bin/bash minecraft
fi

# Set up sudo permissions for the minecraft user
echo "minecraft ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/minecraft
echo "Defaults:minecraft !requiretty" >> /etc/sudoers.d/minecraft

# Create the server directory
serverDir="$HOME/CreeperCommander/servers/$minecraftVersion-$serverName"
mkdir -p "$serverDir"
cd "$serverDir" || exit 1

# Install the server
if [ "$modLoader" == "fabric" ]; then
    curl -OJ https://meta.fabricmc.net/v2/versions/loader/$minecraftVersion/$modLoaderVersion/1.0.1/server/jar  -O "installer.jar"
elif [ "$modLoader" == "forge" ]; then
    curl -OJ "https://maven.minecraftforge.net/net/minecraftforge/forge/$minecraftVersion-$modLoaderVersion/forge-$minecraftVersion-$modLoaderVersion-installer.jar" -O "installer.jar"
elif [ "modLoader" == "vanilla" ]; then
    curl -OJ "https://launcher.mojang.com/v1/objects/$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r ".versions[] | select(.id == \"$minecraftVersion\") | .url" | xargs curl -s | jq -r ".downloads.server.url")" -O "installer.jar"
else
    echo "Mod loader $modLoader is not supported"
    exit 1
fi

java -Xmx2G -jar installer.jar nogui
echo "eula=true" > eula.txt

# Create server properties
cat << EOF > server.properties
serverJar=server.jar
minecraftVersion=$minecraftVersion
serverName=$serverName-$minecraftVersion
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

# Clean up server jar
rm "installer.jar"

# Optional: Create service and start it (uncomment if needed)
# Create the service
# cat << EOF > minecraft-server-$minecraftVersion.service
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
# systemctl enable "$serverDir/minecraft-server-$minecraftVersion.service"
# systemctl start "minecraft-server-$minecraftVersion"

# Check if the server is running
# if systemctl is-active --quiet "minecraft-server-$minecraftVersion"; then
#     echo "Server is running"
# else
#     echo "Server failed to start"
# fi

exit 0