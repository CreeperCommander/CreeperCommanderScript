#!/bin/bash

PACKAGEMANAGER=""
if [ -x "$(command -v apk)" ];
then
    PACKAGEMANAGER="apk"
elif [ -x "$(command -v apt-get)" ];
then
    PACKAGEMANAGER="apt"
elif [ -x "$(command -v dnf)" ];
then
    PACKAGEMANAGER="dnf"
elif [ -x "$(command -v zypper)" ];
then
    PACKAGEMANAGER="zypper"
elif [ -x "$(command -v pacman)" ];
then
    PACKAGEMANAGER="pacman"
else
    echo "Package manager not found.">&2;
    exit 1
fi