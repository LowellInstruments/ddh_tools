#!/usr/bin/env bash
FOL=/home/pi/li/ddh
VENV=/home/pi/li/venv
VPIP=$VENV/bin/pip


# abort upon any error
clear && echo && set -e
trap 'echo ‘$BASH_COMMAND’ TRAPPED! rv $?' EXIT


read -p "\nDDH Install python: deleting folder + downloaded files. Continue (y/n)? " ch
case "$ch" in
  y|Y ) echo "yes";; n|N ) echo "no"; exit;; * ) echo "invalid"; exit;;
esac
rm -rf $FOL || true


# on RPi, venv needs to inherit PyQt5 installed via apt
printf '\nDDH Install python: virtualenv\n'
rm -rf $VENV || true
python3 -m venv $VENV --system-site-packages
source $VENV/bin/activate
$VPIP install --upgrade pip
$VPIP install wheel
$VPIP install git+https://github.com/LowellInstruments/lowell-mat.git
$VPIP uninstall --yes bluepy
$VPIP install git+https://github.com/LowellInstruments/bluepy.git


printf '\nDDH Install python: cloning from github\n'
git clone https://github.com/LowellInstruments/ddh.git $FOL
$VPIP -r $FOL/requirements.txt


printf '\nDDH Install python: ensuring resolv.conf\n'
sudo chattr -i /etc/resolv.conf
sudo sh -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"
sudo sh -c "echo 'nameserver 8.8.4.4' >> /etc/resolv.conf"
sudo chattr +i /etc/resolv.conf