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
packagesNeeded=(curl git node)
packagesWillBeInstalled=()
nodeIsInstalled=false

source $workingDir/DetectPackageManager.sh
echo "Your package manager is $PACKAGEMANAGER"
cd $HOME

source $workingDir/CheckingPackageInstall.sh

if [ "${#packagesWillBeInstalled[@]}" -eq 0 ];
then
    echo "All required packages are installed"
else
    if [ "$nodeIsInstalled" = false ];
    then
        echo "Node is not installed"
    fi
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

if [ "$nodeIsInstalled" = false ];
then
    echo "Node is not installed"
    echo "Installing Node..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    source ~/.bashrc
    nvm install v20.11.1
    nvm use v20.11.1
fi


git clone https://github.com/CreeperCommander/CreeperCommanderWebsite
cd $HOME/CreeperCommanderWebsite
npm install

echo "Installation of CreeperCommander completed"