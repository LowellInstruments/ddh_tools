#!/usr/bin/env bash
LI=/home/pi/li
DDT=$LI/ddh_tools


# abort upon any error
clear && echo && set -e
trap 'echo ‘$BASH_COMMAND’ TRAPPED! rv $?' EXIT


# see service output -> sudo journalctl -f -u unit_dds_switch_net
echo
echo '-----------------------------------------'

echo 'setting ifmetric permissions...'
sudo setcap 'cap_net_raw,cap_net_admin+eip' /usr/sbin/ifmetric

echo 'installing LI DDS switch_net service...'
sudo systemctl stop unit_dds_switch_net.service || true
sudo cp $DDT/_dt_files/unit_dds_switch_net.service /etc/systemd/system/
sudo chmod 644 /etc/systemd/system/unit_dds_switch_net.service
sudo systemctl daemon-reload
sudo systemctl disable unit_dds_switch_net.service
sudo systemctl enable unit_dds_switch_net.service
sudo systemctl start unit_dds_switch_net.service

echo '-----------------------------------------'
echo 'done LI DDS switch_net service'
echo