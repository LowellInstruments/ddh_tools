#!/usr/bin/env bash
VENV=/home/pi/li/venv
VPIP=$VENV/bin/pip


# abort upon any error
clear && echo && set -e
trap 'echo ‘$BASH_COMMAND’ TRAPPED! rv $?' EXIT


printf '\nDDH Update python MAT lib: virtualenv \n'
source $VENV/bin/activate
$VPIP install --no-deps --force-reinstall git+https://github.com/LowellInstruments/lowell-mat.git


printf '\nDDH Update python: done!\n\n'
