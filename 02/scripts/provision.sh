#!/bin/bash
set -eu

yum -y update
yum -y install ntp httpd

sed -i -e "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf
echo "RewriteLog /var/log/httpd/rewrite.log" >> /etc/httpd/conf/httpd.conf
echo "RewriteLogLevel 9" >> /etc/httpd/conf/httpd.conf
echo "RewriteEngine on" >> /etc/httpd/conf/httpd.conf
echo 'RewriteRule /images/(.*)$ /assets/$1' >> /etc/httpd/conf/httpd.conf
