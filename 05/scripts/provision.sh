#!/bin/bash
set -eu

# dockerをインストールする
if [ ! -e /usr/bin/docker ]; then
    rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
    yum install -y docker-io
fi
# docker-composeをインストールする
if [ ! -e /usr/bin/docker-compose ]; then
    curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > ~/docker-compose
    chmod +x ~/docker-compose 
    mv ~/docker-compose /usr/bin/
fi

