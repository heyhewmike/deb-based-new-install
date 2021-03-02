#!/bin/bash
# Copyright © 2021 Michael Kudrak <mike@heyhew.net>
#
# Published under the GNU GPL V3 License
# 
# By using this software you have agreed to the
# LICENSE TERMS outlined in the file titled
# LICENSE contained in the top-level directory of
# this project.
clear
# Query if they need current user to have sudo permissions
echo "Does this user require sudo privilages to be added? yes or no"
read permissions
echo "Installing lsb-release"
su - -c 'apt install -y lsb-release'
distro=$(lsb_release -is)
export currentuser=$(pwd | cut -d/ -f3)
if [ $distro = Debian ]; then
clear
echo "Running for Debian"
# back up the newly installed sources
echo "Backing up the sources file" && sleep 1
su - -c 'cp /etc/apt/sources.list /etc/apt/list.sources.org'
# enable contrib and non-free
clear && echo "Adding contrib and non-free" && sleep .5
# grep is required so that sed does not edit the same line with multiple runs of this program
su - -c 'cat /etc/apt/sources.list | grep "contrib non-free" || sed -i "s/main/main contrib non-free/g" /etc/apt/sources.list'
# update apt & upgrade & install lsb-release
clear && echo "Updating & Upgrading apt & Installing lsb-release" && sleep .5
su - -c 'apt update && apt -y upgrade && apt install -y lsb-release'
clear && echo "Adding backports" && sleep .5
# makes the sources.list.d directory if it is not there
su - -c 'mkdir -p /etc/apt/sources.list.d'
# adds the backports for the $(lsb_release -cs){identifies the name of the version} to a file in the directory
su - -c 'cat "deb http://deb.debian.org/debian $(lsb_release -cs)-backports main contrib non-free" >> /etc/apt/sources.list.d/backports.list'
clear && echo "Updating & Upgrading - Again - Backports" && sleep .5
su - -c 'apt update && apt -y upgrade && apt install -y firmware-linux firmware-misc-nonfree'
su - -c 'apt update'
su - -c 'apt -y upgrade'
su - -c 'apt install -y remmina dnsutils screen'
cd /home/${currentuser}/Downloads
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
su - -c 'apt install -y ./gitkraken-amd64.deb'
elif [ $distro = Ubuntu ]; then
clear 
echo "Running for Ubuntu" && echo "updating and upgrading and installing tools" && sleep 1
# install remmina
su - -c 'apt-add-repository ppa:remmina-ppa-team/remmina-next'
su - -c 'apt update && apt -y upgrade'
su - -c 'apt install -y remmina remmina-plugin-rdp remmina-plugin-secret dnsutils screen'
cd /home/${currentuser}/Downloads
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
su - -c 'apt install -y ./gitkraken-amd64.deb'
elif [ $distro = Linuxmint ]; then
clear 
echo "Running for Linux Mint" && echo "updating and upgrading and installing tools" && sleep 1
# install remmina
su - -c 'apt-add-repository ppa:remmina-ppa-team/remmina-next'
su - -c 'apt update && apt -y upgrade'
su - -c 'apt install -y remmina remmina-plugin-rdp remmina-plugin-secret dnsutils screen'
cd /home/${currentuser}/Downloads
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
su - -c 'apt install -y ./gitkraken-amd64.deb'
elif [ $distro = Sparky ]; then
clear 
echo "Running for Sparky" && echo "updating and upgrading and installing tools" && sleep 1
# install remmina
su - -c 'apt-add-repository ppa:remmina-ppa-team/remmina-next'
su - -c 'apt update && apt -y upgrade'
su - -c 'apt install -y remmina remmina-plugin-rdp remmina-plugin-secret dnsutils screen'
cd /home/${currentuser}/Downloads
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
su - -c 'apt install -y ./gitkraken-amd64.deb'
else
clear
echo " Runing for unknown Distro" && echo "installing dnsutils and screen"
su - -c 'apt update && apt -y upgrade && apt install -y dnsutils screen'
fi
if [ $permission = yes ]; then
# setting user to sudo rights
clear
echo "Setting sudo permissions"
su - -c 'gpasswd -a '${currentuser}' sudo'
sleep .5
else
clear && echo "sudo permissions were not set" && sleep .5
fi
clear
echo "All up to date"