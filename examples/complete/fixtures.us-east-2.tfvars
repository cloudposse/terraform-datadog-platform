region = "us-east-2"

namespace = "eg"

stage = "test"

name = "datadog-monitor"

alert_tags = ["@opsgenie"]

alert_tags_separator = "\n"

monitor_paths   = ["../../catalog/monitors/*.yaml"]
synthetic_paths = ["../../catalog/monitors/*.yaml"]
slo_paths       = ["../../catalog/monitors/*.yaml"]
