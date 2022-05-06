#!/usr/bin/env bash
LI=/home/pi/li
DDT=$LI/ddh_tools


# abort upon any error
clear && echo && set -e
trap 'echo ‘$BASH_COMMAND’ TRAPPED! rv $?' EXIT


echo
echo '-----------------------------------------'
echo 'DDH Install LI crontab...'
sudo cp $DDT/_dt_files/crontab /etc/crontab
sudo chmod 644 /etc/crontab
echo '-----------------------------------------'
echo 'done DDH Install LI crontab'
echo
