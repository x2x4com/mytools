#!/bin/bash



sudo apt-get update && sudo apt-get install shadowsocks pwgen
mkdir ~/shadowsocks && cd ~/shadowsocks

server_ip="192.168.1.1"
port="38388"
method="aes-256-cfb"
#password=$(dd if=/dev/urandom bs=1 count=16 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev)

password=$(pwgen -c -n 16 1)

echo $password

cat <<EOF >shadowsocks.json
{
    "server":"0.0.0.0",
    "server_port":$port,
    "password":"$password",
    "timeout":600,
    "method":"$method"
}
EOF

cat <<EOF >ss.sh
#!/bin/bash

nohup ssserver -c shadowsocks.json &
EOF

chmod +x ss.sh

echo "Start Shadowsocks"
bash ss.sh

echo "Plain URI"
uri="$method:$password@$server_ip:$port"
echo "ss://$uri"

echo "Base64 URI"
b64uri=$(cat $uri | base64)
echo "ss://$b64uri"
