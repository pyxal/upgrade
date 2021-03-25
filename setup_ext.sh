#!/bin/sh

# LINUX OS SETUP SCRIPT V1.3
#
# Firewall setup
# Full OS upgrade
# Sublime Text 3
# speedtest-cli
# youtube-dl
# gnome-chess
# Environment config
#



# check status
status()
{
	case "$1" in
		"install")
			if [ "$2" = true ]; then
				echo "\n${3} successful\n"
			else
				echo "\n${3} failed\n"
			fi;
			;;

		"check")
			if [ "$2" = true ]; then
				echo "${3}: OK"
			else
				echo "${3}: failed"
			fi;
			;;
	esac
}


# check chassis
chassis()
{
    CHASSIS=$(hostnamectl status | grep Chassis | cut -f2 -d ":" | tr -d ' ')
    echo "Chassis: ${CHASSIS}"
    if ! [ "$CHASSIS" = "laptop" ]; then
        xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s 0
    fi;
}


# elevation
echo "\nLinux OS setup script V1.3\n"
sudo whoami

# status variables
UFWSETUP=false
FULLUPGRADE=false
SUBLIMETEXT=false
SPEEDTESTCLI=false
YOUTUBEDL=false
GNOMECHESS=false
ENVIRONMENTCONFIG=false



# firewall setup
echo "\nFirewall setup...\n"
sudo ufw enable &&
sudo ufw default deny incoming &&
sudo ufw default allow outgoing &&
sudo ufw reload &&
sudo ufw status verbose &&
UFWSETUP=true || UFWSETUP=false

# firewall status
status "install" $UFWSETUP "Firewall setup"



# full upgrade & clean up
echo "\nFull upgrade & clean up...\n"
sudo apt update &&
sudo apt full-upgrade -y &&
sudo apt autoclean &&
sudo apt autoremove -y &&
FULLUPGRADE=true || FULLUPGRADE=false

# full upgrade status
status "install" $FULLUPGRADE "Full-upgrade"



# install and setup Sublime Text 3
echo "\nInstalling Sublime Text 3...\n"

## install GPG key
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - &&

## set up apt to work with https sources
sudo apt install apt-transport-https &&

## use stable upgrade repository
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list &&

## update apt and install Sublime Text 3
sudo apt update &&
sudo apt install sublime-text &&
SUBLIMETEXT=true || SUBLIMETEXT=false

# sublime text 3 status
status "install" $SUBLIMETEXT "Sublime Text 3"



# install speedtest-cli
echo "\nInstalling speedtest-cli...\n"
sudo apt install python3-pip -y &&
sudo pip3 install speedtest-cli &&
echo "\nRunning speedtest...\n" &&
speedtest &&
echo "\ndone" &&
SPEEDTESTCLI=true || SPEEDTESTCLI=false

# speedtest-cli status
status "install" $SPEEDTESTCLI "speedtest-cli"



# install youtube-dl
echo "\nInstalling youtube-dl...\n"
sudo snap install youtube-dl &&
YOUTUBEDL=true || YOUTUBEDL=false

# youtube-dl status
status "install" $YOUTUBEDL "youtube-dl"



# install gnome-chess
echo "\nInstalling gnome-chess...\n"
sudo apt install gnome-chess -y &&
GNOMECHESS=true || GNOMECHESS=false

# gnome-chess status
status "install" $GNOMECHESS "gnome-chess"



# environment setup
echo "\nEnvironment config..."

OS=$(cat /etc/issue | awk '{print $1, $2}' | sed -e 's/^[ \t]*//')
echo "\nOS detected: ${OS}"

case "$OS" in
	"Peppermint Ten")
		## panel config
		echo "Xfce4 panel configuration..."

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
		ENVIRONMENTCONFIG=true || ENVIRONMENTCONFIG=false
		;;

	"Linux Mint")
		## panel config
		echo "No environment config avaiable for Linux Mint\n" &&
		ENVIRONMENTCONFIG=true || ENVIRONMENTCONFIG=false
		;;
esac

# environment config status
status "install" $ENVIRONMENTCONFIG "Environment setup"



# print status
echo "\n\nStatus:\n"
status "check" $UFWSETUP "Firewall setup"
status "check" $FULLUPGRADE "Full-upgrade"
status "check" $SUBLIMETEXT "Sublime Text 3"
status "check" $SPEEDTESTCLI "speedtest-cli"
status "check" $YOUTUBEDL "youtube-dl"
status "check" $GNOMECHESS "gnome-chess"
status "check" $ENVIRONMENTCONFIG "Environment setup"



# end message
echo "\nSetup completed\n"
