FROM gliderlabs/alpine:3.3

RUN apk update && apk add php-fpm \
    && sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php/php-fpm.conf \
    && sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php/php-fpm.conf \
    && sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php/php.ini \
    && mkdir -p /var/www/html

WORKDIR /var/www/html

CMD [ "/usr/bin/php-fpm" ]

