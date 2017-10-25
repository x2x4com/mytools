#!/bin/bash

common_sh = './common.sh'
file_limit_target='/etc/security/limits.conf'
kernel_para='# Customer
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 1024 65535
# Over'

[ -r $common_sh ] && source $common_sh || echo "Can not read ${common_sh}";exit 127


if [ $UID -ne 0 ]
then
    echo_failed "please run me as root"
    exit 1
fi


[ `/bin/grep -c -P "^\*\s+soft\s+nofile\s+\d+" $file_limit_target` == '0' ] && echo "*         soft   nofile       102400" >> $file_limit_target
[ `/bin/grep -c -P "^\*\s+hard\s+nofile\s+\d+" $file_limit_target` == '0' ] && echo "*         hard   nofile       102400" >> $file_limit_target
[ `/bin/grep -c -P "^\*\s+soft\s+nproc\s+\d+" $file_limit_target` == '0' ] && echo "*         soft   nproc       65535" >> $file_limit_target
[ `/bin/grep -c -P "^\*\s+hard\s+nproc\s+\d+" $file_limit_target` == '0' ] && echo "*         hard   nproc       65535" >> $file_limit_target
[ -f "/etc/security/limits.d/90-nproc.conf" ] && mv /etc/security/limits.d/90-nproc.conf /root/.
[ `/bin/grep -c -e '^# Customer' -e '^# Over' /etc/sysctl.conf` != 2 ] && echo $kernel_para >> /etc/sysctl.conf
/sbin/sysctl -p
