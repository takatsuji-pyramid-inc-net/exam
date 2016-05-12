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

# start or restart nginx
IS_NGINX_RUNNING=$(is_running nginx)
if [ "$IS_NGINX_RUNNING" == 'true' ]; then
  service nginx restart
else
  service nginx start
fi

# start or restart apache
IS_HTTPD_RUNNING=$(is_running httpd)
if [ "$IS_HTTPD_RUNNING" == 'true' ]; then
  service httpd restart
else
  service httpd start
fi