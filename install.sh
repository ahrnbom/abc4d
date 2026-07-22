#!/bin/bash

set -e

# Basic dependencies
sudo apt install linux-kernel-amd64 linux-headers-amd64 extrepo git htop curl nano python3-venv python3-pip fonts-mononoki

# Install nvidia drivers
if grep -q "0x10de" /sys/bus/pci/devices/*/vendor 2>/dev/null; then
    echo "[+] Nvidia hardware found in sysfs!"
    sudo extrepo enable nvidia-cuda
    sudo apt update 
    sudo apt install -y nvidia-open
fi

# Activate trixie backports
sudo cp debian-backports.sources /etc/apt/sources.list.d/debian-backports.sources
sudo apt-get update 

# Install hyprland
sudo apt-get install -y -t trixie-backports hyprland hyprland-guiutils

# Install Noctalia
sudo apt-get install -y -t trixie-backports noctalia

# Install and configure NetworkManager
sudo apt-get install -y network-manager
echo "About to nuke your network config... Trust me, it's fine, but you can Ctrl + C to abort"
sleep 5

sudo cat << EOF > /etc/network/interfaces
source /etc/network/interfaces.d/*
auto lo
iface lo inet loopback
EOF

sudo systemctl enable --now NetworkManager
sudo systemctl restart NetworkManager
