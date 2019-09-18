#!/bin/bash

bk_home='/data/backup/nginx'
target='nginx.service'
systemd_dir='/lib/systemd/system'
bk=$(date '+%Y%m%d_%H%M%S%N')
nginx_root="/usr/local/nginx"

[[ ${UID} -ne 0 ]] && echo "Require root to run" && exit 1
[ ! -d "$nginx_root" ] && echo "Can not find nginx root" && exit 1
[ ! -f "./conf/nginx/$target" ] && echo "Can not find ./conf/nginx/$target" && exit 1
[ ! -d "$bk_home" ] && mkdir -p $bk_home
[ -f "$systemd_dir/$target" ] && mv $systemd_dir/$target $bk_home/${target}.$bk
# cp ./conf/nginx/$target $systemd_dir/$target
curl 'https://gitee.com/x2x4/mytools/raw/master/conf/nginx/nginx.service' -o $systemd_dir/$target
systemctl enable nginx
systemctl status nginx

#copy example config
conf="$nginx_root/conf"
vhosts="$conf/vhosts"
[ ! -d "$vhosts" ] && mkdir -p $vhosts
[ -f "$conf/nginx.conf" ] && mv $conf/nginx.conf $bk_home/nginx.conf.$bk
# cp ./conf/nginx/nginx.conf $conf/nginx.conf
curl 'https://gitee.com/x2x4/mytools/raw/master/conf/nginx/nginx.conf' -o $conf/nginx.conf
# [ ! -f "$vhots/www.conf" ] && cp ./conf/nginx/www.conf $vhosts/www.conf
[ ! -f "$vhots/www.conf" ] && curl 'https://gitee.com/x2x4/mytools/raw/master/conf/nginx/www.conf' -o $vhosts/www.conf

echo "DONE, Please modify $vhosts/www.conf |DOMAIN| to your domain and |SITE| to your site root"
