#!/usr/bin/env bash
LI=/home/pi/li
DDT=$LI/ddh_tools
FOL=$LI/ddh
DLF=$FOL/dl_files
VENV=$LI/venv
VPIP=$VENV/bin/pip
TSTAMP=/tmp/dl_files_$(date +%Y%M%d-%H%M%S)
DONE_BAK=0


# abort upon any error
clear && echo && set -e
trap 'echo ‘$BASH_COMMAND’ TRAPPED! rv $?' EXIT
if [ $PWD != $DDT ]; then echo 'wrong starting folder'; exit 1; fi


printf '\nDDH: Install python: backup existing dl_files to %s\n' "$TSTAMP"
if [ -d $DLF ]; then cp -r $DLF $TSTAMP; DONE_BAK=1; fi


printf '\nDDH Install python: uninstalling old DDH \n '
if [ -d $FOL ]; then rm -rf $FOL; fi


# on RPi, venv needs to inherit PyQt5 installed via apt
printf '\nDDH Install python: virtualenv \n'
rm -rf $VENV || true
python3 -m venv $VENV --system-site-packages
source $VENV/bin/activate
$VPIP install --upgrade pip
$VPIP install wheel


printf '\nDDH Install python: cloning from github \n'
git clone https://github.com/LowellInstruments/ddh.git $FOL -b loop
$VPIP install -r $FOL/requirements.txt
$VPIP uninstall --yes bluepy
$VPIP install git+https://github.com/LowellInstruments/bluepy.git
$VPIP install -r $FOL/requirements_added.txt || true


printf '\nDDH Install python: bluepy permissions, also done other places \n'
BLUEPY_HELPER=$VENV/lib/python3.7/site-packages/bluepy/bluepy-helper
sudo setcap 'cap_net_raw,cap_net_admin+eip' $BLUEPY_HELPER


# X/. means the content excluding the folder X
printf '\nDDH: Install python: restoring dl_files from /tmp\n'
if [ $DONE_BAK -eq 1 ]; then mkdir $DLF || true; cp -r $TSTAMP/. $DLF; fi


printf '\nDDH Install python: ensuring resolv.conf \n'
sudo chattr -i /etc/resolv.conf
sudo sh -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"
sudo sh -c "echo 'nameserver 8.8.4.4' >> /etc/resolv.conf"
sudo chattr +i /etc/resolv.conf


printf '\nDDH Install python: done!\n\n'
