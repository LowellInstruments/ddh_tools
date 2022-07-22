#!/usr/bin/env bash


# abort upon any error
echo && echo && set -e
trap 'echo "$BASH_COMMAND" TRAPPED! rv $?' EXIT


printf '\n\n\n---- Update DDH and DDS ----\n'


# backup existing DDH configuration
printf 'U > backup\n'
FS=/home/pi/li/dds
FSB=/tmp/dds_backup
rm -rf $FSB || true
mkdir -p $FSB
cp -r $FS/dl_files $FSB
cp $FS/dds_run.sh $FSB           # this has the AWS keys
cp $FS/settings/ddh.json $FSB    # this has the DDH MACS to monitor
cp $FS/settings/_macs_to_sn.yml $FSB || true


# try to pull DDH & DDS from git
printf 'U > uninstall\n'
rm -rf /tmp/git* || true
FHG=/tmp/git_ddh
FSG=/tmp/git_dds



printf 'U > clone from github\n'
git clone -b v4 https://github.com/lowellinstruments/ddh.git "$FHG"
git clone https://github.com/lowellinstruments/dds.git "$FSG"


# restore configuration we backed up before
printf 'U > restore backup\n'
cp -r $FSB/dl_files $FSG
cp $FSB/dds_run.sh "$FSG"/dds_run.sh
cp $FSB/ddh.json "$FSG"/settings
cp $FSB/_macs_to_sn.yml "$FSG"/settings 2> /dev/null || true


# we reached here, we are doing well
printf 'U > install\n'
FH=/home/pi/li/ddh
rm -rf $FH
rm -rf $FS
mv $FHG $FH
mv $FSG $FS


echo; echo 'U > DDH and DDS finished'
