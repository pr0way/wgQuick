#!/bin/bash

# INIT VARS
WIREGUARD_DIR="/etc/wireguard"
WIREGUARD_CFG="wg0.conf"

NETWORK_RANGE="10.0.0.1/24"
PORT="51820"
DNS_SERVERS="1.1.1.1, 1.0.0.1"

SERVER_PUB_KEY_NAME="server_publickey"
SERVER_PRIV_KEY_NAME="server_privatekey"

CLIENT_PUB_KEY_NAME="peer1_publickey"
CLIENT_PRIV_KEY_NAME="peer1_privatekey"

function addPeersToConfig(){

    # Add exist peer / create new one

    # while true; do
    # done

}

function createServerConfiguration(){

    if [ ! -f $WIREGUARD_CFG ]; then

    echo """
    [Interface]
    Address = ${NETWORK_RANGE}
    ListenPort = ${PORT}  
    DNS = ${DNS_SERVERS} 
    PrivateKey = ${returnCert "$WIREGUARD_DIR/$SERVER_PRIV_KEY_NAME"} 

    PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

    """ > $WIREGUARD_CFG

    fi

    # TODO: Interactive Peers adds

}

function generateServerCert(){
    wg genkey | tee $SERVER_PRIV_KEY_NAME | wg pubkey > $SERVER_PUB_KEY_NAME
}

function generateClientCert(){
    wg genkey | tee $CLIENT_PRIV_KEY_NAME | wg pubkey > $CLIENT_PUB_KEY_NAME
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

function returnCert(){
    return cat $1
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
        # TODO: Refactor isInstalled
        isInstalled wg
        isInstalled tee
        isInstalled cat
        # generateServerCert
        # generateClientCert


    else
        msg
    fi
}


# Start program
main $@