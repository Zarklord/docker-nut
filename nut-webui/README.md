# nut-webui

This is the **nut-webui** docker image, which implements the web-based monitoring interface for Network UPS Tools (NUT) using Apache2 and `nut-cgi`.

## How to Use

Pull the image:

```bash
docker pull zarklord/nut-webui:latest
```

## Configuration

You can configure `nut-webui` in one of two ways:

### Option 1: Environment Variables (Recommended)

Pass one or more `MONITOR_<NAME>` variables to define the UPS daemons to monitor:

```bash
docker run -d \
  --name nut-webui \
  -p 80:80 \
  -e MONITOR_1="myups@nut-upsd:3493 \"Primary Rack UPS\"" \
  zarklord/nut-webui:latest
```

### Option 2: Config Volume Mount

Mount a custom `hosts.conf` into `/etc/nut/hosts.conf`:

```bash
docker run -d \
  --name nut-webui \
  -p 80:80 \
  -v /path/to/hosts.conf:/etc/nut/hosts.conf:ro \
  zarklord/nut-webui:latest
```

**Example `hosts.conf`:**

```
MONITOR myups@nut-upsd:3493 "Primary Rack UPS"
```

## Docker Compose Example

```yaml
services:
  nut-webui:
    image: zarklord/nut-webui:latest
    container_name: nut-webui
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      - MONITOR_1=myups@nut-upsd:3493 "Primary Rack UPS"
```

## Screenshots

### Main View
![Main View](https://raw.githubusercontent.com/zarklord/docker-nut/main/nut-webui/docs/main.png)

### Detail View
![Detail View](https://raw.githubusercontent.com/zarklord/docker-nut/main/nut-webui/docs/detail.png)