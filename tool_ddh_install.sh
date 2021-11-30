#!/usr/bin/env bash

# =======================================
# to run when building DDH from scratch
# =======================================

# exit on error, keep track of executed commands, print
clear && set -e
trap 'echo ‘$BASH_COMMAND’ trapped! returned code $?' EXIT


printf '\nWelcome to DDH installer'
printf '\n------------------------ \n\n'
if [ "$EUID" -ne 0 ]; then printf '\n>> Please run as root \n'; exit; fi


read -p ">> Removing DDH, including downloaded files. Continue (y/n)? " ch
case "$ch" in
  y|Y ) echo "yes";; n|N ) echo "no"; exit;; * ) echo "invalid"; exit;;
esac
if [ -d "/home/pi/li/ddh" ]; then rm -rf /home/pi/li/ddh; fi


printf '\n>> Installing APT dependencies... \n'
apt-get update
apt-get -y install libatlas3-base libglib2.0-dev python3-pyqt5 libhdf5-dev python3-dev \
    libgdal-dev libproj-dev proj-data proj-bin libgeos-dev python3-gdbm python3-venv


printf '\n>> Configuring brightness and date... \n'
chmod 777 /sys/class/backlight/rpi_backlight/brightness || true
chmod 777 /sys/class/backlight/10-0045/brightness || true
setcap CAP_SYS_TIME+ep /bin/date


VENV=/home/pi/li/venv
printf '\n>> Creating virtualenv... \n'
# need to inherit some like PyQt5 installed w/apt on Rpi
python3 -m venv $VENV --system-site-packages
source $VENV/bin/activate
$VENV/bin/pip install --upgrade pip
$VENV/bin/pip install wheel
$VENV/bin/pip install git+https://github.com/LowellInstruments/bluepy.git



printf '\n>> Cloning DDH source from github... \n'
mkdir -p /home/pi/li/ddh
# warning ---> you may want 'master' or 'v3'
git clone https://github.com/LowellInstruments/ddh.git /home/pi/li/ddh
$VENV/bin/pip install -r /home/pi/li/ddh/requirements.txt


printf '\n>> Ensuring good permissions... \n'
chmod -R pi:pi /home/pi/li
setcap 'cap_net_raw,cap_net_admin+eip' /home/pi/.local/lib/python3.7/site-packages/bluepy/bluepy-helper


printf '\n>> Now you may /home/pi/li/ddh/tools/script_ddh_2_configure.sh \n'
