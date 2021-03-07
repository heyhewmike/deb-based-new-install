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
echo "Installing lsb-release" && su - -c 'apt install -y lsb-release'
#Sets the distro name to a variable
distro=$(lsb_release -is)
#Sets the release name to a variable
release=$(lsb_release -rs | cut -d. -f1)
#Sets the current signed in user as a variable for use in paths and adding to sudo
export currentuser=$(pwd | cut -d/ -f3)
#sets a variable to 0 so that it can check for forked distros that provide the same distro name and release as Debian
debianresult=0
# Checks to see if there is a source file for Antix and MX - Both Debian based Distros
anti= ls /etc/apt/sources.list.d/ | grep anti | cut -d. -f1
mx= ls /etc/apt/sources.list.d/ | grep mx | cut -d. -f1
if [ $anti=antix ]; then
    debianresult=$(( $debianresult + 1))
fi
if [ $mx=mx ]; then
    debianresult=$(( debianresult + 1))
fi
if [ $distro = Debian ]; then
    if [ $release >= 10]; then
        #Checks to see if this is Debian and adds backports
        if [ $debianresult = 0 ]; then
            clear && echo "Running for Debian"
            # back up the newly installed sources
            echo "Backing up the sources file" && sleep 1
            su - -c 'cp /etc/apt/sources.list /etc/apt/list.sources.org'
            # enable contrib and non-free
            clear && echo "Adding contrib and non-free" && sleep .5
            # grep is required so that sed does not edit the same line with multiple runs of this program
            su - -c 'cat /etc/apt/sources.list | grep "contrib non-free" || sed -i "s/main/main contrib non-free/g" /etc/apt/sources.list'
            # update apt & upgrade & install lsb-release
            clear && echo "Updating & Upgrading apt & Installing lsb-release" && sleep .5
            su - -c 'apt update && apt -y upgrade && apt install -y lsb-release' && clear && echo "Adding backports" && sleep .5
            # makes the sources.list.d directory if it is not there
            su - -c 'mkdir -p /etc/apt/sources.list.d'
            # adds the backports for the $(lsb_release -cs){identifies the name of the version} to a file in the directory
            su - -c 'cat "deb http://deb.debian.org/debian $(lsb_release -cs)-backports main contrib non-free" >> /etc/apt/sources.list.d/backports.list'
            clear && echo "Updating & Upgrading - Again - Backports" && sleep .5
        # if this is antix or mx then it skips the backports as that is already present
        elif [ $debianresult >= 1 ]; then
            clear && echo "Running for MX or AntiX"
            su - -c 'apt update && apt -y upgrade && apt install -y lsb-release'
        fi
        su - -c 'apt update && apt -y upgrade && apt install -y firmware-linux firmware-misc-nonfree'
        su - -c 'apt update && apt -y upgrade && apt install -y remmina dnsutils screen'
        # install GitKraken, Teamviewer and Zoom
        cd /home/${currentuser}/Downloads && wget https://release.gitkraken.com/linux/gitkraken-amd64.deb && wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && wget https://zoom.us/client/latest/zoom_amd64.deb && su - -c 'apt install -y ./gitkraken-amd64.deb ./teamviewer_amd64.deb ./zoom_amd64.deb'
    else
        echo 'deb http://ftp.debian.org/debian stretch-backports main' | sudo tee --append /etc/apt/sources.list.d/stretch-backports.list >> /dev/null
        su - -c 'apt-get update && apt-get -y upgrade && apt-get install -t stretch-backports remmina remmina-plugin-rdp remmina-plugin-secret remmina-plugin-spice && apt install -y dnsutils screen'
        # install GitKraken, Teamviewer and Zoom
        cd /home/${currentuser}/Downloads && wget https://release.gitkraken.com/linux/gitkraken-amd64.deb && wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && wget https://zoom.us/client/latest/zoom_amd64.deb && su - -c 'apt install -y ./gitkraken-amd64.deb ./teamviewer_amd64.deb ./zoom_amd64.deb'
    fi
elif [ $distro = Ubuntu ]; then
    if [ $release >= 20 ]; then
        clear && echo "Running for Ubuntu" && echo "updating and upgrading and installing tools" && sleep 1
        # install remmina, Teamviewer, Zoom & GitKraken
        su - -c 'apt-add-repository ppa:remmina-ppa-team/remmina-next'
        su - -c 'apt update && apt -y upgrade' && su - -c 'apt install -y remmina remmina-plugin-rdp remmina-plugin-secret dnsutils screen'
        cd /home/${currentuser}/Downloads && wget https://release.gitkraken.com/linux/gitkraken-amd64.deb && wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && wget https://zoom.us/client/latest/zoom_amd64.deb && su - -c 'apt install -y ./gitkraken-amd64.deb ./teamviewer_amd64.deb ./zoom_amd64.deb'
    else
        clear && echo "Running for Ubuntu" && echo "updating and upgrading and installing tools" && sleep 1
        # install remmina, Teamviewer, Zoom & GitKraken
        # add the dependencies to use apt-add-repository
        su - -c 'apt-get update && apt-get -y upgrade && apt-get install -y software-properties-common'
        su - -c 'apt-add-repository ppa:remmina-ppa-team/remmina-next' && su - -c 'apt-get update && apt-get -y upgrade' && su - -c 'apt-get install -y remmina remmina-plugin-rdp remmina-plugin-secret dnsutils screen'
        cd /home/${currentuser}/Downloads && wget https://release.gitkraken.com/linux/gitkraken-amd64.deb && wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && wget https://zoom.us/client/latest/zoom_amd64.deb && su - -c 'apt install -y ./gitkraken-amd64.deb ./teamviewer_amd64.deb ./zoom_amd64.deb'
    fi
elif [ $distro = Linuxmint ]; then
clear && echo "Running for Linux Mint" && echo "updating and upgrading and installing tools" && sleep 1
    if [ $release >= 20 ];then
        # install remmina, Teamviewer, Zoom & GitKraken
        su - -c 'apt-add-repository ppa:remmina-ppa-team/remmina-next' && su - -c 'apt update && apt -y upgrade' && su - -c 'apt install -y remmina remmina-plugin-rdp remmina-plugin-secret dnsutils screen'
        cd /home/${currentuser}/Downloads && wget https://release.gitkraken.com/linux/gitkraken-amd64.deb && wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && wget https://zoom.us/client/latest/zoom_amd64.deb && su - -c 'apt install -y ./gitkraken-amd64.deb ./teamviewer_amd64.deb ./zoom_amd64.deb'
    else
        su - -c 'apt-get install -y software-properties-common'
        # install remmina, Teamviewer, Zoom & GitKraken
        # add the dependencies to use apt-add-repository
        su - -c 'apt-add-repository ppa:remmina-ppa-team/remmina-next' && su - -c 'apt-get update && apt-get -y upgrade' && su - -c 'apt-get install -y remmina remmina-plugin-rdp remmina-plugin-secret dnsutils screen'
        cd /home/${currentuser}/Downloads && wget https://release.gitkraken.com/linux/gitkraken-amd64.deb && wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && wget https://zoom.us/client/latest/zoom_amd64.deb && su - -c 'apt install -y ./gitkraken-amd64.deb ./teamviewer_amd64.deb ./zoom_amd64.deb'
    fi
elif [ $distro = Sparky ]; then
clear && echo "Running for Sparky" && echo "updating and upgrading and installing tools" && sleep 1
# install remmina, Teamviewer, Zoom, GitKraken
su - -c 'apt-add-repository ppa:remmina-ppa-team/remmina-next' && su - -c 'apt update && apt -y upgrade' && su - -c 'apt install -y remmina remmina-plugin-rdp remmina-plugin-secret dnsutils screen'
cd /home/${currentuser}/Downloads && wget https://release.gitkraken.com/linux/gitkraken-amd64.deb && wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && wget https://zoom.us/client/latest/zoom_amd64.deb && su - -c 'apt install -y ./gitkraken-amd64.deb ./teamviewer_amd64.deb ./zoom_amd64.deb'
else
clear && echo " Runing for unknown Distro" && echo "installing dnsutils and screen" && su - -c 'apt update && apt -y upgrade && apt install -y dnsutils screen'
clear && echo "Downloading and installing GitKraken, Teamviewer and Zoom" && sleep .5
cd /home/${currentuser}/Downloads && wget https://release.gitkraken.com/linux/gitkraken-amd64.deb && wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb && wget https://zoom.us/client/latest/zoom_amd64.deb && su - -c 'apt install -y ./gitkraken-amd64.deb ./teamviewer_amd64.deb ./zoom_amd64.deb'
fi
if [ $permissions = yes ] or [ $permissions = y ] or [ $permissions = Yes ] or [ $permissions = Y ]; then
# setting user to sudo rights
clear && echo "Setting sudo permissions" && su - -c 'gpasswd -a '${currentuser}' sudo' && sleep .5
else
clear && echo "sudo permissions were not set" && sleep .5
fi
clear
echo "All up to date"