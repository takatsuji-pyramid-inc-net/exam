#!/bin/bash
set -eu

# ユーザーが存在するか調べる
function exists_user() {
    if [ `grep "^$1:" /etc/passwd` == '' ]; then
        echo 'false'
    else
        echo 'true'
    fi
}

# gcc-c++をyumインストールする
#yum -y update
yum -y install gcc-c++

# ユーザー、グループ、ディレクトリを作成する
if [ $( exists_user nginx ) == 'false' ]; then
    useradd -s /sbin/nologin nginx
fi
if [ ! -e /var/run/nginx ]; then
    mkdir /var/run/nginx
    chown nginx:nginx /var/run/nginx/
fi
if [ ! -e /var/log/nginx ]; then
    mkdir /var/log/nginx
    chown nginx:nginx /var/log/nginx/
fi
if [ $( exists_user apache ) == 'false' ]; then
    useradd -s /sbin/nologin apache
fi
if [ ! -e  /var/run/httpd ]; then
    mkdir /var/run/httpd
    chown apache:apache /var/run/httpd/
fi
if [ ! -e  /var/log/httpd ]; then
    mkdir /var/log/httpd
    chown apache:apache /var/log/httpd/
fi

# 各ミドルウェアをビルド、インストールする
pushd /usr/local/src > /dev/null

#============ nginx ==============
# pcreのソースコードを取得する
if [ ! -e ./pcre-8.38 ]; then
    wget http://sourceforge.net/projects/pcre/files/pcre/8.38/pcre-8.38.tar.gz
    tar zxvf pcre-8.38.tar.gz
    rm pcre-8.38.tar.gz
fi
# opensslのソースコードを取得する
if [ ! -e ./openssl-1.0.2h ]; then
    wget http://www.openssl.org/source/openssl-1.0.2h.tar.gz
    tar zxvf openssl-1.0.2h.tar.gz
    rm openssl-1.0.2h.tar.gz
fi
# zlibのソースコードを取得する
if [ ! -e ./zlib-1.2.8 ]; then
    wget http://zlib.net/zlib-1.2.8.tar.gz
    tar zxvf zlib-1.2.8.tar.gz
    rm zlib-1.2.8.tar.gz
fi
# make & install nginxする
if [ ! -e /usr/local/nginx ]; then
    if [ ! -e ./nginx-1.8.1 ]; then
        wget http://nginx.org/download/nginx-1.8.1.tar.gz
        tar zxvf nginx-1.8.1.tar.gz
        rm nginx-1.8.1.tar.gz
    fi
    pushd ./nginx-1.8.1 > /dev/null
    ./configure \
        --prefix=/usr/local/nginx \
        --user=nginx \
        --group=nginx \
        --pid-path=/var/run/nginx/nginx.pid \
        --lock-path=/var/run/nginx/nginx.lock \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-http_ssl_module \
        --without-http_ssi_module \
        --without-http_uwsgi_module \
        --with-http_realip_module \
        --with-pcre=/usr/local/src/pcre-8.38 \
        --with-openssl=/usr/local/src/openssl-1.0.2h \
        --with-zlib=/usr/local/src/zlib-1.2.8
    make
    make install
    popd > /dev/null
    # キックスクリプトを設定する
    cp /var/setting_files/init_nginx /etc/init.d/nginx
    chmod +x /etc/init.d/nginx
fi
# confファイルを設定する(confファイルは変更頻度が高いので毎回更新する)
cp /var/setting_files/nginx.conf /usr/local/nginx/conf/nginx.conf

#============ apache ==============
# aprのインストールを行う
if [ ! -e /usr/local/lib/apr ]; then
    if [ ! -e ./apr-1.5.2 ]; then
        wget http://www.us.apache.org/dist/apr/apr-1.5.2.tar.gz
        tar zxvf apr-1.5.2.tar.gz
        rm apr-1.5.2.tar.gz
    fi
    pushd ./apr-1.5.2 > /dev/null
    ./configure --prefix=/usr/local/lib/apr
    make
    make install
    popd > /dev/null
fi
# apr-utilのインストールを行う
if [ ! -e /usr/local/lib/apr-util ]; then
    if [ ! -e ./apr-util-1.5.4 ]; then
        wget http://www.us.apache.org/dist/apr/apr-util-1.5.4.tar.gz
        tar zxvf apr-util-1.5.4.tar.gz
        rm apr-util-1.5.4.tar.gz
    fi
    pushd ./apr-util-1.5.4 > /dev/null
    ./configure --prefix=/usr/local/lib/apr-util --with-apr=/usr/local/lib/apr
    make
    make install
    popd > /dev/null
fi
# pcreのインストールを行う
if [ ! -e /usr/local/lib/pcre ]; then
    if [ ! -e ./pcre-8.38 ]; then
        wget http://sourceforge.net/projects/pcre/files/pcre/8.38/pcre-8.38.tar.gz
        tar zxvf pcre-8.38.tar.gz
        rm pcre-8.38.tar.gz
    fi
    pushd ./pcre-8.38 > /dev/null
    ./configure --prefix=/usr/local/lib/pcre
    make
    make install
    popd > /dev/null
fi
# make & install apache
if [ ! -e /usr/local/httpd ]; then
    if [ ! -e ./httpd-2.4.20 ]; then
        wget http://ftp.jaist.ac.jp/pub/apache//httpd/httpd-2.4.20.tar.gz
        tar zxvf httpd-2.4.20.tar.gz
        rm httpd-2.4.20.tar.gz
    fi
    pushd ./httpd-2.4.20 > /dev/null
    ./configure \
        --prefix=/usr/local/httpd \
        --with-apr=/usr/local/lib/apr \
        --with-apr-util=/usr/local/lib/apr-util \
        --with-pcre=/usr/local/lib/pcre
    make
    make install
    popd > /dev/null
    # キックスクリプトを設定する
    cp /var/setting_files/init_httpd /etc/rc.d/init.d/httpd
    chmod +x /etc/rc.d/init.d/httpd
fi
# confファイルを設定する(confファイルは変更頻度が高いので毎回更新する)
cp /var/setting_files/httpd.conf /usr/local/httpd/conf/httpd.conf
cp /var/setting_files/httpd-mpm.conf /usr/local/httpd/conf/extra/httpd-mpm.conf

#============== php ================
# libxml2でpythonのモジュールが必要なようなのでインストールしておく
# python-develのソースからのインストール方法が分からなかったのでとりあえずyumでインストールする
yum -y install python-devel
# libxml2をインストールする
if [ ! -e /usr/local/lib/libxml2 ]; then
    if [ ! -e ./libxml2-2.9.3 ]; then
        wget http://xmlsoft.org/sources/libxml2-2.9.3.tar.gz
        tar zxvf libxml2-2.9.3.tar.gz
        rm libxml2-2.9.3.tar.gz
    fi
    pushd ./libxml2-2.9.3 > /dev/null
    ./configure --prefix=/usr/local/lib/libxml2
    make
    make install
    popd > /dev/null
fi
# make & install php
if [ ! -e /usr/local/php ]; then
    if [ ! -e ./php-5.6.21 ]; then
        wget http://www.php.net/get/php-5.6.21.tar.gz/from/jp2.php.net/mirror
        tar zxvf mirror
        rm mirror
    fi
    pushd ./php-5.6.21 > /dev/null
    ./configure --prefix=/usr/local/php --with-apxs2=/usr/local/httpd/bin/apxs --with-libxml-dir=/usr/local/lib/libxml2
    make
    make install
    popd > /dev/null
fi

popd > /dev/null    # popd from /usr/local/src
