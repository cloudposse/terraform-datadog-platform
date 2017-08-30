variable "namespace" {}

variable "stage" {}

variable "name" {}

variable "delimiter" {
  default = "-"
}

variable "attributes" {
  type    = "list"
  default = []
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "datadog_api_key" {}

variable "datadog_app_key" {}

variable "alert_type" {
  default = "metric alert"
}

variable "alert_user" {}

variable "alert_message" {
  default = "Monitor triggered"
}

variable "alert_escalation_message" {
  default = "Escalation message"
}

variable "alert_escalation_user" {
  default = ""
}

variable "" {
  default = "false"
}

variable "ok_state_value" {
  default = "0"
}

variable "warning_state_value" {
  default = "1"
}

variable "critical_state_value" {
  default = "2"
}

variable "renotify_interval_mins" {
  default = "60"
}
