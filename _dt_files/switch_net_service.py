#!/usr/bin/env python3

import time
import subprocess as sp
import sys


def _p(s):
    print(s)
    # otherwise output not shown in journalctl
    sys.stdout.flush()


def _sh(s: str) -> bool:
    rv = sp.run(s, shell=True, stdout=sp.PIPE, stderr=sp.PIPE)
    return rv.returncode == 0


def main():

    # wi-fi can go internet and we already use it
    wlan_has_via = _sh('timeout 2 ping -c 1 -I wlan0 www.google.com')
    if wlan_has_via and _sh('ip route get 8.8.8.8 | grep wlan0'):
        _p('w')
        return

    # wi-fi cannot go internet, are we really using it
    if not _sh('/usr/sbin/ifmetric ppp0 400'):
        _p('ifmetric error ppp0 400')
        return

    # wi-fi, try again
    if wlan_has_via and _sh('ip route get 8.8.8.8 | grep wlan0'):
        _p('w*')
        return

    # wi-fi does NOT work, make sure we try cell
    if not _sh('/usr/sbin/ifmetric ppp0 0'):
        _p('ifmetric error ppp0 0')
        return

    # check cell can go to internet
    ppp_has_via = _sh('timeout 2 ping -c 1 -I ppp0 www.google.com')
    if ppp_has_via and _sh('ip route get 8.8.8.8 | grep ppp0'):
        _p('c')
        return

    _p('-')


if __name__ == '__main__':
    # see all services -> systemctl list-units --type=service
    while 1:
        main()
        time.sleep(2)