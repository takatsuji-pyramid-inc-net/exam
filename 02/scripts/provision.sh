#!/bin/bash
set -eu

yum -y update
yum -y install ntp httpd

sed -i -e "s/Listen 80/Listen 8088/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8088/g" /etc/httpd/conf/httpd.conf

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
    rewrite /images/(.*)$ /assets/\$1;
  }

  location / {
    proxy_pass http://web-apache/;
  }
}
EOT

