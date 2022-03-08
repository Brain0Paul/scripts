#!/bin/bash
###################################################### #
#                                                      #
# Installation automatique de Docker par Paul Pascual #
#                                                      #
########################################################

clear

# Désinstaller les anciennes versions de docker
apt-get remove docker docker-engine docker.io containerd runc

apt-get update

# Installer les dépendances
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  
apt-get update
    
#Installer docker    
apt-get -y install docker-ce docker-ce-cli containerd.io

#Installer docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

clear

echo ""
tput setaf 7; echo "-----------------------------------------------------------"
tput bold; tput setaf 7; echo "         => INSTALLATION DE DOCKER TERMINEE <="
tput setaf 7; echo ""
tput bold; tput setaf 6; echo "                By Paul Pascual               "
tput bold; tput setaf 6; echo "                Pascual.link                  "
tput setaf 7; echo "-----------------------------------------------------------"
tput setaf 2; echo ""
