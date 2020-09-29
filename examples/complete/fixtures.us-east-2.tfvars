enabled = true

region = "us-east-2"

namespace = "eg"

stage = "test"

name = "datadog-monitor"

datadog_api_key = "test"

datadog_app_key = "test"

monitors_enabled = false

monitors_config_file = "monitors.yaml"

alert_tags = "\n@opsgenie"

monitor_tags = ["ManagedBy:Terraform"]
