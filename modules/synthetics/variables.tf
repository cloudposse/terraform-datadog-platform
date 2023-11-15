# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/synthetics_test
variable "datadog_synthetics" {
  type        = any
  description = "Map of Datadog synthetic test configurations using Terraform or API schema. See README for details."
}

variable "default_tags_enabled" {
  type        = bool
  description = "If true, all tests will have tags from `null-label` added to them"
  default     = true
}

variable "alert_tags" {
  type        = list(string)
  description = "List of alert tags to add to all alert messages, e.g. `[\"@opsgenie\"]` or `[\"@devops\", \"@opsgenie\"]`"
  default     = []
}

variable "alert_tags_separator" {
  type        = string
  description = "Separator for the alert tags. All strings from the `alert_tags` variable will be joined into one string using the separator and then added to the alert message"
  default     = "\n"
}

variable "locations" {
  type        = list(string)
  description = <<-EOT
    Array of locations used to run synthetic tests, or `"all"` to use all public locations.
    These locations will be added to any locations specified in the `locations` attribute of a test.
    EOT
  default     = ["all"]
}

