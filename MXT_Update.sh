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
mkdir /opt/martexcoin-v4.0.0
cd /opt/martexcoin-v4.0.0
wget https://github.com/martexcoin/martexcoin/releases/download/v4.0.0.0/martexcore-4.0.0-x86_64-linux-gnu.tar.gz
tar -zxvf martexcore-4.0.0-x86_64-linux-gnu.tar.gz
cd martexcore-4.0.0/bin && cp * /usr/local/bin/
echo "Cleaning up" && martexd

echo "Switching to node monitor mode. Press ctl-c to exit."
watch martex-cli getinfo
echo "Get MarteX!!"
