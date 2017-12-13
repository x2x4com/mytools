#!/bin/bash

bk_home='/data/backup/nginx'
target='./conf/nginx/nginx.service'
systemd_dir='/lib/systemd/system'
bk=$(date '+%Y%m%d_%H%M%S%N')
nginx_root="/usr/local/nginx"

[ ! -d "$nginx_root" ] && echo "Can not find nginx root" && exit 1
[ ! -f "$target" ] && echo "Can not find $target" && exit 1
[ ! -d "$bk_home" ] && sudo mkdir -p $bk_home
[ -f "$systemd_dir/$target" ] && sudo mv $systemd_dir/$target $bk_home/${target}.$bk
sudo cp $target $systemd_dir/$target
sudo systemctl enable nginx
sudo systemctl status nginx

#copy example config
conf="$nginx_root/conf"
vhosts="$conf/vhosts"
[ ! -d "$vhosts" ] && mkdir -p $vhosts
[ -f "$conf/nginx.conf" ] && mv $conf/nginx.conf $bk_home/nginx.conf.$bk
cp ./conf/nginx/nginx.conf $conf/nginx.conf
[ ! -f "$vhots/www.conf" ] && cp ./conf/nginx/www.conf $vhosts/www.conf

echo "DONE"
