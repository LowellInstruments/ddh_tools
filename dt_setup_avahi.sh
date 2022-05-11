#!/usr/bin/env bash
DDT=/home/pi/li/ddh_tools


# abort upon any error
clear && echo && set -e
trap 'echo ‘$BASH_COMMAND’ TRAPPED! rv $?' EXIT


echo
echo '-----------------------------------------'
echo 'DDH setup AVAHI...'
if [ "$#" -ne 1 ]; then
    echo "dt_install_avahi -> needs one parameter"
    exit 1
fi
LEN=$(expr length "$1")
if [ "$LEN" -ne 7 ]; then
    echo "parameter length must be 7"
    exit 1
fi

SED_STR="s/host-name=.*/host-name=ddh_$1/"
echo "setting AVAHI name as:"
echo "    $SED_STR"
sed -i "$SED_STR" $DDT/_dt_files/avahi-daemon.conf
sudo cp $DDT/_dt_files/avahi-daemon.conf /etc/avahi/
sudo systemctl restart avahi-daemon.service
echo '-----------------------------------------'
echo 'done DDH setup AVAHI'
echo
