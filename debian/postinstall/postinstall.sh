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
  


# Mise à jours des paquets
function Install-PaquetsEssentiels {
  apt update && apt upgrade -y
  apt install -y openssh-server
  apt install -y zsh
  apt install -y curl
  apt install -y vim
  apt install -y git
}


function Install-Zsh {
  tput setaf 2; chsh -s $(which zsh)

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch || {
    echo "Could not install Oh My Zsh" >/dev/stderr
    exit 1
  }

  locale-gen --purge fr_FR.UTF-8
  echo -e 'LANG="fr_FR.UTF-8"\nLANGUAGE="fr_FR.UTF-8"\n' > /etc/default/locale


  # Modification de zsh
  for file in ~/.zshrc
  do
    echo "Traitement de $file ..."
    sed -i -e "s/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=agnoster/g" "$file"
  done
}

function Update-db {
  updatedb
}

   
networks:
  proxy:
    external: true
  " > docker-compose.yml

  tput setaf 2; docker network create proxy
  docker-compose up -d
}

function Change-Password {
  tput setaf 6; echo "root:$password_root" | chpasswd
  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
  tput setaf 7; echo "                                => Mot de passe de Root a été changé.                               "
  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
  tput setaf 2; adduser --quiet --disabled-password --shell /bin/bash --home /home/$name_user --gecos "User" $name_user
  tput setaf 2; echo "$name_user:$password_user" | chpasswd
  tput setaf 2; adduser $name_user sudo
  tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
  tput bold; tput setaf 7; echo "                         => L'utilisateur $name_user a été créé.                         "
  tput bold; tput setaf 7; echo "                         => $name_user fait parti du groupe sudo.                        "
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

# Changement du motd
function Change-MOTD {
  ip_du_serveur=$(hostname -i)
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
install_traefik = "n"
clear
tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
tput setaf 7; echo "                                   Script d'installation de Debian                                  "
tput setaf 7; echo "----------------------------------------------------------------------------------------------------"

tput setaf 6; read -p "Souhaitez vous créer les utilisateurs ? (y/n)  " create_user
if [ $create_user = "y" ]
  then
    tput setaf 6; read -p "===>     Entrez le mot de passe pour Root : " password_root
    tput setaf 6; read -p "===>     Entrez un nom d'utilisateur : " name_user
    tput setaf 6; read -p "===>     Entrez le mot de passe pour l'utilisateur $name_user : " password_user
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
fi
echo ""

tput setaf 6; read -p "Souhaitez vous installer Docker ? (y/n)  " install_docker
if [ $install_docker = "y" ]
  then
  echo ""
  tput setaf 6; read -p "Souhaitez vous installer Traefik et Portainer ? (y/n)  " install_traefik
  if [ $install_traefik = "y" ]
    then
    tput setaf 6; read -p "===>     Entrez votre nom de domaine (ex : papamica.fr) : " ndd
    tput setaf 6; read -p "===>     Entrez votre adresse mail pour Let's Encrypt : " email
    echo ""
    while [ -z $redirection ] || [ $redirection != 'y' ]
    do
      tput setaf 3; echo "ATTENTION ! Veuillez faire les redirections suivantes :"
      tput setaf 3; echo "=> Traefik : traefik.$ndd => IP WAN de votre serveur !"
      tput setaf 3; echo "=> Portainer : portainer.$ndd => IP WAN de votre serveur !"
      echo ""
      tput setaf 3; read -p "Les redirections ont bien été configurées ? (y/n) " redirection
    done
  fi
fi
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


tput setaf 6; echo "Configuration des sources ................................................................. En cours"
Change-Source
tput setaf 7; echo "Configuration des sources ................................................................. OK"
echo ""

tput setaf 6; echo "Installation des paquets essentiels........................................................ En cours"
Install-PaquetsEssentiels
tput setaf 7; echo "Installation des paquets essentiels........................................................ OK"
echo ""

tput setaf 6; echo "Installation de ZSH........................................................................ En cours"
Install-Zsh
tput setaf 7; echo "Installation de ZSH........................................................................ OK"
echo ""

tput setaf 6; echo "Mise à jour de la base de données.......................................................... En cours"
Update-db
tput setaf 7; echo "Mise à jour de la base de données.......................................................... OK"

echo ""
echo ""
if [ $install_docker = "y" ]
  then
  tput setaf 6; echo "Installation de Docker..................................................................... En cours"
  Install-Docker
  tput setaf 7; echo "Installation de Docker..................................................................... OK"
fi

echo ""
echo ""
if [ $install_traefik = "y" ]
  then
  tput setaf 6; echo "Installation de Traefik et de Portainer.................................................... En cours"
  Install-TraefikPortainer
  tput setaf 7; echo "Installation de Traefik et de Portainer.................................................... OK"
fi

echo ""
echo ""
if [ $create_user = "y" ]
  then
  tput setaf 6; echo "Création des utilisateurs et changement des mots de passe.................................. En cours"
  Change-Password
  tput setaf 7; echo "Création des utilisateurs et changement des mots de passe.................................. OK"
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
if [ $change_motd = "y" ] 
  then
  tput setaf 6; echo "Changement du MOTD....................................................................... En cours"
  Change-MOTD
  tput setaf 7; echo "Changement du MOTD....................................................................... OK"
fi

echo ""
echo ""
if [ $install_traefik = "y" ]
  then
  echo ""
  echo ""
  tput bold; tput setaf 7; echo "LISTES DES CONTAINERS EN COURS : "
  tput setaf 3; echo ""
  docker container ls
fi

echo ""
echo ""
tput setaf 7; echo "----------------------------------------------------------------------------------------------------"
tput bold; tput setaf 7; echo "                               => PREPARATION TERMINEE <=                                "
tput setaf 7; echo ""
if [ $install_traefik = "y" ]
  then
  tput bold; tput setaf 7; echo "                               Portainer.$ndd                                          "
  tput bold; tput setaf 7; echo "                               Traefik.$ndd                                            "
  tput bold; tput setaf 7; echo "                          Identifiant Traefik : admin / admin                          "
  tput setaf 7; echo ""
fi
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
