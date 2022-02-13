#!/usr/bin/env python3

import pycurl
import subprocess as sp
from io import BytesIO
import os
import pathlib


# Paths to Files and Dirs
_PF_TMP = './tmp.zip'
_PDV = pathlib.Path('./_vessel_files')
_PDD = pathlib.Path('/home/pi/li/ddh')


def _banner_success():
    print('Installing vessel: done!')


def _sh(s):
    rv = sp.run(s, shell=True, stdout=sp.PIPE, stderr=sp.PIPE)
    return rv.returncode


def _end_if(cond):
    if cond:
        print('error')
        exit(1)


def _perform_curl_by_url(url: str) -> bytes:
    buf_io = BytesIO()
    c = pycurl.Curl()
    c.setopt(c.URL, url)
    c.setopt(c.WRITEDATA, buf_io)
    c.perform()
    c.close()
    return buf_io.getvalue()


def _list_all_vessel_zip_files_from_ddh_ws():
    print('getting vessel zip file\n')
    url = 'http://localhost:8080/list_vessel_files'
    a = _perform_curl_by_url(url)
    print(a)


def _get_vessel_zip_file_from_ddh_ws():
    url = 'http://localhost:8080/files/get?ddh=mary'
    a = _perform_curl_by_url(url)
    # PK means zip file mime type
    _end_if(a[:2] != b'PK')
    return a


def _save_vessel_zip_file_to_disk(data: bytes):
    print('saving zip file to disk\n')
    os.unlink(_PF_TMP)
    file = open(_PF_TMP, 'wb')
    rv = file.write(data)
    file.close()
    _end_if(len(data) != rv)


def _unzip_vessel_zip_file():
    print('unzipping zip file -> password:')
    # -o: overwrite
    s = 'unzip -o {}'.format(_PF_TMP)
    _end_if(_sh(s))


def _check_vessel_zip_file_contents():
    print('detecting vessel files in zip\n')
    j = os.path.exists(_PDV / 'ddh.json')
    r = os.path.exists(_PDV / 'run_ddh.sh')
    m = os.path.exists(_PDV / '_macs_to_SN.yml')
    _end_if(not(j and r and m))


def _copy_vessel_files_to_ddh_folder():
    print('installing vessel files to ddh\n')
    j = _sh('cp {}/ddh.json {}/settings'.format(_PDV, _PDD))
    r = _sh('cp {}/run_ddh.sh {}'.format(_PDV, _PDD))
    m = _sh('cp {}/_macs_to_SN.yml {}/settings'.format(_PDV, _PDD))
    _end_if(j or r or m)


def main():
    # b = _get_vessel_zip_file_from_ddh_ws()
    # _save_vessel_zip_file_to_disk(b)
    # _unzip_vessel_zip_file()
    # _check_vessel_zip_file_contents()
    # _copy_vessel_files_to_ddh_folder()
    _banner_success()


if __name__ == '__main__':
    # main()
    _list_all_vessel_zip_files_from_ddh_ws()
