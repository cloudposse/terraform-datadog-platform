variable "datadog_slos" {
  type = map(object({
    name = string
    type = string

    thresholds = list(object({
      target          = string
      timeframe       = string
      target_display  = string
      warning         = string
      warning_display = string
    }))

    query = map(any)

    groups      = list(string)
    monitor_ids = list(number)

    message      = string
    description  = string
    force_delete = bool
    validate     = bool

    tags = list(string)
  }))
  description = "Map of Datadog SLO configurations. See catalog for examples"
}

variable "alert_tags" {
  type        = list(string)
  description = "List of alert tags to add to all alert messages, e.g. `[\"@opsgenie\"]` or `[\"@devops\", \"@opsgenie\"]`"
  default     = null
}

variable "alert_tags_separator" {
  type        = string
  description = "Separator for the alert tags. All strings from the `alert_tags` variable will be joined into one string using the separator and then added to the alert message"
  default     = "\n"
}
