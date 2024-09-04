FROM alpine:edge

MAINTAINER Zarklord

LABEL org.label-schema.description="This docker image implements Network UPS Tools (NUT) upsd daemon" \
    org.label-schema.name=nut-upsd \
    org.label-schema.vcs-url=https://github.com/zarklord/docker-nut/tree/master/nut-upsd

RUN apk add nut libcrypto1.1 libssl1.1 libusb musl net-snmp-libs

RUN [ -d /etc/nut ] && find /etc/nut/ -type f -exec rm {} \; || false

ENV GROUP=nut \
    USER=nut \
    API_USER= \
    API_PASSWORD=

EXPOSE 3493
COPY etc/nut/* /etc/nut/
COPY --chmod=0755 startup.sh /startup.sh
ENTRYPOINT /startup.sh
