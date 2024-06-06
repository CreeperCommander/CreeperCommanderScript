server=$1
if [ -z "$server" ]; then
    echo "You must specify the server name"
    exit 1
fi

if [ ! -d "$CreeperCommanderHome/servers/$server" ]; then
    echo "Server $server does not exist"
    exit 1
fi

newServerName=$2
if [ -z "$newServerName" ]; then
    echo "You must specify the new server name"
    exit 1
fi

serverVersion=$(echo "$server" | cut -d'-' -f1)
serverLoader=$(echo "$server" | cut -d'-' -f2)
newServerName="$serverVersion-$serverLoader-$newServerName"
if [ -d "$CreeperCommanderHome/servers/$newServerName" ]; then
    echo "Server $newServerName already exists"
    exit 1
fi

echo "Changing server name from $server to $newServerName"
mv "$CreeperCommanderHome/servers/$server" "$CreeperCommanderHome/servers/$newServerName"
echo "Server name changed successfully"