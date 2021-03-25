#!/bin/sh

# PEPPERMINT TEN LIVE SETUP SCRIPT V1.0
#
# Firewall setup
# Environment config
#


# check chassis
chassis()
{
    CHASSIS=$(hostnamectl status | grep Chassis | cut -f2 -d ":" | tr -d ' ')
    echo "Chassis: ${CHASSIS}"
    if ! [ "$CHASSIS" = "laptop" ]; then
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s 0
    fi;
}


# firewall setup
echo "\nFirewall setup...\n" &&
sudo ufw enable &&
sudo ufw default deny incoming &&
sudo ufw default allow outgoing &&
sudo ufw reload &&
sudo ufw status verbose &&


# environment setup
## panel config
echo "\nXFCE4 panel configuration...\n" &&

## videos remove
xfconf-query -c xfce4-panel -p /plugins/plugin-5 -rR &&

## remove pager
xfconf-query -c xfwm4 -p /general/workspace_count -s 1 &&
xfconf-query -c xfce4-panel -p /plugins/plugin-8 -rR &&

## remove xfce4 power manager icon, if not laptop
chassis &&

## keyboard layout config
xfconf-query -n -c xfce4-panel -p "/plugins/plugin-11/display-type" -t uint -s "2" &&
xfconf-query -n -c xfce4-panel -p "/plugins/plugin-11/display-name" -t uint -s "1" &&
xfconf-query -n -c xfce4-panel -p "/plugins/plugin-11/display-tooltip-icon" -t bool -s "false" &&
xfconf-query -n -c xfce4-panel -p "/plugins/plugin-11/group-policy" -t uint -s "0" &&

## clock config
xfconf-query -n -c xfce4-panel -p "/plugins/plugin-12/digital-format" -t string -s "%H:%M - %d/%m/%Y" &&

## restart xfce4 panel
echo "Restarting XFCE4 panel..." &&
xfce4-panel -r &&

# clear
clear
