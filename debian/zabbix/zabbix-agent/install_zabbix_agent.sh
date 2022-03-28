#!/usr/bin/env bash

clear
apt install wget -y
wget https://cdn.zabbix.com/zabbix/binaries/stable/5.4/5.4.6/zabbix_agent-5.4.6-linux-4.12-ppc64le-static.tar.gz

tput bold; tput setaf 7; echo "------------------------------------------------------------"
tput bold; tput setaf 7; echo "             => INSTALLATION DE L'AGENT ZABBIX TERMINEE <="
tput setaf 7; echo ""
tput bold; tput setaf 6; echo "                By Paul Pascual                           "
tput bold; tput setaf 6; echo "                Pascual.link                              "
tput bold; tput setaf 7; echo "------------------------------------------------------------"
tput setaf 2; echo ""
