# abc4d - Another Based Config for Debian


If you want to get into tiling window managers but found the learning curve a little too steep, perhaps this project can be of use. abc4d is a setup script that installs a reasonably cohesive tiling desktop using Hyprland and Noctalia. Unlike other, similar projects like (https://github.com/JaKooLit/Debian-Hyprland)[this one], abc4d is much simpler and should Just Work™ (I tried to install the "Kool" one several times before giving up and realizing that it's really stupid and you can achieve a much better result with less effort, and gain a lot of stability as a side bonus, hence the creation of this project).

abc4d adheres to these guidelines:
- one single script, should be easy to read and reason about
- simple installations only, if something requires many lines to do, then it's probably not the right way to do it 
- don't do exactly everything, the user is not stupid and can configure a few things after installation, this can still be a helpful tool to get people started and we can provide some guidance on where to go next 
- limit control flow and branching to the absolute essentials, we don't need the complexity and you're not stupid, you can comment out stuff or shuffle things around if you need to re-run a specific step or whatever 

## What gets installed
- nvidia drivers directly from nvidia packaged for debian, this is by far the most stable approach from my experience
- hyprland, a very competent and configurable window manager
- noctalia, a set of cohesive desktop tools that work great on top of hyprland

## Current status

Alpha status, not yet tested. Use at your own risk! 

## Instructions

`./install.sh`

## Quirks and warnings
This script installs Noctalia v5, which (at the time of writing) is still in beta. This is because I couldn't get v4 to work, and I also assume it will be considered stable quite soon because it seems to work really well.

Noctalia's network UI requires NetworkManager to work, but a basic Debian Trixie install doesn't have that (at least, it didn't on my machine), instead it uses a very simple network config in `/etc/network/interfaces`. This script nukes those settings, to avoid conflicts with NetworkManager. You may have to e.g. log into your wifi again. If you try to install this over ssh, expect the session to get interrupted.

This script currently looks for Nvidia hardware, and if it finds it, installs the open nvidia drivers. If you have old nvidia hardware (older than the 16XX series) this will not work and will probably bork your system. You have been warned!