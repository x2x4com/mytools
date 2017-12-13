#!/bin/bash
# Jacky Xu, 2017-03-14

PREFIX="/usr/local/nginx"
CONF="$PREFIX/etc"
TMP="/tmp/install_nginx"
USER="www"
GROUP="www"
TARGET="NGINX"
FILE="nginx-1.13.7.tar.gz"
SOURCE_URL="http://nginx.org/download/nginx-1.13.7.tar.gz"
SOURCE_DIR="nginx-1.13.7"


echo_success() {
    word=$1
    echo -e "\033[32m$word\e[m"
}

echo_failed() {
    word=$1
    echo -e "\033[31m$word\e[m"
}

echo_warning() {
    word=$1
    echo -e "\033[33m$word\e[m"
}

if [ $UID -ne 0 ]
then
    echo_failed "please run me as root"
    exit 1
fi

echo_success "Starting Install $TARGET to $PREFIX"

if [ -d "$PREFIX" ]
then
    echo_failed "$PREFIX existed, exiting..."
    exit 1
fi

echo_success "Step 1: repart your system"

if [ -f "/etc/redhat-release" ]
then
    yum -y install libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gmp gmp-devel libmcrypt libmcrypt-devel readline readline-devel libxslt libxslt-devel
else
    apt-get -y install libxml2 libxml2-dev libssl1.0.0 libssl-dev bzip2 libbz2-dev libcurl3 libcurl4-openssl-dev libjpeg9 libjpeg9-dev libpng3 libpng12-dev libfreetype6 libfreetype6-dev libgmp10 libgmp-dev libmcrypt4 libmcrypt-dev libreadline6 libreadline6-dev libxslt1.1 libxslt1-dev pkg-config libssl-dev libsslcommon2-dev libpcre3 libpcre3-dev libgd-dev libgeoip-dev
fi

if [ -d "$TMP" ]
then
    echo_warning "clean up $TMP"
    if [ "x$TMP" != "x/" ]
    then
        rm -rf $TMP
    fi
fi
mkdir -p $TMP
if [ $? -ne 0 ]
then
    echo_failed "can not create $TMP, exiting..."
    exit 1
fi
cd $TMP

echo_success "Step 2: download $TARGET from internet"
wget -v "$SOURCE_URL" -O $FILE

if [ ! -f "$FILE" ]
then
    echo_failed "download failed, exiting..."
    exit 1
fi

echo_success "Step 3: uncompression $FILE"
tar -zxf $FILE
if [ $? -ne 0 ]
then
    echo_failed "tar -zxf $FILE failed, exiting..."
    exit 1
fi

echo_success "Step 4: compile:configure"
cd $SOURCE_DIR
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_ssl_module
if [ $? -ne 0 ]
then
    echo_failed "compile:configure failed, exiting..."
    exit 1
fi


echo_success "Step 5: search your cpu core"
core=`grep -c '^process' /proc/cpuinfo`
echo_success "your have $core cpu core"
if [ $core -gt 1 ]
then
    let core=$core-1
fi



echo_success "Step 6: compile:make"
make -j$core

if [ $? -ne 0 ]
then
    echo_failed "compile:make failed, exiting..."
    exit 1
fi

echo_success "Step 7: compile:make install"
make install

if [ $? -ne 0 ]
then
    echo_failed "compile:make failed, exiting..."
    if [ -d "$PREFIX" ]
    then
        echo_failed "clean up $PREFIX"
        if [ "x$PREFIX" != "x/" ]
        then
            rm -rf $PREFIX
        fi
    fi
    exit 1
fi

if [ ! -d "$PREFIX" ]
then
    echo_failed "can not locate $PREFIX"
    exit 1
fi


echo_success "install finished"

#install php-redis
#/usr/local/php7/bin/pecl install redis
