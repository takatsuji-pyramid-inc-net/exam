#!/bin/bash
set -eu

#yum -y update

# gcc-c++をyumインストール
yum -y install gcc-c++

# ユーザー、グループ、ディレクトリを作成する
useradd -s /sbin/nologin nginx
mkdir /var/run/nginx
mkdir /var/log/nginx
chown nginx:nginx /var/run/nginx/
chown nginx:nginx /var/log/nginx/

useradd -s /sbin/nologin apache
mkdir /var/run/httpd
mkdir /var/log/httpd
chown apache:apache /var/run/httpd/
chown apache:apache /var/log/httpd/

pushd /usr/local/src

#============ nginx ==============

# pcreのソースコードを取得する
wget http://sourceforge.net/projects/pcre/files/pcre/8.38/pcre-8.38.tar.gz
tar zxvf pcre-8.38.tar.gz
# opensslのソースコードを取得する
wget http://www.openssl.org/source/openssl-1.0.2h.tar.gz
tar zxvf openssl-1.0.2h.tar.gz
# zlibのソースコードを取得する
wget http://zlib.net/zlib-1.2.8.tar.gz
tar zxvf zlib-1.2.8.tar.gz
# make & install nginxする
wget http://nginx.org/download/nginx-1.8.1.tar.gz
tar zxvf nginx-1.8.1.tar.gz
pushd ./nginx-1.8.1
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
popd
# キックスクリプトを設定する
cp /var/setting_files/init_nginx /etc/init.d/nginx
chmod +x /etc/init.d/nginx
# confファイルを設定する
cp /var/setting_files/nginx.conf /usr/local/nginx/conf/nginx.conf

#============ apache ==============

# aprのインストールを行う
wget http://www.us.apache.org/dist/apr/apr-1.5.2.tar.gz
tar zxvf apr-1.5.2.tar.gz
pushd ./apr-1.5.2
./configure --prefix=/usr/local/lib/apr
make
make install
popd
# apr-utilのインストールを行う
wget http://www.us.apache.org/dist/apr/apr-util-1.5.4.tar.gz
tar zxvf apr-util-1.5.4.tar.gz
pushd ./apr-util-1.5.4
./configure --prefix=/usr/local/lib/apr-util --with-apr=/usr/local/lib/apr
make
make install
popd
# pcreのインストールを行う(nginxをビルドする際にソースファイルは取得している)
pushd ./pcre-8.38
./configure --prefix=/usr/local/lib/pcre
make
make install
popd
# make & install apache
wget http://ftp.jaist.ac.jp/pub/apache//httpd/httpd-2.4.20.tar.gz
tar zxvf httpd-2.4.20.tar.gz
pushd ./httpd-2.4.20
./configure \
    --prefix=/usr/local/httpd \
    --with-apr=/usr/local/lib/apr \
    --with-apr-util=/usr/local/lib/apr-util \
    --with-pcre=/usr/local/lib/pcre
make
make install
popd
# キックスクリプトを設定する
cp /var/setting_files/init_httpd /etc/rc.d/init.d/httpd
chmod +x /etc/rc.d/init.d/httpd
# confファイルを設定する
cp /var/setting_files/httpd.conf /usr/local/httpd/conf/httpd.conf
cp /var/setting_files/httpd-mpm.conf /usr/local/httpd/conf/extra/httpd-mpm.conf

#============== php ================

# libxml2でpythonのモジュールが必要なようなのでインストールしておく
# python-develのソースからのインストール方法が分からなかったのでとりあえずyumでインストールする
yum -y install python-devel
# libxml2をインストールする
wget http://xmlsoft.org/sources/libxml2-2.9.3.tar.gz
tar zxvf libxml2-2.9.3.tar.gz
pushd ./libxml2-2.9.3
./configure --prefix=/usr/local/lib/libxml2
make
make install
popd
# make & install php
wget http://www.php.net/get/php-5.6.21.tar.gz/from/jp2.php.net/mirror
tar zxvf mirror
pushd ./php-5.6.21
./configure --prefix=/usr/local/php --with-apxs2=/usr/local/httpd/bin/apxs --with-libxml-dir=/usr/local/lib/libxml2
make
make install
popd




popd
