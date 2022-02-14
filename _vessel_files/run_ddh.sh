r/bin/env bash

# abort upon any error
clear; set -e; echo
trap 'echo ‘$BASH_COMMAND’ TRAPPED, rv $' EXIT


# needed for crontab to access the X-window system
export XAUTHORITY=/home/pi/.Xauthority
export DISPLAY=:0


# fill AWS vars
export DDH_AWS_NAME=p-joaquim
export DDH_AWS_KEY_ID=AKIA2SU3QQX6XSBG25KX
export DDH_AWS_SECRET=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
export DDH_AWS_SNS_TOPIC_ARN=arn:aws:sns:us-east-1:727249356285:demo-kaz-1234567-basics-topic


printf "DDH: setting permissions\n"
VENV=/home/pi/li/venv
BLUEPY_HELPER=$VENV/lib/python3.7/site-packages/bluepy/bluepy-helper
sudo setcap CAP_SYS_TIME+ep /bin/date
sudo setcap 'cap_net_raw,cap_net_admin+eip' /usr/sbin/ifmetric
sudo setcap 'cap_net_raw,cap_net_admin+eip' $BLUEPY_HELPER || true


printf "DDH: running\n"
FOL=/home/pi/li/ddh
sudo chown -R pi:pi $FOL
source $VENV/bin/activate
(cd $FOL && $VENV/bin/python main.py) || exit 1
