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
cent=$Y
bord=$N
excr=$W

T="$bord [${cent}+${W}${bord}]$excr"
F="$bord [${cent}...${W}${bord}]$excr"

A="${W}$bord [${bol}${Y}!${W}${bord}]$excr"
E="${W}$bord [${bol}${R}✘${W}${bord}]$excr"
S="${W}$bord [${bol}${G}✓${W}${bord}]$excr"

I="$bord [${cent}\$${bord}]${cent}❯$excr"

YN="$bord[${cent}Y${bord}/${cent}N${bord}]${excr}"
#info
autor="${bol}$bord [${bol}${cent}𝙹𝚜𝚘𝚗 𝚂𝚎𝚌𝚞𝚛𝚒𝚝𝚢${bord}]"
script="${bol}$bord [${bol}${cent}𝚃𝚞𝚗 𝙽𝚐𝚛𝚘𝚔${bord}]"

ruta_actual=pwd
ruta_root="kali-fs/root/"
carpeta="tunNgrok"

logo() {
        echo -e """$cent
      ▄
     ███
    █████
    ██ ██    $autor$cent
    █████    $script$cent
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

                        if [[ $(test -f "kali-fs/root/ngrok";echo $?) -eq 0 ]];then
                                #echo -e "$S ngrok"

                                if [[ $(ls "$HOME/.zshrc" 2>/dev/null) ]] && [[ $(cat "$HOME/.zshrc" | grep tun > /dev/null 2>&1;echo $?) -eq 1 ]];then
                                        printf "$A Shell$bol$Y =$W .zshrc\n"
                                        echo "alias tun='bash /data/data/com.termux/files/home/$carpeta/ngrok.sh'" >> "$HOME/.zshrc"
                                        printf "$S Reinicia tu terminal y ejecuta$G tun\n"

                                elif [[ $(ls "$HOME/.bashrc" 2>/dev/null) ]] && [[ $(cat "$HOME/.bashrc" | grep tun > /dev/null 2>&1;echo $?) -eq 1 ]];then
                                        printf "$S Shell$bol$Y =$W .bashrc\n"
                                        echo "alias tun='bash /data/data/com.termux/files/home/$carpeta/ngrok.sh'" >> "$HOME/.bashrc"
                                        printf "$S Reinicia tu terminal y ejecuta$G tun\n"
                                fi
                        else
                                install_ngrok
                        fi
                else
                        install_kali
        fi
    fi
}
install_kali() {
        printf  "$A Instalar$G kali-fs $YN:$bol$Y  "
        read option

        if [[ $option == 'y' || $option == 'Y' ]];then
                wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Kali/kali.sh > /dev/null 2>&1

                printf "\n$F Instalando "
                bash kali.sh > /dev/null 2>&1

                printf "$S Instalado\n"

                requirements
        else
                exit 1
        fi
}

install_ngrok() {
        printf  "\n$A Instalar$G ngrok $YN:$Y "
        read option

        if [[ $option == 'y' || $option == 'Y' ]];then
                printf "\n$F Instalando "
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

        printf "$S Instalado\n"
    else
        exit 1
        fi
}
config_ngrok() {
        if [[ $(test -f "${ruta_root}.ngrok2/ngrok.yml";echo $?) -eq 1 ]];then
                echo -e "\n$A Sitio oficial:$C dashboard.ngrok.com/signup"

                printf "$T Authtoken:$bol$Y "
                read token
                if [[ $(echo $token | wc -c ) > 15 ]];then
                        mkdir "${ruta_root}.ngrok2"
                        echo "authtoken: ${token}" > "${ruta_root}.ngrok2/ngrok.yml"

                        echo -e "\n$S Instalado\n"
                        requirements
                else
                        echo -e "\n$E Error token"
                        exit 1
                fi
        else
                echo -e "\n$T Ejecute$G ./ngrok.sh"
                exit 0
        fi
}

logo
requirements
config_ngrok
