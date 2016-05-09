#!/bin/bash
set -eu

yum -y update
yum -y install httpd

sed -i -e "s/Listen 80$/Listen 8080/g" /etc/httpd/conf/httpd.conf
sed -i -e "s/#ServerName www.example.com:80/ServerName localhost:8080/g" /etc/httpd/conf/httpd.conf

chmod 755 /var/log/httpd

curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh

cat << EOT >> /etc/td-agent/td-agent.conf
<source>
    type tail
    format apache
    path /var/log/httpd/access_log
    pos_file /var/log/td-agent/apache_access_log.pos
    tag apache.access
</source>
<match apache.access>
    type file
    path /var/www/html/logs/apache_access.log
    flush_interval 1s
</match>
<source>
    type tail
    format /^(\[(?<time>[^\]]*)\] \[(?<level>[^\]]+)\] (\[client (?<host>[^\]]*)\] )?(?<message>.*)|(?<message>.*))$/
    path /var/log/httpd/error_log
    pos_file /var/log/td-agent/apache_error_log.pos
    tag apache.error
</source>
<match apache.error>
    type file
    path /var/www/html/logs/apache_error.log
    flush_interval 1s
</match>
EOT
