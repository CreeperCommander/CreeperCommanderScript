minecraftServer=$1

if [ -z "$minecraftServer" ]; then
    echo "You must specify the server name"
    exit 1
fi

if [ ! -d "$CreeperCommanderHome/servers/$minecraftServer" ]; then
    echo "Server $minecraftServer does not exist"
    exit 1
fi

echo "Deleting server $minecraftServer"
rm -rf "$CreeperCommanderHome/servers/$minecraftServer"
echo "Server $minecraftServer deleted successfully"