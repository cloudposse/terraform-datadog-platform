enabled = true

region = "us-east-2"

namespace = "eg"

stage = "test"

name = "datadog-monitor"

alert_tags = ["@opsgenie"]

alert_tags_separator = "\n"

monitor_paths = ["../../catalog/monitors/*.yaml"]

synthetic_paths = ["synthetics/*.yaml"]

# Note that creating and modifying custom roles is an opt-in Enterprise feature. Contact Datadog support to get it enabled for your account
# https://docs.datadoghq.com/account_management/rbac/?tab=datadogapplication
custom_rbac_enabled = false
