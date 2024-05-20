#!/bin/bash

# Auteur : Arnold Edwin / H@ckthu$
# Date  : 22 Novembre 2023
# Version : 0.1
# Lisence : GPL
# Description : Script de gestion du Trafic réseau 
#


# Déclaration des Variables Globales

Banner=$(more ascci.txt)

Hostname=$(hostname)
var_date=$(date) 

#Options=$1
Options=$@
Rapport_file="rapport.${Hostname}.txt"


clear


if [[ $Options == "--help" ]] ; then
   less help.txt
   exit
fi


if [[  $Options == "--rapport" ]] ; then
	exec > >(tee ${Rapport_file})
fi


# Déclaration des Fonctions




# Fonction de Présentation 

function Presentation ()
{
	cat ascci.txt
#	echo "Create by Hackthus"
}


# Fonction pour la séparation

function Separation ()
{

	echo "[#]======================================================[#]"
	#echo ""
}

# & apt install iptables ------> Pour metre le systeme à jour et installer iptables
function UpdateSystem ()

{
	sudo apt-get update ; apt install iptables -y
}

function espacement () # ---> pour créer un espace
{
	echo ""
}

# Fonction pour démarrer le service iptables

function var_dema_iptables ()

{
	sudo systemctl start iptables & sudo servce iptables start 

}

# PROGRAMME PRINCIALE

# APPEL DES FONCTIONS

#UpdateSystem


#Presentation
echo  "$Banner" 
#echo "Create by Hackthus"
#echo ""
#echo "           Date : $var_date                               "
#echo""

#echo "[+]             BIENVENUE SUR PAQUETFILTER             [+]"
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

#espacement
Separation


#echo " _________________________________________________________"
#echo "|                                                         |"
#echo "|                        OPTIONS                          |"
#echo "|_________________________________________________________|"

espacement

#echo "Veillez choisr une option:"
read -p "Veillez choisr une option: " option

espacement

if [ $option -eq "1" ] ; then
    read -p "Entrer Le Port: " port
elif [ $option -eq "2" ] ; then
	read -p "Entrer L'Adresse Cible: " ip
elif [ $option -eq "3" ] ; then
	read -p "Entrer L'Adresse Réseau Cible: " reseau
elif [ $option -eq "4" ] ; then
	read -p "Entrer L'Adresse IP: " ip_socket
	read -p "Entrer Le Port: " port_socket
elif [ $option -eq "5" ] ; then
	read -p "Entrer Le Site Web: " site
elif [ $option -eq "6" ] ; then
	read -p "Entrer L'Interface: " interface
	#statements
else
    echo "Vous devez choisir une option !!"
 #   sleep 2
  #  exit
fi


espacement
#Separation


echo " _________________________________________________________"
echo "|                                                         |"
echo "|                       PROTOCOLES                        |"
echo "|_________________________________________________________|"

espacement
Separation

echo "[1] Tcp "
echo "[2] Udp "
echo "[3] Icmp "
#echo "[4] Http "
#espacement

Separation
espacement

#echo "Veillez choisir un Protocole:"
read -p "Veillez choisir un Protocole: " protocole
echo ""

if [ $protocole -eq "1" ] ; then
    echo "Protocole utilisé: Tcp "
    protocole="tcp"
elif [ $protocole -eq "2" ] ; then 
	echo "Protocole utilisé: Udp "
	protocole="udp"
elif [ $protocole -eq "3" ] ; then 
	echo "Protocole utilisé: Icmp"
	protocole="icmp"
elif [ $protocole -eq "4" ] ; then
	echo "Protocole utilisé: Http"
	protocole="http"
else
	echo "vous devez choisi un Protocole "
fi

espacement
#Separation


echo " _________________________________________________________"
echo "|                                                         |"
echo "|                     SENS DU TRAFIC                      |"
echo "|_________________________________________________________|"

espacement
Separation

echo "[1] Trafic Entrant "
echo "[2] Trafic Sortant "
#espacement
Separation
espacement

#echo "Veillez choisir le Sens du Trafic:"
read -p "Veillez choisir le Sens du Trafic: " sens
echo ""

if [ $sens -eq "1" ] ; then
	sens="INPUT"
    echo "Sens du Trafic: Trafic entrant "
elif [ $sens -eq "2" ] ; then 
	sens="OUTPUT"
	echo "Sens du Trafic: Trafic sortant "
else
	echo "vous devez choisir un le sens du Trafic "
fi

espacement
#Separation

echo " _________________________________________________________"
echo "|                                                         |"
echo "|                        ACTIONS                          |"
echo "|_________________________________________________________|"

espacement
Separation

echo "[1] Bloquer Le Trafic "
echo "[2] Autoriser Le trafic "
#espacement
Separation
espacement

#echo "Veillez choisir une action à éffectuer:"
read -p "Veillez choisir une action à éffectuer: " action
espacement


if [ $action -eq "1" ] ; then
    echo "Action: Bloquage du Trafic "
elif [ $action -eq "2" ] ; then 
	echo "Action: Autorisation du Trafic "
else
	echo "Vous devez choisir une action à réaliser !!"
fi


# Traitement Des Opérations 

# Au Niveau des adresse ip

if [ $option -eq "2" ] && [ $action -eq "1" ] ; then # Bloquer le trafic entrant 
	sudo iptables -A $sens -s $ip -j DROP 
	echo "Le Trafic en $sens venant de l'Adresse ip: $ip à été Bloquer !!"
elif  [ $option -eq "2" ] && [ $action -eq "2" ]; then # Autoriser le trafic entrant
	sudo iptables -D $sens -s $ip -j DROP
	echo "Le Trafic en $sens venant de l'Adresse ip: $ip à été Autoriser !!" 
	#statements
#else
#	echo ""
fi


# REGLES AU NIVEAU DES PORTS

# Bloquage des Ports 

if [ $option -eq "1" ]  && [ $action -eq "1" ] ; then # pour bloquer un port tcp en entré
	sudo iptables -A $sens -p $protocole --dport $port -j DROP 
	echo "Trafic en $sens vers le port: $port à été Bloquer !!"
elif  [ $option -eq "1" ] && [ $action -eq "1" ] ; then # Pour Bloquer un port udp en entré
	sudo iptables -A $sens -p $protocole --dport $port -j DROP 
	echo "Trafic en $sens vers le port: $port à été Bloquer !!" 
#else
#	echo ""
fi

# Autorisation des port 

if [ $option -eq "1" ]  && [ $action -eq "2" ] ; then # pour AUTORISER un port tcp en entré
	sudo iptables -D $sens -p $protocole --dport $port -j DROP
	sudo iptables -I $sens -p $protocole --dport $port -j ACCEPT
	echo "Trafic $sens vers le port: $port à été Autoriser !!"
elif  [ $option -eq "1" ] && [ $action -eq "2" ] ; then # Pour Autoriser un port udp en entré
	sudo iptables -I $sens -p $protocole --dport $port -j ACCEPT
	echo "Trafic $sens vers le port: $port à été Autoriser !!" 
#else
#	echo ""
fi


# REGLES AU NIVEAU DE LA SOCKET

if [ $option -eq "4" ]  && [ $action -eq "1" ] ; then
	sudo iptables -A $sens -p $protocole --dport $port_socket -j DROP  # Pour Bloquer la socket
	echo "Le trafic $sens sur la socket: $ip_socket:$port_socket à été Bloquer avec succès"
elif [ $option -eq "4" ]  && [ $action -eq "2" ] ; then
	sudo iptables -I $sens -s $ip_socket -p $protocole --dport $port_socket -j ACCEPT # Pour autoriser la socket
#	sudo iptables -A $sens -p $protocole --dport $port_socket -j DROP # Pour efface la regle de bloquage 
	echo "Le trafic $sens sur la socket: $ip_socket:$port_socket à été Autoriser avec succès"
#else
	#echo ""	 
fi


# REGLE AU NIVEAU DES SITES WEB

if [ $option -eq "5" ] && [ $action -eq "1" ] ; then
	sudo iptables -I $sens -d $site -p $protocole --match multiport --dports 443,80 -j DROP # pour Bloquer un site
	echo "Le Trafic en $sens sur le Site: $site à été bloquer avec succès"
elif [ $option -eq "5" ] && [ $action -eq "2" ] ; then
#	sudo iptables -I $sens -d $site -p $protocole --match multiport --dports 443,80 -j ACCEPT
	sudo iptables -D $sens -d $site -p $protocole --match multiport --dports 443,80 -j DROP # pour Accepter un site bloquer
	echo "Le Trafic $sens sur le Site: $site à été Autoriser avec succès"
else 
	echo""
fi

# REGLE POUR ICMP

if [ $option -eq "6" ] && [ $action -eq "1" ] ; then 
	sudo iptables -A $sens -p $protocole -i $interface -j DROP # Pour Bloquer Icmp
	echo "Le protocole $protocole à été Bloquer en $sens sur L'Interface: $interface "
	#sudo iptables -A INPUT -p icmp -i eth0 -j DROP   
elif [ $option -eq "6" ] && [ $action -eq "2" ] ; then 
	sudo iptables -D $sens -p $protocole -i $interface -j DROP # Pour Autoriser Icmp
	echo "Le protocole $protocole à été Autoriser en $sens sur L'Interface: $interface "
#else
	#echo ""
fi





echo "========================================================"
espacement
echo "           Opération Terminé  !!         "
espacement
echo "Pour tout problème rencontrer Veillez signalé à l'addresse suivante: Email: hackthus@gmail.com "
echo "Merci"




#if [ $Option -eq "--rapport" ] ; then
#	exec > >(tee $apport_file)
#fi

#function Choisir()
#{
 #   case $var in 
  #      1) read -p " Entrer le port : " port
   #     2) vi $File;;
    #    3)subl $File;;
     #   *) echo "Désolé vous devez choisir un Editeur";;   
    #esac
#}
#Choisir

