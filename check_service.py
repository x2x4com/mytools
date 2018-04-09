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
import redis.sentinel
from sys import exit, argv
from os import environ
from collections import OrderedDict
import argparse
import pika
# import lib.MyLog as log
import lib.BashColor as color
import time

queue_name = 'opsTesting'
message = "Hello OtcMaker"
#log.set_logger(level='INFO', console=True)

def check_rmq(args):
    global queue_name,message
    host = environ.get('RMQ_HOST')
    port = environ.get('RMQ_PORT')
    user = environ.get('RMQ_USER')
    password = environ.get('RMQ_PASS')
    if not host: host = args.host
    if not port: port = args.port
    if not user: user = args.user
    if not password: password = args.passwd
    hidden_pass = "*"
    if password:
        hidden_pass = hidden_pass * len(password)
    else:
        hidden_pass = None
    color.cyan("Start to connect RabbitMQ Service")
    color.cyan("Host: %s, Port: %s, User: %s, Passwd: %s" % (host, port, user, hidden_pass))
    credentials = pika.PlainCredentials(user, password)
    print()
    try:
        color.cyan("Check as producer")
        color.cyan("Connect...")
        connection = pika.BlockingConnection(pika.ConnectionParameters(host, port, '/', credentials))
        color.cyan("Channel...")
        channel = connection.channel()
        color.cyan("Queue: %s..." % queue_name)
        channel.queue_declare(queue=queue_name)
        color.cyan("Publish msg: %s..." % message)
        channel.basic_publish(exchange='', routing_key=queue_name, body=message)
        color.cyan("Publish done, close connection...")
        connection.close()
        color.cyan("Producer done")
    except Exception as e:
        color.red(str(e))
        exit(1)
    print()
    try:
        color.cyan("Check as consumer")
        color.cyan("Connect...")
        connection = pika.BlockingConnection(pika.ConnectionParameters(host, port, '/', credentials))
        color.cyan("Channel...")
        channel = connection.channel()
        color.cyan("Queue: %s..." % queue_name)
        channel.queue_declare(queue=queue_name)
        color.cyan("Get message...")
        method_frame, header_frame, body = channel.basic_get(queue=queue_name)
        #color.cyan("%s , %s , %s" %(method_frame, header_frame, body))
        body = body.decode()
        color.cyan()
        if body != message: raise ValueError("%s != %s" %(message, body))
        color.cyan()
    except Exception as e:
        color.red(str(e))
        exit(1)


def check_redis(args):
    host = environ.get('REDIS_HOST')
    port = environ.get('REDIS_PORT')
    user = environ.get('REDIS_USER')
    password = environ.get('REDIS_PASS')
    _sentinel = environ.get('REDIS_SENTINEL')
    if not host: host = args.host
    if not port: port = args.port
    if not user: user = args.user
    if not password: password = args.passwd
    if not _sentinel: _sentinel = args.sentinel
    test = args.test
    hidden_pass = "*"
    if password:
        hidden_pass = hidden_pass * len(password)
    else:
        hidden_pass = None
    sentinel_ip = None
    sentinel_port = None
    sentinel = None
    if _sentinel:
        try:
            (sentinel_ip,sentinel_port) = _sentinel.split(':')
            sentinel_port = int(sentinel_port)
        except Exception:
            color.yellow("Sentinel format error, must ip/domain:port skip")
            sentinel_ip = None
            sentinel_port = None
    color.cyan("Start to connect Redis Service")
    color.cyan("Host: %s, Port: %s, User: %s, Passwd: %s, Sentinel: %s:%s" % (host, port, user, hidden_pass, sentinel_ip, sentinel_port))
    redis_db = redis.Redis(host=host, port=port, db=9, socket_timeout=10)
    try:
        db_info = redis_db.info()
        # print(db_info)
    except Exception as e:
        color.red(str(e))
        exit(1)
    if _sentinel:
        color.cyan("Try to get master from sentinel, ", end="")
        (master_ip, master_port) = redis_get_master(_sentinel, sentinel_ip, sentinel_port)
        color.cyan("Master_IP: %s, Master_Port: %s" %(master_ip, master_port))
    loop = False
    if test: loop = True
    color.cyan("Try to do test set and get, ", end="")
    redis_test(redis_db)
    print()
    count = 1
    time.sleep(2)
    try:
        while loop:
            color.cyan("%s: %s, " % (count, time.strftime("%H:%M:%S",time.localtime(int(time.time())))), end="")
            color.cyan("Set/Get: ", end="")
            redis_test(redis_db)
            if _sentinel:
                color.cyan(", Master:", end="")
                (master_ip, master_port) = redis_get_master(_sentinel, sentinel_ip, sentinel_port)
                color.cyan(" %s:%s" % (master_ip, master_port), end="")
            print()
            count += 1
            time.sleep(2)
    except KeyboardInterrupt:
        color.yellow("\nKeyboard interrupt")
    redis_db.delete("ops:test")
    color.cyan("Done")


def redis_get_master(_sentinel, sentinel_ip, sentinel_port):
    master_ip = None
    master_port = None
    if _sentinel:
        sentinel = redis.sentinel.Sentinel([(sentinel_ip, sentinel_port)], socket_timeout=0.1)
        try:
            [master_ip, master_port] = sentinel.discover_master('mymaster')
        except Exception as e:
            color.red(" (%s) " % str(e), end="")
    return master_ip, master_port


def redis_test(db):
    key = "ops:test"
    val = "online"
    ok = False
    try:
        if db.set(key,val):
            res = db.get(key).decode()
            if res == val:
                ok = True
    except Exception as e:
        color.red(" (%s) " % str(e), end="")
    if ok:
        color.green("Success", end="")
    else:
        color.red("Failed", end="")

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
                        "help": "redis host, env REDIS_HOST will overwrite it",
                        "default": '127.0.0.1',

                    },
                    "port": {
                        "sort": "-P",
                        "long": "--port",
                        "help": "redis port, env REDIS_PORT will overwrite it",
                        "default": '6379',
                    },
                    "user": {
                        "sort": "-u",
                        "long": "--user",
                        "help": "redis port, env REDIS_USER will overwrite it",
                        "default": None,
                    },
                    "pass": {
                        "sort": "-p",
                        "long": "--passwd",
                        "help": "redis port, env REDIS_PASS will overwrite it",
                        "default": None,
                    },
                    "test": {
                        "sort": "-T",
                        "long": "--test",
                        "help": "keep connection and try to get/set some key to redis",
                        "store_true": True,
                        "default": False
                    },
                    "sentinel": {
                        "sort": "-S",
                        "long": "--sentinel",
                        "help": "sentinel ip:port",
                        "default": None
                    }

                }
            },
            "rabbitmq": {
                "help": "rabbitmq service",
                "func": check_rmq,
                "sub": {
                    "host": {
                        "sort": "-H",
                        "long": "--host",
                        "help": "redis host, env RMQ_HOST will overwrite it",
                        "default": '127.0.0.1',

                    },
                    "port": {
                        "sort": "-P",
                        "long": "--port",
                        "help": "redis port, env RMQ_PORT will overwrite it",
                        "default": '5672',
                    },
                    "user": {
                        "sort": "-u",
                        "long": "--user",
                        "help": "redis port, env RMQ_USER will overwrite it",
                        "default": "guest",
                    },
                    "pass": {
                        "sort": "-p",
                        "long": "--passwd",
                        "help": "redis port, env RMQ_PASS will overwrite it",
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
            #sub_group = cmd.add_mutually_exclusive_group()
            for sub in subs.keys():
                not_store = True
                if 'no_prefix' in subs[sub].keys():
                    cmd.add_argument(sub, help=subs[sub]['help'])
                else:
                    if 'store_true' in subs[sub].keys():
                        if subs[sub]['store_true']:
                            cmd.add_argument(subs[sub]['sort'], subs[sub]['long'], help=subs[sub]['help'],
                                                   action="store_true")
                            not_store = False
                    if not_store:
                        cmd.add_argument(subs[sub]['sort'], subs[sub]['long'], help=subs[sub]['help'],
                                               default=subs[sub]['default'])
    args = parser.parse_args()
    if args.action is None:
        parser.print_help()
        exit(1)
    sub_command[args.action]['func'](args)


if __name__ == '__main__':
    main()
