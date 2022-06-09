FROM joseluisq/php-fpm:8.1

LABEL Maintainer="Alex Kostylev <i@akost.dev>"

RUN apk add --no-cache supervisor git

# Configure supervisor
RUN mkdir -p /etc/supervisor.d/
COPY config/supervisord.ini /etc/supervisor.d/supervisord.ini

COPY config/cron /var/spool/cron/crontabs/root

CMD ["supervisord", "-n", "-c", "/etc/supervisor.d/supervisord.ini"]