# https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor
variable "datadog_monitors" {
  # We use `any` type here because the `datadog_monitors` map can have multiple configurations
  # and it is too complex to model all possible configurations in the type system.
  type        = any
  description = <<-EOT
    Map of Datadog monitor configurations. See the README for details on the expected structure.
    Keys will be used as monitor names if not provided in the `name` attribute.
    Attributes match [Datadog "Create a monitor" API](https://docs.datadoghq.com/api/v1/monitors/#create-a-monitor).
    For backward compatibility, attributes under `options` in the API schema that were
    previously allowed at the top level remain available at the top level if no `options` are provided.
    Because `new_host_delay` is deprecated, it is ignored unless set to zero.
    EOT
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
  description = <<-EOT
    Map of `datadog_monitors` map keys to sets of Datadog unique role IDs
    to restrict access to each monitor. If provided, it will override
    the `restricted_roles` attribute in the monitor definition.
    EOT
  default     = {}
}

variable "default_tags_enabled" {
  type        = bool
  description = <<-EOT
    If true, monitors without `tags` in their definitions will have tags
    from `null-label` added to them. Note that even an empty `list` or `map` of tags in
    the monitor definition will keep the default tags from being added.
    EOT
  default     = true
}
