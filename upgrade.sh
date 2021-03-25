#!/bin/sh

# LINUX OS UPGRADE SCRIPT V1.0
#
# Full OS upgrade
#

# elevation
echo "\nLinux OS upgrade script V1.0\n"
sudo whoami

# full upgrade & clean up
echo "\nFull upgrade & clean up...\n"
sudo apt update &&
sudo apt full-upgrade -y &&
sudo apt autoclean &&
sudo apt autoremove -y &&
echo "\nFull upgrade successful\n" || echo "\nFull upgrade failed\n"
