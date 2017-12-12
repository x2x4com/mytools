#!/usr/bin/env python
# encoding: utf-8
# ===============================================================================
#
#         FILE:
#
#        USAGE:
#
#  DESCRIPTION:
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (),
#      COMPANY:
#      VERSION:  1.0
#      CREATED:
#     REVISION:  ---
# ===============================================================================

from math import sqrt

class Prime:
    debug = None
    def __init__(self, debug=False):
        self.debug = debug

    def set_debug(self, v):
        self.debug = v

    def is_prime(cls, n, debug=False):
        if cls.debug is None:
            cls.debug = debug
        if n == 1:
            cls.__drop_out("n is 1")
            return False
        for i in range(2, int(sqrt(n)+1)+1):
            cls.__drop_out("sqrt %s = %s" % (n, sqrt(n)))
            cls.__drop_out("%s / %s = %s" % (n, i, n%i))
            if n % i == 0:
                return False
        return  True

    def __drop_out(self, w):
        if (self.debug):
            print(w)
