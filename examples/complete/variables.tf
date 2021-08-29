variable "region" {
  type        = string
  description = "AWS region"
}

variable "alert_tags" {
  type        = list(string)
  description = "List of alert tags to add to all alert messages, e.g. `[\"@opsgenie\"]` or `[\"@devops\", \"@opsgenie\"]`"
}

variable "alert_tags_separator" {
  type        = string
  description = "Separator for the alert tags. All strings from the `alert_tags` variable will be joined into one string using the separator and then added to the alert message"
}

variable "monitor_paths" {
  type        = list(string)
  description = "List of paths to Datadog monitor configurations"
}

variable "synthetic_paths" {
  type        = list(string)
  description = "List of paths to Datadog synthetic configurations"
}

# https://docs.datadoghq.com/account_management/rbac/?tab=datadogapplication
variable "custom_rbac_enabled" {
  type        = bool
  description = "Flag to enable/disable custom RBAC. Note that creating and modifying custom roles is an opt-in Enterprise feature. Contact Datadog support to get it enabled for your account"
  default     = false
}
