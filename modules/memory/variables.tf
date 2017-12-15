variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = "string"
  description = "Application or solution name (e.g. `app`)"
}

variable "delimiter" {
  type        = "string"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, 'attributes`"
  default     = "-"
}

variable "attributes" {
  description = "Additional attributes (e.g. `policy` or `role`)"
  type        = "list"
  default     = []
}

variable "tags" {
  description = "Additional tags (e.g. map('BusinessUnit','XYZ')"
  type        = "map"
  default     = {}
}

variable "datadog_api_key" {
  type        = "string"
  description = "Datadog API key. This can also be set via the DATADOG_API_KEY environment variable"
  default     = ""
}

variable "datadog_app_key" {
  type        = "string"
  description = "Datadog APP key. This can also be set via the DATADOG_APP_KEY environment variable"
  default     = ""
}

variable "monitor_enabled" {
  type        = "string"
  description = "State of monitor"
  default     = "true"
}

variable "monitor_silenced" {
  type        = "string"
  description = "Each scope will be muted until the given POSIX timestamp or forever if the value is 0"
  default     = "1"
}

variable "alert_type" {
  type        = "string"
  description = "The type of the monitor (e.g. metric alert, service check, event alert, query alert)"
  default     = "metric alert"
}

variable "notify_no_data" {
  type        = "string"
  description = "A boolean indicating whether this monitor will notify when data stops reporting"
  default     = "false"
}

variable "new_host_delay" {
  type        = "string"
  description = "Time (in seconds) to allow a host to boot and applications to fully start before starting the evaluation of monitor results"
  default     = "300"
}

variable "renotify_interval" {
  type        = "string"
  description = "The number of minutes after the last notification before a monitor will re-notify on the current status. It will only re-notify if it's not resolved"
  default     = "60"
}

variable "period" {
  type        = "string"
  description = "Monitoring period in minutes"
  default     = "10m"
}

variable "ok_threshold" {
  type        = "string"
  description = "Memory usage OK threshold in bytes"
  default     = "104857600"
}

variable "warning_threshold" {
  type        = "string"
  description = "Memory usage warning threshold in bytes"
  default     = "54857600"
}

variable "critical_threshold" {
  type        = "string"
  description = "Memory usage critical threshold in bytes"
  default     = "24857600"
}

variable "datadog_monitor_tags" {
  description = "Configurable labels that can be applied to monitor"
  type        = "list"
  default     = ["system", "memory"]
}

variable "selector" {
  description = "Selector for enabling monitor for specific hosts, host tags"
  type        = "list"
  default     = ["*"]
}

variable "notify" {
  type        = "string"
  description = "Notification email, hipchat or slack user/channel"
  default     = ""
}

variable "escalation_notify" {
  type        = "string"
  description = "Escalation notification email, hipchat or slack user/channel"
  default     = ""
}

variable "group_by" {
  type        = "string"
  description = "Group By"
  default     = "{host}"
}

variable "remediation" {
  type        = "string"
  description = "URL to internal documentation for instructions as to how to remediate"
  default     = ""
}
