JAVA=""

# Install the java version required for the minecraft version 
# 1.0 - 1.7.x	Java 7
# 1.8.x	Java 8
# 1.9 - 1.12.x	Java 8
# 1.13.x	Java 8
# 1.14.x	Java 8
# 1.15.x	Java 8
# 1.16.x	Java 8 ou 11
# 1.17.x	Java 16
# 1.18.x	Java 17
# 1.19.x	Java 17
# 1.20.x	Java 17

minecraftVersionSecondPart=$(echo $1 | cut -d'.' -f2)
minecraftVersionSecondPart_int=$((minecraftVersionSecondPart))

if [ minecraftVersionSecondPart_int < 8 ]; 
then
    sudo add-apt-repository ppa:openjdk-r/ppa  
    JAVA="openjdk-7-jdk"
elif [ minecraftVersionSecondPart_int < 16 ]; 
then
    JAVA="openjdk-8-jdk"
elif [ minecraftVersionSecondPart_int == 16];
then
    JAVA="openjdk-11-jdk"
elif [ minecraftVersionSecondPart_int == 17];
then
    JAVA="openjdk-16-jdk"
else 
    JAVA="openjdk-17-jdk"
fi

echo "--------------------------------------------------------------------------------------------"
echo "Java version : $JAVA"
echo "--------------------------------------------------------------------------------------------"