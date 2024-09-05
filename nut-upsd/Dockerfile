FROM alpine:latest

RUN apk add nut --no-cache

RUN [ -d /etc/nut ] && find /etc/nut/ -type f -exec rm {} \; || false

COPY ./etc/nut/* /etc/nut/
COPY --chmod=0755 ./entrypoint.sh /entrypoint.sh

EXPOSE 3493
ENV GROUP=nut \
    USER=nut \
    API_USER= \
    API_PASSWORD=

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
