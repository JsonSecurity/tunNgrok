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
F="$bord [${Y}!${W}${bord}]$excr"

A="${W}$bord [${bol}${Y}!${W}${bord}]$excr"
E="${W}$bord [${bol}${R}✘${W}${bord}]$excr"
S="${W}$bord [${bol}${G}✓${W}${bord}]$excr"

I="$bord [${cent}\$${bord}]${cent}❯$excr"

#info
autor="${bol}$bord [${bol}${G}𝙹𝚜𝚘𝚗 𝚂𝚎𝚌𝚞𝚛𝚒𝚝𝚢${bord}]"
script="${bol}$bord [${bol}${G}𝙽𝚐𝚛𝚘𝚔 𝚏𝚘𝚛 𝚝𝚎𝚛𝚖𝚞𝚡${bord}]"

#importante para ejecutar
carpeta="tunNgrok"

#rutas obsolutas para ejecutar la herramienta desde cualquier parte
ruta_bash="$HOME/${carpeta}/kali-fs/root/.bashrc"
ruta_kali="$HOME/${carpeta}/./start-kali.sh"

logo() {
	echo -e """$N$L					    | |
	      ███████]▄▄▄▄▄▄▄▄   ⊙           ⊙|
	▂▄▅█████████▅▄▃▂                    | |
	I███████████████████].              | |
 ........◥⊙▲⊙▲⊙▲⊙▲⊙▲⊙▲⊙◤____________________| |$W"""
	echo -e "   $autor$script"
}

excecute_ngrok() {
	logo
	config_bashrc=$(cat $ruta_bash | grep ngrok)

	protc=$(echo $config_bashrc | awk '{print $2}')
	puert=$(echo $config_bashrc | awk '{print $3}')

	if [[ ! -n $protc ]] || [[ ! -n $puert ]];then
		help
		exit 1
	fi
	
	echo -e "\n$F Ejecutando$Y ->$W$C $protc$W:$C$puert"
	
	bash $ruta_kali > /dev/null 2>&1 &
	#echo -e "$Y ejecutando ngrok..."
	sleep 3

	cont=1
	while true;do
		tunel=$(curl -s -N http://127.0.0.1:4040/api/tunnels | tr ',' '\n' | grep public | tr '/|:|"' ' ')
		if [[ -n $tunel ]];then
			break
		else
			sleep 1
			let cont=cont+1

			if [[ $cont == 10 ]];then
				echo -e "$E error de conexion"
				exit 1
			fi
		fi
	done

	ip=$(echo $tunel | awk '{print $3}')
	port=$(echo $tunel | awk '{print $4}')

	echo -e "\n$S$G ngrok";sleep .3
	echo -e "$T ip:$G $ip";sleep .3
	echo -e "$T puerto:$G $port";sleep .3
	
	printf "\n"
	while true;do
		read salida
		echo -e "$Y CTRL + C to exit"
	done
	#ipt=$(curl -s -N http://127.0.0.1:4040/api/tunnels	
}
config_ngrok() {
	echo -e "\n$S Iniciando$G tun$W ngrok\n"
	protocolos_ngrok="http tcp tls"
	if [[ -n $puerto && -n $protocolo && -n $(echo $protocolos_ngrok | grep $protocolo) && $puerto =~ ^[0-9]+$ ]];then
		ip_local=$(ifconfig | grep inet | awk 'NR==3' | awk '{print $2}')
		echo -e "$S$G local";sleep .3
		echo -e "$T Protocolo:$G $protocolo";sleep .3
		echo -e "$T ip:$G $ip_local";sleep .3
		echo -e "$T Puerto:$G $puerto";sleep .3

		if [[ $(test -f $ruta_bash;echo $?) -eq 1 ]];then
			echo -e "$E$G ./install.sh"
			exit 1
		fi

		line_ngrok=$(cat $ruta_bash | grep "./ngrok")
		replace_ngrok="./ngrok $protocolo $puerto"
		if [[ $line_ngrok !=  $replace_ngrok ]];then
			if [[ -n $line_ngrok ]];then
				echo -e "\n$F Actualizando..."
				sed -i -e 's!'"$line_ngrok"'!'"$replace_ngrok"'!g' $ruta_bash
			else
				echo -e "\n$F configurando..."
				echo $replace_ngrok >> $ruta_bash
			fi
		fi
	else
		echo -e "$E Error de configuracion"
		exit 1
	fi
	
	excecute_ngrok
}
help(){
	echo -e """\n[!] Script tun ngrok 3.2 by [ Json Security ]
 
   [+] Execution:
	tun -e
				
   [+] Config:
	tun -s <protocolo> -p <puerto>
			""" | bat -pp -l java
}
if [[ ! $1 ]];then
	help
	exit 1
fi

clear

if [[ $(test -f $ruta_bash;echo $?) -eq 1 ]];then
	echo -e "\n$E No se detectaron archivos necesarios\n\n$A Ejecute:$G ./install.sh"
	exit 1
fi

while getopts :s:p:,e arg;do
	case $arg in
		e) excecute_ngrok;;
		s) protocolo=$OPTARG;;
		p) puerto=$OPTARG;config_ngrok;;
		*) help;;
	esac
done

