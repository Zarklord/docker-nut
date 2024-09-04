FROM alpine:edge

RUN apk add nut --no-cache

RUN [ -d /etc/nut ] && find /etc/nut/ -type f -exec rm {} \; || false

ENV GROUP=nut \
    USER=nut \
    API_USER= \
    API_PASSWORD=

EXPOSE 3493
COPY ./etc/nut/* /etc/nut/
COPY --chmod=0755 ./startup.sh /startup.sh
ENTRYPOINT /startup.sh
