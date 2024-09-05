FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y nut-cgi fcgiwrap nginx-light && \
    apt-get auto-remove && \
    apt-get clean

RUN [ -d /etc/nut ] && find /etc/nut/ -type f -exec rm {} \; || false
RUN [ -f /etc/nginx/sites-enabled/default ] && rm /etc/nginx/sites-enabled/default || false

COPY ./etc/nut/* /etc/nut/
COPY ./etc/nginx/sites-available/* /etc/nginx/sites-available/
COPY --chmod=0755 ./entrypoint.sh /entrypoint.sh

RUN ln -s /etc/nginx/sites-available/nut-default-tcp80 /etc/nginx/sites-enabled/nut-default-tcp80

EXPOSE 80
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
