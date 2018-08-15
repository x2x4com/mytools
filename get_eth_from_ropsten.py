#!/usr/bin/env python
# encoding: utf-8
# ===============================================================================
#
#         FILE:  get_eth_from_ropsten
#
#        USAGE:  ./get_eth_from_ropsten
#
#  DESCRIPTION:  blockscanner
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  x2x4(x2x4@qq.com)
#      COMPANY:  x2x4
#      VERSION:  1.0
#      CREATED:  2018/08/15 16:13
#     REVISION:  ---
# ===============================================================================

try:
    from urllib import request
    from urllib.error import HTTPError, URLError
except ImportError:
    import urllib2 as request
    from urllib2 import HTTPError, URLError


from sys import argv, exit
from time import sleep
from datetime import datetime
import json

address = None
try:
    address = argv[1]
except IndexError:
    print('address must define')
    exit(1)

url = 'http://faucet.ropsten.be:3001/donate/%s' % address

while True:
    print('{time} UTC, New looping start'.format(time=str(datetime.utcnow())))
    sleep_time = 10000
    try:
        req = request.urlopen(url)
        code = req.code
        rt = req.read()
        print('Request done, code: %s, rt: %s' % (code, rt))
    except HTTPError as e:
        code = e.code
        msg = e.msg
        rt = e.fp.read()
        if type(rt) == bytes:
            rt = rt.decode()
        print('Request done, code: %s, msg: %s, rt: %s' % (code, msg, rt))
        try:
            rt = json.loads(rt)
            sleep_time = rt['duration']
        except Exception as e:
            print('Unknow error')
            print(e)
    except Exception as e:
        print('Unknow error')
        print(e)
    sleep_time = sleep_time / 1000.0
    print('sleep %s' % sleep_time)
    sleep(sleep_time)


