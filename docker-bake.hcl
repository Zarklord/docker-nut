group "ci_targets" {
  targets = ["nut-monitor", "nut-upsd", "nut-webui"]
}
target "ci_platforms" {
	platforms = ["linux/amd64", "linux/arm64"]
}

target "docker-metadata-action" {}

group "default" {
  targets = ["nut-monitor", "nut-upsd", "nut-webui"]
}

target "nut-monitor-local" {
  tags = ["nut-monitor:local"]
}

target "nut-monitor" {
	inherits = ["nut-monitor-local", "ci_platforms", "docker-metadata-action"]
	context = "./"
	dockerfile = "Dockerfile"
}

target "nut-upsd-local" {
  tags = ["nut-upsd:local"]
}

target "nut-upsd" {
	inherits = ["nut-upsd-local", "ci_platforms", "docker-metadata-action"]
	context = "./"
	dockerfile = "Dockerfile"
}

target "nut-webui-local" {
  tags = ["nut-webui:local"]
}

target "nut-webui" {
	inherits = ["nut-webui-local", "ci_platforms", "docker-metadata-action"]
	context = "./"
	dockerfile = "Dockerfile"
}