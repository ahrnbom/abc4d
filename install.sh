#!/bin/bash

set -e

ABD4D_DIR=/etc/abc4d
sudo mkdir -p $ABD4D_DIR

# Basic dependencies
sudo apt install -y linux-kernel-amd64 linux-headers-amd64 extrepo git htop curl wget nano python3-venv python3-pip fonts-mononoki flatpak kitty pkexec libnotify-bin

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
sudo apt-get install -y -t trixie-backports hyprland hyprland-guiutils hyprshutdown hyprpolkitagent

# Install Noctalia
wget https://pkg.noctalia.dev/deb/nickh-archive-keyring.deb && sudo dpkg -i nickh-archive-keyring.deb
sudo wget -O /etc/apt/sources.list.d/noctalia-trixie.sources https://pkg.noctalia.dev/deb/noctalia-trixie.sources
sudo apt-get install -y -t trixie-backports noctalia noctalia-greeter
sudo cp greeter.toml /var/lib/noctalia-greeter/greeter.toml

# Configure Flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Firefox
flatpak install -y org.mozilla.firefox

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

# Hyprland config
rm -r ~/.config/hypr/hyprland.conf
cp hyprland.lua ~/.config/hypr/hyprland.lua

# Create fun update checker
sed -i "s/USER_NAME=\"YOUR_USERNAME\"/USER_NAME=\"$USER\"/" abc4d-update-checker.sh
sudo cp abc4d-update-checker.sh /usr/local/bin/abc4d-update-checker.sh
sudo cp abc4d-update-checker.service /etc/systemd/system/abc4d-update-checker.service
sudo systemctl daemon-reload