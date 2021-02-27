#!/bin/bash
clear
echo "testing if statement"
sleep 1
if [ $lsb_release -is = Debian ]; then
echo "[ $lsb_release -is = Debian ];"
sleep 1
elif [ $lsb_release -is = "Debian" ]; then
echo '[ $lsb_release -is = "Debian" ]';
sleep 1
elif [ $(lsb_release -is) = Debian ]; then
echo '[ $(lsb_release -is) = Debian ]'
sleep 1
elif [ $(lsb_release -is) = "Debian" ]; then
echo '[ $(lsb_release -is) = "Debian" ]'
sleep 1
else
echo "None of the above"
sleep 1
fi

