import pycurl
import subprocess as sp
from io import BytesIO
import os


def _get_vessel_zip_file_from_ddh_ws(url: str):
    buf_io = BytesIO()
    c = pycurl.Curl()
    c.setopt(c.URL, url)
    c.setopt(c.WRITEDATA, buf_io)
    c.perform()
    c.close()
    b = buf_io.getvalue()

    # PK means zip file mime type
    ok = b[:2] == b'PK'
    return ok, b


def _save_file_to_disk(data: bytes):
    file = open("../ddh_ws_client/tmp.zip", "wb")
    rv = file.write(data)
    file.close()
    return len(data) == rv


def _end_if(cond):
    if cond:
        print('error')
        exit(1)


def install_ddh_vessel_files(url):
    print('getting zip file')
    rv = _get_vessel_zip_file_from_ddh_ws(url)
    _end_if(not rv[0])

    print('writing zip file to disk')
    rv = _save_file_to_disk(rv[1])
    _end_if(not rv)

    print('unzipping zip file with overwriting')
    s = 'unzip -o ./tmp.zip'
    rv = sp.run(s, shell=True, stdout=sp.PIPE, stderr=sp.PIPE)
    _end_if(rv.returncode)

    print('detecting file exists')
    rv = os.path.exists('/home/kaz/a.txt')
    _end_if(not rv)


if __name__ == '__main__':
    # content zip file:
    #     - run_ddh.json
    #     - _macs_to_sn.yml
    #     - ddh.json
    vessel_url = 'http://localhost:8080/files/get?ddh=mary'
    install_ddh_vessel_files(vessel_url)

