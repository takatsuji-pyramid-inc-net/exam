#!/bin/bash
set -eu

yum -y update
yum -y install ntp httpd httpd-devel

sed -i -e "s/Listen 80/Listen 8088/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8088/g" /etc/httpd/conf/httpd.conf

mkdir /etc/httpd/modules/mod_rpaf-0.6
pushd /etc/httpd/modules/mod_rpaf-0.6
wget https://raw.github.com/ttkzw/mod_rpaf-0.6/master/mod_rpaf-2.0.c
/usr/sbin/apxs -i -c -n mod_rpaf-2.0.so mod_rpaf-2.0.c
popd
cat << EOT | tee /etc/httpd/conf.d/mod_rpaf.conf > /dev/null
LoadModule rpaf_module modules/mod_rpaf-2.0.so
RPAFenable On
RPAFsethostname On
RPAFproxy_ips 127.0.0.1
RPAFheader X-Forwarded-For
EOT

rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
yum -y install nginx

cat << EOT | tee /etc/nginx/conf.d/r_proxy.conf > /dev/null
upstream web-apache {
  server localhost:8088;
}
server {
  listen       8080;
  server_name  r_proxy_nginx.jp;

  location /images/ {
    root   /var/www/html;
    rewrite /images/(.*)$ /assets/\$1 break;
  }

  location / {
    proxy_set_header  X-Real-IP       \$remote_addr;
    proxy_set_header  X-Forwarded-For \$remote_addr;
    proxy_set_header  Host            \$http_host;
    proxy_pass http://web-apache/;
  }
}
EOT

