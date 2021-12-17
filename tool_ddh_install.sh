#!/usr/bin/env bash

# =======================================
# to run when building DDH from scratch
# =======================================

# exit on error, keep track of executed commands, print
clear && set -e
trap 'echo ‘$BASH_COMMAND’ trapped! returned code $?' EXIT
printf '\nWelcome to DDH installer'
printf '\n------------------------ \n\n'


read -p ">> Deleting DDH, including downloaded files. Continue (y/n)? " ch
case "$ch" in
  y|Y ) echo "yes";; n|N ) echo "no"; exit;; * ) echo "invalid"; exit;;
esac
if [ -d "/home/pi/li/ddh" ]; then rm -rf /home/pi/li/ddh; fi


printf '\n>> Installing APT dependencies... \n'
sudo apt-get update
sudo apt-get -y install xscreensaver matchbox-keyboard ifmetric joe git
sudo apt-get -y install libatlas3-base libglib2.0-dev python3-pyqt5 libhdf5-dev python3-dev \
    libgdal-dev libproj-dev proj-data proj-bin libgeos-dev python3-gdbm python3-venv


printf '\n>> Installing virtualenv... \n'
VENV=/home/pi/li/venv
rm -rf $VENV || true
# need to inherit some like PyQt5 installed w/apt on Rpi
python3 -m venv $VENV --system-site-packages
source $VENV/bin/activate
$VENV/bin/pip install --upgrade pip
$VENV/bin/pip install wheel
$VENV/bin/pip install git+https://github.com/LowellInstruments/lowell-mat.git
$VENV/bin/pip uninstall --yes bluepy
$VENV/bin/pip install git+https://github.com/LowellInstruments/bluepy.git


printf '\n>> Cloning DDH source from github... \n'
mkdir -p /home/pi/li/ddh
git clone https://github.com/LowellInstruments/ddh.git /home/pi/li/ddh
$VENV/bin/pip install -r /home/pi/li/ddh/requirements.txt


# careful: sudo does not affect redirects, we do it smart
printf '\n>> Installing resolv.conf...'
sudo sh -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"
sudo sh -c "echo 'nameserver 8.8.4.4' >> /etc/resolv.conf"
sudo chattr +i /etc/resolv.conf


printf '\n>> Now you may /home/pi/li/ddh/tools/script_ddh_2_configure.sh \n'
