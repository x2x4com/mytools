#!/usr/bin/env python3
# encoding: utf-8
# ===============================================================================
#
#         FILE:  pytelnet
#
#        USAGE:  ./pytelnet
#
#  DESCRIPTION:  mytools
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  x2x4(x2x4@qq.com)
#      COMPANY:  x2x4
#      VERSION:  1.0
#      CREATED:  2018/03/20 13:55
#     REVISION:  ---
# ===============================================================================

import telnetlib
from sys import argv, exit
from socket import error as SE

host = port = timeout = None

try:
    host=argv[1]
    port=argv[2]
except IndexError:
    print("%s host port [timeout]" % argv[0])
    print("default timeout: 10sec")
    exit(1)

try:
    timeout=argv[3]
except IndexError:
    timeout=10

try:
    tn = telnetlib.Telnet(host=host, port=port, timeout=timeout)
except ConnectionError as e:
    print(e)
    exit(0)
except SE as e:
    print(e)
    exit(0)

print("%s:%s is open" % (host, port))


