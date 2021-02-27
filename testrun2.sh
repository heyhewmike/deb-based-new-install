#!/bin/bash
clear
distro=$(lsb_release -is)
echo $distro
if [ $distro = Debian ]; then
echo "[ $distro = Debian ]" && echo "Option 1"
elif [ $distro = 'Debian' ]; then
echo "[ $distro =  'Debian' ]" && echo "Option 2"
else
echo "Error"
fi
