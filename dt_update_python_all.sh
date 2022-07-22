#!/usr/bin/env bash


FOL_DDT=/home/pi/li/ddh_tools


# -------------------------------------------------------------
# this script "A" CANNOT be called from DDS or DDH folders "F"
# because "A" removes and re-installs "F" itself
# maybe the best place is rc.local :)
# -------------------------------------------------------------


ping -q -c 1 -W 1 www.google.com
rv=$?
if [ $rv -eq 0 ]; then
    echo;  echo 'R > we have internet, updating...'
    $FOL_DDT/dt_update_python_mat.sh
    $FOL_DDT/dt_update_python_ddh_dds.sh
else
    echo; echo 'R > NO internet, NO updating'
fi
