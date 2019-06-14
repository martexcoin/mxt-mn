#!/bin/bash
# https://github.com/martexcoin/mxt-mn for updates
# To build a MXT node from https://github.com/martexcoin/martexcoin Repository on to Ubuntu +16.04 VPS
# Tested on a minimal VPS configuration of: 1vCPU 1GB RAM 16GB Storage
#########################################################################################################
# PLEASE REVIEW IT BEFORE YOUR RUN 
#########################################################################################################
clear
uris=$(lsb_release -a | grep Release | cut -f 2)
meis=$(free -m | grep Mem | awk '{print $2}')
swis=$(free -m | grep Swap | awk '{print $2}')
uris=$(whoami)
iiis=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
ifis=$(route | grep default | awk '{print $8}')

if [ "$swis" = 0 ]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo -e "/swapfile   none    swap    sw    0   0 \n" >> /etc/fstab
    swis=$(free -m | grep Swap | awk '{print $2}')
fi

echo "Running on Ubuntu $uris with $meis MB Ram and $swis MB swap"
echo "Updating the VM and installing dependencies"
apt update && apt -y upgrade && apt -y install build-essential libtool autotools-dev autoconf automake pkg-config libssl-dev libevent-dev libboost-all-dev libminiupnpc-dev libgmp-dev libcurl4-openssl-dev libdb-dev libdb++-dev git fail2ban zip unzip
echo "Configuring fail2ban"
echo -e "[DEFAULT]\nbantime  = 864000\nfindtime  = 600\nmaxretry = 3\ndestemail = root@localhost\nsender = root@localhost\n\naction = %(action_mwl)s\n" >> /etc/fail2ban/jail.local
service fail2ban restart
echo "Building MXT... may take extended time on a low memory VPS"
cd /opt && rm -rf martexcoin && git clone https://github.com/martexcoin/martexcoin.git && cd martexcoin
./autogen.sh && ./configure --disable-gui-tests --disable-tests && make && cd src && strip martexd martex-cli martex-tx && cp martexd martex-cli martex-tx /usr/local/bin
echo "Cleaning up" && cd /opt/martexcoin && make clean && cd && martexd

read -p "Please enter this MN Private Key and press [ENTER]:" yay
if [[ -z "$yay" ]]; then
   printf '%s\n' "No key entred, you have to edit ~/.MXT/MarteX.conf your self and plug your Masternode Key"
   mnpkey="PLUG_YOUR_MN_KEY_HERE"
else
   shopt -s extglob
   yay="${yay##*( )}"
   yay="${yay%%*( )}"
   shopt -u extglob
   mnpkey=$yay
fi

echo "Building node config file"
echo -e "masternode=1\nmasternodeaddr=$iiis:51315\nmasternodeprivkey=$mnpkey\nexternalip=$iiis\nlogtimestamps=1\ntxindex=1\nstake=0\nstaking=0\n" >> ~/.MXT/MarteX.conf

echo "Downloading blockchain . . ."
cd ~/.MXT/ && wget martexcoin.org/releases/blockchain-latest.zip && unzip -o blockchain-latest.zip && cd

sleep 10; martexd

echo "Setting martexd to auto-run on reboot"
echo -e "@reboot /usr/local/bin/martexd\n" >> /var/spool/cron/crontabs/$uris
echo "Switching to node monitor mode. Press ctl-c to exit."
watch martex-cli getinfo
echo "Get MarteX!!\nReboot the VPS and access it again to confirm all is in order"
