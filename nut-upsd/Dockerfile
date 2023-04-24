FROM alpine:3.17

MAINTAINER Zarklord

ARG BUILD_DATE
ARG VCS_REF
ARG NUT_VERSION=2.8.0-r4

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.schema-version="1.0" \
    org.label-schema.description="This docker image implements Network UPS Tools (NUT) upsd daemon" \
    org.label-schema.name=nut-upsd \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=https://github.com/zarklord/docker-nut/tree/master/nut-upsd

RUN apk add nut=$NUT_VERSION \
      libcrypto1.1 libssl1.1 libusb musl net-snmp-libs mosquitto-clients

RUN [ -d /etc/nut ] && find /etc/nut/ -type f -exec rm {} \; || false

ENV GROUP=nut \
    USER=nut \
    API_USER= \
    API_PASSWORD= \
    MINSUPPLIES=0 \
    MQTT_HOST= \
    MQTT_PORT=1883 \
    MQTT_USERNAME= \
    MQTT_PASSWORD=

EXPOSE 3493
COPY etc/nut/* /etc/nut/
COPY --chmod=0755 usr/bin/* /usr/bin/
COPY --chmod=0755 startup.sh /startup.sh
ENTRYPOINT /startup.sh
