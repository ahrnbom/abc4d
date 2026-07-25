#!/bin/bash

set -e

ABD4D_DIR=/etc/abc4d
sudo mkdir -p $ABD4D_DIR

# Basic dependencies
sudo apt install -y linux-kernel-amd64 linux-headers-amd64 extrepo git htop curl wget nano python3-venv python3-pip fonts-mononoki fonts-noto-color-emoji flatpak kitty pkexec libnotify-bin

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
# Instructions from https://docs.noctalia.dev/v5/getting-started/installation/?section=debian#debian
wget https://pkg.noctalia.dev/deb/nickh-archive-keyring.deb && sudo dpkg -i nickh-archive-keyring.deb
sudo wget -O /etc/apt/sources.list.d/noctalia-trixie.sources https://pkg.noctalia.dev/deb/noctalia-trixie.sources
sudo apt-get install -y -t trixie-backports noctalia noctalia-greeter
sudo cp greeter.toml /var/lib/noctalia-greeter/greeter.toml

# Configure Flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Firefox
flatpak install -y org.mozilla.firefox

# Install Bazaar
flatpak install -y io.github.kolunmi.Bazaar

# Install NetworkManager
sudo apt-get install -y network-manager

# Nuke old network config with warning
sudo cp /etc/network/interfaces $ABD4D_DIR/old-network-interfaces.bak
echo "About to nuke your network config... Trust me, it's fine, but you can Ctrl + C to abort"
sleep 5
cat << 'EOF' | sudo tee /etc/network/interfaces > /dev/null
source /etc/network/interfaces.d/*
auto lo
iface lo inet loopback
EOF
echo "Old network nuked, backup written to $ABD4D_DIR/old-network-interfaces.bak"

# Enable NetworkManager
sudo systemctl enable --now NetworkManager
sudo systemctl restart NetworkManager

# Hyprland config
rm -f ~/.config/hypr/hyprland.conf
cp hyprland.lua ~/.config/hypr/hyprland.lua

# Kitty config
cp kitty.conf ~/.config/kitty/kitty.conf

# Install hyprmod, a graphical application to adjust Hyprland config
# It has quite a lot of dependencies and it's not currently packaged in 
# a way that makes it easy to obtain with updates, but it's very useful to have
# Feel free to not install these things if you don't want it
sudo apt install pipx libglib2.0-bin python-gi-dev python3-gi-cairo \
    pkg-config libcairo2-dev libgirepository-2.0-dev python3-dev \
    gir1.2-adw-1 lua5.4
pipx install git+https://github.com/BlueManCZ/hyprmod.git
hyprmod --install

# Done!
echo "Installation complete! Rebooting in 10 seconds..."
sleep 10
systemctl reboot