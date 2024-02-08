namespace = "eg"

stage = "test"

name = "datadog-monitor"

alert_tags = ["@opsgenie"]

alert_tags_separator = "\n"

legacy_monitor_paths = ["./monitors-test/*.yaml"]

json_monitor_paths = ["./monitors-test/*.json"]
