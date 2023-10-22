namespace = "eg"

stage = "test"

name = "datadog-synthetics"

alert_tags = ["@opsgenie"]

alert_tags_separator = "\n"

terraform_synthetic_paths = ["catalog/terraform-schema/*.yaml"]
api_synthetic_paths       = ["catalog/api-schema/*.yaml"]
