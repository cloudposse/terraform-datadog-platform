variable "region" {
  type        = string
  description = "AWS region"
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API key"
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog App key"
}

variable "monitors_config_file" {
  type        = string
  description = "Path to the Datadog monitors configuration file"
}

variable "alert_tags" {
  type        = string
  description = "Space-separated string of alert tags to add to all alert messages, e.g. `@opsgenie` or `@opsgenie @devops`"
}

variable "monitor_tags" {
  type        = list(string)
  description = "A list of tags to associate with monitors. This can help you categorize and filter monitors in the Manage Monitors page of the Datadog UI"
}

variable "monitors_enabled" {
  type        = bool
  description = "Set to `false` to disable Datadog monitors provisioning (used for testing)"
}
