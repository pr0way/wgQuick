#!/bin/bash

WIREGUARD_DIR="/etc/wireguard"
WIREGUARD_CFG="wg0"

function generateServerCert(){
    wg genkey | tee server_privatekey | wg pubkey > server_publickey
}

function generateClientCert(){
    wg genkey | tee peer1_privatekey | wg pubkey > peer1_publickey
}

function isInstalled(){
    if [ $# -eq 1 ]; then

        # Command exist
        if [ command -v "$1" >/dev/null 2>&1 ]; then
            msg -i "$1 exist"
        else 
            msg "I can't find $1 in system!"
        fi

    else 
        msg "Incorrect use ${FUNCNAME[0]}"
    fi
}

function goDirectory(){
    if [ -d $WIREGUARD_DIR ]; then
        cd $WIREGUARD_DIR
    else
        msg "Wireguard directory doesn't exist!"
    fi
}

function msg(){
    RED="\e[0;31m"
    GREEN="\e[0;32m"
    YELLOW="\e[0;33m"
    CYAN="\e[0;36m"
    NC="\e[0m"

    if [ $# -lt 1 ]; then
        echo -e "${CYAN}Usage: ${GREEN}$0 ${YELLOW}<interface>$NC"
        exit 1
    elif [ $# -eq 1 ]; then
        echo -e "${RED}Error: ${NC}$1"
        exit 1
    elif [ $# -eq 2 ]; then
        case "$1" in
            -w)
                echo -e "${YELLOW}$2${NC}"
            ;;
            -d)
                echo -e "${RED}$2${NC}"
            ;;
            -i)
                echo -e "${CYAN}$2${NC}"
            ;;
            -o)
                echo -e "${GREEN}$2${NC}"
            ;;
        esac
    else
        msg "Incorrect use ${FUNCNAME[0]}"
    fi
}

function main() {
    if [ $# -eq 1 ]; then

        msg -o "Program started..."

        goDirectory
        isInstalled wg
        isInstalled tee
        # generateServerCert
        # generateClientCert


    else
        msg
    fi
}


# Start program
main $@