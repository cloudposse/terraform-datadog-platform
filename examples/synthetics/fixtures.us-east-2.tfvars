enabled = true

region = "us-east-2"

namespace = "eg"

stage = "test"

name = "datadog-synthetics"

alert_tags = ["@opsgenie"]

alert_tags_separator = "\n"

synthetic_paths = ["synthetics/*.yaml"]
