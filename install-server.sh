# Check if the script is run as root
if [ "$EUID" -ne 0 ];
then
    echo "You must run this script as root"
    exit 1
fi

# Check if the server version is specified
if [ "$#" -ne 1 ];
then
    echo "Usage: $0 <server version>"
    exit 1
fi

# Get the server version
serverVersion=$1

# Get the server name
shift
serverName=$@

# Check if the server is already installed
if [ -d "$HOME/CreeperCommander/servers/$serverVersion-$serverName" ];
then
    echo "Server is already exists with the same name and version"
    exit 1
fi

# Create the minecraft user
sudo adduser minecraft

su - minecraft

# Install the server
mkdir $HOME/CreeperCommander/servers/$serverVersion-$serverName -p
cd $HOME/CreeperCommander/servers/$serverVersion-$serverName
wget https://serverjars.com/api/fetchJar/minecraft/$serverVersion -O $HOME/CreeperCommander/servers/$serverVersion-$serverName/server.jar

# Ask the user to agree to the EULA
read -p "Do you agree to the Minecraft EULA? (Y/n)" -n 1 -r
if [ "$REPLY" = "" ];
then
    REPLY="Y"
fi
if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ];
then
    echo "eula=true" > eula.txt
else
    echo "You must agree to the Minecraft EULA to continue"
    exit 1
fi

java -Xmx1024M -Xms512M -jar server.jar nogui
chmod +x start.sh

rm $HOME/CreeperCommander/servers/$serverVersion-$serverName/server.jar


# echo "serverJar=server.jar
# serverVersion=$serverVersion
# serverName=minecraft-server-$serverVersion
# serverPort=25565
# serverIp=localhost
# serverMaxPlayers=20
# serverMotd=Welcome to the server
# serverDifficulty=easy
# serverGamemode=survival
# serverWorld=world
# serverSeed=
# serverSpawnProtection=16
# serverViewDistance=10" >> server.properties

# # Create the service
# echo "[Unit]" > minecraft-server-$serverVersion.service
# echo "Description=Minecraft Server
# After=network.target

# [Service]
# Type=simple
# User=$USER
# WorkingDirectory=$HOME/minecraft-server-$serverVersion
# ExecStart=$HOME/minecraft-server-$serverVersion/start.sh
# Restart=on-failure

# [Install]
# WantedBy=multi-user.target" >> minecraft-server-$serverVersion.service

# # Create the start script
# echo "#!/bin/bash" > start.sh
# echo "java -Xms1G -Xmx1G -jar server.jar" >> start.sh

# Move the files to the server directory

# # Enable the service
# systemctl enable $HOME/CreeperCommander/servers/$serverVersion-$serverName/minecraft-server-$serverVersion.service

# # Start the service
# systemctl start minecraft-server-$serverVersion

# # Check if the server is running
# if [ "$(systemctl is-active minecraft-server-$serverVersion)" = "active" ];
# then
#     echo "Server is running"
# else
#     echo "Server failed to start"
# fi

# Delete the temporary files
