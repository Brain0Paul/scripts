#!/bin/bash
clear

apt install -y apache2 php php-mysql php-mysqlnd php-ldap php-bcmath php-mbstring php-gd php-pdo php-xml libapache2-mod-php mariadb-server mariadb-client

wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-1+debian11_all.deb
dpkg -i zabbix-release_6.0-1+debian11_all.deb
apt update 

apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent 

tput setaf 7; echo "------------------------------------------------------------------"
tput bold; tput setaf 7; echo "         => INSTALLATION de ZABBIX-SERVER TERMINEE <="
tput setaf 7; echo ""
tput bold; tput setaf 6; echo "                By Paul Pascual                      "
tput bold; tput setaf 6; echo "                Pascual.link                         "
tput setaf 7; echo "------------------------------------------------------------------"
tput setaf 2; echo ""
