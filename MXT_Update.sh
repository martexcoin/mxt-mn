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
martex-cli stop && sleep 10
mkdir /opt/martexcoin-v4.0.2.2
cd /opt/martexcoin-v4.0.2.2
wget https://github.com/martexcoin/martexcoin/releases/download/v4.0.2.2/martexcore-4.0.2-x86_64-linux-gnu.tar.gz
tar -zxvf martexcore-4.0.2-x86_64-linux-gnu.tar.gz
cd martexcore-4.0.2/bin && cp * /usr/local/bin/
echo "Cleaning up" && martexd
echo "Switching to node monitor mode. Press ctl-c to exit."
watch martex-cli getinfo
echo "Get MarteX!!"
