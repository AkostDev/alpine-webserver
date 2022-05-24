FROM php:8.1-fpm-alpine3.15

LABEL Maintainer="Alex Kostylev <i@akost.dev>"

RUN apk add --no-cache zip unzip nginx supervisor git tzdata

# Installing composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm -rf composer-setup.php

# Configure supervisor
RUN mkdir -p /etc/supervisor.d/
COPY config/supervisord.ini /etc/supervisor.d/supervisord.ini

# Configure nginx
COPY config/nginx.conf /etc/nginx/
RUN mkdir -p /run/nginx/ \
    && touch /run/nginx/nginx.pid \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN set -ex && apk --no-cache add postgresql-dev
RUN docker-php-ext-install pgsql pdo_mysql pdo_pgsql

RUN apk add --no-cache msmtp libzip libpng libjpeg-turbo libwebp freetype
RUN apk add --no-cache --virtual build-essentials \
    icu-dev icu-libs zlib-dev automake libzip-dev \
    libpng-dev libwebp-dev libjpeg-turbo-dev freetype-dev && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install gd && \
    docker-php-ext-install exif && \
    docker-php-ext-install zip

COPY config/cron /var/spool/cron/crontabs/root

EXPOSE 80
CMD ["supervisord", "-n", "-c", "/etc/supervisor.d/supervisord.ini"]