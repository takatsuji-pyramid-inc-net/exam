#!/bin/bash
set -eu

# dockerをインストールする
if [ ! -e /usr/bin/docker ]; then
    apt-get install -y docker.io
    usermod -aG docker vagrant
fi
# docker-composeをインストールする
if [ ! -e /usr/bin/docker-compose ]; then
    curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > ~/docker-compose
    chmod +x ~/docker-compose 
    mv ~/docker-compose /usr/bin/
fi

# wordpressをダウンロードする
if [ ! -e /usr/local/src/wordpress ]; then
    pushd /usr/local/src > /dev/null
    wget https://ja.wordpress.org/wordpress-4.5.2-ja.tar.gz
    tar zxvf wordpress-4.5.2-ja.tar.gz
    rm wordpress-4.5.2-ja.tar.gz
    cp -r wordpress/* /wordpress
    popd > /dev/null
fi

