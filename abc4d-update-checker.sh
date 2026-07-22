#!/bin/bash

# --- CONFIGURATION ---
USER_NAME="YOUR_USERNAME"
TERM_CMD="kitty -e"
# ---------------------

sleep 60

# Get the target user's ID and graphical session address
USER_ID=$(id -u "$USER_NAME")
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"

# 1. Run the real apt update quietly as root
apt-get update -y >/dev/null 2>&1

# 2. Count pending updates
apt_updates=$(apt-get -s upgrade 2>/dev/null | grep -c "^Inst")
flatpak_updates=$(sudo -u "$USER_NAME" flatpak remote-ls --updates 2>/dev/null | wc -l)

# 3. Handle APT Notification
if [ "$apt_updates" -gt 0 ]; then
    action=$(sudo -u "$USER_NAME" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
        notify-send "APT Updates Available" "$apt_updates packages can be upgraded." \
        --action="upgrade=Run Upgrade")
    
    if [ "$action" = "upgrade" ]; then
        # Run terminal in user context, using pkexec for the elevation prompt
        sudo -u "$USER_NAME" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
            $TERM_CMD sh -c "sudo apt upgrade -y; exec bash" &
    fi
fi

# 4. Handle Flatpak Notification
if [ "$flatpak_updates" -gt 0 ]; then
    action=$(sudo -u "$USER_NAME" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
        notify-send "Flatpak Updates Available" "$flatpak_updates apps can be upgraded." \
        --action="upgrade=Run Upgrade")
    
    if [ "$action" = "upgrade" ]; then
        sudo -u "$USER_NAME" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
            $TERM_CMD sh -c "flatpak update -y; exec bash" &
    fi
fi
