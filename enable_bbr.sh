#!/bin/bash

kernel_1=$(uname -r | cut -d '.' -f 1)
kernel_2=$(uname -r | cut -d '.' -f 2)
common_sh='./common.sh'


if [ -r "$common_sh" ]
then
    source $common_sh
else
    echo "Can not read ${common_sh}"
    exit 127
fi


if [ $UID -ne 0 ]
then
    echo_failed "please run me as root"
    exit 1
fi

[ $kernel_1 -lt 4 ] && echo_failed "kernel must >= 4.x.x"
if [ $kernel_1 -eq 4 ]
then
    if [ $kernel_2 -lt 9 ]
    then
        echo_failed "kernel must >= 4.9.x"
        exit 1
    fi
fi


[ $(lsmod | grep -c bbr) -eq 0 ] && modprobe tcp_bbr
if [ $(lsmod | grep -c bbr) -eq 0 ]
then
    echo_failed "Can not enable mod tcp_bbr, please check"
    exit 1
fi

[ $(grep -c "^tcp_bbr" /etc/modules-load.d/modules.conf) -eq 0 ] && echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
[ $(grep -c '^net.core.default_qdisc=fq' /etc/sysctl.conf) -eq 0 ] && echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
[ $(grep -c '^net.ipv4.tcp_congestion_control=bbr' /etc/sysctl.conf) -eq 0 ] && echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

sysctl -p 2>&1 >>/dev/null

sysctl net.ipv4.tcp_available_congestion_control
sysctl net.ipv4.tcp_congestion_control
