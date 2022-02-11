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
