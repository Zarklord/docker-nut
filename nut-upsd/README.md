# nut-upsd

This is the **nut-upsd** docker image, which implements the UPS drivers and the `upsd` daemon from [Network UPS Tools (NUT)](https://networkupstools.org/).

This container supports monitoring one or more UPS devices simultaneously via USB, serial, or network drivers.

## How to Use

Pull the image:

```bash
docker pull zarklord/nut-upsd:latest
```

## Configuration

You can configure `nut-upsd` in one of two ways:

### Option 1: Environment Variables (Recommended for Simple Setups)

You can define UPS devices directly via environment variables:

| Variable | Description |
| :--- | :--- |
| `UPS_<NAME>` | Semicolon-separated driver configuration for the UPS device. |
| `API_USER` | Username for API / monitor client authentication (optional). |
| `API_PASSWORD` | Password for API / monitor client authentication (optional). |

**Example:**

```bash
docker run -d \
  --name nut-upsd \
  -p 3493:3493 \
  --privileged \
  -e UPS_MYUPS="driver = usbhid-ups; port = auto; desc = 'My APC UPS'" \
  -e API_USER="monuser" \
  -e API_PASSWORD="monpassword" \
  zarklord/nut-upsd:latest
```

### Option 2: Config Volume Mount (Advanced Setups)

For advanced multi-UPS configurations, mount your custom `ups.conf` into `/etc/nut/ups.conf`:

```bash
docker run -d \
  --name nut-upsd \
  -p 3493:3493 \
  -v /path/to/ups.conf:/etc/nut/ups.conf:ro \
  --privileged \
  zarklord/nut-upsd:latest
```

**Example `ups.conf`:**

```ini
pollinterval = 1
maxretry = 3

[myups]
    driver = usbhid-ups
    port = auto
    desc = "Primary Rack UPS"
```

## Device Mapping

In order for UPS drivers to communicate with your hardware, the USB or serial device must be accessible inside the container.

### Option A: Privileged Mode (Simplest)

Pass `--privileged` to the container:

```bash
docker run -d --privileged -p 3493:3493 ... zarklord/nut-upsd:latest
```

### Option B: Specific Device Mapping (More Secure)

Identify your UPS USB device using `lsusb`:

```bash
$ lsusb
Bus 005 Device 002: ID 051d:0002 American Power Conversion Uninterruptible Power Supply
```

Find the major and minor device numbers:

```bash
$ ls -l /dev/bus/usb/005/002
crw-rw-r-- 1 root root 189, 513 Aug 26 10:00 /dev/bus/usb/005/002
```

Pass the device path and cgroup rule into docker:

```bash
docker run -d \
  -p 3493:3493 \
  --device /dev/bus/usb/005/002 \
  --device-cgroup-rule='c 189:513 rw' \
  -e UPS_MYUPS="driver = usbhid-ups; port = auto; desc = 'APC UPS'" \
  zarklord/nut-upsd:latest
```

## Docker Compose Example

```yaml
services:
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
      - API_PASSWORD=monpassword
```
