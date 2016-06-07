FROM gliderlabs/alpine:3.3

ENV ENTRYKIT_VERSION 0.4.0

RUN apk update && apk add nginx

RUN apk add curl \
    && curl -L -O https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && mv entrykit /bin/entrykit \
    && chmod +x /bin/entrykit \
    && entrykit --symlink

COPY ./nginx.conf.tmpl /etc/nginx/nginx.conf.tmpl

ENTRYPOINT [ "render", "/etc/nginx/nginx.conf", "--", "nginx", "-g", "daemon off;" ]

