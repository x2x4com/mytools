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
#import colorama
#colorama 在持续输出的时候会很卡，自己写颜色

# 字体颜色
Fore = {
    "BLACK": '\033[30m',
    'RED': '\033[31m',
    'GREEN': '\033[32m',
    'YELLOW': '\033[33m',
    'BLUE': '\033[34m',
    'MAGENTA': '\033[35m',
    'CYAN': '\033[36m',
    'WHITE': '\033[37m',
    'RESET': '\033[39m',
}

#背景色
Back = {
    "BLACK": '\033[40m',
    'RED': '\033[41m',
    'GREEN': '\033[42m',
    'YELLOW': '\033[43m',
    'BLUE': '\033[44m',
    'MAGENTA': '\033[45m',
    'CYAN': '\033[46m',
    'WHITE': '\033[47m',
    'RESET': '\033[49m',
}

# DIM, NORMAL, BRIGHT, RESET_ALL
Style = {
    "DIM": {
        "START": "\033[2m",
        "END": "\033[22m",
    },
    "NORMAL": {
        "START": None,
        "END": None
    },
    "BRIGHT": {
        "START": "\033[1m",
        "END": "\033[21m",
    },
    "RESET_ALL": {
        "START": "\033[0m",
        "END": None,
    },
    "BLINK" : {
        "START": "\033[5m",
        "END": "\033[25m",
    }

}

def red(msg, end="\n"):
    return print(Fore['RED'] + msg + Fore['RESET'], end=end)

def green(msg, end="\n"):
    return print(Fore['GREEN'] + msg + Fore['RESET'], end=end)

def blue(msg, end="\n"):
    return print(Fore['BLUE'] + msg + Fore['RESET'], end=end)

def yellow(msg, end="\n"):
    return print(Fore['YELLOW'] + msg + Fore['RESET'], end=end)

def magenta(msg, end="\n"):
    return print(Fore['MAGENTA'] + msg + Fore['RESET'], end=end)

def cyan(msg, end="\n"):
    return print(Fore['CYAN'] + msg + Fore['RESET'], end=end)

def white(msg, end="\n"):
    return print(Fore['WHITE'] + msg + Fore['RESET'], end=end)

def bright_red(msg, end="\n"):
    return print(Style['BRIGHT']['START'] + Fore['RED'] + msg + Fore['RESET'] + Style['BRIGHT']['END'], end=end)

def bright_green(msg, end="\n"):
    return print(Style['BRIGHT']['START'] + Fore['GREEN'] + msg + Fore['RESET'] + Style['BRIGHT']['END'], end=end)

def bright_blue(msg, end="\n"):
    return print(Style['BRIGHT']['START'] + Fore['BLUE'] + msg + Fore['RESET'] + Style['BRIGHT']['END'], end=end)

def bright_yellow(msg, end="\n"):
    return print(Style['BRIGHT']['START'] + Fore['YELLOW'] + msg + Fore['RESET'] + Style['BRIGHT']['END'], end=end)

def bright_magenta(msg, end="\n"):
    return print(Style['BRIGHT']['START'] + Fore['MAGENTA'] + msg + Fore['RESET'] + Style['BRIGHT']['END'], end=end)

def bright_cyan(msg, end="\n"):
    return print(Style['BRIGHT']['START'] + Fore['CYAN'] + msg + Fore['RESET'] + Style['BRIGHT']['END'], end=end)

def bright_white(msg, end="\n"):
    return print(Style['BRIGHT']['START'] + Fore['WHITE'] + msg + Fore['RESET'] + Style['BRIGHT']['END'], end=end)
