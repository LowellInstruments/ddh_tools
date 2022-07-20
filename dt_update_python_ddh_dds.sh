#!/usr/bin/env bash


# abort upon any error
echo && echo && set -e
trap 'echo "$BASH_COMMAND" TRAPPED! rv $?' EXIT


printf '\n\n\n---- Update DDH and DDS ----\n'


# backup existing DDH configuration
printf 'U > backup\n'
FOL_DDH=/home/pi/li/ddh
FOL_DDS=/home/pi/li/dds
BAK=/tmp/bak_ddh
rm -rf $BAK || true
mkdir -p $BAK
cp -r $FOL_DDS/dl_files $BAK
cp $FOL_DDH/scripts/_ddh_run.sh $BAK  # this has the AWS keys
cp $FOL_DDS/settings/ddh.json $BAK    # this has the DDH MACS to monitor
cp $FOL_DDS/settings/_macs_to_sn.yml $BAK || true


# try to pull DDH & DDS from git
printf 'U > uninstall\n'
rm -rf /tmp/git* || true
FOL_DDH_GIT=/tmp/git_ddh
FOL_DDS_GIT=/tmp/git_dds



printf 'U > clone from github\n'
git clone -b v4 https://github.com/lowellinstruments/ddh.git "$FOL_DDH_GIT"
git clone https://github.com/lowellinstruments/dds.git "$FOL_DDS_GIT"


# restore configuration we backed up before
printf 'U > restore backup\n'
cp -r $BAK/dl_files "$FOL_DDS_GIT"
cp $BAK/_ddh_run.sh "$FOL_DDH_GIT"/scripts/_ddh_run.sh
cp $BAK/ddh.json "$FOL_DDS"/settings
cp $BAK/_macs_to_sn.yml "$FOL_DDS"/settings 2> /dev/null || true


# we reached here, we are doing well
printf 'U > install\n'
rm -rf $FOL_DDH
rm -rf $FOL_DDS
mv "$FOL_DDH_GIT" $FOL_DDH
mv "$FOL_DDS_GIT" $FOL_DDS


echo; echo 'U > DDH and DDS finished'
