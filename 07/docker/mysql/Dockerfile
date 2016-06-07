FROM gliderlabs/alpine:3.3

COPY startup.sh /startup.sh

RUN apk update && apk-install mysql mysql-client \
    && mkdir /app \
    && chmod +x /startup.sh

WORKDIR /app
VOLUME /app
COPY my.cnf /etc/mysql/my.cnf

CMD [ "/startup.sh" ]

