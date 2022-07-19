#!/usr/bin/env bash


VENV=/home/pi/li/venv
VPIP=$VENV/bin/pip


source $VENV/bin/activate
$VPIP install --no-deps --force-reinstall git+https://github.com/LowellInstruments/lowell-mat.git@v4
