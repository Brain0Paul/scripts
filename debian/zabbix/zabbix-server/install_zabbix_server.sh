#!/bin/bash
clear
# Principaux paramètres
tput setaf 7; read -p "Entrez le mot de passe pour la base de données Zabbix : " ZABBIX_DB_USER_PASSWORD
read -p "Entrez l'adresse ip du serveur : " SERVER_IP
#SERVER_IP=$(hostname -i)
tput setaf 2; echo ""

apt install -y apache2 php php-mysql php-mysqlnd php-ldap php-bcmath php-mbstring php-gd php-pdo php-xml libapache2-mod-php mariadb-server mariadb-client

tput setaf 7; echo "------------------------------------------------------------------"
tput bold; tput setaf 7; echo "         => INSTALLATION de ZABBIX-SERVER TERMINEE <="
tput setaf 7; echo ""
tput setaf 7; echo "   IP du serveur Zabbix : $SERVER_IP/zabbix                     "
tput setaf 7; echo "         ID : Admin / MDP : zabbix                              "
tput setaf 7; echo ""
tput bold; tput setaf 6; echo "                By Paul Pascual                      "
tput bold; tput setaf 6; echo "                Pascual.link                         "
tput setaf 7; echo "------------------------------------------------------------------"
tput setaf 2; echo ""
