#!/bin/bash
set -eu

function is_running() {
	SERVICE_NAME=$1
	IS_SERVICE_RUNNING=$(service $SERVICE_NAME status | grep "running")
	if [ "$IS_SERVICE_RUNNING" == "" ]; then
		echo 'false'
	else
		echo 'true'
	fi
}

if [ "$1" != '' ]; then
    sed -i -e "s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf
    cat << EOT | tee /var/www/html/.htaccess > /dev/null
    AuthUserFile /etc/httpd/conf/.htpasswd
    AuthGroupFile /dev/null
    AuthName "input your id and passwd"
    AuthType Basic
    require valid-user
EOT
    htpasswd -c -b /etc/httpd/conf/.htpasswd "$1" "$2"
else
    sed -i -e "s/AllowOverride All/AllowOverride None/g" /etc/httpd/conf/httpd.conf
fi

IS_HTTPD_RUNNING=$(is_running httpd)
if [ "$IS_HTTPD_RUNNING" == 'true' ]; then
  service httpd restart
else
  service httpd start
fi
