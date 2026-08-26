FROM debian:stable-slim

ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2

RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    nut-cgi \
    && rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/nut/* \
    /etc/apache2/sites-available/000-default.conf \
    /etc/apache2/conf-available/servername.conf

COPY --chown=www-data:www-data ./etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY --chown=www-data:www-data ./etc/apache2/conf-available/servername.conf /etc/apache2/conf-available/servername.conf
COPY --chown=www-data:www-data ./etc/nut/* /etc/nut/
COPY --chmod=0755 ./entrypoint.sh /entrypoint.sh

RUN a2enconf servername && \
    a2enmod cgi remoteip && \
    chown -R www-data:www-data /usr/lib/cgi-bin/nut /usr/share/nut/www && \
    chmod -R 755 /usr/lib/cgi-bin/nut

EXPOSE 80
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/entrypoint.sh"]
