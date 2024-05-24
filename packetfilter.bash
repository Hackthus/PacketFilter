#!/bin/bash

# Auteur : Arnold Edwin / H@ckthu$
# Date  : 22 Novembre 2023
# Version : 0.1
# Licence : GPL
# Description : Script de gestion du Trafic réseau

# Déclaration des Variables Globales
Banner="
   ____            _        _   _____ _ _ _            
  |  _ \ __ _  ___| | _____| |_|  ___(_) | |_ ___ _ __ 
  | |_) / _\` |/ __| |/ / _ \ __| |_  | | | __/ _ \ '__|
  |  __/ (_| | (__|   <  __/ |_|  _| | | | ||  __/ |   
  |_|   \__,_|\___|_|\_\___|\__|_|   |_|_|\__\___|_| 

    
  License GPL   Version: 0.1   Email: hackthus@gmail.com  
                                                     
           Create By Arnold Edwin / H@ckthus
"
HelpMenu="
 OPTIONS :
 
 --help               * Pour afficher le menu d'aide
 --rapport            * Pour générer un rapport 
   Port               * pour traiter des opérations sur un ou plusieurs ports spécifiques
                         Ex : 22  ou 22,80 
   IP                 * Pour traiter des opérations sur des adresses IP <xxxx.xxxx.xxxx.xxxx> ou nom de domaine <xxxx.com>
                         Ex : 192.168.x.x  ou hackthus.local
  Réseau              * Pour traiter du trafic au niveau du réseau 
                         Ex: 192.168.x.x où 192.168.0.0/24
  Site Web            * Pour traiter du trafic au niveau des sites web
                         Ex: www.google.com
  Icmp                * Pour les traitements au niveau du protocole ICMP
  /<mot>              * Pour rechercher un mot précis 
  q où :q             * Pour quitter le menu d'aide
"

Hostname=$(hostname)
var_date=$(date) 
Options=$@
Rapport_file="rapport.${Hostname}.txt"

clear

# Afficher l'aide
if [[ $Options == "--help" ]] ; then
   echo "$HelpMenu"
   exit
fi

# Générer un rapport
if [[  $Options == "--rapport" ]] ; then
	exec > >(tee ${Rapport_file})
fi

# Fonctions Déclarées
 
function Separation () {
	echo "[#]======================================================[#]"
}

# Mise à jour du système et installation d'iptables
function UpdateSystem () {
	sudo apt-get update && sudo apt-get install iptables -y
}
 
function espacement () {
	echo ""
}

# Fonction pour démarrer le service iptables
function var_dema_iptables () {
	sudo systemctl start iptables && sudo service iptables start
}

# Fonction de validation des entrées numériques
function validate_number () {
	if ! [[ $1 =~ ^[0-9]+$ ]]; then
		echo "Erreur: '$1' n'est pas un nombre valide."
		exit 1
	fi
}

# Fonction de validation des adresses IP
function validate_ip () {
	if ! [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		echo "Erreur: '$1' n'est pas une adresse IP valide."
		exit 1
	fi
}

# Fonction principale
function main () {
	echo "$Banner" 
	espacement
	echo "[*]       Date: $var_date           [*]"

	echo " _________________________________________________________"
	echo "|                                                         |"
	echo "|                   OPTIONS DISPONIBLES                   |"
	echo "|_________________________________________________________|"

	espacement
	Separation

	echo "[1] Port "
	echo "[2] Adresse IP ou Nom de domaine "
	echo "[3] Réseau "
	echo "[4] socket "
	echo "[5] Site Web "
	echo "[6] Icmp "

	Separation
	espacement

	read -p "Veillez choisir une option: " option
	espacement

	validate_number $option

	case $option in
		1)
			read -p "Entrer Le Port: " port
			validate_number $port
			;;
		2)
			read -p "Entrer L'Adresse Cible: " ip
			validate_ip $ip
			;;
		3)
			read -p "Entrer L'Adresse Réseau Cible: " reseau
			validate_ip $reseau
			;;
		4)
			read -p "Entrer L'Adresse IP: " ip_socket
			validate_ip $ip_socket
			read -p "Entrer Le Port: " port_socket
			validate_number $port_socket
			;;
		5)
			read -p "Entrer Le Site Web: " site
			;;
		6)
			read -p "Entrer L'Interface: " interface
			;;
		*)
			echo "Vous devez choisir une option valide !!"
			exit 1
			;;
	esac

	espacement
	Separation

	echo " _________________________________________________________"
	echo "|                                                         |"
	echo "|                       PROTOCOLES                        |"
	echo "|_________________________________________________________|"

	espacement
	Separation

	echo "[1] Tcp "
	echo "[2] Udp "
	echo "[3] Icmp "

	Separation
	espacement

	read -p "Veillez choisir un Protocole: " protocole
	espacement

	validate_number $protocole

	case $protocole in
		1)
			protocole="tcp"
			;;
		2)
			protocole="udp"
			;;
		3)
			protocole="icmp"
			;;
		*)
			echo "Vous devez choisir un protocole valide !!"
			exit 1
			;;
	esac

	Separation

	echo " _________________________________________________________"
	echo "|                                                         |"
	echo "|                     SENS DU TRAFIC                      |"
	echo "|_________________________________________________________|"

	espacement
	Separation

	echo "[1] Trafic Entrant "
	echo "[2] Trafic Sortant "

	Separation
	espacement

	read -p "Veillez choisir le Sens du Trafic: " sens
	espacement

	validate_number $sens

	case $sens in
		1)
			sens="INPUT"
			;;
		2)
			sens="OUTPUT"
			;;
		*)
			echo "Vous devez choisir un sens du trafic valide !!"
			exit 1
			;;
	esac

	Separation

	echo " _________________________________________________________"
	echo "|                                                         |"
	echo "|                        ACTIONS                          |"
	echo "|_________________________________________________________|"

	espacement
	Separation

	echo "[1] Bloquer Le Trafic "
	echo "[2] Autoriser Le trafic "

	Separation
	espacement

	read -p "Veillez choisir une action à éffectuer: " action
	espacement

	validate_number $action

	case $action in
		1)
			action="DROP"
			;;
		2)
			action="ACCEPT"
			;;
		*)
			echo "Vous devez choisir une action valide !!"
			exit 1
			;;
	esac

	# Traitement des opérations en fonction des choix

	if [ $option -eq 1 ]; then
		sudo iptables -A $sens -p $protocole --dport $port -j $action
		echo "Trafic $sens sur le port $port a été $action."
	elif [ $option -eq 2 ]; then
		sudo iptables -A $sens -s $ip -j $action
		echo "Trafic $sens de l'adresse IP $ip a été $action."
	elif [ $option -eq 3 ]; then
		sudo iptables -A $sens -s $reseau -j $action
		echo "Trafic $sens du réseau $reseau a été $action."
	elif [ $option -eq 4 ]; then
		sudo iptables -A $sens -s $ip_socket -p $protocole --dport $port_socket -j $action
		echo "Trafic $sens sur la socket $ip_socket:$port_socket a été $action."
	elif [ $option -eq 5 ]; then
		sudo iptables -A $sens -d $site -p $protocole --dport 80 -j $action
		sudo iptables -A $sens -d $site -p $protocole --dport 443 -j $action
		echo "Trafic $sens vers le site $site a été $action."
	elif [ $option -eq 6 ]; then
		sudo iptables -A $sens -p $protocole -i $interface -j $action
		echo "Trafic $sens sur l'interface $interface a été $action."
	fi

	espacement
	echo "========================================================"
	espacement
	echo "           Opération Terminée !!         "
	espacement
	echo "Pour tout problème rencontré, veuillez signaler à l'adresse suivante : Email: hackthus@gmail.com "
	echo "Merci"
}

 
main
