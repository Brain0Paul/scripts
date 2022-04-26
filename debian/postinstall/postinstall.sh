
#!/bin/bash
#######################################################
#                                                     #
# Configuration automatique de Debian par Brain0Paul  #
#                                                     #
#######################################################


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
}

# Changement du motd
function change-MOTD {
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

tput setaf 6; read -p "Souhaitez vous changer le MOTD ? (y/n)  " change_motd
if [ $change_motd = "y" ]
  then
  tput setaf 6; read -p "===>     Entrez le nom du serveur : " name_server
  tput setaf 6; read -p "===>     Entrez le nom de l'hébergeur : " name_provider
fi
echo ""
