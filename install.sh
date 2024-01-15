#!/bin/bash

#colores
W="\e[0m"
N="\e[30;1m"
n="\e[30m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
P="\e[35m"
C="\e[36m"
L="\e[37;2m"

#resaltado
rW="\e[48m"
rN="\e[40;1m"
rG="\e[42m"
rY="\e[43m"
rB="\e[44m"
rP="\e[45m"
rC="\e[46m"
rL="\e[47m"

#subrayado
sW="\e[39m"
sN="\e[40;1m"
sG="\e[42m"
sY="\e[43m"
sB="\e[44m"
sP="\e[45m"
sC="\e[46m"
sL="\e[47m"

bol="${W}\033[1m"
cur="\033[3m"
sub="\033[4m"

#salidas/entradas
cent=$C
bord=$N
excr=$W

T="$bord [${cent}+${W}${bord}]$excr"
F="$bord [${cent}-${W}${bord}]$excr"

A="${W}$bord [${bol}${Y}!${W}${bord}]$excr"
E="${W}$bord [${bol}${R}✘${W}${bord}]$excr"
S="${W}$bord [${bol}${G}✓${W}${bord}]$excr"

I="$bord [${cent}\$${bord}]${cent}❯$excr"

#info
autor="${bol}$bord [${bol}${cent}𝙹𝚜𝚘𝚗 𝚂𝚎𝚌𝚞𝚛𝚒𝚝𝚢${bord}]"
script="${bol}$bord [${bol}${cent}𝙽𝚐𝚛𝚘𝚔 𝚏𝚘𝚛 𝚝𝚎𝚛𝚖𝚞𝚡${bord}]"

ruta_actual=pwd
ruta_root="kali-fs/root/"
carpeta="tunNgrok"

logo() {
	echo -e """$W
      ▄
     ███
    █████
    ██ ██    $autor$W
    █████    $script$W
   ███ ███
  █████████
  █▀     ▀█
			"""
}
requirements() {
	if [ $(command -v proot | wc -l) == "0" ];then
        printf "$F Instalando$bord proot\n"
        pkg install proot -y > /dev/null 2>&1
    fi
    if [ $(command -v wget | wc -l) == "0" ];then
        printf "$F Instalando$bord wget\n"
        pkg install wget -y > /dev/null 2>&1
    fi
    if [ $(command -v openssl | wc -l) == "0" ];then
        printf "$F Instalando$bord openssl-tool\n"
        pkg install openssl-tool -y > /dev/null 2>&1
    fi
    if [ $(command -v unzip | wc -l) == "0" ];then
        printf "$F Instalando$bord unzip\n"
        pkg install unzip -y > /dev/null 2>&1
    fi
    if [[ $(pwd) == "$HOME/$carpeta" ]];then
    	if [[ $(test -d 'kali-fs' && test -d 'kali-binds' && test -f 'start-kali.sh';echo $?) -eq 0 ]];then

    	   	echo -e "\n$S kali-fs"

			if [[ $(test -f "kali-fs/root/ngrok";echo $?) -eq 0 ]];then
				echo -e "$S ngrok"
			else
				echo -e "$E$G ngrok$W is not installed\n"
				install_ngrok
			fi
		else
			echo -e "$E$G kali-fs$W is not installed\n"
			install_kali
    	fi
    fi
}
install_kali() {
	printf  "$A Desea instalar$G kali-fs [${W}Y${G}/${W}N${G}]${W}:$G "
	read option

	if [[ $option == 'y' || $option == 'Y' ]];then	
		echo -e "\n$F Descargando..."
		wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Kali/kali.sh > /dev/null 2>&1
		echo -e "$F Instalando (2min a 3min)..."
		bash kali.sh > /dev/null 2>&1
		sleep .5
		requirements
	else
		exit 1
	fi
}

install_ngrok() {
	printf  "$A Desea instalar$G ngrok [${W}Y${G}/${W}N${G}]${W}:$G "
	read option

	if [[ $option == 'y' || $option == 'Y' ]];then	
		echo -e "\n$F Descargando ngrok..."
    	case `dpkg --print-architecture` in
        	aarch64)
            	architectureURL="arm64" ;;
       	 	arm)
 	           	architectureURL="arm" ;;
 	       	armhf)
 	           	architectureURL="arm" ;;
 	      	 amd64)
     	       	architectureURL="amd64" ;;
        	i*86)
	            architectureURL="386" ;;
        	x86_64)
            	architectureURL="amd64" ;;
        	*)
        	    echo "unknown or unsupported architecture"
		esac

    	wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-${architectureURL}.zip -O ngrok.zip >  /dev/null 2>&1
        # arm : https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
        # aarch46 : https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip
        # i368 : https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip
        # x86_64 : https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
    	unzip ngrok.zip > /dev/null 2>&1
    	rm ngrok.zip
    	mv ngrok ${ruta_root}
    else
    	exit 1
   	fi
}
config_ngrok() {
	if [[ $(test -f "${ruta_root}.ngrok2/ngrok.yml";echo $?) -eq 1 ]];then
		echo -e "\n$E Se requiere un token para$G ngrok.yml"
		echo -e "\n$F Cree una cuenta:$C dashboard.ngrok.com/signup"

		printf "$T Authtoken: "
		read token

		if [[ $(echo $token | wc -c ) > 15 ]];then
			mkdir "${ruta_root}.ngrok2"
			echo "authtoken: ${token}" > "${ruta_root}.ngrok2/ngrok.yml"

			echo -e "\n$S Instalado corretamente"	
			requirements
		else
			echo -e "$E error token"
			exit 1
		fi
	else
		echo -e "$S ngrok.yml"
		echo -e "\n$T$G ./ngrok.sh"
		exit 0
	fi
}

logo
requirements
config_ngrok
