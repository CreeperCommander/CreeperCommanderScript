#!/bin/bash

echo "Checking if required packages is installed..."
for i in "${packagesNeeded[@]}"
do
    CheckingPackageInstalled $i
    if [ $? -eq 0 ];
    then
        echo $i" is installed"
    else
        echo $i" is not installed"
           packagesWillBeInstalled+=($i);
    fi
done

