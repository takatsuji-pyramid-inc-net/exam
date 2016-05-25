FROM php:5.6.21-apache

ENV ENTRYKIT_VERSION 0.4.0

# Entrykitをインストールする
RUN apt-get update \
    && apt-get install -y curl \
    && curl -L -O https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && mv entrykit /bin/entrykit \
    && chmod +x /bin/entrykit \
    && entrykit --symlink

COPY ./apache2.conf.tmpl /etc/apache2/apache2.conf.tmpl
COPY ./index.php /var/www/html/index.php

ENTRYPOINT [ "render", "/etc/apache2/apache2.conf", "--", "apache2-foreground" ]

