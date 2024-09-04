FROM alpine:edge

RUN apk add nut mosquitto-clients --no-cache

RUN [ -d /etc/nut ] && find /etc/nut/ -type f -exec rm {} \; || false

ENV GROUP=nut \
    USER=nut \
    MINSUPPLIES=0 \
    MQTT_HOST= \
    MQTT_PORT=1883 \
    MQTT_USERNAME= \
    MQTT_PASSWORD=

COPY ./etc/nut/* /etc/nut/
COPY --chmod=0755 ./usr/bin/* /usr/bin/
COPY --chmod=0755 ./startup.sh /startup.sh
ENTRYPOINT /startup.sh
