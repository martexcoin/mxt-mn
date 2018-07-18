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
cd /opt/martexcoin && git pull && cd martexcoin/src && chmod +x leveldb/build_detect_platform && chmod +x secp256k1/autogen.sh && make -f makefile.unix USE_UPNP=- && strip MarteXd && cp MarteXd /usr/local/bin && echo "Cleaning up" && make -f makefile.unix clean && cd && MarteXd

echo "Switching to node monitor mode. Press ctl-c to exit."
watch MarteXd getinfo
echo "Get MarteX!!" 
