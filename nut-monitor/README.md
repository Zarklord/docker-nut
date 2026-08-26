# nut-monitor

This is the **nut-monitor** docker image, which implements the `upsmon` daemon from [Network UPS Tools (NUT)](https://networkupstools.org/) and forwards UPS status events to an MQTT broker.

## How to Use

Pull the image:

```bash
docker pull zarklord/nut-monitor:latest
```

### Environment Variables

| Variable | Default | Description |
| :--- | :--- | :--- |
| `MONITOR_<NAME>` | *(none)* | UPS monitoring definition: `"<upsname>@<host>[:<port>] <powervalue> <username> <password> <type>"` |
| `MINSUPPLIES` | `0` | Minimum number of power supplies required |
| `MQTT_HOST` | *(none)* | MQTT broker hostname / IP (optional, events skipped if unset) |
| `MQTT_PORT` | `1883` | MQTT broker port |
| `MQTT_USERNAME` | *(none)* | MQTT broker username (optional) |
| `MQTT_PASSWORD` | *(none)* | MQTT broker password (optional) |
| `USER` | `nut` | Run-as user inside container |
| `GROUP` | `nut` | Run-as group inside container |

### Running with Docker CLI

```bash
docker run -d \
  --name nut-monitor \
  -e MONITOR_1="myups@nut-upsd:3493 1 monuser monpassword secondary" \
  -e MQTT_HOST="mqtt.local" \
  -e MQTT_PORT="1883" \
  -e MQTT_USERNAME="mqttuser" \
  -e MQTT_PASSWORD="secretpassword" \
  zarklord/nut-monitor:latest
```

### Running with Docker Compose

```yaml
services:
  nut-monitor:
    image: zarklord/nut-monitor:latest
    container_name: nut-monitor
    restart: unless-stopped
    environment:
      - MONITOR_1=myups@nut-upsd:3493 1 monuser monpassword secondary
      - MQTT_HOST=mosquitto
      - MQTT_PORT=1883
      - MQTT_USERNAME=nut
      - MQTT_PASSWORD=nutsecret
```

### MQTT Notifications

When UPS events occur, messages are published to the topic:
`ups/<UPSNAME>/notify`

Payloads match standard NUT notify event types:
- `ONLINE`: UPS is back online on mains power
- `ONBATT`: UPS is running on battery power
- `LOWBATT`: Battery level is low (critical)
- `FSD`: Forced shutdown in progress
- `COMMOK`: Communications established
- `COMMBAD`: Communications lost
- `SHUTDOWN`: System shutdown initiated
- `REPLBATT`: Battery replacement required
- `NOCOMM`: UPS is unavailable
