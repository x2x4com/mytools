#!/bin/bash
# Jacky Xu, 2017-03-14

PREFIX="/usr/local/php7"
CONF="$PREFIX/etc"
TMP="/tmp/install_php7"
USER="www"
GROUP="www"
TARGET="PHP7"
FILE="php-7.1.18.tar.gz"
SOURCE_URL="http://cn2.php.net/get/php-7.1.18.tar.gz/from/this/mirror"
SOURCE_DIR="php-7.1.18"


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
wget -v "http://cn2.php.net/get/${FILE}/from/this/mirror" -O $FILE

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
./configure --prefix=$PREFIX --with-config-file-path=$CONF --enable-fpm --with-fpm-user=$USER  --with-fpm-group=$GROUP --enable-inline-optimization --disable-debug --disable-rpath --enable-shared  --enable-soap --with-libxml-dir --with-xmlrpc --with-openssl --with-mcrypt --with-mhash --with-pcre-regex --with-sqlite3 --with-zlib --enable-bcmath --with-iconv --with-bz2 --enable-calendar --with-curl --with-cdb --enable-dom --enable-exif --enable-fileinfo --enable-filter --with-pcre-dir --enable-ftp --with-gd --with-openssl-dir --with-jpeg-dir --with-png-dir --with-zlib-dir  --with-freetype-dir --enable-gd-native-ttf --enable-gd-jis-conv --with-gettext --with-gmp --with-mhash --enable-json --enable-mbstring --enable-mbregex --enable-mbregex-backtrack --with-libmbfl --with-onig --enable-pdo --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-zlib-dir --with-pdo-sqlite --with-readline --enable-session --enable-shmop --enable-simplexml --enable-sockets  --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --with-libxml-dir --with-xsl --enable-zip --enable-mysqlnd-compression-support --with-pear --enable-opcache

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

echo_success "Step 8: config $TARGET"
cp php.ini-production $CONF/php.ini && \
cp $CONF/php-fpm.conf.default $CONF/php-fpm.conf && \
cp $CONF/php-fpm.d/www.conf.default $CONF/php-fpm.d/www.conf && \
cp sapi/fpm/init.d.php-fpm /etc/init.d/php7-fpm && \
chmod +x /etc/init.d/php7-fpm

if [ $? -ne 0 ]
then
    echo_success "config $TARGET failed, exiting..."
    exit 1
fi

php_fpm=`netstat -lntp | grep '^tcp' | grep -c php-fpm`

if [ $php_fpm -ne 0 ]
then
    echo_warning "find $php_fpm php-fpm tcp listen port, find max port num"
    max=0
    for i in `netstat -lntp | grep '^tcp' | grep php-fpm | awk '{print $4}' | cut -d ":" -f 2`
    do
        [ $i -gt $max ] && max=$i
    done
    let port=$max+1
    echo_warning "php7-fpm will run at $port"
    sed -i "s/^listen = .*/listen = 127\.0\.0\.1:$port/g" $CONF/php-fpm.d/www.conf
fi

echo_success "install finished, please run /etc/init.d/php7-fpm start"

#install php-redis
#/usr/local/php7/bin/pecl install redis
