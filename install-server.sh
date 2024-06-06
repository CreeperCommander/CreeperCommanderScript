#!/bin/sh

# Check if the script is run as root

# Check if the required arguments are provided
# shellcheck disable=SC2068
echo "$@";
echo "$#";
if [ "$#" -lt "3" ]; then
    echo "Parametre: "
    echo "[]: optional, <>: required"
    echo "Usage: $0 <minecraftVersion> <modLoader> <serverName> [modLoaderVersion]"
    exit 1
fi

minecraftVersion="$1"
modLoader="$2"
serverName="$3"

if [ "$#" -eq "4" ]; then
    modLoaderVersion="$4"
fi
if [ -z "$serverName" ]; then
    echo "You must specify the minecraft version, mod loader, mod loader version, installer version and server name"
    exit 1
fi
if [ -d "$HOME/CreeperCommander/servers/$minecraftVersion-$serverName" ]; then
    echo "Server already exists with the same name and version"
    exit 1
fi
echo "Installing Minecraft server version $minecraftVersion with the name $serverName in $CreeperCommanderHome/servers/$minecraftVersion-$serverName"
serverDir="$CreeperCommanderHome/servers/$minecraftVersion-$serverName"
mkdir -p "$serverDir"
cd "$serverDir" || exit 1
echo "Mod Loader : $modLoader"
# Install the server
if [ "$modLoader" = "fabric" ]; then
    wget https://meta.fabricmc.net/v2/versions/loader/"$minecraftVersion"/"$modLoaderVersion"/1.0.1/server/jar  -O "installer.jar"
elif [ "$modLoader" = "forge" ]; then
    wget "https://maven.minecraftforge.net/net/minecraftforge/forge/$minecraftVersion-$modLoaderVersion/forge-$minecraftVersion-$modLoaderVersion-installer.jar" -O "installer.jar"
elif [ "$modLoader" = "vanilla" ]; then
    wget "$(curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r ".versions[] | select(.id == \"$minecraftVersion\") | .url" | xargs curl -s | jq -r ".downloads.server.url")" -O "installer.jar"
else
    echo "Mod loader $modLoader is not supported"
    exit 1
fi
java -Xmx2G -jar installer.jar nogui
echo "eula=true" > eula.txt
mv installer.jar start.jar
echo "Server installed successfully"
exit 0