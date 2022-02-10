# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor
variable "datadog_monitors" {
  type = any
#    enabled                = bool
#    name                   = string
#    type                   = string
#    message                = string
#    escalation_message     = string
#    query                  = string
#    tags                   = map(string)
#    notify_no_data         = bool
#    new_group_delay        = number
#    evaluation_delay       = number
#    no_data_timeframe      = number
#    renotify_interval      = number
#    renotify_occurrences   = number
#    renotify_statuses      = set(string)
#    notify_audit           = bool
#    timeout_h              = number
#    enable_logs_sample     = bool
#    include_tags           = bool
#    require_full_window    = bool
#    locked                 = bool
#    force_delete           = bool
#    threshold_windows      = map(any)
#    thresholds             = map(any)
#    priority               = number
#    groupby_simple_monitor = bool
#    validate               = bool

    # TODO: deprecate in favor of new_group_delay once the options are fully clarified
    # See https://github.com/DataDog/terraform-provider-datadog/issues/1292
#    new_host_delay = number
#  }))
  description = "Map of Datadog monitor configurations. See catalog for examples"
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

variable "restricted_roles_map" {
  type        = map(set(string))
  description = "Map of monitors names to sets of Datadog roles to restrict access to each monitor"
  default     = {}
}
