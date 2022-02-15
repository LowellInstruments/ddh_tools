#!/usr/bin/env bash
FOL=/home/pi/li/ddh
VENV=/home/pi/li/venv
J4H=/home/pi/li/juice4halt


# abort upon any error
clear && echo && set -e
trap 'echo ‘$BASH_COMMAND’ TRAPPED! rv $?' EXIT


printf '\nDDH Install Linux: apt dependencies\n\n'
sudo apt-get update
sudo apt-get -y install xscreensaver matchbox-keyboard ifmetric joe git \
libatlas3-base libglib2.0-dev python3-pyqt5 libhdf5-dev python3-dev \
libgdal-dev libproj-dev proj-data proj-bin python3-gdbm python3-venv \
libcurl4-gnutls-dev gnutls-dev python3-pycurl


printf '\nDDH Install Linux: juice4halt\n\n'
rm -rf $J4H
mkdir -p $J4H/bin
cp _dt_files/shutdown_script.py $J4H/bin/


printf '\nDDH Install Linux: rc.local\n\n'
sudo cp _dt_files/rc.local /etc/rc.local
sudo chmod +x /etc/rc.local
sudo systemctl enable rc-local


printf '\nDDH Install Linux: done!\n\n'