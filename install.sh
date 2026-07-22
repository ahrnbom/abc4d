#!/bin/bash

set -e

ABD4D_DIR=/etc/abc4d
sudo mkdir -p $ABD4D_DIR 

# Basic dependencies
sudo apt install -y linux-kernel-amd64 linux-headers-amd64 extrepo git htop curl nano python3-venv python3-pip fonts-mononoki flatpak

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
sudo apt-get install -y -t trixie-backports hyprland hyprland-guiutils hyprshutdown

# Install Noctalia
sudo apt-get install -y -t trixie-backports noctalia noctalia-greeter
sudo cp $PWD/greeter.toml /var/lib/noctalia-greeter/greeter.toml

# Configure Flathub
# TODO TODO TODO

# Install NetworkManager
sudo apt-get install -y network-manager

# Nuke old network config with warning
cp /etc/network/interfaces $ABD4D_DIR/old-network-interfaces.bak
echo "About to nuke your network config... Trust me, it's fine, but you can Ctrl + C to abort"
sleep 5
sudo cat << EOF > /etc/network/interfaces
source /etc/network/interfaces.d/*
auto lo
iface lo inet loopback
EOF
echo "Old network nuked, backup written to $ABD4D_DIR/old-network-interfaces.bak"

# Enable NetworkManager
sudo systemctl enable --now NetworkManager
sudo systemctl restart NetworkManager

