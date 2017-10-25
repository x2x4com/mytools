#!/bin/bash

common_sh='./common.sh'
file_limit_target='/etc/security/limits.conf'
kernel_para='# Customer\nnet.ipv4.conf.default.rp_filter = 1\nnet.ipv4.conf.default.accept_source_route = 0\nkernel.sysrq = 0\nkernel.core_uses_pid = 1\nnet.ipv4.tcp_syncookies = 1\nkernel.msgmnb = 65536\nkernel.msgmax = 65536\nkernel.shmmax = 68719476736\nkernel.shmall = 4294967296\nnet.ipv4.tcp_max_tw_buckets = 6000\nnet.ipv4.tcp_sack = 1\nnet.ipv4.tcp_window_scaling = 1\nnet.ipv4.tcp_rmem = 4096 87380 4194304\nnet.ipv4.tcp_wmem = 4096 16384 4194304\nnet.core.wmem_default = 8388608\nnet.core.rmem_default = 8388608\nnet.core.rmem_max = 16777216\nnet.core.wmem_max = 16777216\nnet.core.netdev_max_backlog = 262144\nnet.core.somaxconn = 262144\nnet.ipv4.tcp_max_orphans = 3276800\nnet.ipv4.tcp_max_syn_backlog = 262144\nnet.ipv4.tcp_timestamps = 0\nnet.ipv4.tcp_synack_retries = 1\nnet.ipv4.tcp_syn_retries = 1\nnet.ipv4.tcp_tw_recycle = 1\nnet.ipv4.tcp_tw_reuse = 1\nnet.ipv4.tcp_mem = 94500000 915000000 927000000\nnet.ipv4.tcp_fin_timeout = 1\nnet.ipv4.tcp_keepalive_time = 1200\nnet.ipv4.ip_local_port_range = 1024 65535\n# Over'

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


[ $(/bin/grep -c -P "^\*\s+soft\s+nofile\s+\d+" /etc/security/limits.conf) -eq 0 ] && echo "*         soft   nofile       102400" >> $file_limit_target
[ $(/bin/grep -c -P "^\*\s+hard\s+nofile\s+\d+" /etc/security/limits.conf) -eq 0 ] && echo "*         hard   nofile       102400" >> $file_limit_target
[ $(/bin/grep -c -P "^\*\s+soft\s+nproc\s+\d+" /etc/security/limits.conf) -eq 0 ] && echo "*         soft   nproc       65535" >> $file_limit_target
[ $(/bin/grep -c -P "^\*\s+hard\s+nproc\s+\d+" /etc/security/limits.conf) -eq 0 ] && echo "*         hard   nproc       65535" >> $file_limit_target
[ -f "/etc/security/limits.d/90-nproc.conf" ] && mv /etc/security/limits.d/90-nproc.conf /root/.
[ $(/bin/grep -c -e '^# Customer' -e '^# Over' /etc/sysctl.conf) -ne 2 ] && echo -e $kernel_para >> /etc/sysctl.conf
/sbin/sysctl -p
