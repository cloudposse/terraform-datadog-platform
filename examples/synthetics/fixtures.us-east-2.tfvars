namespace = "eg"

stage = "test"

name = "datadog-synthetics"

alert_tags = ["@opsgenie"]

alert_tags_separator = "\n"

synthetic_paths = ["catalog/terraform-schema/*.yaml", "catalog/api-schema/*.yaml"]
