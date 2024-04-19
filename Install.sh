#!/bin/sh


function CheckingPackageInstalled() {
    if [ -x "$(command -v $1)" ];
    then
        return 0
    else
        return 1
    fi
}

workingDir=$(pwd)
installDir=$workingDir/Install
packagesNeeded=(git docker docker-compose)
packagesWillBeInstalled=()

source $installDir/DetectPackageManager.sh
echo "Your package manager is $PACKAGEMANAGER"

source $installDir/CheckingPackageInstall.sh

if [ "${#packagesWillBeInstalled[@]}" -eq 0 ];
then
    echo "All required packages are installed"
else

    echo 'We will install this packages :' "${packagesWillBeInstalled[@]}"
    read -p "Do you want to install this packages? (Y/n)" -n 1 -r
    if [ "$REPLY" = "" ];
    then
        REPLY="Y"
    fi
    if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ];
    then
        echo "Installing packages..."
        sudo $PACKAGEMANAGER install -y ${packagesWillBeInstalled[@]}
        
    else
        echo "Installation is canceled">&2;
    fi
fi

if [ -d /CreeperCommander ];
then
    echo "CreeperCommander is already installed in /CreeperCommander, if you want to reinstall CreeperCommander, please remove /CreeperCommander"
    exit 1
fi

sudo mkdir /CreeperCommander
sudo chmod -R 777 /CreeperCommander
sudo chown -R $USER:$USER /CreeperCommander
cd /CreeperCommander
mkdir servers
git clone https://github.com/CreeperCommander/CreeperCommanderWebsite
cd /CreeperCommander/CreeperCommanderWebsite

# TODO: Create and fill DockerFile and DockerCompose

if [ $CREEPER_COMMANDER_DIR ];
then
    echo "CREEPER_COMMANDER_DIR is already set"
else
    if [ -f $HOME/.bashrc ];
    then
        echo "export CREEPER_COMMANDER_DIR=/CreeperCommander" >> $HOME/.bashrc
    else
        echo "export CREEPER_COMMANDER_DIR=/CreeperCommander" >> $HOME/.bash_profile
    fi
fi
echo "If you use another shell, please set CREEPER_COMMANDER_DIR to /CreeperCommander in your shell configuration file (ie: .bashrc, .zshrc)"

read -p "Do you want to the app start automatically at boot ? (Y/n)" -n 1 -r
if [ "$REPLY" = "" ];
then
    REPLY="Y"
fi
if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ];
then
  cd $CREEPER_COMMANDER_DIR
  sudo docker run hello-world
else
    echo "You will need to start it manually with : sudo docker run albanagisa/creeper_commander"
fi
source $HOME/.bashrc

echo "Installation of CreeperCommander completed"