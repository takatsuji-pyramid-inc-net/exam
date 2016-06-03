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

