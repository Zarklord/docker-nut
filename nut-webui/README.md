# nut-webui

This is the **nut-webui** docker image, which implements the web-based UI for the upsd daemon from https://networkupstools.org/.


## how to use

pull as usual:
 
```
docker pull zarklord/nut-webui[:<tag>]
```

tags:
* **latest** for most recent (but potentially most broken / unstable) build
* other version-specific tags (if any) for frozen / stable builds

then run it as follows:

```
docker run -d \
   -p 80:80 \
   -v /path/to/nut-config:/etc/nut \
   zarklord/nut-webui[:<tag>]
```

## configuration

### ports

This docker runs nginx, and thus exposes the following ports:

* TCP/80 for plain http

### main config for upsstats

For the upsstats CGI tools, you need this configuration file:

* [hosts.conf](https://networkupstools.org/docs/man/hosts.conf.html)
This file cannot be provided through environment variables, 
you have to use a config volume as shown:

1. create the  *hosts.conf* config file with your favorite editor
2. store it into a permanent config directory, e.g. `/data/dockers/nut-webui/config`
3. when running the container, point it mount the config directory as a file into **/etc/nut/hosts.conf**, e.g.
   `-v /data/dockers/nut-webui/config/hosts.conf:/etc/nut/hosts.conf`

**The container will fail to start when no volume is mounted, or not all needed files are present!**

A sample config file is provided for your conventience in the [master repository](https://github.com/zarklord/docker-nut/tree/master/nut-webui/user_files/hosts.conf).
You may use it as a starting point, however I recommed to have a indepth look at the official
[Network UPS Tools](https://networkupstools.org/) documentation.

# Screenshots

![Main View](https://raw.githubusercontent.com/zarklord/docker-nut/master/nut-webui/docs/main.png)

![Detail View](https://raw.githubusercontent.com/zarklord/docker-nut/master/nut-webui/docs/detail.png)