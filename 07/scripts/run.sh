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

IS_DOCKER_RUNNING=$(is_running docker)
if [ "$IS_DOCKER_RUNNING" == 'true' ]; then
    service docker restart
else
    service docker start
fi

pushd /var/docker > /dev/null

# 各コンテナのビルドを行う
docker build -t takatsuji/my_db:0.0 ./mysql
docker build -t takatsuji/my_fpm:0.0 ./phpfpm
docker build -t takatsuji/my_nginx:0.0 ./nginx

# TODO: --nameオプションは使用しないようにするつもりだったけど、linkどうしよう
#       同名のコンテナが存在するかをifでチェックするか、対象のイメージを持つ生きているコンテナidを取得するか...
#       後回し

# 各コンテナの起動を行う
docker run -d --name my_db takatsuji/my_db:0.0
docker run -d --name my_fpm --link='my_db:mysql' --volume='/wordpress:/var/www/html' takatsuji/my_fpm:0.0
docker run -d --name my_nginx -p 80:80 --link='my_fpm:phpfpm' --volume='/wordpress:/var/www/html' takatsuji/my_nginx:0.0

popd > /dev/null
