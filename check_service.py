#!/usr/bin/env python3
# encoding: utf-8
# ===============================================================================
#
#         FILE:  check_service.py
#
#        USAGE:  ./check_service.py
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
#      CREATED:  2018/03/20 11:44
#     REVISION:  ---
# ===============================================================================

import redis
from sys import exit, argv
from os import environ
from collections import OrderedDict
import argparse

def check_rmq(args):
    print(args)

def check_redis(args):
    print(args)

def main():
    sub_command = OrderedDict(
        {
            "redis": {
                "help": "redis service",
                "func": check_redis,
                "sub": {
                    "host": {
                        "sort": "-H",
                        "long": "--host",
                        "help": "redis host",
                        "default": '127.0.0.1',

                    },
                    "port": {
                        "sort": "-P",
                        "long": "--port",
                        "help": "redis port",
                        "default": '6379',
                    },
                    "user": {
                        "sort": "-u",
                        "long": "--user",
                        "help": "redis port",
                        "default": None,
                    },
                    "pass": {
                        "sort": "-p",
                        "long": "--pass",
                        "help": "redis port",
                        "default": None,
                    },

                }
            },
            "rabbitmq": {
                "help": "rabbitmq service",
                "func": check_rmq,
                "sub": {
                    "host": {
                        "sort": "-H",
                        "long": "--host",
                        "help": "redis host",
                        "default": '127.0.0.1',

                    },
                    "port": {
                        "sort": "-P",
                        "long": "--port",
                        "help": "redis port",
                        "default": '5672',
                    },
                    "user": {
                        "sort": "-u",
                        "long": "--user",
                        "help": "redis port",
                        "default": "guest",
                    },
                    "pass": {
                        "sort": "-p",
                        "long": "--pass",
                        "help": "redis port",
                        "default": "guest",
                    },

                }
            },
        }
    )
    parser = argparse.ArgumentParser()
    #parser.add_argument("-h", "--host", help="host", default='127.0.0.1')
    #parser.add_argument("-p", "--port", help="port", action="store_true",)
    #group = parser.add_mutually_exclusive_group()
    #group.add_argument("-u", "--hash", help="container hash")
    #group.add_argument("-n", "--name", help="container name")
    sub_parsers = parser.add_subparsers(title="Sub Command", dest="action")
    for action in sub_command.keys():
        cmd = sub_parsers.add_parser(action, help=sub_command[action]['help'])
        subs = sub_command[action].get('sub')
        if subs is not None:
            sub_group = cmd.add_mutually_exclusive_group()
            for sub in subs.keys():
                not_store = True
                if 'store_true' in subs[sub].keys():
                    if subs[sub]['store_true']:
                        sub_group.add_argument(subs[sub]['sort'], subs[sub]['long'], help=subs[sub]['help'], action="store_true")
                        not_store = False
                if not_store:
                    sub_group.add_argument(subs[sub]['sort'], subs[sub]['long'], help=subs[sub]['help'], default=subs[sub]['default'])

    args = parser.parse_args()
    if args.action is None:
        parser.print_help()
        exit(1)
    sub_command[args.action]['func'](args)


if __name__ == '__main__':
    main()
    print("On working, use docker.sh instead")