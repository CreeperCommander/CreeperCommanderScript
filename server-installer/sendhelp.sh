# with colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e ""
echo -e "------------------------------------------------------------------- ${RED}Wrong usage !!!${NC} -------------------------------------------------------------------"
echo -e "${GREEN}Usage:${NC} $1 <minecraftVersion> <modLoader|vanilla> (modLoaderVersion) <installerVersion> <serverName>"
echo -e "${GREEN}Example:${NC} $1 1.16.5 fabric 0.11.6 1.0.1 myServer"
echo -e "${GREEN}Example:${NC} $1 1.16.5 vanilla 1.0.1 myServer"
