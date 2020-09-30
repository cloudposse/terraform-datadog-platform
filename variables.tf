# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor
variable "datadog_monitors" {
  type = list(object({
    name                = string
    type                = string
    message             = string
    escalation_message  = string
    query               = string
    tags                = list(string)
    notify_no_data      = bool
    new_host_delay      = number
    evaluation_delay    = number
    no_data_timeframe   = number
    renotify_interval   = number
    notify_audit        = bool
    timeout_h           = number
    enable_logs_sample  = bool
    include_tags        = bool
    require_full_window = bool
    locked              = bool
    force_delete        = bool
    threshold_windows   = map(any)
    thresholds          = map(any)
  }))
  description = "List of Datadog monitor configurations"
}

variable "alert_tags" {
  type        = string
  description = "Space-separated string of alert tags to add to all alert messages, e.g. `@opsgenie` or `@devops`"
  default     = null
}
