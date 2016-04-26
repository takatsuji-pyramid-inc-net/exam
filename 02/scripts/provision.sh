#!/bin/bash
set -eu

yum -y update
yum -y install ntp httpd

sed -i -e "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf

echo "ProxyPass /images/ http://localhost:8080/assets/" >> /etc/httpd/conf/httpd.conf
echo "ProxyPassReverse /images/ http://localhost:8080/assets/" >> /etc/httpd/conf/httpd.conf
echo "ProxyPassReverseCookieDomain localhost:5001 localhost:8080" >> /etc/httpd/conf/httpd.conf
echo "ProxyPassReverseCookiePath /images/ /assets/" >> /etc/httpd/conf/httpd.conf
