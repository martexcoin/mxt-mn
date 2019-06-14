#!/bin/bash
# https://github.com/martexcoin/mxt-mn for updates
# UPDATE a built MXT node from https://github.com/martexcoin/martexcoin Repository on to Ubuntu +16.04 VPS
# Tested on a minimal VPS configuration of: 1vCPU 1GB RAM 16GB Storage
#########################################################################################################
# PLEASE REVIEW IT BEFORE YOUR RUN
#########################################################################################################
clear

echo "Updating the VM and applying OS patches"
apt update && apt -y upgrade
echo "Updating MXT"
cd /opt/martexcoin && git checkout . && git pull && ./autogen.sh && ./configure --disable-gui-tests --disable-tests && make && cd src && strip martexd martex-cli martex-tx && cp martexd martex-cli martex-tx /usr/local/bin
echo "Cleaning up" && cd /opt/martexcoin && make clean && cd && martexd

echo "Switching to node monitor mode. Press ctl-c to exit."
watch martex-cli getinfo
echo "Get MarteX!!" 
