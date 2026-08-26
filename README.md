# docker-nut

Dockerized [Network UPS Tools (NUT)](https://networkupstools.org/) suite for monitoring and managing Uninterruptible Power Supplies (UPS).

This repository contains 3 focused Docker containers that can be used individually or together:

| Image | Registry (Docker Hub / GHCR) | Description |
| :--- | :--- | :--- |
| **[nut-upsd](nut-upsd/README.md)** | `zarklord/nut-upsd`<br>`ghcr.io/zarklord/nut-upsd` | UPS drivers and `upsd` daemon to poll UPS devices via USB/Serial/Network. |
| **[nut-monitor](nut-monitor/README.md)** | `zarklord/nut-monitor`<br>`ghcr.io/zarklord/nut-monitor` | `upsmon` client that monitors UPS status and publishes state change events to MQTT. |
| **[nut-webui](nut-webui/README.md)** | `zarklord/nut-webui`<br>`ghcr.io/zarklord/nut-webui` | Web-based CGI dashboard to view real-time statistics and visual gauges for UPS status. |

---

## Architecture Overview

```
 [UPS Hardware] ──(USB/Serial)──> [ nut-upsd ] (Port 3493)
                                       │
                    ┌──────────────────┴──────────────────┐
                    ▼                                     ▼
             [ nut-monitor ]                        [ nut-webui ]
                    │                               (Web on Port 80)
                    ▼
             [ MQTT Broker ]
```

---

## Complete Docker Compose Example

The following `docker-compose.yml` runs the entire stack together:

```yaml
services:
  # 1. Hardware polling daemon
  nut-upsd:
    image: zarklord/nut-upsd:latest
    container_name: nut-upsd
    restart: unless-stopped
    privileged: true
    ports:
      - "3493:3493"
    environment:
      - UPS_APC=driver = usbhid-ups; port = auto; desc = 'Main UPS'
      - API_USER=monuser
      - API_PASSWORD=monsecret

  # 2. Status monitor & MQTT notifier
  nut-monitor:
    image: zarklord/nut-monitor:latest
    container_name: nut-monitor
    restart: unless-stopped
    depends_on:
      - nut-upsd
    environment:
      - MONITOR_1=APC@nut-upsd:3493 1 monuser monsecret secondary
      - MQTT_HOST=mosquitto
      - MQTT_PORT=1883
      - MQTT_USERNAME=mqttuser
      - MQTT_PASSWORD=mqttpassword

  # 3. Web dashboard
  nut-webui:
    image: zarklord/nut-webui:latest
    container_name: nut-webui
    restart: unless-stopped
    depends_on:
      - nut-upsd
    ports:
      - "8080:80"
    environment:
      - MONITOR_1=APC@nut-upsd:3493 "Main Rack UPS"
```

---

## Individual Projects

For detailed configuration options, refer to each project's documentation:
- [`nut-upsd` Documentation](nut-upsd/README.md)
- [`nut-monitor` Documentation](nut-monitor/README.md)
- [`nut-webui` Documentation](nut-webui/README.md)

## License

Simplified BSD License. See [LICENSE](LICENSE) for details.