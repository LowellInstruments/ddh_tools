#!/usr/bin/env bash
LI=/home/pi/li
DDT=$LI/ddh_tools


# abort upon any error
clear && echo && set -e
trap 'echo ‘$BASH_COMMAND’ TRAPPED! rv $?' EXIT


# see service output -> sudo journalctl -f -u unit_dds_aws_s3
echo
echo '-----------------------------------------'

echo 'installing LI DDS AWS S3 service...'
sudo systemctl stop unit_dds_aws_s3.service || true
sudo cp $DDT/_dt_files/unit_dds_aws_s3.service /etc/systemd/system/
sudo chmod 644 /etc/systemd/system/unit_dds_aws_s3.service
sudo systemctl daemon-reload
sudo systemctl disable unit_dds_aws_s3.service
sudo systemctl enable unit_dds_aws_s3.service
sudo systemctl start unit_dds_aws_s3.service

echo '-----------------------------------------'
echo 'done LI DDS install AWS S3 service'
echo
