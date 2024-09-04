FROM alpine:edge

MAINTAINER Zarklord

ARG VCS_REF

LABEL org.label-schema.description="This docker image implements Network UPS Tools (NUT) ups monitor, which forwards messages to MQTT" \
    org.label-schema.name=nut-monitor \
    org.label-schema.vcs-url=https://github.com/zarklord/docker-nut/tree/master/nut-monitor

RUN apk add nut mosquitto-clients

RUN [ -d /etc/nut ] && find /etc/nut/ -type f -exec rm {} \; || false

ENV GROUP=nut \
    USER=nut \
    MINSUPPLIES=0 \
    MQTT_HOST= \
    MQTT_PORT=1883 \
    MQTT_USERNAME= \
    MQTT_PASSWORD=

COPY etc/nut/* /etc/nut/
COPY --chmod=0755 usr/bin/* /usr/bin/
COPY --chmod=0755 startup.sh /startup.sh
ENTRYPOINT /startup.sh
