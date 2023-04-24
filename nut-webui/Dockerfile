FROM bitnami/minideb

MAINTAINER Zarklord
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.schema-version="1.0" \
    org.label-schema.description="This is the nut-webui docker image, which implements the web-based UI for Network UPS Tools (NUT)" \
    org.label-schema.name=nut-webui \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=https://github.com/zarklord/docker-nut/tree/master/nut-webui

RUN apt-get update && \
    apt-get install -y nut-cgi fcgiwrap nginx-light busybox && \
    apt-get auto-remove && \
    apt-get clean

RUN [ -d /etc/nut ] && find /etc/nut/ -type f -exec rm {} \; || false
RUN [ -d /etc/nginx/sites-available ] && find /etc/nginx/sites-available -type f -exec rm {} \; || false
RUN [ -d /etc/nginx/sites-enabled ] && find /etc/nginx/sites-enabled -type f -exec rm {} \; || false

HEALTHCHECK --interval=10s --timeout=5s \
    CMD /healthcheck.sh

ENV GROUP=nut \
    USER=nut

EXPOSE 80
COPY etc/nut/* /etc/nut/
COPY etc/nginx/sites-available/* /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/nut-default-tcp80 /etc/nginx/sites-enabled/nut-default-tcp80
COPY --chmod=0755 startup.sh /startup.sh
COPY --chmod=0755 healthcheck.sh /healthcheck.sh
ENTRYPOINT /startup.sh
