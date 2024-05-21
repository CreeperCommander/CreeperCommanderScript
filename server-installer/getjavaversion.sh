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

minecraftVersionThirdPart=$(echo $1 | cut -d'.' -f3)
minecraftVersionThirdPart_int=$((minecraftVersionThirdPart))


if (( $minecraftVersionSecondPart_int == 20 || $minecraftVersionThirdPart_int > 4));
then
    wget https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz;
    tar xvf openjdk-21.0.2_linux-x64_bin.tar.gz
    sudo mv jdk-21.0.2/ /usr/local/jdk-21

    export PATH=$(readlink -f ./jdk-21/bin):$PATH
    export JAVA_HOME=$(readlink -f .)
    
    source /etc/profile.d/jdk21.sh
elif (( $minecraftVersionSecondPart_int > 17 ));
then
    JAVA="openjdk-17-jdk";
elif (( $minecraftVersionSecondPart_int > 16 ));
then 
    JAVA="openjdk-16-jdk";
elif (( $2 == "vanilla" ))
then
    JAVA="openjdk-11-jdk";
else
    JAVA="openjdk-8-jdk";
fi


echo "-----------------------------------------------------------------"
echo "Java version : $JAVA"
echo "-----------------------------------------------------------------"
