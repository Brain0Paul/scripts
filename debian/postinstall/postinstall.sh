#!/bin/bash
###################################################### #
#                                                      #
# Configuration automatique de Debian par Paul Pascual #
#                                                      #
########################################################


function Verif-System {
  user=$(whoami)

  if [ $(whoami) != "root" ]
    then
    tput setaf 5; echo "ERREUR : Veuillez exécuter le script en tant que Root !"
    exit
  fi

  if [[ $(arch) != *"64" ]]
    then
    tput setaf 5; echo "ERREUR : Veuillez installer une version x64 !"
    exit
  fi
  }
  
# Mise à jours des paquets
function Install-PaquetsEssentiels {
  apt update && apt upgrade -y
  apt install -y openssh-server
  apt install -y curl
  apt install -y vim
  apt install -y git
  apt install -y htop

function Change-Password {
  tput setaf 6; echo "root:$password_root"
  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
  tput setaf 7; echo "                                => Mot de passe de Root a été changé.                               "
  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
}

# Changement du port SSH
function Change-SSHPort {
  cp /etc/ssh/sshd_config /etc/ssh/sshd_config_backup

  for file in /etc/ssh/sshd_config
  do
    echo "Traitement de $file ..."
    sed -i -e "s/#Port 22/Port $ssh_port/" "$file"
  done  
  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
  tput setaf 7; echo "                                 => Port SSH remplacé par $ssh_port.                                "
  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"

}

# Désactivation PrintLastLog
function NoLastLog {

  for file in /etc/ssh/sshd_config
  do
    echo "Traitement de $file ..."
    sed -i -e "s/#PrintLastLog yes/PrintLastLog no/" "$file"
  done  
  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
  tput setaf 7; echo "                                 => Désactivation de PrintLastLog                                   "
  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"

}

# Changement du hostname
function Change-Hostname {
  cp /etc/hostname /etc/hostname_backup
  old_hostname=$(hostname)
  for file in /etc/hostname
  do
    echo "Traitement de $file ..."
    sed -i -e "s/$old_hostname/$hostname/" "$file"
  done  
}

function Change-Hosts {
  cp /etc/hosts /etc/hosts_backup
  for file in /etc/hosts
  do
    echo "Traitement de $file ..."
    sed -i -e "s/$old_hostname/$hostname/" "$file"
  done 
}

  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
  tput setaf 7; echo "                                 => $old_hostname remplacé par $hostname.                           "
  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"

}

# Changement du motd
function Change-MOTD {
  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
  tput bold; tput setaf 7; echo "                      => L'adresse IP du serveur est $ip_du_serveur.                     "
  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"

  echo "
  ██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗
  ██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝
  ██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗
  ██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝
  ╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗
   ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

               Server   : $name_server

               IP       : $ip_du_serveur

               Provider : $name_provider

  " > /etc/motd
  
}
#-----------------------------------------------------------------------------------------------------------------------------------
clear
tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
tput setaf 7; echo "                                   Script d'installation de Debian                                  "
tput setaf 7; echo "----------------------------------------------------------------------------------------------------"

tput setaf 6; read -p "Souhaitez vous changer le mot de passe root ? (y/n)  " change_root
if [ $change_root = "y" ]
  then
    tput setaf 6; read -p "===>     Entrez le mot de passe pour Root : " password_root
fi
echo ""

tput setaf 6; read -p "Souhaitez vous changer le hostname ? (y/n)  " change_hostname
if [ $change_hostname = "y" ]
  then
    tput setaf 6; read -p "===>     Entrez le nouveau hostname : " hostname
fi
echo ""

tput setaf 6; read -p "Souhaitez vous changer le port SSH ? (recommandé) (y/n)  " change_sshport
if [ $change_sshport = "y" ]
  then
    tput setaf 6; read -p "===>     Entrez port que vous souhaitez (ex : 2020) : " ssh_port
fi
echo ""

tput setaf 6; read -p "Souhaitez vous changer le MOTD ? (y/n)  " change_motd
if [ $change_motd = "y" ]
  then
  tput setaf 6; read -p "===>     Entrez le nom du serveur : " name_server
  tput setaf 6; read -p "===>     Entrez le nom de l'hébergeur : " name_provider
  tput setaf 6; read -p "===>     Entrez l'addresse ip du serveur : " ip_du_serveur
fi
echo ""

echo ""
tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
tput setaf 7; echo "                                           Début du script                                          "
tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
echo ""
echo ""


tput setaf 6; echo "Vérification du système ................................................................... En cours"
Verif-System
tput setaf 7; echo "Vérification du système ................................................................... OK"
echo ""

tput setaf 6; echo "Installation des paquets essentiels........................................................ En cours"
Install-PaquetsEssentiels
tput setaf 7; echo "Installation des paquets essentiels........................................................ OK"

echo ""
echo ""

if [ $change_root = "y" ]
  then
  tput setaf 6; echo "Changement du mot de passe root.......................................................... En cours"
  Change-Password
  tput setaf 7; echo "Changement du mot de passe root.......................................................... OK"
fi

echo ""
echo ""
if [ $change_sshport = "y" ]
  then
  tput setaf 6; echo "Changement du port SSH.................................................................... En cours"
  Change-SSHPort
  tput setaf 7; echo "Changement du port SSH.................................................................... OK"
fi

echo ""
echo ""
if [ $change_hostname = "y" ]
  then
  tput setaf 6; echo "Changement du hostname.................................................................... En cours"
  Change-Hostname
  Change-Hosts
  Change-Hosts
  tput setaf 7; echo "Changement du hostname.................................................................... OK"
fi

echo ""
echo ""
if [ $change_hostname = "y" ]
  then
  tput setaf 6; echo "Désactivation de PrintLastLog........................................................ En cours"
  NoLastLog
  tput setaf 7; echo "Désactivation de PrintLastLog.............................................................. OK"
fi

echo ""
echo ""
if [ $change_motd = "y" ] 
  then
  tput setaf 6; echo "Changement du MOTD....................................................................... En cours"
  Change-MOTD
  tput setaf 7; echo "Changement du MOTD....................................................................... OK"
fi

echo ""
echo ""
tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
tput bold; tput setaf 7; echo "                               => PREPARATION TERMINEE <=                                "
tput setaf 7; echo ""

tput bold; tput setaf 7; echo "                                Veuillez vous reconnecter                                "
if [ $change_sshport = "y" ]
  then
  tput bold; tput setaf 7; echo "                             Votre nouveau port SSH : $ssh_port                        "
fi
tput setaf 7; echo ""
tput bold; tput setaf 6; echo "                                       By Brain0Paul                                     "
tput bold; tput setaf 6; echo "                                        pascual.link                                     "
tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
tput setaf 2; echo ""

sleep 5
# Redémarrage du service sshd
service ssh restart
