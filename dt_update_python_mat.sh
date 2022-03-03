#!/usr/bin/env bash
LI=/home/pi/li
VENV=$LI/venv
VPIP=$VENV/bin/pip


# abort upon any error
clear && echo && set -e
trap 'echo ‘$BASH_COMMAND’ TRAPPED! rv $?' EXIT
if [ $PWD != $DDT ]; then echo 'wrong starting folder'; exit 1; fi


printf '\nDDH Update python MAT lib: virtualenv \n'
source $VENV/bin/activate
$VPIP install --no-deps --force-reinstall https://github.com/LowellInstruments/lowell-mat.git


printf '\nDDH Update python: done!\n\n'
