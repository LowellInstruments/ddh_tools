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
    if _sh('timeout 2 ping -c 1 -I wlan0 www.google.com'):
        _p('w')
        return

    if not _sh('/usr/sbin/ifmetric ppp0 400'):
        _p('ifmetric error')
        return

    if _sh('timeout 2 ping -c 1 -I wlan0 www.google.com'):
        _p('w*')
        return

    if not _sh('/usr/sbin/ifmetric ppp0 0'):
        _p('ifmetric 2 error')
        return

    if _sh('timeout 2 ping -c 1 -I ppp0 www.google.com'):
        _p('c')
        return

    print('-')


if __name__ == '__main__':
    while 1:
        main()
        time.sleep(2)
