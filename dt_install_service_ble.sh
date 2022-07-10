#!/usr/bin/env bash
LI=/home/pi/li
DDT=$LI/ddh_tools


# abort upon any error
clear && echo && set -e
trap 'echo ‘$BASH_COMMAND’ TRAPPED! rv $?' EXIT


# see service output -> sudo journalctl -f -u unit_dds_ble
echo
echo '-----------------------------------------'

echo 'installing LI DDS BLE service...'
sudo systemctl stop unit_dds_ble.service || true
sudo cp $DDT/_dt_files/unit_dds_ble.service /etc/systemd/system/
sudo chmod 644 /etc/systemd/system/unit_dds_ble.service
sudo systemctl daemon-reload
sudo systemctl disable unit_dds_ble.service
sudo systemctl enable unit_dds_ble.service
sudo systemctl start unit_dds_ble.service

echo '-----------------------------------------'
echo 'done LI DDS install BLE service'
echo
